(setq doom-theme 'doom-tokyo-night)
(setq doom-front (font-spec :family "JetBrains Mono" :size 15))
(setq display-line-numbers-type 'relative)
(setq confirm-kill-emacs nil)
(setq doom-localleader-key ",")

(map! :leader
      :desc "Comment line" "-" #'comment-line)

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.1)))))

(defun mrbarboza/toggle-markdown-view-mode ()
  "Toggle between `markdown-mode' and `markdown-view-mode'."
  (interactive)
  (if (eq major-mode 'markdown-view-mode)
      (markdown-mode)
    (markdown-view-mode)))

(setq org-roam-directory "~/vault/"
      org-roam-dailies-directory "daily/")

;; Enable Org-Roam autosync 
(org-roam-db-autosync-mode)

(setq org-roam-capture-templates
  '(("d" "default" plain
     "%?"
     :target (file+head "${slug}.org"
              "#+title: ${title}\n#+filetags: \n#+date: %T\n\n")
     :unnarrowed t)

    ("l" "literature note" plain
     "* Source\n%?\n\n* Notes\n\n* Summary"
     :target (file+head "literature/${slug}.org"
              "#+title: ${title}\n#+filetags: :literature:\n#+date: %T\n\n")
     :unnarrowed t)

    ("p" "permanent note" plain
     "%?"
     :target (file+head "permanent/${slug}.org"
              "#+title: ${title}\n#+filetags: :permanent:\n#+date: %T\n\n")
     :unnarrowed t)))

(setq org-roam-dailies-capture-templates
  '(("d" "default" entry
     "* %<%H:%M> %?"
     :target (file+head "%<%Y-%m-%d>.org"
              "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n\n"))))

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start nil))

(use-package! consult-org-roam
  :after org-roam
  :config
  (consult-org-roam-mode 1)
  :bind
  (:map doom-leader-notes-map
   ("r s" . consult-org-roam-search)     ; SPC n r s — full-text search
   ("r B" . consult-org-roam-backlinks))) ; SPC n r B — backlinks via consult

(custom-theme-set-faces!
'doom-tokyo-night
'(org-level-8 :inherit outline-3 :height 1.0)
'(org-level-7 :inherit outline-3 :height 1.0)
'(org-level-6 :inherit outline-3 :height 1.1)
'(org-level-5 :inherit outline-3 :height 1.2)
'(org-level-4 :inherit outline-3 :height 1.3)
'(org-level-3 :inherit outline-3 :height 1.4)
'(org-level-2 :inherit outline-2 :height 1.5)
'(org-level-1 :inherit outline-1 :height 1.6)
'(org-document-title  :height 1.8 :bold t :underline nil))

(defconst mrbarboza/nu-dir
  (expand-file-name "dev/nu" (getenv "HOME")))

(setq read-process-output-max (* 1024 1024))
(when (file-directory-p mrbarboza/nu-dir)
  (setq projectile-project-search-path (list mrbarboza/nu-dir)
        projectile-enable-caching nil))

(use-package! lsp-mode
  :commands lsp
  :config
  (setq lsp-semantic-tokens-enable t)
  (add-hook 'lsp-after-apply-edits-hook
            (lambda (&rest _)
              (save-buffer))))

(let ((nudev-emacs-path (expand-file-name "nudev/ides/emacs/" mrbarboza/nu-dir)))
  (when (file-directory-p nudev-emacs-path)
    (add-to-list 'load-path nudev-emacs-path)
    (require 'nu nil t)))
