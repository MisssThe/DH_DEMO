using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using System.Net;
using System.Net.Sockets;
using System.Threading;

public class NetWork
{
    public static Socket GetConnect()
    {
        Socket client = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp);
        EndPoint end_point = new IPEndPoint(IPAddress.Parse("10.0.9.66"),8800);
        try
        {
            client.Connect(end_point);
        }
        catch(SocketException e)
        {
            Debug.Log("连接服务器失败    " + e.Message);
            return null;
        }
        Debug.Log("链接成功");
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
        return client;
    }

    public static void SendMessage(Socket client, byte[] message)
    {
        client.Send(message);
        return;
    }
}
