//
//  DownloadCell.m
//  dropLink
//
//  Created by dave on 12/16/12.
//  Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell
@synthesize downloadImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
