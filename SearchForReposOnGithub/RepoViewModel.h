//
//  RepoViewModel.h
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "BaseViewModel.h"

@class RepoModel;

@interface RepoViewModel : BaseViewModel

@property (nonatomic,assign) NSInteger curPage;

@property (nonatomic,strong) NSString *searchKeyWord;

//search repos
-(void)startSearchRepos:(NSString*)keyword;
-(void)searchNext;

//action for pushing to repo detal page
-(void)actionForPushRepoDetailPage:(RepoModel*)model viewController:(UIViewController*)controller;
@end
