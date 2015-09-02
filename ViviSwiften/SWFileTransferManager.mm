//
//  SWFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 8/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransferManager.h"
#import "SWAccount.h"
#import "SWFileTransfer.h"
#import "VSFileTransferManagerDelegate.h"
#import "SWFileTransferManagerAdapter.h"

#import <Swiften/Base/boost_bsignals.h>
#import <Swiften/FileTransfer/FileTransferManager.h>
#import <Swiften/FileTransfer/FileReadBytestream.h>

using namespace Swift;

@implementation SWFileTransferManager {
    FileTransferManager* ftManager;
}

- (id)initWithFileTransferManager: (FileTransferManager*) aFtManager
{
    if (self = [super init]) {
        ftManager = aFtManager;
    }
    return self;
}

- (SWFileTransfer*)sendFileTo: (SWAccount*)account
                     filename: (NSString*)filename
                   desciption: (NSString*)desciption
{
    std::string fnamestr = NSString2std_str(filename);
    boost::shared_ptr<FileReadBytestream> fileReadStream = boost::make_shared<FileReadBytestream>(boost::filesystem::path(fnamestr));
    
    OutgoingFileTransfer::ref outgongTransfer = ftManager->createOutgoingFileTransfer(*(account.jid), boost::filesystem::path(fnamestr), NSString2std_str(desciption), fileReadStream);
    if (outgongTransfer) {
        return [[SWFileTransfer alloc] initWithFileTransfer: outgongTransfer];
    } else {
        [NSException raise: @"FileTransferNotSupported" format: @"File transfer not supported"];
        return nil;
    }
}

@end
