using System.Text.RegularExpressions;
using Godot;

namespace GameProject
{
    [Tool]
    public partial class SpawnPointVisualizer : Node2D
    {
        private string _className = "";
        private readonly string _pattern = @"(?<=\/)[^\/\n]+(?=\.cs$)";


        public override void _Ready()
        {
            if (!Engine.IsEditorHint()) { QueueFree(); return; }
        }

        public override void _Process(double delta)
        {
            if (Engine.IsEditorHint())
            {
                UpdateClassName();
                QueueRedraw();
            }
        }

        private void UpdateClassName()
        {
            var parent = GetParent();
            if (parent == null) return;

            Variant dataVariant = parent.Get("Data");

            if (dataVariant.Obj is GodotObject dataObj)
            {
                var script = dataObj.GetScript().As<CSharpScript>();
                if (script != null)
                {
                    string scriptPath = script.ResourcePath;
                    string newName = Regex.Match(scriptPath, this._pattern).Value;

                    if (this._className != newName)
                    {
                        this._className = newName;
                    }
                }
            }
            else
            {
                this._className = "";
            }
        }


        public override void _Draw()
        {
            //Label l = new() { Text = this._className }; AddChild(l);

            DrawString(
                ThemeDB.FallbackFont,
                new Vector2(-60, -20),
                this._className,
                HorizontalAlignment.Center,
                -1,
                14,
                Colors.Yellow
            );

            DrawCircle(Vector2.Zero, 20f, Colors.Cyan, filled: false);
        }
    }
}