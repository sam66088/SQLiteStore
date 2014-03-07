//
//  Product.h
//  Store
//
//  Created by sanjeev.bharti on 3/6/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
    
    int             mInt_productId ;
    
    double          mDouble_actualPrice ;
    double          mDouble_productSalesPrice ;
    
    NSString        *mString_productName ;
    NSString        *mString_productDescreption ;

    NSArray          *mArray_productColor ;
    NSDictionary          *mDict_productStore ;
    
}

@property (nonatomic) int             mInt_productId ;
@property (nonatomic) double          mDouble_actualPrice ;
@property (nonatomic) double          mDouble_productSalesPrice ;

@property (nonatomic, copy) NSString    *mString_productName ;
@property (nonatomic, copy) NSString    *mString_productDescreption ;

@property (nonatomic, retain) NSArray        *mArray_productColor ;
@property (nonatomic, retain) NSDictionary        *mDict_productStore ;



@end
