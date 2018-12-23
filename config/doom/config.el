;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

(let* ((font-size (cond ((string= system-name "station") 13)
                        ((string= system-name "sputnik") 15))))
  (setq doom-font (font-spec :family "Source Code Pro" :size font-size)))

;; (setq ivy-re-builders-alist
;;         '((counsel-ag . ivy--regex-plus)
;;           (counsel-grep . ivy--regex-plus)
;;           (counsel-rg . ivy--regex-plus)
;;           (swiper . ivy--regex-plus)
;;           ;; (t . ivy--regex-ignore-order)
;;           (t . ivy--regex-plus)
;;           )
;;         ivy-initial-inputs-alist nil)

;; (def-package! auth-source-pass
;;   :after auth-source
;;   :config (auth-source-pass-enable))
(after! auth-source
  (auth-source-pass-enable))

(after! org
  (setq org-directory "~/org/")
  (add-to-list 'org-capture-templates
               '("w" "Web bookmark" entry (file "Bookmarks.org")
                 "* %a\n%U" :jump-to-captured t))
  (setq org-refile-targets
        (mapcar
         (lambda (org-dir-file)
           (cons org-dir-file (cons ':maxlevel '9)))
         (directory-files org-directory nil "\\(\/\|\w\\)*\.org$" nil)))
  (setq org-refile-allow-creating-parent-nodes 'confirm)
  (setq org-refile-use-outline-path 'file)
  (setq org-protocol-default-template-key "w")
  (setq org-outline-path-complete-in-steps nil))

(after! epa
  (setq epa-pinentry-mode 'ask))

(after! helpful
  (setq helpful-max-buffers 1))

(after! magit
  (setq magit-repository-directories
        '(
          ("~/.emacs.d" . 0)
          ("~/src/git" . 1)
          ("~/src/twincam-web-store" . 1)
          ("~/machine-conf" . 1)
          )))

(after! company
  (setq ispell-alternate-dictionary
        (expand-file-name "~/.local/share/british-words.txt" )))

(set-irc-server!
 "Freenode"
 '(:host "chat.freenode.net"
   :tls t
   :port (6697 . 6697)
   :nick "bennylb"
   :sasl-username ,(+pass-get-user "irc.freenode.net")
   :sasl-password (lambda (&rest _) (+pass-get-secret "irc.freenode.net"))
   :channels ("#nixos")
   ))

(setq +pretty-code-enabled-modes '(emacs-lisp-mode))

;;(load! "bindings")
