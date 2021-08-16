using System.Collections;
using UnityEngine;
using UnityEngine.UI;
using XLua;

[RequireComponent(typeof(Text))]
public class LoadingText : MonoBehaviour
{
    Text text;
    private string textShow;
    Coroutine textChange;

    IEnumerator TextChange()
    {
        while (true)
        {
            if (text.text == textShow + "..")
                text.text = textShow + "...";
            else if (text.text == textShow + ".")
                text.text = textShow + "..";
            else if (text.text == textShow)
                text.text = textShow + ".";
            else
                text.text = textShow;

            yield return new WaitForSeconds(0.5f);
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        if (text == null)
        {
            text = GetComponent<Text>();
            textShow = text.text;
            StartCoroutine(TextChange());
        }
    }

    private void OnEnable()
    {
        if (text == null)
        {
            text = GetComponent<Text>();
            textShow = text.text;
            StartCoroutine(TextChange());
        }
    }

    private void OnDisable()
    {
        if (textChange != null)
            StopCoroutine(textChange);
    }

    private void OnDestroy()
    {
        if (textChange != null)
            StopCoroutine(textChange);
    }

    // Update is called once per frame
    void Update()
    {

    }
}
