//
//  RepoViewModel.m
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "RepoViewModel.h"
#import "NetworkingManager.h"
#import "RepoModel.h"
#import "RepoDetailPageViewController.h"


@implementation RepoViewModel

-(void)startSearchRepos:(NSString*)keyword{
    @synchronized (self) {
        _curPage  =1;
        _searchKeyWord =keyword;
    }
    [self searchRepos:_searchKeyWord page:_curPage];
}
-(void)searchNext{
    if (_searchKeyWord) {
        [self searchRepos:_searchKeyWord page:_curPage];
    }
}

-(void)searchRepos:(NSString*)keywork page:(NSInteger)page{
    NSDictionary *paramDict =@{SEARCH_REPOS_KEY:keywork,SEARCH_REPOS_SORT_KEY:@"stars",SEARCH_REPOS_ORDER_KEY:@"desc",@"per_page":@(10),@"page":@(page)};
    NetworkingManager *manager =[NetworkingManager defaultNetworkingManager];
    NSLog(@"page=======%ld",_curPage);
    [manager requestDataByGET:SEARCH_REPOS_BASE_URL parmeterDict:paramDict resultBlock:^(id result) {
        //
        @synchronized (self) {
            _curPage++;
        }
        //
        [self translateJSON2Model:result];
    } errorBlock:^(id error) {
        if (self.mErrorBlock) {
            self.mErrorBlock(error);
        }
    }];
}

-(void)translateJSON2Model:(NSDictionary*)jsonResp{
    if (jsonResp) {
        NSInteger totalNum =jsonResp[@"total_count"]?[jsonResp[@"total_count"] integerValue]:0;
        NSArray *items =jsonResp[@"items"];
        if (items) {
            NSMutableArray *resultArray =[NSMutableArray arrayWithCapacity:1];
            [items enumerateObjectsUsingBlock:^(NSDictionary* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                RepoModel *model =[RepoModel new];
                model.totalNum =totalNum;
                model.name =obj[@"name"];
                model.fulleName =obj[@"full_name"];
                model.htmlURL =obj[@"html_url"];
                model.owerName =obj[@"owner"][@"login"];
                [resultArray addObject:model];
            }];
            //
            if (self.mResultBlock) {
                self.mResultBlock(resultArray);
            }
        }
    }
}

-(void)actionForPushRepoDetailPage:(RepoModel*)model viewController:(UIViewController*)controller{
    RepoDetailPageViewController *controller0 =[[RepoDetailPageViewController alloc] init];
    controller0.htmlURL =model.htmlURL;
    [controller.navigationController pushViewController:controller0 animated:YES];
    //[controller presentViewController:controller0 animated:YES completion:nil];
}

@end
