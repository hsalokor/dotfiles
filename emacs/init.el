(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

(if (and (file-accessible-directory-p "~/.cabal/share/")
         (file-accessible-directory-p "~/.cabal/bin/"))
    (add-to-list 'load-path (car (directory-files "~/.cabal/share/" t "ghc-mod-.*")))
    (add-to-list 'exec-path "~/.cabal/bin/"))

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'exec-path "/usr/local/bin/")

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(evil
    evil-leader
    textmate
    paredit
    auto-complete
    rainbow-delimiters

    clojure-mode
    haskell-mode
    flymake-css
    flymake-shell
    less-css-mode

    ag
    cider
    ac-nrepl
    geiser
    color-theme-sanityinc-solarized
    color-theme-sanityinc-tomorrow

    starter-kit
    starter-kit-lisp
    starter-kit-bindings))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-user-dir "~/.emacs.d/elpa")
(setq auto-mode-alist (cons '("\\.cljs" . clojure-mode) auto-mode-alist))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-tomorrow-night)))
 '(custom-safe-themes (quote ("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(virtualenv-root "~/src/qvantel/"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
