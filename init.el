(if (fboundp 'menu-bar-mode)
    (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

(defun open-user-init-file ()
  (interactive)
  (find-file user-init-file))
(global-set-key (kbd "C-c c") 'open-user-init-file)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
(setq package-enable-at-startup nil)

(unless (package-installed-p 'quelpa)
    (with-temp-buffer
      (url-insert-file-contents "https://github.com/quelpa/quelpa/raw/master/quelpa.el")
      (eval-buffer)
      (quelpa-self-upgrade)))
(setq quelpa-self-upgrade-p nil)
(setq quelpa-update-melpa-p nil)

(unless (or (package-installed-p 'use-package) (package-installed-p 'quelpa-use-package))
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package)
  (package-install 'quelpa-use-package))
(require 'use-package)
(require 'quelpa-use-package)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message "")
(setq ring-bell-function 'ignore)
(setq make-pointer-invisible t)
(setq frame-resize-pixelwise t)
(setq split-width-threshold most-positive-fixnum)
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(put 'upcase-region 'disabled nil)
(defalias 'yes-or-no-p 'y-or-n-p)

(defun my-scroll-down-command ()
  (interactive)
  (dotimes (i 3)
    (previous-line))
  (recenter))
(global-set-key (kbd "M-p") 'my-scroll-down-command)
(defun my-scroll-up-command ()
  (interactive)
  (dotimes (i 3)
    (next-line))
  (recenter))
(global-set-key (kbd "M-n") 'my-scroll-up-command)

(use-package autorevert
  :init
  (progn
    (global-auto-revert-mode t)))

(use-package cc-mode
  :init
  (progn
    (setq c-default-style "k&r")
    (setq c-basic-offset 4)
    (c-set-offset 'case-label '+)))

(use-package compile
  :init
  (progn
    (setq compilation-scroll-output t)))

(use-package counsel
  :config (counsel-mode)
  :ensure t)

(use-package delsel
  :init
  (progn
    (delete-selection-mode 1)))

(use-package elpy
  :defer t
  :init
  (progn
    (setq elpy-rpc-backend "jedi")
    (setq elpy-rpc-python-command "python3"))
  (advice-add 'python-mode :before 'elpy-enable)
  :ensure t)

(use-package files
  :init
  (progn
    (setq make-backup-files nil)))

(use-package frame
  :init
  (progn
    (blink-cursor-mode -1)))

(use-package glsl-mode
  :ensure t)

(use-package gud
  :config
  (progn
    (add-to-list 'auto-mode-alist '("\\.gdb$" . gdb-script-mode))))

(use-package helm
  :init
  (progn
    (setq helm-M-x-fuzzy-match t)
    (setq helm-buffers-fuzzy-matching t)
    (setq helm-recentf-fuzzy-match t)
    (setq helm-ff-skip-boring-files t)
    (setq helm-exit-idle-delay 0))
  :config
  (progn
    (require 'helm-config)
    (helm-mode)
    (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
    (define-key helm-map (kbd "C-z") 'helm-select-action)
    (use-package helm-ring
      :bind (("M-y" . helm-show-kill-ring))))
  :diminish helm-mode
  :ensure t)

(use-package helm-gtags
  :init
  (progn
    (setq helm-gtags-prefix-key (kbd "C-c g"))
    (setq helm-gtags-suggested-key-mapping nil)
    (setq helm-gtags-ignore-case t)
    (setq helm-gtags-auto-update t)
    (setq helm-gtags-direct-helm-completing t)
    (setq helm-gtags-fuzzy-match t))
  :config
  (progn
    (let ((command-table '(("w" . helm-gtags-find-dwim)
                           ("u" . helm-gtags-find-pop-stack)
                           ("f" . helm-gtags-find-files)
                           ("o" . helm-gtags-parse-file)
                           ("p" . helm-gtags-find-pattern)
                           ("s" . helm-gtags-find-symbol)
                           ("r" . helm-gtags-find-rtag)
                           ("t" . helm-gtags-find-tag)
                           ("m" . helm-gtags-resume)))
          (key-func (if (string-prefix-p "\\" helm-gtags-prefix-key)
                        #'concat
                      (lambda (prefix key) (kbd (concat prefix " " key))))))
      (cl-loop for (key . command) in command-table
               do
               (define-key helm-gtags-mode-map (funcall key-func helm-gtags-prefix-key key) command)))    
    (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
    (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
    (add-to-list 'safe-local-variable-values '(helm-gtags-mode . 1)))
  :quelpa (helm-gtags :fetcher github :repo "jacekmigacz/emacs-helm-gtags"))

(use-package hexl
  :init
  (progn
    (setq hexl-bits 8)))

(use-package hi-lock
  :bind (("C-c h" . highlight-symbol-at-point)
         ("C-c u" . unhighlight-regexp)))

(use-package ivy
  :diminish
  :bind (("C-c C-r" . ivy-resume))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-initial-inputs-alist nil)
  (ivy-use-virtual-buffers t)
  :config
  (ivy-mode)
  :ensure t)

(use-package magit
  :bind (("C-c g" . magit-status))
  :ensure t)

(use-package man
  :init
  (progn
    (setq Man-notify-method 'pushy)))

(use-package mouse
  :init
  (progn
    (setq mouse-yank-at-point t)))

(use-package mu4e
  :defer t
  :commands (mu4e mu4e-compose-new)
  :custom
  (mu4e-get-mail-command "mbsync -a")
  (mu4e-attachment-dir "~/downloads")
  (mu4e-change-filenames-when-moving t)
  (mu4e-enable-notifications t)
  (mu4e-confirm-quit nil)
  :bind (("C-c m" . mu4e))
  :ensure nil)
(defconst user-mu4e-contexts (concat user-emacs-directory "mu4e.el"))
(if (file-readable-p user-mu4e-contexts) (load-file user-mu4e-contexts) nil)

(use-package mwheel
  :init
  (progn
    (setq mouse-wheel-scroll-amount '(1 ((shift))))))

(use-package ninja-mode
  :ensure t)

(use-package paren
  :init
  (show-paren-mode 1))

(use-package sendmail
  :init
  (progn
    (setq message-send-mail-function 'message-send-mail-with-sendmail)
    (setq sendmail-program "msmtp")))

(use-package org
  :bind (("C-c C-o l" . org-metaleft))
  :config
  (progn
    (setq org-support-shift-select 'always)
    (setq org-M-RET-may-split-line nil)
    (setq org-todo-keywords '((sequence "DO ZROBIENIA" "|" "ZROBIONE")))
    (setq org-agenda-files '("~/org"))))

(use-package simple
  :init
  (progn
    (line-number-mode 1)
    (column-number-mode 1))
  :bind (("M-]" . next-error)
         ("M-[" . previous-error)))

(use-package spacemacs-common
  :init
  (progn
    (setq spacemacs-theme-org-height nil)
    (setq spacemacs-theme-underline-parens nil))
  :config
  (when (display-graphic-p)
    (load-theme 'spacemacs-light t))
  :ensure spacemacs-theme)

(use-package swiper
  :bind (("C-s" . swiper)
         ("C-r" . swiper))
  :ensure t)

(use-package tooltip
  :init
  (progn
    (tooltip-mode -1)))

(use-package windmove
  :bind (("<left>" . windmove-left)
         ("<right>" . windmove-right)
         ("<up>" . windmove-up)
         ("<down>" . windmove-down)))

(defconst user-local-init-file (concat user-emacs-directory "local.el"))
(if (file-readable-p user-local-init-file) (load-file user-local-init-file) nil)
(defun open-user-local-init-file ()
  (interactive)
  (find-file user-local-init-file))
(global-set-key (kbd "C-c C-c c") 'open-user-local-init-file)

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
