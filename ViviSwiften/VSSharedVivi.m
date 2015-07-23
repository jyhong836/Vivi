//
//  VISharedVivi.m
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

id<VSVivi> vivi = nil;

void setSharedVivi(id<VSVivi> shared)
{
    NSCAssert(vivi == nil, @"Attempt to set the shared VSVivi instance after it's already been set");
    NSCParameterAssert(shared != nil);
    vivi = shared;
}
