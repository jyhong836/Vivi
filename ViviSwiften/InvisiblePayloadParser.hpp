//
//  InvisiblePayloadParser.hpp
//  Vivi
//
//  Created by Junyuan Hong on 8/24/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#include "InvisiblePayload.hpp"
#include <Swiften/Parser/GenericPayloadParser.h>
#include <Swiften/Parser/GenericPayloadParserFactory.h>

class InvisiblePayloadParser: public GenericPayloadParser<InvisiblePayload> {
public:
    InvisiblePayloadParser() {}
}

class InvisiblePayloadParserFactory: public GenericPayloadParserFactory<InvisiblePayloadParser> {
public:
    InvisiblePayloadParserFactory(): GenericPayloadParserFactory<InvisiblePayloadParser>("list") {}
}
