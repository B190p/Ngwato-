#!/bin/bash

echo "📱 Creating Ngwato Analytics Mobile App..."

mkdir -p ngwato-analytics/mobile-app/{screens,services}
cd ngwato-analytics/mobile-app || exit 1

############################
# package.json
############################
cat <<EOF > package.json
{
  "name": "ngwato-mobile",
  "version": "1.0.0",
  "main": "node_modules/expo/AppEntry.js",
  "private": true,
  "scripts": {
    "start": "expo start"
  },
  "dependencies": {
    "expo": "~50.0.0",
    "react": "18.2.0",
    "react-native": "0.73.0"
  }
}
EOF

############################
# api service
############################
cat <<EOF > services/api.js
const API = "https://yourdomain.com/api";

export async function login(email,password){
  const r = await fetch(API+"/login",{
    method:"POST",
    headers:{"Content-Type":"application/json"},
    body:JSON.stringify({email,password})
  });
  return r.json();
}

export async function getTrades(token){
  const r = await fetch(API+"/trades",{
    headers:{Authorization:"Bearer "+token}
  });
  return r.json();
}
EOF

############################
# App.js
############################
cat <<EOF > App.js
import React,{useState} from "react";
import Login from "./screens/LoginScreen";
import Dashboard from "./screens/DashboardScreen";

export default function App(){
  const [token,setToken]=useState(null);
  return token ? <Dashboard token={token}/> : <Login setToken={setToken}/>;
}
EOF

############################
# Login Screen
############################
cat <<EOF > screens/LoginScreen.js
import React,{useState} from "react";
import {View,TextInput,Button,Text} from "react-native";
import {login} from "../services/api";

export default function Login({setToken}){
  const [email,setEmail]=useState("");
  const [password,setPassword]=useState("");

  async function submit(){
    const r = await login(email,password);
    setToken(r.token);
  }

  return (
    <View style={{padding:40}}>
      <Text>Ngwato Analytics</Text>
      <TextInput placeholder="Email" onChangeText={setEmail}/>
      <TextInput placeholder="Password" secureTextEntry onChangeText={setPassword}/>
      <Button title="Login" onPress={submit}/>
    </View>
  );
}
EOF

############################
# Dashboard Screen
############################
cat <<EOF > screens/DashboardScreen.js
import React,{useEffect,useState} from "react";
import {View,Text,Button} from "react-native";
import {getTrades} from "../services/api";

export default function Dashboard({token}){
  const [trades,setTrades]=useState([]);

  useEffect(()=>{
    getTrades(token).then(setTrades);
  },[]);

  return (
    <View style={{padding:20}}>
      <Text>Dashboard</Text>
      {trades.map((t,i)=>(
        <Text key={i}>{t.symbol} {t.type} {t.profit}</Text>
      ))}
    </View>
  );
}
EOF

echo "✅ Mobile App Created"