//
//  SWFileTransferManagerAdapter.hpp
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#import <boost/shared_ptr.hpp>
#import <Swiften/FileTransfer/FileTransferManager.h>
#import <Swiften/FileTransfer/IncomingFileTransfer.h>

@class SWFileTransferManager;

namespace Swift {
    class SWFileTransferManagerAdapter {
        
    public:
        SWFileTransferManagerAdapter(boost::shared_ptr<FileTransferManager> signalProvider, SWFileTransferManager* slotProvider);
        typedef boost::shared_ptr<SWFileTransferManagerAdapter> ref;
        
    private:
        boost::shared_ptr<FileTransferManager> signalProvider;
        SWFileTransferManager* __weak slotProvider;
        
        void handleIncomingFileTransfer(IncomingFileTransfer::ref);
        
    };
}
