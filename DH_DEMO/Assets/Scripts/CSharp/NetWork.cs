using Google.Protobuf;
using Network;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using UnityEngine;
using XLua;

[LuaCallCSharp]
public class NetWork
{
    public static Socket client;
    private static string player_name;
    static byte[] kk;
    static int kk_length = 0;
    public static void Init()
    {
        client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
        EndPoint end_point = new IPEndPoint(IPAddress.Parse("10.0.9.66"), 10000);
        try
        {

            var a = client.BeginConnect(end_point, asyncResult =>
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

    public static void SetPlayerName(string name)
    {
        player_name = name;
    }

    public static string GetPlayerName()
    {
        return player_name;
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
        int length = data.Length;
        byte[] new_data = new byte[length + 2];
        new_data[0] = 250;
        new_data[1] = (byte)length;
        data.CopyTo(new_data,2);
        tcpClient.BeginSend(new_data, 0, new_data.Length, SocketFlags.None, asyncResult =>
        {
            //完成发送消息
            int length1 = tcpClient.EndSend(asyncResult);
        }, null);
    }
    //异步接收
    public static void AsynRecive(Socket tcpClient)
    {
        byte[] data = new byte[1025];
        tcpClient.BeginReceive(data, 0, data.Length, SocketFlags.None, asyncResult =>
        {
            int length = tcpClient.EndReceive(asyncResult);
            Debug.Log("收到消息长度：" + length);
            for (int i = 0; i < length;)
            {
                if (kk_length != 0)
                {
                    byte[] l = new byte[kk.Length + kk_length];
                    byte[] p = data.Take(kk_length).ToArray();
                    kk.CopyTo(l, 0);
                    p.CopyTo(l, kk.Length);
                    kk = null;
                    i = i + kk_length;
                    NetWorkManager.MsgAdd(l, kk.Length + kk_length);
                    kk_length = 0;
                }
                if (data[i] == 250)
                {
                    int length1 = data[i + 1];
                    if (length1 != 0)
                    {
                        if (length - i >= length1 + 2)
                        {
                            byte[] temp_data = data.Skip(i + 2).Take(length1).ToArray();
                            NetWorkManager.MsgAdd(temp_data, length1);
                            i = i + 2 + length1;
                        }
                        else
                        {
                            kk = data.Skip(i + 2).Take(length - i).ToArray();
                            kk_length = length1 - length + i;
                        }

                    }
                    else
                    {
                        i = i + 2;
                    }

                }
                else
                {
                    Debug.Log("收到消息出错");
                    break;
                }
            }
            //if (length != 0)
            //{
                
            //}//else
            ////{
            ////    client.Close();
            ////}

            //byte[] new_data = new byte[length - 1];
            //Array.Copy(data, 1, new_data, 0, length - 1);
            //int num = data[0];
            //Debug.Log("首字节:"+num);
            //switch (num)
            //{
            //    case 2:
            //        ReceiveTalk(new_data);
            //        break;
            //    case 3:
            //        ReceiveToFight(new_data);
            //        break;
            //    case 4:
            //        ReceiveFight(new_data);
            //        break;
            //    case 5:
            //        StartToFight(new_data);
            //        break;
            //    case 6://代表用户注册失败，用户名已存在
            //        EventManager.Instance.Send("1 'loginRecive' 'loginpage' 1");
            //        Debug.Log("代表用户注册失败，用户名已存在");
            //        break;
            //    case 7://代表用户注册成功
            //        EventManager.Instance.Send("1 'loginRecive' 'loginpage' 2");
            //        Debug.Log("代表用户注册成功");
            //        break;
            //    case 8://代表用户登录失败，未注册
            //        EventManager.Instance.Send("1 'loginRecive' 'loginpage' 3");
            //        Debug.Log("代表用户登录失败，未注册");
            //        break;
            //    case 9://代表用户登陆失败，密码错误
            //        EventManager.Instance.Send("1 'loginRecive' 'loginpage' 4");
            //        Debug.Log("代表用户登陆失败，密码错误");
            //        break;
            //    case 10://代表用户登录成功
            //        //EventManager.Instance.Send("1 'loginRecive' 'loginpage' 5");
            //        Debug.Log("代表用户登录成功");
            //        break;
            //    case 11://聊天发送消息对方不在线
            //        Debug.Log("聊天发送消息对方不在线");
            //        break;
            //    case 12://发送战斗邀请对方不在线
            //        Debug.Log("发送战斗邀请对方不在线");
            //        break;
            //    case 13://战斗时对方不在线
            //        Debug.Log("战斗时对方不在线");
            //        break;
            //    case 14://对方拒绝战斗
            //        Debug.Log("对方拒绝战斗");
            //        break;
            //    case 15://你的回合
            //        LuaManager.Instance.Env.DoString("FightSystem:StartRound()");
            //        break;
            //    default:
            //        break;
            //}

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
        Debug.Log("发送消息");
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
        Debug.Log("发送战斗邀请");
        AsynSend(client, new_data);
    }
    //发送战斗信息
    public static void SendFight(string myName, string hisName, string carName)
    {
        Fight temp = new Fight();
        temp.MyName = myName;
        temp.HisName = hisName;
        temp.CarName = carName;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 4;
        data.CopyTo(new_data, 1);

        AsynSend(client, new_data);
    }

    public static void SendTurnEnd(string myName, string hisName)
    {
        ToFight temp = new ToFight();
        temp.MyName = myName;
        temp.HisName = hisName;
        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 6;
        data.CopyTo(new_data,1);
        AsynSend(client,new_data);
    }

    public static void SendMyAttribute(string myName, float positionx,float positionz,float rotationy)
    {
        PlayerAttribute temp = new PlayerAttribute();
        temp.MyName = myName;
        temp.Positionx = positionx;
        temp.Positionz = positionz;
        temp.Rotationy = rotationy;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 7;
        data.CopyTo(new_data,1);
        AsynSend(client,new_data);
    }

    public static void SendMyLose(string myName, string hisName)
    {
        ToFight temp = new ToFight();
        temp.MyName = myName;
        temp.HisName = hisName;
        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 8;
        data.CopyTo(new_data,1);

        AsynSend(client,new_data);
    }

    public static void SendChangeCardAttribute(string player_name,int index,int value)
    {
        PlayerAttribute temp = new PlayerAttribute();
        temp.MyName = player_name;
        temp.Positionx = index;
        temp.Positionz = value;
        temp.Rotationy = 0;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 9;
        data.CopyTo(new_data,1);

        AsynSend(client,new_data);
    }
    public static void SendAddCard(string player_name,string card_name)
    {
        ToFight temp = new ToFight();
        temp.MyName = player_name;
        temp.HisName = card_name;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 10;
        data.CopyTo(new_data,1);

        AsynSend(client,new_data);
    }
    public static void RequestCardAttribute(string player_name)
    {
        ToFight temp = new ToFight();
        temp.MyName = player_name;

        byte[] data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        new_data[0] = 11;
        data.CopyTo(new_data,1);

        AsynSend(client,new_data);
    }
    //public static void ReceiveTalk(byte[] data)
    //{
    //    Talk temp = new Talk();
    //    Deserialize(temp, data);
    //    string his_name = temp.MyName;
    //    string my_name = temp.HisName;
    //    string message = temp.Msg;
    //    //LuaManager.Instance.Env.DoString("require('Assets/Scripts/Lua/UI/ChatUI.lua') EventSystem.Send('SendChatMsg',"+message+","+his_name+")");
    //    Debug.Log(his_name + "say: " + message);
    //}

    //public static void ReceiveToFight(byte[] data)
    //{
    //    ToFight temp = new ToFight();
    //    Deserialize(temp,data);
    //    string his_name = temp.MyName;
    //    string my_name = temp.HisName;
    //    Debug.Log(his_name+"向你发起了战斗邀请");
    //    temp.HisName = his_name;
    //    temp.MyName = my_name;
    //    data = Serialize(temp);
    //    byte[] new_data = new byte[data.Length + 1];
    //    //同意 发一个ToFight回去
    //    {
    //        new_data[0] = 3;
    //        data.CopyTo(new_data, 1);

    //    }
    //    //拒绝 首字节改成5发回去
    //    //{
    //    //    new_data[0] = 5;
    //    //    data.CopyTo(new_data,1);
    //    //}
    //    AsynSend(client, new_data);

    //}

    //public static void ReceiveFight(byte[] data)
    //{
    //    Fight temp = new Fight();
    //    Deserialize(temp,data);
    //    string my_name = temp.HisName;
    //    string his_name = temp.MyName;
    //    string car_Name = temp.CarName;//////////////////////////////////////////
    //    LuaManager.Instance.Env.DoString("FightSystem.SendCard("+car_Name+",false)");
    //    Debug.Log(his_name + "使用了"+car_Name+"号牌");
    //}

    //public static void StartToFight(byte[] data)
    //{
    //    byte[] new_data = new byte[data.Length - 1];
    //    bool IsFirst = data[0] == 1 ? true : false;
    //    Array.Copy(data,1,new_data,0,data.Length-1);
    //    ToFight temp = new ToFight();
    //    Deserialize(temp,new_data);
    //    string his_name = temp.HisName;
    //    //进入战斗
    //    LuaManager.Instance.Env.DoString("FightSystem.StartFight("+IsFirst+ ",100,100,100,10,1,3,100,100,100,10,1)");
    //    //传入参数 对手名字，先手后手

    //}
    public static void close()
    {
        //Debug.Log("关闭套接字");
        //if(client != null)
        //client.Close();
    }
}