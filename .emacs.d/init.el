;; From github.com/june29/dotfiles/.emacs.d/init.el

;; Customized by toihrk

;; Add target directories to load path recursively
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
              (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

(add-to-load-path "elisp")
(add-to-load-path "elpa")
(add-to-load-path "local-elisp")
(add-to-load-path "site-lisp")



;; Init Time
(defadvice require (around require-benchmark activate)
  (let* ((before (current-time))
         (result ad-do-it)
         (after  (current-time))
         (time (+ (* (- (nth 1 after) (nth 1 before)) 1000)
                  (/ (- (nth 2 after) (nth 2 before)) 1000))))
    (when (> time 50)
      (message "%s: %d msec" (ad-get-arg 0) time))))

;; Startup Message
(setq inhibit-startup-message t)

;; Startup CurrentDirectory
(setq inhibit-splash-screen t)
(defun cd-to-homedir-all-buffers ()
  "Change every current directory of all buffers to the home directory."
  (mapc
   (lambda (buf) (set-buffer buf) (cd (expand-file-name "~"))) (buffer-list)))
(add-hook 'after-init-hook 'cd-to-homedir-all-buffers)

;; Yes to y
(fset 'yes-or-no-p 'y-or-n-p)

;; Toolbar
(tool-bar-mode 0)

;; Encode
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)

