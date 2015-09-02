//
//  SWFileTransferManagerAdapter.cpp
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransferManagerAdapter.h"
#import "SWIncomingFileTransfer.h"
#import "SWFileTransferManager.h"
#import "VSFileTransferManagerDelegate.h"

#import <boost/bind.hpp>

using namespace Swift;

SWFileTransferManagerAdapter::SWFileTransferManagerAdapter(FileTransferManager* signalProvider, SWFileTransferManager* slotProvider): signalProvider(signalProvider), slotProvider(slotProvider)
{
    signalProvider->onIncomingFileTransfer.connect(boost::bind(&SWFileTransferManagerAdapter::handleIncomingFileTransfer, this, _1));
}

SWFileTransferManagerAdapter::~SWFileTransferManagerAdapter()
{
    signalProvider->onIncomingFileTransfer.disconnect(boost::bind(&SWFileTransferManagerAdapter::handleIncomingFileTransfer, this, _1));
}

void SWFileTransferManagerAdapter::handleIncomingFileTransfer(IncomingFileTransfer::ref incominTransfer)
{
    SWIncomingFileTransfer *swtf = [[SWIncomingFileTransfer alloc] initWithFileTransfer: incominTransfer];
    if ([slotProvider.delegate respondsToSelector: @selector(fileTransferManager:getIncomingTransfer:)]) {
        [slotProvider.delegate fileTransferManager: slotProvider getIncomingTransfer: swtf];
    }
    
}
