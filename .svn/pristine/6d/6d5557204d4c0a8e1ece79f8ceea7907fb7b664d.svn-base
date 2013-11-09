//
//  ViewController.m
//  BlueLibrary
//
//  Created by Eli Ganem on 31/7/13.
//  Copyright (c) 2013 Eli Ganem. All rights reserved.
//

#import "ViewController.h"

#import "LibraryAPI.h"
#import "Album+TableRepresentation.h"

#import "AlbumView.h"
#import "HorizontalScroller.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,HorizontalScrollerDelegate>
{
    UITableView *dataTable;
    NSArray *allAlbums;
    NSDictionary *currentAlbumData;
    NSUInteger currentAlbumIndex;
    HorizontalScroller *scroller;
    
    UIToolbar *toolbar;
    NSMutableArray *undoStack;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.76f green:0.81f blue:0.87f alpha:1];
   
    currentAlbumIndex = 0;
    
    toolbar = [[UIToolbar alloc] init];
    
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoAction)];
    undoItem.enabled = NO;
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteAction)];
    
    toolbar.items = @[undoItem,space,deleteItem];
    [self.view addSubview:toolbar];
    
    undoStack = [[NSMutableArray alloc] init];
    
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    [self loadPreviousState];
    
    scroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 120)];
    scroller.backgroundColor = [UIColor colorWithRed:0.24f green:0.35f blue:0.49f alpha:1];
    scroller.delegate = self;
    [self.view addSubview:scroller];
    
    [self reloadScroller];
    
    dataTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 120) style:UITableViewStyleGrouped];
    dataTable.dataSource = self;
    dataTable.delegate = self;
    dataTable.backgroundView = nil;
    [self.view addSubview:dataTable];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentState) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)undoAction{
    if ([undoStack count]>0) {
        NSInvocation *invocation = [undoStack lastObject];
        
        [undoStack removeLastObject];
        
        [invocation invoke];
    }else{
        [toolbar.items[0] setEnabled:NO];
    }
}

- (void)deleteAction{
    [self deleteAlbum];
}

- (void)viewWillLayoutSubviews{
    toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 44, CGRectGetWidth(self.view.frame), 44);
    
    dataTable.frame = CGRectMake(0, 130, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 200);
}

- (void)showDataForAlbumAtIndex:(NSUInteger)albumIndex{
    if (albumIndex < [allAlbums count]) {
        Album *album = allAlbums[albumIndex];
        currentAlbumData = [album tr_tableRepresentation];
    }else{
        currentAlbumData = nil;
    }
    [dataTable reloadData];
}

- (void)reloadScroller{
    
    allAlbums = [[LibraryAPI sharedInstance] getAlbums];
    
    if (currentAlbumIndex >= allAlbums.count) currentAlbumIndex = allAlbums.count-1;
    
    [scroller reload];
    
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (void)saveCurrentState{
    [[NSUserDefaults standardUserDefaults] setInteger:currentAlbumIndex forKey:@"currentAlbumIndex"];
    [[LibraryAPI sharedInstance] saveAlbums];
}

- (void)loadPreviousState{
    currentAlbumIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentAlbumIndex"];
    [self showDataForAlbumAtIndex:currentAlbumIndex];
}

- (void)addAlbum:(Album *) album atIndex:(NSUInteger) index{
    [[LibraryAPI sharedInstance] addAlbum:album atIndex:index];
    
    currentAlbumIndex = index;
    [self reloadScroller];
}

- (void)deleteAlbum{
    Album *deleteAlbum = allAlbums[currentAlbumIndex];
    
    NSMethodSignature *sig = [self methodSignatureForSelector:@selector(addAlbum:atIndex:)];
    
    NSInvocation *undoAction = [NSInvocation invocationWithMethodSignature:sig];
    [undoAction setTarget:self];
    [undoAction setSelector:@selector(addAlbum:atIndex:)];
    [undoAction setArgument:&deleteAlbum atIndex:2];
    [undoAction setArgument:&currentAlbumIndex atIndex:3];
    [undoAction retainArguments];
    
    [undoStack addObject:undoAction];
    
    [[LibraryAPI sharedInstance] deleteAlbumAtIndex:currentAlbumIndex];
    [self reloadScroller];
    
    [toolbar.items[0] setEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIde = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIde];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIde];
    }
    
    cell.textLabel.text = currentAlbumData[@"titles"][indexPath.row];
    cell.detailTextLabel.text = currentAlbumData[@"values"][indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [currentAlbumData[@"titles"] count];
}

- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller *)scroller{
    return [allAlbums count];
}

- (UIView *)horizontalScroller:(HorizontalScroller *)scroller viewAtIndex:(NSUInteger)index{
    Album *album = allAlbums[index];
    return [[AlbumView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) albumCover:album.coverUrl];
}

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(NSUInteger)index{
    currentAlbumIndex = index;
    
    [self showDataForAlbumAtIndex:index];
}

- (NSInteger)initialViewIndexForHorizontalScroller:(HorizontalScroller *)scroller{
    return currentAlbumIndex;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

@end
