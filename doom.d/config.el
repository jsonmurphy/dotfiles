(setq doom-theme 'doom-nord)

(setq doom-leader-key ","
      doom-localleader-key "; ;")
(setq evil-escape-key-sequence "ii")
(setq evil-escape-delay 0.2)

(map! :leader "q" 'evil-window-delete)
(map! :leader "Q" 'kill-emacs)
(map! :leader "w" 'save-buffer)
(map! :leader "v" 'vterm)
(map! :leader "e" 'counsel-recentf)

(defun zap-up-to-paren ()
  (interactive)
  (zap-up-to-char 1 (string-to-char ")")))

(map! :after clojure-mode :map clojure-mode-map :localleader :n "x" #'sp-kill-hybrid-sexp)
(map! :after clojure-mode :map clojure-mode-map :localleader :n "s" #'sp-forward-slurp-sexp)
(map! :after clojure-mode :map clojure-mode-map :localleader :n "b" #'sp-forward-barf-sexp)
(evil-define-key 'normal 'global (kbd "|") 'evil-window-vsplit)
(evil-define-key 'normal 'global (kbd "_") 'evil-window-split)
(evil-define-key 'normal 'global (kbd ";h") 'evil-window-left)
(evil-define-key 'normal 'global (kbd ";j") 'evil-window-down)
(evil-define-key 'normal 'global (kbd ";k") 'evil-window-up)
(evil-define-key 'normal 'global (kbd ";l") 'evil-window-right)
