;;;; pastentoot.asd

(asdf:defsystem #:pastentoot
  :author "Shmill"
  :version "0.0.1"
  :serial t
  :depends-on (#:hunchentoot)
  :components ((:file "package")
               (:file "pastentoot")))
