;;
;;  uiop-remap  -  UIOP interface to REMAP.
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :common-lisp-user)

(defpackage :uiop-remap
  (:use :cl
        :cl-stream
        :remap)
  #.(cl-stream:shadowing-import-from)
  (:export #:*uiop-remap*
           #:uiop-remap))
