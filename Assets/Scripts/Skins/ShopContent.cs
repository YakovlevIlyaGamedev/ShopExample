using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[CreateAssetMenu(fileName = "ShopContent", menuName = "Shop/ShopContent")]
public class ShopContent : ScriptableObject
{
    [SerializeField] private List<CharacterSkinItem> _characterSkinItems;
    [SerializeField] private List<MazeSkinItem> _mazeSkinItems;

    public IEnumerable<CharacterSkinItem> CharacterSkinItems => _characterSkinItems;
    public IEnumerable<MazeSkinItem> MazeSkinItems => _mazeSkinItems;

    private void OnValidate()
    {
        var charaterSkinsDuplicates = _characterSkinItems.GroupBy(item => item.SkinType)
            .Where(array => array.Count() > 1);

        if (charaterSkinsDuplicates.Count() > 0)
            throw new InvalidOperationException(nameof(_characterSkinItems));

        var mazeSkinsDuplicates = _mazeSkinItems.GroupBy(item => item.SkinType)
            .Where(array => array.Count() > 1);

        if (mazeSkinsDuplicates.Count() > 0)
            throw new InvalidOperationException(nameof(_mazeSkinItems));
    }
}
