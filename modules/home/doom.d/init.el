;;; init.el -*- lexical-binding: t; -*-

(doom!
 :completion
 company
 vertico

 :ui
 doom
 doom-dashboard
 hl-todo
 modeline
 ophints
 (popup +defaults)
 treemacs
 vc-gutter
 vi-tilde-fringe
 window-select
 workspaces

 :editor
 (evil +everywhere)
 file-templates
 fold
 snippets

 :emacs
 dired
 electric
 undo
 vc

 :term
 vterm

 :checkers
 syntax

 :tools
 (eval +overlay)
 lookup
 lsp
 magit
 tree-sitter

 :lang
 (cc +lsp)
 (csharp +lsp)
 emacs-lisp
 (go +lsp)
 json
 (lua +lsp)
 markdown
 nix
 org
 (python +lsp)
 (rust +lsp)
 sh
 yaml

 :config
 (default +bindings +smartparens))
