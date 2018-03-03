//
//  EDSCommon.h
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/4/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, EDSProjection) {
  EDSProjectionLast,
  EDSProjection1D,
  EDSProjection5D,
  EDSProjection1M,
  EDSProjection3M,
  EDSProjection6M,
  EDSProjection1Y
};

@interface EDSCommon : NSObject

+ (NSString *)apiKey;

+ (NSString *)listURL;

+ (NSString *)chartURL;

+ (NSString *)uniqueIdentifier;

+ (NSArray *)dowSymbols;

+ (NSArray *)sp500Symbols;

+ (UIColor *)grayColor;

+ (UIColor *)darkGrayColor;

+ (UIColor *)eidoBlueColor;

+ (UIColor *)eidoPurpleColor;

+ (void)requestListWithSymbols:(NSArray *)symbols
               completionBlock:(void (^)(NSMutableArray *results))completionBlock
                    errorBlock:(void (^)(NSError *error))errorBlock;

+ (void)requestChartWithSymbol:(NSString *)symbol
                     indexPath:(NSIndexPath *)indexPath
                    projection:(NSString *)projection
               completionBlock:(void (^)(NSData *data,
                                         NSString *symbol,
                                         NSIndexPath *indexPath))completionBlock
                    errorBlock:(void (^)(NSError *error))errorBlock;

@end
