//
//  YFFileUtil.m
//  Expecta
//
//  Created by guoyf on 2020/4/3.
//

#import "YFFileUtil.h"
#import <UIKit/UIKit.h>

@implementation YFFileUtil

+(void)printError:(NSError *)error{

#if DEBUG
    if(error){
        NSLog(@"---------------%@",error);
    }
#endif
}

//获取沙盒主目录路径
+ (NSString *)homeDir{
    return NSHomeDirectory();
}

//获取沙盒中的Document路径
+ (NSString *)documentsDir{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

//获取沙盒中的Library路径
+ (NSString *)libraryDir{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

//获取沙盒中Libarary/Preferences的目录路径
+ (NSString *)preferencesDir{
    return [[self libraryDir] stringByAppendingPathComponent:@"Preferences"];
}

//获取沙盒中Library/Caches的目录路径
+ (NSString *)cachesDir{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

//获取沙盒中tmp的目录路径
+ (NSString *)tmpDir{
    return NSTemporaryDirectory();
}

#pragma mark - 文件处理
//创建文件夹
+ (BOOL)createDirectoryAtPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
       /* createDirectoryAtPath:withIntermediateDirectories:attributes:error:
        * 参数1：创建的文件夹的路径
        * 参数2：是否创建媒介的布尔值，一般为YES
        * 参数3: 属性，没有就置为nil
        * 参数4: 错误信息
       */
    NSError * error;
       BOOL isSuccess = [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    [self printError:error];
   return isSuccess;

}

//创建文件
+ (BOOL)createFileAtPath:(NSString *)path overwrite:(BOOL)overwrite{
    // 如果文件夹路径不存在，那么先创建文件夹
       NSString *directoryPath = [self directoryAtPath:path];
       if (![self isExistsAtPath:directoryPath]) {
           // 创建文件夹
           if (![self createDirectoryAtPath:directoryPath]) {
               return NO;
           }
       }
       // 如果文件存在，并不想覆盖，那么直接返回YES。
       if (!overwrite) {
           if ([self isExistsAtPath:path]) {
               return YES;
           }
       }
      /*创建文件
       *参数1：创建文件的路径
       *参数2：创建文件的内容（NSData类型）
       *参数3：文件相关属性
       */
       BOOL isSuccess = [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
        
    return isSuccess;
}


//删除文件、文件夹
+ (BOOL)removeItemAtPath:(NSString *)path{
    
    NSError * error;
    BOOL isSuccess = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    [self printError:error];
    return isSuccess;
};

//获取文件创建的时间

//获取文件创建的时间
+ (NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileCreationDate error:error];
}
 
//获取文件修改的时间
+ (NSDate *)modificationDateOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSDate *)[self attributeOfItemAtPath:path forKey:NSFileModificationDate error:error];
}


//写入文件内容
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content{
    //判断文件内容是否为空
   if (!content) {
       [NSException raise:@"非法的文件内容" format:@"文件内容不能为nil"];
       return NO;
   }
       //判断文件(夹)是否存在
       if ([self isExistsAtPath:path]) {
           if ([content isKindOfClass:[NSMutableArray class]]) {//文件内容为可变数组
               [(NSMutableArray *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSArray class]]) {//文件内容为不可变数组
               [(NSArray *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSMutableData class]]) {//文件内容为可变NSMutableData
               [(NSMutableData *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSData class]]) {//文件内容为NSData
               [(NSData *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSMutableDictionary class]]) {//文件内容为可变字典
               [(NSMutableDictionary *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSDictionary class]]) {//文件内容为不可变字典
               [(NSDictionary *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSJSONSerialization class]]) {//文件内容为JSON类型
               [(NSDictionary *)content writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSMutableString class]]) {//文件内容为可变字符串
               [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[NSString class]]) {//文件内容为不可变字符串
               [[((NSString *)content) dataUsingEncoding:NSUTF8StringEncoding] writeToFile:path atomically:YES];
           }else if ([content isKindOfClass:[UIImage class]]) {//文件内容为图片
               [UIImagePNGRepresentation((UIImage *)content) writeToFile:path atomically:YES];
           }else if ([content conformsToProtocol:@protocol(NSCoding)]) {//文件归档
               [NSKeyedArchiver archiveRootObject:content toFile:path];
           }else {
               [NSException raise:@"非法的文件内容" format:@"文件类型%@异常，无法被处理。", NSStringFromClass([content class])];
               
               return NO;
           }
       }else {
           return NO;
       }
       return YES;

}

//清空Cashes文件夹
+ (BOOL)clearCachesDirectory{
    NSArray *subFiles = [self listFilesInDirectoryAtPath:[self cachesDir] deep:NO];
       BOOL isSuccess = YES;
       
       for (NSString *file in subFiles) {
           NSString *absolutePath = [[self cachesDir] stringByAppendingPathComponent:file];
           isSuccess &= [self removeItemAtPath:absolutePath];
       }
       return isSuccess;
}

