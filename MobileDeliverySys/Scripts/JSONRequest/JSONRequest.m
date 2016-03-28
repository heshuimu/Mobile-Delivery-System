//
//  JSONRequest.m
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/7.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import "JSONRequest.h"

@implementation JSONRequest

static JSONRequest* currentObj;

+(JSONRequest *)sharedInstance
{
    if (currentObj == nil) {
        currentObj= [[JSONRequest alloc] init];
    }
    return currentObj;
}

-(NSURLSession *)sessionInstance
{
    if (_currentSession == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _currentSession= [NSURLSession sessionWithConfiguration:config];
    }
    return _currentSession;
}

-(NSData *) CreateJSONwithDictionary:(NSDictionary*) dictionary
{
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    [self DebugPrintout:postData];
    return postData;
}

-(void) POSTJSONDataFromServerWithString:(NSString *)urlStr JSONData:(NSData*)JSONData target:(id<JSONRequestDelegate>)target
{
    NSLog(@"Operation Start");
    if(JSONData != nil)
    {
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        NSLog(@"%@", urlStr);
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:JSONData];
        NSLog(@"Operation Going In");
        NSURLSessionDataTask *postToServer = [[self sessionInstance] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              //------
        {
            if (error) {
                NSLog(@"Error");
                [target communicationFailedWithError:error];
            }
            else{
                [self DebugPrintout:data];
                [target recieveJSONReturn:data];
            }
        }
                                             //------
        ];
        [postToServer resume];
    }
}

-(void) GETJSONDataFromSeverWithString:(NSString *)urlStr target:(id<JSONRequestDelegate>)target
{
    NSLog(@"Operation Start");
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    NSLog(@"%@", urlStr);
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postToServer = [[self sessionInstance] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          //------
    {
        if (error) {
            NSLog(@"Error");
            [target communicationFailedWithError:error];
        }
        else{
            [self DebugPrintout:data];
            [target recieveJSONReturn:data];
        }
    }

                                          //------
    ];
    [postToServer resume];
}

-(NSString *)AppendGETParameterWithString:(NSString *)urlStr withKey:(NSString *)key withValue:(NSString *)value isFirstParameter:(BOOL)isFirstParameter
{
    if (isFirstParameter) {
        urlStr = [urlStr stringByAppendingString:@"?"];
    }
    else{
        urlStr = [urlStr stringByAppendingString:@"&"];
    }
    urlStr = [urlStr stringByAppendingString:key];
    urlStr = [urlStr stringByAppendingString:@"="];
    urlStr = [urlStr stringByAppendingString:value];
    return urlStr;
}

-(void) DebugPrintout:(NSData *) DataToPrint
{
    NSString *JSONString = [[NSString alloc] initWithData:DataToPrint encoding:NSUTF8StringEncoding];
    NSLog(@"%@", JSONString);
}

-(void) POSTJSONDataFromServerWithString:(NSString *)urlStr withImageData:(NSData *)data target:(id<JSONRequestDelegate>)target
{
    NSLog(@"Operation Start");
    if(data != nil)
    {
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        NSLog(@"%@", urlStr);
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"image/JPEG" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        NSLog(@"Operation Going In");
        NSURLSessionDataTask *postToServer = [[self sessionInstance] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              //------
                                              {
                                                  if (error) {
                                                      NSLog(@"Error");
                                                      [target communicationFailedWithError:error];
                                                  }
                                                  else{
                                                      [self DebugPrintout:data];
                                                      [target recieveJSONReturn:data];
                                                  }
                                              }
                                              //------
                                              ];
        [postToServer resume];
    }
    else
    {
        NSLog(@"Data is nil");
    }
}

@end
