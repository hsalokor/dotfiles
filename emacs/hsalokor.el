(set-default-font "Menlo-15")
(load-theme 'deeper-blue)
(tool-bar-mode -1)

(add-to-list 'load-path "~/.cabal/share/ghc-mod-1.10.15/")
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda () (ghc-init) (flymake-mode)))

; Mac brace fix
(setq default-input-method "MacOSX")
(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'none)

(require 'evil)
(require 'sr-speedbar)

; Evil mode
(evil-mode 1)

