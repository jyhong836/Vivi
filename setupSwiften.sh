#!/bin/bash
cd SwiftXMPP
./scons Swiften # compile
mv Swiften/libSwiften.a ../"Libraries and Frameworks"
mv 3rdParty/Boost/libSwiften_Boost.a ../"Libraries and Frameworks"
