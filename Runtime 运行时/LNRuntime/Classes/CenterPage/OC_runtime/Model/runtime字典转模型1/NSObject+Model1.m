/*
 * NSObject+Model1.m
 * 简/众_不知名开发者 | https://github.com/CoderLN
 * 
 */

#import "NSObject+Model1.h"
#import <objc/message.h>

@implementation NSObject (Model1)

// 思路：利用runtime 遍历模型中所有属性，根据模型中属性去字典中取出对应的value给模型属性赋值
+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    // 1.创建对应的对象
    id objc = [[self alloc] init];
    
    // 2.利用runtime给对象中的属性赋值
    // 成员变量个数
    unsigned int count = 0;
    // 获取类中的所有成员变量
    Ivar * ivars = class_copyIvarList(self, &count);

    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        // 根据角标，从数组取出对应的成员变量（Ivar：成员变量,以下划线开头）
        Ivar ivar = ivars[i];
        
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 处理成员变量名，字典中的key(去掉 _ ,从第一个角标开始截取)
        NSString *key = [ivarName substringFromIndex:1];
        
        // 根据成员属性名去字典中查找对应的value
        id value = dict[key];
        
        
        //----------------------- <#<--- 不知名开发者 --->#> ------------------------//
        //
        
        // runtime字典转模型一级转换：直接是字典转模型
        // 如果模型属性数量大于字典键值对数理，模型属性会被赋值为nil,而报错 could not set nil as the value for the key age.无法将nil设置为键age的值
        if (value) {
            // 给模型中属性赋值
            [objc setValue:value forKey:key];
        }
    }
    // 释放ivars
    free(ivars);
   
    return objc;
}



@end
