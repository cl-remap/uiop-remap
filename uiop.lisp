;;
;;  uiop-remap  -  UIOP interface to REMAP.
;;  Thomas de Grivel <thoxdg@gmail.com> +33614550127
;;

(in-package :uiop-remap)

(defclass uiop (remap)
  ())

(defvar *remap*
  (make-instance 'uiop))

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
  (let* ((direction (compute-direction read write))
         (stream (cl:open path :direction direction
                          :element-type '(unsigned-byte 8)
                          :if-does-not-exist (when create :create))))
    (unless (null append)
      (file-position stream (file-length stream)))
    stream))

(defvar *buffer-size* 4096)

(defmethod remap-cat ((remap uiop) &rest paths)
  (dolist (p paths)
    (let ((abs (absolute-or-wild! p)))
      (if (wild-pathname-p abs)
          (apply #'remap-cat remap (remap-dir remap abs 'name '<))
          (with-open-file (file abs :element-type 'character)
            (let* ((str (make-string *buffer-size*))
                   (len (read-sequence str :stream file)))
              (write-sequence str
                              :stream *standard-output*
                              :end len)))))))
