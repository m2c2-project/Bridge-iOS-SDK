/*
 Copyright 2011 Marko Karppinen & Co. LLC.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 
 ModelObject.m
 mogenerator / PONSO
 Created by Nikita Zhuk on 22.1.2011.
 */

#import "ModelObject.h"
#import "SBBComponentManager.h"
#import "SBBObjectManager.h"
#import "SBBCacheManager.h"
#import "ModelObjectInternal.h"

@implementation ModelObject

- (id) initWithCoder: (NSCoder*) aDecoder
{
    self = [super init];
    if (self) {
        // Superclass implementation:
        // If we add ivars/properties, here's where we'll load them
    }
    return self;
}

- (void) encodeWithCoder: (NSCoder*) aCoder
{
    // Superclass implementation:
    // If we add ivars/properties, here's where we'll save them
}

+ (id)createModelObjectFromFile:(NSString *)filePath
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        return nil;
    }
    
    NSError *error = nil;
    NSData *plistData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingUncached error:&error];
    if(!plistData)
    {
        NSLog(@"Couldn't read '%@' data from '%@': %@.", NSStringFromClass([self class]), filePath, error);
        return nil;
    }
    
    if([plistData length] == 0)
    {
        NSLog(@"Empty '%@' data found from '%@'.", NSStringFromClass([self class]), filePath);
        return nil;
    }
    
    NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData
                                                                    options:0
                                                                     format:NULL
                                                                      error:&error];
    if(!plist)
    {
        NSLog(@"Couldn't load '%@' data from '%@': %@.", NSStringFromClass([self class]), filePath, error);
        
        return nil;
    }
    
    id modelObject = [[self alloc] initWithDictionaryRepresentation:plist objectManager:SBBComponent(SBBObjectManager)];
    [modelObject awakeFromDictionaryRepresentationInit];
    
    return modelObject;
}

- (BOOL)writeToFile:(NSString *)filePath
{
    if(filePath == nil)
    {
        NSLog(@"File path was nil - cannot write to file.");
        return NO;
    }
    
    // Save this modelObject into plist
    NSDictionary *dict = [self dictionaryRepresentationFromObjectManager:SBBComponent(SBBObjectManager)];
    NSError *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
    if(!plistData)
    {
        NSLog(@"Error while serializing model object of class '%@' into plist. Error: '%@'.", NSStringFromClass([self class]), error);
        
        return NO;
    }
    
    BOOL isDir = NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByDeletingLastPathComponent] isDirectory:&isDir] || !isDir)
    {
        NSError *error = nil;
        if(![[NSFileManager defaultManager] createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"Couldn't create parent directory of file path '%@' for saving model object of class '%@': %@.", filePath,  NSStringFromClass([self class]), error);
            return NO;
        }
    }
    
    if(![plistData writeToFile:filePath atomically:YES])
    {
        NSLog(@"Error while saving model object of class '%@' into plist file %@.",  NSStringFromClass([self class]), filePath);
        return NO;
        
    }
    
    return YES;
}

- (id)initWithDictionaryRepresentation:(NSDictionary *)dictionary objectManager:(id<SBBObjectManagerProtocol>)objectManager
{
    if((self = [super init]))
    {
        self.sourceDictionaryRepresentation = dictionary;
    }
    
    return self;
}

- (NSDictionary *)dictionaryRepresentationFromObjectManager:(id<SBBObjectManagerProtocol>)objectManager
{
    return [NSDictionary dictionary];
}

- (void)awakeFromDictionaryRepresentationInit
{
    self.sourceDictionaryRepresentation = nil;
}

- (NSEntityDescription *)entityForContext:(NSManagedObjectContext *)context
{
    // will be overridden in generated classes that have an entityIDKeyPath defined in their userInfo in the model
    return nil;
}

- (instancetype)initFromCoreDataCacheWithID:(NSString *)bridgeObjectID objectManager:(id<SBBObjectManagerProtocol>)objectManager
{
    if (self = [super init]) {
        //
    }
    
    return self;
}

- (instancetype)initWithManagedObject:(NSManagedObject *)managedObject objectManager:(id<SBBObjectManagerProtocol>)objectManager cacheManager:(id<SBBCacheManagerProtocol>)cacheManager
{
    if (self = [super init]) {
        // generated subclasses will override this
    }
    
    return self;
}

- (void)saveToCoreDataCacheWithObjectManager:(id<SBBObjectManagerProtocol>)objectManager
{
    // If objectManager doesn't define a cacheManager, or the generated code for this object doesn't
    // define an entity (because there's no entityIDKeyPath in the userInfo), this method does nothing
    if ([objectManager respondsToSelector:@selector(cacheManager)]) {
        id<SBBCacheManagerProtocol> cacheManager = [(id)objectManager cacheManager];
        NSManagedObjectContext *cacheContext = cacheManager.cacheIOContext;
        if ([self entityForContext:cacheContext]) {
            [cacheContext performBlockAndWait:^{
                [self saveToContext:cacheContext withObjectManager:objectManager];
            }];
        }
    }
}

- (NSManagedObject *)saveToContext:(NSManagedObjectContext *)cacheContext withObjectManager:(id<SBBObjectManagerProtocol>)objectManager
{
    // generated subclasses will override this
    return nil;
}

- (void) dealloc
{
    self.sourceDictionaryRepresentation = nil;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    // Note: ModelObject is not autoreleased because we are in copy method.
    id<SBBObjectManagerProtocol> oMan = SBBComponent(SBBObjectManager);
    ModelObject *copy = [[[self class] alloc] initWithDictionaryRepresentation:[self dictionaryRepresentationFromObjectManager:oMan] objectManager:oMan];
    [copy awakeFromDictionaryRepresentationInit];
    
    return copy;
}

@synthesize sourceDictionaryRepresentation;

@end


@implementation NSMutableDictionary (PONSONSMutableDictionaryAdditions)

- (void)setObjectIfNotNil:(id)obj forKey:(NSString *)key
{
    if(obj == nil)
        return;
    
    [self setObject:obj forKey:key];
}

@end
