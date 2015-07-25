//
//  ViviSwiften.h
//  ViviSwiften
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for ViviSwiften.
FOUNDATION_EXPORT double ViviSwiftenVersionNumber;

//! Project version string for ViviSwiften.
FOUNDATION_EXPORT const unsigned char ViviSwiftenVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ViviSwiften/PublicHeader.h>

// MARK: Vivi protocols
#import <ViviSwiften/VSViviProtocol.h>
#import <ViviSwiften/VSClientManagerProtocol.h>
#import <ViviSwiften/VSClientDelegateProtocol.h>
#import <ViviSwiften/VSControllerProtocol.h>

// MARK: Swiften wrappers
#import <ViviSwiften/SWClient.h>
#import <ViviSwiften/SWEventLoop.h>
#import <ViviSwiften/SWAccount.h>
