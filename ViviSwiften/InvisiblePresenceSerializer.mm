//
//  InvisiblePresenceSerializer.cpp
//  Vivi
//
//  Created by Junyuan Hong on 8/25/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "InvisiblePresenceSerializer.hpp"
#import <Swiften/Serializer/XML/XMLElement.h>
#import <Swiften/Base/Log.h>
#import <boost/shared_ptr.hpp>

namespace Swift {
    
    InvisiblePresenceSerializer::InvisiblePresenceSerializer(PayloadSerializerCollection* payloadSerializers, const boost::optional<std::string>& explicitNS) :
    GenericStanzaSerializer<InvisiblePresence>("presence", payloadSerializers, explicitNS)
    {
        
    }

    void InvisiblePresenceSerializer::setStanzaSpecificAttributesGeneric(
                                            boost::shared_ptr<InvisiblePresence> presence,
                                            XMLElement& element) const {
        if (presence->getInvisible()) {
            element.setAttribute("type","invisible");
        } else {
            element.setAttribute("type","visible");
        }
    }
    
}
