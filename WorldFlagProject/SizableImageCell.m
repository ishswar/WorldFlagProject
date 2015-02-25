//
//  SizableImageCell.m
//  WorldFlagProject
//
//  Created by Pranay Shah on 2/25/15.
//  Copyright (c) 2015 Pranay Shah. All rights reserved.
//

#import "SizableImageCell.h"


@implementation SizableImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.frame = CGRectMake(10.0, 19.0, 240.0, 27.0);
        
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float desiredWidth = 35;
    float w=self.imageView.frame.size.width;
    if (w>desiredWidth) {
        float widthSub = w - desiredWidth;
        self.imageView.frame = CGRectMake(self.imageView.frame.origin.x,self.imageView.frame.origin.y,desiredWidth,self.imageView.frame.size.height);
        self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x-widthSub,self.textLabel.frame.origin.y,self.textLabel.frame.size.width+widthSub,self.textLabel.frame.size.height);
        self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x-widthSub,self.detailTextLabel.frame.origin.y,self.detailTextLabel.frame.size.width+widthSub,self.detailTextLabel.frame.size.height);
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}
@end
