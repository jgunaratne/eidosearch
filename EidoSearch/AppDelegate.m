//
//  AppDelegate.m
//  EidoSearch
//
//  Created by Junius Gunaratne on 1/29/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "AppDelegate.h"
#import "EDSAboutVC.h"
#import "EDSCommon.h"
#import "EDSWatchListVC.h"
#import "MaterialActivityIndicator.h"

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic, strong) EDSWatchListVC *dowVC;
@property (nonatomic, strong) EDSWatchListVC *watchListVC;
@property (nonatomic, strong) MDCActivityIndicator *activityIndicator;
@property (nonatomic, strong) NSMutableArray *symbols;
@property (nonatomic, strong) NSString *reqURL;
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) UIViewController *defaultVC;
@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  application.statusBarHidden = YES;

  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [self.window makeKeyAndVisible];
  
  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

  _defaultVC = [[UIViewController alloc] init];
  _defaultVC.view.backgroundColor = [EDSCommon darkGrayColor];
  _nav = [[UINavigationController alloc] initWithRootViewController:_defaultVC];
  _nav.navigationBar.barTintColor = [EDSCommon darkGrayColor];
  _nav.navigationBar.translucent = NO;
  self.window.rootViewController = _nav;
  self.symbols = [NSMutableArray arrayWithArray:[EDSCommon dowSymbols]];
  
  [self setupWatchLists];
  
  return YES;
}

- (void)setupWatchLists {
  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
  self.tabBarController.tabBar.barTintColor = [EDSCommon darkGrayColor];
  self.tabBarController.tabBar.translucent = NO;
  
  self.dowVC = [[EDSWatchListVC alloc] init];
  self.dowVC.title = @"Dow Jones";
  self.dowVC.symbols = self.symbols;
  self.dowVC.tabBarItem.image = [UIImage imageNamed:@"ic_dow_white"];
  
  self.watchListVC = [[EDSWatchListVC alloc] init];
  self.watchListVC.title = @"S&P 500";
  self.watchListVC.symbols = [NSMutableArray arrayWithArray:[EDSCommon sp500Symbols]];
  self.watchListVC.tabBarItem.image = [UIImage imageNamed:@"ic_location_city_white"];
  
//  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//  NSArray *savedSymbols = [prefs arrayForKey:@"EDSSavedSymbols"];
//  if (savedSymbols.count > 0) {
//    self.watchListVC.symbols = [NSMutableArray arrayWithArray:savedSymbols];
//  }
//
//  [EDSCommon runAnalyticsWithSymbols:self.watchListVC.symbols];

  EDSAboutVC *aboutVC = [[EDSAboutVC alloc] init];
  aboutVC.title = @"About EidoSearch";
  aboutVC.tabBarItem.image = [UIImage imageNamed:@"ic_eido_white"];
  
  self.tabBarController.viewControllers = @[ self.dowVC, self.watchListVC, aboutVC ];
  self.nav.viewControllers = @[ self.tabBarController ];
  [self.nav.visibleViewController.view setNeedsDisplay];
  
  UIView *tabLine =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 1)];
  tabLine.backgroundColor = [UIColor darkGrayColor];
  tabLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self.tabBarController.tabBar addSubview:tabLine];
}

@end
