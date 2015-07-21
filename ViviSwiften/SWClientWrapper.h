//
//  SWClientAdapter.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO change name to Adapter
@interface SWClientWrapper : NSObject
- (id)init;
- (void)dealloc;
- (void)run;
- (void)connect;

@end
