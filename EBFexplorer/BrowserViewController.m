//
//  ViewController.m
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 24/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//
#import "SocialUtilitisies.h"
#import "BrowserViewController.h"
#import "BookmarkListViewController.h"
#import "AddBookmarkViewController.h"

static const CGFloat kNavBarHeight = 52.0f;
static const CGFloat kLabelHeight = 14.0f;
static const CGFloat kMargin = 10.0f;
static const CGFloat kSpacer = 2.0f;
static const CGFloat kLabelFontSize = 12.0f;
static const CGFloat kAddressHeight = 26.0f;

@implementation BrowserViewController
@synthesize webview,pageTitle,addressField,mytoolbar;
@synthesize back,forward,stop,refresh;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    Share=[[SocialUtilitisies alloc]init];
    
    // adding a navigation bar ! it will contain the window title and the address text field !
    
    CGRect navBarFrame = self.view.bounds;
    navBarFrame.size.height = kNavBarHeight;
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarFrame];
    navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    navBar.tintColor=[UIColor blackColor];
    
    // first adding the window title label
    
    //setup frame
    CGRect labelFrame = CGRectMake(kMargin, kSpacer, navBar.bounds.size.width - 2*kMargin, kLabelHeight);
    //creating the label 
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    //some tweaks for better UX
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.text = @"EBF Germany";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor=[UIColor whiteColor];
    label.textAlignment = 1;
    
    //adding the title label to the navigationbar
    [navBar addSubview:label];
    self.pageTitle = label;
    
    
    // same for the address field 
    CGRect addressFrame = CGRectMake(kMargin, kSpacer*2.0 + kLabelHeight, labelFrame.size.width, kAddressHeight);
    UITextField *address = [[UITextField alloc] initWithFrame:addressFrame];
    address.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    address.borderStyle = UITextBorderStyleRoundedRect;
    address.font = [UIFont systemFontOfSize:17];
    address.keyboardType = UIKeyboardTypeURL;
    address.autocapitalizationType = UITextAutocapitalizationTypeNone;
    address.clearButtonMode = UITextFieldViewModeWhileEditing;
    [address addTarget:self action:@selector(loadAddress:event:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //adding the adresse field to the navbar
    [navBar addSubview:address];
    self.addressField = address;
    
    // here adding the navbar to our view
    [self.view addSubview:navBar];
    
    // now the webview setup and request
    webview.delegate = self;
    webview.scalesPageToFit = YES;
    NSURL* url = [NSURL URLWithString:@"http://ebf.de"];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}


- (void)updateButtons
{
    self.forward.enabled = self.webview.canGoForward;
    self.back.enabled = self.webview.canGoBack;
    self.stop.enabled = self.webview.loading;
}
- (void)updateTitle:(UIWebView*)aWebView
{
    /** 
     here gettig the document title to update the title label in the navigation bar
     the user exprience is very important in all apps
     **/
    
    NSString* Title = [aWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //updating the title on the UI
    self.pageTitle.text = Title;
}
- (void)updateAddress:(NSURLRequest*)request
{
    NSURL* url = [request mainDocumentURL];
    NSString* absoluteString = [url absoluteString];
    self.addressField.text = absoluteString;
}
- (void)loadAddress:(id)sender event:(UIEvent*)event
{
    NSString* urlString = self.addressField.text;
    NSURL* url = [NSURL URLWithString:urlString];
    if(!url.scheme)
    {
        NSString* modifiedURLString = [NSString stringWithFormat:@"http://%@", urlString];
        url = [NSURL URLWithString:modifiedURLString];
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
}
- (void)informError:(NSError*)error
{
    NSString* localizedDescription = [error localizedDescription];
    UIAlertView* alertView = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:localizedDescription delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//webview delegate methods implementation

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self updateAddress:request];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self updateTitle:webView];
    NSURLRequest* request = [webView request];
    [self updateAddress:request];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
    [self informError:error];
}


//show sharing + options 
-(IBAction)shareoptions:(id)sender
{
    NSLog(@"share options");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Bookmark",@"Tweet it !",@"Facebook",@"Mail it ",nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
	[actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"clic detected !");
    
	if(buttonIndex == 0)
    {
		//bookmark the page
        NSLog(@"Bookmarking ... ");
        addbookmark=[[AddBookmarkViewController alloc]initWithNibName:@"AddBookmarkViewController" bundle:nil];
        addbookmark.link=addressField.text;
        addbookmark.windowTitle=pageTitle.text;
       [self presentViewController:addbookmark animated:YES completion:Nil];
        
	}
    if(buttonIndex == 2){
		[Share ShareOnFacebook:pageTitle.text WithLink:addressField.text showSharingUIAt:self];
	}
	if(buttonIndex == 1){
		[Share ShareOnTwitter:pageTitle.text WithLink:addressField.text showSharingUIAt:self];
	}
    if(buttonIndex == 3){
		[Share ShareUsingMail:pageTitle.text WithLink:addressField.text showSharingUIAt:self];
		
	}
    
}


-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)ShowBookmark:(id)sender
{
    BookmarkListViewController*bookmark=[[BookmarkListViewController alloc]initWithNibName:@"BookmarkListViewController" bundle:nil];
    bookmark.delegate=self;
     [self presentViewController:bookmark animated:YES completion:Nil];
}

-(void)Load:(NSString *)url
{
    NSLog(@"%@",url);
    NSURL* Localurl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:Localurl];
    [self.webview loadRequest:request];
}

@end
