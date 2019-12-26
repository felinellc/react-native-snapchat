import React from 'react';
import { NativeModules, requireNativeComponent, NativeEventEmitter } from 'react-native';

const { RNSnapSDK } = NativeModules;


class BitmojiPicker extends React.Component {
  render() {
    return <BitmojiPickerRaw {...this.props} />;
  }
}

if(!global.bitmojiPickerRegistered){
	const BitmojiPickerRaw = requireNativeComponent('BitmojiPicker', BitmojiPicker);
	global.bitmojiPickerRegistered = true;
	RNSnapSDK.BitmojiPicker = BitmojiPickerRaw
}


RNSnapSDK.initialize();

RNSnapSDK.EventEmitter = new NativeEventEmitter(RNSnapSDK);


export default RNSnapSDK;
