//
//  BaseViewModel.m
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

//init
-(id)initWithResultBlock:(RESULTBLOCK)block0 errorBlock:(ERRORBLOCK)block1{
    self =[super init];
    if (self) {
        self.mResultBlock =block0;
        self.mErrorBlock =block1;
    }
    return self;
}
@end
