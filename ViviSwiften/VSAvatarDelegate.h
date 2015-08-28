//
//  VSAvatarDelegate.h
//  Vivi
//
//  Created by Junyuan Hong on 8/28/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VSAvatarDelegate <NSObject>

//@optional
- (void)account: (SWAccount*)account
didChangeAvatar: (NSData*)avatarData;

@end
