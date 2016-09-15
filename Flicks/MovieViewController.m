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

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *MovieUISearchBar;
@property (assign, nonatomic) BOOL isFiltered;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MovieService *movieService;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSMutableArray *filterMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.MovieUISearchBar.delegate = self;
    UITextField *textField = [self.MovieUISearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.movies = [NSArray array];
    self.filterMovies = [NSMutableArray array];
    
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
            self.movies = [[self.movieService movies] copy];
            self.filterMovies = [NSMutableArray arrayWithArray:self.movies];
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
    return self.filterMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    cell.movietitle.text = ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).title;
    cell.movieDescription.text = ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).overview;
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterImageURL, ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).poster]]];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar delegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self clearAndDisplay];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0)
    {
        [self clearAndDisplay];
    } else {
        [self filterResults:searchText];
    }
}

- (void)clearAndDisplay
{
    [self.MovieUISearchBar resignFirstResponder];
    self.MovieUISearchBar.text = @"";
    [self clearFilter];
}

- (void)clearFilter
{
    self.filterMovies = [NSMutableArray arrayWithArray:self.movies];
    [self.tableView reloadData];
}

- (void)filterResults:(NSString *)searchText
{
    self.filterMovies = [NSMutableArray array];
    for (MovieData *movie in self.movies)
    {
        BOOL nameMatch = [movie.title rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound;
        if (nameMatch) {
            [self.filterMovies addObject:movie];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieDetailViewController *vc = segue.destinationViewController;
    vc.movie = self.movies[indexPath.row];
}

@end
