using UnityEngine;

public class GameplayTestBootstrap : MonoBehaviour
{
    [SerializeField] private Transform _characterSpawnPoint;
    [SerializeField] private Transform _mazeCellSpawnPoint;
    [SerializeField] private CharacterFactory _characterFactory;
    [SerializeField] private MazeCellFactory _mazeCellFactory;

    private IDataProvider _dataProvider;
    private IPersistentData _persistentPlayerData;

    private void Awake()
    {
        InitializeData();

        DoTestSpawn();
    }

    private void DoTestSpawn()
    {
        Character character = _characterFactory.Get(_persistentPlayerData.PlayerData.SelectedCharacterSkin, _characterSpawnPoint.position);
        MazeCell mazeCell = _mazeCellFactory.Get(_persistentPlayerData.PlayerData.SelectedMazeSkin, _mazeCellSpawnPoint.position);

        Debug.Log($"«аспавнили персонажа {_persistentPlayerData.PlayerData.SelectedCharacterSkin} и клетку лабиринта {_persistentPlayerData.PlayerData.SelectedMazeSkin}");
    }

    private void InitializeData()
    {
        _persistentPlayerData = new PersistentData();
        _dataProvider = new DataLocalProvider(_persistentPlayerData);

        LoadDataOrInit();
    }

    private void LoadDataOrInit()
    {
        if (_dataProvider.TryLoad() == false)
            _persistentPlayerData.PlayerData = new PlayerData();
    }
}
