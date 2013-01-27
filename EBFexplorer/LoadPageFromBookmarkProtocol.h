//
//  LoadPageFromBookmarkProtocol.h
//  EBFexplorer
//
//  Created by Béchir Arfaoui on 27/01/13.
//  Copyright (c) 2013 EBF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadPageFromBookmarkProtocol <NSObject>

-(void)Load:(NSString*)url;
@end
