#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BR_Callback <NSObject>
//用于蓝牙设备连接状态变更的通知
-(void)BR_connectResult:(BOOL)isconnected;
@end

@interface INVSBleTool : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

//初始化
- (instancetype)init:(id<BR_Callback>)delegate;
//连接蓝牙设备
- (BOOL)connect:(NSString *) device;//支持名称，mac地址，uuid
- (BOOL)connectBt:(CBPeripheral *)peripheral;
- (BOOL)connectBt:(CBPeripheral *)peripheral usingCBManager:(CBCentralManager *)cbmanager;
//断开蓝牙设备连接
- (BOOL)disconnectBt;
//读取身份证信息
- (NSDictionary *)readCert;
- (NSDictionary *)readCard;
@end
