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
    case Available, Error, Probe, Subscribe, Subscribed, Unavailable, Unsubscribe, Unsubscribed, Invisible, Visible
    public func toString() -> String? {
        return SWPresenceTypeStringDict[self]
    }
    /// Return an readable string which describes the current presence status.
    public func parseWithShow(showtype: SWPresenceShowType?, andStatus status: String?) -> String? {
        if status != nil && status != "" {
            return status
        } else {
            switch (self) {
            case .Available:
                if let show = showtype {
                    return show.toString()
                } else {
                    return "Online"
                }
            case .Unavailable:
                return "Offline"
            default:
                return toString()
            }
        }
    }
    /// Parse from presence string. This will search for corresponded
    /// type from presence type and presence show type. If it is not
    /// found, presence will be return in status, and presencetyp is
    /// `.Available`, show type is `.Online`.
    public static func parseFrom(presence: String!) -> (presence: SWPresenceType, show: SWPresenceShowType, status: String!) {
        // FIXME: By default, Swiften will use (show).None for Unavailable presence, (show).Online for Available.
        for (type, str) in SWPresenceTypeStringDict {
            if presence == str {
                return (presence: type, show: SWPresenceShowType(presence: type), status: "")
            }
        }
        for (type, str) in SWPresenceShowTypeStringDict {
            if presence == str {
                return (presence: .Available, show: type, status: "")
            }
        }
//        if presence == "Invisible" {
//            // FIXME: this will cause unable to receive any update from server.
//            return (presence: .Available, show: SWPresenceShowType.Online, status: "")
//        }
        if presence == "Offline" {
            return (presence: .Unavailable, show: SWPresenceShowType.None, status: presence)
        }
        return (presence: .Available, show: SWPresenceShowType.Online, status: presence)
    }
    public init(show: SWPresenceShowType) {
        switch (show) {
        case .None:
            self = .Unavailable
        default:
            self = .Available
        }
    }
}
let SWPresenceTypeStringDict: [SWPresenceType: String] = [.Available: "Available", .Error: "Error", .Probe: "Probe", .Subscribe: "Subscribe", .Subscribed: "Subscribed", .Unavailable: "Unavailable", .Unsubscribe: "Unsubscribe", .Unsubscribed: "Unsubscribed", .Invisible: "Invisible", .Visible: "Visible"]

public enum SWPresenceShowType: Int32 {
    case Online, Away, FFC, XA, DND, None
    public func toString() -> String? {
        return SWPresenceShowTypeStringDict[self]
    }
    public init(presence: SWPresenceType) {
        switch (presence) {
        case .Available:
            self = .Online
        case .Unavailable:
            self = .None
        default:
            self = .None
        }
    }
}
let SWPresenceShowTypeStringDict: [SWPresenceShowType: String] = [.Online: "Online", .Away: "Away", .FFC:"FFC", .XA: "XA"/* extended away */, .DND: "DND" /* do not disturb */, .None:"None"]

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
