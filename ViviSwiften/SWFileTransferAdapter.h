//
//  SWFileTransferAdapter.hpp
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#import <Swiften/FileTransfer/FileTransfer.h>
#import <boost/shared_ptr.hpp>

@class SWFileTransfer;

namespace Swift {
    class SWFileTransferAdapter {
        
    public:
        SWFileTransferAdapter(FileTransfer::ref signalProvider, SWFileTransfer* slotProvider);
        typedef boost::shared_ptr<SWFileTransferAdapter> ref;
        
    private:
        FileTransfer::ref signalProvider;
        SWFileTransfer* __weak  slotProvider;
        void handleProcessedBytes(size_t /* proccessedBytes */);
        void handleStateChanged(const FileTransfer::State&);
        void handleFinished(boost::optional<FileTransferError>);
        
    };
}
