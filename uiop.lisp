;;
;;  remap - modular transactional file system in Common Lisp
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :remap)

(defclass uiop (remap)
  ())

(defvar *remap-uiop*
  (make-instance 'uiop))

(defparameter *remap*
  *remap-uiop*)

(defmethod remap-cwd ((remap uiop))
  (namestring (uiop:getcwd)))

(defmethod remap-dir ((remap uiop) (path string) (sort null)
                      (order null))
  (let ((wild (or (when (wild-pathname-p path)
                    path)
                  (make-pathname :name :wild :type :wild
                                 :directory path))))
    (mapcar (lambda (x) (enough-namestring x path))
            (directory wild))))

(defun absolute-dir! (&optional path)
  (let ((abs (absolute path)))
    (or (uiop:directory-exists-p abs)
        (error "No such directory: ~S" path))))

(defmethod remap-home ((remap uiop) (user null))
  (user-homedir-pathname))

(defmethod remap-cd ((remap uiop) (directory string))
  (let ((abs (absolute-dir! directory)))
    (uiop:chdir abs)
    (values)))

(defun compute-direction (read write)
  (cond ((and read write) :io)
        (read :input)
        (write :output)))

(defmethod remap-open ((remap uiop) (path string)
                       &key read write append create &allow-other-keys)
  (cl:open path
           :direction (compute-direction read write)
           :element-type '(unsigned-byte 8)))

(defvar *buffer-size* 4096)

(defmethod remap-cat ((remap uiop) &rest paths)
  (dolist (p paths)
    (let ((abs (absolute-or-wild! p)))
      (if (wild-pathname-p abs)
          (apply #'remap-cat remap (remap-dir remap abs 'name '<))
          (with-open-file (f abs :element-type 'character)
            (let* ((s (make-string *buffer-size*))
                   (r (read-sequence s f)))
              (write-sequence s *standard-output* :end r)))))))

(defvar *fds*
  '())

(deftype mode () 'fixnum)

#+nil
(defmethod open (path &key append create exclusive non-blocking read
                        truncate write)
  (declare (type boolean append exclusive non-blocking read truncate write)
           (type (or null mode) create))
  )

(defun cat (&rest inputs &key (> #\-))
  (values > inputs))
