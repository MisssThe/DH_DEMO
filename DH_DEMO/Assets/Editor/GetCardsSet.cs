using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.Text;
using System.IO;
using System;
public class GetCardsSet : MonoBehaviour
{
    // 读取excel文件生成卡牌集
    private static StreamWriter sw = null;
    [MenuItem("Tools/GetCardsFromExcel")]
    public static void GetCardsFromExcel()
    {
        FileStream fs = new FileStream(@"C:\Unity\Cloud\DH_DEMO_FINAL\DH_DEMO\Assets\Scripts\Lua\Fight\CardEffectAndDisplay.lua",FileMode.Open, FileAccess.Write, FileShare.None);
        sw = new StreamWriter(fs);
        sw.WriteLine("---------------------------- 攻击牌 ----------------------------");
        SetAttackCards("卡牌集 - 攻击牌");
        sw.WriteLine("---------------------------- 辅助牌 ----------------------------");
        SetAssitCards("卡牌集 - 辅助牌");
        sw.WriteLine("---------------------------- 咒术牌 ----------------------------");
        // SetConjurCards("卡牌集 - 咒术牌");
        // sw.Close();
        Debug.Log("转换完成");
        // fs.Close();
        sw.Close();
    }
    private static void SetAttackCards(string file_name)
    {
        if (sw != null)
        {
            FileStream fs = new FileStream(@"C:\Users\dh_xly1\Desktop\" + file_name + ".csv", FileMode.Open, FileAccess.Read, FileShare.None);
            StreamReader sr = new StreamReader(fs, System.Text.Encoding.GetEncoding(936));
            string str = sr.ReadLine();
            while (str != null)
            {    
                str = sr.ReadLine();
                if (str != null)
                {
                    string[] xu = str.Split(',');
                    string card_name = xu[0];
                    string damage_count = xu[1];
                    string damage = xu[2];
                    string is_fixed = xu[3];
                    string card_code = "local "+card_name+" = {}\n";
                    card_code += "function "+card_name+".Effect(play1,play2)\n";
                    card_code += "  local real_d = play1:Attack("+damage+")\n";
                    card_code += "  for i = 0,"+damage_count+",1 do\n";
                    card_code += "      play2:ReduceHP(real_d)\n";
                    card_code += "  end\nend\n";
                    card_code += "function "+card_name+".Display()\n";
                    card_code += "end\n";
                    card_code += "EventSystem.Add('"+card_name+"_Effect',false,"+card_name+".Effect)\n";
                    card_code += "EventSystem.Add('"+card_name+"_Display',false,NormalAttack.Display)\n";
                    sw.Write(card_code);
                }
            }   
            sr.Close();
        }
    }
    private static void SetAssitCards(string file_name)
    {
        if (sw != null)
        {
            FileStream fs = new FileStream(@"C:\Users\dh_xly1\Desktop\" + file_name + ".csv", FileMode.Open, FileAccess.Read, FileShare.None);
            StreamReader sr = new StreamReader(fs, System.Text.Encoding.GetEncoding(936));
            string str = "";
            sr.ReadLine();
            while (str != null)
            {    
                str = sr.ReadLine();
                if (str != null)
                {
                    string[] xu = str.Split(',');
                    string card_name = xu[0];
                    double damage = Convert.ToDouble(xu[1]);
                    double damaged = Convert.ToDouble(xu[2]);
                    double treatment = Convert.ToDouble(xu[3]);
                    double mp_cost = Convert.ToDouble(xu[4]);
                    double round_num = Convert.ToDouble(xu[5]);
                    bool is_self = Convert.ToBoolean(xu[6]);
                    string card_code = "local "+card_name+" = {}\n";
                    card_code += "function "+card_name+".Effect(play1,play2)\n";
                    string attri = is_self?"play1":"play2";
                    if (round_num > 0.1)
                    {
                        string type = null;
                        string add_buff = null;
                        if (Math.Abs(damaged) > 0.01)
                        {
                            type = "'IYD'";
                            add_buff = "AddDebuff(";
                            if (damaged < 0)
                            {
                                add_buff = "AddBuff(";
                                type = "RYD";
                            }
                            card_code += "  "+attri+":"+add_buff+damaged+","+type+")\n";
                        }
                        if (Math.Abs(damage) > 0.01)
                        {
                            type = "'IMD'";
                            add_buff = "AddBuff(";
                            if (damage < 0)
                            {
                                add_buff = "AddDebuff(";
                                type = "RMD";
                            }
                            card_code += "  "+attri+":"+add_buff+damage+","+type+")\n";
                        }
                        if (Math.Abs(treatment) > 0.01)
                        {
                            type = "'ITE'";
                            add_buff = "AddBuff(";
                            if (treatment < 0)
                            {
                                add_buff = "AddDebuff(";
                                type = "'RTE'";
                            }
                            card_code += "  "+attri+":"+add_buff+treatment+","+type+")\n";
                        }
                        if (Math.Abs(mp_cost) > 0.01)
                        {
                            type = "'IMC'";
                            add_buff = "AddBuff(";
                            if (damage < 0)
                            {
                                add_buff = "AddDebuff(";
                                type = "'RMC'";
                            }
                            card_code += "  "+attri+":"+add_buff+mp_cost+","+type+")\n";
                        }
                    }
                    card_code += "end\n";
                    card_code += "function "+card_name+".Display()\r\n";
                    card_code += "end\n";
                    card_code += "EventSystem.Add('"+card_name+"_Effect',false,"+card_name+".Effect)\n";
                    card_code += "EventSystem.Add('"+card_name+"_Display',false,"+card_name+".Display)\n";
                    Debug.Log(card_code);
                    sw.Write(card_code);
                }
            }   
            sr.Close();
        }
    }
    private static void SetConjurCards(string file_name)
    {
        // if (sw != null)
        // {
        //     FileStream fs = new FileStream(@"C:\Users\dh_xly1\Desktop\" + file_name + ".csv", FileMode.Open, FileAccess.Read, FileShare.None);
        //     StreamReader sr = new StreamReader(fs, System.Text.Encoding.GetEncoding(936));
        //     string str = "";
        //     sr.ReadLine();
        //     while (str != null)
        //     {    
        //         str = sr.ReadLine();
        //         if (str != null)
        //         {
        //             string[] xu = str.Split(',');
        //             string card_name = xu[0];
        //             double mp_cost = Convert.ToDouble(xu[1]);
        //             double damage = Convert.ToDouble(xu[2]);
        //             double card_num = Convert.ToDouble(xu[3]);
        //             string assit_card = xu[4];
        //             bool is_self1 = Convert.ToBoolean(xu[5]);
        //             bool is_self2 = Convert.ToBoolean(xu[6]);
        //             bool is_self2 = Convert.ToBoolean(xu[7]);
        //             string card_code = "local "+card_name+" = {}\n";
        //             card_code += "function "+card_name+".Effect()\n";
        //             string attri = null;
        //             if (mp_cost > 0.01)
        //             {
        //                 card_code += "  play1:ReduceMP("+mp_cost+")";
        //             }
        //             if (Math.Abs(damage) > 0.01)
        //             {
        //                 attri = is_self1?"Player_Attri":"Rivial_Attri";
        //                 card_code += "  FightSystem."+attri+":"+add_buff+damage+","+type+")\n";
        //             }
        //             if (Math.Abs(card_num) > 0.01)
        //             {
        //                 attri = is_self2?"Player_Attri":"Rivial_Attri";"
        //                 card_code += "  FightSystem."+attri+":"+add_buff+treatment+","+type+")\n";
        //             }
        //             if (!assit_card.Equals(""))
        //             {
        //                 attri
        //                 card_code += "  EventSystem.Send('"+assit_card+"_Effect')\n";
        //             }
        //             card_code += "end\n";
        //             card_code += "function "+card_name+".Display()\r\n";
        //             card_code += "end\n";
        //             card_code += "EventSystem.Add('"+card_name+"_Effect',false,"+card_name+".Effect)\n";
        //             card_code += "EventSystem.Add('"+card_name+"_Display',false,"+card_name+".Display)\n";
        //             Debug.Log(card_code);
        //             sw.Write(card_code);
        //         }
        //     }   
        //     sr.Close();
        // }
    }
}
