function HorizontalRule()
    local para = pandoc.Para({pandoc.Str("***")})
    return pandoc.Div({para}, pandoc.Attr("", {}, {["custom-style"]="Heading 3"}))
end
