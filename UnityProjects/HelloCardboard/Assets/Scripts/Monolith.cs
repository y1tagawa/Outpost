using UnityEngine;

public class Monolith : MonoBehaviour
{
    float rotationX = 0;

    void Start()
    {
    }

    void Update()
    {
        var rotation = Quaternion.Euler(rotationX, 0f, 0f);
        gameObject.transform.localRotation = rotation;
        rotationX = (rotationX + 2f) % 360f;
    }

    // See CardboardReticlePointer.cs
    void OnPointerEnter() { }

    // See CardboardReticlePointer.cs
    void OnPointerExit() { }
}
