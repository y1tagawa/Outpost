using UnityEngine;

public class Projectile : MonoBehaviour
{
    const int lapse = 60 * 2/*sec*/;

    int age;
    Vector3 delta;

    void Start()
    {
        Reset();
    }

    void Update()
    {
        if (age >= lapse)
        {
            Reset();
        }
        else
        {
            ++age;
            gameObject.transform.position += delta;
        }
    }

    private void Reset()
    {
        age = 0;
        var sight = GameObject.Find("/Player/Main Camera/CardboardReticlePointer");
        var forward = sight.transform.forward;
        delta = -0.5f * forward;
        gameObject.transform.position = sight.transform.position + delta * (-lapse / 2);
    }
}
