;;; consult-everything.el --- Everything integration with Consult -*- lexical-binding: t; -*-

;; Copyright (C) John Haman 2022
;; Author: John Haman <mail@johnhaman.org>
;; Homepage: https://github.com/jthaman/consult-everything
;; Version: 0.1

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This package provides Everything integration with the Emacs program
;; `consult'. Download the Everything commandline tool, es.exe, from
;; https://www.voidtools.com/downloads/#cli and place the binary in your Path.
;; Everything is a useful `locate' alternative on Windows machines.

;;; Code:

(require 'consult)

(defcustom consult-everything-args
  "es -p -r"
  "Command line arguments for everything, see `consult-everything'.
The dynamically computed arguments are appended."
  :type 'string)

(defun consult--everything (prompt builder initial)
  "Run everything command.
The function returns the selected file.
The filename at point is added to the future history.
BUILDER is the command builder.
PROMPT is the prompt.
INITIAL is initial input."
  (consult--read
   (consult--async-command builder
     (consult--async-map (lambda (x) (string-remove-prefix "./" x)))
     (consult--async-highlight builder)
     :file-handler nil) ;; do not allow tramp
   :prompt prompt
   :sort nil
   :require-match t
   :initial (consult--async-split-initial initial)
   :add-history (consult--async-split-thingatpt 'filename)
   :category 'file
   :history '(:input consult--find-history)))

(defvar consult--everything-regexp-type nil)

(defun consult--everything-regexp-type (cmd)
  "Return regexp type supported by es CMD."
  (or consult--everything-regexp-type
      (setq consult--everything-regexp-type
            (if (eq 0 (call-process-shell-command
                       (concat cmd " -regextype emacs -version")))
                'emacs 'basic))))

(defun consult--everything-builder (input)
  "Build command line given INPUT."
  (pcase-let* ((cmd (split-string-and-unquote consult-everything-args))
               (type (consult--everything-regexp-type (car cmd)))
               (`(,arg . ,opts) (consult--command-split input))
               (`(,re . ,hl) (funcall consult--regexp-compiler arg type t)))
    (when re
      (list :command
            (append cmd
                    (cdr (mapcan
                          (lambda (x)
                            `(""
                              ,(format ".*%s.*"
                                       ;; HACK Replace non-capturing groups with capturing groups.
                                       ;; GNU find does not support non-capturing groups.
                                       (replace-regexp-in-string
                                        "\\\\(\\?:" "\\(" x 'fixedcase 'literal))))
                          re))
                    opts)
            :highlight hl))))

;;;###autoload
(defun consult-everything (&optional initial)
  "Search for files matching input regexp given INITIAL input."
  (interactive "P")
  (let* ((prompt-dir (consult--directory-prompt "Everything" dir))
         (default-directory (cdr prompt-dir)))
    (find-file (consult--everything (car prompt-dir) #'consult--everything-builder initial))))

(provide 'consult-everything)

;;; consult-everything.el ends here
