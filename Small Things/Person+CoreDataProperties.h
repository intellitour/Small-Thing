//
//  Person+CoreDataProperties.h
//  Small Things
//
//  Created by Leonardo S Rangel on 7/20/15.
//  Copyright © 2015 Leonardo S Rangel. All rights reserved.
//
//  Delete this file and regenerate it using "Create NSManagedObject Subclass…"
//  to keep your implementation up to date with your model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *smallthing;

@end

NS_ASSUME_NONNULL_END
