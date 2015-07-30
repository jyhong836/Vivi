//
//  SWXMPPRoster.h
//  Vivi
//
//  Created by Junyuan Hong on 7/30/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
namespace Swift {
    class XMPPRoster;
}
#endif

@protocol VSXMPPRosterDelegate;

@interface SWXMPPRoster : NSObject

@property (weak, nonatomic) id<VSXMPPRosterDelegate> delegate;

#ifdef __cplusplus
- (id)init: (Swift::XMPPRoster*)aRoster;
#else
- (id)init: (void*)roster;
#endif

- (void)getItems;

@end
