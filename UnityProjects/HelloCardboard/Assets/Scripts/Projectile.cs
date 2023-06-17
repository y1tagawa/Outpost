using UnityEngine;

public class Monolith : MonoBehaviour
{
    const int lifeCycle = 60 * 5;
    public Vector3 delta;
    public int age;

    void Start()
    {
        Reset();
    }

    void Update()
    {
        if (++age >= lifeCycle) {
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
        var forward = player.transform.forward.normalized;
        delta = forward * -0.5f;
        gameObject.transform.position = player.transform.position - delta * (lifeCycle / 2);   
    }
}
