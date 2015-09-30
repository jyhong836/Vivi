//
//  Utils.m
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "Utils.h"

const char* NSString2std_str(NSString *nsstr) {
    if (![nsstr canBeConvertedToEncoding:CCHAR_ENCODING]) {
        NSLog(@"\"%@\" can not be converted to c string", nsstr);
//        assert(false);
        [NSException raise:@"NotBeConvertedNSString" format:@"\"%@\" can not be converted to c string", nsstr];
    }
    return [nsstr cStringUsingEncoding:CCHAR_ENCODING];
}
