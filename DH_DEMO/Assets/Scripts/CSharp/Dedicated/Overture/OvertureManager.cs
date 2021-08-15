using System.Collections;
using UnityEngine;
using UnityEngine.AddressableAssets;

public class OvertureManager : MonoBehaviour
{
    [SerializeField] AssetReference SceneCamera;
    [SerializeField] private LuaScriptBehaviour overtureManager;
    [SerializeField] private Animator SceneTran;
    bool atTheBeginning = true;
    [SerializeField] private Animator cameraInLoading;
    [SerializeField] private MeshRenderer seaSurface;

    // AsyncOperationHandle _sceneCameraOpt;


    IEnumerator WaitForLoading()
    {
        bool hadFinInit = false;
        while (true)
        {
            if (atTheBeginning)
            {
                yield return new WaitForSeconds(4);
                atTheBeginning = false;
            }
            if (overtureManager.IsBuilding == false /*&& _sceneCameraOpt.IsDone*/)
            {
                if (!hadFinInit)
                {
                    SceneTran.SetTrigger("FinInit");
                    hadFinInit = true;
                    yield return new WaitForSeconds(0.3f);
                }
                else
                {
                    cameraInLoading.SetTrigger("CardsFall");
                    EventManager.Instance.Send("1 'CardsFalling' 'OvertureManager'");
                    yield break;
                }
            }
            yield return new WaitForSeconds(1);
        }
    }

    void Awake()
    {
        // _sceneCameraOpt = SceneCamera.InstantiateAsync();
        StartCoroutine(WaitForLoading());
    }
    private void Start()
    {
        seaSurface.material.SetFloat("_FogAlpha", 1);
    }

    void Update()
    {

    }
}
