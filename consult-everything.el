;;; consult-everything.el --- Everything integration with Consult -*- lexical-binding: t; -*-

;; Copyright (C) John Haman 2022
;; Author: John Haman <mail@johnhaman.org>
;; Homepage: https://github.com/jthaman/consult-everything
;; Package-Requires: ((emacs "25.1") (consult "0.15"))
;; Version: 0.2

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This package provides Everything integration with the Emacs program
;; `consult'. Download the Everything command line tool, es.exe, from
;; https://www.voidtools.com/downloads/#cli.
;;
;; Everything is a useful `locate' alternative on Windows machines.

;;; License:

;; This program is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later
;; version.

;; This program is distributed in the hope that it will be useful, but WITHOUT ANY
;; WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
;; PARTICULAR PURPOSE. See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License along with
;; this program. If not, see <https://www.gnu.org/licenses/>.

;;; Code:

(require 'consult)

(defcustom consult-everything-args
  "es -r"
  "Command line arguments for everything, see `consult-everything'.

The default value is \"es -r\", which only works if you place the command line version of Everything (es.exe) in your PATH."
  :type 'string)

(defun consult--everything-builder (input)
  "Build command line from INPUT."
  (pcase-let ((`(,arg . ,opts) (consult--command-split input)))
    (unless (string-blank-p arg)
      (cons (append (consult--build-args consult-everything-args)
                    (consult--split-escaped arg) opts)
            (cdr (consult--default-regexp-compiler input 'basic t))))))

;;;###autoload
(defun consult-everything (&optional initial)
  "Search with `everything' for files matching input regexp given INITIAL input."
  (interactive)
  (find-file (consult--find "Everything: " #'consult--everything-builder initial)))

(provide 'consult-everything)

;;; consult-everything.el ends here
