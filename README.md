# react-native-svg-native

Show SVG natively

## Installation

```sh
npm install react-native-svg-native
```

```sh
yarn add react-native-svg-native
```

## Manual installation

_ios/Podfile_

```
  pod 'SDWebImage', '~> 5.0', :modular_headers => true
  pod 'SDWebImageSVGCoder', '~> 1.0', :modular_headers => true
```

## Usage

```
import { SvgNativeView } from 'react-native-svg-native';

// ...

<SvgNativeView
  uri="https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/tiger.svg"
  style={{ width: 200, height: 200 }}
  cacheTime={86400000} // is optional default cache is disable: Cache time in milliseconds (e.g., 1 day)
/>
```
