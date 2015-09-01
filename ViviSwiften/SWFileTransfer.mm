//
//  SWOutgoingFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 9/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransfer.h"
#import <Swiften/FileTransfer/FileTransfer.h>
#import <Swiften/FileTransfer/OutgoingFileTransfer.h>

using namespace Swift;

@implementation SWFileTransfer {
    FileTransfer::ref fileTransfer;
}

- (id)initWithFileTransfer: (FileTransfer::ref)ft
{
    if (self = [super init]) {
        fileTransfer = ft;
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

#pragma mark - handlers

@synthesize processBytesHandler;
@synthesize stateChangeHandler;
@synthesize finishedHandler;

- (void)setupHandlers: (VSFTProcessedBytesHandler)onProcessedBytes
       onStateChanged: (VSFTSateChangeHandler) onStateChanged
           onFinished: (VSFTFinishedHanlder) onFinished
{
    processBytesHandler = onProcessedBytes;
    stateChangeHandler = onStateChanged;
    finishedHandler = onFinished;
}

@end
