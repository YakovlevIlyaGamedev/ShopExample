using System;
using UnityEngine;

[CreateAssetMenu(fileName = "MazeCellFactory", menuName = "GameplayExample/MazeCellFactory")]
public class MazeCellFactory : ScriptableObject
{
    [SerializeField] private MazeCell _greenTheme;
    [SerializeField] private MazeCell _egyptTheme;
    [SerializeField] private MazeCell _cristallTheme;
    [SerializeField] private MazeCell _jungleTheme;
    [SerializeField] private MazeCell _chinaTheme;
    [SerializeField] private MazeCell _beachTheme;
    [SerializeField] private MazeCell _treasuryTheme;

    public MazeCell Get(MazeSkins skinType, Vector3 spawnPosition)
    {
        MazeCell instance = Instantiate(GetPrefab(skinType), spawnPosition, Quaternion.identity, null);
        instance.Initialize();
        return instance;
    }

    public MazeCell GetPrefab(MazeSkins skinType)
    {
        switch (skinType)
        {
            case MazeSkins.Green:
                return _greenTheme;
            case MazeSkins.Egypt:
                return _egyptTheme;
            case MazeSkins.Cristall:
                return _cristallTheme;
            case MazeSkins.Jungle:
                return _jungleTheme;
            case MazeSkins.China:
                return _chinaTheme;
            case MazeSkins.Beach:
                return _beachTheme;
            case MazeSkins.Treasury:
                return _treasuryTheme;

            default:
                throw new ArgumentException(nameof(skinType));
        }
    }
}
