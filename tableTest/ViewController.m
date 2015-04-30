
//  ViewController.m
//  tableTest
//
//  Created by Craig Merchant on 29/04/2015.
//  Copyright (c) 2015 Craig Merchant. All rights reserved.
//

#import "ViewController.h"
#import "EventView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildHeaderView];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Initially hide the header
    self.tableView.contentOffset = CGPointMake(0, self.tableView.tableHeaderView.bounds.size.height);
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) buildHeaderView
{
    self.headerView.frame = CGRectMake(0, 0, self.headerView.frame.size.width, 60);
    
    EventView *testView = [[EventView alloc] initWithFrame:self.headerView.bounds];
    testView.backgroundColor = [UIColor colorWithRed:(247.0/255.0) green:(247.0/255.0) blue:(245.0/255.0) alpha:1.0];
    testView.userInteractionEnabled=TRUE;
    testView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 16, testView.bounds.size.width-20, 29)];
    [seg addTarget:self action:@selector(segmentedControlIndexChanged:) forControlEvents:UIControlEventValueChanged];
    
    seg.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [seg insertSegmentWithTitle:@"Scroll" atIndex:0 animated:NO];
    [seg insertSegmentWithTitle:@"Sticky" atIndex:1 animated:NO];
    
    seg.selectedSegmentIndex = 0;
    
    [testView addSubview:seg];
    
    [self.headerView addSubview:testView];
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void) updateHeaderSticky:(BOOL)sticky
{
    self.tableView.tableHeaderView=nil;
    [self.headerView removeFromSuperview];
    
    CGRect headerFrame = self.headerView.frame;
    
    if(sticky){
        self.tableView.tableHeaderView=self.headerView;
        
        headerFrame.origin.y = 0;
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, 0);
    } else {
        [self.view addSubview:self.headerView];
        
        headerFrame.origin.y = self.tableView.frame.origin.y;
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.headerView.bounds.size.height, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -self.headerView.bounds.size.height);
    }
    
    self.headerView.frame = headerFrame;
    
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

#pragma mark UISegmentControl

-(void)segmentedControlIndexChanged:(UISegmentedControl*)seg
{
    switch (seg.selectedSegmentIndex)
    {
        case 0:
            [self updateHeaderSticky:YES];
            break;
        case 1:
            [self updateHeaderSticky:NO];
            break;
        default:
            break;
    }
}

#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = @"Cell";
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
