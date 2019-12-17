"
  " ____                                 ____
 " / ___|_   _ _ __ ___  _ __ ___  _   _| __ )  ___  __ _ _ __ ___
" | |  _| | | | '_ ` _ \| '_ ` _ \| | | |  _ \ / _ \/ _` | '__/ __|
" | |_| | |_| | | | | | | | | | | | |_| | |_) |  __/ (_| | |  \__ \
 " \____|\__,_|_| |_| |_|_| |_| |_|\__, |____/ \___|\__,_|_|  |___/
  "                                |___/
" By: Jose Elera Campana - https://github.com/jelera
" Based: on jellybeans.vim and ir_black
"
" Support for 256 Color Terminal and Full Color graphical Vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ********************************************************************************
" Standard colors
" Note, x:x:x are RGB values
"
"  normal: #f6f3e8
"
"  string: #A8FF60  168:255:96
"    string inner (punc, code, etc): #00A0A0  0:160:160
"  number: #FF73FD  255:115:253
"  comments: #7C7C7C  124:124:124
"  keywords: #96CBFE  150:203:254
"  operators: white
"  class: #FFFFB6  255:255:182
"  method declaration name: #FFD2A7  255:210:167
"  regular expression: #E9C062  233:192:98
"    regexp alternate: #FF8000  255:128:0
"    regexp alternate 2: #B18A3D  177:138:61
"  variable: #C6C5FE  198:197:254
"
" Misc colors:
"  red color (used for whatever): #FF6C60   255:108:96
"     light red: #FFB6B0   255:182:176
"
"  brown: #E18964  good for special
"
"  lightpurpleish: #FFCCFF
"
" Interface colors:
"  background color: black
"  cursor (where underscore is used): #FFA560  255:165:96
"  cursor (where block is used): white
"  visual selection: #1D1E2C
"  current line: #151515  21:21:21
"  search selection: #07281C  7:40:28
"  line number: #3D3D3D  61:61:61


" ********************************************************************************
" The following are the preferred 16 colors for your terminal
"           Colors      Bright Colors
" Black     #4E4E4E     #7C7C7C
" Red       #FF6C60     #FFB6B0
" Green     #A8FF60     #CEFFAB
" Yellow    #FFFFB6     #FFFFCB
" Blue      #96CBFE     #FFFFCB
" Magenta   #FF73FD     #FF9CFE
" Cyan      #C6C5FE     #DFDFFE
" White     #EEEEEE     #FFFFFF


" ********************************************************************************

if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

let g:colors_name = "gummybears"

if !has("gui_running") && &t_Co != 88 && &t_Co != 256
	finish
endif


"hi Example         guifg=NONE        guibg=NONE        gui=NONE      ctermfg=NONE        ctermbg=NONE        cterm=NONE

" General colors
hi  Normal       guifg=#ababa4 guibg=#0d0c0d gui=NONE      ctermfg=251   ctermbg=233  cterm=NONE
hi  NonText      guifg=#a800a8 guibg=#000000 gui=NONE      ctermfg=206   ctermbg=0    cterm=NONE

hi  Cursor       guifg=#000000 guibg=#f0f000 gui=NONE      ctermfg=0     ctermbg=11   cterm=reverse
hi  LineNr       guifg=#3D3D3D guibg=#000000 gui=NONE      ctermfg=237   ctermbg=0    cterm=NONE

hi  VertSplit    guifg=#202020 guibg=#202020 gui=NONE      ctermfg=234   ctermbg=234  cterm=NONE
hi  StatusLine   guifg=#9cffd3 guibg=#202020 gui=NONE      ctermfg=85    ctermbg=234  cterm=NONE
hi  StatusLineNC guifg=#000000 guibg=#202020 gui=bold      ctermfg=0     ctermbg=234  cterm=BOLD

hi  FoldColumn   guifg=#a0a8b0 guibg=#384048 gui=NONE      ctermfg=248   ctermbg=238  cterm=NONE
hi  Folded       guifg=#a0a8b0 guibg=#384048 gui=NONE      ctermfg=248   ctermbg=238  cterm=NONE

hi  Title        guifg=#498994 guibg=NONE    gui=BOLD,ITALIC      ctermfg=68     ctermbg=NONE cterm=BOLD
hi  Visual       guifg=NONE    guibg=#262D51 gui=NONE      ctermfg=NONE  ctermbg=237  cterm=NONE

hi  SpecialKey   guifg=#505050 guibg=#000000 gui=NONE      ctermfg=239   ctermbg=0    term=NONE

