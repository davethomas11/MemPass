//
//  Sha2.m
//  MemPass
//
//  Created by David Thomas on 2015-12-10.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

#import "Sha2.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Sha2

-(NSString *)sha256:(NSString *)input {
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
    
}

@end
