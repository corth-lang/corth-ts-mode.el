;;; corth-ts-mode.el -- tree-sitter major mode for Corth programming language

;;; Commentary:

;;; This major mode was written with the help of these awesome articles:

;;; https://www.masteringemacs.org/article/how-to-get-started-tree-sitter
;;; https://www.masteringemacs.org/article/lets-write-a-treesitter-major-mode


;;; Code:

(require 'treesit)

(defvar corth-mode-syntax-table (make-syntax-table) "Syntax table for Corth files.")

(defvar corth-ts-features
  '((comment doc signature-comment
     keyword intrinsic
     char-literal number-literal string-literal
     constant
     global-definition global-use
     builtin-type)))

(defvar corth-ts-font-lock-rules
  '(
    :language corth :override t :feature keyword
    "[\"include\"
      \"namespace\" \"endnamespace\"
      \"macro\" \"endmacro\"
      \"proc\" \"->\" \"return\"
      \"in\" \"end\"
      \"memory\" \"and\"
      \"let\" \"peek\"
      \"if\" \"else\"
      \"while\" \"do\" \"break\"
      \"cast\"]
     @font-lock-keyword-face"

    :language corth :override t :feature intrinsic
    "(intrinsic) @font-lock-builtin-face"

    :language corth :override t :feature char-literal
    "(char_literal) @font-lock-string-face"

    :language corth :override t :feature number-literal
    "(number_literal) @font-lock-number-face"

    :language corth :override t :feature string-literal
    "(string_literal) @font-lock-string-face"

    :language corth :override t :feature constant
    "(singleton) @font-lock-constant-face"

    :language corth :override t :feature comment
    "[(inline_comment) (multiline_comment)] @font-lock-comment-face"

    :language corth :override t :feature doc
    "([(multiline_comment) (inline_comment)]+ @font-lock-doc-face
      .
      [(proc_definition) (macro_definition) (global_allocation)])"

    :language corth :override t :feature global-definition
    "(proc_definition (name) @font-lock-function-name-face)"

    :language corth :override t :feature global-definition
    "(macro_definition name: (name) @font-lock-function-name-face)"

    :language corth :override t :feature global-definition
    "(global_allocation (name) @font-lock-function-name-face)"

    :language corth :override t :feature signature-comment
    "(proc_definition
       (inline_comment) @font-lock-type-face
       [arg: (builtin_type)
        return: (builtin_type)])"

    :language corth :override t :feature builtin-type
    "(builtin_type) @font-lock-type-face"
    ))

(defun corth-ts-setup ()
  "Setup treesit for corth-ts-mode."

  (setq-local treesit-font-lock-feature-list corth-ts-features)
  (setq-local treesit-font-lock-settings (apply #'treesit-font-lock-rules corth-ts-font-lock-rules))

  ;; todo: (setq-local treesit-simple-indent-rules html-ts-indent-rules)

  (treesit-major-mode-setup))

;;;###autoload
(define-derived-mode corth-ts-mode prog-mode "corth"
  "Major mode for Corth files, using the tree-sitter library."
  :group 'corth
  :syntax-table text-mode-syntax-table

  (setq-local font-lock-defaults nil)
  (when (treesit-ready-p 'corth)
    (treesit-parser-create 'corth)
    (corth-ts-setup)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.corth\\'" . corth-ts-mode))


(provide 'corth-ts-mode)

;;; corth-ts-mode.el ends here
