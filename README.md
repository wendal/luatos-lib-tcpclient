# luatos-lib-tcpclient

事件式TCP客户端, 适用于LuatOS

本库**当前未完成**

## 介绍

本客户端基于socket库, 兼容所有支持网络功能的LuatOS模块, 包括但不限于:

1. EC618系列, 如 Air780E/Air780EG/Air700E/Air780EX等等
2. EC718P系列, 如 Air780EP, Air780EPV等等
3. ESP32系列, 如 ESP32C3/ESP32S3等等
4. XT804系列, 如 Air601-12F
5. 需要搭配W5500联网的, 例如 Air101/Air103/Air105等

## 安装和使用

本协议库使用纯lua编写, 所以不需要编译, 将库文件的源码(tcpclient.lua)拷贝到项目即可

## 目录说明

1. lib 库文件目录, 存放tcpclient.lua库文件
2. demo 示例代码目录, 包含demo.lua等示例文件, 搭配lib目录组成完整luatos演示代码
3. fireware 固件目录, 包含验证过的固件文件, 方便测试, 但并非只能使用该固件

## 变更日志

[changelog](changelog.md)

## LIcense

[MIT License](https://opensource.org/licenses/MIT)
