//
//  Forest.m
//  LifeOfForest
//
//  Created by admin on 06/07/16.
//  Copyright © 2016 Saveliy. All rights reserved.
//

#import "Forest.h"
#import "Grass.h"
#import "Herbivore.h"
#import "Predator.h"
#import "Rubbish.h"

@interface Forest ()

@property NSMutableArray *forestBeings;

@end

@implementation Forest


- (instancetype)init
{
    self = [super init];
    if (self){
        _forestBeings = [[NSMutableArray alloc] init];
        for (int i=0; i<3; i++)
            [self.forestBeings addObject:[[Grass alloc] init]];
        for (int i=0; i<3; i++)
            [self.forestBeings addObject:[[Rubbish alloc] init]];
        for (int i=0; i<3; i++)
            [self.forestBeings addObject:[[Herbivore alloc] init]];
        for (int i=0; i<3; i++)
            [self.forestBeings addObject:[[Predator alloc] init]];
    }
    return self;
}


+ (Forest*)sharedInstance
{
    static Forest* _sharedInstance = nil;
    @synchronized(self) {
        if (!_sharedInstance) {
            _sharedInstance = [[Forest alloc] init];
        }
    }
    
    return _sharedInstance;
}


- (BOOL)can:(id)obj1 eat:(id)obj2
{
    if ([obj1 isKindOfClass:[Herbivore class]] && ![obj2 respondsToSelector:@selector(eat:)]){
        return YES;
    }
    if ([obj1 isKindOfClass:[Predator class]] && ![obj2 isKindOfClass:[Grass class]])
    {
        if ([obj2 isKindOfClass:[Rubbish class]]){
            return YES;
        }
        if ([obj2 isKindOfClass:[Herbivore class]]){
            Herbivore *herbivore = obj2;
            return ![herbivore isHide];
        }
        if ([obj2 isKindOfClass:[Predator class]]){
            Predator *predator1 = obj1;
            Predator *predator2 = obj2;
            return (predator1.weight>=predator2.weight) && ![predator2 isProtected];
        }
    }
    return NO;
}


- (int)numberOfHerbivore
{
    int num = 0;
    for (id obj in self.forestBeings)
    {
        if ([obj isKindOfClass:[Herbivore class]]) num++;
    }
    return num;
}


- (int)numberOfPredator
{
    int num = 0;
    for (id obj in self.forestBeings)
    {
        if ([obj isKindOfClass:[Predator class]]) num++;
    }
    return num;
}


- (void)daySimulation
{
    while ([self numberOfHerbivore]>0 || [self numberOfPredator]>1)
    {
        int forestSize = (int)[self.forestBeings count];
        int index1 = arc4random_uniform(forestSize);
        int index2 = arc4random_uniform(forestSize);
        if (index1 != index2)
        {
            id obj1 = self.forestBeings[index1];
            id obj2 = self.forestBeings[index2];
            if ([self can:obj1 eat:obj2])
            {
                [obj1 eat:obj2];
                [self.forestBeings removeObject:obj2];
            }
        }
        
    }
}

@end