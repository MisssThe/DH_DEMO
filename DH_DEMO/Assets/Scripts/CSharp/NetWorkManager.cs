using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Google.Protobuf;
using Network;
using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using XLua;

class message
{
    public message(byte[] data,int length)
    {
        this.data = data;
        this.length = length;
    }
    public byte[] data;
    public int length;
};

public class NetWorkManager : MonoBehaviour
{
    [SerializeField]
    public GameObject player_ship_prefab;
    static Queue<message> message_queue;
    static Dictionary<string, GameObject> other_player;
    Socket client;



    private void Start()
    {
        NetWork.Init();
        message_queue = new Queue<message>();
        other_player = new Dictionary<string, GameObject>();
        client = NetWork.client;
    }

    public static void MsgAdd(byte[] data,int length)
    {
        message temp = new message(data,length);
        message_queue.Enqueue(temp);
    }

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

    public  void AsynSend(Socket tcpClient, byte[] data)
    {
        tcpClient.BeginSend(data, 0, data.Length, SocketFlags.None, asyncResult =>
        {
            //完成发送消息
            int length = tcpClient.EndSend(asyncResult);
        }, null);
    }
    public static void ReceiveTalk(byte[] data)
    {
        Talk temp = new Talk();
        Deserialize(temp, data);
        string his_name = temp.MyName;
        string my_name = temp.HisName;
        string message = temp.Msg;
        LuaManager.Instance.Env.DoString("require('Assets/Scripts/Lua/UI/ChatUI.lua') EventSystem.Send('SendChatMsg','"+message+"','"+his_name+"')");
        Debug.Log(his_name + "say: " + message);
    }

    public void ReceiveToFight(byte[] data)
    {
        ToFight temp = new ToFight();
        Deserialize(temp, data);
        string his_name = temp.MyName;
        string my_name = temp.HisName;
        Debug.Log(his_name + "向你发起了战斗邀请");
        temp.HisName = his_name;
        temp.MyName = my_name;
        data = Serialize(temp);
        byte[] new_data = new byte[data.Length + 1];
        //同意 发一个ToFight回去
        {
            new_data[0] = 3;
            data.CopyTo(new_data, 1);

        }
        //拒绝 首字节改成5发回去
        //{
        //    new_data[0] = 5;
        //    data.CopyTo(new_data,1);
        //}
        AsynSend(client, new_data);

    }

    public static void ReceiveFight(byte[] data)
    {
        Fight temp = new Fight();
        Deserialize(temp, data);
        string my_name = temp.HisName;
        string his_name = temp.MyName;
        string car_Name = temp.CarName;//////////////////////////////////////////
                Debug.Log(his_name + "使用了" + car_Name + "号牌22222222");
        LuaManager.Instance.Env.DoString("EventSystem.Send('SendCard','" + car_Name + "',false)");
            //"FightSystem.SendCard('" + car_Name + "',false)");
        Debug.Log(his_name + "使用了" + car_Name + "号牌");
    }

    public static void StartToFight(byte[] data)
    {
        byte[] new_data = new byte[data.Length - 1];
        string IsFirst = data[0] == 1 ? "true" : "false";
        Array.Copy(data, 1, new_data, 0, data.Length - 1);
        ToFight temp = new ToFight();
        Deserialize(temp, new_data);
        string my_name = temp.MyName;
        string his_name = temp.HisName;
        Debug.Log("收到我的名字："+my_name+",别人名字："+his_name);
        //进入战斗
        LuaManager.Instance.Env.DoString("FightSystem.StartFight('"+my_name+"','"+his_name+"',"+ IsFirst+ ",100,100,100,10,1,3,100,100,100,10,1)");
        //传入参数 对手名字，先手后手

    }

    public void ReceivePlayerAttribute(byte[] data)
    {
        PlayerAttribute temp = new PlayerAttribute();
        Deserialize(temp, data);
        string his_name = temp.MyName;
        if(other_player.ContainsKey(his_name))
        {
            GameObject other = other_player[his_name];
            other.transform.rotation = Quaternion.Euler(new Vector3(0,temp.Rotationy,0));
            other.transform.position = new Vector3(temp.Positionx,0.4f,temp.Positionz);
            
        }
        else
        {
            GameObject other = Instantiate(player_ship_prefab,new Vector3(temp.Positionx,0.4f,temp.Positionz), Quaternion.Euler(new Vector3(0, temp.Rotationy, 0)));
            other.name = his_name;
            other_player.Add(his_name, other);
        }
        return;
    }

    public void ReceiveWin(byte[] data)
    {
        ToFight temp = new ToFight();
        string loser_name = temp.HisName;
        LuaManager.Instance.Env.DoString("EventSystem.Send('EndFight',true)");
        //显示你战胜了 loser_name;
    }
    private void Receive(message msg)
    {
        int length = msg.length;
        byte[] data = msg.data;
        if(length == 0)
        {
            return;
        }
        byte[] new_data = new byte[length - 1];
        Array.Copy(data, 1, new_data, 0, length - 1);
        int num = data[0];
        Debug.Log("首字节:" + num);
        switch (num)
        {
            case 2:
                ReceiveTalk(new_data);
                break;
            case 3:
                ReceiveToFight(new_data);
                break;
            case 4:
                ReceiveFight(new_data);
                break;
            case 5:
                StartToFight(new_data);
                break;
            case 6://代表用户注册失败，用户名已存在
                EventManager.Instance.Send("1 'loginRecive' 'loginpage' 1");
                Debug.Log("代表用户注册失败，用户名已存在");
                break;
            case 7://代表用户注册成功
                EventManager.Instance.Send("1 'loginRecive' 'loginpage' 2");
                Debug.Log("代表用户注册成功");
                break;
            case 8://代表用户登录失败，未注册
                EventManager.Instance.Send("1 'loginRecive' 'loginpage' 3");
                Debug.Log("代表用户登录失败，未注册");
                break;
            case 9://代表用户登陆失败，密码错误
                EventManager.Instance.Send("1 'loginRecive' 'loginpage' 4");
                Debug.Log("代表用户登陆失败，密码错误");
                break;
            case 10://代表用户登录成功
                    EventManager.Instance.Send("1 'loginRecive' 'loginpage' 5");
                Debug.Log("代表用户登录成功");
                break;
            case 11://聊天发送消息对方不在线
                Debug.Log("聊天发送消息对方不在线");
                break;
            case 12://发送战斗邀请对方不在线
                Debug.Log("发送战斗邀请对方不在线");
                break;
            case 13://战斗时对方不在线
                Debug.Log("战斗时对方不在线");
                break;
            case 14://对方拒绝战斗
                Debug.Log("对方拒绝战斗");
                break;
            case 15://你的回合
                LuaManager.Instance.Env.DoString("EventSystem.Send('StartRound')");
                Debug.Log("开始回合");
                break;
            case 16://更新玩家信息
                ReceivePlayerAttribute(new_data);
                break;
            case 17://获得对局胜利
                ReceiveWin(new_data);
                break;
            case 18://
                //EventManager.Instance.Send("1 'loginRecive' 'loginpage' 6");
                break;
            default:
                break;
        }
    }
    void Update()
    {
        if(message_queue.Count != 0)
        {
            message temp = message_queue.Dequeue();
            Receive(temp);
        }
    }

    private void OnDestroy()
    {
        NetWork.close();
    }
}
