" Vim syntax file
" Language:	Fountain screenplay
" File: .fountain, .spmd, .txt
" Reference: http://fountain.io/
" Maintainer:	Carson Fire <carsonfire@gmail.com>
" Last Change:	February 20, 2012
" Version: 2.02	

if exists("b:current_syntax")
  finish
endif
syn sync minlines=200

syn match fountainSection1 "^\s*# \(\_[^#]\)" fold transparent contains=ALL
syn region fountainTitlePage start="\%^\(.*\):" end="^$" contains=fountainBoneyard,fountainNotes
syn match fountainCharacter "^\(\L\)*$" 
syn region fountainDialogue matchgroup=fountainCharacter start="^\(\L\)*$" end="^\s*$" contains=fountainCharacter,fountainParenthetical,fountainBoneyard,fountainNotes,fountainEmphasis
syn match fountainParenthetical "^\s*\((.*)\)$" contained contains=fountainBoneyard,fountainNotes
syn match fountainTransition "^\(\L\)* TO:$" contains=fountainBoneyard,fountainNotes
syn match fountainTransitionForced "^\s*>\(.*\)" contains=fountainBoneyard,fountainNotes
syn match fountainCentered "^\s*>\(.*\)<" contains=fountainBoneyard,fountainNotes
syn match fountainUnderlined "_[^_]*_" 
syn match fountainItalic "\*[^\*]*\*"
syn match fountainBold "\*\*[^\*]*\*\*"
syn match fountainBoldItalic "\*\*\*[^\*]*\*\*\*" 
syn match fountainPagebreak "^===[=]*$"
syn region fountainNotes start="\[\[" end="\]\]" contains=xLineContinue
syn region fountainHeader1 start="^\s*# " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainHeader2 start="^\s*## " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainHeader3 start="^\s*### " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainHeader4 start="^\s*#### " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainHeader5 start="^\s*##### " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainHeader6 start="^\s*###### " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainSynopses start="^\s*= " end="$" contains=fountainBoneyard,fountainNotes
syn region fountainSceneHeading start="^\s*\(\.\|INT\. \|EXT\. \|INT\./EXT\. \|INT/EXT\. \|INT \|EXT \|INT/EXT \|I/E \|int\. \|ext\. \|int\./ext\. \|int/ext\. \|int \|ext \|int/ext \|i/e \)" end="$" contains=fountainSceneNumber,fountainBoneyard,fountainNotes 
syn region fountainBoneyard start="/\*" end="\*\/" contains=xLineContinue
syn match xLineContinue "\\$" contained
syn region fountainSceneNumber start="#" end="#" contained

hi def link fountainTitlePage		    title
hi def link fountainSceneHeading	    title
hi def link fountainCharacter			identifier 
hi def link fountainDialogue			statement
hi def link fountainParenthetical		function
hi def link fountainTransition			todo
hi def link fountainTransitionForced	todo
hi def link fountainCentered			character
hi fountainUnderlined					gui=underline
hi fountainItalic						gui=italic cterm=italic	
hi fountainBold							gui=bold cterm=bold	
hi fountainBoldItalic					gui=bold,italic cterm=bold,italic	
hi def link fountainPagebreak			conditional
hi def link fountainActionForced		normal
hi def link fountainNotes				comment
hi def link fountainBoneyard			nontext	
hi def link fountainHeader1				htmlH1	
hi def link fountainHeader2				htmlH2	
hi def link fountainHeader3				htmlH3	
hi def link fountainHeader4				htmlH4	
hi def link fountainHeader5				htmlH5	
hi def link fountainHeader6				htmlH6	
hi def link fountainSynopses			number
hi def link fountainSceneNumber			number	

let b:current_syntax = "fountain"
