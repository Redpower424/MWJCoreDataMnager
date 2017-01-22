//
//  MWJCoreDataManager.h
//  CoreDataManager
//
//  Created by Redpower on 2017/1/22.
//  Copyright © 2017年 Redpower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MWJCoreDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext* context;

+ (instancetype)shareInstance;

//创建MO对象
- (NSManagedObject *)createMO:(NSString *)entityName;

//1.添加对象
- (void)saveManagerObj:(NSManagedObject *)mo;

//2.查询
- (NSArray *)query:(NSString *)entifyName
         predicate:(NSPredicate *)predicate;

//3.修改mo
- (void)updateManagerObj:(NSManagedObject *)mo;

//4.删除
- (void)removeManagerObj:(NSManagedObject *)mo;


@end