//清空temp文件夹
+ (BOOL)clearTmpDirectory{
    NSArray *subFiles = [self listFilesInDirectoryAtPath:[self tmpDir] deep:NO];
      BOOL isSuccess = YES;
      
      for (NSString *file in subFiles) {
          NSString *absolutePath = [[self tmpDir] stringByAppendingPathComponent:file];
          isSuccess &= [self removeItemAtPath:absolutePath];
      }
      return isSuccess;

}

//复制文件夹
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite{
    NSError * error;
    // 先要保证源文件路径存在，不然抛出异常
       if (![self isExistsAtPath:path]) {
           [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
           return NO;
       }
       //获得目标文件的上级目录
       NSString *toDirPath = [self directoryAtPath:toPath];
       if (![self isExistsAtPath:toDirPath]) {
           // 创建复制路径
           if (![self createDirectoryAtPath:toDirPath]) {
               return NO;
           }
       }
       // 如果覆盖，那么先删掉原文件
       if (overwrite) {
           if ([self isExistsAtPath:toPath]) {
               [self removeItemAtPath:toPath];
           }
       }
       // 复制文件，如果不覆盖且文件已存在则会复制失败
       BOOL isSuccess = [[NSFileManager defaultManager] copyItemAtPath:path toPath:toPath error:&error];
      [self printError:error];
       
       return isSuccess;

}

//判断文件是否存在
+ (BOOL)isExistsAtPath:(NSString *)path{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

//移动文件夹
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath overwrite:(BOOL)overwrite error:(NSError *__autoreleasing *)error{
    // 先要保证源文件路径存在，不然抛出异常
       if (![self isExistsAtPath:path]) {
           [NSException raise:@"非法的源文件路径" format:@"源文件路径%@不存在，请检查源文件路径", path];
           return NO;
       }
       //获得目标文件的上级目录
       NSString *toDirPath = [self directoryAtPath:toPath];
       if (![self isExistsAtPath:toDirPath]) {
           // 创建移动路径
           if (![self createDirectoryAtPath:toDirPath]) {
               return NO;
           }
       }
       // 判断目标路径文件是否存在
       if ([self isExistsAtPath:toPath]) {
           //如果覆盖，删除目标路径文件
           if (overwrite) {
               //删掉目标路径文件
               [self removeItemAtPath:toPath];
           }else {
              //删掉被移动文件
               [self removeItemAtPath:path];
               return YES;
           }
       }
       
       // 移动文件，当要移动到的文件路径文件存在，会移动失败
       BOOL isSuccess = [[NSFileManager defaultManager] moveItemAtPath:path toPath:toPath error:error];
       
       return isSuccess;
}

//获取文件名
+ (NSString *)fileNameAtPath:(NSString *)path suffix:(BOOL)suffix{
    NSString *fileName = [path lastPathComponent];
       if (!suffix) {
           fileName = [fileName stringByDeletingPathExtension];
       }
       return fileName;
}

//获取文件所在的文件夹路径
+ (NSString *)directoryAtPath:(NSString *)path{
    return [path stringByDeletingLastPathComponent];
}

//根据文件路径获取文件扩展类型
+ (NSString *)suffixAtPath:(NSString *)path{
    return [path pathExtension];
}


//判断文件路径是否为空，文件夹没有子文件或者文件长度为0；
+ (BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self isFileAtPath:path error:error] &&
            [[self sizeOfItemAtPath:path error:error] intValue] == 0) ||
    ([self isDirectoryAtPath:path error:error] &&
     [[self listFilesInDirectoryAtPath:path deep:NO] count] == 0);
}

+ (BOOL)isDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeDirectory);
}

+ (BOOL)isFileAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return ([self attributeOfItemAtPath:path forKey:NSFileType error:error] == NSFileTypeRegular);
}


//判断目录是否可以执行
+ (BOOL)isExecutableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isExecutableFileAtPath:path];
}

//判断目录是否可读
+ (BOOL)isReadableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isReadableFileAtPath:path];
}

//判断目录是否可写
+ (BOOL)isWritableItemAtPath:(NSString *)path {
    return [[NSFileManager defaultManager] isWritableFileAtPath:path];
}

//获取文件大小
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    return (NSNumber *)[self attributeOfItemAtPath:path forKey:NSFileSize error:error];
}

//获取文件夹大小
+ (NSNumber *)sizeOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    if ([self isDirectoryAtPath:path error:error]) {
       //深遍历文件夹
        NSArray *subPaths = [self listFilesInDirectoryAtPath:path deep:YES];
        NSEnumerator *contentsEnumurator = [subPaths objectEnumerator];
        
        NSString *file;
        unsigned long long int folderSize = 0;
        
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
        }
        return [NSNumber numberWithUnsignedLongLong:folderSize];
    }
    return nil;
}

