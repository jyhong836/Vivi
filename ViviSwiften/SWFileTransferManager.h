//
//  SWFileTransfer.h
//  Vivi
//
//  Created by Junyuan Hong on 8/31/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifdef __cplusplus
    #ifndef SWIFT_EXPERIMENTAL_FT
    #error require file transfer function of Swiften compiled.
    #endif
#endif

#ifdef __cplusplus
#import <boost/shared_ptr.hpp>

namespace Swift {
    class FileTransferManager;
}
#endif

@class SWAccount;
@class SWOutgoingFileTransfer;
@protocol VSFileTransferManagerDelegate;

@interface SWFileTransferManager : NSObject

#ifdef __cplusplus
- (id)initWithFileTransferManager: (Swift::FileTransferManager*) aFtManager;
#endif

- (SWOutgoingFileTransfer*)sendFileTo: (SWAccount*)account
                             filename: (NSString*)filename
                           desciption: (NSString*)desciption
                                error: (NSError**)error;

@property (nonatomic)id<VSFileTransferManagerDelegate> delegate;

@end
