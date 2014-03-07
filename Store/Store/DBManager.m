//
//  DBManager.m
//  Store
//
//  Created by sanjeev.bharti on 3/6/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import "DBManager.h"
#import "Product.h"

#define SqlFile @"StoreInformation.sqlite"

#define NSSRING_FROM_CSTRING(_str_) \
[NSString stringWithFormat:@"%s",_str_]

#define CSTRING_FROM_NSSTRING(_str_) \
[_str_ cStringUsingEncoding:NSUTF8StringEncoding]

static DBManager *initObj = nil;

@implementation DBManager

+(id) sharedInstance {
   
    if (initObj == nil) {
        initObj = [[self alloc] init];
    }
    return initObj;
}

#pragma mark -
#pragma mark - Inialization of Database

-(void) initializeDataBase {
    
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [docDirPath stringByAppendingPathComponent:SqlFile];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *bundlefilePath = nil;
        
        bundlefilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:SqlFile];
        
        [[NSFileManager defaultManager] copyItemAtPath:bundlefilePath
                                                toPath:filePath
                                                 error:nil];
    }
    
    if (sqlite3_open([filePath cStringUsingEncoding:NSUTF8StringEncoding], &db) != SQLITE_OK) {
        //Alert...
    }
}

#pragma mark -
#pragma mark - Database operations to Product

