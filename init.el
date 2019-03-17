;; load path
;;(add-to-list 'load-path "~/.emacs.d/")

;; startup
(menu-bar-mode -1) 
(toggle-scroll-bar -1) 
(tool-bar-mode -1)
(set-frame-parameter nil 'fullscreen 'fullboth)
(setq inhibit-startup-message t)
;; show line nums
(add-hook 'text-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'linum-mode)

;; set path
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; modeline
(display-battery-mode 1)
(display-time-mode 1)



;; melpa
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
'("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))

;; org-mode
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; try
(use-package try
  :ensure t)

;; which key
(use-package which-key
:ensure t
:config
(which-key-mode))

;; ido
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; ibuffer
(defalias 'list-buffers 'ibuffer)

;; chuck mode
(add-to-list 'load-path "~/.emacs.d/packages/chuck-mode/")
(require 'chuck-mode)

(add-hook 'chuck-mode-hook
          (lambda () (run-hooks 'prog-mode-hook)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-enabled-themes (quote (sanityinc-tomorrow-eighties)))
 '(custom-safe-themes
   (quote
    ("628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(package-selected-packages
   (quote
    (which-key try rjsx-mode treemacs-magit treemacs-icons-dired treemacs-projectile use-package treemacs color-theme-sanityinc-solarized color-theme-sanityinc-tomorrow osc extempore-mode rainbow-delimiters smartparens company-tern js2-mode zenburn-theme cyberpunk-theme)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838"))))

;; load theme after init
;;(add-hook 'after-init-hook (lambda () (load-theme 'zenburn)))

;;;;;;;; code
(require 'smartparens-config)
(add-hook 'prog-mode-hook (lambda ()
			    (rainbow-delimiters-mode)
			    (smartparens-mode)))

;;;;;;;; javascript
(setq-default js2-basic-offset 2)
(setq-default js-indent-level 2)

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)
(require 'rjsx-mode)
;; tern - autocomplete
(require 'company)
(require 'company-tern)
(add-to-list 'company-backends 'company-tern)
(add-hook 'js2-mode-hook  (lambda ()
                           (tern-mode)
                           (company-mode)))

;;;;;;;; TREEMACS
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (executable-find "python") 3 0)
          treemacs-display-in-side-window        t
          treemacs-file-event-delay              5000
          treemacs-deferred-git-apply-delay      nil
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-no-png-images                 t
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (executable-find "python3"))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

;;(use-package treemacs-icons-dired
;;  :after treemacs dired
;;  :ensure t
;;  :config (treemacs-icons-dired-mode))

;;(use-package treemacs-magit
;;  :after treemacs magit

;;  :ensure t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
