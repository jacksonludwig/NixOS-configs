;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; NOTE Company settings:
;; Raise autocompletion delay from 0.25. nil means manual.
;; Set tooltip limit
(after! company
  (setq company-tooltip-limit 18)
  (setq company-idle-delay 0.5))

;; NOTE Lua mode config
;; (after! lua-mode
;;   (setq +lua-lsp-dir "~/Unmanaged/lang-servers/sumneko/lua-language-server"
;;         lua-indent-level 4))

;; NOTE Rust mode config
;; (after! rustic
;;   (setq rustic-lsp-server 'rust-analyzer))

;; NOTE Company box tooltips
;; (setq company-box-doc-enable nil)

;; NOTE blinking cursor
(blink-cursor-mode 1)
(setq x-stretch-cursor t)

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jackson Ludwig"
      user-mail-address "jacksonludwig0@gmail.com"

      ;; NOTE lsp-ui-sideline is redundant with eldoc and much more invasive, so
      ;; disable it by default.
      lsp-ui-sideline-enable nil

      ;; NOTE disable symbol highlight cause it's kind of annoying in emacs
      lsp-enable-symbol-highlighting nil

      ;; NOTE More common use-case
      evil-ex-substitute-global t

      ;; This determines the style of line numbers in effect. If set to `nil', line
      ;; numbers are disabled. For relative line numbers, set this to `relative'.
      display-line-numbers-type 'relative)

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Roboto Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "sans" :size 16))
;;(setq
;; doom-font (font-spec :family "Iosevka Fixed" :size 18)
;; doom-big-font (font-spec :family "Iosevka Fixed" :size 24)
;; doom-variable-pitch-font (font-spec :family "Overpass"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

;;(setq doom-theme 'doom-nord)
;; (setq doom-theme 'doom-Iosvkem)
;; (setq doom-theme 'doom-opera-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

;; NOTE Set org directory and other settings for org
(setq org-directory "~/git_repos/emacs-org-mode/"
      org-ellipsis " [...] "
      org-src-tab-acts-natively t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; NOTE Switch to the new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; NOTE Remove Line Highlight
(remove-hook! doom-first-buffer #'global-hl-line-mode)

;; NOTE Use ultisnips bind to navigate snippets
(map! :after yasnippet
      :map yas-minor-mode-map
      :i "C-l" #'yas-expand
      :i "C-j" #'yas-next-field
      :i "C-k" #'yas-prev-field)

;; NOTE disable lsp formatters
(setq +format-with-lsp nil)

;; NOTE dont show images after running code block
(after! org
  (remove-hook 'org-babel-after-execute-hook #'org-redisplay-inline-images))

;; NOTE Latex keybinds (SPC m v to open pdf view)
(map!
 :after LaTeX-mode-hook
 :map LaTeX-mode-map
 :localleader
 :desc "View" "v" #'TeX-view)

;; HACK stop warning about invalid base64 data when things are unfocused in org
(defadvice! no-errors/+org-inline-image-data-fn (_protocol link _description)
  :override #'+org-inline-image-data-fn
  "Interpret LINK as base64-encoded image data. Ignore all errors."
  (ignore-errors
    (base64-decode-string link)))
