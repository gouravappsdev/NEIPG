//
//  PGDataManager.m
//  NEIPG
//
//  Created by Yaogeng Cheng on 1/13/14.
//  Copyright (c) 2014 Yaogeng Cheng. All rights reserved.
//

#import "PGDataManager.h"
#import "PGCheckList.h"

@implementation PGDataManager

/*+ (NSMutableArray *) getLogin{
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT * FROM LogInfo";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }

        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            NSString * str  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            [wineArray addObject:str];
            
            str  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            [wineArray addObject:str];

            str  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            [wineArray addObject:str];

        }
        sqlite3_close(db);
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return wineArray;
        sqlite3_close(db);
    }
}
*/


+ (NSMutableArray *) getPresciribeList:(NSString *)drugName{
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    sqlite3 *db;
    
    @try {
        //NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        //NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"NEIPG.sqlite" ofType:nil];
        
        
        //BOOL success = [fileMgr fileExistsAtPath:dbPath];
        //if(!success)
        //{
           // NSLog(@"Cannot locate database file '%@'.", dbPath);
       // }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        //const char *sql = "SELECT c.ConsiderationsID,  c.Description FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsID=c.ConsiderationsID and dc.CategoryCode='PRESCRIBE' and GenericName='sertraline'";
        NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT c.ConsiderationsID,  c.Description FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsID=c.ConsiderationsID and dc.CategoryCode='PRESCRIBE' and GenericName='", drugName, @"'"];
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pDescr =@"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            PGCheckList *item = [[PGCheckList alloc] init];
            //WineList *MyWine = [[WineList alloc]init];
            NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            //NSString * pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            item.itemId = pId;
            item.itemName = pDescr;
            item.drugName = drugName;
            [wineArray addObject:item];
            item=nil;
            //[_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
        pDescr = nil;
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        dbPath=nil;
        sql=nil;
        return wineArray;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        wineArray=nil;
        sqlite3_close(db);
    }
}



+ (NSMutableArray *) getDrugList{
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT * FROM Drugs order by DrugName COLLATE NOCASE";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pDescr =@"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            //PGCheckList *item = [[PGCheckList alloc] init];
            //WineList *MyWine = [[WineList alloc]init];
            //NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            //NSString * pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            //item.itemId = pId;
            //item.itemName = pDescr;
            //item.checked = FALSE;
            [wineArray addObject:pDescr];
            //[_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        dbPath=nil;
        sql=nil;
        pDescr = nil;
        return wineArray;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        wineArray=nil;
        sqlite3_close(db);
    }
}

+ (NSMutableArray *) getDrugUseList{
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT distinct Use FROM DrugUse order by Use COLLATE NOCASE";
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pDescr =@"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            //PGCheckList *item = [[PGCheckList alloc] init];
            //WineList *MyWine = [[WineList alloc]init];
            //NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            //NSString * pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            //item.itemId = pId;
            //item.itemName = pDescr;
            //item.checked = FALSE;
            [wineArray addObject:pDescr];
            //[_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        dbPath=nil;
        sql=nil;
        pDescr = nil;
        return wineArray;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        wineArray=nil;
        sqlite3_close(db);
    }
}

+ (NSMutableArray *) getDrugNameListByIndication:(NSString *)indication{
    
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT distinct GenericName FROM DrugUse where Use='", indication, @"' order by GenericName"];
        NSLog(@"sql is %@",sql);
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pDescr =@"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            //PGCheckList *item = [[PGCheckList alloc] init];
            //WineList *MyWine = [[WineList alloc]init];
            //NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            //NSString * pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            //item.itemId = pId;
            //item.itemName = pDescr;
            //item.checked = FALSE;
            [wineArray addObject:pDescr];
            //[_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        pDescr = nil;
        dbPath=nil;
        sql=nil;
        return wineArray;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        wineArray=nil;
        sqlite3_close(db);
    }
}


