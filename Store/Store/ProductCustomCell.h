//
//  ProductCustomCell.h
//  Store
//
//  Created by sanjeev.bharti on 3/6/14.
//  Copyright (c) 2014 sanjeev.bharti. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCustomCell : UITableViewCell {
    
    __weak UILabel      *mLabel_productName        ;
    __weak UILabel      *mLabel_productActualPrice ;
    __weak UILabel      *mLabel_salesPrice         ;
    __weak  UIImageView *mImageView_productPicture  ;
    
}

    @property (nonatomic, weak) IBOutlet UILabel     *mLabel_productName  ;
    @property (nonatomic, weak) IBOutlet UILabel     *mLabel_productActualPrice  ;
    @property (nonatomic, weak) IBOutlet UILabel     *mLabel_salesPrice  ;
    @property (nonatomic, weak) IBOutlet UIImageView     *mImageView_productPicture  ;

@end
