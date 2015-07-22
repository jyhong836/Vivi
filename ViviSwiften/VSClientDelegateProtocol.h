//
//  fuck.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import "SWClientAdapter.h"
//@class SWClientAdapter;

@protocol VSClientDelegate <NSObject>

//@optional
- (void)clientDidConnect: (SWClientAdapter*)client;
//@optional
- (void)clientDidReceiveMessage: (SWClientAdapter*)client
                    fromAccount: (NSString*)account
                      inContent: (NSString*)content;

@end
