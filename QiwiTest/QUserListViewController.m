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

#import "QUserCell.h"

#import <EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface QUserListViewController ()

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation QUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    const CGFloat progressHUDSize = 60.0;
    self.progressHUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - progressHUDSize) * 0.5, (self.view.bounds.size.height - progressHUDSize) * 0.5, progressHUDSize, progressHUDSize)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];    
    
    if(IS_PAD && SYS_VERSION >= 7.0) {
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.top += [[UIApplication sharedApplication] statusBarFrame].size.height;
        self.tableView.contentInset = contentInset;
    }
    
    [self setUIActions];
    
    [self updateUsersManually:NO];
}

- (void)setUIActions{
    @weakify(self);
    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self updateUsersManually:YES];
     }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(self.progressHUD != nil && [self.progressHUD superview] == nil) {
        [self.view.superview addSubview:self.progressHUD];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.users = nil;
    [self updateUsersManually:NO];
}

- (void)updateUsersManually:(BOOL)manually {
    if([self.users count] <= 0) {
        [self.progressHUD show:YES];
    }
    @weakify(self);
    [[[QUserViewModel sharedInstance] usersUseCache:!manually]
     subscribeNext:^(NSArray *users) {
         @strongify(self);
         NSLog(@"%ld", [users count]);
         self.users = users;
         [self.progressHUD hide:YES];
     } error:^(NSError *error) {
         @strongify(self);
         NSLog(@"%@", error);
         SHOW_ALERT(_T(@"Ошибка"), [error localizedDescription], 0, nil, _T(@"Закрыть"), nil);
         [self.refreshControl endRefreshing];
         [self.progressHUD hide:YES];
     } completed:^{
         NSLog(@"user list loaded");
     }];
    
}

- (void)setUsers:(NSArray *)users {
    _users = users;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *userCellId = @"userCellId";
    QUserCell *cell = (QUserCell *)[tableView dequeueReusableCellWithIdentifier:userCellId];
    if(cell == nil) {
        cell = [[QUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCellId];
    }
    cell.user = self.users[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [QUserCell heightForUser:self.users[indexPath.row] cellWidth:tableView.frame.size.width];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
