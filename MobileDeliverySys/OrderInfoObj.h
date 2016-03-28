//
//  OrderInfoObj.h
//  MobileDeliverySys
//
//  Created by 雪竜 on 15/7/10.
//  Copyright (c) 2015年 雪竜. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 Sample JSON Return for Reference
 
 orderid` varchar(20)  '订单号',
 `orderowner` varchar(15)  '单订所有者',
 `orderstate` varchar(1)  '订单状态',
 `beginaddress` varchar(200)  '起运地',
 `endaddress` varchar(200)  '到达地',
 `nowaddress` varchar(200)  '当前位置',
 `customerid` varchar(20)  '托运人/客户代码',
 `consignment` varchar(20)  '托运业务经办人',
 `storecode` varchar(20)  '门店编码',
 `storeaddress` varchar(200)  '门店地址',
 `transporttype` varchar(20)  '运输方式',
 `carid` varchar(20)  '车号',
 `volume` varchar(20)  '货物体积CBM',
 `quantity` varchar(20)  '件数（周转箱）',
 `weight` varchar(20)  '重量',
 `goodsname` varchar(20)  '货物名称',
 `deliveryaddress` varchar(200)  '提货地址',
 `deliveryphone` varchar(15)  '提货联系电话',
 `othernode` varchar(20)  '其他在途节点',
 `receipt` varchar(20)  '收货业务经办人',
 `receiptname` varchar(20)  '收货人名称',
 `destination` varchar(200)  '送达地址',
 `receiptphone` varchar(15)  '收货人联系电话',
 `sendday` varchar(20)  '要求发货日',
 `etd` varchar(20)  '预计到达时间',
 `eta` varchar(20)  ' 预计出发时间',
 `etatime` varchar(20) ,
 `insurancetype` varchar(200) ,
 `warningstate` varchar(2) '报警状态  0 报警状态  1 正常状态',
 `yzm` varchar(10)  '验证码',
 */

@interface OrderInfoObj : NSObject

@property NSString* OrderID;
@property NSString* OrderOwner;
@property NSString* OrderState;
@property NSString* BeginAddress;
@property NSString* NowAddress;
@property NSString* CustomerID;
@property NSString* Consignment;
@property NSString* StoreCode;
@property NSString* StoreAddress;
@property NSString* TransportType;
@property NSString* CarID;
@property NSString* Volume;
@property NSString* Quantity;
@property NSString* Weight;
@property NSString* GoodsName;
@property NSString* DeliveryAddr;
@property NSString* DeliveryPhone;
@property NSString* OtherNode;
@property NSString* ReceiptAgent;
@property NSString* Recipient;
@property NSString* Destination;
@property NSString* RecipientPhone;
@property NSString* DeliveryDueDate;
@property NSString* ETD;
@property NSString* ETA;
@property NSString* ETATime;
@property NSString* InsuranceType;
@property NSString* WarningState;
@property NSString* YZM;

@end
