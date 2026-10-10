;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "PyDotDog"
      user-mail-address "palubickimaciej5@gmail.com")

(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 14)
      doom-theme 'doom-one
      display-line-numbers-type 'relative)

(after! lsp-mode
  (setq lsp-enable-symbol-highlighting t
        lsp-headerline-breadcrumb-enable t))
