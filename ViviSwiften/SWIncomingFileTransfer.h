//
//  SWIncomingFileTransfer.h
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransfer.h"

@class SWAccount;

@interface SWIncomingFileTransfer : SWFileTransfer

- (void)acceptAsFile: (NSString*)file;

@property (nonatomic, readonly)SWAccount* sender;
@property (nonatomic, readonly)SWAccount* recipient;

@end
