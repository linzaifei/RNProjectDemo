/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,

    DeviceEventEmitter,
} from 'react-native';

import RNToNative from './js/RNToNative'
import PushNative from './js/PushNative'

export default class RNProjectDemo extends Component {



  render() {
    return(
        <PushNative></PushNative>

    )
  };
}

var styles = StyleSheet.create({
    container:{
        flex :1,
        backgroundColor:'#f5f5f5'
    },
    navigator:{
        height:64,
        backgroundColor:'red',

    }

});

AppRegistry.registerComponent('RNProjectDemo', () => RNProjectDemo);
