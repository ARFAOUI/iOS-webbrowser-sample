//
//  SQLManager.h
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 27/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BookmarkItem.h"

@interface SQLManager : NSObject
{
    NSString*databasePath;
    NSString*databaseName;
    sqlite3 *database;
}

@property(nonatomic,retain) NSString*databasePath;
@property(nonatomic,retain) NSString*databaseName;


+ (id)sharedInstance;
-(void)initDB;
-(void) checkAndCreateDatabase;
-(sqlite3*)OpenDatabase;
-(NSMutableArray*)GetBookmarks;
-(void)RemoveBookmarkFromDB:(BookmarkItem*)item;
-(void)AddBookmark:(BookmarkItem*)item;
@end
