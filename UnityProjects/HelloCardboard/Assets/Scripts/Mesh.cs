using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mesh : MonoBehaviour
{
    float rotationX;

    // Start is called before the first frame update
    void Start()
    {
        //
    }

    // Update is called once per frame
    void Update()
    {
        var rotation = Quaternion.Euler(rotationX, 0f, 0f);
        gameObject.transform.localRotation = rotation;
        rotationX = (rotationX + 1f) % 360f;
    }
}
