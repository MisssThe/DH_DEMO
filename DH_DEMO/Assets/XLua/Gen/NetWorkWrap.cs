#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using XLua;
using System.Collections.Generic;


namespace XLua.CSObjectWrap
{
    using Utils = XLua.Utils;
    public class NetWorkWrap 
    {
        public static void __Register(RealStatePtr L)
        {
			ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			System.Type type = typeof(NetWork);
			Utils.BeginObjectRegister(type, L, translator, 0, 0, 0, 0);
			
			
			
			
			
			
			Utils.EndObjectRegister(type, L, translator, null, null,
			    null, null, null);

		    Utils.BeginClassRegister(type, L, __CreateInstance, 10, 1, 1);
			Utils.RegisterFunc(L, Utils.CLS_IDX, "Init", _m_Init_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Serialize", _m_Serialize_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "Deserialize", _m_Deserialize_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "AsynSend", _m_AsynSend_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SendRegister", _m_SendRegister_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SendLogIn", _m_SendLogIn_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SendTalk", _m_SendTalk_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SendToFight", _m_SendToFight_xlua_st_);
            Utils.RegisterFunc(L, Utils.CLS_IDX, "SendFight", _m_SendFight_xlua_st_);
            
			
            
			Utils.RegisterFunc(L, Utils.CLS_GETTER_IDX, "client", _g_get_client);
            
			Utils.RegisterFunc(L, Utils.CLS_SETTER_IDX, "client", _s_set_client);
            
			
			Utils.EndClassRegister(type, L, translator);
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int __CreateInstance(RealStatePtr L)
        {
            
			try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
				if(LuaAPI.lua_gettop(L) == 1)
				{
					
					var gen_ret = new NetWork();
					translator.Push(L, gen_ret);
                    
					return 1;
				}
				
			}
			catch(System.Exception gen_e) {
				return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
			}
            return LuaAPI.luaL_error(L, "invalid arguments to NetWork constructor!");
            
        }
        
		
        
		
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Init_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    
                    NetWork.Init(  );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Serialize_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    Google.Protobuf.IMessage _message = (Google.Protobuf.IMessage)translator.GetObject(L, 1, typeof(Google.Protobuf.IMessage));
                    
                        var gen_ret = NetWork.Serialize( _message );
                        LuaAPI.lua_pushstring(L, gen_ret);
                    
                    
                    
                    return 1;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_Deserialize_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    Google.Protobuf.IMessage _message = (Google.Protobuf.IMessage)translator.GetObject(L, 1, typeof(Google.Protobuf.IMessage));
                    byte[] _data = LuaAPI.lua_tobytes(L, 2);
                    
                    NetWork.Deserialize( _message, _data );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_AsynSend_xlua_st_(RealStatePtr L)
        {
		    try {
            
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
            
            
            
                
                {
                    System.Net.Sockets.Socket _tcpClient = (System.Net.Sockets.Socket)translator.GetObject(L, 1, typeof(System.Net.Sockets.Socket));
                    byte[] _data = LuaAPI.lua_tobytes(L, 2);
                    
                    NetWork.AsynSend( _tcpClient, _data );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendRegister_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 1);
                    string _password = LuaAPI.lua_tostring(L, 2);
                    
                    NetWork.SendRegister( _name, _password );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendLogIn_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _name = LuaAPI.lua_tostring(L, 1);
                    string _password = LuaAPI.lua_tostring(L, 2);
                    
                    NetWork.SendLogIn( _name, _password );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendTalk_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _myName = LuaAPI.lua_tostring(L, 1);
                    string _hisName = LuaAPI.lua_tostring(L, 2);
                    string _msg = LuaAPI.lua_tostring(L, 3);
                    
                    NetWork.SendTalk( _myName, _hisName, _msg );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendToFight_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _myName = LuaAPI.lua_tostring(L, 1);
                    string _hisName = LuaAPI.lua_tostring(L, 2);
                    
                    NetWork.SendToFight( _myName, _hisName );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _m_SendFight_xlua_st_(RealStatePtr L)
        {
		    try {
            
            
            
                
                {
                    string _myName = LuaAPI.lua_tostring(L, 1);
                    string _hisName = LuaAPI.lua_tostring(L, 2);
                    int _carIndex = LuaAPI.xlua_tointeger(L, 3);
                    
                    NetWork.SendFight( _myName, _hisName, _carIndex );
                    
                    
                    
                    return 0;
                }
                
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            
        }
        
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _g_get_client(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    translator.Push(L, NetWork.client);
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 1;
        }
        
        
        
        [MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
        static int _s_set_client(RealStatePtr L)
        {
		    try {
                ObjectTranslator translator = ObjectTranslatorPool.Instance.Find(L);
			    NetWork.client = (System.Net.Sockets.Socket)translator.GetObject(L, 1, typeof(System.Net.Sockets.Socket));
            
            } catch(System.Exception gen_e) {
                return LuaAPI.luaL_error(L, "c# exception:" + gen_e);
            }
            return 0;
        }
        
		
		
		
		
    }
}
