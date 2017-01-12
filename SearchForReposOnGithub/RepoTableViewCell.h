//
//  RepoTableViewCell.h
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RepoModel;

@interface RepoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mStarLabel;

-(void)setRepoModel:(RepoModel*)model;

@end
