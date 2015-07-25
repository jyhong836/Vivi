//
//  ViviProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@protocol VSClientManager;

/*!
 * @brief The core protocol of Vivi.
 */
@protocol VSVivi <NSObject>

@property (readonly, nonatomic) id<VSClientManager> clientController;
@property (readonly, nonatomic) BOOL isQuitting;

@end
