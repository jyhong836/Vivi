//
//  SWFileTransferManagerAdapter.cpp
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransferManagerAdapter.h"
#import "SWFileTransfer.h"
#import "SWFileTransferManager.h"
#import "VSFileTransferManagerDelegate.h"

using namespace Swift;

SWFileTransferManagerAdapter::SWFileTransferManagerAdapter(boost::shared_ptr<FileTransferManager> signalProvider, SWFileTransferManager* slotProvider): signalProvider(signalProvider), slotProvider(slotProvider)
{
    
}

void SWFileTransferManagerAdapter::handleIncomingFileTransfer(IncomingFileTransfer::ref incominTransfer)
{
    SWFileTransfer *swtf = [[SWFileTransfer alloc] initWithFileTransfer: incominTransfer];
    if ([slotProvider.delegate respondsToSelector: @selector(fileTransferManager:getIncomingTransfer:)]) {
        [slotProvider.delegate fileTransferManager: slotProvider getIncomingTransfer: swtf];
    }
    
}
