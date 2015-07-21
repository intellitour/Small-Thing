//
//  SmallThing+CoreDataProperties.h
//  Small Things
//
//  Created by Leonardo S Rangel on 7/20/15.
//  Copyright © 2015 Leonardo S Rangel. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "SmallThing.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallThing (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *smalltext;
@property (nullable, nonatomic, retain) NSData *smallaudio;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
