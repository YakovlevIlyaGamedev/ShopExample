using System;
using TMPro;
using UnityEngine;

public class ValueView<T> : MonoBehaviour where T : IConvertible
{
    [SerializeField] private TMP_Text _text;

    public void Show(T value)
    {
        gameObject.SetActive(true);
        _text.text = value.ToString();
    }

    public void Hide() => gameObject.SetActive(false);
}
