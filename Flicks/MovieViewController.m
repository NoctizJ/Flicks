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
#import "MovieCollectionViewCell.h"
#import "MovieService.h"
#import "MovieData.h"
#import "UIImageView+AFNetworking.h"
#import "SVProgressHUD.h"

static NSString *const posterImageURL = @"https://image.tmdb.org/t/p/w342";

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *MovieUISearchBar;
@property (assign, nonatomic) BOOL isFiltered;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) MovieService *movieService;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSMutableArray *filterMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIRefreshControl *refreshControl2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *switchControl;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [SVProgressHUD show];
    [self.tableView setHidden:YES];
    
    self.MovieUISearchBar.delegate = self;
    UITextField *textField = [self.MovieUISearchBar valueForKey:@"_searchField"];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.movies = [NSArray array];
    self.filterMovies = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.movieService = [[MovieService alloc] initWithEndpoint:self.endpoint];
    
    // refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl2 = [[UIRefreshControl alloc] init];
    [self.refreshControl2 addTarget:self action:@selector(onRefresh2) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.collectionView insertSubview:self.refreshControl2 atIndex:0];
    
    [self getAssetsAsync];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    [self.collectionView reloadData];
    [self.refreshControl endRefreshing];
    [self fadeInImage];
    [SVProgressHUD dismiss];
    [self.tableView setHidden:NO];
}

- (void) onRefresh2
{
    [self.tableView reloadData];
    [self.collectionView reloadData];
    [self.refreshControl2 endRefreshing];
    [SVProgressHUD dismiss];
}

- (void)fadeInImage
{
    for (MovieTableViewCell* cell in self.tableView.visibleCells) {
        cell.movieImage.alpha = 0;
        [UIView animateWithDuration:0.6 animations:^{
            cell.movieImage.alpha = 1;
        }];
    }
}


#pragma mark - Table View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    cell.movietitle.text = ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).title;
    [cell.movietitle sizeToFit];
    cell.movieDescription.text = ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).overview;
    cell.movieDescription.lineBreakMode = NSLineBreakByWordWrapping;
    cell.movieDescription.numberOfLines = 0;
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterImageURL, ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).poster]]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filterMovies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollectionCell" forIndexPath:indexPath];
    [cell.movieImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", posterImageURL, ((MovieData *)[self.filterMovies objectAtIndex:indexPath.row]).poster]]];
    return cell;
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
    [self.collectionView reloadData];
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
    [self.collectionView reloadData];
}

#pragma mark - Switch tableView and collectionView

- (IBAction)onValueChanged:(UISegmentedControl *)sender {
    if (self.switchControl.selectedSegmentIndex == 0) {
        self.tableView.hidden = NO;
        //self.MovieUISearchBar.hidden = NO;
        self.collectionView.hidden = YES;
    } else {
        self.tableView.hidden = YES;
        //self.MovieUISearchBar.hidden = YES;
        self.collectionView.hidden = NO;
    }
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    MovieDetailViewController *vc = segue.destinationViewController;
    vc.movie = self.filterMovies[indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
