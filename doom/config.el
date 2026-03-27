(setq doom-theme 'doom-tokyo-night)
(setq doom-font (font-spec :family "JetBrains Mono" :size 15))
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
      org-roam-dailies-directory "logs/")

(after! org-roam
  (org-roam-db-autosync-mode)
  (setq org-roam-node-display-template
        (concat "${title:*} " (propertize "${tags:20}" 'face 'org-tag)))
  (setq org-roam-completion-everywhere t))

(setq org-roam-capture-templates
  '(("i" "idea" plain
     "%?"
     :target (file+head "ideas/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :idea:\n#+date: %T\n\n")
     :unnarrowed t)

    ("p" "person")

    ("pp" "profile" plain
     "* Role\n%?\n\n* Strengths\n\n* Growth Areas\n\n* Career Goals\n\n* Notes"
     :target (file+head "people/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :person:\n#+date: %T\n\n")
     :unnarrowed t)

    ("j" "project" plain
     "* Goal\n%?\n\n* Status\n\n* Team\n\n* Key Decisions\n\n* Risks\n\n* Updates"
     :target (file+head "projects/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :project:\n#+date: %T\n\n")
     :unnarrowed t)

    ("b" "playbook" plain
     "* Purpose\n%?\n\n* When to Use\n\n* Steps\n\n* Notes"
     :target (file+head "playbooks/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :playbook:\n#+date: %T\n\n")
     :unnarrowed t)

    ("l" "log")

    ("lm" "meeting" plain
     "* Attendees\n%?\n\n* Agenda\n\n* Discussion\n\n* Decisions\n\n* Action Items"
     :target (file+head "logs/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :log:meeting:\n#+date: %T\n\n")
     :unnarrowed t)

    ("po" "1-on-1" plain
     "* Date: %<%Y-%m-%d>\n\n* Agenda\n%?\n\n* Updates\n\n* Action Items\n\n* Notes"
     :target (file+head "people/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :person:1on1:\n#+date: %T\n\n")
     :unnarrowed t)

    ("ld" "decision" plain
     "* Context\n%?\n\n* Options Considered\n\n* Decision\n\n* Rationale\n\n* Consequences"
     :target (file+head "logs/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :log:decision:\n#+date: %T\n\n")
     :unnarrowed t)

    ("pf" "feedback" plain
     "* Person\n%?\n\n* Context\n\n* Observation\n\n* Impact\n\n* Ask / Suggestion"
     :target (file+head "people/%<%Y%m%d%H%M%S>-${slug}.org"
              "#+title: ${title}\n#+filetags: :person:feedback:\n#+date: %T\n\n")
     :unnarrowed t)))

(setq org-roam-dailies-capture-templates
  '(("d" "default" plain
     "* Focus\n%?\n\n* Meetings\n\n* Action Items\n\n* Notes"
     :target (file+head "%<%Y-%m-%d>.org"
              "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n\n"))))

(map! :leader
      :desc "Open ideas in dired"     "n r I" #'(lambda () (interactive) (dired "~/vault/ideas/"))
      :desc "Open people in dired"    "n r P" #'(lambda () (interactive) (dired "~/vault/people/"))
      :desc "Open projects in dired"  "n r J" #'(lambda () (interactive) (dired "~/vault/projects/"))
      :desc "Open playbooks in dired" "n r B" #'(lambda () (interactive) (dired "~/vault/playbooks/"))
      :desc "Open logs in dired"      "n r L" #'(lambda () (interactive) (dired "~/vault/logs/")))

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
   ("r s" . consult-org-roam-search)))   ; SPC n r s — full-text search

(after! org
  ;; Add backtick as inline code marker (like Markdown)
  (add-to-list 'org-emphasis-alist
               '("`" (:inherit font-lock-constant-face :foreground "#b16286")))
  (setcar (nthcdr 2 org-emphasis-regexp-components) " \t\r\n,\"')}")
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components))

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

(use-package! claude-code
  :config
  (setq claude-code-claude-command "claude")
  (setq claude-code-terminal-backend 'vterm)
  (setq claude-code-display-window-fn
        (lambda (buffer)
          (display-buffer buffer '((display-buffer-in-side-window)
                                   (side . right)
                                   (window-width . 0.5))))))

(map! :leader
      (:prefix ("A" . "AI")
       :desc "Claude Code"        "c" #'claude-code
       :desc "Send region"        "r" #'claude-code-send-region
       :desc "Send buffer"        "b" #'claude-code-send-buffer
       :desc "Menu"               "m" #'claude-code-menu))

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
