//
//  KeychainManager.m
//  OCGlobal
//
//  Created by Eddie on 2018/1/12.
//  Copyright © 2018年 yl. All rights reserved.
//

#import "KeychainManager.h"

@implementation KeychainManager

+ (instancetype)manager {
    static KeychainManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KeychainManager alloc] init];
    });
    return manager;
}

+ (BOOL)addKeychainAccount:(NSString *)account service:(NSString *)service saveValue:(NSString *)value {
    NSDictionary *query = @{(__bridge id)kSecAttrAccessible :(__bridge id)kSecAttrAccessibleWhenUnlocked,
                            (__bridge id)kSecClass          :(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecValueData      : [value dataUsingEncoding:NSUTF8StringEncoding],
                            (__bridge id)kSecAttrAccount    : account,
                            (__bridge id)kSecAttrService    : service
                            };
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query,nil);
    NSLog(@"%d--account:%@--service:%@--value:%@",status,account,service,value);
    return status == errSecSuccess;
}

+ (NSString *)selectKeychainAccount:(NSString *)account service:(NSString *)service {
    NSDictionary *query = @{(__bridge id)kSecClass       :(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData  :@YES,
                            (__bridge id)kSecMatchLimit  :(__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecAttrAccount :account,
                            (__bridge id)kSecAttrService :service
                            };
    CFTypeRef dataType = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataType);
    if (status == errSecSuccess) {
        NSString *pwd = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataType) encoding:NSUTF8StringEncoding];
        NSLog(@"%@",pwd);
        return pwd;
    }else {
        return @"";
    }
}

+ (BOOL)deleteKeyChainAccount:(NSString *)account service:(NSString *)service {
    NSDictionary *query = @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount:account,
                            (__bridge id)kSecAttrService:service
                            };
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);
    return status == errSecSuccess;
}

+ (BOOL)updateKeyChainAccount:(NSString *)accont service:(NSString *)service value:(NSString *)value {
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount:accont,
                            (__bridge id)kSecAttrService:service,
                            };
    NSDictionary *update = @{(__bridge id)kSecValueData:[value dataUsingEncoding:NSUTF8StringEncoding]};
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    return status == errSecSuccess;
}

+ (BOOL)existKeychainAccount:(NSString *)account service:(NSString *)service {
    return [[self class] selectKeychainAccount:account service:service].length > 0 ? true : false;
}

- (void)addKeychainWord {
    NSDictionary *query = @{(__bridge id)kSecAttrAccessible:(__bridge id)kSecAttrAccessibleWhenUnlocked,
                            (__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecValueData :[@"12345" dataUsingEncoding:NSUTF8StringEncoding],
                            (__bridge id)kSecAttrAccount :@"bobo shipin",
                            (__bridge id)kSecAttrService: @"loginPassword"};
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query,nil);
    NSLog(@"%d--bobo shipin--loginPassword",status);
}

- (BOOL)selectKeyChainWord {
    NSDictionary *query = @{(__bridge id)kSecClass:(__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData :@YES,
                            (__bridge id)kSecMatchLimit:(__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecAttrAccount:@"bobo shipin",
                            (__bridge id)kSecAttrService :@"loginPassword"
                            };
    CFTypeRef dataType = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataType);
    if (status == errSecSuccess) {
        NSString *pwd = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataType) encoding:NSUTF8StringEncoding];
        NSLog(@"%@",pwd);
        return true;
    }else {
        return false;
    }
}
@end
