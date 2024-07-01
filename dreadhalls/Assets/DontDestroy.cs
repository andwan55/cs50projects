using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class DontDestroy : MonoBehaviour {

	// make this static so it's visible across all instances
	public static DontDestroy instance = null;
	private string lastSceneName;  // Store the name of the last active scene

    void Awake() {
        if (instance == null) {
            instance = this;
            DontDestroyOnLoad(gameObject);
            lastSceneName = SceneManager.GetActiveScene().name; // Initialize with the current scene name
            SceneManager.sceneLoaded += OnSceneLoaded;  // Subscribe to the sceneLoaded event
        } else if (instance != this) {
            Destroy(gameObject);
        }
    }

    void OnDestroy() {
        // Unsubscribe from the sceneLoaded event to avoid memory leaks
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode) {
        // Check if the new scene is different from the last one
        if (scene.name != lastSceneName) {
            Destroy(gameObject);  // Destroy this GameObject if the scene has changed
			LevelGenerator.level = 0; // reset player level
        } else {
            // Update lastSceneName if staying in the same scene (for any reason, if needed)
            lastSceneName = scene.name;
        }
	}

	// Use this for initialization
	void Start () {
		
	}
}
