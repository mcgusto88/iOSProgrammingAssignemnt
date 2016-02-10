//
//  ViewController.m
//  iOSProgrammingTest
//
//  Created by Augustus Wilson on 2/9/16.
//  Copyright © 2016 Augustus Wilson. All rights reserved.
//

#import "ViewController.h"
#import "MangerClass.h"
#import "ModelClass.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *searchTblView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
- (IBAction)searchText:(id)sender;
@property(strong,nonatomic)MangerClass *managerClass;
@property(strong,nonatomic)NSMutableArray* searchArray;
@property(strong,nonatomic)NSDictionary *myDict;
@property MBProgressHUD *progressIndicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"Test Log");
    _searchTblView.dataSource = self;
    _searchTblView.delegate = self;
    _searchTF.delegate = self;
    _searchTF.borderStyle = UITextBorderStyleRoundedRect;
    _managerClass = [[MangerClass alloc]init];
    _searchArray = [[NSMutableArray alloc]init];
    _myDict = [[NSDictionary alloc]init];
    _progressIndicator = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progressIndicator];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_searchTF resignFirstResponder];
    
    return  YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _searchArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    UITableViewCell *cell;
    cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    _myDict = [_searchArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [_myDict objectForKey:@"lf"];
    return  cell;
}

- (IBAction)searchText:(id)sender {

    if(_searchArray != nil){
        [_searchArray removeAllObjects];
       // [_progressIndicator hideAnimated:YES];
        [_searchTblView reloadData];
    }
    [_searchTF resignFirstResponder];
    NSString * searchString = [_managerClass searchForText:_searchTF.text];
    if(![searchString isEqualToString:@""]){
        [_progressIndicator showAnimated:YES];

        NSString *urlString = [NSString stringWithFormat:@"http://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@",searchString];
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];


        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSArray *array = [[NSArray alloc]init];
            NSArray *lfsArray = [[NSArray alloc]init];
            NSDictionary *dict = [[NSDictionary alloc]init];
            array = (NSArray*)responseObject;
            NSLog(@"%lu",(unsigned long)array.count);
            if(array.count == 0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"No search Results"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                //_searchArray = nil;
                [_searchTblView reloadData];
            }else{
                
                dict = [array objectAtIndex:0];
                lfsArray = [dict objectForKey:@"lfs"];
                for(NSDictionary *dictt in lfsArray){
                    [_searchArray addObject:dictt];
                    
                }

                [_searchTblView reloadData];
            
            }
            [_progressIndicator hideAnimated:YES];


            NSLog(@"Count of array:%lu",(unsigned long)_searchArray.count);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 4
            [_progressIndicator hideAnimated:YES];

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        // 5

        [operation start];
        
}

}

@end
