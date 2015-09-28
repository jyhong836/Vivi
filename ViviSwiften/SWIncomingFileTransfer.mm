//
//  SWIncomingFileTransfer.m
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWIncomingFileTransfer.h"
#import "SWAccount.h"

#import <boost/shared_ptr.hpp>
#import <boost/filesystem.hpp>
#import <Swiften/FileTransfer/IncomingFileTransfer.h>
#import <Swiften/FileTransfer/FileWriteBytestream.h>
#include <Swiften/JID/JID.h>

using namespace Swift;

@implementation SWIncomingFileTransfer

- (void)acceptAsFile: (NSString*)file
{
    std::string fnamestr = NSString2std_str(file);
    boost::filesystem::path filepath(fnamestr);
    
    boost::shared_ptr<FileWriteBytestream> fileWriteStream = boost::make_shared<FileWriteBytestream>(boost::filesystem::path(fnamestr));
    boost::dynamic_pointer_cast<IncomingFileTransfer>(fileTransfer)->accept(fileWriteStream);
}

- (SWAccount*)sender
{
    const JID &jid = boost::dynamic_pointer_cast<IncomingFileTransfer>(fileTransfer)->getSender();
    SWAccount* account = [[SWAccount alloc] initWithAccountName: std_str2NSString(jid.toString())];
    return account;
}

- (SWAccount*)recipient
{
    const JID &jid = boost::dynamic_pointer_cast<IncomingFileTransfer>(fileTransfer)->getRecipient();
    SWAccount* account = [[SWAccount alloc] initWithAccountName: std_str2NSString(jid.toString())];
    return account;
}

@end
