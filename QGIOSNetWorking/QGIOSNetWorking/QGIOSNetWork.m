//
//  QGIOSNetWork.m
//  QGIOSNetWork
//
//  Created by Li,Quangang on 2018/8/28.
//  Copyright © 2018年 liquangang. All rights reserved.
//

#import "QGIOSNetWork.h"
#import "AFNetworking.h"

@interface QGIOSNetWork ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation QGIOSNetWork

/**
 *  实现单例
 */

static QGIOSNetWork *manager;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[QGIOSNetWork alloc] init];
        manager.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone] ;
    }) ;
    return manager;
}

- (id)copyWithZone:(NSZone *)zone{
    return manager;
}

#pragma mark - getter

+ (AFSecurityPolicy *)customSecurityPolicy{
    
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https3" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:2];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

@end
