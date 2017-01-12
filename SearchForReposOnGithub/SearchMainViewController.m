//
//  SearchMainViewController.m
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/10.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "SearchMainViewController.h"
#import "RepoViewModel.h"
#import "RepoModel.h"
#import "RepoTableViewCell.h"
#import "NetworkingManager.h"
#import "MJRefresh.h"

#define DefaultRepoCellHeight 60
#define DefaultRepoSectionHeight 30


@interface SearchMainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    NSMutableArray <RepoModel*> *reposArray;
    RepoViewModel * repoViewModel;
}

@end

@implementation SearchMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setup{
    //init model view
    [self initRepoViewModel];
    //init table view
    [self initTableView];
    //init networking for enable reacheable
    [NetworkingManager defaultNetworkingManager];
    //init other
    [self initOther];
}

-(void)initTableView{
    _mSearchResultTableView.dataSource =self;
    _mSearchResultTableView.delegate =self;
    //
    MJRefreshAutoStateFooter *footer =[MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        [repoViewModel searchNext];
        _mSearchResultTableView.mj_footer.state =MJRefreshStateIdle;
    }];
    [footer setTitle:@"pull for loading more" forState:MJRefreshStateIdle];
    [footer setTitle:@"loading more..." forState:MJRefreshStateRefreshing];
    _mSearchResultTableView.mj_footer =footer;
}

-(void)initRepoViewModel{
    repoViewModel =[[RepoViewModel alloc] initWithResultBlock:^(id result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            NSInteger count =[(NSArray*)result count];
            if (count==0) {
                return ;
            }
            NSInteger index =reposArray.count;
            [reposArray addObjectsFromArray:result];
            //
            NSMutableArray *indexArray =[NSMutableArray arrayWithCapacity:1];
            for (NSInteger i=0; i<count; i++) {
                [indexArray addObject:[NSIndexPath indexPathForRow:index+i inSection:0]];
            }
            if (index==0) {
                [_mSearchResultTableView reloadData];
            }else{
                [_mSearchResultTableView beginUpdates];
                [_mSearchResultTableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
                [_mSearchResultTableView endUpdates];
            }
        });
        
    } errorBlock:^(id error) {
        
    }];
}

-(void)initOther{
    reposArray =[NSMutableArray arrayWithCapacity:1];
    _mSearchBar.delegate =self;
    //avoid cover by nav bar
    float ver =[[[UIDevice currentDevice] systemVersion] floatValue];
    if(ver>=7.0)
    {
        self.edgesForExtendedLayout =UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //
    self.navigationItem.title =@"Search Repo";
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma ---tableview_datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return reposArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify =@"repoCell";
    RepoTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        UINib *nib =[UINib nibWithNibName:@"RepoTableViewCell" bundle:nil];
        cell =[nib instantiateWithOwner:nil
                                options:nil].firstObject;
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentify];
    }
    //
    RepoModel *model =reposArray[indexPath.row];
    [cell setRepoModel:model];
    return cell;
}

//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSString *str =[NSString stringWithFormat:@"total %ld",reposArray.count>0?reposArray.firstObject.totalNum:0];
//    return str;
//}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[UIView new];
    UILabel *totalNumLabel =[UILabel new];
    NSString *str =[NSString stringWithFormat:@"TOTAL NUM %ld",reposArray.count>0?reposArray.firstObject.totalNum:0];
    totalNumLabel.text =str;
    totalNumLabel.font =[UIFont systemFontOfSize:14];
    totalNumLabel.frame =CGRectMake(8, 0, [UIScreen mainScreen].bounds.size.width-8, DefaultRepoSectionHeight);
    [view addSubview:totalNumLabel];
    return view;
}

#pragma ---tableview_delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return DefaultRepoCellHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return DefaultRepoSectionHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RepoModel *model =reposArray[indexPath.row];
    [repoViewModel actionForPushRepoDetailPage:model viewController:self];
}


#pragma ---search bar delegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_mSearchBar resignFirstResponder];
}

-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    static NSDate *lastDate =nil;
    if (lastDate) {
        NSTimeInterval interval =[[NSDate date] timeIntervalSinceDate:lastDate];
        if (interval>2.0) {//频繁操作会导致服务器拒绝访问，所以在这里设置每次访问间隔为2s
            if (searchText.length>0) {
                [self startSearch:searchText];
            }
            lastDate =[NSDate date];
        }
    }else{
        lastDate =[NSDate date];
        if (searchText.length>0) {
            [self startSearch:searchText];
        }
    }
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (searchBar.text.length>0) {
        [self startSearch:searchBar.text];
    }
}

-(void)startSearch:(NSString*)text{
    [reposArray removeAllObjects];
    [_mSearchResultTableView reloadData];
    //
    if (![repoViewModel.searchKeyWord isEqualToString:text]) {
        [repoViewModel startSearchRepos:text];
    }
}
@end
