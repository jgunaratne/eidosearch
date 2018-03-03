//
//  EDSCommon.m
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/4/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "EDSCommon.h"
#import "EDSCommon+Private.h"

@interface EDSCommon ()

@end

@implementation EDSCommon

+ (NSString *)apiKey {
  return kAPIKey;
}

+ (NSString *)listURL {
  return kListURL;
}

+ (NSString *)chartURL {
  return kChartURL;
}

+ (NSString *)uniqueIdentifier {
  return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

+ (NSArray *)dowSymbols {
  NSArray *symbols = @[ @"AAPL", @"AXP", @"BA", @"CAT", @"CSCO", @"CVX", @"DD", @"DIS",
                        @"GE", @"GS", @"HD", @"IBM", @"INTC", @"JNJ", @"JPM", @"KO", @"MCD",
                        @"MMM", @"MRK", @"MSFT", @"NKE", @"PFE", @"PG", @"TRV", @"UNH", @"UTX",
                        @"VZ", @"V", @"WMT", @"XOM" ];
  return symbols;
}

+ (NSArray *)sp500Symbols {
  NSArray *symbols = @[ @"MMM", @"ABT", @"ABBV", @"ACN", @"ATVI", @"AYI", @"ADBE", @"AMD", @"AAP", @"AES", @"AET", @"AMG", @"AFL", @"A", @"APD", @"AKAM", @"ALK", @"ALB", @"ARE", @"ALXN", @"ALGN", @"ALLE", @"AGN", @"ADS", @"LNT", @"ALL", @"GOOGL", @"GOOG", @"MO", @"AMZN", @"AEE", @"AAL", @"AEP", @"AXP", @"AIG", @"AMT", @"AWK", @"AMP", @"ABC", @"AME", @"AMGN", @"APH", @"APC", @"ADI", @"ANDV", @"ANSS", @"ANTM", @"AON", @"AOS", @"APA", @"AIV", @"AAPL", @"AMAT", @"ADM", @"ARNC", @"AJG", @"AIZ", @"T", @"ADSK", @"ADP", @"AZO", @"AVB", @"AVY", @"BHGE", @"BLL", @"BAC", @"BK", @"BCR", @"BAX", @"BBT", @"BDX", @"BRK.B", @"BBY", @"BIIB", @"BLK", @"HRB", @"BA", @"BWA", @"BXP", @"BSX", @"BHF", @"BMY", @"AVGO", @"BF.B", @"CHRW", @"CA", @"COG", @"CDNS", @"CPB", @"COF", @"CAH", @"CBOE", @"KMX", @"CCL", @"CAT", @"CBG", @"CBS", @"CELG", @"CNC", @"CNP", @"CTL", @"CERN", @"CF", @"SCHW", @"CHTR", @"CHK", @"CVX", @"CMG", @"CB", @"CHD", @"CI", @"XEC", @"CINF", @"CTAS", @"CSCO", @"C", @"CFG", @"CTXS", @"CLX", @"CME", @"CMS", @"KO", @"CTSH", @"CL", @"CMCSA", @"CMA", @"CAG", @"CXO", @"COP", @"ED", @"STZ", @"COO", @"GLW", @"COST", @"COTY", @"CCI", @"CSRA", @"CSX", @"CMI", @"CVS", @"DHI", @"DHR", @"DRI", @"DVA", @"DE", @"DLPH", @"DAL", @"XRAY", @"DVN", @"DLR", @"DFS", @"DISCA", @"DISCK", @"DISH", @"DG", @"DLTR", @"D", @"DOV", @"DWDP", @"DPS", @"DTE", @"DRE", @"DUK", @"DXC", @"ETFC", @"EMN", @"ETN", @"EBAY", @"ECL", @"EIX", @"EW", @"EA", @"EMR", @"ETR", @"EVHC", @"EOG", @"EQT", @"EFX", @"EQIX", @"EQR", @"ESS", @"EL", @"ES", @"RE", @"EXC", @"EXPE", @"EXPD", @"ESRX", @"EXR", @"XOM", @"FFIV", @"FB", @"FAST", @"FRT", @"FDX", @"FIS", @"FITB", @"FE", @"FISV", @"FLIR", @"FLS", @"FLR", @"FMC", @"FL", @"F", @"FTV", @"FBHS", @"BEN", @"FCX", @"GPS", @"GRMN", @"IT", @"GD", @"GE", @"GGP", @"GIS", @"GM", @"GPC", @"GILD", @"GPN", @"GS", @"GT", @"GWW", @"HAL", @"HBI", @"HOG", @"HRS", @"HIG", @"HAS", @"HCA", @"HCP", @"HP", @"HSIC", @"HSY", @"HES", @"HPE", @"HLT", @"HOLX", @"HD", @"HON", @"HRL", @"HST", @"HPQ", @"HUM", @"HBAN", @"IDXX", @"INFO", @"ITW", @"ILMN", @"IR", @"INTC", @"ICE", @"IBM", @"INCY", @"IP", @"IPG", @"IFF", @"INTU", @"ISRG", @"IVZ", @"IRM", @"JEC", @"JBHT", @"SJM", @"JNJ", @"JCI", @"JPM", @"JNPR", @"KSU", @"K", @"KEY", @"KMB", @"KIM", @"KMI", @"KLAC", @"KSS", @"KHC", @"KR", @"LB", @"LLL", @"LH", @"LRCX", @"LEG", @"LEN", @"LUK", @"LLY", @"LNC", @"LKQ", @"LMT", @"L", @"LOW", @"LYB", @"MTB", @"MAC", @"M", @"MRO", @"MPC", @"MAR", @"MMC", @"MLM", @"MAS", @"MA", @"MAT", @"MKC", @"MCD", @"MCK", @"MDT", @"MRK", @"MET", @"MTD", @"MGM", @"KORS", @"MCHP", @"MU", @"MSFT", @"MAA", @"MHK", @"TAP", @"MDLZ", @"MON", @"MNST", @"MCO", @"MS", @"MOS", @"MSI", @"MYL", @"NDAQ", @"NOV", @"NAVI", @"NTAP", @"NFLX", @"NWL", @"NFX", @"NEM", @"NWSA", @"NWS", @"NEE", @"NLSN", @"NKE", @"NI", @"NBL", @"JWN", @"NSC", @"NTRS", @"NOC", @"NCLH", @"NRG", @"NUE", @"NVDA", @"ORLY", @"OXY", @"OMC", @"OKE", @"ORCL", @"PCAR", @"PKG", @"PH", @"PDCO", @"PAYX", @"PYPL", @"PNR", @"PBCT", @"PEP", @"PKI", @"PRGO", @"PFE", @"PCG", @"PM", @"PSX", @"PNW", @"PXD", @"PNC", @"RL", @"PPG", @"PPL", @"PX", @"PCLN", @"PFG", @"PG", @"PGR", @"PLD", @"PRU", @"PEG", @"PSA", @"PHM", @"PVH", @"QRVO", @"PWR", @"QCOM", @"DGX", @"Q", @"RRC", @"RJF", @"RTN", @"O", @"RHT", @"REG", @"REGN", @"RF", @"RSG", @"RMD", @"RHI", @"ROK", @"COL", @"ROP", @"ROST", @"RCL", @"CRM", @"SBAC", @"SCG", @"SLB", @"SNI", @"STX", @"SEE", @"SRE", @"SHW", @"SIG", @"SPG", @"SWKS", @"SLG", @"SNA", @"SO", @"LUV", @"SPGI", @"SWK", @"SBUX", @"STT", @"SRCL", @"SYK", @"STI", @"SYMC", @"SYF", @"SNPS", @"SYY", @"TROW", @"TPR", @"TGT", @"TEL", @"FTI", @"TXN", @"TXT", @"TMO", @"TIF", @"TWX", @"TJX", @"TMK", @"TSS", @"TSCO", @"TDG", @"TRV", @"TRIP", @"FOXA", @"FOX", @"TSN", @"UDR", @"ULTA", @"USB", @"UA", @"UAA", @"UNP", @"UAL", @"UNH", @"UPS", @"URI", @"UTX", @"UHS", @"UNM", @"VFC", @"VLO", @"VAR", @"VTR", @"VRSN", @"VRSK", @"VZ", @"VRTX", @"VIAB", @"V", @"VNO", @"VMC", @"WMT", @"WBA", @"DIS", @"WM", @"WAT", @"WEC", @"WFC", @"HCN", @"WDC", @"WU", @"WRK", @"WY", @"WHR", @"WMB", @"WLTW", @"WYN", @"WYNN", @"XEL", @"XRX", @"XLNX", @"XL", @"XYL", @"YUM", @"ZBH", @"ZION", @"ZTS" ];
  return symbols;
}

+ (UIColor *)grayColor {
  return [UIColor colorWithRed:(CGFloat)36 / (CGFloat)255
                         green:(CGFloat)40 / (CGFloat)255
                          blue:(CGFloat)44 / (CGFloat)255
                         alpha:1];
}

+ (UIColor *)darkGrayColor {
  return [UIColor colorWithRed:(CGFloat)21 / (CGFloat)255
                         green:(CGFloat)26 / (CGFloat)255
                          blue:(CGFloat)31 / (CGFloat)255
                         alpha:1];
}

+ (UIColor *)eidoBlueColor {
  return [UIColor colorWithRed:(CGFloat)10 / (CGFloat)255
                         green:(CGFloat)130 / (CGFloat)255
                          blue:(CGFloat)203 / (CGFloat)255
                         alpha:1];
}

+ (UIColor *)eidoPurpleColor {
  return [UIColor colorWithRed:(CGFloat)139 / (CGFloat)255
                         green:(CGFloat)39 / (CGFloat)255
                          blue:(CGFloat)161 / (CGFloat)255
                         alpha:1];
}

+ (void)requestListWithSymbols:(NSArray *)symbols
               completionBlock:(void (^)(NSMutableArray *results))completionBlock
                    errorBlock:(void (^)(NSError *error))errorBlock {
  NSString *apiKeyString = [kAPIArg stringByAppendingString:kAPIKey];
  NSString *keyURL = [kListURL stringByAppendingString:apiKeyString];
  
  if (symbols.count > 0) {
    NSString *symbolsString =
        [kSymbolsArg stringByAppendingString:[symbols componentsJoinedByString:kSymbolsDelimiter]];
    NSString *reqURL = [keyURL stringByAppendingString:symbolsString];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self placeGetRequestWithURL:reqURL withHandler:^(NSData *data,
                                                        NSURLResponse *response,
                                                        NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
          if (error) {
            errorBlock(error);
          } else {
            NSMutableArray *results =
                [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (completionBlock) {
              completionBlock(results);
            }
          }
        });
      }];
    });
  } else {
    if (completionBlock) {
      completionBlock(nil);
    }
  }
}

