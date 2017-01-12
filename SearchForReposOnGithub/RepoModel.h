//
//  RepoModel.h
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RepoModel : NSObject

@property (nonatomic,assign) NSInteger totalNum;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *fulleName;

@property (nonatomic,strong) NSString *owerName;

@property (nonatomic,strong) NSString *htmlURL;

@end
