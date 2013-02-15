//
//  DownloadManager.h
//  SimpleTableApp
//
//  Created by ITC on 11.02.13.
//  Copyright (c) 2013 ITC. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DownloadManager : NSURLConnection
- (void)imageForCode:(NSString*)code forCountry:(Contry*)country;
- (void)imageForCode:(NSString*)code toImageView:(UIImageView*)imageView;
- (void)setImageDataforCountry:(Contry*)contry;
@end
