//
//  SWEventLoop.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
namespace Swift{
class BoostNetworkFactories;
}
#endif

/*!
 * @brief SWEventLoop include the functions of SimpleEventLoop and BoostNetworkFactories.
 */
@interface SWEventLoop : NSObject
- (id)init;
- (void)start;
#ifdef __cplusplus
- (Swift::BoostNetworkFactories *)getNetworkFactories;
#else
- (void *)getNetworkFactories;
#endif
- (void)dealloc;
@end
