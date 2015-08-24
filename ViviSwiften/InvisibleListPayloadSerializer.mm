//
//  InvisiblePayloadSerializer.cpp
//  Vivi
//
//  Created by Junyuan Hong on 8/24/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#include "InvisibleListPayloadSerializer.hpp"
#import <Swiften/Serializer/XML/XMLElement.h>
#import <Swiften/Serializer/XML/XMLRawTextNode.h>

using namespace Swift;

std::string
InvisibleListPayloadSerializer::serializePayload(boost::shared_ptr<InvisibleListPayload> payload) const
{
    XMLElement element("list");
    if (payload->invisible) {
        element.setAttribute("name", "invisible");
        element.addNode(boost::shared_ptr<XMLRawTextNode>(new XMLRawTextNode("<item action='deny' order='1'>""<presence-out/>""</item>")));
    } else {
        element.setAttribute("name", "visible");
        element.addNode(boost::shared_ptr<XMLRawTextNode>(new XMLRawTextNode("<item action='allow' order='1'>""<presence-out/>""</item>")));
    }
    return element.serialize();
}
