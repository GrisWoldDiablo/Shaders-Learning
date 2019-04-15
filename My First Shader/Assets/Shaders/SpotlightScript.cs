using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class SpotlightScript : MonoBehaviour
{

    public Material mat;
    public string protertyName;
    public Transform player;

    // Update is called once per frame
    void Update()
    {
        if (player != null)
        {
            mat.SetVector(protertyName, player.position);
        }
        else
        {
            Debug.Log("Assign the player!");
        }
    }
}
