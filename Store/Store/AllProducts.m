//
//  AllProducts.m
//  Store
//
//  Created by sanjeev.bharti on 3/6/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import "ProductCustomCell.h"
#import "ProductInformationVC.h"

#import "AllProducts.h"
#import "Product.h"
#import "DBManager.h"

@interface AllProducts ()

@end

@implementation AllProducts

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
    
    self.title = @"Products List";

    mTableView_productList.frame = CGRectMake(0.0f, 0.0f, 320.0f, self.view.frame.size.height) ;


	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {

    mArray_listOfElements = [[DBManager sharedInstance] getAllProductsFromStore];
    [mTableView_productList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - UITableview Delegate and DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return mArray_listOfElements.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Test";
    
    ProductCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    Product *_product = [mArray_listOfElements objectAtIndex:indexPath.row];
    
    cell.mLabel_productName.text            = _product.mString_productName  ;
    
    cell.mLabel_productActualPrice.text     = [NSString stringWithFormat:@"%0.2f",_product.mDouble_actualPrice];
    cell.mLabel_salesPrice.text             = [NSString stringWithFormat:@"%0.2f",_product.mDouble_productSalesPrice];
    
    NSString *_path =[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",_product.mInt_productId]];
    cell.mImageView_productPicture.image = [UIImage imageWithContentsOfFile:_path];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    mInt_currentlySelectedIndex = indexPath.row ;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"Edit" sender:self];
    
}

#pragma mark -
#pragma mark - StoryBoard Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"Edit"])
    {
        // Get reference to the destination view controller
        
        ProductInformationVC *vc = [segue destinationViewController];
        
        vc.mProduct = [[[DBManager sharedInstance] getAllProductsFromStore] objectAtIndex:mInt_currentlySelectedIndex];
        
        vc.mString_createOrUpdate = kupdate ;
        //NSLog(@"%@",vc.mString_createOrUpdate);
    }
}


@end
