//
//  Vivi.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViviProtocol.h"

@protocol VIClientController;

@interface Vivi : NSObject <Vivi> {
@private
    NSObject<VIClientController> *clientController;
    BOOL isQuitting;
}
- (id)init;
@end
