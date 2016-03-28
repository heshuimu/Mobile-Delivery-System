//
//  JSONRequest.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/7.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@protocol JSONRequestDelegate <NSObject>

-(void)recieveJSONReturn:(NSData *)data;
-(void)communicationFailedWithError:(NSError *)err;

@end


@interface JSONRequest : NSObject

@property NSString *postString;
@property NSData *postData;
@property NSURLSession *currentSession;

+(JSONRequest *)sharedInstance;

-(NSData *) CreateJSONwithDictionary:(NSDictionary*) dictionary;
-(void) DebugPrintout:(NSData *) DataToPrint;
-(void) POSTJSONDataFromServerWithString:(NSString*)urlStr JSONData:(NSData*)JSONData target:(id<JSONRequestDelegate>)target;
-(void) GETJSONDataFromSeverWithString:(NSString *)urlStr target:(id<JSONRequestDelegate>)target;
-(void) POSTJSONDataFromServerWithString:(NSString *)urlStr withImageData:(NSData *)data target:(id<JSONRequestDelegate>)target;
-(NSString *)AppendGETParameterWithString:(NSString *)urlStr withKey:(NSString *)key withValue:(NSString *)value isFirstParameter:(BOOL)isFirstParameter;

@end
