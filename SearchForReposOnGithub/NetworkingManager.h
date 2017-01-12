//
//  NetworkingManager.h
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkingManager : NSObject

+(instancetype)defaultNetworkingManager;

//get 方法
-(void)requestDataByGET:(NSString*)urlStr parmeterDict:(NSDictionary*)dict resultBlock:(RESULTBLOCK)resultBlock errorBlock:(ERRORBLOCK)errorBlock ;
//post 方法
-(void)requestDataByPost:(NSString*)urlStr parmeterDict:(NSDictionary*)dict resultBlock:(RESULTBLOCK)resultBlock errorBlock:(ERRORBLOCK)errorBlock;
@end
