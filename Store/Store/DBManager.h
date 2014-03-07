//
//  DBManager.h
//  Store
//
//  Created by sanjeev.bharti on 3/6/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class Product ;


@interface DBManager : NSObject {

    sqlite3 *db;
}

+ (id) sharedInstance;


//method to initialize the database

- (void) initializeDataBase ;

// database operations

- (void)insertRecordToStoreWithProduct:(Product *)_product ;
- (void)updateRecordToStoreWithProduct:(Product *)_product ;
- (void)deleteRecordFromStoreWithProduct:(Product *)_product ;
- (NSArray *)getAllProductsFromStore ;
- (int)fetchHeightRowNumberFromDataBase ;

@end
