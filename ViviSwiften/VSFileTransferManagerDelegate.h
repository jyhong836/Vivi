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

- (void)fileTransferManager: (SWFileTransferManager*)manager
        getIncomingTransfer: (SWIncomingFileTransfer*)transfer;

@end
