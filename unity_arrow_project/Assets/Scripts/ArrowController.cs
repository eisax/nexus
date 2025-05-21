using UnityEngine;

public class ArrowController : MonoBehaviour
{
    private float targetRotation = 0f;
    private float rotationSpeed = 5f;
    private bool isRotating = false;

    void Update()
    {
        if (isRotating)
        {
            // Smoothly rotate towards target rotation
            transform.rotation = Quaternion.Slerp(
                transform.rotation,
                Quaternion.Euler(0, targetRotation, 0),
                Time.deltaTime * rotationSpeed
            );

            // Check if we're close enough to target rotation
            if (Quaternion.Angle(transform.rotation, Quaternion.Euler(0, targetRotation, 0)) < 0.1f)
            {
                isRotating = false;
            }
        }
    }

    public void UpdateRotation(string rotationStr)
    {
        if (float.TryParse(rotationStr, out float rotation))
        {
            // Convert from radians to degrees and adjust for Unity's coordinate system
            targetRotation = rotation * Mathf.Rad2Deg;
            isRotating = true;
        }
    }

    public void SetColor(string colorStr)
    {
        // Parse color string (format: "r,g,b,a")
        string[] colorValues = colorStr.Split(',');
        if (colorValues.Length == 4)
        {
            float r = float.Parse(colorValues[0]);
            float g = float.Parse(colorValues[1]);
            float b = float.Parse(colorValues[2]);
            float a = float.Parse(colorValues[3]);

            // Apply color to the arrow material
            Renderer renderer = GetComponent<Renderer>();
            if (renderer != null)
            {
                renderer.material.color = new Color(r, g, b, a);
            }
        }
    }
} 