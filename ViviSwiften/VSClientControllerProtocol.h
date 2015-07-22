//
//  VIClientControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSControllerProtocol.h"
#import "VSClientDelegateProtocol.h"
#import "SWClientAdapter.h"
#import "SWEventLoop.h"

@protocol VSClientController <NSObject, VSController>

@property (nonatomic) id<VSClientDelegate> clientDelegate;
@property (nonatomic) NSString* accountName;
@property (nonatomic) NSString* accountPasswd;
@property (nonatomic) SWClientAdapter* client;
@property (nonatomic) SWEventLoop* eventLoop;

@end
