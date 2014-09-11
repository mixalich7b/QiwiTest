//
//  QUserListViewController.m
//  QiwiTest
//
//  Created by Константин Тупицин on 11.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QUserListViewController.h"
#import "QUserBalancesViewController.h"

#import "QUser.h"
#import "QUserViewModel.h"

#import <EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface QUserListViewController ()

@property (nonatomic, strong) NSArray *users;

@end

@implementation QUserListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];    
    @weakify(self);
    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self updateUsers];
     }];
    
    [self updateUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.users = nil;
    [self updateUsers];
}

- (void)updateUsers {
    [[[QUserViewModel sharedInstance] users]
     subscribeNext:^(NSArray *users) {
         NSLog(@"%ld", [users count]);
         self.users = users;
     } error:^(NSError *error) {
         NSLog(@"%@", error);
         SHOW_ALERT(_T(@"Ошибка"), [error localizedDescription], 0, nil, _T(@"Закрыть"), nil);
         [self.refreshControl endRefreshing];
     } completed:^{
         NSLog(@"user list loaded");
     }];
    
}

- (void)setUsers:(NSArray *)users {
    _users = users;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

@end
