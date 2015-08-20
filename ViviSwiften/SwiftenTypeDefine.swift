//
//  SwiftenTypeDefine.swift
//  Vivi
//
//  Created by Junyuan Hong on 7/26/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

import Foundation

// MARK: Swiften types
public enum SWPresenceType: Int32 {
    case Available, Error, Probe, Subscribe, Subscribed, Unavailable, Unsubscribe, Unsubscribed
    public func toString() -> String? {
        return SWPresenceTypeStringDict[self]
    }
}
let SWPresenceTypeStringDict: [SWPresenceType: String] = [.Available: "Available", .Error: "Error", .Probe: "Probe", .Subscribe: "Subscribe", .Subscribed: "Subscribed", .Unavailable: "Unavailable", .Unsubscribe: "Unsubscribe", .Unsubscribed: "Unsubscribed"]

public enum SWPresenceShowType: Int32 {
    case Online, Away, FFC, XA, DND, None
    public func toString() -> String? {
        return SWPresenceShowTypeStringDict[self]
    }
}
let SWPresenceShowTypeStringDict: [SWPresenceShowType: String] = [.Online: "Online", .Away: "Away", .FFC:"FFC", .XA: "XA", .DND: "DND", .None:"None"]

public enum SWClientErrorType: Int32 {
    case UnknownError, DomainNameResolveError, ConnectionError, ConnectionReadError
    case ConnectionWriteError, XMLError, AuthenticationFailedError, CompressionFailedError
    case ServerVerificationFailedError, NoSupportedAuthMechanismsError, UnexpectedElementError, ResourceBindError
    case SessionStartError, StreamError, TLSError, ClientCertificateLoadError
    case ClientCertificateError, CertificateCardRemoved, UnknownCertificateError, CertificateExpiredError
    case CertificateNotYetValidError, CertificateSelfSignedError, CertificateRejectedError, CertificateUntrustedError
    case InvalidCertificatePurposeError, CertificatePathLengthExceededError, InvalidCertificateSignatureError, InvalidCAError
    case InvalidServerIdentityError, RevokedError, RevocationCheckFailedError
}
