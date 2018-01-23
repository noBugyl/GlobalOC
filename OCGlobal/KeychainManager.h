//
//  KeychainManager.h
//  OCGlobal
//
//  Created by Eddie on 2018/1/12.
//  Copyright © 2018年 yl. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface KeychainManager : NSObject
+ (instancetype)manager;
- (void)addKeychainWord;
- (BOOL)selectKeyChainWord;

+ (NSString *)selectKeychainAccount:(NSString *)account service:(NSString *)service;
+ (BOOL)existKeychainAccount:(NSString *)account service:(NSString *)service;
+ (BOOL)addKeychainAccount:(NSString *)account service:(NSString *)service saveValue:(NSString *)value;
+ (BOOL)deleteKeyChainAccount:(NSString *)account service:(NSString *)service;
+ (BOOL)updateKeyChainAccount:(NSString *)accont service:(NSString *)service value:(NSString *)value;
@end
