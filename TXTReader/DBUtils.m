//
//  DBUtils.m
//  TXTReader
//
//  Created by PYgzx on 15/3/8.
//  Copyright (c) 2015年 pygzx. All rights reserved.
//

#import "DBUtils.h"

#define TABLENAME @"book"
#define ID @"id"
#define NAME @"name"
#define PAGINATEFONTSIZE @"paginatefontsize"
#define PAGINATEROWSPACE @"paginateRowSpace"
#define PAGEINDEXS @"pageIndexs"
#define BOOKMARKOFFSETS @"bookmarkOffsets"
#define LASTREADDATE @"lastReadDate"
#define LASTREADOFFSET @"lastReadOffset"

#define DB_FILE_PATH [DOCUMENTS_PATH stringByAppendingPathComponent:@"TXTReader.db"]//[[NSBundle mainBundle] pathForResource:@"TXTRreader.db" ofType:nil]

@implementation DBUtils

+ (BOOL) queryBook:(Book *)book {
    FMDatabase *db = [FMDatabase databaseWithPath:DB_FILE_PATH];NSLog(@"DBFile: %@", DB_FILE_PATH);
    if([db open]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", TABLENAME, ID, NAME, PAGINATEFONTSIZE, PAGINATEROWSPACE, PAGEINDEXS, BOOKMARKOFFSETS, LASTREADDATE, LASTREADOFFSET];
        BOOL res = [db executeUpdate:createTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        
        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@", TABLENAME, NAME, book.name];
        FMResultSet *rs = [db executeQuery:querySql];
        while ([rs next]) {
//            int idd = [rs intForColumn:ID];
            NSString *name = [rs stringForColumn:NAME];
            int fontSize = [rs intForColumn:PAGINATEFONTSIZE];
            int rowSpace = [rs intForColumn:PAGINATEROWSPACE];
            NSUInteger lastOffset = (NSUInteger)[rs unsignedLongLongIntForColumn:LASTREADOFFSET];
            NSString *pageIndex = [rs stringForColumn:PAGEINDEXS];
            NSString *bms = [rs stringForColumn:BOOKMARKOFFSETS];
            NSString *date = [rs stringForColumn:LASTREADDATE];
            PYLog(@"%@ %@ %@ %@",name, @(fontSize), @(rowSpace), @(lastOffset));
            
            NSArray *pis = [pageIndex componentsSeparatedByString:@" "];
            NSString *tmp;
            
            book.lastUpdate = [PYUtils string2Date:date];
            book.lastReadOffset = lastOffset;
            
            NSArray *bmsArray = [bms componentsSeparatedByString:@" "];
            book.bookMarksOffset = [NSMutableArray arrayWithCapacity:bmsArray.count];
            for (NSUInteger i = 0; i < bmsArray.count-1; i++) {
                tmp = [bmsArray objectAtIndex:i];
                [book.bookMarksOffset addObject:[NSValue valueWithRange:NSMakeRange([tmp integerValue], 50)]];
            }
//            PYLog(@"bookMarksOffset: %@", book.bookMarksOffset);
            
            GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
            PYLog(@"%s fontsize: %@ %@ rowspace: %@ %@", __PRETTY_FUNCTION__, @(fontSize), @(st.fontSize), @(rowSpace), @(st.rowSpaceIndex));
            if(fontSize == st.fontSize && rowSpace == st.rowSpaceIndex) {
                book.pageIndexArray = [NSMutableArray arrayWithCapacity:pis.count];
                for (NSUInteger i = 0; i < pis.count-1; i++) {
                    tmp = [pis objectAtIndex:i];
                    [book.pageIndexArray addObject:@([tmp integerValue])];
                }
//                PYLog(@"pageIndexArray: %@", book.pageIndexArray);
            }
            else {
                book.pageIndexArray = nil;
                [rs close];
                [db close];
                return NO;
            }
            book.lastReadOffset = lastOffset;
            [rs close];
            [db close];
            PYLog(@"%s: %@", __PRETTY_FUNCTION__, book);
            return YES;
        }
    }
    else {
        [db close];
        return NO;
    }
    [db close];
    return NO;
}

+ (void) addBook:(Book*)book {
    FMDatabase *db = [FMDatabase databaseWithPath:DB_FILE_PATH];
    if([db open]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", TABLENAME, ID, NAME, PAGINATEFONTSIZE, PAGINATEROWSPACE, PAGEINDEXS, BOOKMARKOFFSETS, LASTREADDATE, LASTREADOFFSET];
        BOOL res = [db executeUpdate:createTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }
        
        GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
        NSMutableString* pageIndexsString = [[NSMutableString alloc] init];
        for (NSNumber *num in book.pageIndexArray) {
            [pageIndexsString appendFormat:@"%@ ", num];
        }
//        NSLog(@"page: %@", [NSString stringWithString:pageIndexsString]);
        NSMutableString* bookmarkIndexString = [[NSMutableString alloc] init];
        for (NSValue *value in book.bookMarksOffset) {
            [bookmarkIndexString appendFormat:@"%@ ", @([value rangeValue].location)];
        }
//        NSLog(@"bookmark: %@", [NSString stringWithString:bookmarkIndexString]);
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO book (%@,%@,%@,%@,%@,%@,%@) VALUES (?,?,?,?,?,?,?)", NAME, PAGINATEFONTSIZE, PAGINATEROWSPACE, PAGEINDEXS, BOOKMARKOFFSETS, LASTREADDATE, LASTREADOFFSET];NSLog(@"%@", @(st.fontSize));
        BOOL addSuccess = [db executeUpdate:sql, book.name, [NSNumber numberWithInteger:st.fontSize], [NSNumber numberWithInteger:st.rowSpaceIndex], [NSString stringWithString:pageIndexsString], [NSString stringWithString:bookmarkIndexString], [PYUtils date2String:book.lastUpdate shortDate:YES], [NSNumber numberWithUnsignedInteger:book.lastReadOffset]];
//        NSLog(@"====");
        PYLog(@"%s %d", __PRETTY_FUNCTION__, addSuccess);
        PYLog(@"%s: %@", __PRETTY_FUNCTION__, book);
    }
    else {
    }
    [db close];
}

+ (void) updateWithBook:(Book *)book {
    FMDatabase *db = [FMDatabase databaseWithPath:DB_FILE_PATH];
    if([db open]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", TABLENAME, ID, NAME, PAGINATEFONTSIZE, PAGINATEROWSPACE, PAGEINDEXS, BOOKMARKOFFSETS, LASTREADDATE, LASTREADOFFSET];
        BOOL res = [db executeUpdate:createTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }

        
        GlobalSettingAttrbutes *st = [GlobalSettingAttrbutes shareSetting];
        NSMutableString* pageIndexsString = [[NSMutableString alloc] init];
        for (NSNumber *num in book.pageIndexArray) {
            [pageIndexsString appendFormat:@"%@ ", num];
        }
        NSMutableString* bookmarkIndexString = [[NSMutableString alloc] init];
        for (NSValue *value in book.bookMarksOffset) {
            [bookmarkIndexString appendFormat:@"%@ ", @([value rangeValue].location)];
        }
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE book SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE %@ = ?", PAGINATEFONTSIZE, PAGINATEROWSPACE, PAGEINDEXS, BOOKMARKOFFSETS, LASTREADDATE, LASTREADOFFSET, NAME];
        BOOL updateSuccess = [db executeUpdate:sql, @(st.fontSize), @(st.rowSpaceIndex), [NSString stringWithString:pageIndexsString], [NSString stringWithString:bookmarkIndexString], [PYUtils date2String:book.lastUpdate shortDate:YES], @(book.lastReadOffset), book.name];
        PYLog(@"%s %d | %@ %@", __PRETTY_FUNCTION__, updateSuccess, @(st.fontSize), @(st.rowSpaceIndex));
        PYLog(@"%s: %@", __PRETTY_FUNCTION__, book);
    }
}

+ (BOOL) isBookInDB:(Book *)book {
    BOOL ret = NO;
    FMDatabase *db = [FMDatabase databaseWithPath:DB_FILE_PATH];
    if([db open]) {
        NSString *createTable = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT, '%@' INTEGER, '%@' INTEGER, '%@' TEXT, '%@' TEXT, '%@' TEXT, '%@' TEXT)", TABLENAME, ID, NAME, PAGINATEFONTSIZE, PAGINATEROWSPACE, PAGEINDEXS, BOOKMARKOFFSETS, LASTREADDATE, LASTREADOFFSET];
        BOOL res = [db executeUpdate:createTable];
        if (!res) {
            NSLog(@"error when creating db table");
        } else {
            NSLog(@"success to creating db table");
        }

        
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %@", TABLENAME, NAME, book.name];
        FMResultSet *rs = [db executeQuery:querySql];
        if([rs next]) {
            ret = YES;
        }
    }
    [db close];
    return ret;
}

@end
