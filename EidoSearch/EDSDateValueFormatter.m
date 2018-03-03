//
//  EDSCommon.m
//  EidoSearch
//
//  Created by Junius Gunaratne on 3/4/17.
//  Copyright © 2017 Junius Gunaratne. All rights reserved.
//

#import "EDSDateValueFormatter.h"

@interface EDSDateValueFormatter () {
  NSDateFormatter *_dateFormatter;
}
@end

@implementation EDSDateValueFormatter

- (id)init {
  self = [super init];
  if (self) {
    _dateFormatter = [[NSDateFormatter alloc] init];
    _dateFormatter.dateFormat = @"d MMM yy";
  }
  return self;
}

- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
  return [_dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:value]];
}

@end
