//
//  VIControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VSController <NSObject>
- (void)controllerDidLoad;
- (void)controllerWillClose;
@end
