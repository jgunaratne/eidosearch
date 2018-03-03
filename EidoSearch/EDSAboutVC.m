//
//  EDSAboutVC.m
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/5/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "EDSAboutVC.h"
#import "EDSCommon.h"

@interface EDSAboutVC ()

@property (nonatomic, strong) UITextView *textView;

@end


@implementation EDSAboutVC

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
  UIImage *hero = [UIImage imageNamed:@"Hero"];
  UIImageView *heroImageView = [[UIImageView alloc] initWithImage:hero];
  heroImageView.frame = self.view.frame;
  heroImageView.contentMode = UIViewContentModeScaleAspectFill | UIViewContentModeLeft;
  heroImageView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  heroImageView.alpha = 0.5f;
  [self.view addSubview:heroImageView];
  
  UIImage *logo = [UIImage imageNamed:@"EidoSearchLogoWhite"];
  UIImageView *logoView = [[UIImageView alloc] initWithImage:logo];
  logoView.frame = CGRectMake(0, 10, 280, 100);
  logoView.contentMode = UIViewContentModeScaleAspectFit;
  [self.view addSubview:logoView];
  
  self.textView = [[UITextView alloc] init];
  self.textView.editable = NO;
  self.textView.backgroundColor = [UIColor clearColor];
  self.textView.textColor = [UIColor whiteColor];
  NSString *desc = @"EidoSearch uses patented pattern matching technology to project probable event outcomes and find relationships in Big Data.\n\nEidoSearch identifies data series patterns in financial data. We can search for multiple disparate patterns simultaneously. Our proprietary search algorithms find similar conditions in any size database returning only the most relevant results. These results are analyzed, and a probabilistic range of outcomes is generated.\n\nThese data-based predictions contain unique insight that cannot be combined through any other method. As new information becomes available, it is immediately taken into account. This is not traditional modeling. This is data-based search, an evolution in prediction.";
  NSDictionary *attrs = @{ NSForegroundColorAttributeName : [UIColor whiteColor] };
  self.textView.attributedText = [[NSAttributedString alloc] initWithString:desc attributes:attrs];
  [self.view addSubview:self.textView];
}

- (void)viewWillLayoutSubviews {
  self.view.backgroundColor = [UIColor blackColor];
  self.textView.frame = CGRectMake(20,
                                   100,
                                   self.view.frame.size.width - 40,
                                   self.view.frame.size.height - 120);
}

@end
