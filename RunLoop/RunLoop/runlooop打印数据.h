//
//  Header.h
//  RunLoop
//
//  Created by zhanglili on 2018/7/12.
//  Copyright © 2018年 zhanglili. All rights reserved.
//

#ifndef Header_h
#define Header_h
//加入这句[runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
<CFRunLoop 0x6040001ea300 [0x1028b7bb0]>{
    wakeup port = 0xa303,
    stopped = false,
    ignoreWakeUps = true,
    current mode = (none),
    common modes = <CFBasicHash 0x60400044cd80 [0x1028b7bb0]>{type = mutable set, count = 1,
        entries =>
        2 : <CFString 0x10288d7f0 [0x1028b7bb0]>{contents "kCFRunLoopDefaultMode"}},
    common mode items = <CFBasicHash 0x6000002419e0 [0x1028b7bb0]>{type = mutable set, count = 1,
        entries =>
        1 : <CFRunLoopSource 0x600000165280 [0x1028b7bb0]>{signalled = No, valid = Yes, order = 200, context = <CFMachPort 0x600000150a10 [0x1028b7bb0]>{valid = Yes, port = 6103, source = 0x600000165280, callout = __NSFireMachPort (0x101196409), context = <CFMachPort context 0x600000241110>}}
    }
    ,
    modes = <CFBasicHash 0x60400044d170 [0x1028b7bb0]>{type = mutable set, count = 1,
        entries =>
        2 : <CFRunLoopMode 0x6040001909b0 [0x1028b7bb0]>{name = kCFRunLoopDefaultMode, port set = 0xa203, queue = 0x604000151250, source = 0x604000190a80 (not fired), timer port = 0x6003,
            sources0 = <CFBasicHash 0x600000241ce0 [0x1028b7bb0]>{type = mutable set, count = 0,
                entries =>
            }
            ,
            sources1 = <CFBasicHash 0x600000241cb0 [0x1028b7bb0]>{type = mutable set, count = 1,
                entries =>
                1 : <CFRunLoopSource 0x600000165280 [0x1028b7bb0]>{signalled = No, valid = Yes, order = 200, context = <CFMachPort 0x600000150a10 [0x1028b7bb0]>{valid = Yes, port = 6103, source = 0x600000165280, callout = __NSFireMachPort (0x101196409), context = <CFMachPort context 0x600000241110>}}
            }
            ,
            observers = (null),
            timers = (null),
            currently 553079807 (390752998348983) / soft deadline in: 1.84463533e+10 sec (@ -1) / hard deadline in: 1.84463533e+10 sec (@ -1)
        },
        
    }
    }

//没有加这句[runLoop addPort:[NSMachPort port] forMode:NSRunLoopCommonModes];
<CFRunLoop 0x6040001f5d00 [0x110013bb0]>
{wakeup port = 0x5c03, stopped = false, ignoreWakeUps = true,
    current mode = (none),
    common modes = <CFBasicHash 0x60400025dc40 [0x110013bb0]>{type = mutable set, count = 1,
        entries =>
        2 : <CFString 0x10ffe97f0 [0x110013bb0]>{contents = "kCFRunLoopDefaultMode"}
    }
    ,
    common mode items = (null),
    modes = <CFBasicHash 0x60400025deb0 [0x110013bb0]>{type = mutable set, count = 1,
        entries =>
        2 : <CFRunLoopMode 0x604000380d00 [0x110013bb0]>{name = kCFRunLoopDefaultMode, port set = 0x5d03, queue = 0x604000158ec0, source = 0x604000380f70 (not fired), timer port = 0x5e03,
            sources0 = (null),
            sources1 = (null),
            observers = (null),
            timers = (null),
            currently 553080279 (391225819082292) / soft deadline in: 1.84463528e+10 sec (@ -1) / hard deadline in: 1.84463528e+10 sec (@ -1)
        },
        
    }
    }




#endif /* Header_h */
