//
//  DownloadManager.m
//  SimpleTableApp
//
//  Created by ITC on 11.02.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager()
@property Contry* country;
@property NSMutableData* imageData;
@property UIImageView* imageView;

@end

@implementation DownloadManager

- (void)imageForCode:(NSString*)code forCountry:(Contry*)country
{
    self.country = country;
    [self imageForCode:code];
}

- (void)imageForCode:(NSString*)code toImageView:(UIImageView*)imageView
{
    self.imageView = imageView;
    [self imageForCode:code];
}

- (void)imageForCode:(NSString*)code
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString* path = @"http://flagpedia.net/data/flags/normal/";
    NSString* file = [code stringByAppendingPathExtension:@"png"];
    NSURL *url = [NSURL URLWithString:[path stringByAppendingString:file]];
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    NSURLConnection *theConnection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    if (theConnection) {
        self.imageData = [NSMutableData data];
    } else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"Connection failed");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.imageView.image = [UIImage imageWithData:self.imageData];
    [self getDataforCountry:self.country];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)getDataforCountry:(Contry*)contry
{
    contry.flagImage = [NSData dataWithData:self.imageData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadComplete" object:self];
}

@end