+ (void)requestChartWithSymbol:(NSString *)symbol
                     indexPath:(NSIndexPath *)indexPath
                    projection:(NSString *)projection
               completionBlock:(void (^)(NSData *data,
                                         NSString *symbol,
                                         NSIndexPath *indexPath))completionBlock
                    errorBlock:(void (^)(NSError *error))errorBlock {
  NSString *chartSymbolURL =
      [[EDSCommon chartURL] stringByAppendingString:symbol];
  NSString *chartTimeURL =
      [chartSymbolURL stringByAppendingString:[kSingleSymbolDelimiter
                                               stringByAppendingString:projection]];
  NSString *keyURL =
      [chartTimeURL stringByAppendingString:[kAPIArg stringByAppendingString:[EDSCommon apiKey]]];
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self placeGetRequestWithURL:keyURL withHandler:^(NSData *data,
                                                      NSURLResponse *response,
                                                      NSError *error) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        if (error) {
          if (errorBlock) {
            errorBlock(error);
          }
        } else {
          if (completionBlock) {
            completionBlock(data, symbol, indexPath);
          }
        }
      });
    }];
  });
}

+ (void)placeGetRequestWithURL:(NSString *)urlString
                  withHandler:(void (^)(NSData *data,
                                        NSURLResponse *response,
                                        NSError *error))ourBlock {
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:ourBlock] resume];
}

@end
