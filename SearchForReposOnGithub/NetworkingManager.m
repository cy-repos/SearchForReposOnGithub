//
//  NetworkingManager.m
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#import "NetworkingManager.h"

@interface NetworkingManager (){
    AFHTTPSessionManager *httpManager;
    NSLock *requestLock;
    NSInteger requestToken;
}

@end

@implementation NetworkingManager

+(instancetype)defaultNetworkingManager{
    static NetworkingManager *defaultManager =nil;
    if (!defaultManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultManager =[[NetworkingManager alloc] init];
        });
    }
    return defaultManager;
}

-(id)init{
    self =[super init];
    if (self) {
        [self checkForNetworkingReachabled];
        [self initHttpManager];
    }
    return self;
}

-(void)dealloc{
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initHttpManager{
    httpManager =[[AFHTTPSessionManager alloc] init];
    httpManager.requestSerializer.timeoutInterval =6;
    //
    requestLock =[[NSLock alloc] init];
    requestToken =0;
}

//监测网络
-(void)checkForNetworkingReachabled{
    AFNetworkReachabilityManager *reachableManager =[AFNetworkReachabilityManager sharedManager];
    [reachableManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                case AFNetworkReachabilityStatusNotReachable:
                [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKING_UN_REACHABLED_NOTIFICATION object:nil];
                break;
                
            default:
                [[NSNotificationCenter defaultCenter] postNotificationName:NETWORKING_REACHABLED_NOTIFICATION object:nil];
                break;
        }
    }];
    [reachableManager startMonitoring];
}

//get 方法
-(void)requestDataByGET:(NSString*)urlStr parmeterDict:(NSDictionary*)dict resultBlock:(RESULTBLOCK)resultBlock errorBlock:(ERRORBLOCK)errorBlock{
    AFNetworkReachabilityManager *reachableManager =[AFNetworkReachabilityManager sharedManager];
    if (!reachableManager.reachable) {//网络无效
        NSError *error =[NSError errorWithDomain:@"unreachable networking status" code:1001 userInfo:nil];
        if (errorBlock) {
            errorBlock(error);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [requestLock lock];
        while (requestToken>0) {
            [NSThread sleepForTimeInterval:0.2];
        }
        //执行
        [httpManager GET:urlStr parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            requestToken =0;
            if (resultBlock) {
                resultBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            requestToken =0;
            if (errorBlock) {
                errorBlock(error);
            }
        }];
        [requestLock unlock];
    });
    
}
//post 方法
-(void)requestDataByPost:(NSString*)urlStr parmeterDict:(NSDictionary*)dict resultBlock:(RESULTBLOCK)resultBlock errorBlock:(ERRORBLOCK)errorBlock {
    
}


@end
