public class SkinSelector : IShopItemVisitor
{
    private IPersistentData _persistentData;

    public SkinSelector(IPersistentData persistentData) => _persistentData = persistentData;

    public void Visit(ShopItem shopItem) => Visit((dynamic)shopItem);

    public void Visit(CharacterSkinItem characterSkinItem) 
        => _persistentData.PlayerData.SelectedCharacterSkin = characterSkinItem.SkinType;

    public void Visit(MazeSkinItem mazeSkinItem) 
        => _persistentData.PlayerData.SelectedMazeSkin = mazeSkinItem.SkinType;
}