- (void)insertRecordToStoreWithProduct:(Product *)_product {
    
    /*
    CREATE TABLE "ProductInfo" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "productName" VARCHAR, "productDesc" VARCHAR, "productActualPrice" DOUBLE, "productSalesPrice" DOUBLE, "productColor" VARCHAR, "productStores" VARCHAR)
    */
    
    [self initializeDataBase];

    NSString *insertQuery = nil;
    
    insertQuery = [NSString stringWithFormat:@"insert into ProductInfo(productName,productDesc,productActualPrice,productSalesPrice,productColor,productStores) values (?,?,?,?,?,?)"];
    
    sqlite3_stmt *statement = nil;
    
    const char *sql = [insertQuery cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
        //Alert
        //NSLog(@"%s",sqlite3_errmsg(db));
        return;
    }

    sqlite3_bind_text(statement, 1, [_product.mString_productName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [_product.mString_productDescreption UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(statement,3,_product.mDouble_actualPrice);
    sqlite3_bind_double(statement,4,_product.mDouble_productSalesPrice);

    NSData *_data = [NSKeyedArchiver archivedDataWithRootObject:_product.mArray_productColor];
    
    sqlite3_bind_blob(statement, 5, [_data bytes], (int)[_data length], SQLITE_TRANSIENT);
    
    _data = [NSKeyedArchiver archivedDataWithRootObject:_product.mDict_productStore];
    
    sqlite3_bind_blob(statement, 6, [_data bytes], (int)[_data length], SQLITE_TRANSIENT);

      if (sqlite3_step(statement) == SQLITE_DONE) {
        //OK Alert
        //NSLog(@"Oke");
    }
}

- (void)updateRecordToStoreWithProduct:(Product *)_product {
    
    /*
     CREATE TABLE "ProductInfo" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "productName" VARCHAR, "productDesc" VARCHAR, "productActualPrice" DOUBLE, "productSalesPrice" DOUBLE, "productColor" VARCHAR, "productStores" VARCHAR)
     */
    
    NSString *insertQuery = nil;
    
    insertQuery = [NSString stringWithFormat:@"update ProductInfo set productName = ?,productDesc = ?,productActualPrice = ?,productSalesPrice = ?,productColor = ?,productStores = ? where id = ?"];
    
    sqlite3_stmt *statement = nil;
    
    [self initializeDataBase];
    
    const char *sql = [insertQuery cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
        //Alert
        //NSLog(@"%s",sqlite3_errmsg(db));
        return;
    }
    
    sqlite3_bind_text(statement, 1, [_product.mString_productName UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(statement, 2, [_product.mString_productDescreption UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_double(statement,3,_product.mDouble_actualPrice);
    sqlite3_bind_double(statement,4,_product.mDouble_productSalesPrice);
    
    NSData *_data = [NSKeyedArchiver archivedDataWithRootObject:_product.mArray_productColor];
    
    sqlite3_bind_blob(statement, 5, [_data bytes], (int)[_data length], SQLITE_TRANSIENT);
    
    _data = [NSKeyedArchiver archivedDataWithRootObject:_product.mDict_productStore];
    
    sqlite3_bind_blob(statement, 6, [_data bytes], (int)[_data length], SQLITE_TRANSIENT);

    sqlite3_bind_int(statement,7,_product.mInt_productId);
    
    if (sqlite3_step(statement) == SQLITE_DONE) {
        
        //OK Alert
    }
}

- (void)deleteRecordFromStoreWithProduct:(Product *)_product {
    
    /*
     CREATE TABLE "ProductInfo" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "productName" VARCHAR, "productDesc" VARCHAR, "productActualPrice" DOUBLE, "productSalesPrice" DOUBLE, "productColor" VARCHAR, "productStores" VARCHAR)
     */

    NSString *updateQuery = nil;
    
    updateQuery =[NSString stringWithFormat:@"DELETE FROM ProductInfo where id = %d",_product.mInt_productId];
    
    sqlite3_stmt *statement = nil;
    [self initializeDataBase];
    
    const char *sql = [updateQuery cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (sqlite3_prepare_v2(db, sql, -1, &statement, NULL) != SQLITE_OK) {
        //Alert
        //NSLog(@"%s",sqlite3_errmsg(db));
        return;
    }
    
    if (sqlite3_step(statement) == SQLITE_DONE) {
        //OK Alert
        //NSLog(@"Row Deleted Successfully");
    }
    else
    {
        //Error Alert
        //NSLog(@"%s",sqlite3_errmsg(db));
    }

    
}

- (NSArray *)getAllProductsFromStore {
    
    /*
     CREATE TABLE "ProductInfo" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "productName" VARCHAR, "productDesc" VARCHAR, "productActualPrice" DOUBLE, "productSalesPrice" DOUBLE, "productColor" VARCHAR, "productStores" VARCHAR)
     */

    [self initializeDataBase];
    
    NSString *selectQry = nil;
    
    NSMutableArray *recordsArray = [[NSMutableArray alloc] init];
    
    selectQry = @"Select id,productName,productDesc,productActualPrice,productSalesPrice,productColor,productStores from ProductInfo";
    
    sqlite3_stmt *statement = nil;
    
    if (sqlite3_prepare_v2(db, [selectQry cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            Product *_product = [[Product alloc] init];
            
            _product.mInt_productId = sqlite3_column_int(statement, 0);
            
            _product.mString_productName = NSSRING_FROM_CSTRING(sqlite3_column_text(statement, 1));
            
            _product.mString_productDescreption = NSSRING_FROM_CSTRING(sqlite3_column_text(statement, 2));
           
            _product.mDouble_actualPrice = sqlite3_column_double(statement, 3);
            
            _product.mDouble_productSalesPrice = sqlite3_column_double(statement, 4);
            
            const void *ptr = sqlite3_column_blob(statement, 5);
            int size = sqlite3_column_bytes(statement, 5);
            NSData *_data = [[NSData alloc] initWithBytes:ptr length:size];
            
            _product.mArray_productColor = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:_data];
            
            ptr = sqlite3_column_blob(statement, 6);
            size = sqlite3_column_bytes(statement, 6);
            _data = [[NSData alloc] initWithBytes:ptr length:size];

            _product.mDict_productStore = (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:_data] ;
            [recordsArray addObject:_product];
            
            _product = nil;
        }
    }
    return recordsArray;
}

- (int)fetchHeightRowNumberFromDataBase {
    
    /*
     CREATE TABLE "ProductInfo" ("id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL , "productName" VARCHAR, "productDesc" VARCHAR, "productActualPrice" DOUBLE, "productSalesPrice" DOUBLE, "productColor" VARCHAR, "productStores" VARCHAR)
     */

    NSString *selectQry = nil;
    
    selectQry = @"Select max (id) from ProductInfo";
    
    sqlite3_stmt *statement = nil;
    
    [self initializeDataBase];
    
    if (sqlite3_prepare_v2(db, CSTRING_FROM_NSSTRING(selectQry), -1, &statement, NULL) != SQLITE_OK) {
        //ERROR
        //NSLog(@"%s",sqlite3_errmsg(db));
        return -1;
    }
    
    int lastInsertedRow = -1;
    if (sqlite3_step(statement) == SQLITE_ROW)
    {
        lastInsertedRow = sqlite3_column_int(statement, 0);
    }
    
    sqlite3_finalize(statement);
    
    return lastInsertedRow;
}


@end
