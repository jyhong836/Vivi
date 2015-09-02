//
//  SWFileTransferAdapter.cpp
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWFileTransferAdapter.h"
#import "SWFileTransfer.h"
#import "VSFileTransferDelegate.h"

#import <boost/bind.hpp>

using namespace Swift;

SWFileTransferAdapter::SWFileTransferAdapter(FileTransfer::ref signalProvider, SWFileTransfer* slotProvider)
{
    this->signalProvider = signalProvider;
    this->slotProvider = slotProvider;
    
    signalProvider->onProcessedBytes.connect(boost::bind(&SWFileTransferAdapter::handleProcessedBytes, this, _1));
    signalProvider->onStateChanged.connect(boost::bind(&SWFileTransferAdapter::handleStateChanged, this, _1));
    signalProvider->onFinished.connect(boost::bind(&SWFileTransferAdapter::handleFinished, this, _1));
}

SWFileTransferAdapter::~SWFileTransferAdapter()
{
    signalProvider->onProcessedBytes.disconnect(boost::bind(&SWFileTransferAdapter::handleProcessedBytes, this, _1));
    signalProvider->onStateChanged.disconnect(boost::bind(&SWFileTransferAdapter::handleStateChanged, this, _1));
    signalProvider->onFinished.disconnect(boost::bind(&SWFileTransferAdapter::handleFinished, this, _1));
}

void SWFileTransferAdapter::handleProcessedBytes(size_t sz)
{
    if ([slotProvider.delegate respondsToSelector: @selector(fileTransfer:processedBytes:)]) {
        [slotProvider.delegate fileTransfer: slotProvider
                             processedBytes: sz];
    }
}

void SWFileTransferAdapter::handleStateChanged(const FileTransfer::State&state)
{
    if ([slotProvider.delegate respondsToSelector: @selector(fileTransfer:stateChanged:)]) {
        [slotProvider.delegate fileTransfer: slotProvider
                               stateChanged: state.type];
    }
}

void SWFileTransferAdapter::handleFinished(boost::optional<FileTransferError> error)
{
    int errcode = -1;
    if (error.is_initialized()) {
        errcode = error->getType();
    }
    if ([slotProvider.delegate respondsToSelector: @selector(fileTransfer:finishedWithError:)]) {
        [slotProvider.delegate fileTransfer: slotProvider finishedWithError: errcode];
    }
}
