//
//  Logs.h
//  Beaver
//
//  Created by xuzhaocheng on 14/11/4.
//  Copyright (c) 2014年 Zhejiang University. All rights reserved.
//

#ifndef Beaver_Logs_h
#define Beaver_Logs_h

/*** Logging ***/

// http://stackoverflow.com/questions/969130/how-to-print-out-the-method-name-and-line-number-and-conditionally-disable-nslog
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#define ELog(error) NSLog(@"%s [Line %d] Error:\n%@\n%@\n%@", __PRETTY_FUNCTION__, __LINE__, [error localizedDescription], [error localizedRecoverySuggestion], [error userInfo])

#endif
