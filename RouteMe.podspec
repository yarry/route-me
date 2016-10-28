Pod::Spec.new do |m|

  m.name    = 'RouteMe'
  m.version = '1.7.0'

  m.summary          = 'An open source toolset for building mapping applications for iOS devices.'
  m.description      = 'An open source toolset for building mapping applications for iOS devices with great flexibility for visual styling, offline use, and customizability.'
  m.homepage         = 'https://github.com/yarry/route-me'
  m.license          = 'BSD'
  m.author           = { 'Mapbox' => 'mobile@mapbox.com' }

  m.source = {
    :git => 'https://github.com/yarry/route-me.git',
    :tag => m.version.to_s
  }

  m.platform              = :ios
  m.ios.deployment_target = '9.0'
  m.requires_arc          = true

  m.module_name = 'RouteMe'

  m.source_files = ['MapView/Map/*.{h,c,m}', 'Proj4/*.{c,h}']
  m.exclude_files =  [
    "**/proj.c",
    "**/nad2bin.c",
    "**/multistresstest.c",
    "**/geod.c",
    "**/cs2cs.c",
    "**/nad2nad.c"
  ]

  m.prefix_header_file = 'MapView/MapView_Prefix.pch'

  m.public_header_files = [
  	'MapView/Map/RouteMe.h',
    'MapView/Map/RMTile.h',
    'MapView/Map/Mapbox.h',
    'MapView/Map/RMAnnotation.h',
    'MapView/Map/RMCacheObject.h',
    'MapView/Map/RMCircle.h',
    'MapView/Map/RMCircleAnnotation.h',
    'MapView/Map/RMCompositeSource.h',
    'MapView/Map/RMConfiguration.h',
    'MapView/Map/RMCoordinateGridSource.h',
    'MapView/Map/RMDatabaseCache.h',
    'MapView/Map/RMGreatCircleAnnotation.h',
    'MapView/Map/RMInteractiveSource.h',
    'MapView/Map/RMMBTilesSource.h',
    'MapView/Map/RMMapboxSource.h',
    'MapView/Map/RMMapView.h',
    'MapView/Map/RMMapViewDelegate.h',
    'MapView/Map/RMMarker.h',
    'MapView/Map/RMMemoryCache.h',
    'MapView/Map/RMPointAnnotation.h',
    'MapView/Map/RMPolygonAnnotation.h',
    'MapView/Map/RMPolylineAnnotation.h',
    'MapView/Map/RMShape.h',
    'MapView/Map/RMStaticMapView.h',
    'MapView/Map/RMTileCache.h',
    'MapView/Map/RMTileMillSource.h',
    'MapView/Map/RMUserLocation.h',
    'MapView/Map/RMUserTrackingBarButtonItem.h',
    'MapView/Map/RMFoundation.h',
    'MapView/Map/RMAbstractWebMapSource.h',
    'MapView/Map/RMAbstractMercatorTileSource.h',
    'MapView/Map/RMMapLayer.h',
    'MapView/Map/RMGlobalConstants.h',
    'MapView/Map/RMTileSource.h',
    'MapView/Map/RMFractalTileProjection.h',
    'MapView/Map/RMProjection.h',
    'MapView/Map/RMShapeAnnotation.h',
    'MapView/Map/RMGenericMapSource.h',
  ]

  m.resource_bundle = {
    'RouteMe' => 'MapView/Map/Resources/*'
  }

  m.documentation_url = 'https://www.mapbox.com/mapbox-ios-sdk'

  m.frameworks = 'CoreGraphics', 'CoreLocation', 'Foundation', 'QuartzCore', 'UIKit'

  m.libraries = 'sqlite3', 'z'

  m.xcconfig = {
    'OTHER_LDFLAGS'        => '-ObjC',
  }

  m.preserve_paths = 'MapView/MapView.xcodeproj', 'MapView/Map/Resources'

  m.dependency 'FMDB', '~> 2.3'

end
