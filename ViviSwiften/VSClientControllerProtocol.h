//
//  VIClientControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSControllerProtocol.h"
#import "VSClientDelegate.h"

@protocol VSClientController <NSObject, VSController>

@property (nonatomic, weak) id<VSClientDelegate> clientDelegate;
@property (nonatomic) NSString* accountName;
@property (nonatomic) NSString* accountPasswd;

@end
