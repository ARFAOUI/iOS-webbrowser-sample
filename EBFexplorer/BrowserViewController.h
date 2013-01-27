//
//  ViewController.h
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 24/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "LoadPageFromBookmarkProtocol.h"

@class SocialUtilitisies;
@class AddBookmarkViewController;


@interface BrowserViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate,LoadPageFromBookmarkProtocol>
{
     UIWebView*webview;
     UILabel* pageTitle;
     UITextField* addressField;
    
    UIToolbar*mytoolbar;    
    UIBarButtonItem* back;
    UIBarButtonItem* forward;
    UIBarButtonItem* refresh;
    UIBarButtonItem* stop;
    SocialUtilitisies*Share;
    AddBookmarkViewController*addbookmark;
    
}
@property(nonatomic,retain) IBOutlet UIWebView*webview;
@property (nonatomic, retain) UILabel* pageTitle;
@property (nonatomic, retain) UITextField* addressField;
@property(nonatomic,retain) IBOutlet UIToolbar*mytoolbar;


@property (nonatomic, retain) IBOutlet UIBarButtonItem* back;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* forward;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* refresh;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* stop;

- (void)updateButtons;
- (void)updateTitle:(UIWebView*)aWebView;
- (void)updateAddress:(NSURLRequest*)request;
- (void)loadAddress:(id)sender event:(UIEvent*)event;
- (void)informError:(NSError*)error;
-(IBAction)shareoptions:(id)sender;
-(IBAction)ShowBookmark:(id)sender;
@end
