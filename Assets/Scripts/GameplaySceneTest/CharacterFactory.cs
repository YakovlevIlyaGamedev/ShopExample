using System;
using UnityEngine;

[CreateAssetMenu(fileName = "CharactersFactory", menuName = "GameplayExample/CharactersFactory")]
public class CharacterFactory : ScriptableObject
{
    [SerializeField] private Character _anubis;
    [SerializeField] private Character _bat;
    [SerializeField] private Character _bear;
    [SerializeField] private Character _bearArmor;
    [SerializeField] private Character _cat;
    [SerializeField] private Character _deer;
    [SerializeField] private Character _dog;
    [SerializeField] private Character _dogBeach;
    [SerializeField] private Character _dragon;
    [SerializeField] private Character _hare;
    [SerializeField] private Character _monkey;
    [SerializeField] private Character _mouse;
    [SerializeField] private Character _panda;
    [SerializeField] private Character _parrot;
    [SerializeField] private Character _penguin;
    [SerializeField] private Character _pharaon;
    [SerializeField] private Character _ra;
    [SerializeField] private Character _redPanda;
    [SerializeField] private Character _duck;

    public Character Get(CharacterSkins skinType, Vector3 spawnPosition)
    {
        Character instance = Instantiate(GetPrefab(skinType), spawnPosition, Quaternion.identity, null);
        instance.Initialize();
        return instance;
    }

    private Character GetPrefab(CharacterSkins skinType)
    {
        switch (skinType)
        {
            case CharacterSkins.Anubis:
                return _anubis;
            case CharacterSkins.Bat:
                return _bat;
            case CharacterSkins.Bear:
                return _bear;
            case CharacterSkins.BearArmor:
                return _bearArmor;
            case CharacterSkins.Cat:
                return _cat;
            case CharacterSkins.Deer:
                return _deer;
            case CharacterSkins.Dog:
                return _dog;
            case CharacterSkins.DogBeach:
                return _dogBeach;
            case CharacterSkins.Dragon:
                return _dragon;
            case CharacterSkins.Hare:
                return _hare;
            case CharacterSkins.Monkey:
                return _monkey;
            case CharacterSkins.Mouse:
                return _mouse;
            case CharacterSkins.Panda:
                return _panda;
            case CharacterSkins.Parrot:
                return _parrot;
            case CharacterSkins.Penguin:
                return _penguin;
            case CharacterSkins.Pharaon:
                return _pharaon;
            case CharacterSkins.Ra:
                return _ra;
            case CharacterSkins.RedPanda:
                return _redPanda;
            case CharacterSkins.Duck:
                return _duck;

            default:
                throw new ArgumentException(nameof(skinType));
        }
    }
}
