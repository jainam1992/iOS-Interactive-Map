//
//  ViewController.m
//  SJSUInteractiveMap
//
//  Created by student on 11/4/15.
//  Copyright (c) 2015 SJSUTeam9. All rights reserved.
//

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import "ViewController.h"
#import "InfoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

double currentLon, currentLat;
NSDictionary *dictionary;
NSString *filePathDictionary;
UIImage *image;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [directories firstObject];
    filePathDictionary = [documents stringByAppendingPathComponent:@"misc-dictionary.plist"];
    
    NSDictionary *loadeddictionary = [NSDictionary dictionaryWithContentsOfFile:filePathDictionary];
    NSLog(@"Initial zooom level is :  %@", loadeddictionary[@"zoomScale"]);
    
    //setting homepage image views and initial zoom
    
    [self.imageView setImage:[UIImage imageNamed:@"campusMap.jpg"]];
    [self.scrollView setClipsToBounds:YES];
    
    self.scrollView.maximumZoomScale = 100;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.zoomScale = [loadeddictionary[@"zoomScale"] floatValue];
    
    //getting current location
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    image = [UIImage imageNamed:@"campusMap.jpg"];
    
    self.setCurrentLocationPointer;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

-(void)setCurrentLocationPointer{
    
    //setting current location point
    self.deviceLocation;
    
    //get current image height and width
    float imageWidth = image.size.width;
    float imageHeight= image.size.height;
    
    float usrx= imageWidth * (fabs(currentLon) -121.886478)/(121.876243 -121.886478);
    float usry= imageHeight - (imageHeight * ( (fabs(currentLat)-37.331361)/(37.338800-37.331361)));
    
    
    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(usrx,usry,10,10)];
    [overlay setBackgroundColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1.5]];
    [_imageView addSubview:overlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deviceLocation
{
    currentLat = self.locationManager.location.coordinate.latitude;
    currentLon = self.locationManager.location.coordinate.longitude;
    
    //if current address not in
    if(currentLat == 0.000000 && currentLon == 0.000000)
    {
        currentLat = 37.333090;
        currentLon = -121.882208;
    }
}

//returning contentview
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

//add search bar
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *str = searchBar.text;
    [self displaySearch : str];
    [searchBar resignFirstResponder];
}

//adding search options
- (void)displaySearch :(NSString*) searchText {
    int buildingId = 0;
    if([searchText.uppercaseString  isEqual: @"ENGINEERING BUILDING"]){
        buildingId = 101;
    }
    else if([searchText.uppercaseString  isEqual: @"KING LIBRARY"]){
        buildingId = 102;
    }
    else if([searchText.uppercaseString  isEqual: @"BBC"]){
        buildingId = 103;
    }
    else if([searchText.uppercaseString  isEqual: @"STUDENT UNION"]){
        buildingId = 104;
    }
    else if([searchText.uppercaseString  isEqual: @"SOUTH PARKING GARAGE"]){
        buildingId = 105;
    }
    else if([searchText.uppercaseString  isEqual: @"YOSHIHIRO UCHIDA HALL"]){
        buildingId = 106;
    }
    if(buildingId != 0){
        UIButton *button=(UIButton *)[self.view viewWithTag:buildingId];
        CGRect zoomRect = CGRectMake(button.frame.origin.x-20, button.frame.origin.y-20, button.frame.size.width+40, button.frame.size.height+40);
        [self.scrollView zoomToRect:zoomRect animated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"KINGSegue"]) {
        [self doAction:1 segue:segue];
    }
    
    else if ([segue.identifier isEqualToString:@"ENGSegue"]) {
        [self doAction:2 segue:segue];
    }
    
    else if ([segue.identifier isEqualToString:@"BBCSegue"]) {
        [self doAction:3 segue:segue];
    }
    
    else if ([segue.identifier isEqualToString:@"YUHSegue"]) {
        [self doAction:4 segue:segue];
    }
    
    else if ([segue.identifier isEqualToString:@"SPGSegue"]) {
        [self doAction:5 segue:segue];
    }
    
    else if ([segue.identifier isEqualToString:@"SUSegue"]) {
        [self doAction:6 segue:segue];
    }
}

- (void)doAction: (int) method
           segue:(UIStoryboardSegue *)segue
{
    switch (method) {
        case 1:
            [self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.335428" destinationLon:@"-121.884834" method:method segue:segue];
            break;
        case 2:
            [self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.337121" destinationLon:@"-121.881629" method:method segue:segue];
            break;
        case 3:
            [self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.336620" destinationLon:@"-121.878352" method:method segue:segue];
            break;
        case 4:
            [self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.333487" destinationLon:@"-121.882962" method:method segue:segue];
            break;
        case 5:
            [self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.332935" destinationLon:@"-121.879928" method:method segue:segue];
            break;
        case 6:
            [self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.336321" destinationLon:@"-121.880940" method:method segue:segue];
            break;
        default:
            break;
    }
    //[self getDistanceFromAPI:[NSNumber numberWithDouble:currentLat] sourceLon:[NSNumber numberWithDouble:currentLon] destinationLat:@"37.335428" destinationLon:@"-121.884834"];
    
}

- (void) getDistanceFromAPI:(NSString *)sourceLat
                  sourceLon:(NSString *)sourceLon
             destinationLat:(NSString *)destinationLat
             destinationLon:(NSString *)destinationLon
                     method:(int)method
                        segue:(UIStoryboardSegue *)segue
{
    __block NSString *responseDistance;
    //__block BOOL flag = false;
    __block NSString *responseDuration;
    
    //NSString *ouputArray[2];
    
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?origins=%@,%@&destinations=%@,%@&mode=walking&key=AIzaSyALkZUrfOFcZ_uyuGkc7XVkYg0QTpqF9jM", sourceLat,sourceLon, destinationLat, destinationLon];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [parseRequest setHTTPMethod:@"GET"];
    
    NSURL *requestURL = [NSURL URLWithString:urlString];
    
    [parseRequest setURL:requestURL];
    
    // Send request to Parse and parse returned data
    [NSURLConnection sendAsynchronousRequest:parseRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSArray *objects;
                               if (data) {
                                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                   objects = [NSArray array];
                                   
                                   //get distance and duration from Google API
                                   responseDistance = responseDictionary[@"rows"][0][@"elements"][0][@"distance"][@"text"];
                                   responseDuration = responseDictionary[@"rows"][0][@"elements"][0][@"duration"][@"text"];
                                   
                                   //calling segue
                                   InfoViewController *v = [segue destinationViewController];
                                   [v setHappiness:method distance:responseDistance duration:responseDuration];
                               }
                           }];
}

//refresh current location
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        currentLon = currentLocation.coordinate.longitude;
        currentLat = currentLocation.coordinate.latitude;
    }
}

//action on zoom level change
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{

    //setting initial zoom value
    dictionary = @{@"zoomScale" : [NSString stringWithFormat:@"%f", self.scrollView.zoomScale]};
    NSLog(@"updated zoom level: %@",[NSString stringWithFormat:@"%f", self.scrollView.zoomScale]);
    
    //saving zoom level in dictionary file
    [dictionary writeToFile:filePathDictionary atomically:YES];
}

//dismissing search keyboard
- (void) dismissKeyboard
{
    [_uiSearchBar resignFirstResponder];
}

@end
