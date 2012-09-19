(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'package)
(add-to-list 'package-archives
    '("melpa" . "http://melpa.milkbox.net/packages/") t)
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
    clojure-mode
    haskell-mode
    nrepl
    starter-kit
    starter-kit-lisp
    starter-kit-bindings))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-user-dir "~/.emacs.d/elpa")
(setq auto-mode-alist (cons '("\\.cljs" . clojure-mode) auto-mode-alist))
