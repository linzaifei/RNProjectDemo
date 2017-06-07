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

var RNToNativeManager = NativeModules.RNToNativeManager;

export default class RNToNative extends Component {


    _One(){
        RNToNativeManager.addEvent('这是EN 到原生的值');
    }
    _two(){
        RNToNativeManager.addEventTwo('这是EN 到原生的值',{rn:'这是字典'});
    }
    _three(){
        RNToNativeManager.addEventTwo('这是EN 到原生的值',20170607);
    }
    _textCallback(){
        RNToNativeManager.TextCallBackOne(('这是EN 到原生的值'),(error,events)=>{
         if(error){
             console.log(error);
         }  else{
            alert(events);
         }
        })
    }
    //Promise回调
    async _CallbackTwo(){
        try{
            var evevts = await  RNToNativeManager.TextCallBackTwo();
            console.log(evevts);

            // alert(events)
        }catch (e){
            console.log(e);

        }
    }

    _constantsToExport(){

        console.log(RNToNativeManager.first);

    }

    _randerContent(){
        return(
            <View style = {styles.container}>
                <View style = {styles.navigator}>

                </View>

                <View style = {[styles.center]}>
                    <Text style = {styles.textStyle} onPress = {this._One}>把值带给原生界面 string</Text>
                    <Text style = {styles.textStyle} onPress = {this._two}>把值带给原生界面 string + dic</Text>
                    <Text style = {styles.textStyle} onPress = {this._three}>把值带给原生界面 string + date</Text>
                    <Text style = {styles.textStyle} onPress = {this._textCallback}>把值带给原生界面 string + 回调 </Text>
                    <Text style = {styles.textStyle} onPress = {this._CallbackTwo}>把值带给原生界面 Promise回调 </Text>
                    <Text style = {styles.textStyle} onPress = {this._constantsToExport}>把值带给原生界面 + native </Text>


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
        backgroundColor:'#f5f5f5'
    },
    center:{
        justifyContent:'center',
        alignItems:'center',
    },
    navigator:{
        height:64,
        backgroundColor:'red',
    },
    textStyle:{
        color:'#999',
        fontSize:15,
        margin:10,
    }

});


