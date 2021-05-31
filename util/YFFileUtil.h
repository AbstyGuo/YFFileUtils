//
//  YFFileUtil.h
//  Expecta
//
//  Created by guoyf on 2020/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFFileUtil : NSObject

#pragma mark - 获取路径
//获取沙盒主目录路径
+ (NSString *)homeDir;

//获取沙盒中的Document路径
+ (NSString *)documentsDir;

//获取沙盒中的Library路径
+ (NSString *)libraryDir;

//获取沙盒中Libarary/Preferences的目录路径
+ (NSString *)preferencesDir;

//获取沙盒中Library/Caches的目录路径
+ (NSString *)cachesDir;

//获取沙盒中tmp的目录路径
+ (NSString *)tmpDir;

#pragma mark - 文件处理
//创建文件夹
+ (BOOL)createDirectoryAtPath:(NSString *)path;

//创建文件
+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite;


//删除文件、文件夹
+ (BOOL)removeItemAtPath:(NSString *)path;

//获取文件创建的时间
+ (NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;
 
//获取文件修改的时间
+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;


//写入文件内容
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content;

//清空Cashes文件夹
+ (BOOL)clearCachesDirectory;

//清空temp文件夹
+ (BOOL)clearTmpDirectory;

//复制文件夹
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite;

//判断文件是否存在
+ (BOOL)isExistsAtPath:(NSString *)path;

//移动文件夹
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error;

//获取文件名
+ (NSString *)fileNameAtPath:(NSString *)path suffix:(BOOL)suffix;

//获取文件所在的文件夹路径
+ (NSString *)directoryAtPath:(NSString *)path;

//根据文件路径获取文件扩展类型
+ (NSString *)suffixAtPath:(NSString *)path;

//判断文件路径是否为空，文件夹没有子文件或者文件长度为0；
+ (BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

//判断目录是否是文件夹
+ (BOOL)isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

//判断目录是否是文件
+ (BOOL)isFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

//判断目录是否可以执行
+ (BOOL)isExecutableItemAtPath:(NSString *)path;

//判断目录是否可读
+ (BOOL)isReadableItemAtPath:(NSString *)path;

//判断目录是否可写
+ (BOOL)isWritableItemAtPath:(NSString *)path;

//获取文件大小
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

//获取文件夹大小
+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

//获取文件大小（单位为字节）
+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

//获取文件夹大小（单位为字节）
+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;

/**
 文件遍历
 参数1：目录的绝对路径
 参数2：是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
 2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 */
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

//获取文件属性
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error;

//获取文件属性集合
+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error;



@end

NS_ASSUME_NONNULL_END
