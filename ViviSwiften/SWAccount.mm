//
//  SWAccount.m
//  Vivi
//
//  Created by Junyuan Hong on 7/22/15.
//  Copyright © 2015 Junyuan Hong. All rights reserved.
//

#import "SWAccount.h"

#import <Swiften/JID/JID.h>
using namespace Swift;

@implementation SWAccount {
    NSInteger resourceIndex;
}

@synthesize jid;

/*!
 * @param accountName must be convertible to ASCII C String, or raise Exception.
 */
- (id)initWithAccountName: (NSString *)account
{
    if (self = [super init]) {
        resources = [[NSMutableArray<NSString*> alloc] init];
        jid = new JID(NSString2std_str(account));
        if (!jid->isBare()) {
            [self addResource: self.resourceString];
            std::string bareID = jid->toBare().toString();
            delete jid;
            jid = new JID(bareID);
        }
        resourceIndex = -1;
    }
    return self;
}

/*!
 * @brief Init with jid. 
 *
 * It will guarantee jid to be bare, and store resource to list if exists.
 */
- (id)initWithJID: (JID*)ajid
{
    /// FIXME: This is not safe. The JID used to init may not be released
    /// later.
    if (self = [super init]) {
        resources = [[NSMutableArray<NSString*> alloc] init];
        jid = ajid;
        if (!jid->isBare()) {
            [self addResource: self.resourceString];
            std::string bareID = jid->toBare().toString();
            delete jid;
            jid = new JID(bareID);
        }
        resourceIndex = -1;
    }
    return self;
}

- (void)dealloc
{
    delete jid;
}

#pragma mark - Wrap JID functions

/*!
 * @brief Validate JID.
 */
- (BOOL)valid
{
    if (jid->isValid())
        return YES;
    else
        return NO;
}

@synthesize resources;

/*!
 * @brief Add resource string to the end of resource list.
 *
 * @return The index of added resource.
 */
- (NSInteger)addResource: (NSString*)resource
{
    [resources addObject: resource];
    return resources.count - 1;
}

/*!
 * @brief Set used resource index.
 *
 * The default resource index is -1, which means there is
 * no resource used.
 *
 * :Important: the index should between 0(include) and
 * resources count, or will cause an runtime assert.
 */
- (void)setResourceIndex: (NSInteger)index
{
    if (index >= 0 && index < resources.count) {
        resourceIndex = index;
        JID *newjid = new JID(jid->getNode(), jid->getDomain(), NSString2std_str(resources[resourceIndex]));
        delete jid;
        jid = newjid;
    } else
        assert(false); // invalid index
}

/*!
 * @brief Set used resource index to defualt(-1).
 *
 * The default resource index is -1, which means there is
 * no resource used.
 */
- (void)resetResourceIndex
{
    resourceIndex = -1;
    JID *newjid = new JID(jid->getNode(), jid->getDomain());
    delete jid;
    jid = newjid;
}

#pragma mark - Account string access

- (NSString*)accountString
{
    return std_str2NSString(jid->toBare().toString());
}

- (NSString*)fullAccountString
{
    return std_str2NSString(jid->toString());
}

- (NSString*)resourceString
{
    // TODO: test what if the getResource return empty?
    return std_str2NSString(jid->getResource());
}

- (NSString*)nodeString
{
    return std_str2NSString(jid->getNode());
}

- (NSString*)domainString
{
    return std_str2NSString(jid->getDomain());
}

@end
