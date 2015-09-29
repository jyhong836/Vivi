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
            *error = [NSError errorWithDomain:VSClientErrorTypeDomain code:VSClientErrorTypeFileNotFound userInfo:@{NSLocalizedDescriptionKey: @"Fail to send file, for file not found.", NSLocalizedFailureReasonErrorKey: @"File not exists.", NSLocalizedRecoverySuggestionErrorKey: [NSString stringWithFormat:@"Remove file %s, and try again", filepath.filename().c_str()]}];
            return nil;
        }
    }
    
    boost::shared_ptr<FileReadBytestream> fileReadStream = boost::make_shared<FileReadBytestream>(filepath);
    
    OutgoingFileTransfer::ref outgongTransfer = ftManager->createOutgoingFileTransfer(*(account.jid), filepath, NSString2std_str(desciption), fileReadStream);
    if (outgongTransfer) {
        return [[SWOutgoingFileTransfer alloc] initWithFileTransfer:outgongTransfer
                                                           filepath: filename];
    } else {
        if (error) {
            *error = [NSError errorWithDomain:VSClientErrorTypeDomain code:VSClientErrorTypeFileTransferNotSupport userInfo:@{NSLocalizedDescriptionKey: @"Fail to init outgoing file transfer.", NSLocalizedFailureReasonErrorKey: @"Fail to create outgoing file transfer.", NSLocalizedRecoverySuggestionErrorKey: @"The file transfer feature may not be supported by target client. Try to remove file from message."}];
            return nil;
        }
        return nil;
    }
}

@end
