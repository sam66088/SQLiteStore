//
//  ProductInformationVC.h
//  Store
//
//  Created by sanjeev.bharti on 3/5/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Product      ;
@class DBManager    ;

@interface ProductInformationVC : UIViewController <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate > {
    
    IBOutlet    UITextField *mTextField_productName ;
    IBOutlet    UITextField *mTextField_productDescreption ;
    IBOutlet    UITextField *mTextField_productRegularPrice ;
    IBOutlet    UITextField *mTextField_productSalesPrice ;
    
    IBOutlet    UIImageView     *mImageView_productPhoto ;
    IBOutlet    UITextField     *mTextField_ProductColor ;
    IBOutlet    UITextField     *mTextField_productStore ;
    
    IBOutlet    UIView          *mView_container ;
    
    IBOutlet    UIButton        *mButton_updateOrInsert ;
    
    NSString    *mString_createOrUpdate ;
    Product     *mProduct ;
    IBOutlet UIBarButtonItem     *mBarButton_right ;
}

@property (nonatomic,copy) NSString    *mString_createOrUpdate ;
@property (nonatomic,retain) Product    *mProduct ;

- (IBAction)createOrUpdateButtonPressed:(UIButton *)pressedButton ;
- (void)loadValuesFromDatabaseForProduct ;

@end
