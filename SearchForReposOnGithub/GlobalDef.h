//
//  GlobalDef.h
//  SearchForReposOnGithub
//
//  Created by WsdlDev on 17/1/11.
//  Copyright © 2017年 jcYang. All rights reserved.
//

#ifndef GlobalDef_h
#define GlobalDef_h

/////******////network excute block
typedef void(^RESULTBLOCK)(id result);
typedef void(^ERRORBLOCK)(id error);
typedef void(^FAILUREBLOCK)(id failMsg);

////******/////network reachable notification name
#define NETWORKING_REACHABLED_NOTIFICATION @"reachableNotification"
#define NETWORKING_UN_REACHABLED_NOTIFICATION @"un_reachableNotification"

////******////search repos base url
#define SEARCH_REPOS_BASE_URL @"https://api.github.com/search/repositories"
#define SEARCH_REPOS_KEY @"q"
#define SEARCH_REPOS_SORT_KEY @"sort"
#define SEARCH_REPOS_ORDER_KEY @"order"


#endif /* GlobalDef_h */
