//
//  ViewController.m
//  EidoSearch
//
//  Created by Junius Gunaratne on 1/29/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "EDSCommon.h"
#import "EDSWatchListCell.h"
#import "EDSWatchListVC.h"
#import "EidoSearch-Swift.h"
#import "MaterialActivityIndicator.h"
#import "MaterialAppBar.h"
#import "MaterialSnackbar.h"

static CGFloat const kActivityIndicatorRadius = 72.f;
static CGFloat const kHeaderMinHeight = 80.f;
static NSString *const kReusableIdentifierItem = @"kEDSWatchListCellIdentifier";

@interface EDSWatchListVC ()

@property (nonatomic) EDSProjection projectionType;
@property (nonatomic, strong) MDCActivityIndicator *activityIndicator;
@property (nonatomic, strong) MDCAppBar *appBar;
@property (nonatomic, strong) NSString *lastUpdated;
@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) UIBarButtonItem *editButton;
@property (nonatomic, strong) UIBarButtonItem *timeButton;
@property (nonatomic, strong) UIBarButtonItem *updateButton;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIView *loadingView;

@end

@implementation EDSWatchListVC {
  NSMutableArray *_content;
}

- (instancetype)init {
  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:layout];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)commonInit {
  _editableList = NO;
  _symbols = [NSMutableArray array];
  _projectionType = EDSProjection1M;
  _loadingView = [[UIView alloc] init];
  _loadingView.autoresizingMask =
      UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  _loadingView.hidden = YES;
  
  CGRect activityIndicator = CGRectMake(0,
                                        0,
                                        kActivityIndicatorRadius * 2,
                                        kActivityIndicatorRadius * 2);
  _activityIndicator = [[MDCActivityIndicator alloc] initWithFrame:activityIndicator];
  _activityIndicator.radius = kActivityIndicatorRadius;
  _activityIndicator.cycleColors = @[ [EDSCommon eidoBlueColor], [EDSCommon eidoPurpleColor] ];
  _activityIndicator.strokeWidth = 8.f;
      _activityIndicator.indicatorMode = MDCActivityIndicatorModeIndeterminate;
  _activityIndicator.autoresizingMask =
      (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
       UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
  [_loadingView addSubview:_activityIndicator];

  _appBar = [[MDCAppBar alloc] init];
  [self addChildViewController:_appBar.headerViewController];
  _appBar.headerViewController.headerView.backgroundColor = [EDSCommon darkGrayColor];
  _appBar.navigationBar.tintColor = [UIColor whiteColor];
  _appBar.navigationBar.titleTextAttributes =
      @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  _appBar.navigationBar.titleView.hidden = YES;

  UIImage *logo = [UIImage imageNamed:@"EidoSearchLogo"];
  self.logoImageView = [[UIImageView alloc] initWithImage:logo];
  self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
  self.appBar.headerViewController.headerView.minimumHeight = kHeaderMinHeight;
  [_appBar.headerViewController.headerView addSubview:self.logoImageView];
}

- (void)addButtonBarItems {
  NSMutableArray *buttonBarItems = [NSMutableArray array];
  UIImage *timeIcon = [UIImage imageNamed:@"ic_filter_1_white"];
  self.timeButton =
      [[UIBarButtonItem alloc] initWithImage:timeIcon
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(didSelectTime:)];
  [buttonBarItems addObject:self.timeButton];

  UIImage *updateIcon = [UIImage imageNamed:@"ic_update_white"];
  self.updateButton =
      [[UIBarButtonItem alloc] initWithImage:updateIcon
                                       style:UIBarButtonItemStyleDone
                                      target:self
                                      action:@selector(didSelectUpdate:)];
  [buttonBarItems addObject:self.updateButton];
  
  if (self.editableList) {
    UIImage *editIcon = [UIImage imageNamed:@"ic_mode_edit_white"];
    self.editButton =
        [[UIBarButtonItem alloc] initWithImage:editIcon
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(didSelectEdit:)];
    [buttonBarItems addObject:self.editButton];
    
    UIImage *addIcon = [UIImage imageNamed:@"ic_playlist_add_white"];
    self.addButton =
        [[UIBarButtonItem alloc] initWithImage:addIcon
                                         style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(didSelectSearch)];
    [buttonBarItems addObject:self.addButton];
  }
  
  self.navigationItem.rightBarButtonItems = buttonBarItems;
}

- (void)didSelectSearch {
  NSString *addMessage = @"Enter a S&P 500 ticker symbol to add to the list.";
  UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:@"Add Ticker"
                                          message:addMessage
                                   preferredStyle:UIAlertControllerStyleAlert];
  id addAction = ^(UIAlertAction *action) {
    UITextField *symbol = alert.textFields.firstObject;
    [self.symbols addObject:[symbol.text uppercaseString]];
    [self updateWatchList];
  };
  UIAlertAction *addButton =
      [UIAlertAction actionWithTitle:@"Add"
                               style:UIAlertActionStyleDefault
                             handler:addAction];
  UIAlertAction *cancelButton =
      [UIAlertAction actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action) {
                               
                             }];
  [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
    textField.placeholder = @"NFLX";
  }];
  [alert addAction:addButton];
  [alert addAction:cancelButton];
  [self presentViewController:alert animated:YES completion:nil];
}

