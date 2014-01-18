## VENVersionTracker

iOS Version Tracking Library to update betas, let users know about new versions in production and enforce deprecated versions of your app.

### Installation
The easiest way is to use CocoaPods. If you don't already, here's a [guide](http://guides.cocoapods.org/using/getting-started.html).
``` ruby
pod 'VENSnowOverlayView', '~>0.1.0'
```

### Outline
`VENVersionTracker` is designed to allow you to maintain multiple `channels` of released builds modeling production (App Store) and any internal release groups you may have.

#### e.g. At Vemo, we have:

`iosteam` Builds which will only go to the iOS development team e.g. 4.8.0a2

`internal` Builds which are shared with the company, typically promoted from `iosteam` e.g. 4.8.0b1

`friends_and_family` Builds which are shared with our friends, family members and registered beta testers. These are builds being considered for submission to proudction (e.g. 4.8.0rc2)

`production` Update the production app when updates are available

This is modelled by requesting the version for a `channel` from the update service (currently just static files in S3)

### Usage
``` objc
[VENVersionTracker beginTrackingVersionForChannel:@"production"
                                       serviceBaseUrl:@"http://mys3bucket.s3.amazonaws.com/version"
                                         timeInterval:1800
                                          withHandler:^(VENVersionTrackerState state, VENVersion *version) {
                                          
        dispatch_sync(dispatch_get_main_queue(), ^{
            switch (state) {
              case VENVersionTrackerStateDeprecated:
                [version install];
              break;
              
              case VENVersionTrackerStateOutdated:
                // Offer the user the option to update
              break;
            }
        });
    }];
    
```

### Getting Versions
The restful endpoint (whether an actual service, or just a file in S3) should return a file with the following format:
``` json
{
   "version":{
      "number":"4.6.0rc10",
      "mandatory":false,
      "install_url":"<<ITMS INSTALL URL>>"
   },
   "min-version-number":1.0 
}
```

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
