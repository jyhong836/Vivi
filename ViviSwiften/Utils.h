//
//  Utils.h
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifndef Utils_h
#define Utils_h

/*!
 * NSString* std_str2NSString(std::string)
 */
#define std_str2NSString(std_str) [NSString stringWithCString:(std_str).c_str() encoding:[NSString defaultCStringEncoding]]

const char* NSString2std_str(NSString *nsstr);

#endif /* Utils_h */
