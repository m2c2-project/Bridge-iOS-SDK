//
//  SBBImage.m
//
//  $Id$
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBBImage.h instead.
//

#import "_SBBImage.h"
#import "ModelObjectInternal.h"
#import "NSDate+SBBAdditions.h"

@interface _SBBImage()

@end

// see xcdoc://?url=developer.apple.com/library/etc/redirect/xcode/ios/602958/documentation/Cocoa/Conceptual/CoreData/Articles/cdAccessorMethods.html
@interface NSManagedObject (Image)

@property (nonatomic, strong) NSNumber* height;

@property (nonatomic, assign) double heightValue;

@property (nonatomic, strong) NSString* source;

@property (nonatomic, strong) NSNumber* width;

@property (nonatomic, assign) double widthValue;

@end

@implementation _SBBImage

- (instancetype)init
{
	if((self = [super init]))
	{

	}

	return self;
}

#pragma mark Scalar values

- (double)heightValue
{
	return [self.height doubleValue];
}

- (void)setHeightValue:(double)value_
{
	self.height = [NSNumber numberWithDouble:value_];
}

- (double)widthValue
{
	return [self.width doubleValue];
}

- (void)setWidthValue:(double)value_
{
	self.width = [NSNumber numberWithDouble:value_];
}

#pragma mark Dictionary representation

- (void)updateWithDictionaryRepresentation:(NSDictionary *)dictionary objectManager:(id<SBBObjectManagerProtocol>)objectManager
{
    [super updateWithDictionaryRepresentation:dictionary objectManager:objectManager];

    self.height = [dictionary objectForKey:@"height"];

    self.source = [dictionary objectForKey:@"source"];

    self.width = [dictionary objectForKey:@"width"];

}

- (NSDictionary *)dictionaryRepresentationFromObjectManager:(id<SBBObjectManagerProtocol>)objectManager
{
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super dictionaryRepresentationFromObjectManager:objectManager]];

    [dict setObjectIfNotNil:self.height forKey:@"height"];

    [dict setObjectIfNotNil:self.source forKey:@"source"];

    [dict setObjectIfNotNil:self.width forKey:@"width"];

	return dict;
}

- (void)awakeFromDictionaryRepresentationInit
{
	if(self.sourceDictionaryRepresentation == nil)
		return; // awakeFromDictionaryRepresentationInit has been already executed on this object.

	[super awakeFromDictionaryRepresentationInit];
}

#pragma mark Core Data cache

- (NSEntityDescription *)entityForContext:(NSManagedObjectContext *)context
{
    return [NSEntityDescription entityForName:@"Image" inManagedObjectContext:context];
}

- (instancetype)initWithManagedObject:(NSManagedObject *)managedObject objectManager:(id<SBBObjectManagerProtocol>)objectManager cacheManager:(id<SBBCacheManagerProtocol>)cacheManager
{

    if (self == [super init]) {

        self.height = managedObject.height;

        self.source = managedObject.source;

        self.width = managedObject.width;

    }

    return self;

}

- (NSManagedObject *)saveToContext:(NSManagedObjectContext *)cacheContext withObjectManager:(id<SBBObjectManagerProtocol>)objectManager cacheManager:(id<SBBCacheManagerProtocol>)cacheManager
{
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:cacheContext];
    [self updateManagedObject:managedObject withObjectManager:objectManager cacheManager:cacheManager];

    // Calling code will handle saving these changes to cacheContext.

    return managedObject;
}

- (void)updateManagedObject:(NSManagedObject *)managedObject withObjectManager:(id<SBBObjectManagerProtocol>)objectManager cacheManager:(id<SBBCacheManagerProtocol>)cacheManager
{

    [super updateManagedObject:managedObject withObjectManager:objectManager cacheManager:cacheManager];

    managedObject.height = self.height;

    managedObject.source = self.source;

    managedObject.width = self.width;

    // Calling code will handle saving these changes to cacheContext.
}

#pragma mark Direct access

@end
