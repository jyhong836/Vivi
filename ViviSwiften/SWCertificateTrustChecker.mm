//
//  SWCertificateTrustChecker.cpp
//  Vivi
//
//  Created by Junyuan Hong on 9/8/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWCertificateTrustChecker.h"

using namespace Swift;

bool SWCertificateTrustChecker::isCertificateTrusted(const std::vector<Certificate::ref>& certificateChain)
{
    for (auto cert: certificateChain) {
        if (!handler(std_str2NSString(cert->getSubjectName()))) {
            return false;
        }
    }
    return true;
}

SWCertificateTrustChecker::SWCertificateTrustChecker(SWTrustCertificateHandler handler): handler(handler)
{
}
