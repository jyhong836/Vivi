//
//  VSFileTransferManagerDelegate.h
//  Vivi
//
//  Created by Junyuan Hong on 9/2/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWFileTransferManager;
@class SWIncomingFileTransfer;

@protocol VSFileTransferManagerDelegate <NSObject>

/*!
 * @brief handle the incoming file transfer.
 *
 * The transfer has to been stored in variable to avoid
 * being released. Call [transfer acceptAsFile] to accept
 * file and start tansfer.
 */
- (void)fileTransferManager: (SWFileTransferManager*)manager
        getIncomingTransfer: (SWIncomingFileTransfer*)transfer;

@end
