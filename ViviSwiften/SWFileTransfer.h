//
//  SWOutgoingFileTransfer.h
//  Vivi
//
//  Created by Junyuan Hong on 9/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifdef __cplusplus
#include <boost/shared_ptr.hpp>

namespace Swift {
    class FileTransfer;
}
#endif

typedef void (^VSFTProcessedBytesHandler)(int);
typedef void (^VSFTSateChangeHandler)(int);
typedef void (^VSFTFinishedHanlder)(int);

@interface SWFileTransfer : NSObject

#ifdef __cplusplus
- (id)initWithFileTransfer: (boost::shared_ptr<Swift::FileTransfer>)ft;
#endif

@property (nonatomic, readonly)NSString* filename;
@property (nonatomic, readonly)unsigned long fileSizeInBytes;

- (void)cancel;
- (void)start;

#pragma mark - handlers

@property (nonatomic, readonly)VSFTProcessedBytesHandler processBytesHandler;
@property (nonatomic, readonly)VSFTSateChangeHandler stateChangeHandler;
@property (nonatomic, readonly)VSFTFinishedHanlder finishedHandler;

- (void)setupHandlers: (VSFTProcessedBytesHandler)onProcessedBytes
       onStateChanged: (VSFTSateChangeHandler) onStateChanged
           onFinished: (VSFTFinishedHanlder) onFinished;

@end
