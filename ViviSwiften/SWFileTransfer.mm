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

using namespace Swift;

@implementation SWFileTransfer {
    SWFileTransferAdapter *adapter;
}

@synthesize delegate;
@synthesize filepath;

- (id)initWithFileTransfer: (FileTransfer::ref)ft
{
    if (self = [super init]) {
        fileTransfer = ft;
        adapter = new SWFileTransferAdapter(fileTransfer, self);
        filepath = std_str2NSString(ft->getFileName());
    }
    return self;
}

- (id)initWithFileTransfer: (FileTransfer::ref)ft
                  filepath: (NSString*)aFilepath
{
    if (self = [super init]) {
        fileTransfer = ft;
        adapter = new SWFileTransferAdapter(fileTransfer, self);
        filepath = aFilepath;
    }
    return self;
}

- (void)dealloc
{
    delete adapter;
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

@end
