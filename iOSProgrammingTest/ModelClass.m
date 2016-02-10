//
//  ModelClass.m
//  iOSProgrammingTest
//
//  Created by Augustus Wilson on 2/9/16.
//  Copyright © 2016 Augustus Wilson. All rights reserved.
//

#import "ModelClass.h"

@implementation ModelClass
-(instancetype)initWithResponse:(NSDictionary*)response{
    self = [super init];
    if(!self){
        return nil;
    }
    
    return self;
}
@end
/*-(instancetype)initWithResponse:(NSDictionary *)response{
 
 self = [super init];
 
 if (!self) {
 return nil;
 }
 
 
 
 self.title = [response objectForKey:@"title"];
 self.message = [response objectForKey:@"description"];
 self.url = [NSURL URLWithString:[response objectForKey:@"url"]];
 
 return self;
 }
 
*/