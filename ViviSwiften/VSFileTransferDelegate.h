//
//  VSFileTransferDelegate.h
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWFileTransfer;

@protocol VSFileTransferDelegate <NSObject>

- (void)fileTransfer: (SWFileTransfer*) filetransfer
      processedBytes: (size_t)bytes;

- (void)fileTransfer: (SWFileTransfer*) filetransfer
        stateChanged: (int)stateCode;

- (void)fileTransfer: (SWFileTransfer*) filetransfer
   finishedWithError: (int)errorCode;

@end
