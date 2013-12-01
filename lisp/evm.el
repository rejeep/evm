;;; evm.el --- Emacs Version Manager

;; Copyright (C) 2013 Johan Andersson

;; Author: Johan Andersson <johan.rejeep@gmail.com>
;; Maintainer: Johan Andersson <johan.rejeep@gmail.com>
;; Version: 0.2.0
;; URL: http://github.com/rejeep/evm
;; Package-Requires: ((dash "2.3.0") (f "0.13.0"))

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

(require 'f)
(require 'dash)

(defvar evm-local-path (f-join "/" "usr" "local" "evm")
  "Path to EVM local.")

(defun evm--current ()
  "Name of currently selected package."
  (let ((evm-current-path (f-expand "current" evm-local-path)))
    (when (f-file? evm-current-path)
        (f-read evm-current-path))))

(defun evm--installation-path ()
  "Path to currently selected package."
  (f-expand (evm--current) evm-local-path))

(defun evm-find (file)
  "Find FILE in the currently selected Emacs installation."
  (-first-item
   (f-files
    (evm--installation-path)
    (lambda (path)
      (equal (f-filename path) file))
    'recursive)))

(provide 'evm)

;;; evm.el ends here
