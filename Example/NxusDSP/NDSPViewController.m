//
//  NDSPViewController.m
//  NxusDSP
//
//  Copyright (c) 2016 TechMpire ltd. All rights reserved.
//

#import "NDSPViewController.h"
#import "NxusDSP/NxusDSP.h"

@interface NDSPViewController ()

@property (weak, nonatomic) IBOutlet UITableView *paramsTable;
@property (strong, nonatomic) NSMutableArray *dataSource;

- (IBAction)addParameter:(id)sender;
- (IBAction)sendEvent:(id)sender;

@end

@implementation NDSPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.paramsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = [[NSMutableArray alloc] init];
    
    [NxusDSP trackEvent:@"test-event"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addParameter:(id)sender {
    [self.dataSource addObject:[[ParamsRowData alloc] init]];
    [self.paramsTable reloadData];
}

- (IBAction)sendEvent:(id)sender {
    BOOL paramsFilled = YES;
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < [self.dataSource count]; i++) {
        ParamsRowData *rowData = [self.dataSource objectAtIndex:i];
        if(rowData.key && (rowData.key.length > 0) && rowData.value && (rowData.value.length > 0)) {
            [params setValue:rowData.value forKey:rowData.key];
        } else {
            paramsFilled = NO;
            break;
        }
    }
    if (paramsFilled) {
        [NxusDSP trackEvent:@"click" params:params];
    } else {
        UIAlertController *alertNotOk = [UIAlertController alertControllerWithTitle:nil message:@"Please enter all the parameters!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alertNotOk dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertNotOk addAction:actionOk];
        [self presentViewController:alertNotOk animated:YES completion:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = (int)[self.dataSource count];
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ParamsCell";
    
    ParamsTableCell *cell = [self.paramsTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ParamsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ParamsRowData *rowData = [self.dataSource objectAtIndex:indexPath.row];
    cell.paramKey.text = rowData.key;
    cell.paramValue.text = rowData.value;
    cell.cellIndex = (int)indexPath.row;
    cell.delegate = self;
    
    return cell;
}

- (void)deleteParamsTableRow:(NSInteger)cellIndex withData:(id)data {
    [self.dataSource removeObjectAtIndex:cellIndex];
    [self.paramsTable reloadData];
}

- (void)updateKey:(NSInteger)cellIndex key:(NSString *)key {
    ParamsRowData *rowData = [self.dataSource objectAtIndex:cellIndex];
    rowData.key = key;
    [self.dataSource replaceObjectAtIndex:cellIndex withObject:rowData];
}

- (void)updateValue:(NSInteger)cellIndex value:(NSString *)value {
    ParamsRowData *rowData = [self.dataSource objectAtIndex:cellIndex];
    rowData.value = value;
    [self.dataSource replaceObjectAtIndex:cellIndex withObject:rowData];
}

@end