+ (NSString *) getContent:(NSString *)drugName{
    //return @"Problem with prepare statement";
    //NSMutableString* theString = [NSMutableString string];
    NSString * theString = @"";
    //[theString appendString:@"<link rel='stylesheet' type='text/css' href='styles.css'>"]; //<p class='neiheader1'>Commonly Prescribed For (bold for FDA approved)</p> <a href='IMG_0412.JPG' target='_blank'>image name</a>
    theString = [theString stringByAppendingFormat:@"%@",@"<link rel='stylesheet' type='text/css' href='styles.css'>"];
    //[theString appendString:@"<a href='Amisulpride-test.jpg' target='_blank'>image name</a>"];
    //[theString appendString:@"<a href='Amisulpride-01.png' target='_blank'>image name</a>"];
    //[theString appendString:@"<table border=0 cellspacing='0' cellpadding='0' width='100%' class='bkgHeader'><tr><td><table border=0 cellspacing='0' cellpadding='0' width='100%'><tr><td width='1%'><p><img class='imgSize' src='commonlyprescribedfor.png'></p></td><td width='1%'>&nbsp;&nbsp;</td><td width='99%'><p class='neiheader1'>Dosing and Use</p></td></tr></table></td></tr></table>"];
    //[theString appendString:@"<table border=0 cellspacing='0' cellpadding='0' width='100%'><tr class='bkgHeader'><td valign='middle'><img class='imgSize' src='dosinganduse.png'>&nbsp;&nbsp;<span class='neiheader1'>Dosing and Use</span></td></tr></table>"];
    //[theString appendString:@"<ul><li><strong>Schizophrenia, acute and maintenance</strong></li><li><strong>Acute mania/mixed mania (monotherapy and adjunct to lithium or valproate)</strong></li><li><strong>Other psychotic disorders</strong></li><li>Bipolar maintenance</li><li>Bipolar depression</li><li>Treatment-resistant depression</li><li>Behavioral disturbances in dementia</li><li>Behavioral disturbances in children and adolescents</li><li>Disorders associated with problems with impulse control</li></ul>"];
    //
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT dch.DrugContentHeaderID, dch.HeaderHtml, dc.TextHTML FROM DrugContent dc, DrugContentHeader dch where dc.DrugContentHeaderID=dch.DrugContentHeaderID and GenericName='", drugName, @"' order by dch.DrugContentHeaderID"];
        NSLog(@"sql is %@",sql);
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSInteger pId = 0;
        NSString * pCode = @"";
        NSString * pDescr  = @"";
        NSString *str = @"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {

            pId = sqlite3_column_int(sqlStatement, 0);
            pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            
            str = [NSString stringWithFormat:@"%@%li%@%@%@",@"<A name='", (long)pId, @"'></A>", pCode, pDescr];
            //NSLog(@"str: %@", str);
            //[theString appendString:str];
            theString = [theString stringByAppendingFormat:@"%@",str];
            //<A name='BOOK'></A>

            //[wineArray addObject:str];

        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        //[theString appendString:@"<table width='100%' border='0'><tr><td align='right'><A href='#top'>Back to Top</A></td></tr></table><p>&nbsp;</p>"];
        theString = [theString stringByAppendingFormat:@"%@",@"<table width='100%' border='0'><tr><td align='right'><A href='#top'>Back to Top</A></td></tr></table><p>&nbsp;</p>"];
        //theString = nil;
        //pId = nil;
        pCode = nil;
        pDescr  = nil;
        str = nil;
        dbPath=nil;
        sql=nil;
        return theString;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        theString = nil;
        //sqlite3_close(db);
    }
}


+ (NSString *) getGenericDrugName:(NSString *)drugName{

    sqlite3 *db;
    NSString * pDescr = @"";
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT GenericName FROM drugs where DrugName='", drugName, @"'"];
        NSLog(@"sql is %@",sql);
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
           pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        dbPath=nil;
        sql=nil;
        return pDescr;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        pDescr=nil;
        sqlite3_close(db);
    }
}

+ (NSMutableDictionary *) getConsiderationKeys:(NSString *)drugName{
    //
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        //const char *sql = "SELECT * FROM DrugConsiderations dc, Category c where dc.CategoryCode=c.CategoryCode and dc.CategoryCode<>'PRESCRIBE' and dc";
        NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT distinct c.* FROM DrugConsiderations dc, Category c where dc.CategoryCode=c.CategoryCode and dc.CategoryCode<>'PRESCRIBE' and dc.GenericName='", drugName, @"'"];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }

        NSString * pCode = @"";
        NSString * pDescr  = @"";
        NSString *pImageName = @"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            //PGCheckList *item = [[PGCheckList alloc] init];
            //WineList *MyWine = [[WineList alloc]init];
            NSMutableArray *wineArray = [[NSMutableArray alloc] init];
            //NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            pImageName  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            //item.itemId = pId;
            //item.itemName = pDescr;
            //item.checked = FALSE;
            [wineArray addObject:pDescr];
            [wineArray addObject:pImageName];
            //[dict setObject: @"Wind in the Willows"  forKey: @"100-432112"];
            [dict setObject: wineArray  forKey: pCode];
            wineArray=nil;
            //[_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        pCode = nil;
        pDescr  = nil;
        pImageName = nil;
        dbPath=nil;
        sql=nil;
        return dict;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        dict=nil;
        sqlite3_close(db);
    }
}

