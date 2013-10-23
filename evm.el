;;; evm.el --- Emacs version manager

;; Copyright (C) 2013 Johan Andersson

;; Author: Johan Andersson <johan.rejeep@gmail.com>
;; Maintainer: Johan Andersson <johan.rejeep@gmail.com>
;; Version: 0.2.0
;; URL: http://github.com/rejeep/evm.el
;; Package-Requires: ((s "1.7.0") (dash "2.1.0") (f "0.7.1") (commander "0.5.0"))

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;; Avoid "Loading vc-git..." messages
(remove-hook 'find-file-hooks 'vc-find-file-hook)

;; Avoid "ls does not support --dired; see `dired-use-ls-dired' for
;; more details." messages
(setq dired-use-ls-dired nil)

(require 'f)
(require 's)
(require 'dash)
(require 'commander)

(defvar evm-path
  (f-expand ".evm" (getenv "HOME")))

(defvar evm-emacs-path
  (f-expand ".evm" user-emacs-directory))

(defvar evm-scripts-path
  (f-expand "scripts" evm-path))

(defvar evm-installations-path
  (f-expand "installations" evm-path))

(defvar evm-cache-path
  (f-expand "cache" evm-path))

(defvar evm-tars-path
  (f-expand "tars" evm-path))

(defvar evm-force nil
  "Force installation if true.")

(defvar evm-emacs
  (when (f-file? evm-emacs-path)
    (s-trim (f-read-text evm-emacs-path 'utf-8))))

(defun evm-find (file)
  "Find FILE in the currently selected Emacs installation."
  (-first-item
   (f-files
    (evm--installation-path)
    (lambda (path)
      (equal (f-filename path) file))
    :recursive)))

(defun evm--ok (format-string &rest objects)
  (princ (apply 'format (concat format-string "\n") objects)))

(defun evm--fail (format-string &rest objects)
  (apply 'message format-string objects)
  (kill-emacs 1))

(defun evm--installation-path ()
  (f-expand evm-emacs evm-installations-path))

(defun evm--validate-version (version)
  (unless (f-file? (f-expand version evm-scripts-path))
    (error "Invalid version %s" version)))

(defun evm--installed? (version)
  (f-dir? (f-expand version evm-installations-path)))

(defun evm--osx? ()
  (f-dir? (f-expand "Emacs.app" (evm--installation-path))))

(defun evm--clean (version)
  "Clean out installation, cache and tar of VERSION."
  (let ((installation (f-expand version evm-installations-path))
        (cache (f-expand version evm-cache-path))
        (tar (f-expand (concat version ".tar.bz2") evm-tars-path)))
    (dolist (file (list installation cache tar))
      (when (f-exists? file)
        (f-delete file :force)))))

(defun evm/force ()
  (setq evm-force t))

(defun evm/help ()
  (commander-print-usage-and-exit))

(defun evm/install (version)
  (evm--validate-version version)
  (when (evm--installed? version)
    (if evm-force
        (evm--clean version)
      (error "Already installed %s" version)))
  (let* ((script (f-expand version evm-scripts-path))
         (buffer (get-buffer-create "*evm*"))
         (process (start-process version buffer script)))
    (set-process-filter
     process
     (lambda (process string)
       (princ string)))
    (while (accept-process-output process))
    (evm--ok "Successfully installed %s" version)))

(defun evm/uninstall (version)
  (evm--validate-version version)
  (unless (or evm-force (evm--installed? version))
    (evm--fail "Version %s not installed" version))
  (evm--clean version)
  (evm--ok "Successfully uninstalled %s" version))

(defun evm/use (version)
  (evm--validate-version version)
  (setq evm-emacs (f-write-text version 'utf-8 evm-emacs-path)))

(defun evm/list ()
  (-each
   (-map 'f-filename (f-files evm-scripts-path))
   (lambda (directory)
     (when (equal evm-emacs directory)
       (princ "* "))
     (princ directory)
     (when (evm--installed? directory)
       (princ " [I]"))
     (princ "\n"))))

(defun evm/bin (&optional name)
  (let ((evm-emacs (or name evm-emacs)))
    (princ
     (if (evm--osx?)
         (f-join (evm--installation-path) "Emacs.app" "Contents" "MacOS" "Emacs")
       (f-join (evm--installation-path) "bin" "emacs")))))

(commander
 (name "evm")
 (description "Emacs Version Manger")

 (command "install <version>" "Install version" evm/install)
 (command "uninstall <version>" "Uninstall version" evm/uninstall)
 (command "use <version>" "Use version" evm/use)
 (command "list" "List all versions" evm/list)
 (command "bin [name]" "Return path to current or specified Emacs installation binary" evm/bin)

 (option "-h, --help" "Show usage information" evm/help)
 (option "--force" "Force install/uninstall version." evm/force))

(provide 'evm)

;;; evm.el ends here
