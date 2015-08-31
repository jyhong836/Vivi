//
//  SWFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 8/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransferManager.h"
#import "SWAccount.h"
#import <Swiften/FileTransfer/FileTransferManager.h>

using namespace Swift;

@implementation SWFileTransferManager {
    FileTransferManager* ftManager;
}


- (id)initWithFileTransferManager: (Swift::FileTransferManager*) aFtManager
{
    if (self = [super init]) {
        ftManager = aFtManager;
    }
    return self;
}

- (void)sendFileTo: (SWAccount*)account
          filename: (NSString*)filename
{
    [NSException raise: @"UnimplementException" format: @"Not implemented function: sendFileTo"];
//    OutgoingFileTransfer::ref oft = ftManager->createOutgoingFileTransfer(account.jid, <#const boost::filesystem::path &filepath#>, <#const std::string &description#>, <#boost::shared_ptr<ReadBytestream> bytestream#>);
    // TODO: add sending task to list.
}

@end