- (void)didSelectTime:(id)sender {
  UIAlertController *sheet =
      [UIAlertController alertControllerWithTitle:nil
                                          message:nil
                                   preferredStyle:UIAlertControllerStyleActionSheet];
  [sheet addAction:[UIAlertAction actionWithTitle:@"1 Day Projection"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *_Nonnull action) {
                                            self.timeButton.image =
                                                [UIImage imageNamed:@"ic_looks_1_white"];
                                            self.projectionType = EDSProjection1D;
                                            [self.collectionView reloadData];
                                          }]];
  [sheet addAction:[UIAlertAction actionWithTitle:@"5 Day Projection"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *_Nonnull action) {
                                            self.timeButton.image =
                                                [UIImage imageNamed:@"ic_looks_5_white"];
                                            self.projectionType = EDSProjection5D;
                                            [self.collectionView reloadData];
                                          }]];
  [sheet addAction:[UIAlertAction actionWithTitle:@"1 Month Projection"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *_Nonnull action) {
                                            self.timeButton.image =
                                                [UIImage imageNamed:@"ic_filter_1_white"];
                                            self.projectionType = EDSProjection1M;
                                            [self.collectionView reloadData];
                                          }]];
  [sheet addAction:[UIAlertAction actionWithTitle:@"3 Month Projection"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *_Nonnull action) {
                                            self.timeButton.image =
                                                [UIImage imageNamed:@"ic_filter_3_white"];
                                            self.projectionType = EDSProjection3M;
                                            [self.collectionView reloadData];
                                          }]];
  [sheet addAction:[UIAlertAction actionWithTitle:@"6 Month Projection"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *_Nonnull action) {
                                            self.timeButton.image =
                                                [UIImage imageNamed:@"ic_filter_6_white"];
                                            self.projectionType = EDSProjection6M;
                                            [self.collectionView reloadData];
                                          }]];
  [sheet addAction:[UIAlertAction actionWithTitle:@"1 Year Projection"
                                            style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction *_Nonnull action) {
                                            self.timeButton.image =
                                                [UIImage imageNamed:@"ic_filter_1_white"];
                                            self.projectionType = EDSProjection1Y;
                                            [self.collectionView reloadData];
                                          }]];
  [self presentViewController:sheet animated:YES completion:nil];
}

- (void)didSelectUpdate:(id)sender {
  [self updateWatchList];
}

- (void)didSelectEdit:(id)sender {
  BOOL isEditing = self.editor.isEditing;
  if (isEditing) {
    self.editButton.image = [UIImage imageNamed:@"ic_mode_edit_white"];
  } else {
    self.editButton.image = [UIImage imageNamed:@"ic_done_white"];
  }
  [self.editor setEditing:!isEditing animated:YES];
}

- (void)updateWatchList {
  [self showLoadingIndicator];
  id successBlock = ^(NSMutableArray *results) {
    [self hideLoadingIndicator];
    if (results) {
      self.results = results;
      [self loadContent];
      [self.collectionView reloadData];
      MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
      message.text = [@"Data Last Updated " stringByAppendingString:self.lastUpdated];
      message.duration = 1.f;
      [MDCSnackbarManager showMessage:message];
    }
  };
  id errorBlock = ^(NSError *error) {
    [self hideLoadingIndicator];
    [self displayServerError];
  };
  [EDSCommon requestListWithSymbols:self.symbols
                    completionBlock:successBlock
                         errorBlock:errorBlock];
}

- (void)displayServerError {
  NSString *alertString =
      @"We're having trouble communicating with EidoSearch servers. Please try again later.";
  UIAlertView *alert =
      [[UIAlertView alloc] initWithTitle:@"Server Error"
                                 message:alertString
                                delegate:self
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil];
  [alert show];
}

