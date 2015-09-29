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
/*!
 * @brief Init with file transfer, without filepath. The filepath
 * will be set to Swift::FileTransfer::getFilename().
 */
- (id)initWithFileTransfer: (boost::shared_ptr<Swift::FileTransfer>)ft;
/*!
 * @brief Init with file transfer and filepath. The filepath should
 * be full path to file.
 */
- (id)initWithFileTransfer: (boost::shared_ptr<Swift::FileTransfer>)ft
                  filepath: (NSString*)aFilepath;
#endif
/*!
 * @brief File name without path. (read-only)
 */
@property (nonatomic, readonly)NSString* filename;
/*!
 * @brief Full file path. (read-only)
 */
@property (nonatomic, readonly)NSString* filepath;
@property (nonatomic, readonly)unsigned long fileSizeInBytes;
@property (nonatomic, weak)id<VSFileTransferDelegate> delegate;

- (void)cancel;

@end