hi  WildMenu     guifg=#28882c guibg=#f0f000 gui=NONE      ctermfg=28    ctermbg=11   cterm=NONE
hi  PmenuSbar    guifg=#000000 guibg=#ffffff gui=NONE      ctermfg=0     ctermbg=15   cterm=NONE

hi  Error        guifg=NONE    guibg=NONE    gui=UNDERCURL guisp=#FF6C60 ctermfg=15   ctermbg=88    cterm=NONE
hi  ErrorMsg     guifg=#e8e8d3 guibg=#902020  gui=BOLD      ctermfg=15    ctermbg=203  cterm=BOLD
hi  WarningMsg   guifg=#ffffff guibg=#ff8cc2  gui=BOLD      ctermfg=15    ctermbg=203  cterm=BOLD

" Message displayed in lower left, such as --INSERT--
hi ModeMsg       guifg=#000000  guibg=#C6C5FE gui=BOLD     ctermfg=0 ctermbg=189 cterm=BOLD

if version >= 700 " Vim 7.x specific colors
  hi CursorLine   guifg=NONE    guibg=#000000 gui=NONE      ctermfg=NONE ctermbg=16  cterm=NONE
  hi CursorColumn guifg=NONE    guibg=#121212 gui=NONE      ctermfg=NONE ctermbg=233 cterm=BOLD
  hi MatchParen   guifg=#f6f3e8 guibg=#857b6f gui=BOLD      ctermfg=7    ctermbg=243 cterm=BOLD
  hi Pmenu        guifg=#f6f3e8 guibg=#444444 gui=NONE      ctermfg=7    ctermbg=238 cterm=NONE
  hi PmenuSel     guifg=#000000 guibg=#cae682 gui=NONE      ctermfg=0    ctermbg=186 cterm=NONE
  hi Search       guifg=#f0a0c0 guibg=#302028 gui=UNDERLINE ctermfg=176  ctermbg=53  cterm=underline
endif

hi IncSearch      guifg=#101314 guibg=#21d0eb gui=NONE   ctermfg=234 ctermbg=6 cterm=NONE

" Syntax highlighting
hi Comment     guifg=#585858 guibg=NONE    gui=ITALIC   ctermfg=240   ctermbg=NONE cterm=NONE
hi String      guifg=#9fba4d guibg=NONE    gui=NONE   ctermfg=143 ctermbg=NONE cterm=NONE
hi Number      guifg=#cf6a4c guibg=NONE    gui=NONE   ctermfg=130 ctermbg=NONE cterm=NONE

hi Keyword     guifg=#ffb964 guibg=NONE    gui=ITALIC   ctermfg=214 ctermbg=NONE cterm=BOLD
hi PreProc     guifg=#2688bd guibg=NONE    gui=BOLD   ctermfg=75 ctermbg=NONE cterm=BOLD
hi Conditional guifg=#ffb964 guibg=NONE    gui=NONE   ctermfg=214  ctermbg=NONE cterm=NONE

hi Todo        guifg=#a1178a guibg=#e8db27 gui=BOLD,UNDERLINE   ctermfg=89  ctermbg=227  cterm=BOLD
hi Constant    guifg=#de5833 guibg=NONE    gui=BOLD,ITALIC ctermfg=130 ctermbg=NONE cterm=BOLD

hi Identifier  guifg=#7e749c guibg=NONE    gui=NONE   ctermfg=104 ctermbg=NONE cterm=NONE
hi Function    guifg=#edbf62 guibg=NONE    gui=BOLD   ctermfg=172 ctermbg=NONE cterm=BOLD
hi Type        guifg=#b86e1e guibg=NONE    gui=BOLD,ITALIC   ctermfg=172 ctermbg=NONE cterm=BOLD
hi Statement   guifg=#6894de guibg=NONE    gui=ITALIC   ctermfg=75 ctermbg=NONE cterm=NONE

hi Special     guifg=#458c27 guibg=NONE    gui=NONE   ctermfg=31 ctermbg=NONE cterm=NONE
hi Delimiter   guifg=#668799 guibg=NONE    gui=NONE   ctermfg=74  ctermbg=NONE cterm=NONE
hi Operator    guifg=#6ab6ba guibg=NONE    gui=NONE   ctermfg=44 ctermbg=NONE cterm=NONE

