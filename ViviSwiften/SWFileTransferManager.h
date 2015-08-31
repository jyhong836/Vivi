//
//  SWFileTransfer.h
//  Vivi
//
//  Created by Junyuan Hong on 8/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifndef SWIFT_EXPERIMENTAL_FT
#error require file transfer function of Swiften compiled.
#endif

#ifdef __cplusplus
namespace Swift {
    class FileTransferManager;
}
#endif

@class SWAccount;

@interface SWFileTransferManager : NSObject

#ifdef __cplusplus
- (id)initWithFileTransferManager: (Swift::FileTransferManager*) aFtManager;
#endif

- (void)sendFileTo: (SWAccount*)account
          filename: (NSString*)filename;

@end
