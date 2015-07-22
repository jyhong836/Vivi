//
//  VISharedVivi.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
#import "VSSharedVivi.h"

id<VSVivi> vivi = nil;

void setSharedVivi(id<VSVivi> shared)
{
    NSCAssert(vivi == nil, @"Attempt to set the shared AIAdium instance after it's already been set");
    NSCParameterAssert(shared != nil);
    vivi = shared;
}
