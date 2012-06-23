(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(evil
    evil-leader
    textmate
    sr-speedbar
    rainbow-delimiters
    paredit
    starter-kit
    starter-kit-lisp
    starter-kit-bindings))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-user-dir "~/.emacs.d/elpa")
