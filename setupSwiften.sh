#!/bin/bash
cd SwiftXMPP
./scons swiften_dll=true SWIFTEN_INSTALLDIR=../"Libraries and Frameworks" ../"Libraries and Frameworks" Swiften # compile
cd ../"Libraries and Frameworks/lib"
install_name_tool -id @loader_path/Frameworks/libSwiften.3.0.dylib libSwiften.3.0.dylib
