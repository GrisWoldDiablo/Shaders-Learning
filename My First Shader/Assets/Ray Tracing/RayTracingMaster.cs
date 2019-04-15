
using UnityEngine;

public class RayTracingMaster : MonoBehaviour
{
    public ComputeShader RayTracingShader;
    public Texture SkyBoxTexture;
    public Color Specular;
    [Range(2, 8)] public int ReflectionAmount = 2;
    public bool Refresh = false;

    public Light DirectionalLight;

    private RenderTexture _target;

    private Camera _camera;

    private uint _currentSample = 0;
    private Material _addMaterial;


    private void Awake()
    {
        _camera = GetComponent<Camera>();
    }

    private void Update()
    {
        if (transform.hasChanged || Refresh || DirectionalLight.transform.hasChanged)
        {
            _currentSample = 0;
            transform.hasChanged = false;
            Refresh = false;
        }
    }

    private void SetShaderParameters()
    {
        RayTracingShader.SetMatrix("_CameraToWorld", _camera.cameraToWorldMatrix);
        RayTracingShader.SetMatrix("_CameraInverseProjection", _camera.projectionMatrix.inverse);
        RayTracingShader.SetTexture(0, "_SkyboxTexture", SkyBoxTexture);
        RayTracingShader.SetVector("_PixelOffset", new Vector2(Random.value, Random.value));
        RayTracingShader.SetVector("_specular", new Vector3(Specular.linear.r,Specular.linear.g,Specular.linear.b));
        RayTracingShader.SetInt("_ReflectionAmount", ReflectionAmount);

        Vector3 l = DirectionalLight.transform.forward;
        RayTracingShader.SetVector("_DirectionalLight", new Vector4(l.x, l.y, l.z, DirectionalLight.intensity));
        RayTracingShader.SetVector("_LightAlbedo", new Vector3(DirectionalLight.color.linear.r,
                                                               DirectionalLight.color.linear.g,
                                                               DirectionalLight.color.linear.b));
        RayTracingShader.SetFloat("_Time", Time.time);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        SetShaderParameters();
        Render(destination);
    }

    private void Render(RenderTexture destination)
    {
        //Make sure we have a current render target
        InitRenderTexture();

        // Set the target and dispatch the compute shader
        RayTracingShader.SetTexture(RayTracingShader.FindKernel("CSMain"), "Result", _target);
        int threadGroupsX = Mathf.CeilToInt(Screen.width / 8.0f);
        int threadGroupsY = Mathf.CeilToInt(Screen.height / 8.0f);
        RayTracingShader.Dispatch(0, threadGroupsX, threadGroupsY, 1);

        // Blit the result texture to the screen
        if (_addMaterial == null)
        {
            _addMaterial = new Material(Shader.Find("Hidden/AddShader"));
        }
        _addMaterial.SetFloat("_Sample", _currentSample);
        Graphics.Blit(_target, destination, _addMaterial);
        _currentSample++;
    }

    private void InitRenderTexture()
    {
        if (_target == null || _target.width != Screen.width || _target.height != Screen.height)
        {
            //Release render testure if we alWready have one
            if (_target != null)
            {
                _target.Release();
            }
            _currentSample = 0;
            // Get a render target for Ray Tracing
            _target = new RenderTexture(Screen.width, Screen.height, 0, 
                RenderTextureFormat.ARGBFloat, RenderTextureReadWrite.Linear);
            _target.enableRandomWrite = true;
            _target.Create();
        }
    }
}
