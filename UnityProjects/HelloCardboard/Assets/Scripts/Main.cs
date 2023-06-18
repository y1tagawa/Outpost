using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Main : MonoBehaviour
{
    const int maxCount = 10;
    const int interval = 60 / 5;

    public GameObject projectile;

    private List<GameObject> instances = new();
    private int countDown = 0;

    void Start()
    {
        //
    }

    void Update()
    {
        if (instances.Count < maxCount)
        {
            if (countDown <= 0)
            {
                instances.Add(Instantiate(projectile));
                countDown = interval;
            } 
            else
            {
                --countDown;
            }
        }
    }
}
