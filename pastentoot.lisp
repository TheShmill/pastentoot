;;;; pastentoot.lisp

(in-package #:pastentoot)

(defvar *acceptor* (make-instance 'hunchentoot:easy-acceptor))

(defun start ()
  (hunchentoot:start *acceptor*))

(defun stop ()
  (hunchentoot:stop *acceptor*))

(defmacro site-template (body)
  `(spinneret:with-html-string
    (:html
     (:head
      (:title "Pastentoot"))
     (:body
      (:h1 "Pastentoot")
      ,body))))

(hunchentoot:define-easy-handler (home :uri "/") ()
  (site-template
   (:a :href "/create" (:h2 "Make a paste"))))

(hunchentoot:define-easy-handler (create :uri "/create") ()
  (site-template
   (:form :action "/new" :method "POST"
    (:textarea :name "paste" :cols 50 :rows 10 :maxlength 2000 :autofocus t :required t)
    (:br)
    (:input :type "submit"))))

(hunchentoot:define-easy-handler (new :uri "/new") ((paste :request-type :post))
  (setf (hunchentoot:content-type*) "text/plain")
  (format nil "~a" paste))
