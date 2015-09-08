//
//  SWCertificateTrustChecker.hpp
//  Vivi
//
//  Created by Junyuan Hong on 9/8/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#pragma once

#import <Swiften/TLS/CertificateTrustChecker.h>

typedef BOOL(^SWTrustCertificateHandler)(NSString* subject);

namespace Swift {
    
    class SWIFTEN_API SWCertificateTrustChecker : public CertificateTrustChecker {
    public:
        SWCertificateTrustChecker(SWTrustCertificateHandler);
        bool isCertificateTrusted(const std::vector<Certificate::ref>& certificateChain);
    private:
        SWTrustCertificateHandler handler;
    };
    
}
