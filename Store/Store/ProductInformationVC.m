//
//  ProductInformationVC.m
//  Store
//
//  Created by sanjeev.bharti on 3/5/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import "ProductInformationVC.h"
#import "Product.h"
#import "DBManager.h"

#define kStoreKey  @"StoreKey"

@interface ProductInformationVC ()

@end

@implementation ProductInformationVC

@synthesize mString_createOrUpdate ;
@synthesize mProduct ;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    mView_container.frame = CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height - 44.0f) ;
    
    mView_container.center = self.view.center ;

    //NSLog(@"%@",self.mString_createOrUpdate) ;

    if ([self.mString_createOrUpdate isEqualToString:kupdate]) {
        [self loadValuesFromDatabaseForProduct];
    }
    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (![self.mString_createOrUpdate isEqualToString:kupdate]) {

        [mButton_updateOrInsert setTitle:@"Insert" forState:UIControlStateNormal];

    } else {

        [mButton_updateOrInsert setTitle:@"Update" forState:UIControlStateNormal];
        
        [self createRightBarButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - TextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:mTextField_productStore] || [textField isEqual:mTextField_ProductColor]) {
        
        [UIView animateWithDuration:0.3f animations:^{
            mView_container.center = CGPointMake(self.view.center.x, self.view.center.y - 100) ;
            
        }] ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
   
    if ([textField isEqual:mTextField_productStore] || [textField isEqual:mTextField_ProductColor]) {
        mView_container.center = self.view.center ;
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [textField resignFirstResponder];
   
    if ([textField isEqual:mTextField_productStore] || [textField isEqual:mTextField_ProductColor]) {
   
        [UIView animateWithDuration:1.0f animations:^{
            mView_container.center = self.view.center ;

        }] ;
    }
    return YES ;
}


#pragma mark -
#pragma mark - User Defined Methods

- (IBAction)createOrUpdateButtonPressed:(UIButton *)pressedButton {
    
    Product *_product = [[Product alloc] init];
    
    _product.mString_productName        = mTextField_productName.text ;
    _product.mString_productDescreption = mTextField_productDescreption.text ;
    _product.mDouble_actualPrice        = [mTextField_productRegularPrice.text doubleValue];
    _product.mDouble_productSalesPrice  = [mTextField_productSalesPrice.text doubleValue];
    _product.mArray_productColor        = [NSArray arrayWithObject:mTextField_ProductColor.text];
    _product.mDict_productStore         = [NSDictionary dictionaryWithObject:mTextField_productStore.text forKey:kStoreKey];

    if (mTextField_productName.text.length > 0) {

    if (![self.mString_createOrUpdate isEqualToString:kupdate]) {
        
        [[DBManager sharedInstance] insertRecordToStoreWithProduct:_product];
        
    } else {
        
        _product.mInt_productId = self.mProduct.mInt_productId ;
        [[DBManager sharedInstance] updateRecordToStoreWithProduct:_product];
    }
   
    [self.navigationController popViewControllerAnimated:YES];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!" message:@"Please Enter Name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil ;
    }
}

- (void)loadValuesFromDatabaseForProduct {
    
    mTextField_productName.text = mProduct.mString_productName ;
    
    mTextField_productDescreption.text = mProduct.mString_productDescreption;
    
    mTextField_productRegularPrice.text = [[NSNumber numberWithDouble:mProduct.mDouble_actualPrice] stringValue] ;
    mTextField_productSalesPrice.text = [[NSNumber numberWithDouble:mProduct.mDouble_productSalesPrice] stringValue] ;
    
    if (mProduct.mArray_productColor.count > 0) {
        mTextField_ProductColor.text = [mProduct.mArray_productColor objectAtIndex:0];
    }
    if (mProduct.mDict_productStore) {
        mTextField_productStore.text = [mProduct.mDict_productStore objectForKey:kStoreKey];

    }
    
    NSString *_path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",self.mProduct.mInt_productId]];
    
    mImageView_productPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:_path]];
    
    _path = nil ;
    
}

- (IBAction)getPhotoFromLib:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)saveImageWithUniqueNameToDocumentDirectory:(UIImage *)_image {
    
    int _rowNumber = 0;
    
    if (![self.mString_createOrUpdate isEqualToString:kupdate]) {
        
        _rowNumber = [[DBManager sharedInstance] fetchHeightRowNumberFromDataBase];
        _rowNumber++ ;
        
    } else {
        
        _rowNumber = self.mProduct.mInt_productId;

    }
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",_rowNumber]];
    
    NSData *_imageData = UIImagePNGRepresentation(_image) ;
    
    [_imageData writeToFile:path atomically:YES];
    
    path = nil ;
    _imageData = nil ;
}

- (void)createRightBarButton {
   
    UIBarButtonItem *_deleteButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Delete"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(deleteEntry)];
    
    self.navigationItem.rightBarButtonItem = _deleteButton;
}

- (void)deleteEntry {
    
    [[DBManager sharedInstance] deleteRecordFromStoreWithProduct:self.mProduct];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",self.mProduct.mInt_productId]];

    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark - UIImagePickerController Methods


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    mImageView_productPhoto.image = chosenImage;
    
    [self saveImageWithUniqueNameToDocumentDirectory:chosenImage];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


@end
