//
//  ViewController.h
//  EidoSearch
//
//  Created by Junius Gunaratne on 1/29/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MaterialCollections.h"

@interface EDSWatchListVC : MDCCollectionViewController

@property (nonatomic) BOOL editableList;
@property (nonatomic, strong) NSMutableArray *symbols;
@property (nonatomic, strong) NSMutableArray *results;

- (void)updateWatchList;

- (void)showLoadingIndicator;

- (void)hideLoadingIndicator;

@end
