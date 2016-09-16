//
//  MovieDetailViewController.m
//  Flicks
//
//  Created by Yuning Jin on 9/14/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

static NSString *const posterImageURL = @"https://image.tmdb.org/t/p/original";

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieTime;
@property (weak, nonatomic) IBOutlet UILabel *movieOverview;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIScrollView *cardScrollView;


@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    
    [self.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterImageURL, self.movie.poster]]];
    
    self.movieTitle.text = self.movie.title;
    self.movieTime.text = self.movie.time;
    self.movieOverview.text = self.movie.overview;
    self.movieOverview.lineBreakMode = NSLineBreakByWordWrapping;
    self.movieOverview.numberOfLines = 0;
    [self.movieOverview sizeToFit];
    [self.cardView sizeToFit];
    self.cardScrollView.contentSize = self.cardView.frame.size;
    [self.cardScrollView setShowsVerticalScrollIndicator:NO];
    
    [SVProgressHUD dismiss];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
