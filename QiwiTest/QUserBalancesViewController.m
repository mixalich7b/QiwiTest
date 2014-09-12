//
//  QUserBalancesViewController.m
//  QiwiTest
//
//  Created by Константин Тупицин on 11.09.14.
//  Copyright (c) 2014 mixalich7b. All rights reserved.
//

#import "QUserBalancesViewController.h"

#import "QBalanceCell.h"

#import "QUser.h"
#import "QBalance.h"
#import "QUserViewModel.h"

#import <EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface QUserBalancesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *balances;

@property (nonatomic, weak) MBProgressHUD *progressHUD;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIRefreshControl *refreshControl;
@property (nonatomic, weak) UILabel *notSelectedLabel;


@end

@implementation QUserBalancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.allowsSelection = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    if(self.user == nil) {
        self.tableView.hidden = YES;
    }
    
    if(IS_PAD && SYS_VERSION >= 7.0) {
        UIEdgeInsets contentInset = self.tableView.contentInset;
        contentInset.top += 20.0;
        self.tableView.contentInset = contentInset;
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    UILabel *notSelectedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMidY(self.view.bounds) - 25.0, self.view.frame.size.width, 50.0)];
    [notSelectedLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleBottomMargin];
    notSelectedLabel.font = [UIFont boldSystemFontOfSize:24.0];
    notSelectedLabel.text = _T(@"Выберите пользователя");
    notSelectedLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:notSelectedLabel];
    self.notSelectedLabel = notSelectedLabel;
    if(self.user != nil) {
        self.notSelectedLabel.hidden = YES;
    }
    
    const CGFloat progressHUDSize = 60.0;
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - progressHUDSize) * 0.5, (self.view.bounds.size.height - progressHUDSize) * 0.5, progressHUDSize, progressHUDSize)];
    [self.view addSubview:progressHUD];
    self.progressHUD = progressHUD;
    
    [self setUIActions];
}

- (void)setUIActions{
    @weakify(self);
    [[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         if(_user != nil) {
             [self updateBalances];
         } else {
             [self.refreshControl endRefreshing];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.balances = nil;
    [self updateBalances];
}

- (void)updateBalances {
    if([self.balances count] <= 0) {
        [self.progressHUD show:YES];
    }
    @weakify(self);
    [[[QUserViewModel sharedInstance] balancesWithUserId:self.user.userId]
     subscribeNext:^(NSArray *balances) {
         @strongify(self);
         self.balances = balances;
         [self.progressHUD hide:YES];
     } error:^(NSError *error) {
         @strongify(self);
         NSLog(@"%@", error);
         SHOW_ALERT(_T(@"Ошибка"), [error localizedDescription], 0, nil, _T(@"Закрыть"), nil);
         [self.refreshControl endRefreshing];
         [self.progressHUD hide:YES];
     } completed:^{
         NSLog(@"balance list loaded");
     }];
}

- (void)setBalances:(NSArray *)balances {
    _balances = balances;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)setUser:(QUser *)user {
    _user = user;
    self.balances = nil;
    [self.tableView reloadData];
    if(_user != nil) {
        [self updateBalances];
        self.notSelectedLabel.hidden = YES;
        self.tableView.hidden = NO;
    } else {
        self.notSelectedLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.balances count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *balanceCellId = @"balanceCellId";
    QBalanceCell *cell = (QBalanceCell *)[tableView dequeueReusableCellWithIdentifier:balanceCellId];
    if(cell == nil) {
        cell = [[QBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:balanceCellId];
    }
    cell.balance = self.balances[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [QBalanceCell heightForBalance:self.balances[indexPath.row] cellWidth:tableView.frame.size.width];
}

@end
