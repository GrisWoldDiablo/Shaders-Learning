using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class Blending : MonoBehaviour
{
    public Material mat;
    private void Update()
    {
        mat.SetFloat("_BlendF",Mathf.Abs(Mathf.Sin(Time.time)));
    }
}
