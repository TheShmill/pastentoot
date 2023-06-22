;;;; pastentoot.lisp

(in-package #:pastentoot)

(defvar *acceptor* (make-instance 'hunchentoot:easy-acceptor))

(defun start ()
  (mito:connect-toplevel :sqlite3 :database-name #P"paste.db")
  (mito:ensure-table-exists 'paste)
  (hunchentoot:start *acceptor*))

(defun stop ()
  (mito:disconnect-toplevel)
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

(hunchentoot:define-easy-handler (view :uri "/view") (code)
  (let ((paste (mito:find-dao 'paste :code code)))
    (setf (hunchentoot:content-type*) "text/plain")
    (paste-content paste)))

(hunchentoot:define-easy-handler (new :uri "/new") ((paste :request-type :post))
  (let ((code (generate-code)))
    (mito:create-dao 'paste :content paste :code code)
    (format nil "~a" code)))

(defun generate-code ()
  (let ((result (make-string 8)))
    (loop :for i :from 0 :to 7
          :for char = (code-char (+ 97 (random 26)))
          :do (setf (elt result i) char))
    result))

(mito:deftable paste ()
  ((code :col-type :text)
   (content :col-type :text)))
