using UnityEngine;
using UnityEngine.UI;

public class DisplayLevel : MonoBehaviour
{
    Text levelText;  // Reference to the Text component
    // If using TextMeshPro, use:
    // public TextMeshProUGUI levelText;

    void Start()
    {
        levelText = GetComponent<Text>();  // Get the Text component
        // If using TextMeshPro, use:
        // levelText = GetComponent<TextMeshProUGUI>();
    }

    void Update()
    {
        // Set the text to show the current level from LevelGenerator
        levelText.text = "Level: " + LevelGenerator.level.ToString();
    }
}