//
//  EDSWatchListCell.m
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/5/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "EDSCommon.h"
#import "EDSWatchListCell.h"
#import "MaterialPalettes.h"

@implementation EDSWatchListCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  self.contentView.backgroundColor = [EDSCommon darkGrayColor];

  self.directionView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_trending_flat_white"]];
  self.directionView.contentMode = UIViewContentModeScaleAspectFit;
  [self.contentView addSubview:self.directionView];
  
  self.percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.percentLabel.font = [UIFont systemFontOfSize:10 weight:0];
  self.percentLabel.textColor = [UIColor whiteColor];
  self.percentLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:self.percentLabel];
  
  self.priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.priceLabel.font = [UIFont systemFontOfSize:24 weight:0];
  self.priceLabel.textColor = [UIColor whiteColor];
  self.priceLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:self.priceLabel];
  
  self.projectedPriceDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.projectedPriceDescLabel.font = [UIFont systemFontOfSize:10 weight:0];
  self.projectedPriceDescLabel.textColor = [UIColor whiteColor];
  self.projectedPriceDescLabel.text = @"Projected Price";
  self.projectedPriceDescLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:self.projectedPriceDescLabel];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.textLabel.textColor = [UIColor whiteColor];
  self.textLabel.font = [UIFont systemFontOfSize:24 weight:0];
  self.detailTextLabel.textColor = [UIColor whiteColor];
  self.detailTextLabel.font = [UIFont systemFontOfSize:10 weight:0];
  
  self.detailTextLabel.frame =
      CGRectMake(self.detailTextLabel.frame.origin.x,
                 self.detailTextLabel.frame.origin.y,
                 160,
                 self.detailTextLabel.frame.size.height);
  self.detailTextLabel.clipsToBounds = YES;
  self.directionView.frame =
      CGRectMake(self.contentView.frame.size.width - self.directionView.frame.size.width - 10,
                 0,
                 self.directionView.frame.size.width,
                 self.contentView.frame.size.height - 20);
  self.percentLabel.frame =
      CGRectMake(0,
                 37,
                 self.contentView.frame.size.width - 10,
                 self.contentView.frame.size.height - 51);
  self.priceLabel.frame =
      CGRectMake(0,
                 0,
                 self.contentView.frame.size.width - 50,
                 self.contentView.frame.size.height - 18);
  self.projectedPriceDescLabel.frame =
      CGRectMake(0,
                 37,
                 self.contentView.frame.size.width - 50,
                 self.contentView.frame.size.height - 51);
}

- (void)setProjectedPrice:(NSNumber *)projectedPrice {
  _projectedPrice = projectedPrice;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  self.priceLabel.hidden = NO;
  self.priceLabel.text = @"";
  self.percentLabel.text = @"";
  self.projectedPriceDescLabel.text = @"";
}

- (void)populateContentWithSymbol:(NSString *)symbol
                             name:(NSString *)name
                   projectedPrice:(CGFloat)projPrice
                        lastPrice:(CGFloat)lastPrice
                   projectionType:(EDSProjection)projectionType {
  self.symbol = symbol;
  
  @try {
    self.textLabel.text = self.symbol;
  }
  @catch (NSException *exception) {
    NSLog(@"Invalid symbol.");
  }
  
  @try {
    self.detailTextLabel.text = name;
  }
  @catch (NSException *exception) {
    NSLog(@"Invalid name.");
  }
  
  @try {
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", projPrice];
  }
  @catch (NSException *exception) {
    NSLog(@"Invalid price.");
  }
  
  if (projPrice == 0) {
    self.priceLabel.hidden = YES;
    self.projectedPriceDescLabel.text = @"";
    self.percentLabel.text = @"Data Unavailable";
    self.isDataUnavilable = YES;
    self.directionView.image = [UIImage imageNamed:@"ic_warning_white"];
    self.directionView.image =
        [self.directionView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.directionView setTintColor:[MDCPalette yellowPalette].accent400];
  } else {
    NSString *projectionText = @"";
    switch (projectionType) {
      case EDSProjectionLast:
        projectionText = @"Last Price";
        break;
      case EDSProjection1D:
        projectionText = @"1 Day Projection";
        break;
      case EDSProjection5D:
        projectionText = @"5 Day Projection";
        break;
      case EDSProjection1M:
        projectionText = @"1 Month Projection";
        break;
      case EDSProjection3M:
        projectionText = @"3 Month Projection";
        break;
      case EDSProjection6M:
        projectionText = @"6 Month Projection";
        break;
      case EDSProjection1Y:
        projectionText = @"1 Year Projection";
        break;
    }
    self.projectedPriceDescLabel.text = projectionText;
    self.isDataUnavilable = NO;
    CGFloat percent = (projPrice / lastPrice - 1) * 100;
    self.percentLabel.text = [NSString stringWithFormat:@"%.1f%%", percent];
    if (percent > 0.1) {
      self.directionView.image = [UIImage imageNamed:@"ic_trending_up_white"];
      self.directionView.image =
          [self.directionView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.directionView setTintColor:[MDCPalette greenPalette].accent400];
    } else if (percent < -0.1) {
      self.directionView.image = [UIImage imageNamed:@"ic_trending_down_white"];
      self.directionView.image =
          [self.directionView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
      [self.directionView setTintColor:[MDCPalette redPalette].accent400];
    } else {
      self.directionView.image = [UIImage imageNamed:@"ic_trending_flat_white"];
    }
  }
}

@end
