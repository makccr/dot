-- A function to print HorizontalRule's in Markdown as Scene breaks when exporting to .odt or .docx
function HorizontalRule()
    return pandoc.Para({pandoc.Str("#")}, {class="SceneBreak"})
end
