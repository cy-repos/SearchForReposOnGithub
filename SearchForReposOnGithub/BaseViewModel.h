//
//  BaseViewModel.h
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewModel : NSObject
//set public network excute block
@property (nonatomic,strong) RESULTBLOCK mResultBlock;
@property (nonatomic,strong) ERRORBLOCK mErrorBlock;

//init
-(id)initWithResultBlock:(RESULTBLOCK)block0 errorBlock:(ERRORBLOCK)block1;
@end
