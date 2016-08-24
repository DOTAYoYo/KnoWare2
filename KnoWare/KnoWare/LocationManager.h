//
//  LocationManager.h
//  KnoWare
//
//  Created by Jeremy Storer on 2/18/16.
//  Copyright © 2016 Jeremy Storer. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface LocationManager : NSObject<CLLocationManagerDelegate>
+(LocationManager *)sharedInstance;
@property (readonly) CLLocationManager *locationManager;

@end
