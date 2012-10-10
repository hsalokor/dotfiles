;(set-default-font "Menlo-15")
(load-theme 'deeper-blue)
(tool-bar-mode -1)

(require 'evil)
(require 'sr-speedbar)
(require 'rainbow-delimiters)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

(if (eq system-type 'darwin)
  (setq mac-option-key-is-meta t)
  (setq mac-right-option-modifier nil))

; Evil mode
(evil-mode 1)

; Fix lisp indent
(setq indent-tabs-mode nil)
(setq tab-width 2)

; Autoload ghc-mode
;(autoload 'ghc-init "ghc" nil t)
;(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))
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
