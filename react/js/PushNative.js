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
    NativeModules,
} from 'react-native';

var Dimensions = require('Dimensions');
var ScreenWidth = Dimensions.get('window').width;
var ScreenHeight = Dimensions.get('window').height;

var PushManager = NativeModules.PushManager;

export default class PushNative extends Component {

    async _pushNative(){
        console.log('开始了')
       try {
           var urlStr = await PushManager.pushDataEvent();
           // console.log('获取到数据'+ urlStr);
           alert('获取到数据 '+ urlStr);

       }catch (e){
           console.log(e);
        }
    }

    _back(){
        PushManager.popEvevt('pop');
    }
    _randerContent(){
        return(

            <View style = {styles.container}>
                <View style = {styles.navigator}>
                    <Text style = {[styles.naviText,{marginLeft:15,flex:1}]} onPress = {this._back}>返回</Text>
                    <Text style = {[styles.naviText,{alignItems:'center',flex:5}]}>这是RN模块</Text>
                </View>

                <View style = {styles.container}>
                    <Text style = {styles.textStyle} onPress = {this._pushNative}>push原生界面</Text>
                </View>
            </View>

        )
    }

  render() {
    return(

        this._randerContent()
    )
  };
}

var styles = StyleSheet.create({
    container:{
        flex :1,
        backgroundColor:'#f5f5f5',
        justifyContent:'center',
        alignItems:'center',

    },
    center:{
        justifyContent:'center',
        alignItems:'center',
    },
    navigator:{
        height:64,
        backgroundColor:'red',
        width:ScreenWidth,
        flexDirection:'row',
        // justifyContent:'center',
        alignItems:'center',
    },
    textStyle:{
        color:'#999',
        fontSize:15,
        margin:10,
    },
    naviText:{
        color:'white',
        fontSize:17,
        marginTop:10,
        textAlign:'center'
    }

});


