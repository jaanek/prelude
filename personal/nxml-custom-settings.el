;;
;;(defun nxml-pretty-format ()
;;    (interactive)
;;    (save-excursion
;;        (shell-command-on-region (point-min) (point-max) "xmllint --format -" (buffer-name) t)
;;        (nxml-mode)
;;        (indent-region begin end)))

;;;###autoload
(progn
 (push '("<\\?xml" . nxml-mode) magic-mode-alist)

 ;; pom files should be treated as xml files
 (add-to-list 'auto-mode-alist '("\\.pom$" . nxml-mode))

 (setq nxml-child-indent 4)
 (setq nxml-attribute-indent 0)
 (setq nxml-auto-insert-xml-declaration-flag nil)
 (setq nxml-bind-meta-tab-to-complete-flag t)
 (setq nxml-slash-auto-complete-flag t))

;;
;; 
(defun nxml-kill-tag-contents ()
  "Copy the contents between two tags"
;  (interactive "*p\ncCopy tag contents: ") ; this expects arguments input
  (interactive)
  (nxml-backward-up-element)
  (kill-region
    (progn
      (search-forward ">")
      (point)
    )
    (progn
      (nxml-backward-up-element)
      (nxml-forward-element)
      (search-backward "</")
      (point)
    )
  )
)

(defun nxml-copy-tag-contents ()
  "Copy the contents between two tags"
;  (interactive "*p\ncCopy tag contents: ") ; this expects arguments input
  (interactive)
  (nxml-backward-up-element)
  (copy-region-as-kill
   (progn
     (search-forward ">")
     (point)
   )
  (progn
     (nxml-backward-up-element)
     (nxml-forward-element)
     (search-backward "</")
     (point))
  )
)

(defun nxml-pretty-print-xml-region (begin end)
  "Beautiful code from Benjamin Ferrari (blog.bookwurm.at). 
   The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
      (nxml-mode)
      (goto-char begin)
      (while (search-forward-regexp "\>[ \\t]*\<" nil t)
        (backward-char) (insert "\n"))
      (indent-region begin end))
    (message "Ah, much better!")
)

(defun m-nxml-mode-hook ()
"key definitions for nxml mode"
(interactive)
;; (set-variable 'fill-column 99) ;; skip this here, because we set a default one in mine.el
; nxml key bindings consistent with C-b, C-f, C-p, C-n, M-b, M-f, M-p, M-n
(define-key nxml-mode-map "\C-of" 'nxml-forward-balanced-item)     ; f for forward
(define-key nxml-mode-map "\C-ob" 'nxml-backward-balanced-item)    ; b for backward
(define-key nxml-mode-map "\C-op" 'nxml-backward-element)   ; p consistent with C-p
(define-key nxml-mode-map "\C-on" 'nxml-forward-element)  ;
(define-key nxml-mode-map "\M-of" 'nxml-forward-element)     ; f for forward, 
(define-key nxml-mode-map "\M-ob" 'nxml-backward-element)    ; b for backward
(define-key nxml-mode-map "\M-op" 'nxml-backward-paragraph)   ; p consistent with M-p
(define-key nxml-mode-map "\M-on" 'nxml-forward-paragraph)  ;
;(define-key nxml-mode-map "\M-ou" 'nxml-backward-up-element) ; u for up
;(define-key nxml-mode-map "\M-od" 'nxml-down-element)        ; d for down
(define-key nxml-mode-map "\M-ok" 'nxml-kill-element)        ; d for down

(define-key nxml-mode-map [M-insert] 'nxml-copy-tag-contents)
(define-key nxml-mode-map "\C-xw" 'nxml-kill-tag-contents)

(define-key nxml-mode-map "\C-cv" 'browse-url-of-buffer) ; should be consistent with the shortcut in the html-mode
(set-variable 'tab-width 2)

  (message "Defined extra key-bindings for nxml-mode")
)
(add-hook 'nxml-mode-hook 'm-nxml-mode-hook)
