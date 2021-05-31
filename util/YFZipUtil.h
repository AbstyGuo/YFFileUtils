//
//  YFZipUtil.h
//  YFCommon
//
//  Created by guoyf on 2020/6/8.
//  Copyright © 2020 absty_guo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSZipArchive.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFZipUtil : NSObject

/**
  这里使用 SSZipArchive 进行解压操作，不再进行封装
 
 使用方法
    *解压
    [SSZipArchive unzipFileAtPath:path toDestination:destinationPath]; 等一系列
 
    * 压缩
    [SSZipArchive createZipFileAtPath:path withFilesAtPaths:filePath]; 等

 */

@end

NS_ASSUME_NONNULL_END
