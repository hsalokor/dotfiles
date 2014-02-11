(require 'evil)
(require 'rainbow-delimiters)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; Evil mode
(evil-mode 1)
(setq evil-default-cursor t) 

;; Line numbers
(global-linum-mode t)

;; Mac fixes
(if (eq system-type 'darwin)
    (progn
      (set-face-attribute 'default nil
                          :family "Monaco"
                          :height 140
                          :weight 'normal)
      (setq mac-option-key-is-meta t)
      (setq mac-right-option-modifier nil)))

;; Linux setup
(if (eq system-type 'unix)
    (progn
      (set-face-attribute 'default nil
                          :family "Ubuntu Mono"
                          :height 120
                          :weight 'normal)))

;; Fix lisp indent
(setq indent-tabs-mode nil)
(setq tab-width 2)

;; Fix mouse scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;;; scroll window under mouse
(setq scroll-step 1) ;;; keyboard scroll one line at a time

;; Add lein to path
(setenv "PATH" (concat "~/bin:" (getenv "PATH")))

;; Autocomplete mode
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(ac-config-default)

;; Add haskell source for autocomplete
(if (and (file-accessible-directory-p "~/.cabal/share/")
         (file-accessible-directory-p "~/.cabal/bin/"))
    (require 'haskell-autocomplete)
    ;; Autoload ghc-mode
    (add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))
    (autoload 'ghc-init "ghc" nil t)
    (add-hook 'haskell-mode-hook (lambda () (ghc-init)))
    (add-hook 'haskell-mode-hook (lambda () (turn-on-haskell-indentation)))
    (add-to-list 'ac-sources 'ac-source-ghc-mod))

;; Clang autocomplete
(require 'auto-complete-clang-async)

(defun ac-cc-mode-setup ()
  (setq ac-clang-complete-executable "~/.emacs.d/clang-complete")
  (setq ac-sources '(ac-source-clang-async))
  (ac-clang-launch-completion-process))

(defun clang-ac-config ()
  (add-hook 'c-mode-common-hook 'ac-cc-mode-setup))

(clang-ac-config)

;; Cider config
(add-to-list 'evil-emacs-state-modes 'cider-repl-mode)
(add-hook 'clojure-mode (define-key evil-normal-state-map "\M-." 'cider-jump))
(add-hook 'cider-interaction-mode-hook 'cider-turn-on-eldoc-mode)
(setq cider-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "*cider*") 

;; Cider autocomplete using ac-nrepl
(require 'clojure-autocomplete)

(if window-system
  (progn (color-theme-sanityinc-tomorrow-night)
         (tool-bar-mode -1))
  (progn (load-theme 'tango-dark)))

;; Enable global autorevert
(global-auto-revert-mode)

;; Disable italics
(mapc
 (lambda (face) (set-face-attribute face nil :weight 'normal :italic nil))
 (face-list))

(require 'ag)

;; Fix indents
(setq-default tab-width 2)
(setq-default js-indent-level 2)

;; Go autocomplete
(require 'go-autocomplete)
(require 'auto-complete-config)

;; helm
(require 'helm-config)
(setq enable-recursive-minibuffers t)
(helm-mode 1)
(helm-gtags-mode 1)
(helm-descbinds-mode)
(setq helm-idle-delay 0.1)
(setq helm-input-idle-delay 0.1)
(setq helm-buffer-max-length 50)
(setq helm-M-x-always-save-history t)
(setq helm-buffer-details-flag nil)
(setq helm-ff-tramp-not-fancy nil)
(setq helm-for-files-preferred-list
      '(helm-source-buffers-list
        helm-source-recentf
        helm-source-bookmarks
        helm-source-file-cache
        helm-source-files-in-current-dir
	helm-source-locate))
(add-to-list 'helm-completing-read-handlers-alist '(org-refile)) ; helm-mode does not do org-refile well
(require 'helm-git)

(setq highlight-symbol-on-navigation-p t)
(setq highlight-symbol-idle-delay 0.2)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)

(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
