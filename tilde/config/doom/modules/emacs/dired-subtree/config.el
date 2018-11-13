;;; emacs/dired-subtree/config.el -*- lexical-binding: t; -*-

(map! :after dired
      :map dired-mode-map
      :n "e" #'dired-subtree-toggle)
