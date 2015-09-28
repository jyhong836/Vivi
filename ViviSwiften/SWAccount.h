//
//  SWAccount.h
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//
#ifdef __cplusplus
namespace Swift {
    class JID;
}
#endif

@interface SWAccount : NSObject
#ifdef __cplusplus
@property (readonly, nonatomic) Swift::JID* jid;
#endif

/*!
 * @param accountName must be convertible to ASCII C String, or raise Exception.
 */
- (id)initWithAccountName: (NSString *)account;
#ifdef __cplusplus
/*!
 * @brief Init with jid.
 *
 * It will guarantee jid to be bare, and store resource to list if exists.
 */
- (id)initWithJID: (const Swift::JID&)ajid;
#endif
- (void)dealloc;

- (SWAccount*)toBare;

/*!
 * @brief Validate JID.
 */
@property (nonatomic, readonly)BOOL valid;
@property (nonatomic, readonly)BOOL bare;
/*!
 * @brief Account string with resource. By default there is no 
 * resource. (read-only)
 */
@property (nonatomic, readonly)NSString* string;
/*!
 * @brief Account string without resource. (read-only)
 */
@property (nonatomic, readonly)NSString* bareString;
@property (nonatomic, readonly)NSString* resource;
@property (nonatomic, readonly)NSString* node;
@property (nonatomic, readonly)NSString* domain;

@end
