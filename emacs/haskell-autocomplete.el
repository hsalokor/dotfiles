(require 'ghc-comp)

(defun haskell-complete ()
  (let* ((end (point))
         (symbols (ghc-select-completion-symbol))
         (beg (ghc-completion-start-point))
         (pattern (buffer-substring-no-properties beg end)))
    (list (sort (all-completions pattern symbols) 'string<))))

(defvar ac-source-ghc-mod
  '((init . ghc-init)
    (candidates . (haskell-complete))))

(provide 'haskell-autocomplete)
