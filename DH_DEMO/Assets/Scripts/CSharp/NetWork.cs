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
using XLua;
using System.Threading.Tasks;

[LuaCallCSharp]
public class NetWork
{
    public static Socket client;

    public static void Init()
    {
        client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        EndPoint end_point = new IPEndPoint(IPAddress.Parse("10.0.9.66"), 8800);
        try
        {
            client.BeginConnect(end_point, asyncResult =>
            {
                client.EndConnect(asyncResult);
                AsynRecive(client);
            }, null);
        }
        catch (SocketException e)
        {
            Debug.Log("连接服务器失败    " + e.Message);

        }
        ///////////////////////////////////////////////////////////到时候根据需求改收到服务器回复的处理
        //ThreadStart receive = new ThreadStart(() =>
        //{
        //    while (true)
        //    {
        //        byte[] data = new byte[1024];
        //        int recv = client.Receive(data);
        //        string stringdata = System.Text.Encoding.UTF8.GetString(data, 0, recv);
        //        Debug.Log(stringdata + "\r\n");
        //    }
        //});
        //Thread new_thread = new Thread(receive);
        //new_thread.Start();
    }


    //序列化
    public static byte[] Serialize(IMessage message)
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

    public static void Deserialize(IMessage message, byte[] data)
    {
        using (CodedInputStream inputStream = new CodedInputStream(data))
        {
            message.MergeFrom(inputStream);
        }
    }
    //异步发送
    public static void AsynSend(Socket tcpClient, byte[] data)
    {
        tcpClient.BeginSend(data, 0, data.Length, SocketFlags.None, asyncResult =>
        {
            //完成发送消息
            int length = tcpClient.EndSend(asyncResult);
        }, null);
    }
    //异步接收
    public static void AsynRecive(Socket tcpClient)
    {
        byte[] data = new byte[1025];
        tcpClient.BeginReceive(data, 0, data.Length, SocketFlags.None, asyncResult =>
        {
            int length = tcpClient.EndReceive(asyncResult);
            if(length == 1)
            {

                //0 false  1 true  2 un register  3 offline、
                
            }else
            {

            }








            AsynRecive(tcpClient);
        }, null);
    }
    //发送注册消息
    public static void  SendRegister(string name, string password)
    {
        Register temp = new Register();
        temp.Name = name;
        temp.Password = password;
        byte[] data;
        
        data = Serialize(temp);
        byte[] new_data = new byte[data.Length+1];
        new_data[0] = 0;
        data.CopyTo(new_data, 1);
        
        AsynSend(client, new_data);

    }
    //发送登录消息
    public static void SendLogIn(string name, string password)
    {
        LogIn temp = new LogIn();
        temp.Name = name;
        temp.Password = password;
        byte[] data;

        data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 1;
        data.CopyTo(new_data, 1);

        AsynSend(client, new_data);
    }
    //发送聊天消息
    public static void SendTalk(string myName, string hisName, string msg)
    {
        Talk temp = new Talk();
        temp.MyName = myName;
        temp.HisName = hisName;
        temp.Msg = msg;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 2;
        data.CopyTo(new_data, 1);

        AsynSend(client, new_data);
    }
    //发送战斗邀请
    public static void SendToFight(string myName, string hisName)
    {
        ToFight temp = new ToFight();
        temp.MyName = myName;
        temp.HisName = hisName;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 3;
        data.CopyTo(new_data, 1);

        AsynSend(client, new_data);
    }
    //发送战斗信息
    public static void SendFight(string myName, string hisName, int carIndex)
    {
        Fight temp = new Fight();
        temp.MyName = myName;
        temp.HisName = hisName;
        temp.CarIndex = carIndex;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 4;
        data.CopyTo(new_data, 1);

        AsynSend(client, new_data);
    }

}
