using UnityEngine;

public class Monolith : MonoBehaviour
{
    float rotationX;

    void Start()
    {
    }

    void Update()
    {
        var rotation = Quaternion.Euler(rotationX, rotationX, rotationX);
        gameObject.transform.localRotation = rotation;
        rotationX = (rotationX + 0.1f) % 360f;
    }
}
