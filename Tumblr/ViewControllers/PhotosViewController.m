//
//  PhotosViewController.m
//  Tumblr
//
//  Created by gilemos on 6/27/19.
//  Copyright © 2019 gilemos. All rights reserved.
//

#import "PhotosViewController.h"
#import "TumblrViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface PhotosViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 240;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    NSURL *url = [NSURL URLWithString:@"https://api.tumblr.com/v2/blog/humansofnewyork.tumblr.com/posts/photo?api_key=Q6vHoaVm5L1u2ZAW1fqv3Jw48gFzYVg9P0vH0VHl3GVy6quoGV"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        else {
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            // Get the dictionary from the response key
            NSDictionary *responseDictionary = dataDictionary[@"response"];
            // Store the returned array of dictionaries in our posts property
            self.posts = responseDictionary[@"posts"];
            
            [self.tableView reloadData];
            // TODO: Get the posts and store in posts property
            // TODO: Reload the table view
        }
    }];
    [task resume];
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TumblrViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ourCell" forIndexPath:indexPath];
    
    NSDictionary *post = self.posts[indexPath.row];
    
    NSArray *photos = post[@"photos"];
    if (photos) {
        // 1. Get the first photo in the photos array
        NSDictionary *photo = photos[0];
        
        // 2. Get the original size dictionary from the photo
        NSDictionary *originalSize =  photo[@"original_size"];
        
        // 3. Get the url string from the original size dictionary
        NSString *urlString = originalSize[@"url"];
        
        // 4. Create a URL using the urlString
        NSURL *url = [NSURL URLWithString:urlString];
        
        // Download the image
        [cell.picture setImageWithURL:url];
    
    }
    
    return cell;

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
