//
//  VIControllerProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@protocol VSController <NSObject>
@required
- (void)controllerDidLoad;
@required
- (void)controllerWillClose;
@end
