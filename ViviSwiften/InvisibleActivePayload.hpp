//
//  InvisibleActivePayload.hpp
//  Vivi
//
//  Created by Junyuan Hong on 8/24/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#include <Swiften/Elements/Payload.h>

class InvisibleActivePayload: Swift::Payload{
public:
    InvisibleActivePayload(bool invisible): invisible(invisible) {}
    bool invisible;
};
