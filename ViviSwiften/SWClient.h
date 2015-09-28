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
@class SWFileTransferManager;
@protocol VSClientDelegate;
@protocol VSClientControllerProtocol;
@protocol VSAvatarDelegate;

#import "ViviSwiftenDefines.h"

typedef void (^VSConnectionHandler)(int);
typedef void (^VSSendMessageHandler)(NSError* _Nullable);
typedef void (^VSUpdateServerCapsHandler)(NSString* _Nullable);

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief A Objective-C adapter for Swift::Client.
 * 
 * One Client correspond to one JID(or SWAccount). When connect method
 * called, the client will connect to server. You should not update data
 * in SWClient, instead you have to realloc SWClient for new settings.
 *
 */
@interface SWClient : NSObject

#pragma mark - Properties

/// Bind NSManagedObject to SWClient.
@property (nonatomic) id<VSClientControllerProtocol> managedObject;

@property (nonatomic, readonly) SWAccount* account;
@property (nonatomic, readonly) SWXMPPRoster* roster;
@property (nonatomic) int priority;
@property (nonatomic) NSString* nickname;
@property (nonatomic, readonly) SWFileTransferManager* fileTransferManager;

@property (nonatomic) id<VSAvatarDelegate> avatarDelegate;
@property (nonatomic, weak) id<VSClientDelegate> delegate;

#pragma mark - Init and delloc

/*!
 * @brief Init SWClient with SWAccount. By default, the resource at index 0
 * of SWAccount would be used.
 *
 * @param account must has at least one resource, else raise exception.
 * @param password must be convertible to ASCII C String, else raise Exception.
 */
- (id)initWithAccount: (SWAccount*)aAccount
             password: (NSString*)aPasswd
            eventLoop: (SWEventLoop*)aEventLoop;
- (void)dealloc;

#pragma mark - Connections

- (void)connect;
/// Connect and invoke handler when success. Handler will be invoked after delegate.
- (void)connectWithHandler: (VSConnectionHandler)handler;
- (void)disconnect;
/// Connect and invoke handler when success. Handler will be invoked after delegate.
- (void)disconnectWithHandler: (VSConnectionHandler)handler;

/// Set through connectWithHandler.
@property (readonly, nonatomic) VSConnectionHandler connectHandler;
/// Set through disconnectWithHandler.
@property (readonly, nonatomic) VSConnectionHandler disconnectHandler;
- (void)setConnectHandlerToNil;
- (void)setDisconnectHandlerToNil;

#pragma mark - Send stanza

- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     content: (NSString*)content
                 attachments: (nullable NSArray<NSString*>*)filenames
                     handler: (nullable VSSendMessageHandler)handler;
- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     content: (NSString*)content;
- (void)sendMessageToAccount: (SWAccount*)targetAccount
                     content: (NSString*)content
                     handler: (VSSendMessageHandler)handler;
- (void)sendPresence: (int)presenceType
            showType: (int)showType
              status: (NSString*)status;

#pragma mark - Invisible presence

/*! 
 * @brief Active or inactive invisible state.
 *
 * :IMPORTANT: Check `canBeInvisible` before using invisible property.
 * If you set invisible when `invisible` is not implemented, 
 * an exception will throw.
 *
 * When using invisible presence(XEP-018, rejected) to implement,
 * set invisible from false to true, will send an "Unvailable" 
 * presence.
 */
@property (nonatomic)BOOL invisible;
/*! 
 * @brief Check if client able to be invisible. Call after client
 * update server caps. (read-only)
 */
@property (nonatomic, readonly)BOOL canBeInvisible;

#pragma mark - Caps

/*!
 * @brief Check if client has initialize server caps. (read-only)
 * 
 * Call before ask for caps of features.
 */
@property (nonatomic, readonly)BOOL hasInitializedServerCaps;

- (void)updateServerCapsWithHandler: (VSUpdateServerCapsHandler)handler;
@property (nonatomic, readonly)VSUpdateServerCapsHandler updateServerCapsHandler;
- (void)setUpdateServerCapsHandlerToNil;

/*!
 * Set disoInfo of client with all supported features.
 */
- (void)setDiscoInfo: (NSString*)clientName
            capsNode: (NSString*)node
            features: (NSArray<NSString*>*)features;

#pragma mark - Client status

/*! 
 * Checks whether the client is connected to the server, and stanzas
 * can be sent. (read-only)
 */
@property (nonatomic, readonly)BOOL isAvailable;
/*!
 * @brief Checks whether the client is active. (read-only)
 *
 * A client is active when it is connected or connecting to the server.
 */
@property (nonatomic, readonly)BOOL isActive;

#pragma mark - Set client attributes

- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version
              currentOS: (NSString*)os;
- (void)setSoftwareName: (NSString*)name
         currentVersion: (NSString*)version;

#pragma mark - ClientOptions
@property (nonatomic, readwrite) NSString* manualHostname;
@property (nonatomic, readwrite) int manualPort;

@end

NS_ASSUME_NONNULL_END
