;;;; pastentoot.lisp

(in-package #:pastentoot)

(defvar *acceptor* (make-instance 'hunchentoot:easy-acceptor))

(defun start ()
  (hunchentoot:start *acceptor*))

(defun stop ()
  (hunchentoot:stop *acceptor*))
