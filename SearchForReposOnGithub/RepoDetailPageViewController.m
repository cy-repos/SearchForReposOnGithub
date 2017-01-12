//
//  RepoDetailPageViewController.m
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "RepoDetailPageViewController.h"

@interface RepoDetailPageViewController (){
    UIWebView *mWebView;
}

@end

@implementation RepoDetailPageViewController

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
    self.navigationItem.title =@"Repo Detail";
    //
    [self initWebView];
}

-(void)initWebView{
    mWebView =[[UIWebView alloc] init];
    [self.view addSubview:mWebView];
    //
    if (_htmlURL) {
        NSURLRequest *request =[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_htmlURL]];
        [mWebView loadRequest:request];
    }
}

#pragma ----view 
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    //
    [self layoutSubView];
}

-(void)layoutSubView{
    mWebView.frame =self.view.bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
