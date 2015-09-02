//
//  SWOutgoingFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWOutgoingFileTransfer.h"

#import <Swiften/FileTransfer/OutgoingFileTransfer.h>

using namespace Swift;

@implementation SWOutgoingFileTransfer

- (void)start
{
    boost::dynamic_pointer_cast<OutgoingFileTransfer>(fileTransfer)->start();
}

@end
