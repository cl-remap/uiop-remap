;;
;;  uiop-remap  -  UIOP interface to REMAP.
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :common-lisp-user)

;;  All reusable URIs and paths should go here

(defpackage :remap.uri)

;;  Here we control data remapping

(defpackage :remap
  (:use :babel-stream
        :cl
        :cl-stream
        :local-time
        :remap.uri
        :rollback
        :split-sequence
        :unistd-stream)
  #.(cl-stream:shadowing-import-from)
  (:export #:*hooks*
           #:*remap*
           #:cd
           #:cwd
           #:from
           #:ftp
           #:http
           #:html
           #:ls
           #:pwd
           #:shell
           #:sync
           #:to
           #:uiop))
