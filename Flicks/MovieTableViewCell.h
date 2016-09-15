//
//  MoviesTableViewCell.h
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movietitle;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;

@end
