//
//  SWFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 8/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransferManager.h"
#import "ViviSwiftenDefines.h"
#import "SWAccount.h"
#import "SWFileTransfer.h"
#import "VSFileTransferManagerDelegate.h"
#import "SWFileTransferManagerAdapter.h"
#import "SWOutgoingFileTransfer.h"

#import <Swiften/Base/boost_bsignals.h>
#import <boost/filesystem.hpp>
#import <Swiften/FileTransfer/FileTransferManager.h>
#import <Swiften/FileTransfer/FileReadBytestream.h>

using namespace Swift;

@implementation SWFileTransferManager {
    FileTransferManager* ftManager;
    SWFileTransferManagerAdapter* adapter;
}

- (id)initWithFileTransferManager: (FileTransferManager*) aFtManager
{
    if (self = [super init]) {
        ftManager = aFtManager;
        adapter = new SWFileTransferManagerAdapter(aFtManager, self);
    }
    return self;
}

- (SWOutgoingFileTransfer*)sendFileTo: (SWAccount*)account
                             filename: (NSString*)filename
                           desciption: (NSString*)desciption
                                error: (NSError**)error
{
    std::string fnamestr = NSString2std_str(filename);
    boost::filesystem::path filepath(fnamestr);
    
    if (!boost::filesystem::exists(filepath)) {
        if (error) {
            *error = [NSError errorWithDomain: VSClientErrorTypeDomain code: VSClientErrorTypeFileNotFound userInfo: @{@"filename": filename}];
            return nil;
        }
    }
    
    boost::shared_ptr<FileReadBytestream> fileReadStream = boost::make_shared<FileReadBytestream>(filepath);
    
    OutgoingFileTransfer::ref outgongTransfer = ftManager->createOutgoingFileTransfer(*(account.jid), filepath, NSString2std_str(desciption), fileReadStream);
    if (outgongTransfer) {
        return [[SWOutgoingFileTransfer alloc] initWithFileTransfer:outgongTransfer];
    } else {
        if (error) {
            *error = [NSError errorWithDomain: VSClientErrorTypeDomain code: VSClientErrorTypeFileTransferNotSupport userInfo: @{@"account": account}];
            return nil;
        }
        return nil;
    }
}

@end
