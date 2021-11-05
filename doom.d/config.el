(setq doom-theme 'doom-nord)
(setq debug-on-error t)

(setq doom-leader-key ","
      doom-localleader-key "; ;")
(setq evil-escape-key-sequence "ii")
(setq evil-escape-delay 0.2)

(map! :leader "q" 'evil-window-delete)
(map! :leader "Q" 'kill-emacs)
(map! :leader "w" 'save-buffer)
(map! :leader "v" '+vterm/toggle)
(map! :leader "e" 'counsel-recentf)
(evil-define-key 'normal 'global (kbd "|") 'evil-window-vsplit)
(evil-define-key 'normal 'global (kbd "_") 'evil-window-split)
(evil-define-key 'normal 'global (kbd ";h") 'evil-window-left)
(evil-define-key 'normal 'global (kbd ";j") 'evil-window-down)
(evil-define-key 'normal 'global (kbd ";k") 'evil-window-up)
(evil-define-key 'normal 'global (kbd ";l") 'evil-window-right)

(map! :after clojure-mode :map clojure-mode-map :localleader :n "x" #'sp-kill-hybrid-sexp)
(map! :after clojure-mode :map clojure-mode-map :localleader :n "s" #'sp-forward-slurp-sexp)
(map! :after clojure-mode :map clojure-mode-map :localleader :n "b" #'sp-forward-barf-sexp)

(use-package! rustic
  :config
  (set-ligatures! 'rustic-mode
    :lambda "fn")
  (map! :after rustic :map rustic-mode-map :localleader :n "d" #'dap-hydra))

(advice-add 'lsp :before #'direnv-update-environment)
(use-package! direnv
  :config
  (direnv-mode))

(setq dap-utils-extension-path "~/.emacs.d/.extentions")
(use-package! dap-mode
  :config
  (dap-ui-mode)
  (dap-ui-controls-mode 1)
  (setf (cdr dap-ui-session-mode-map) nil)
  (setf (cdr dap-ui-breakpoints-mode-map) nil)
  (require 'dap-lldb)
  (require 'dap-gdb-lldb)
  ;; installs .extension/vscode
  (dap-gdb-lldb-setup)
  (dap-register-debug-template
   "Rust::LLDB Run Configuration"
   (list :type "lldb"
         :request "launch"
         :name "LLDB::Run"
	 :gdbpath "rust-lldb"
         :target nil
         :cwd nil)))

(use-package! nix-mode
  :config
  (require 'nix)
  (require 'nix-search)

  (defun nix-build (&optional file attr)
    "Run nix-build in a compilation buffer.
FILE the file to parse.
ATTR the attribute to build."
    (interactive (list (nix-read-file) nil))
    (unless attr (setq attr (nix-read-attr file)))

    (setq compile-command (format "%s %s -A '%s'" nix-build-executable
                                  file attr))
    (setq-default compilation-directory default-directory)
    (compilation-start compile-command nil
                       (apply-partially (lambda (attr _)
                                          (format "*nix-build*<%s>" attr))
                                        attr)))

  (provide 'nix-build))
