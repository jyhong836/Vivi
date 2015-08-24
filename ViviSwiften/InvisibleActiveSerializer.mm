//
//  InvisibleActiveSerializer.cpp
//  Vivi
//
//  Created by Junyuan Hong on 8/24/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#include "InvisibleActiveSerializer.hpp"
#import <Swiften/Serializer/XML/XMLElement.h>
#import <Swiften/Serializer/XML/XMLRawTextNode.h>

using namespace Swift;

std::string
InvisibleActiveSerializer::serializePayload(boost::shared_ptr<InvisibleActivePayload> payload) const
{
    XMLElement element("active");
    if (payload->invisible) {
        element.setAttribute("name", "invisible");
    } else {
        element.setAttribute("name", "visible");
    }
    return element.serialize();
}
