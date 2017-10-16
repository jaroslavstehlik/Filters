using UnityEngine;
using UnityEditor;

public class FiltersOutlineEditor : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI(materialEditor, properties);        
        OnKeywordGUI(materialEditor, "GRAYSCALE", "grayscale");
        OnKeywordGUI(materialEditor, "HIGH", "All Directions");
    }

    void OnKeywordGUI(MaterialEditor materialEditor, string keyword, string label)
    {
        EditorGUI.BeginChangeCheck();
        Material targetMaterial = materialEditor.target as Material;
        bool keywordEnabled = EditorGUILayout.Toggle(label, targetMaterial.IsKeywordEnabled(keyword));
        if (EditorGUI.EndChangeCheck())
        {            
            if (keywordEnabled)
            {
                targetMaterial.EnableKeyword(keyword);
            }
            else
            {
                targetMaterial.DisableKeyword(keyword);
            }
        }
    }
}
