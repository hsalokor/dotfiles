(require 'evil)
(require 'sr-speedbar)
(require 'rainbow-delimiters)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; Evil mode
(evil-mode 1)
(setq evil-default-cursor t) 

; Line numbers
(global-linum-mode t)

; Mac fixes
(if (eq system-type 'darwin)
    (progn
      (set-face-attribute 'default nil
                          :family "ProggySquare"
                          :height 110
                          :weight 'normal)
      (setq mac-option-key-is-meta t)
      (setq mac-right-option-modifier nil)))

; Linux setup
(if (eq system-type 'unix)
    (progn
      (set-face-attribute 'default nil
                          :family "Ubuntu Mono"
                          :height 120
                          :weight 'normal)))

; Fix lisp indent
(setq indent-tabs-mode nil)
(setq tab-width 2)

; Fix mouse scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time

; Autoload ghc-mode
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init)))
(add-hook 'haskell-mode-hook (lambda () (turn-on-haskell-indentation)))

; Add lein to path
(setenv "PATH" (concat "~/bin:" (getenv "PATH")))

; Textmate mode
(textmate-mode)

; Autocomplete mode
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(ac-config-default)

; Add haskell source for autocomplete
(require 'haskell-autocomplete)
(add-to-list 'ac-sources 'ac-source-ghc-mod)

; Nrepl config
(add-to-list 'evil-emacs-state-modes 'nrepl-mode)
(add-hook 'clojure-mode (define-key evil-normal-state-map "\M-." 'nrepl-jump))
(add-hook 'nrepl-interaction-mode-hook 'nrepl-turn-on-eldoc-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "*nrepl*") 

; NRepl autocomplete using ac-nrepl
(require 'clojure-autocomplete)

; Clojure alignment
(require 'align-cljlet)

(if window-system
  (progn (color-theme-sanityinc-tomorrow-night)
         (tool-bar-mode -1))
  (progn (load-theme 'tango-dark)))

; Enable global autorevert
(global-auto-revert-mode)

; Disable italics
(mapc
 (lambda (face) (set-face-attribute face nil :weight 'normal :italic nil))
 (face-list))
