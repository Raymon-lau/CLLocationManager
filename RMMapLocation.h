//
//  RMMapLocation.h
//  StaffManagement
//
//  Created by Raymon on 16/4/14.
//  Copyright © 2016年 Raymon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RMMapLocation : NSObject
{
    void (^saveGpsCallBack)(double lattitude,double longitude);
}
+ (void)getGps:(void(^)(double lattitude,double longitude))block;
+ (void)stop;
@end
