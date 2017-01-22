//
//  MWJCoreDataManager.m
//  CoreDataManager
//
//  Created by Redpower on 2017/1/22.
//  Copyright © 2017年 Redpower. All rights reserved.
//

#import "MWJCoreDataManager.h"

@implementation MWJCoreDataManager

+ (instancetype)shareInstance{
    static dispatch_once_t token;
    static MWJCoreDataManager *instance;
    
    dispatch_once(&token, ^{
        instance = [[[self class] alloc]init];
        [instance openDB];
    });
    return instance;
}

- (void)openDB{
    //01 加载数据模型文件
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *dataModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:url];
    
    //02 创建coordinator 协调器,并与 数据模型关联
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:dataModel];
    
    //03 打开或者创建数据库文件
    //>>01 文件路径
    NSString *filePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/data.sqlite"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    
    
    //>>02 添加 PersistentStore
    // 如果 data.sqlite 不存在，则创建并打开
    // 如果存在 则打开
    //通过 coordinator  添加一个 PersistentStore（与文件相关联）
    NSError *error = nil;
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:fileUrl options:nil error:&error];
    
    if (error) {
        NSLog(@"打开数据库失败  %@",error);
    }else{
        NSLog(@"打开数据库成功");
    }
    
    
    //04 创建 context并与NSPersistentStoreCoordinator 关联
    self.context = [[NSManagedObjectContext alloc] init];
    self.context.persistentStoreCoordinator = coordinator;
    
}

//创建MO对象
- (NSManagedObject *)createMO:(NSString *)entityName{
    if (entityName.length == 0) {
        return nil;
    }
    
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
    return mo;
    
}

//1.添加对象
- (void)saveManagerObj:(NSManagedObject *)mo{
    
    if (mo == nil) {
        return;
    }
    
    [self.context insertObject:mo];
    
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        NSLog(@"保存失败 %@",error);
    }else{
        
        NSLog(@"保存成功");
        
    }
    
    
}

//2.查询
- (NSArray *)query:(NSString *)entifyName
         predicate:(NSPredicate *)predicate{
    
    if (entifyName.length == 0) {
        return nil;
    }
    
    //01 request
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entifyName];
    request.predicate = predicate;
    
    //>>>>>>>>>>>>>>>补充
    //定义排序字段
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"userId" ascending:YES];
    request.sortDescriptors = @[sort];
    //分页查询
    request.fetchLimit = 5;//返回数据个数
    request.fetchOffset = 5;//起始位置
    
    
    //02
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    return  array;
    
    
}

//3.修改mo
- (void)updateManagerObj:(NSManagedObject *)mo{
    if (mo== nil) {
        return;
    }
    NSError *error = nil;
    [self.context save:&error];
    if (error) {
        NSLog(@"保存失败 %@",error);
    }else{
        
        NSLog(@"保存成功");
        
    }
    
    
}

//4.删除
- (void)removeManagerObj:(NSManagedObject *)mo{
    if (mo== nil) {
        return;
    }
    
    [self.context deleteObject:mo];
    [self.context save:nil];
    
    
}

@end