- (void)loadContent {
  NSMutableArray *updatedSymbols = [NSMutableArray array];
  _content = [NSMutableArray array];
  for (NSInteger i = 0; i < _results.count; i++) {
    NSDictionary *item = _results[i];
    if (item) {
      NSString *message = item[@"message"];
      if (message) {
        [self.symbols removeObjectAtIndex:i];
      } else {
        NSString *name = item[@"name"];
        NSString *symbol = item[@"symbol"];
        [updatedSymbols addObject:symbol];
        _lastUpdated = item[@"lastUpdated"];
        NSNumber *lastPrice = item[@"lastPrice"];
        NSArray *projections = item[@"projections"];
        NSDictionary *itemContent = @{ @"name" : name,
                                       @"symbol" : symbol,
                                       @"lastPrice" : lastPrice,
                                       @"projections" : projections };
        [_content addObject:itemContent];
      }
    }
  }
  
  if (self.editableList) {
    // Update to valid symbols returned by server.
    self.symbols = updatedSymbols;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.symbols forKey:@"EDSSavedSymbols"];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.collectionView registerClass:[EDSWatchListCell class]
          forCellWithReuseIdentifier:kReusableIdentifierItem];

  self.appBar.headerViewController.headerView.trackingScrollView = self.collectionView;
  [self.appBar addSubviewsToParent];
  
  self.styler.separatorColor = [UIColor darkGrayColor];
  self.styler.cellStyle = MDCCollectionViewCellStyleDefault;
  self.styler.gridPadding = 0;
  self.collectionView.backgroundColor = [EDSCommon darkGrayColor];
  [self addButtonBarItems];

  [self updateWatchList];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  self.appBar.navigationBar.title = @"";
  self.logoImageView.hidden = NO;
  CGFloat logoWidth = 200.f;
  CGFloat adjLogoWidth = self.view.frame.size.width * 0.3f;
  if (self.editableList) {
    logoWidth = logoWidth > adjLogoWidth ? adjLogoWidth : logoWidth;
    self.logoImageView.hidden = YES;
  }

  CGFloat logoHeight = 55;
  CGFloat logoTop = self.appBar.headerViewController.headerView.bounds.size.height - logoHeight;
  self.logoImageView.frame = CGRectMake(8, logoTop, logoWidth, logoHeight);
  self.logoImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  CGFloat topInset = 0;
  if (@available(iOS 11.0, *)) {
    topInset += self.additionalSafeAreaInsets.top;
  }
  [self.collectionView setContentInset:UIEdgeInsetsMake(kHeaderMinHeight + topInset, 0, 0, 0)];
  [self setAutomaticallyAdjustsScrollViewInsets:NO];
  
  _loadingView.frame = self.view.frame;
  [self.view addSubview:_loadingView];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [self.collectionView.collectionViewLayout invalidateLayout];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
  return self.appBar.headerViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  return self.appBar.headerViewController;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return [_content count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  EDSWatchListCell *cell =
      [collectionView dequeueReusableCellWithReuseIdentifier:kReusableIdentifierItem
                                                forIndexPath:indexPath];

  NSDictionary *item = _content[indexPath.item];
  NSString *symbol = item[@"symbol"];
  NSString *name = item[@"name"];
  NSNumber *lastPrice = item[@"lastPrice"];
  NSNumber *projectedPrice = [NSNumber numberWithFloat:0];

  NSNumber *num;
  switch (self.projectionType) {
    case EDSProjectionLast:
      num = lastPrice;
    case EDSProjection1D:
      num = item[@"projections"][@"d1"];
      break;
    case EDSProjection5D:
      num = item[@"projections"][@"d5"];
      break;
    case EDSProjection1M:
      num = item[@"projections"][@"m1"];
      break;
    case EDSProjection3M:
      num = item[@"projections"][@"m3"];
      break;
    case EDSProjection6M:
      num = item[@"projections"][@"m6"];
      break;
    case EDSProjection1Y:
      num = item[@"projections"][@"y1"];
      break;
  }
  if (num != (NSNumber *)[NSNull null]) {
    projectedPrice = num;
  }
  if (lastPrice == (NSNumber *)[NSNull null]) {
    lastPrice = [NSNumber numberWithFloat:0];
  }
  [cell populateContentWithSymbol:symbol
                             name:name
                   projectedPrice:projectedPrice.floatValue
                        lastPrice:lastPrice.floatValue
                   projectionType:self.projectionType];
  return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(collectionView.frame.size.width, MDCCellDefaultTwoLineHeight);
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
  if (!self.editor.isEditing) {
    EDSWatchListCell *cell = (EDSWatchListCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!cell.isDataUnavilable) {
      NSString *projStr = @"d1";
      switch (self.projectionType) {
        case EDSProjectionLast:
        case EDSProjection1D:
          projStr = @"d1";
          break;
        case EDSProjection5D:
          projStr = @"d5";
          break;
        case EDSProjection1M:
          projStr = @"m1";
          break;
        case EDSProjection3M:
          projStr = @"m3";
          break;
        case EDSProjection6M:
          projStr = @"m6";
          break;
        case EDSProjection1Y:
          projStr = @"y1";
          break;
      }
      [self showLoadingIndicator];
      id successBlock = ^(NSData *data, NSString *symbol, NSIndexPath *iPath) {
        NSDictionary *predictions =
        [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        EDSChartVC *edsChartVC = [[EDSChartVC alloc] init];
        [edsChartVC setResult:_results[iPath.item]];
        [edsChartVC setPrediction:predictions];
        [edsChartVC setProjectionType:self.projectionType];

        [self.navigationController pushViewController:edsChartVC animated:YES];
        [self hideLoadingIndicator];
      };
      id errorBlock = ^(NSError *error) {
        [self hideLoadingIndicator];
        [self displayServerError];
      };
      [EDSCommon requestChartWithSymbol:cell.symbol
                              indexPath:indexPath
                             projection:projStr
                        completionBlock:successBlock
                             errorBlock:errorBlock];
    }
  }
}

- (void)showLoadingIndicator {
  _loadingView.hidden = NO;
  [_activityIndicator startAnimating];
}

- (void)hideLoadingIndicator {
  [_activityIndicator stopAnimating];
  _loadingView.hidden = YES;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == self.appBar.headerViewController.headerView.trackingScrollView) {
    [self.appBar.headerViewController.headerView trackingScrollViewDidScroll];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (scrollView == self.appBar.headerViewController.headerView.trackingScrollView) {
    [self.appBar.headerViewController.headerView trackingScrollViewDidEndDecelerating];
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  MDCFlexibleHeaderView *headerView = self.appBar.headerViewController.headerView;
  if (scrollView == headerView.trackingScrollView) {
    [headerView trackingScrollViewDidEndDraggingWillDecelerate:decelerate];
  }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
  MDCFlexibleHeaderView *headerView = self.appBar.headerViewController.headerView;
  if (scrollView == headerView.trackingScrollView) {
    [headerView trackingScrollViewWillEndDraggingWithVelocity:velocity
                                          targetContentOffset:targetContentOffset];
  }
}

#pragma mark - <MDCCollectionViewEditingDelegate>

- (BOOL)collectionViewAllowsEditing:(UICollectionView *)collectionView {
  return YES;
}

- (BOOL)collectionViewAllowsReordering:(UICollectionView *)collectionView {
  return YES;
}

- (BOOL)collectionViewAllowsSwipeToDismissItem:(UICollectionView *)collectionView {
  return self.editor.isEditing;
}

- (void)collectionView:(UICollectionView *)collectionView
    willDeleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
  // First sort reverse order then remove. This is done because when we delete an index path the
  // higher rows shift down, altering the index paths of those that we would like to delete in the
  // next iteration of this loop.
  NSArray *sortedArray = [indexPaths sortedArrayUsingSelector:@selector(compare:)];
  for (NSIndexPath *indexPath in [sortedArray reverseObjectEnumerator]) {
    [_content removeObjectAtIndex:indexPath.item];
    [_symbols removeObjectAtIndex:indexPath.item];

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:self.symbols forKey:@"EDSSavedSymbols"];
  }
  [self updateWatchList];
}

- (void)collectionView:(UICollectionView *)collectionView
    willMoveItemAtIndexPath:(NSIndexPath *)indexPath
                toIndexPath:(NSIndexPath *)newIndexPath {
  if (indexPath.section == newIndexPath.section) {
    // Exchange data within same section.
    [_content exchangeObjectAtIndex:indexPath.item withObjectAtIndex:newIndexPath.item];
  }
}

#pragma mark - <MDCCollectionViewStylingDelegate>

- (UIColor *)collectionView:(UICollectionView *)collectionView
    cellBackgroundColorAtIndexPath:(NSIndexPath *)indexPath {
  return [EDSCommon darkGrayColor];
}

@end
