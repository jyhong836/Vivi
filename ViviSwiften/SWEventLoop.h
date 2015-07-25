//
//  SWEventLoop.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifdef __cplusplus
namespace Swift{
class BoostNetworkFactories;
}
#endif

/*!
 * @brief SWEventLoop wraps the functions of SimpleEventLoop and BoostNetworkFactories.
 */
@interface SWEventLoop : NSObject
- (id)init;
- (void)start;
- (void)stop;
@property (readonly, nonatomic)BOOL isStarted;
#ifdef __cplusplus
- (Swift::BoostNetworkFactories *)getNetworkFactories;
#else
- (void *)getNetworkFactories;
#endif
- (void)dealloc;
@end
