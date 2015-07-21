//
//  ViviProtocol.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VSClientController;

@protocol VSVivi <NSObject>
@property (weak, nonatomic) NSObject<VSClientController> *clientController;
@property (readonly, nonatomic) BOOL isQuitting;

@end
