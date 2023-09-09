using System;
using System.Collections.Generic;
using Newtonsoft.Json;

public class PlayerData
{
    private CharacterSkins _selectedCharacterSkin;
    private MazeSkins _selectedMazeSkin;

    private List<CharacterSkins> _openCharacterSkins;
    private List<MazeSkins> _openMazeSkins;

    private int _money;

    public PlayerData()
    {
        _money = 30000;

        _selectedCharacterSkin = CharacterSkins.Bear;
        _selectedMazeSkin = MazeSkins.China;

        _openCharacterSkins = new List<CharacterSkins>() { _selectedCharacterSkin };
        _openMazeSkins = new List<MazeSkins>() { _selectedMazeSkin };
    }

    [JsonConstructor]
    public PlayerData(int money, CharacterSkins selectedCharacterSkin, MazeSkins selectedMazeSkin,
        List<CharacterSkins> openCharacterSkins, List<MazeSkins> openMazeSkins)
    {
        Money = money;

        _selectedCharacterSkin = selectedCharacterSkin;
        _selectedMazeSkin = selectedMazeSkin;

        _openCharacterSkins = new List<CharacterSkins>(openCharacterSkins);
        _openMazeSkins = new List<MazeSkins>(openMazeSkins);
    }

    public int Money
    {
        get => _money;

        set
        {
            if (value < 0)
                throw new ArgumentOutOfRangeException(nameof(value));

            _money = value;
        }
    }

    public CharacterSkins SelectedCharacterSkin
    {
        get => _selectedCharacterSkin;
        set
        {
            if (_openCharacterSkins.Contains(value) == false)
                throw new ArgumentException(nameof(value));

            _selectedCharacterSkin = value;
        }
    }

    public MazeSkins SelectedMazeSkin
    {
        get => _selectedMazeSkin;
        set
        {
            if (_openMazeSkins.Contains(value) == false)
                throw new ArgumentException(nameof(value));

            _selectedMazeSkin = value;
        }
    }

    public IEnumerable<CharacterSkins> OpenCharacterSkins => _openCharacterSkins;

    public IEnumerable<MazeSkins> OpenMazeSkins => _openMazeSkins;

    public void OpenCharacterSkin(CharacterSkins skin)
    {
        if(_openCharacterSkins.Contains(skin))
            throw new ArgumentException(nameof(skin));

        _openCharacterSkins.Add(skin);
    }

    public void OpenMazeSkin(MazeSkins skin)
    {
        if (_openMazeSkins.Contains(skin))
            throw new ArgumentException(nameof(skin));

        _openMazeSkins.Add(skin);
    }
}