+ (NSMutableDictionary *) getContentHeader{
    NSMutableArray *keyArray = [[NSMutableArray alloc] init];
    NSMutableArray *valueArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        const char *sql = "SELECT  * FROM DrugContentHeader";
        //NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT  * FROM DrugContentHeader"];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pDescr  = @"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            //PGCheckList *item = [[PGCheckList alloc] init];
            //WineList *MyWine = [[WineList alloc]init];
            NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            //NSString * pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            //item.itemId = pId;
            //item.itemName = pDescr;
            //item.checked = FALSE;
            [keyArray addObject:[NSNumber numberWithInteger:pId]];
            [valueArray addObject:pDescr];
            //[dict setObject: @"Wind in the Willows"  forKey: @"100-432112"];
                        //[_codeObjects addObject:[NSNumber numberWithInteger:pId]];
            //[itsToDoChecked addObject:(FALSE)];
        }
        [dict setObject: keyArray  forKey: @"key"];
        [dict setObject: valueArray  forKey: @"value"];
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        pDescr=nil;
        dbPath=nil;
        sql=nil;
        return dict;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        dict = nil;
        sqlite3_close(db);
    }
}


+ (NSMutableDictionary *) getConsiderationList:(NSString *)drugName{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    sqlite3 *db;
    
    @try {
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        //const char *sql = "SELECT * FROM DrugConsiderations dc, Category c where dc.CategoryCode=c.CategoryCode and dc.CategoryCode<>'PRESCRIBE' and dc";
        NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT c.*, dc.RankID FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsId=c.ConsiderationsId and dc.CategoryCode<>'PRESCRIBE' and dc.GenericName='", drugName, @"'"];
        
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pCode = @"";
        NSString * pDescr  = @"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            PGCheckList *item = [[PGCheckList alloc] init];
            
            NSInteger pId = sqlite3_column_int(sqlStatement, 0);
            pCode = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            NSInteger rId = sqlite3_column_int(sqlStatement, 3);
            //const char *raw = sqlite3_column_blob(sqlStatement, 3);
            //int rawLen = sqlite3_column_bytes(sqlStatement, 3);
            //NSData *data = [NSData dataWithBytes:raw length:rawLen];
            //MyWine.photo = [[UIImage alloc] initWithData:data];
            item.itemId = pId;
            item.itemName = pDescr;
            item.checked = FALSE;
            item.rankId = rId;
            NSLog(@"item.rankId %li", (long)item.rankId);
            //[dict setObject: @"Wind in the Willows"  forKey: @"100-432112"];
            
            if ([dict objectForKey:pCode]) {
                [[dict objectForKey:pCode] addObject:item];
            } else {
                NSMutableArray *wineArray = [[NSMutableArray alloc] init];
                [wineArray addObject:item];
                [dict setObject: wineArray  forKey: pCode];
            }

            item=nil;
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        pCode = nil;
        pDescr  = nil;
        dbPath=nil;
        sql=nil;
        return dict;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        dict = nil;
        sqlite3_close(db);
    }
}


+ (NSMutableArray *) getAlternateDrugList:(NSString *)sql{
    NSMutableArray *wineArray = [[NSMutableArray alloc] init];
    sqlite3 *db;
    
    @try {
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"NEIPG.sqlite"];

        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
        }
        //const char *sql = "SELECT c.ConsiderationsID,  c.Description FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsID=c.ConsiderationsID and dc.CategoryCode='PRESCRIBE' and GenericName='sertraline'";
        //NSString *sql = [NSString stringWithFormat:@"%@%@%@", @"SELECT c.ConsiderationsID,  c.Description FROM DrugConsiderations dc, Considerations c where dc.ConsiderationsID=c.ConsiderationsID and dc.CategoryCode='PRESCRIBE' and GenericName='", drugName, @"'"];
        sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, [sql UTF8String], -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement");
        }
        NSString * pDescr =@"";
        //
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            pDescr  = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 0)];

            [wineArray addObject:pDescr];
        }
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        pDescr=nil;
        dbPath=nil;
        //sql=nil;
        return wineArray;
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        wineArray = nil;
        sqlite3_close(db);
    }
}
@end
