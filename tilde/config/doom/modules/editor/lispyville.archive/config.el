
(def-package! lispy
  :defer t
  :hook (emacs-lisp-mode . lispy-mode))

(def-package! lispyville
  :defer t
  :hook (lispy-mode . lispyville-mode)
  :when (featurep! :feature evil)
  :init
  (setq lispyville-key-theme
	'(operators
	   c-w
	   prettify
	   text-objects
	   ;; atom-motions
	   additional-motions
	   slurp/barf-cp
	   slurp/barf-lispy
	   additional-insert
	   additional-wrap
	   wrap
	   mark-toggle))
  :config
  ;;(push 'emacs-lisp-mode evil-escape-excluded-major-modes)
  )
