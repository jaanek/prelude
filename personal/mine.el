(global-set-key [up] 'previous-line)
(global-set-key [down] 'next-line)
(global-set-key [left] 'backward-char)
(global-set-key [right] 'forward-char)
(global-set-key [M-right] 'right-word)
(global-set-key [M-left] 'left-word)

(global-set-key "\M-g" 'goto-line)

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

;;
(defun nxml-pretty-format ()
    (interactive)
    (save-excursion
        (shell-command-on-region (point-min) (point-max) "xmllint --format -" (buffer-name) t)
        (nxml-mode)
        (indent-region begin end)))


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

;; Font size
;; The value is in 1/10pt, so 100 will give you 10pt, etc. 
;; http://www.emacswiki.org/emacs/SetFonts. `C-x C-+’ and ‘C-x C--’ to increase or decrease the buffer text size
(set-face-attribute 'default nil :height 120)


;; tabs to spaces
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 4)
(setq tab-width 8)

;;; turn on syntax hilighting
(global-font-lock-mode 1)

;;; use groovy-mode when file ends in .groovy or has #!/bin/groovy at start
(autoload 'groovy-mode "groovy-mode" "Groovy editing mode." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; javascript mode - http://stackoverflow.com/questions/4177929/how-to-change-the-indentation-width-in-emacs-javascript-mode
(setq js-indent-level 2)

;; nxhtml module
(load "~/.emacs.d/personal/nxhtml/autostart.el")

;; load the tabkey2 module
(load "~/.emacs.d/personal/tabkey2/tabkey2.el")

;; nxml
;;;###autoload
(progn
 (push '("<\\?xml" . nxml-mode) magic-mode-alist)

 ;; pom files should be treated as xml files
 (add-to-list 'auto-mode-alist '("\\.pom$" . nxml-mode))

 (setq nxml-child-indent 2)
 (setq nxml-attribute-indent 2)
 (setq nxml-auto-insert-xml-declaration-flag nil)
 (setq nxml-bind-meta-tab-to-complete-flag t)
 (setq nxml-slash-auto-complete-flag t))


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


;; indent region
(global-set-key (kbd "C-x i") 'indent-region)

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
