//
//  FSConstance.m
//  FSNetwork
//
//  Created by 付森 on 2018/10/30.
//  Copyright © 2018年 付森. All rights reserved.
//

#import "FSConstance.h"

NSString * const kBaseUrl = @"http://192.168.0.103";

/*
 NSURLSession
 协调一组相关网络数据传输任务的对象。
 
 NSURLCIST类和相关类提供了下载内容的API。这个API提供了一组丰富的委托方法来支持身份验证，并且使应用程序能够在应用程序不运行时或在iOS中挂起应用程序时执行后台下载。
 
 NSURLSession类在本地支持数据、文件、ftp、http和http s URL方案，并透明地支持代理服务器和SOCKS网关，如用户系统首选项中所配置的。
 
 NSURLIST支持HTTP／1.1、SPDY和HTTP/2协议。HTTP／2支持由RFC 7540描述，并且需要支持ALPN或NPN的服务器进行协议协商。
 
 您还可以使用NSURLProtocol添加对您自己的自定义网络协议和URL方案的支持（用于应用程序的私有使用）。
 
 NSURLSession API涉及许多不同的类，它们以一种相当复杂的方式一起工作，如果您自己阅读参考文档，这可能并不明显。在使用这个API之前，您应该阅读URL会话编程指南，以便从概念上理解这些类如何彼此交互。
 
 使用NSURLSession API，应用程序创建一个或多个会话，每个会话协调一组相关的数据传输任务。例如，如果您正在创建一个Web浏览器，您的应用程序可能为每个选项卡或窗口创建一个会话，或者为交互式使用创建一个会话，为后台下载创建一个会话。在每个会话中，应用程序添加一系列任务，每个任务表示对特定URL的请求（如果必要，遵循HTTP重定向）。
 
 给定URL会话中的任务共享一个公共会话配置对象，该对象定义连接行为，例如要连接到单个主机的最大同时连接数量、是否允许通过蜂窝网络连接等。会话的行为部分取决于在创建配置对象时调用的方法：
 */
