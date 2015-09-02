//
//  ViviSwiftenDefines.h
//  Vivi
//
//  Created by Junyuan Hong on 8/1/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifndef ViviSwiftenDefines_h
#define ViviSwiftenDefines_h

#import <ViviSwiften/ViviSwiften-Swift.h>

typedef SWIFT_ENUM(NSInteger, VSFTManagerError) {
    VSFTManagerErrorFileNotFound,
};
static NSString* const VSFTManagerErrorDomain = @"ViviSwiften.VSFTManagerError";

typedef NS_ENUM(NSInteger, VSClientErrorType) {
    VSClientErrorTypeNone,
    VSClientErrorTypeUnknown,
    VSClientErrorTypeClientUnavaliable
};

#endif /* ViviSwiftenDefines_h */
