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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.movieService getAssets:self.endpoint];
    });
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.movieService getAssets:self.endpoint];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movieService.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
