;; CUSTOM VARS
(defvar jackson/default-font-size 125)
(defvar jackson/default-variable-font-size 125)

(setq user-full-name "Jackson Ludwig"
	  user-mail-address "jacksonludwig0@gmail.com")

(defcustom display-line-numbers-exempt-modes '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable the linum mode, exempts them from global requirement"
  :group 'display-line-numbers
  :type 'list
  :version "green")

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


;; BACKUP FILE DIRECTORY
(setq backup-directory-alist
	  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
	  `((".*" ,temporary-file-directory t)))


;; BASIC UI SETUP
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips

(menu-bar-mode -1)          ; Disable the menu bar
(setq visible-bell t)       ; Visual bell

(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

(setq-default tab-width 4)  ; Tab length
(setq-default indent-tabs-mode nil) ; Spaces, not tabs

(setq-default truncate-lines t) ; Don't wrap by default

(setq help-window-select t) ; Auto switch to help buffers

(defalias 'yes-or-no-p 'y-or-n-p) ; y or n is enough

(setq whitespace-style '(trailing tabs tab-mark)) ; show whitespace
(global-whitespace-mode 1)
          
;; FONT CONFIG
(set-face-attribute 'default nil :font "Iosevka" :height jackson/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Iosevka" :height jackson/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "DejaVu Sans" :height jackson/default-variable-font-size :weight 'regular)


;; DIMINISH
(use-package diminish
  :config
  (diminish 'eldoc-mode)
  (diminish 'global-whitespace-mode))


;; KEYBINDINGS
(use-package general
  :config
  (general-create-definer jackson/leader-binds
    :prefix "SPC"
    :keymaps '(normal))

  ;; TODO delegate into correct packages
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
    "o"   '(:ignore t :which-key "open")
    "ot"  '(vterm-other-window :which-key "open term")
    "oT"  '(vterm :which-key "open term in current")
    ))

(use-package vterm
  :ensure nil
  :hook
  (vterm-mode . (lambda ()
                  (display-line-numbers-mode 0)))
  :config
  (setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
  (setq vterm-max-scrollback 10000)
  )

(use-package undo-fu)
(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-integration t
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-fu
        evil-mode-line-format nil
        evil-vsplit-window-right t
        evil-split-window-below t)
  :hook
  (evil-insert-state-entry . (lambda ()
                              (if (and
                                   (not (member major-mode display-line-numbers-exempt-modes))
                                   (not (minibufferp)))
                                  (setq display-line-numbers t))))
  (evil-insert-state-exit . (lambda ()
                              (if (and
                                   (not (member major-mode display-line-numbers-exempt-modes))
                                   (not (minibufferp)))
                                  (setq display-line-numbers 'relative))))
  :config
  (general-evil-setup) ;; enable imap, nmap, etc for keybinds in other places
  (evil-mode 1)

  (evil-declare-change-repeat 'company-complete-common) ;; avoid error on blank completion trigger

  ;; core extra binds
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (evil-set-initial-state 'messages-buffer-mode 'normal))

(use-package evil-collection
  :after evil
  :custom
  (evil-collection-company-use-tng nil)
  (evil-collection-key-blacklist '("SPC"))
  :init
  ;; add modes manually as needed
  ;; use evil-collection-mode-list to see options
  (evil-collection-init '(calendar dired dashboard mu4e mu4e-conversation vterm ansi-term term)))


;; THEME
(use-package all-the-icons)

;; DASHBOARD
(use-package dashboard
  :ensure t
  :config
  (setq dashboard-startup-banner (concat user-emacs-directory "splash.png")
        dashboard-banner-logo-title "Emacs")
  (setq dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))
  (setq dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (setq dashboard-footer-messages '("Configured by Jackson"))
  (dashboard-setup-startup-hook))

(use-package doom-themes
  :after all-the-icons
  :init
  (load-theme 'doom-one t)
  )

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 30
        doom-modeline-major-mode-icon nil)
  (doom-modeline-def-modeline 'main
    '(bar window-number matches buffer-info remote-host buffer-position selection-info)
    '(objed-state misc-info persp-name irc mu4e github debug input-method buffer-encoding lsp major-mode process vcs checker))
  )


;; WHICH KEY
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))


;; IVY
(use-package counsel
  :diminish counsel-mode
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


;; ORG SETUP
(use-package org
  :hook
  (org-mode . visual-line-mode)
  :config
  (setq org-directory "~/git_repos/emacs-org-mode"
		))


;; BABEL LANGUAGES
(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))
(push '("conf-unix" . conf-unix) org-src-lang-modes)


;; COMPANY
(use-package company
  :diminish company-mode
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :general
  (general-imap "C-SPC" 'company-complete-common)
  :config
  (setq company-idle-delay nil)
  (global-company-mode t))

(use-package company-box
  :hook (company-mode . company-box-mode))


;; LSP MODE AND OTHER LANG SUPPORT

;; Better docs with eglot (if using) and maybe other things
(use-package markdown-mode)

;; Better diagnostics with and without lsp
(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save))
  
  :general
  (general-nmap "[g" 'flycheck-previous-error) ;; Flycheck binds
  (general-nmap "]g" 'flycheck-next-error))

;; Snippets
(use-package yasnippet
  :hook
  (prog-mode . yas-minor-mode)
  (org-mode  . yas-minor-mode)
  :config
  ;; (yas-global-mode 1)
  (define-key yas-minor-mode-map [(tab)] nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  :general
  (general-imap
    :predicate 'yas-minor-mode
    :keymaps 'yas-minor-mode-map
    "C-l" #'yas-expand
    "C-j" #'yas-next-field
    "C-k" #'yas-prev-field)
  )

(use-package yasnippet-snippets
  :after yasnippet)

;; Lsp mode config
(use-package lsp-mode
  :commands (lsp lsp-deferred)

  :hook
  (python-mode . lsp)
  (go-mode . lsp)
  (web-mode . lsp)
  (help-mode . visual-line-mode) ;; visual line mode for docs

  :init
  (setq lsp-keymap-prefix "C-c l")

  :config
  (setq gc-cons-threshold 100000000)
  (setq lsp-completion-provider :capf)
  (setq create-lockfiles nil) ;; disable lockfiles because they annoy some LSP

  (setq lsp-enable-snippet nil) ;; disable lsp snippet
  (setq lsp-headerline-breadcrumb-enable nil) ;; disable breadcrumb
  (setq lsp-enable-symbol-highlighting nil) ;; disable symbol highlight
  (setq lsp-enable-links nil) ;; disable links
  
  (lsp-enable-which-key-integration t)

  ;; Make help buffers nicer
  (add-to-list 'display-buffer-alist
             '((lambda (buffer _) (with-current-buffer buffer
                                    (seq-some (lambda (mode)
                                                (derived-mode-p mode))
                                              '(help-mode))))
               (display-buffer-reuse-window display-buffer-below-selected)
               (reusable-frames . visible)
               (window-height . 0.30)))
  :general
  (general-nmap
    :predicate 'lsp-mode
    "K" 'lsp-describe-thing-at-point)
  (general-nmap
    :predicate 'lsp-mode
    "gs" 'lsp-signature-activate)
  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-doc-enable nil
        lsp-ui-sideline-enable nil)

  :general
  (general-nmap
	:predicate 'lsp-ui-mode
	"gr" 'lsp-ui-peek-find-references)
  (general-nmap
	:predicate 'lsp-ui-mode
	"gd" 'lsp-ui-peek-find-definitions))

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))

(use-package go-mode
  :hook
  (go-mode . (lambda ()
               (setq indent-tabs-mode nil)))
  :config
  (setq lsp-gopls-complete-unimported t)
  )

(use-package web-mode  :ensure t
  :mode (("\\.js\\'" . web-mode)
         ("\\.jsx\\'" . web-mode)
         ("\\.ts\\'" . web-mode)
         ("\\.tsx\\'" . web-mode)
         ("\\.html\\'" . web-mode)
         ("\\.vue\\'" . web-mode)
         ("\\.json\\'" . web-mode))
  :commands web-mode
  :config
  (setq web-mode-content-types-alist
	'(("jsx" . "\\.js[x]?\\'")))
  )


;; PROJECTILE
(use-package projectile
  :diminish projectile-mode
  :custom ((projectile-completion-system 'ivy))
  :config
  (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/git_repos/")
    (setq projectile-project-search-path '("~/git_repos/"))))

(use-package counsel-projectile
  :config (counsel-projectile-mode))


;; EMAIL
(use-package f) ;; used in workaround to find mu4e
(use-package mu4e
  :ensure nil
  :init
  ;; This is a workaround so that mu4e is always found in nix's store
  (let ((mu4epath
		 (concat
		  (f-dirname
		   (file-truename
			(executable-find "mu")))
		  "/../share/emacs/site-lisp/mu4e")))
	(when (and
		   (string-prefix-p "/nix/store/" mu4epath)
		   (file-directory-p mu4epath))
	  (add-to-list 'load-path mu4epath)))

  :hook
  (mu4e-compose-mode . (lambda ()
                         (use-hard-newlines -1)))
  
  :config
  ;; This is set to 't' to avoid mail syncing issues when using mbsync
  (setq mu4e-change-filenames-when-moving t)

  ;; Refresh mail using isync every 10 minutes
  (setq mu4e-update-interval (* 10 60))
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-maildir "~/Mail")

  (setq mu4e-drafts-folder "/[Gmail]/Drafts")
  (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
  (setq mu4e-refile-folder "/[Gmail]/All Mail")
  (setq mu4e-trash-folder  "/[Gmail]/Trash")

  (setq mu4e-maildir-shortcuts
		'((:maildir "/Inbox"             :key ?i)
		  (:maildir "/[Gmail]/Sent Mail" :key ?s)
		  (:maildir "/[Gmail]/Trash"     :key ?t)
		  (:maildir "/[Gmail]/Drafts"    :key ?d)
		  (:maildir "/[Gmail]/All Mail"  :key ?a)))

  (setq mu4e-compose-format-flowed t)
  (setq mu4e-headers-sort-direction "ascending")

  ;; how to send the mail
  (setq smtpmail-smtp-server       "smtp.gmail.com"
		smtpmail-smtp-service      465
		smtpmail-stream-type       'ssl
		message-send-mail-function 'smtpmail-send-it))


;; SAVE CUSTOM VARS TO SEPARATE FILE
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)