;; Encode for file system
(when (eq system-type 'darwin)
  (require 'ucs-normalize)
  (set-file-name-coding-system 'utf-8-hfs)
  (setq locale-coding-system 'utf-8-hfs))

;; Tab width
(setq-default tab-width 2)

;; Use space instead of tab
(setq-default indent-tabs-mode nil)

;; Delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Color Theme
(when (require 'color-theme nil t)
  (color-theme-initialize)
  (when (require 'color-theme-solarized)
    (color-theme-solarized-dark)))

(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background  "#98FB98"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode t)


(if window-system (progn
                    (set-frame-parameter nil 'alpha 95)
                    ))

;; Frame Size
(require 'maxframe)
(add-hook 'window-setup-hook 'maximize-frame t)

;; Font
(set-face-attribute 'default nil
                    :family "Menlo"
                    :height 120)
(set-fontset-font
 nil 'japanese-jisx0208
 (font-spec :family "Hiragino Maru Gothic Pro"))
(setq face-font-rescale-alist
      '((".*Menlo.*" . 1.0)
        (".*Hiragino_Maru_Gothic_Pro.*" . 1.2)
        ("-cdac$" . 1.3)))

;; Paren
(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)
(set-face-background 'show-paren-match-face nil)
(set-face-underline-p 'show-paren-match-face "yellow")

;; Backup files
(add-to-list 'backup-directory-alist
             (cons "." "~/.emacs.d/backups"))
(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "~/.emacs.d/backups") t)))

;; Use 'Command key' as a 'Meta key'
(setq ns-command-modifier (quote meta))
(setq ns-alternate-modifier (quote super))

;; Mac
(setq mac-pass-control-to-system nil)
(setq mac-pass-command-to-system nil)
(setq mac-pass-option-to-system nil)

;; Mac Clipboard
(defun copy-from-osx ()
 (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
 (let ((process-connection-type nil))
     (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
       (process-send-string proc text)
       (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; Backspace by C-h
(keyboard-translate ?\C-h ?\C-?)

;; Change window by C-t
(define-key global-map (kbd "C-<tab>") 'other-window)

;; (makunbound 'overriding-minor-mode-map)
(define-minor-mode overriding-minor-mode
  "Force Remap <C-tab>"
  t                                     ; Default true
  ""                                    ; Don't display
  `((,(kbd "C-<tab>") . other-window-or-sprit)))

;; Indent region
(global-set-key "\C-x\C-i" 'indent-region)

;; SKK
(require 'skk-setup)
(require 'skk-study)

;;skk-server AquaSKK
(setq skk-server-portnum 1178)
(setq skk-server-host "localhost")

(global-set-key "\C-x\C-j" 'skk-mode)

(add-hook 'isearch-mode-hook
          (function (lambda ()
                      (and (boundp 'skk-mode) skk-mode
                           (skk-isearch-mode-setup)))))
(add-hook 'isearch-mode-end-hook
          (function (lambda ()
                      (and (boundp 'skk-mode) skk-mode (skk-isearch-mode-cleanup))
                      (and (boundp 'skk-mode-invoked) skk-mode-invoked
                           (skk-set-cursor-properly)))))

;; emacsc
(require 'emacsc)
(require 'ediff-batch)

;; Cua
(cua-mode t)
(setq cua-enable-cua-keys nil)

;; Auto Revert
(global-auto-revert-mode 1)

;; Uniquify Buffer
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; Emacs server
(require 'server)
(unless (server-running-p)
(server-start))

;; auto-install
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;; Package.el
(when (require 'package nil t)
  (add-to-list 'package-archives
               '("marmalade" . "http://marmalade-repo.org/packages/"))
  (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))
  (package-initialize))

;; Auto Complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories
    "~/.emacs.d/elisp/ac-dict")
  (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
  (ac-config-default))

;; Anything.el
(require 'anything-startup)
(require 'anything-config)

(global-set-key (kbd "C-;") 'anything-filelist+)
(defun anything-custom-filelist ()
    (interactive)
    (anything-other-buffer
     (append
      '(anything-c-source-ffap-line
        anything-c-source-ffap-guesser
        anything-c-source-buffers+
        )
      (anything-c-sources-git-project-for)
      '(anything-c-source-recentf
        anything-c-source-bookmarks
        anything-c-source-file-cache
        anything-c-source-filelist
        ))
     "*anything file list*"))
(setq
 anything-idle-delay 0.2
 anything-input-idle-delay 0.1
 anything-candidate-number-limit 50
 anything-quick-update t
 anything-complete-sort-candidates t)


;; popwin
(if (require 'popwin nil t)
    (progn
      (setq display-buffer-function 'popwin:display-buffer)
      (setq popwin:popup-window-height 0.4)
      (setq anything-samewindow nil)
      (push '("*anything*" :height 20) popwin:special-display-config)
      (push '("\\*anything" :regexp t) popwin:special-display-config)
      (push '(dired-mode :position top) popwin:special-display-config)
      (push '("\\*[Vv][Cc]" :regexp t :position top) popwin:special-display-config)
      (push '("\\*git-" :regexp t :position top) popwin:special-display-config)
      ))

;; Visiable Linu Number
(require 'linum)
(global-linum-mode)
(require 'yalinum)
(global-yalinum-mode t)
(set-face-background 'yalinum-bar-face "DeepPink")
(toggle-scroll-bar nil)
(require 'hlinum)
(custom-set-faces
 '(linum-highlight-face ((t (:foreground "Black"
                             :background "Yellow")))))
(global-linum-mode t)

;; ido Mo
(require 'ido)
(ido-mode t)

;; Visiable History
(require 'undohist)
(undohist-initialize)
(require 'undo-tree)
(global-undo-tree-mode t)
(global-set-key (kbd "M-/") 'undo-tree-redo)

;;  Automatically insert pair braces and quotes
(require 'flex-autopair)
(flex-autopair-mode t)


;; Ruby Configirations
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Procfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("Guardfile" . ruby-mode))
(add-to-list 'auto-mode-alist '("¥¥.gemspec$" . ruby-mode))
(add-to-list 'auto-mode-alist '("¥¥.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("¥¥.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("¥¥.jbuilder$" . ruby-mode))
(when (require 'ruby-block nil t)
  (setq ruby-block-highlight-toggle t))
(defun ruby-mode-hooks ()
  (ruby-block-mode t))
(add-hook 'ruby-mode-hook 'ruby-mode-hooks)

;; Ruby - indent (http://willnet.in/13)
(setq ruby-deep-indent-paren-style nil)

(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?¥))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset))))

;; (require 'ruby-electric)
;; (add-hook 'ruby-mode-hook '(lambda () (ruby-electric-mode t)))
;; (setq ruby-electric-expand-delimiters-list nil)

(require 'ruby-block)
(ruby-block-mode t)
(setq ruby-block-highlight-toggle t)

(require 'rcodetools)
(setq rct-find-tag-if-available nil)
(defun ruby-mode-hook-rcodetools ()
  (define-key ruby-mode-map "¥M-¥C-i" 'rct-complete-symbol)
  (define-key ruby-mode-map "¥C-c¥C-t" 'ruby-toggle-buffer)
  (define-key ruby-mode-map "¥C-c¥C-f" 'rct-ri))
(add-hook 'ruby-mode-hook 'ruby-mode-hook-rcodetools)

;; HAML-mode
(require 'haml-mode)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))

;; YAML-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Scss-mode
(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))

(defun scss-custom ()
  "scss-mode-hook"
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)
   )
  )
(add-hook 'scss-mode-hook
  '(lambda() (scss-custom)))

;; Coffee-mode
(require 'coffee-mode)
(autoload 'coffee-mode "coffee-mode" "Major mode for editing CoffeeScript." t)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.\\(js\\|json\\)$" . js2-mode))

;; jade-mode
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))
