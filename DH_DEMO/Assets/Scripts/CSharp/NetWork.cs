using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;
using System.IO;
using Network;
using Google.Protobuf;
public class NetWork
{
    public Socket client;
    NetWork()
    {
        client = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
        EndPoint end_point = new IPEndPoint(IPAddress.Parse("10.0.9.66"),8800);
        try
        {
            client.Connect(end_point);
        }
        catch(SocketException e)
        {
            Debug.Log("连接服务器失败    " + e.Message);
            
        }
        Debug.Log("链接成功");
        ///////////////////////////////////////////////////////////到时候根据需求改收到服务器回复的处理
        ThreadStart receive = new ThreadStart(()=>{
            while(true)
            {
                byte[] data = new byte[1024];
                int recv = client.Receive(data);
                string stringdata = System.Text.Encoding.UTF8.GetString(data, 0, recv);
                Debug.Log(stringdata + "\r\n");
            }
        });
        Thread new_thread = new Thread(receive);
        new_thread.Start();
    }
    //序列化
    public byte[] Serialize(IMessage message)
        {
            using (MemoryStream memoryStream = new MemoryStream())
            {
                using (CodedOutputStream outputStream = new CodedOutputStream(memoryStream))
                {
                    message.WriteTo(outputStream);
                    outputStream.Flush();
        
                    return memoryStream.ToArray();
                }
            }
        }

    public void Deserialize(IMessage message, byte[] data)
        {
            using (CodedInputStream inputStream = new CodedInputStream(data))
            {
                message.MergeFrom(inputStream);
            }
        }
    
    //发送注册消息
    public void SendRegister(string name, string password)
    {
        Register temp = new Register();
        temp.Event.Event_ = "register";
        temp.Name = name;
        temp.Password = password;
        byte[] data = Serialize(temp);
        client.Send(data);
    }
    //发送登录消息
    public void SendLogIn(string name, string password)
    {
        LogIn temp = new LogIn();
        temp.Event.Event_ = "login";
        temp.Name = name;
        temp.Password = password;
        byte[] data = Serialize(temp);
        client.Send(data);
    }
    //发送聊天消息
    public void SendTalk(string myName, string hisName, string msg)
    {
        Talk temp = new Talk();
        temp.Event.Event_ = "talk";
        temp.MyName = myName;
        temp.HisName = hisName;
        temp.Msg = msg;
        byte[] data = Serialize(temp);
        client.Send(data);
    }
    //发送战斗邀请
    public void SendToFight(string myName, string hisName)
    {
        ToFight temp = new ToFight();
        temp.Event.Event_ = "tofight";
        temp.MyName = myName;
        temp.HisName = hisName;
        byte[] data = Serialize(temp);
        client.Send(data);
    }
    //发送战斗信息
    public void SendFight(string myName, string hisName, int carIndex)
    {
        Fight temp = new Fight();
        temp.Event.Event_ = "fight";
        temp.MyName = myName;
        temp.HisName = hisName;
        temp.CarIndex = carIndex;
        byte[] data = Serialize(temp);
        client.Send(data);
    }

}