" VimDiff colors
hi DiffAdd     guifg=#fcfcfc guibg=#034a08    gui=NONE   ctermfg=250 ctermbg=22 cterm=NONE
hi DiffChange  guifg=#e8e8d3 guibg=#65337a    gui=ITALIC   ctermfg=250 ctermbg=93 cterm=NONE
hi DiffDelete  guifg=#ff0000 guibg=#330000    gui=NONE   ctermfg=1 ctermbg=88 cterm=NONE
hi DiffText    guifg=#000000 guibg=#b84fb8    gui=BOLD   ctermfg=232 ctermbg=207 cterm=BOLD

hi Character   guifg=#cf6a4c guibg=NONE    gui=NONE   ctermfg=209 ctermbg=NONE cterm=NONE
hi Boolean     guifg=#8197bf guibg=NONE    gui=NONE   ctermfg=75 ctermbg=NONE cterm=NONE
hi Repeat      guifg=#ffb964 guibg=NONE    gui=NONE   ctermfg=166 ctermbg=NONE cterm=NONE
hi Exception   guifg=#d75faf guibg=NONE    gui=NONE   ctermfg=133 ctermbg=NONE cterm=NONE
hi Include     guifg=#8fbfdc guibg=NONE    gui=NONE   ctermfg=75 ctermbg=NONE cterm=NONE
hi StorageClass guifg=#c59f6f guibg=NONE    gui=NONE   ctermfg=173 ctermbg=NONE cterm=NONE
hi Tag         guifg=#799d6a guibg=NONE    gui=NONE   ctermfg=77 ctermbg=NONE cterm=NONE
hi Ignore      guifg=#e2e4e5 guibg=NONE    gui=NONE   ctermfg=250 ctermbg=NONE cterm=NONE

hi Directory       guifg=#dad085 guibg=NONE    gui=NONE   ctermfg=221 ctermbg=NONE cterm=NONE
hi LocalVariable   guifg=#663d7a guibg=NONE    gui=NONE   ctermfg=96 ctermbg=NONE cterm=NONE
hi Question        guifg=#59aba7 guibg=NONE    gui=NONE   ctermfg=44 ctermbg=NONE cterm=NONE

hi link Float           Number
hi link Label           Repeat
hi link Typedef         Repeat
hi link Define          Include
hi link Macro           Include
hi link PreCondit       Include
hi link Structure       Include
hi link SpecialChar     Tag
hi link SpecialComment  Tag
hi link Debug           Tag
hi link CTagsClass      Ignore
hi link CTagsGlobalConstant   Ignore
hi link CTagsGlobalVariable   Ignore
hi link CTagsImport   Ignore
hi link CTagsMember   Ignore
hi link DefinedName   Ignore
hi link EnumerationName   Ignore
hi link EnumerationValue   Ignore
hi link MoreMsg   Ignore
hi link Union   Ignore
hi link VisualNOS   Ignore
hi link phpStringDouble Ignore


" Special for Ruby
hi  rubyRegexp                 guifg=#B18A3D guibg=NONE gui=NONE ctermfg=137 ctermbg=NONE cterm=NONE
hi  rubyRegexpDelimiter        guifg=#FF8000 guibg=NONE gui=NONE ctermfg=208 ctermbg=NONE cterm=NONE
hi  rubyEscape                 guifg=#ffffff guibg=NONE gui=NONE ctermfg=15  ctermbg=NONE cterm=NONE
hi  rubyInterpolationDelimiter guifg=#00A0A0 guibg=NONE gui=NONE ctermfg=37  ctermbg=NONE cterm=NONE
hi  rubyControl                guifg=#6699CC guibg=NONE gui=NONE ctermfg=68  ctermbg=NONE cterm=NONE
"hi rubyGlobalVariable         guifg=#FFCCFF guibg=NONE gui=NONE ctermfg=225 ctermbg=NONE cterm=NONE
hi  rubyStringDelimiter        guifg=#336633 guibg=NONE gui=NONE ctermfg=238 ctermbg=NONE cterm=NONE
"rubyInclude
"rubySharpBang
"rubyAccess
"rubyPredefinedVariable
"rubyBoolean
"rubyClassVariable
"rubyBeginEnd
"rubyRepeatModifier
"hi link rubyArrayDelimiter    Special  " [ , , ]
"rubyCurlyBlock  { , , }

hi link rubyClass             Keyword
hi link rubyModule            Keyword
hi link rubyKeyword           Keyword
hi link rubyOperator          Operator
hi link rubyIdentifier        Identifier
hi link rubyInstanceVariable  Identifier
hi link rubyGlobalVariable    Identifier
hi link rubyClassVariable     Identifier
hi link rubyConstant          Type


