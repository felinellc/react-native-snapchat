import React from 'react';
import { NativeModules, requireNativeComponent } from 'react-native';

const { RNSnapSDK } = NativeModules;


class BitmojiPicker extends React.Component {
  render() {
    return <BitmojiPickerRaw {...this.props} />;
  }
}

const BitmojiPickerRaw = requireNativeComponent('BitmojiPicker', BitmojiPicker);


RNSnapSDK.BitmojiPicker = BitmojiPickerRaw


export default RNSnapSDK;
