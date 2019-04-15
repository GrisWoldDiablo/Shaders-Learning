using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovePlayer : MonoBehaviour
{
    public float speed = 2;

    // Update is called once per frame
    void Update()
    {

        float newSpeed = speed;
        if (Input.GetKey(KeyCode.LeftShift))
        {
            newSpeed = speed * 2;
        }
        float posX = Input.GetAxis("Horizontal") * Time.deltaTime * newSpeed;
        float posZ = Input.GetAxis("Vertical") * Time.deltaTime * newSpeed;
        //this.transform.position = new Vector3(transform.position.x + posX, transform.position.y, transform.position.z + posZ);

        this.transform.position += this.transform.right * posX;
        this.transform.position += this.transform.forward * posZ;


        if (Input.GetButton("Jump"))
        {
            this.transform.position += Vector3.up * newSpeed * Time.deltaTime;
        }

        if (Input.GetButton("Crouch"))
        {
            this.transform.position += -Vector3.up * newSpeed * Time.deltaTime;
        }

        float xDir = Input.GetAxis("Mouse X");
        float yDir = Input.GetAxis("Mouse Y");


        transform.Rotate(-yDir, xDir, 0.0f);
        transform.rotation = Quaternion.Euler(transform.rotation.eulerAngles.x, transform.rotation.eulerAngles.y, 0.0f);


    }
}
