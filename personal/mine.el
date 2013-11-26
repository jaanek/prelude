(global-set-key [up] 'previous-line)
(global-set-key [down] 'next-line)
(global-set-key [left] 'backward-char)
(global-set-key [right] 'forward-char)
(global-set-key [M-right] 'right-word)
(global-set-key [M-left] 'left-word)

(global-set-key "\M-g" 'goto-line)

;; enable whitespace mode globally - http://stackoverflow.com/questions/8036576/how-to-get-whitespace-mode-enabled-only-for-certain-modes
(require 'whitespace)
(global-whitespace-mode t)

;; Comment and Uncomment regions
(global-unset-key "\C-c\C-c")
(global-set-key  "\C-c\C-c" 'comment-region)
;; shortcut for uncomment region
(global-unset-key "\C-c\C-u")
(global-set-key "\C-c\C-u" 'uncomment-region)

;; indent region
(global-set-key (kbd "C-x i") 'indent-region)

;;
;;https://sites.google.com/site/steveyegge2/effective-emacs
;;
;; Item 2: Invoke M-x without the Alt key
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)

;; theme
(disable-theme 'zenburn)
;;(load-theme 'solarized-dark t)

;; Disable flyspell-mode and whitespace-mode -  https://github.com/bbatsov/prelude/issues/52
(add-hook 'prog-mode-hook 'prelude-turn-off-whitespace t)
(flyspell-mode 0)

;; join columns
(defun join-lines () (interactive) (let ((fill-column 999999)) (fill-paragraph nil)))
(global-set-key (kbd "C-x j") 'join-lines)

;; uniq-lines
;; ----------
;; This is something of a companion to the built-in sort-lines function.
;; Like the uniq utility, this removes duplicate lines from the region. It
;; is best used after sorting a region.
;;
(defun uniq-lines (start end)
  "Removes duplicate lines from the selected region."
  (interactive "*r")
  (goto-char start)
  (beginning-of-line)
  (let ((last ""))
    (while (< (point) end)
      (let* ((bol (point))
             (eol (progn (end-of-line) (point)))
             (text (buffer-substring bol eol)))
        (forward-char)
        (if (string= last text)
            (delete-region bol (point))
          (setq last text))))))

;; match the parent parenthesis
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
"Go to the matching parenthesis if on parenthesis otherwise insert %."
(interactive "p")
(cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
((looking-at "\\s\)") (forward-char 1) (backward-list 1))
(t (self-insert-command (or arg 1)))))


;; Call maven directly from emacs
(require 'compile)
(defvar mvn-command-history nil  "Maven command history variable")
(defun mvnfast() (interactive)
  (let ((fn (buffer-file-name)))
  (let ((dir (file-name-directory fn)))
  (while (and (not (file-exists-p (concat dir "/pom.xml")))
         (not (equal dir (file-truename (concat dir "/..")))))
         (setq dir (file-truename (concat dir "/.."))))
  (if (not (file-exists-p (concat dir "/pom.xml")))
      (message "No pom.xml found")
      (compile (concat "mvn -f " dir "/pom.xml compile -Dmaven.test.skip=true"))))))
;;(define-key java-mode-map "\C-c\C-x5" 'mvnfast)
(defun mvn(&optional args) "Runs maven in the current project. Starting at the directoy where the file being vsisited resides, a search is   made for pom.xml recsurively. A maven command is made from the first directory where the pom.xml file is found is then displayed  in the minibuffer. The command can be edited as needed and then executed. Errors are navigate to as in any other compile mode"
      (interactive)
      (let ((fn (buffer-file-name)))
      (let ((dir (file-name-directory fn)))
      (while (and (not (file-exists-p (concat dir "/pom.xml")))
             (not (equal dir (file-truename (concat dir "/..")))))
             (setq dir (file-truename (concat dir "/.."))))
      (if (not (file-exists-p (concat dir "/pom.xml")))
             (message "No pom.xml found")
             (compile (read-from-minibuffer "Command: " (concat "mvn -f " dir "/pom.xml compile -Dmaven.test.skip=true") nil nil 'mvn-command-history))))))
;; String pattern for locating errors in maven output. This assumes a Windows drive letter at the beginning
;;(add-to-list 'compilation-error-regexp-alist '("^\\([a-zA-Z]:.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3))
(add-to-list 'compilation-error-regexp-alist '("^\\[ERROR\\] \\(.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3))

;; clipboard with x
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; alias for query replace regexp
(defalias 'qrr 'query-replace-regexp)

;; X copy-paste
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;;-----------------------------------------------------------------------------
;; settings related to viewing and editing

;; Font size
;; The value is in 1/10pt, so 100 will give you 10pt, etc. 
;; http://www.emacswiki.org/emacs/SetFonts. `C-x C-+’ and ‘C-x C--’ to increase or decrease the buffer text size
(set-face-attribute 'default nil :height 120)

;; set default paragraph (line) fill width. http://www.dpawson.co.uk/relaxng/nxml/nxmlGeneral.html#d357e516
(setq-default fill-column 860) ;; this will guarantee that line is not wrapped if column width goes big

;; Show matching parenthesis
(show-paren-mode 1)

;; tabs to spaces
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 4)
(setq tab-width 8)

;;; turn on syntax highlighting
(global-font-lock-mode 1)

;;-----------------------------------------------------------------------------
;; settings related to appearance

;; No menu, no scrollbar
(menu-bar-mode 0)
(if (commandp 'scroll-bar-mode)
    (scroll-bar-mode -1))
(if (commandp 'tool-bar-mode)
    (tool-bar-mode 0))


;;-----------------------------------------------------------------------------
;; settings related to behaviour other than editing

;; Scroll one line at a time, not in blocks
(setq scroll-conservatively 1)

;; Never beep
(setq ring-bell-function '(lambda () (interactive)))

;; Superboost C-x b
(iswitchb-mode t)

;; Stop forcing me to spell out "yes"
(fset 'yes-or-no-p 'y-or-n-p)

;; xah-elisp-mode: http://ergoemacs.org/emacs/xah-elisp-mode.html
;;(add-to-list 'load-path "~/.emacs.d/personal/xah-elisp-mode")
;;(require 'xah-elisp-mode)
;;(add-to-list 'auto-mode-alist '("\.el$" . xah-elisp-mode))

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
;; load the groovy mode. https://github.com/jaanek/Emacs-Groovy-Mode
(add-to-list 'load-path "~/.emacs.d/personal/groovy")
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'auto-mode-alist '("\.gradle$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("gradle" . groovy-mode))
;;; make Groovy mode electric by default.
(add-hook 'groovy-mode-hook
          '(lambda ()
             (require 'groovy-electric)
             (groovy-electric-mode)))

;; web-mode: http://web-mode.org/
(add-to-list 'load-path "~/.emacs.d/personal/web-mode")
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
;; Using web-mode for editing plain HTML files can be done this way
;;(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; javascript mode - http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 4)

;; nxhtml module
(load "~/.emacs.d/personal/nxhtml/autostart.el")

;; load the tabkey2 module
(load "~/.emacs.d/personal/tabkey2/tabkey2.el")

;; load nxml custom settings
(load "~/.emacs.d/personal/nxml-custom-settings.el")

;; load the zencoding mode. Easy html generation. http://www.emacswiki.org/emacs/ZenCoding
(add-to-list 'load-path "~/.emacs.d/personal/zencoding/")
(require 'zencoding-mode)
(add-hook 'sgml-mode-hook 'zencoding-mode)
(global-set-key (kbd "M-RET") 'zencoding-expand-line)

;; load yasnippet. html code templates: https://github.com/capitaomorte/yasnippet
;;(add-to-list 'load-path "~/.emacs.d/personal/yasnippet/0.6.1c")
;;(require 'yasnippet) ;; not yasnippet-bundle
;;(yas/initialize)
;;(yas/load-directory "~/.emacs.d/personal/yasnippet/0.6.1c/snippets")


;; next compilation error
(global-set-key (kbd "C-x c") 'mvn)
(global-set-key (kbd "C-x n") 'compilation-next-error)


(global-set-key (kbd "M-s g") 'grep)
(global-set-key (kbd "M-s M-g") 'rgrep)

(global-set-key (kbd "M-s M-o") 'find-name-dired)
(global-set-key (kbd "M-s M-p") 'find-grep)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(tidy-temp-directory "/tmp/"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;; Disable newlines that are inserted after snippets
;; http://stackoverflow.com/questions/7619640/emacs-latex-yasnippet-why-are-newlines-inserted-after-a-snippet
;;(setq-default require-final-newline nil)
;; ensure we do this *after* default.el is loaded!
;;(add-hook ‘after-init-hook
;;‘(lambda ()
;;(setq require-final-newline nil)))
;;(setq-default mode-require-final-newline nil)
(add-hook 'nxhtml-mumamo-mode-hook '(lambda ()
                           (setq require-final-newline nil)
                           (setq mode-require-final-newline nil)))
;; do not wrap lines. http://office.alendro.com/display/devel/Turn+off+automatic+line+wrap
(add-hook 'text-mode-hook 
          (lambda () (auto-fill-mode -1)))

;; No line breaks after a tag. http://www.emacswiki.org/emacs/HtmlMode#toc3
;;(unless (fboundp 'sgml-fill-nobreak)
;;  ;; from the emacs cvs head
;;  (defun sgml-fill-nobreak ()
;;    ;; Don't break between a tag name and its first argument.
;;    (save-excursion
;;      (skip-chars-backward " \t")
;;      (and (not (zerop (skip-syntax-backward "w_")))
;;           (skip-chars-backward "/?!")
;;           (eq (char-before) ?<))))
;;
;;  (add-hook 'sgml-mode-hook
;;            (lambda ()
;;              (set (make-local-variable 'fill-nobreak-predicate)
;;                   'sgml-fill-nobreak))))
