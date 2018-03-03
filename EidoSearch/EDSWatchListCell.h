//
//  EDSWatchListCell.h
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/5/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "MaterialCollections.h"

@interface EDSWatchListCell : MDCCollectionViewTextCell

@property (nonatomic, assign) BOOL isDataUnavilable;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *projectedPriceLabel;
@property (nonatomic, strong) UILabel *priceDescLabel;
@property (nonatomic, strong) UILabel *projectedPriceDescLabel;
@property (nonatomic, strong) UIImageView *directionView;
@property (nonatomic, strong) NSNumber *projectedPrice;

- (void)populateContentWithSymbol:(NSString *)symbol
                             name:(NSString *)name
                   projectedPrice:(CGFloat)projPrice
                        lastPrice:(CGFloat)lastPrice
                   projectionType:(EDSProjection)projectionType;

@end
