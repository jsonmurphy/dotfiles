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
  :ensure
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

(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("rnix-lsp"))
                  :major-modes '(nix-mode)
                  :server-id 'nix))
