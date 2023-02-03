(require 'package)
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp/")
;; some tools
(require 'helpers)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/")
	     '("melpa-milkbox" . "http://melpa.milkbox.net/packages/"))


;; start without toolbar, splashscreen and maximized
(tool-bar-mode -1)
(setq inhibit-startup-screen t)

;; windmove moving keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-replace t)
 '(css-indent-offset 2)
 '(csv-separators '("," ";"))
 '(custom-safe-themes
   '("d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" "7153b82e50b6f7452b4519097f880d968a6eaf6f6ef38cc45a144958e553fbc6" default))
 '(debug-on-error nil)
 '(dired-recursive-copies 'always)
 '(ein:completion-backend 'ein:use-ac-backend)
 '(ess-view-data-current-backend 'data\.table+magrittr)
 '(initial-frame-alist '((fullscreen . maximized)))
 '(org-agenda-files
   '("~/dirnliga/org/tasks.org" "~/dirnliga/org/heureka.org" "~/dirnliga/org/notes.org" "~/dirnliga/org/other.org"))
 '(package-selected-packages
   '(paredit latex-preview-pane sudo-edit docker-compose-mode vscode-icon dired-sidebar use-package typescript-mode ess-view-data po-mode eink-theme jedi magit csv-mode gist websocket dash simple-httpd js2-mode skewer-mode s deferred request request-deferred pyvenv epl pkg-info projectile popup poly-noweb poly-markdown julia-mode ivy highlight-indentation helm-make async helm find-file-in-project ctable ess-R-data-view company ac-helm helm-core poly-R yasnippet solarized-theme alect-themes polymode markdown-mode ein flycheck auto-complete django-mode elpy smartparens ess org htmlize))
 '(pdf-latex-command "xelatex")
 '(python-shell-interpreter "ipython")
 '(reb-re-syntax 'string)
 '(scroll-preserve-screen-position 1)
 '(standard-indent 2)
 '(typescript-indent-level 2))

(unless package-archive-contents
  (package-refresh-contents))
(package-install-selected-packages)
;; globally enable flycheck
;;(global-flycheck-mode)

(setq show-paren-delay 0)           ; how long to wait?
(show-paren-mode t)                 ; turn paren-mode on
(setq show-paren-style 'expression) ; alternatives are 'parenthesis' and 'mixed'
(setq-default indent-tabs-mode nil)

;; IDO
(require 'ido)
(ido-mode t)

;; load paths
(add-to-list 'load-path "~/emacs.d/lisp")

;; auto-complete
(ac-config-default)

;; R
(require 'ess-site)

(defun def-R-keys ()
  (interactive)
  (local-set-key [(shift return)] 'ess-execute-to-point)
  (local-set-key (kbd "C-<") 'ess-insert-assign)
  (local-set-key (kbd "C-.") 'ess-set-working-directory)
  (local-set-key (kbd "C-c d") 'ess-describe-object-at-point)
  (local-set-key (kbd "C-,") 'ess-view-data-print)
  (setq comint-move-point-for-output t)
  )

(add-hook 'ess-mode-hook 'def-R-keys)

(require 'ess-view-data)
(define-key ess-view-data-mode-map (kbd "C-ö") 'ess-view-data-unique)
(define-key ess-view-data-mode-map (kbd "C-c r") 'ess-view-data-reset)
(define-key ess-view-data-mode-map (kbd "C-c q") 'ess-view-data-quit)


;; avoid having return key to select auto-completion option
(define-key ac-completing-map [return] nil)
(define-key ac-completing-map "\r" nil)

(setq ess-default-style 'DEFAULT)
;;(ess-toggle-underscore nil)

;; (defun rmd-mode ()
;;   "ESS Markdown mode for rmd files."
;;   (interactive)
;;   (require 'poly-R)
;;   (require 'poly-markdown)
;;   (poly-markdown+r-mode))


;; elpy mode
(elpy-enable)

;; white space cleanup
;;(add-hook 'before-save-hook 'whitespace-cleanup)

;; electric pair mode
(electric-pair-mode 1)

;; global key setup
(global-set-key (kbd "C-x C-q") 'find-file-at-point)

;; ibuffer instead of normal buffer view
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-\"") 'add-quotes)

;; comment-or-uncomment
(global-set-key (kbd "C-;") 'comment-or-uncomment-region)

;; this is a redefinition of (useless) toggle read-only mode
(global-set-key (kbd "C-x C-r") 'revert-buffer)

;; magit status
(global-set-key (kbd "C-x g") 'magit-status)

;; insert file name at point
(global-set-key "\C-c\C-i" 'my-insert-file-name)

(add-hook 'LaTeX-mode-hook 'flyspell-mode)

;; dictionary
(with-eval-after-load "ispell"
  ;; Configure `LANG`, otherwise ispell.el cannot find a 'default
  ;; dictionary' even though multiple dictionaries will be configured
  ;; in next line.
  (setenv "LANG" "en_US.UTF-8")
  (setq ispell-program-name "hunspell")
  ;; Configure German, Swiss German, and two variants of English.
  (setq ispell-dictionary "de_DE,en_GB,en_US")
  ;; ispell-set-spellchecker-params has to be called
  ;; before ispell-hunspell-add-multi-dic will work
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "de_DE,en_GB,en_US")
  ;; For saving words to the personal dictionary, don't infer it from
  ;; the locale, otherwise it would save to ~/.hunspell_de_DE.
  (setq ispell-personal-dictionary "~/.hunspell_personal")

  ;; The personal dictionary file has to exist, otherwise hunspell will
  ;; silently not use it.
  (unless (file-exists-p ispell-personal-dictionary)
    (write-region "" nil ispell-personal-dictionary nil 0))
  )

;; org mode auto fill mode hook
(add-hook 'org-mode-hook 'auto-fill-mode)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c x") (lambda () (interactive) (org-capture nil "t")))
(setq org-directory "~/dirnliga/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/dirnliga/org/tasks.org" "Tasks")
         "* TODO %?\n  %i")))
(setq org-startup-indented t)


(require 'font-lock)
(global-font-lock-mode t)
(setq font-lock-support-mode
       '((gams-mode . nil)
     (t . jit-lock-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; jupyter notebook mode
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
(add-to-list 'python-shell-completion-native-disabled-interpreters
             "jupyter")

(setenv "IPY_TEST_SIMPLE_PROMPT" "1")
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i")
(setenv "WORKON_HOME" "~/miniconda3/envs")
(pyvenv-mode 1)

(setq
ein:jupyter-default-server-command "/home/alois/miniconda3/envs/psi/bin/jupyter"
)

(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :init
  (add-hook 'dired-sidebar-mode-hook
            (lambda ()
              (unless (file-remote-p default-directory)
                (auto-revert-mode))))
  :config
  (push 'toggle-window-split dired-sidebar-toggle-hidden-commands)
  (push 'rotate-windows dired-sidebar-toggle-hidden-commands)

  (setq dired-sidebar-subtree-line-prefix "__")
  (setq dired-sidebar-theme 'vscode)
  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t))

(use-package vscode-icon
  :ensure t
  :commands (vscode-icon-for-file))

;; hl line
(global-hl-line-mode)
(delete-selection-mode 1)

(load-theme 'solarized-light t)
(menu-bar-mode -1)

(elpy-rpc-reinstall-virtualenv)
