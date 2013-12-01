(require 'f)
(require 'ert)

(defvar evm-test/test-path
  (f-dirname (f-this-file)))

(defvar evm-test/root-path
  (f-parent evm-test/test-path))

(defvar evm-sandbox-path
  (f-expand "sandbox" evm-test/test-path))

(defmacro with-sandbox (&rest body)
  `(let ((evm-local-path evm-sandbox-path)
         (default-directory evm-sandbox-path))
     (when (f-dir? evm-sandbox-path)
       (f-delete evm-sandbox-path 'force))
     (f-mkdir evm-sandbox-path)
     (f-write "emacs-test" 'utf-8 "current")
     ,@body))

(require 'evm (f-expand "evm" evm-test/root-path))
