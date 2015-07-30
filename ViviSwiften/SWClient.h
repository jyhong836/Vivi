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
@protocol VSChatListControllerProtocol;

typedef void (^ConnectionHandler)(void);

/*!
 * @brief A Objective-C adapter for Swift::Client.
 * 
 * One Client correspond to one JID(or SWAccount). When connect method
 * called, the client will connect to server.
 *
 */
@interface SWClient : NSObject

@property (readonly, nonatomic) SWAccount* account;
@property (readonly, nonatomic) SWXMPPRoster* roster;

@property (nonatomic) id<VSChatListControllerProtocol> chatListController;
@property (nonatomic) id<VSClientDelegate> delegate;
/// Set through connectWithHandler.
@property (readonly, nonatomic) ConnectionHandler connectHandler;
/// Set through disconnectWithHandler.
@property (readonly, nonatomic) ConnectionHandler disconnectHandler;
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
- (void)connectWithHandler: (ConnectionHandler)handler;
- (void)disconnect;
/// Connect and invoke handler when success. Handler will be invoked after delegate.
- (void)disconnectWithHandler: (ConnectionHandler)handler;
- (void)sendMessageToAccount: (SWAccount*)account
              Message: (NSString*)message;

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

@end
