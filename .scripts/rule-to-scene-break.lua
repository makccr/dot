-- A function to print HorizontalRule's in Markdown as Scene breaks when exporting to .odt or .docx
function HorizontalRule()
    -- convert HR to #
    local para = pandoc.Para({pandoc.Str("#")})
    -- apple "SceneBreak" style to the hash
    return pandoc.Div({para}, pandoc.Attr("", {}, {["custom-style"]="SceneBreak"}))
end
