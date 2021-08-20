using System.Collections;
using System.Collections.Generic;
using UnityEngine.AddressableAssets;
using UnityEngine;
using XLua;

public class VoiceLoad : MonoBehaviour
{
    public List<AudioClip> voices;
    public Dictionary<string,AudioClip> voices_dic = null;

    public static VoiceLoad inst 
    {
        private set;
        get;
    }
    
    void Awake() 
    {
        if(inst == null)
        {
            inst = this;
            Debug.Log("加载voices");
            foreach (var item in voices)
            {
                voices_dic.Add(item.name,item);
            }
            DontDestroyOnLoad(gameObject);
        }
        else
            Destroy(gameObject);
    }

    public AudioClip GetClip(string key)
    {
        return voices_dic[key];
    }

}

[LuaCallCSharp]
public static class VoiceLoadStatic
{
    [LuaCallCSharp]
    public static VoiceLoad GetVoices()
    {
        return VoiceLoad.inst;
    }
}
