;; VARS
(defvar jackson/default-font-size 125)
(defvar jackson/default-variable-font-size 125)


;; PACKAGE SETUP
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;; BASIC UI SETUP
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips

(menu-bar-mode -1)            ; Disable the menu bar

(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)


;; FONT CONFIG
(set-face-attribute 'default nil :font "JetBrains Mono" :height jackson/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :height jackson/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height jackson/default-variable-font-size :weight 'regular)


;; KEYBINDINGS
(use-package general
  :config
  (general-create-definer jackson/leader-binds
    :prefix "SPC"
    :non-normal-prefix "C-c"
    :keymaps '(normal insert emacs))

  (jackson/leader-binds
    "t"   '(:ignore t :which-key "toggles")
    "tt"  '(counsel-load-theme :which-key "choose theme")
    "f"   '(:ignore t :which-key "files")
    "fr"  '(counsel-recentf :which-key "recent files")
    "ff"  '(counsel-find-file :which-key "find files")
    ":"   '(execute-extended-command :which-key "run M-x")
    "b"   '(:ignore t :which-key "buffers")
    "bb"  '(counsel-switch-buffer :which-key "switch buffer")
    "bk"  '(kill-current-buffer :which-key "kill current buffer")
    "bK"  '(kill-buffer :which-key "interactive kill buffer")
    "bs"  '(save-buffer :which-key "save current buffer")
    "bp"  '(previous-buffer :which-key "previous buffer")
    "bn"  '(next-buffer :which-key "next buffer")
    "q"   '(:ignore t :which-key "exit menu")
    "qq"  '(kill-emacs :which-key "kill emacs")
    "p"   '(:ignore t :which-key "projectile")
    "SPC" '(projectile-find-file :which-key "find file in project")
    "pa"  '(projectile-add-known-project :which-key "add new project")
    "pd"  '(projectile-remove-known-project :which-key "remove known project")
    ))

(use-package undo-fu)
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (general-evil-setup) ;; enable imap, nmap, etc for keybinds in other places
  (evil-mode 1)

  (evil-declare-change-repeat 'company-complete-common) ;; avoid error on blank completion trigger

  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))


;; THEME
(use-package doom-themes
  :init (load-theme 'doom-vibrant t))


;; MODELINE
(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))


;; WHICH KEY
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))


;; IVY
(use-package counsel
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-prescient
  :after counsel
  :config
  (setq prescient-filter-method '(literal regexp initialism))
  (ivy-prescient-mode 1)
  (prescient-persist-mode))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


;; EXTRA INFO FOR HELP COMMANDS
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; HYDRA SET UP
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(jackson/leader-binds
  "ts" '(hydra-text-scale/body :which-key "scale text"))


;; ORG SETUP
;; TODO IF NEEDED


;; BABEL LANGUAGES
(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))
(push '("conf-unix" . conf-unix) org-src-lang-modes)


;; COMPANY
(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :general
  (general-imap "C-SPC" 'company-complete-common)
  :config
  (setq company-idle-delay nil)
  (global-company-mode t))


;; LSP MODE AND OTHER LANG SUPPORT
(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook
  (python-mode . lsp)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-headerline-breadcrumb-enable nil) ; disable breadcrumb
  (lsp-enable-which-key-integration t))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))


;; PROJECTILE
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/git_repos/")
    (setq projectile-project-search-path '("~/git_repos/"))))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; SAVE CUSTOM VARS TO SEPARATE FILE
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)
