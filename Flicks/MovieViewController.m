//
//  ViewController.m
//  Flicks
//
//  Created by Yuning Jin on 9/13/16.
//  Copyright © 2016 Yuning Jin. All rights reserved.
//

#import "MovieViewController.h"
#import "MovieTableViewCell.h"
#import "MovieService.h"
#import "MovieData.h"

@interface MovieViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MovieService *movieService;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.movieService = [[MovieService alloc] initWithEndpoint:self.endpoint];
    
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
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movieService.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    MovieData *movie = [[self.movieService movies] objectAtIndex:indexPath.row];
    cell.movietitle.text = movie.title;
    cell.movieDescription.text = movie.overview;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
