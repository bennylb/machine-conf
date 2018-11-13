;;; ~/doom.d/autoload.el -*- lexical-binding: t; -*-

;;;###autoload
(defun +my/counsel-rg-directory (&optional directory)
  "Recursively ripgrep arbitrary directories."
  (interactive "D")
  (counsel-rg nil directory nil nil))

;;;###autoload
(defun +my/switch-to-other-buffer()
  "Switch to other buffer toggle."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))
