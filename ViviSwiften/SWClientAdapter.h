//
//  SWClientAdapter.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO change name to Adapter
/*!
 * @brief A Objective-C adapter for Swiften.
 */
@interface SWClientAdapter : NSObject
- (id)init;
- (void)dealloc;

- (void)run;
- (void)runBackgroud;
- (void)connect;

@end
