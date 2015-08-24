//
//  InvisiblePayloadSerializer.hpp
//  Vivi
//
//  Created by Junyuan Hong on 8/24/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#include "InvisibleListPayload.hpp"
#include <Swiften/Serializer/GenericPayloadSerializer.h>
#include <iostream>

/// See [XEP-0126](http://xmpp.org/extensions/xep-0126.html#vis-global) for detail.
class InvisibleListPayloadSerializer: public Swift::GenericPayloadSerializer<InvisibleListPayload> {
    
public:
    std::string serializePayload(boost::shared_ptr<InvisibleListPayload> payload) const;
};
