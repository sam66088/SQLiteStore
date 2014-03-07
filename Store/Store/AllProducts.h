//
//  AllProducts.h
//  Store
//
//  Created by sanjeev.bharti on 3/6/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBManager ;
@class ProductCustomCell ;
@class ProductInformationVC ;

@interface AllProducts : UIViewController {
    
    IBOutlet UITableView *mTableView_productList ;

    NSArray *mArray_listOfElements ;
    
    NSInteger mInt_currentlySelectedIndex ;
}

@end
