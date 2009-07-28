;;;
;;; Time-stamp: <2009-07-28 17:12:47 noel>
;;;
;;; Copyright (C) by Noel Welsh. 
;;;

;;; This library is free software; you can redistribute it
;;; and/or modify it under the terms of the GNU Lesser
;;; General Public License as published by the Free Software
;;; Foundation; either version 2.1 of the License, or (at
;;; your option) any later version.

;;; This library is distributed in the hope that it will be
;;; useful, but WITHOUT ANY WARRANTY; without even the
;;; implied warranty of MERCHANTABILITY or FITNESS FOR A
;;; PARTICULAR PURPOSE.  See the GNU Lesser General Public
;;; License for more details.

;;; You should have received a copy of the GNU Lesser
;;; General Public License along with this library; if not,
;;; write to the Free Software Foundation, Inc., 59 Temple
;;; Place, Suite 330, Boston, MA 02111-1307 USA

;;; Author: Noel Welsh <noelwelsh@yahoo.com>
;;
;;
;; Commentary:

#lang scheme/base

(require scheme/port
         scheme/system
         (planet schematics/schemeunit:3/test)
         "ssh.ss")

;; You need to have public key based login on your local machine for this to work.
;; The following should work to set this up:
;; - Run ssh-keygen. Give it a good password
;; - cd .ssh ; cat id_rsa.pub > authorized_keys
;; - ssh-add id_rsa
;;
;; You must protect the id_rsa file -- anyone who can access
;; it (and knowns your password) can impersonate you.

(define/provide-test-suite ssh-tests
  (test-case
   "ssh correctly captures stdout"
   (check-equal? (result-out (channel-get (ssh "uname")))
                 (with-output-to-bytes (lambda () (system "uname")))))
  (test-case
   "ssh captures exit code"
   (check-false (zero? (result-exit-code (channel-get (ssh "foo"))))))
  )