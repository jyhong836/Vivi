//
//  VIConnectionDelegate.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VSClientController;

@protocol VSClientDelegate <NSObject>

- (void)clientDidConnect: (id<VSClientController>)clientController;

@end
