//
//  InvisiblePresenceSerializer.hpp
//  Vivi
//
//  Created by Junyuan Hong on 8/25/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#ifndef __cplusplus
#error not c++
#endif

#include "InvisiblePresence.hpp"

#import <Swiften/Base/API.h>
#import <Swiften/Serializer/GenericStanzaSerializer.h>

#import <boost/optional.hpp>

namespace Swift {
    class SWIFTEN_API InvisiblePresenceSerializer : public GenericStanzaSerializer<InvisiblePresence> {
    public:
        InvisiblePresenceSerializer(PayloadSerializerCollection* payloadSerializers, const boost::optional<std::string>& explicitNS = boost::optional<std::string>());
        ~InvisiblePresenceSerializer() {}
        
    private:
        virtual void setStanzaSpecificAttributesGeneric(
                                                        boost::shared_ptr<InvisiblePresence> presence,
                                                        XMLElement& element) const;
    };
}
