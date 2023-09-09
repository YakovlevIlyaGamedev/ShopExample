using UnityEngine;

[CreateAssetMenu(fileName = "MazeSkinItem", menuName = "Shop/MazeSkinItem")]
public class MazeSkinItem : ShopItem
{
    [field: SerializeField] public MazeSkins SkinType { get; private set; }
}
