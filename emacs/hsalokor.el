;(set-default-font "Menlo-15")
(load-theme 'deeper-blue)
(tool-bar-mode -1)

(require 'evil)
(require 'sr-speedbar)
(require 'rainbow-delimiters)

(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

; Evil mode
(evil-mode 1)

; Fix lisp indent
(setq indent-tabs-mode nil)
(setq tab-width 2)

; Add lein to path
(setenv "PATH" (concat "/home/hsalokor/bin:" (getenv "PATH")))
