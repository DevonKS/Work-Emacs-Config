(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'load-path "C:/Users/devons/AppData/Roaming/.emacs.d/lisp/")
(add-to-list 'load-path "c:/Users/devons/AppData/Roaming/.emacs.d/lisp/library/")
(package-initialize)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("4f5bb895d88b6fe6a983e63429f154b8d939b4a8c581956493783b2515e22d6d" "613a7c50dbea57860eae686d580f83867582ffdadd63f0f3ebe6a85455ab7706" default)))
 '(ido-enable-flex-matching t)
 '(neo-theme (quote ascii))
 '(neo-window-width 50)
 '(package-selected-packages
   (quote
    (desktop+ evil-leader key-chord hl-line+ omnisharp icicles powerline-evil powerline init-open-recentf browse-kill-ring ido-vertical-mode persistent-scratch window-numbering window-number expand-region ace-jump-mode eldoc-eval company dash epl goto-chg pkg-info popup s undo-tree flycheck linum-relative neotree evil ample-theme moe-theme csharp-mode yasnippet auto-complete))))


;; General Setup

;; Powerline
(require 'init-powerline)

;; Line numbers
(linum-relative-global-mode t)
(setq linum-relative-current-symbol "")

(setq column-number-mode t)
(setq-default indent-tabs-mode nil)

;; Backup Files
(setq backup-files-directory "C:/Users/devons/Documents/Emacs-Backup")
(setq backup-directory-alist
        `((".*" . ,backup-files-directory)))
(setq auto-save-file-name-transforms
        `((".*" ,backup-files-directory t)))

;; Recent files on start
(recentf-mode 1)
(setq init-open-recentf-interface 'default)
(init-open-recentf)

(add-hook 'after-init-hook 'global-company-mode)
(setq company-idle-delay 0)
(show-paren-mode t)
(set-default 'truncate-lines t)
(setq truncate-partial-width-windows nil)
(yas-global-mode 1)
(global-flycheck-mode t)
(global-hl-line-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(ido-mode t)
(ido-vertical-mode t)
(window-numbering-mode t)


(desktop-save-mode t)

;; Setting frame title to file path
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;; General keybindings setup
(global-set-key (kbd "C-x e") 'eval-buffer)
(global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-x r") 'replace-string)
(global-set-key (kbd "C-c f p") 'flycheck-previous-error)
(global-set-key (kbd "C-c f n") 'flycheck-next-error)
(global-set-key (kbd "C-c j") 'ace-jump-word-mode)
(global-set-key (kbd "C-c C-r") 'recentf-open-files)
(global-set-key (kbd "C-c C-v") 'browse-kill-ring)
(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)
(global-set-key (kbd "<f8>") 'neotree-toggle)


(global-evil-leader-mode t)
(evil-leader/set-leader ",")
(evil-leader/set-key "e" 'eval-buffer)
(evil-leader/set-key "/" 'comment-or-uncomment-region-or-line)
(evil-leader/set-key "f n" 'flycheck-next-error)
(evil-leader/set-key "f p" 'flycheck-previous-error)
(evil-leader/set-key "j w" 'ace-jump-word-mode)
(evil-leader/set-key "j c" 'ace-jump-char-mode)
(evil-leader/set-key "v" 'split-window-right)
(evil-leader/set-key "b" 'ido-switch-buffer)
(evil-leader/set-key "r f" 'recentf-open-files)
(evil-leader/set-key "p" 'browse-kill-ring)
(evil-leader/set-key "t" 'neotree-toggle)
(evil-leader/set-key "k" 'kill-buffer)
(evil-leader/set-key "m" 'delete-other-windows)
(evil-leader/set-key "r b" 'revert-buffer)


;; Neotree setup
(setq neo-smart-open t)
(add-hook 'neotree-mode-hook
        (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;; (eldoc-in-minibuffer-mode 1)
(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments current current line or whole lines in region."
  (interactive)
  (save-excursion
    (let (min max)
      (if (region-active-p)
          (setq min (region-beginning) max (region-end))
        (setq min (point) max (point)))
      (comment-or-uncomment-region
       (progn (goto-char min) (line-beginning-position))
       (progn (goto-char max) (line-end-position))))))


;; CSharp Stuff

;; Needed because find-name-dired uses it and the windows find searched within file
(setq igrep-find-program "c:\\cygwin64\\bin\\find")

;; Navigate to a HIS File
(defun goto-HIS-File-on-branch (branch filename)
  (interactive "sBranch:
sFilename: ")
  (if (or (string= (downcase branch) "main") (string= (downcase branch) "m"))
      (setq path "C:/Source/HIS/Main/Code")
    (setq path "C:/Source/HIS/Feature/10.2/Code"))
  (find-name-dired path filename))

(defun goto-HIS-File (filename)
  (interactive "sFilename: ")
  (setq path "c:/Source/HIS/Main/Code")
  (find-name-dired path filename))

;; Open current solution
(defun open-current-solution ()
  (interactive)
  (-let [(directory file . rest) (omnisharp--find-solution-files)]
    (if directory
	(if (null rest) ; only one solution found
               (setq path (concat directory file))
             (setq path (read-file-name "Select solution for current file: "
                             directory
                             nil
                             t
                             file)))))
  (shell-command (concat "start " path " /D .")))

;; Omnisharp Setup
(setq omnisharp--curl-executable-path "C:/Program Files (x86)/Curl/curl.exe")
(setq omnisharp-server-executable-path "C:/Program Files (x86)/omnisharp-server/OmniSharp/bin/Debug/OmniSharp.exe")
(defun my-csharp-mode-hook ()
  (require 'tfs)
  (omnisharp-mode t)

  ;; Omnisharp keybindings setup
  (global-set-key (kbd "C-c g") 'omnisharp-go-to-definition)
  (global-set-key (kbd "C-c i") 'omnisharp-find-implementations)
  (global-set-key (kbd "C-c m") 'omnisharp-navigate-to-current-file-member)
  (global-set-key (kbd "C-c n") 'omnisharp-navigate-to-solution-member)
  (global-set-key (kbd "C-c r") 'omnisharp-rename)
  (global-set-key (kbd "C-c f c") 'omnisharp-fix-code-issue-at-point)
  (global-set-key (kbd "C-c u") 'omnisharp-find-usages)
  (global-set-key (kbd "C-c q") 'omnisharp-current-type-documentation)
  (global-set-key (kbd "C-c SPC") 'omnisharp-auto-complete)
  (global-set-key (kbd "C-c s") 'omnisharp-start-omnisharp-server)
  (global-set-key (kbd "C-c b") 'omnisharp-build-in-emacs)

  ;; Csharp keybindings setup
  (global-set-key (kbd "C-c o") 'open-current-solution)

  ;; TFS keybindings setup
  (global-set-key (kbd "C-c c") 'tfs/checkout)
  (global-set-key (kbd "C-c t u") 'tfs/undo)
  (global-set-key (kbd "C-c d") 'tfs/diff)
  (eval-after-load 'company
  '(add-to-list 'company-backends 'company-omnisharp)))
(add-hook 'csharp-mode-hook 'my-csharp-mode-hook)

;; Omnisharp evil-mode config
(evil-define-key 'insert omnisharp-mode-map (kbd "M-.") 'omnisharp-auto-complete)
(evil-define-key 'normal omnisharp-mode-map (kbd "<f12>") 'omnisharp-go-to-definition)
(evil-define-key 'normal omnisharp-mode-map (kbd "g u") 'omnisharp-find-usages)
(evil-define-key 'normal omnisharp-mode-map (kbd "g I") 'omnisharp-find-implementations) ; g i is taken
(evil-define-key 'normal omnisharp-mode-map (kbd "g o") 'omnisharp-go-to-definition)
(evil-define-key 'normal omnisharp-mode-map (kbd "g r") 'omnisharp-run-code-action-refactoring)
(evil-define-key 'normal omnisharp-mode-map (kbd "g f") 'omnisharp-fix-code-issue-at-point)
(evil-define-key 'normal omnisharp-mode-map (kbd "g F") 'omnisharp-fix-usings)
(evil-define-key 'normal omnisharp-mode-map (kbd "g R") 'omnisharp-rename)
(evil-define-key 'normal omnisharp-mode-map (kbd ", i") 'omnisharp-current-type-information)
(evil-define-key 'normal omnisharp-mode-map (kbd ", I") 'omnisharp-current-type-documentation)
(evil-define-key 'insert omnisharp-mode-map (kbd ".") 'omnisharp-add-dot-and-auto-complete)
(evil-define-key 'normal omnisharp-mode-map (kbd ", n t") 'omnisharp-navigate-to-current-file-member)
(evil-define-key 'normal omnisharp-mode-map (kbd ", n s") 'omnisharp-navigate-to-solution-member)
(evil-define-key 'normal omnisharp-mode-map (kbd ", n f") 'omnisharp-navigate-to-solution-file-then-file-member)
(evil-define-key 'normal omnisharp-mode-map (kbd ", n F") 'omnisharp-navigate-to-solution-file)
(evil-define-key 'normal omnisharp-mode-map (kbd ", n r") 'omnisharp-navigate-to-region)
(evil-define-key 'normal omnisharp-mode-map (kbd "<f12>") 'omnisharp-show-last-auto-complete-result)
(evil-define-key 'insert omnisharp-mode-map (kbd "<f12>") 'omnisharp-show-last-auto-complete-result)
(evil-define-key 'normal omnisharp-mode-map (kbd ",.") 'omnisharp-show-overloads-at-point)
(evil-define-key 'normal omnisharp-mode-map (kbd ",rl") 'recompile)

(evil-define-key 'normal omnisharp-mode-map (kbd ",rt")
  (lambda() (interactive) (omnisharp-unit-test "single")))

(evil-define-key 'normal omnisharp-mode-map
  (kbd ",rf")
  (lambda() (interactive) (omnisharp-unit-test "fixture")))

(evil-define-key 'normal omnisharp-mode-map
  (kbd ",ra")
  (lambda() (interactive) (omnisharp-unit-test "all")))


;; Omnisharp flycheck setup
(setq flycheck-csharp-omnisharp-codecheck-executable "C:/Program Files (x86)/Curl/curl.exe")
(setq omnisharp-debug t)

(global-set-key (kbd "C-c C-n") 'goto-HIS-File)

;; Evil-Mode
(require 'evil)
(evil-mode 1)
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))
(key-chord-mode t)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
(key-chord-define evil-visual-state-map "jk" 'evil-normal-state)
;; Evil-Mode end.

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(hl-line ((t (:background "black")))))
