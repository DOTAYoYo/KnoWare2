//
//  ViewTableViewController.m
//  KnoWare
//
//  Created by Jeremy Storer on 2/15/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//
#define JSON_URL @"http://agile.bgsu.edu/KnoWare/iOS/service.php"
#import "ViewTableViewController.h"
#import "AFNetworking/AFHTTPRequestOperation.h"
#import "ViewMapViewController.h"
#import "SelectedQuerySingleton.h"
#import "QueryTableViewCell.h"

@interface ViewTableViewController (){
    SelectedQuerySingleton *selectedQuery;
}
@property (nonatomic, strong)NSArray *queryArray;
@end

@implementation ViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectedQuery = [SelectedQuerySingleton sharedManager];
   
    [self loadQueries];
    self.tableView.estimatedRowHeight = 10;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"View List" style:UIBarButtonItemStylePlain target:nil action:nil];

}
-(void)viewDidAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.queryArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"Cell";
    
    QueryTableViewCell *cell = (QueryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
//    if (!cell) {
//        cell = [[QueryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//    }
    
    NSDictionary *query = [self.queryArray objectAtIndex:indexPath.row];
    cell.cellQuestion.text = [query objectForKey:@"question"];
    cell.cellID.text = [query objectForKey:@"id"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedQuery = [SelectedQuerySingleton sharedManager];
    selectedQuery.surveyID = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"id"];
    selectedQuery.surveyType = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"response_type"];
    selectedQuery.question = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"question"];
    selectedQuery.choiceOne = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_one"];
    selectedQuery.choiceTwo = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_two"];
    selectedQuery.choiceThree = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_three"];
    selectedQuery.choiceFour = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_four"];
    selectedQuery.choiceFive = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_five"];
    selectedQuery.choiceSix = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_six"];
    selectedQuery.choiceOneHex = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_one_hex"];
    selectedQuery.choiceTwoHex = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_two_hex"];
    selectedQuery.choiceThreeHex = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_three_hex"];
    selectedQuery.choiceFourHex = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_four_hex"];
    selectedQuery.choiceFiveHex = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_five_hex"];
    selectedQuery.choiceSixHex = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"choice_six_hex"];
    selectedQuery.responseMin = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"response_range_start"];
    selectedQuery.responseMax = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"response_range_end"];
    selectedQuery.stepSize = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"response_step"];
    selectedQuery.units = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"units"];
    selectedQuery.linearHexOne = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"linear_hex_1"];
    selectedQuery.linearHexTwo = [self.queryArray[self.tableView.indexPathForSelectedRow.row] objectForKey:@"linear_hex_2"];
    
    [self performSegueWithIdentifier: @"viewToMap" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

-(void)loadQueries{
    NSURL *url = [NSURL URLWithString:@"http://agile.bgsu.edu/KnoWare/iOS/service.php"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.queryArray = responseObject;
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Request Failed: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
}


- (IBAction)homeButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"viewToHome" sender:self];
}
@end
