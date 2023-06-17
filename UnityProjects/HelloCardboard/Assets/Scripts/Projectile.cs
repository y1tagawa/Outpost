using UnityEngine;

public class Projectile : MonoBehaviour
{
    const int lapse = 60 * 5;

    private Vector3 delta;
    private int age;

    void Start()
    {
        Reset();
    }

    void Update()
    {
        if (++age >= lapse) {
            Reset();
        }
        else
        {
            gameObject.transform.position += delta;
        }
    }

    private void Reset() 
    {
        var player = GameObject.Find("/Player");
        age = 0;
        var forward = Camera.main.transform.forward.normalized;
        delta = forward * -0.5f;
        gameObject.transform.position = player.transform.position - delta * (lapse / 2);   
    }
}
