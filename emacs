;; -*-emacs-lisp-*-
;; no startup message
(setq inhibit-startup-message t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 113 :width normal))))
 '(region ((t (:background "dark orange" :foreground "gtk_selection_fg_color")))))
(add-to-list 'default-frame-alist (cons 'background-color "wheat"))
(add-to-list 'default-frame-alist (cons 'cursor-color "red"))
(and (equal (window-system) 'x)
     (let ()
       (add-to-list 'default-frame-alist (cons 'height 60))
       (add-to-list 'default-frame-alist (cons 'width 132))))
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list 'package-archives (cons "melpa" "https://melpa.org/packages/"))
  (package-initialize))
(add-hook 'go-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 4)
            )
          )
(add-hook 'before-save-hook 'gofmt-before-save)
