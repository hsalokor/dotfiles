(let ((default-directory "~/.emacs.d/elpa/"))
  (normal-top-level-add-subdirs-to-load-path))

(if (and (file-accessible-directory-p "~/.cabal/share/")
         (file-accessible-directory-p "~/.cabal/bin/"))
    (add-to-list 'load-path (car (directory-files "~/.cabal/share/" t "ghc-mod-.*")))
    (add-to-list 'exec-path "~/.cabal/bin/"))

(add-to-list 'load-path "~/.emacs.d/lisp/")
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

    helm
    helm-c-yasnippet
    helm-descbinds
    helm-git
    helm-gtags
    projectile
    helm-projectile
  
    go-mode

    starter-kit
    starter-kit-lisp
    starter-kit-bindings))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(setq package-user-dir "~/.emacs.d/elpa")
(setq auto-mode-alist (cons '("\\.cljs" . clojure-mode) auto-mode-alist))
