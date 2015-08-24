//
//  InvisiblePayloadSerializer.hpp
//  Vivi
//
//  Created by Junyuan Hong on 8/24/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#include "InvisiblePayload.hpp"
#include <Swiften/Serializer/GenericPayloadSerializer.h>
#include <iostream>

class InvisiblePayloadSerializer: public Swift::GenericPayloadSerializer<InvisiblePayload> {
    
public:
    std::string serializePayload(boost::shared_ptr<InvisiblePayload> payload) const;
};