" Special for Java
" hi link javaClassDecl    Type
hi link javaScopeDecl         Identifier
hi link javaCommentTitle      javaDocSeeTag
hi link javaDocTags           javaDocSeeTag
hi link javaDocParam          javaDocSeeTag
hi link javaDocSeeTagParam    javaDocSeeTag

hi  javaDocSeeTag guifg=#CCCCCC guibg=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
"hi javaClassDecl guifg=#CCFFCC guibg=NONE gui=NONE ctermfg=194 ctermbg=NONE cterm=NONE


" Special for HTML
hi htmlH1        guifg=#22aba4 guibg=NONE gui=UNDERLINE ctermfg=38  ctermbg=NONE cterm=BOLD
hi htmlLink      guifg=#c777ff guibg=NONE gui=NONE      ctermfg=171 ctermbg=NONE cterm=BOLD
hi htmlString    guifg=#799668 guibg=NONE gui=NONE      ctermfg=100 ctermbg=NONE cterm=NONE
hi htmlTagName   guifg=#b097b0 guibg=NONE gui=NONE      ctermfg=175 ctermbg=NONE cterm=NONE
hi link htmlTag         Keyword
hi link htmlEndTag      Identifier
hi link htmlH2 htmlH1
hi link htmlH3 htmlH1
hi link htmlH4 htmlH1

" Special for Javascript
hi link javaScriptBrowserObjects htmlString
hi link javaScriptDOMObjects     htmlString

" Special for XML
hi link xmlTag          Keyword
hi link xmlTagName      htmlTagName
hi link xmlEndTag       Identifier


" Special for CSS
hi cssTagName guifg=#70a8dd gui=BOLD  ctermfg=74 cterm=BOLD
hi cssBoxProp guifg=#d0af76  gui=NONE  ctermfg=180 gui=NONE
hi link cssColorProp cssBoxProp
hi link cssFontProp cssBoxProp
hi link cssTextProp cssBoxProp
hi cssPseudoClassId guifg=#9ccfdd gui=italic ctermfg=152 cterm=NONE
hi cssIdentifier    guifg=#3fc493 gui=italic ctermfg=115 cterm=NONE

" Special for Markdown
hi link markdownUrl    htmlLink
hi markdownCode      guibg=#3a3a3a guifg=#a7bee4 gui=BOLD ctermbg=237 ctermfg=152 cterm=BOLD
hi markdownCodeBlock guifg=#c5b1e4 ctermfg=182
hi markdownLinkText  guifg=#0087ff ctermfg=33

hi markdownH1        guifg=#00af87 guibg=NONE gui=BOLD,ITALIC,UNDERLINE ctermfg=36  ctermbg=NONE cterm=BOLD
hi markdownH2        guifg=#22aba4 guibg=NONE gui=BOLD,UNDERLINE ctermfg=38  ctermbg=NONE cterm=BOLD
hi markdownH3        guifg=#00d7af guibg=NONE gui=ITALIC,UNDERLINE ctermfg=43  ctermbg=NONE cterm=BOLD

hi markdownBold    guifg=#878700 guibg=NONE gui=BOLD      ctermfg=100 ctermbg=NONE cterm=BOLD
hi markdownItalic    guifg=#af8700 guibg=NONE gui=ITALIC      ctermfg=130 ctermbg=NONE cterm=NONE

hi markdownOrderedListMarker  guifg=#5fff00  gui=BOLD ctermfg=82 cterm=BOLD
hi markdownListMarker  guifg=#ffff00  gui=BOLD ctermfg=226 cterm=BOLD

hi markdownBlockQuote   guifg=#00ffff gui=BOLD ctermfg=14 cterm=BOLD

" Special for Javascript
hi JavaScriptStrings          guifg=#26b3ac guibg=NONE gui=ITALIC ctermfg=45  ctermbg=NONE  cterm=NONE
hi link javaScriptNumber      Number

" Special for Python
"hi  link pythonEscape         Keyword
hi pythonBuiltin          guifg=#50bf95 guibg=NONE  gui=ITALIC ctermfg=42  cterm=UNDERLINE


" Special for CSharp
hi  link csXmlTag             Keyword

" Special for PHP
hi phpDefine  guifg=#ffc795    gui=BOLD ctermfg=209 cterm=BOLD
hi phpStringSingle  guifg=#e8e8d3 guibg=NONE gui=NONE ctermfg=250 ctermbg=NONE  cterm=NONE
