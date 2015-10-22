//
//  cbrTableViewCell.h
//  fieldMobile
//
//  Created by Hai Tran on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cbrTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *subtitleLabel;
    IBOutlet UILabel *distanceLabel;
    IBOutlet UILabel *addressLabel;
    IBOutlet UIImageView *momentumImage;
    IBOutlet UILabel *numberCollections;
    IBOutlet UIButton *favoriteButton;
}

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *subtitleLabel;
@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UIImageView *momentumImage;
@property (strong, nonatomic) UILabel *numberCollections;
@property (strong, nonatomic) UIButton *favoriteButton;
@end
