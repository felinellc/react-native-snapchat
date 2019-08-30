
# RNSnapSDK

## Getting started

`Not Available`

### Mostly automatic installation

`Not Available`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-snapchat` and add `RNSnapSDK.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNSnapSDK.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

`Not Available`

#### Windows

`Not Available`

## Usage
```javascript
import RNSnapSDK from 'react-native-snapchat';

// TODO: What to do with the module?
RNSnapchat.shareSticker(uri, {
    //All are optional - see Snapkit Docs for more information.
	  attachment: "https://geh.li",
    caption: "Test Caption"
	  posX: 0.5,
	  posY: 0.7,
	  width: 250,
	  height: 150,
	  rotation: 6.1
});
```
  
