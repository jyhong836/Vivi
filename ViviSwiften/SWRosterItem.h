//
//  SWRosterItem.h
//  Vivi
//
//  Created by Junyuan Hong on 8/17/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef __cplusplus
namespace Swift {
    class XMPPRosterItem;
};
#endif
@class SWAccount;

@interface SWRosterItem : NSObject

#ifdef __cplusplus
- (id)initWithRosterItem: (Swift::XMPPRosterItem*)item;
#else
- (id)initWithRosterItem: (void*)item;
#endif

@property (nonatomic)NSString* name;
@property (nonatomic)SWAccount* account;
@property (nonatomic)NSMutableArray<NSString*>* groups;

@end
