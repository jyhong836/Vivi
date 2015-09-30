//
//  ViviSwiftenDefines.h
//  Vivi
//
//  Created by Junyuan Hong on 8/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifndef ViviSwiftenDefines_h
#define ViviSwiftenDefines_h

//#import <ViviSwiften/ViviSwiften-Swift.h>

typedef NS_ENUM(NSInteger, VSClientErrorType) {
    VSClientErrorTypeNone,
    VSClientErrorTypeUnknown,
    VSClientErrorTypeClientUnavaliable,
    VSClientErrorTypeFileNotFound,
    VSClientErrorTypeFileTransferNotSupport,
    VSClientErrorTypePresenceUnavailable,
};
static NSString* const VSClientErrorTypeDomain = @"ViviSwiften.VSClientErrorType";

#endif /* ViviSwiftenDefines_h */
