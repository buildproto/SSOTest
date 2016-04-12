//
//  SharedLoginManager.m
//  SSOTester
//
//  Created by Andres El Ropero on 4/12/16.
//  Copyright © 2016 Proto. All rights reserved.
//

#import "SharedLoginManager.h"

// 3rd Party
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

// Helpers
#import "UICKeychainStore.h"

static NSString * const kSharedKeychainKeyFacebookAccessToken = @"FacebookAccessToken";
static NSString * const kSharedKeychainKeyFacebookAppID = @"FacebookAppID";
static NSString * const kSharedKeychainKeyFacebookDeclinedPermissions = @"FacebookDeclinedPermissions";
static NSString * const kSharedKeychainKeyFacebookPermissions = @"FacebookPermissions";
static NSString * const kSharedKeychainKeyFacebookTokenString = @"FacebookTokenString";
static NSString * const kSharedKeychainKeyFacebookUserID = @"FacebookUserID";
static NSString * const kSharedKeychainKeyFacebookExpirationDate = @"FacebookExpirationDate";
static NSString * const kSharedKeychainKeyFacebookRefreshData = @"FacebookRefreshDate";
static NSString * const kSharedKeychainServiceFacebook = @"Facebook";

@implementation SharedLoginManager

+ (SharedLoginManager *)sharedInstance
{
    static SharedLoginManager *__sharedInstance = nil;
    static dispatch_once_t __onceToken;
    dispatch_once(&__onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    return __sharedInstance;
}

#pragma mark - Facebook Helpers
- (void)storeFacebookAccessToken:(FBSDKAccessToken *)token
{   /*
    [encoder encodeObject:self.appID forKey:FBSDK_ACCESSTOKEN_APPID_KEY];
    [encoder encodeObject:self.declinedPermissions forKey:FBSDK_ACCESSTOKEN_DECLINEDPERMISSIONS_KEY];
    [encoder encodeObject:self.permissions forKey:FBSDK_ACCESSTOKEN_PERMISSIONS_KEY];
    [encoder encodeObject:self.tokenString forKey:FBSDK_ACCESSTOKEN_TOKENSTRING_KEY];
    [encoder encodeObject:self.userID forKey:FBSDK_ACCESSTOKEN_USERID_KEY];
    [encoder encodeObject:self.expirationDate forKey:FBSDK_ACCESSTOKEN_EXPIRATIONDATE_KEY];
    [encoder encodeObject:self.refreshDate forKey:FBSDK_ACCESSTOKEN_REFRESHDATE_KEY];
    */
    /*
    [UICKeyChainStore setString:token.appID forKey:kSharedKeychainKeyFacebookAppID service:kSharedKeychainServiceFacebook];
    [UICKeyChainStore setString:token.declinedPermissions forKey:kSharedKeychainKeyFacebookDeclinedPermissions service:kSharedKeychainServiceFacebook];
    [UICKeyChainStore setString:token.permissions forKey:kSharedKeychainKeyFacebookPermissions service:kSharedKeychainServiceFacebook];
    [UICKeyChainStore setString:token.appID forKey:kSharedKeychainKeyFacebookAppID service:kSharedKeychainServiceFacebook];
    [UICKeyChainStore setString:token.appID forKey:kSharedKeychainKeyFacebookAppID service:kSharedKeychainServiceFacebook];
    [UICKeyChainStore setString:token.appID forKey:kSharedKeychainKeyFacebookAppID service:kSharedKeychainServiceFacebook];
    [UICKeyChainStore setString:token.appID forKey:kSharedKeychainKeyFacebookAppID service:kSharedKeychainServiceFacebook];*/
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:token];
    [UICKeyChainStore setData:data forKey:kSharedKeychainKeyFacebookAccessToken service:kSharedKeychainServiceFacebook];
    NSLog(@"archived and saved token with string: %@", token.tokenString);
}

- (void)clearFacebookAccessToken
{
    [UICKeyChainStore removeItemForKey:kSharedKeychainKeyFacebookAccessToken service:kSharedKeychainServiceFacebook];
}

- (FBSDKAccessToken *)loadFacebookAccessToken
{
    NSData *data = [UICKeyChainStore dataForKey:kSharedKeychainKeyFacebookAccessToken service:kSharedKeychainServiceFacebook];
    FBSDKAccessToken *token = (FBSDKAccessToken *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"unarchived token with string: %@", token.tokenString);
    return token;
}

@end
