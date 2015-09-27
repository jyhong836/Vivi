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

@protocol VSFileTransferDelegate;

@interface SWFileTransfer : NSObject {
#ifdef __cplusplus
@protected
    boost::shared_ptr<Swift::FileTransfer> fileTransfer;
#endif
}

#ifdef __cplusplus
- (id)initWithFileTransfer: (boost::shared_ptr<Swift::FileTransfer>)ft;
#endif

@property (nonatomic, readonly)NSString* filename;
@property (nonatomic, readonly)unsigned long fileSizeInBytes;
@property (nonatomic, weak)id<VSFileTransferDelegate> delegate;

- (void)cancel;

@end
