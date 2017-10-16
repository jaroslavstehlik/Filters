using UnityEngine;
using UnityEditor;

public class FiltersEmbossEditor : ShaderGUI
{
    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {
        base.OnGUI(materialEditor, properties);

        OnKeywordGUI(materialEditor, "HORIZONTAL", "horizontal");
        OnKeywordGUI(materialEditor, "VERTICAL", "vertical");
        OnKeywordGUI(materialEditor, "GRAYSCALE", "grayscale");
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
