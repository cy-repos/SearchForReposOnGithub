//
//  RepoTableViewCell.m
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "RepoTableViewCell.h"
#import "RepoModel.h"

@implementation RepoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRepoModel:(RepoModel*)model{
    _mNameLabel.text =model.name;
    _mFullNameLabel.text =model.fulleName;
    _mStarLabel.text =model.owerName;
}

@end
