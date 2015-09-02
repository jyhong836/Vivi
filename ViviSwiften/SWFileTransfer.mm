//
//  SWOutgoingFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 9/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransfer.h"
#import "VSFileTransferDelegate.h"
#import "SWFileTransferAdapter.h"

#import <Swiften/FileTransfer/FileTransfer.h>
#import <Swiften/FileTransfer/OutgoingFileTransfer.h>

using namespace Swift;

@implementation SWFileTransfer {
    FileTransfer::ref fileTransfer;
    SWFileTransferAdapter::ref adapter;
}

@synthesize delegate;

- (id)initWithFileTransfer: (FileTransfer::ref)ft
{
    if (self = [super init]) {
        fileTransfer = ft;
        adapter = boost::shared_ptr<SWFileTransferAdapter>(new SWFileTransferAdapter(fileTransfer, self));
    }
    return self;
}

- (void)dealloc
{
}

- (NSString*)filename
{
    return std_str2NSString(fileTransfer->getFileName());
}

- (unsigned long)fileSizeInBytes
{
    return (unsigned long)fileTransfer->getFileSizeInBytes();
}

- (void)cancel
{
    fileTransfer->cancel();
}

- (void)start
{
    boost::dynamic_pointer_cast<OutgoingFileTransfer>(fileTransfer)->start();
}

@end
