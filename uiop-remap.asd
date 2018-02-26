;;
;;  uiop-remap  -  UIOP interface to REMAP.
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :common-lisp-user)

(defpackage :uiop-remap.system
  (:use :cl :asdf))

(in-package :uiop-remap.system)

(defsystem :uiop-remap
  :name "uiop-remap"
  :author "Thomas de Grivel <thoxdg@gmail.com> +33614550127"
  :version "0.1"
  :description "UIOP interface to REMAP."
  :depends-on ("remap"
               "uiop")
  :components
  ((:file "package")
   (:file "uiop" :depends-on ("package"))))
