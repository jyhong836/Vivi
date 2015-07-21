//
//  Vivi.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "Vivi.h"
#import "VISharedVivi.h"
#import "VIClientController.h"

@implementation Vivi
- (id)init
{
    if (self = [super init]) {
        setSharedVivi(self);
    }
    return self;
}

#pragma mark Core Controllers
@synthesize clientController;

@synthesize isQuitting;

@end
