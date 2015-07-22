//
//  VISharedVivi.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#ifndef VISharedVivi_h
#define VISharedVivi_h

#import "VSViviProtocol.h"
/*!
 @brief Global shared VSVivi
 */
extern id<VSVivi> vivi;

/*!
 * @brief Set shared VSVivi
 *
 * Called once, after App loads. You have to init the controllers.
 */
void setSharedVivi(id<VSVivi> shared);

#endif /* VISharedVivi_h */
