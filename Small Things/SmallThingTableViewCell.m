//
//  SmallThingTableViewCell.m
//  Small Things
//
//  Created by Leonardo S Rangel on 7/16/15.
//  Copyright © 2015 Leonardo S Rangel. All rights reserved.
//

#import "SmallThingTableViewCell.h"

@interface SmallThingTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;


@end

@implementation SmallThingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configureCellWithImage:(UIImage *)image andTitle:(NSString *)title andSubtitle:(NSString *)subtitle WithImage2:(UIImage *)image2 {
    [_image1 setImage:image];
    [_titleLabel setText:title];
    //[_titleLabel setFont:[UIFont fontWithName:@"JosefinSans-Bold.ttf" size:20.0]];
    [_subtitleLabel setText:subtitle];
    //[_subtitleLabel setFont:[UIFont fontWithName:@"JosefinSans-Italic.ttf" size:12.0]];
    [_image2 setImage:image2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
