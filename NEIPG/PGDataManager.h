//
//  PGDataManager.h
//  NEIPG
//
//  Created by Yaogeng Cheng on 1/13/14.
//  Copyright (c) 2014 Yaogeng Cheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface PGDataManager : NSObject

//+ (NSMutableArray *) getLogin;

+ (NSMutableArray *) getPresciribeList:(NSString *)drugName;

+ (NSMutableArray *) getDrugList;

+ (NSMutableArray *) getDrugUseList;

+ (NSString *) getGenericDrugName:(NSString *)drugName;

+ (NSMutableDictionary *) getConsiderationKeys:(NSString *)drugName;

+ (NSMutableDictionary *) getConsiderationList:(NSString *)drugName;

+ (NSMutableArray *) getAlternateDrugList:(NSString *)sql;

+ (NSMutableArray *) getDrugNameListByIndication:(NSString *)indication;

+ (NSMutableString *) getContent:(NSString *)drugName;

+ (NSMutableDictionary *) getContentHeader;

//+(void)InsertRecords:(NSMutableString *)txt :(int) integer :(double) dbl;
//+(void)UpdateRecords:(NSString *)txt :(NSMutableString *) utxt;
//+(void)DeleteRecords:(NSString *)txt;


@end
