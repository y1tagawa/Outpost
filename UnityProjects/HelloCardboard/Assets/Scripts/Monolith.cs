using System;
using UnityEngine;

public class Monolith : MonoBehaviour
{
    public Vector3 startPosition;
    public Vector3 endPosition;
    public DateTime startTime;
    public DateTime endTime;

    // Start is called before the first frame update
    void Start()
    {
        //
    }

    // Update is called once per frame
    void Update()
    {
        //var now = DateTime.Now;
        //if (now >= endTime)
        //{
        //    Destroy(gameObject);
        //}
        //var t = (float)((now - startTime).TotalMilliseconds / (endTime - startTime).TotalMilliseconds);
        //gameObject.transform.position = t * (endPosition - startPosition) + startPosition;
    }
}
