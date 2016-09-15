//
//  ViewController.m
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieDetailViewController.h"
#import "MovieTableViewCell.h"
#import "MovieService.h"
#import "MovieData.h"
#import "UIImageView+AFNetworking.h"

static NSString *const posterImageURL = @"https://image.tmdb.org/t/p/w342";

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MovieService *movieService;
@property (strong, nonatomic) NSMutableArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.movies = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.movieService = [[MovieService alloc] initWithEndpoint:self.endpoint];
    
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getAssetsAsync];
}

#pragma mark - Server Request

- (void)getAssetsAsync
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.movieService getAssets:self.endpoint withCompletionHandler:^{
            [self onRefresh];
        }];
    });
}

- (void) onRefresh
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movieService.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    self.movies = [[self.movieService movies] mutableCopy];
    cell.movietitle.text = ((MovieData *)[self.movies objectAtIndex:indexPath.row]).title;
    cell.movieDescription.text = ((MovieData *)[self.movies objectAtIndex:indexPath.row]).overview;
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterImageURL, ((MovieData *)[self.movies objectAtIndex:indexPath.row]).poster]]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieDetailViewController *vc = segue.destinationViewController;
    vc.movie = self.movies[indexPath.row];
}

@end
