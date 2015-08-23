//
//  SWClient.h
//  Vivi
//
//  Created by Junyuan Hong on 7/21/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

@class SWEventLoop;
@class SWAccount;
@class SWXMPPRoster;
@protocol VSClientDelegate;
@protocol VSClientControllerProtocol;

#import "ViviSwiftenDefines.h"

typedef void (^VSConnectionHandler)(int);
typedef void (^VSSendMessageHandler)(VSClientErrorType);

/*!
 * @brief A Objective-C adapter for Swift::Client.
 * 
 * One Client correspond to one JID(or SWAccount). When connect method
 * called, the client will connect to server. You should not update data
 * in SWClient, instead you have to realloc SWClient for new settings.
 *
 */
@interface SWClient : NSObject

/// Bind NSManagedObject to SWClient.
@property (nonatomic) id<VSClientControllerProtocol> managedObject;

@property (readonly, nonatomic) SWAccount* account;
@property (readonly, nonatomic) SWXMPPRoster* roster;

@property (nonatomic) id<VSClientDelegate> delegate;
/// Set through connectWithHandler.
@property (readonly, nonatomic) VSConnectionHandler connectHandler;
/// Set through disconnectWithHandler.
@property (readonly, nonatomic) VSConnectionHandler disconnectHandler;
- (void)setConnectHandlerToNil;
- (void)setDisconnectHandlerToNil;

/*!
 * @brief Init SWClient with SWAccount
 *
 * @param password must be convertible to ASCII C String, or raise Exception.
 */
- (id)initWithAccount: (SWAccount*)aAccount
             password: (NSString*)aPasswd
            eventLoop: (SWEventLoop*)aEventLoop;
//- (void)dealloc;

- (void)connect;
/// Connect and invoke handler when success. Handler will be invoked after delegate.
- (void)connectWithHandler: (VSConnectionHandler)handler;
- (void)disconnect;
/// Connect and invoke handler when success. Handler will be invoked after delegate.
- (void)disconnectWithHandler: (VSConnectionHandler)handler;
- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     Message: (NSString*)message;
- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     Message: (NSString*)message
                     handler: (VSSendMessageHandler)handler;
- (void)sendPresence: (int)presenceType
            showType: (int)showType
              status: (NSString*)status;

/// Checks whether the client is connected to the server, and stanzas can be sent.
- (BOOL)isAvailable;
/*!
 * @brief Checks whether the client is active.
 *
 * A client is active when it is connected or connecting to the server.
 */
- (BOOL)isActive;

- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
              currentOS: (NSString*)os;
- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version;

// MARK: ClientOptions
@property (nonatomic, readwrite) NSString* manualHostname;
- (void)setManualHostname: (NSString*)manualHostname;
@property (nonatomic, readwrite) int manualPort;
- (void)setManualPort:(int)manualPort;

@end
