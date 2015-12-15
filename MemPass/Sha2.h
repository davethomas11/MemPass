//
//  Sha2.h
//  MemPass
//
//  Created by David Thomas on 2015-12-10.
//  Copyright © 2015 Dave Anthony Thomas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sha2 : NSObject

-(NSString *)sha256:(NSString *)inputValue;

@end
