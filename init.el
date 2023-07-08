;; Themes
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(deeper-blue))
 '(package-selected-packages
   '(company-jedi jedi-core ac-html-angular ac-html-csswatcher ac-html-bootstrap web-mode-edit-element web-mode neotree company-web company nix-mode which-key with-venv lsp-ui dap-mode treemacs-magit treemacs-icons-dired treemacs-projectile treemacs marginalia embark-consult embark vertico orderless ripgrep ag projectile realgud use-package))
 '(warning-suppress-types '((comp) (comp) (use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;;(use-package foo)
;; This is only needed once, near the top of the file
(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  ;;(add-to-list 'load-path "<path where use-package is installed>")
  (require 'use-package))
;; --- packages ---

(use-package web-mode
  :ensure t)
(use-package web-mode-edit-element
  :ensure t
  :config (add-hook 'web-mode-hook 'web-mode-edit-element-minor-mode))

;; --- Completion ---
(use-package company
  :ensure t
  :init (setq company-idle-delay 0.3
	      company-minimum-prefix-length 1))
;; Company version of ac-html, complete for web,html,emmet,jade,slim modes
(use-package company-web
  :ensure t)

;; Configuration:
(use-package ac-html-bootstrap
  :ensure t)
(use-package ac-html-csswatcher
  :ensure t)
(use-package ac-html-angular
  :ensure t)
;;   (add-to-list 'company-backends 'company-web-html)
;;   (add-to-list 'company-backends 'company-web-jade)
;;   (add-to-list 'company-backends 'company-web-slim)

;; or, for example, setup web-mode-hook:
(define-key web-mode-map (kbd "C-'") 'company-web-html)
(add-hook 'web-mode-hook (lambda ()
                           (set (make-local-variable 'company-backends) '(company-web-html company-files))
                           (company-mode t)))

;; * TODO jedi-mode
;; Common code of jedi.el and company-jedi.el
(use-package jedi-core
  :ensure t)
;; Standard Jedi.el setting
;; uncomment for jedi-mode
;; (add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; Type:
;;     M-x jedi:install-server RET
;; Then open Python file.
(use-package company-jedi
  :ensure t)
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

;; uncomment for jedi-mode
;; (add-hook 'python-mode-hook 'my/python-mode-hook)

;; Global code completion
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(electric-pair-mode t)
;; (visit-tags-table "~/.emacs.legacy/TAGS-py")


(setq tags-table-list
      '("~/.emacs.d.legacy" "~/Development" "~/Development2"))

;; (global-set-key (kbd "<tab>") #'company-indent-or-complete-common)
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-/") #'company-complete))
(with-eval-after-load 'company
  (define-key company-active-map
    (kbd "SPC")
    ;;(kbd "TAB")
    #'company-complete-common-or-cycle)
  (define-key company-active-map
    (kbd "<backtab>")
    (lambda ()
      (interactive)
      (company-complete-common-or-cycle -1))))
;; --- End Completion ---
;; --- Indenting ---
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Yes, of course you agree that TabsAreEvil.                           ;;
;; But you just have to indulge yourself a tab from time to time        ;;
;; – perhaps to create a file in some required format.                  ;;
;; Whaddya do? ...                                                      ;;
;;                                                                      ;;
;; ‘C-q’ to the rescue! Don’t forget it:                                ;;
;; ‘C-q’ says “insert the next character, whatever it is”               ;;
;; (command quoted-insert).                                             ;;
;;                                                                      ;;
;; So, ‘C-q<tab>' does the trick. – DrewAdams                           ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; tab-width and c-basic-offset variables are buffer-local
;; Emacs only evaluates ~/.emacs at start up, and it is only effective in that file.
;; To set a default value for all buffers, you need
(setq-default tab-width 4)

;; tab-stop-list is used for inserting new tabs.
;; tab-width only for existing tabs e.g. tabify
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60
                          64 68 72 76 80 84 88 92 96 100 104 108 112
                          116 120))
;; The variable indent-tabs-mode controls whether tabs are used for indentation.
;; It is t (true) by default; nil (false) to deactivate it.
(setq-default indent-tabs-mode nil)
;; How wide a tab is, default is 8.
(setq tab-width 4) ; or any other preferred value
;; CC Mode is a powerful package that provides modes for editing
;; C and C-like (C++, Java, Objective C, CORBA IDL, etc.) files.
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)
(defvaralias 'python-indent 'tab-width)
;; For validation of indentation settings: whitespace-mode

;; IndentingHtml
(add-hook 'html-mode-hook
          (lambda ()
            ;; Default indentation is usually 2 spaces, changing to 4.
            (set (make-local-variable 'sgml-basic-offset) 4)))
;; --- End Indenting ---
(add-hook 'emacs-lisp-mode-hook 'eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'eldoc-mode)
(add-hook 'ielm-mode-hook 'eldoc-mode)

;; --- Nix ----
(use-package nix-mode
  :ensure t)
;; --- Python ---
(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         ;; (XXX-mode . lsp)
         ;(python-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred)

;; optionally
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
;; if you are helm user
;(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs
  :ensure t
  :commands lsp-treemacs-errors-list)

;; --- Debugger ----
;; https://emacs-lsp.github.io/dap-mode/page/python-poetry-pyenv/
(use-package realgud
  :ensure t
  :defer t)

;; --- DAP Debug Adapter Protocol ---
(use-package with-venv
  :ensure t)
;; (use-package dap-mode
;;   :ensure t
;;   :after lsp-mode
;;   :commands dap-debug
;;   :hook ((python-mode . dap-ui-mode) (python-mode . dap-mode))
;;   :config
;;   (require 'dap-python)
;;   ;;(setq dap-python-debugger 'debugpy)
;;   (defun dap-python--pyenv-executable-find (command)
;;     ;(with-venv (executable-find "python-mediatum")
;;     (with-venv (executable-find "python")
;;                ))

;;   (add-hook 'dap-stopped-hook
;;             (lambda (arg) (call-interactively #'dap-hydra))))
;; ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; ;; -*- lexical-binding: t -*-
;; (define-minor-mode +dap-running-session-mode
;;   "A mode for adding keybindings to running sessions"
;;   nil
;;   nil
;;   (make-sparse-keymap)
;;   (evil-normalize-keymaps) ;; if you use evil, this is necessary to update the keymaps
;;   ;; The following code adds to the dap-terminated-hook
;;   ;; so that this minor mode will be deactivated when the debugger finishes
;;   (when +dap-running-session-mode
;;     (let ((session-at-creation (dap--cur-active-session-or-die)))
;;       (add-hook 'dap-terminated-hook
;;                 (lambda (session)
;;                   (when (eq session session-at-creation)
;;                     (+dap-running-session-mode -1)))))))

;; ;; Activate this minor mode when dap is initialized
;; (add-hook 'dap-session-created-hook '+dap-running-session-mode)

;; ;; Activate this minor mode when hitting a breakpoint in another file
;; (add-hook 'dap-stopped-hook '+dap-running-session-mode)

;; ;; Activate this minor mode when stepping into code in another file
;; (add-hook 'dap-stack-frame-changed-hook (lambda (session)
;;                                           (when (dap--session-running session)
;;                                             (+dap-running-session-mode 1))))
;; --- End ---

;; optional if you want which-key integration
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; jedi-language-server requirement python >=3.7
; (use-package jedi
;  :ensure t)
;(use-package company-jedi
;	   :ensure t)
(setq python-shell-interpreter "/nix/store/jskxc2wfzq6zdar1iix0x218lbp18kn6-python-2.7.16"
      python-shell-interpreter-args "-i")

(defalias 'workon 'pyvenv-workon)
;; --- end ---
;; --- Hydra ---
(defhydra hydra-buffer-menu (:color pink
                             :hint nil)
  "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))

(define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)
;; --- End Hydra ---
;; --- Working with projects ---
;; --- Enable projectile ---
;; Project framework
(use-package projectile
  :ensure t)
(use-package ag
  :ensure t)
(use-package ripgrep
  :ensure t)
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-x p") 'projectile-command-map)

;; You can go one step further ...
;; and set a list of folders which Projectile is automatically going to ...
;; check for projects on startup.

;; Recursive discovery is configured by specifying the search depth in a cons cell:
;; (setq projectile-project-search-path '("~/projects/" "~/work/" ("~/github" . 1)))
(setq projectile-project-search-path '("~/Development"))

;; While Projectile works fine with Emacs’s default minibuffer completion system ...
;; you’re highly encouraged to use some powerful alternative ...
;; like ido, ivy, selectrum or vertico.

;; --- Treemacs Config ---
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           t
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

;(use-package treemacs-evil
;  :after (treemacs evil)
;  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
;  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
;  :ensure t
;  :config (treemacs-set-scope-type 'Perspectives))

;(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
;  :after (treemacs)
;  :ensure t
;  :config (treemacs-set-scope-type 'Tabs))

;; --- End Treemacs ---

(use-package neotree
  :ensure t)
(global-set-key [f8] 'neotree-toggle)

;; --- Enable vertico ---
;; VERTical Interactive COmpletion
(use-package vertico
  :ensure t
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; I recommend to give Orderless completion a try, which is different from the
;; prefix TAB completion used by the basic default completion system or in shells.
;; Optionally use the `orderless' completion style.
(use-package orderless
  :ensure t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; --- Enable marginalia ---
;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init section is always executed.
  :init

  ;; Marginalia must be actived in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))
;; --- end ---
;; --- Enable embark ---
(use-package embark
  :ensure t
  :bind
  (("C-<" . embark-act)         ;; pick some comfortable binding ("C-.")
   ("C->" . embark-dwim)        ;; good alternative: M-. (("C-;")
   ("C-h <" . embark-bindings)) ;; alternative for `describe-bindings' ("C-h B")

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; You may adjust the Eldoc strategy, if you want to see the 
  ;; documentation from multiple providers.
  (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)
  
  :config
  ;; Show the Embark target at point via Eldoc.
  (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))
;; --- end ---

;; --- Enable consult ---
(use-package consult
  :ensure t
  :init
  (setq completion-styles '(substring basic)))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))
;; --- end---