//获取文件大小（单位为字节）
+ (NSString *)sizeFormattedOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    //先获取NSNumber类型的大小
    NSNumber *size = [self sizeOfItemAtPath:path error:error];
    if (size) {
       //将文件大小格式化为字节
        return [self sizeFormatted:size];
    }
    return nil;
}
 
+ (NSString *)sizeFormattedOfDirectoryAtPath:(NSString *)path error:(NSError *__autoreleasing *)error {
    //先获取NSNumber类型的大小
    NSNumber *size = [self sizeOfDirectoryAtPath:path error:error];
    if (size) {
        return [self sizeFormatted:size];
    }
    return nil;
}

//将文件大小格式化为字节
+(NSString *)sizeFormatted:(NSNumber *)size {
    /*NSByteCountFormatterCountStyle枚举
     *NSByteCountFormatterCountStyleFile 字节为单位，采用十进制的1000bytes = 1KB
     *NSByteCountFormatterCountStyleMemory 字节为单位，采用二进制的1024bytes = 1KB
     *NSByteCountFormatterCountStyleDecimal KB为单位，采用十进制的1000bytes = 1KB
     *NSByteCountFormatterCountStyleBinary KB为单位，采用二进制的1024bytes = 1KB
     */
    return [NSByteCountFormatter stringFromByteCount:[size unsignedLongLongValue] countStyle:NSByteCountFormatterCountStyleFile];
}

/**
 文件遍历
 参数1：目录的绝对路径
 参数2：是否深遍历 (1. 浅遍历：返回当前目录下的所有文件和文件夹；
 2. 深遍历：返回当前目录下及子目录下的所有文件和文件夹)
 */
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path deep:(BOOL)deep {
    NSArray *listArr;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if (deep) {
        // 深遍历
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        }else {
            listArr = nil;
        }
    }else {
        // 浅遍历
        NSArray *shallowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shallowArr;
        }else {
            listArr = nil;
        }
    }
    return listArr;
}

//获取文件属性
/*
 FOUNDATION_EXPORT NSString * const NSFileType;
 FOUNDATION_EXPORT NSString * const NSFileTypeDirectory;
 FOUNDATION_EXPORT NSString * const NSFileTypeRegular;
 FOUNDATION_EXPORT NSString * const NSFileTypeSymbolicLink;
 FOUNDATION_EXPORT NSString * const NSFileTypeSocket;
 FOUNDATION_EXPORT NSString * const NSFileTypeCharacterSpecial;
 FOUNDATION_EXPORT NSString * const NSFileTypeBlockSpecial;
 FOUNDATION_EXPORT NSString * const NSFileTypeUnknown;
 FOUNDATION_EXPORT NSString * const NSFileSize;
 FOUNDATION_EXPORT NSString * const NSFileModificationDate;  //修改时间
 FOUNDATION_EXPORT NSString * const NSFileReferenceCount;
 FOUNDATION_EXPORT NSString * const NSFileDeviceIdentifier;
 FOUNDATION_EXPORT NSString * const NSFileOwnerAccountName;
 FOUNDATION_EXPORT NSString * const NSFileGroupOwnerAccountName;
 FOUNDATION_EXPORT NSString * const NSFilePosixPermissions;
 FOUNDATION_EXPORT NSString * const NSFileSystemNumber;
 FOUNDATION_EXPORT NSString * const NSFileSystemFileNumber;
 FOUNDATION_EXPORT NSString * const NSFileExtensionHidden;
 FOUNDATION_EXPORT NSString * const NSFileHFSCreatorCode;
 FOUNDATION_EXPORT NSString * const NSFileHFSTypeCode;
 FOUNDATION_EXPORT NSString * const NSFileImmutable;
 FOUNDATION_EXPORT NSString * const NSFileAppendOnly;
 FOUNDATION_EXPORT NSString * const NSFileCreationDate;         //创建时间
 FOUNDATION_EXPORT NSString * const NSFileOwnerAccountID;
 FOUNDATION_EXPORT NSString * const NSFileGroupOwnerAccountID;
 FOUNDATION_EXPORT NSString * const NSFileBusy;
 FOUNDATION_EXPORT NSString * const NSFileProtectionKey NS_AVAILABLE_IOS(4_0);
 FOUNDATION_EXPORT NSString * const NSFileProtectionNone NS_AVAILABLE_IOS(4_0);
 FOUNDATION_EXPORT NSString * const NSFileProtectionComplete NS_AVAILABLE_IOS(4_0);
 FOUNDATION_EXPORT NSString * const NSFileProtectionCompleteUnlessOpen NS_AVAILABLE_IOS(5_0);
 FOUNDATION_EXPORT NSString * const NSFileProtectionCompleteUntilFirstUserAuthentication NS_AVAILABLE_IOS(5_0);
 */
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
    return [[self attributesOfItemAtPath:path error:error] objectForKey:key];
}

//获取文件属性集合
+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError *__autoreleasing *)error{
    return [[NSFileManager defaultManager] attributesOfItemAtPath:path error:error];
}


@end
