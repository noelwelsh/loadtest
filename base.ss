;;;
;;; Time-stamp: <2009-07-28 21:56:45 noel>
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

(require scheme/unit)

(define-struct (exn:load-test exn) ())

;; Messages from a client thread
;; struct fail : exn
(define-struct fail (reason) #:prefab)
;; struct error : number
(define-struct error (status-code) #:prefab)
;; struct success : number
(define-struct success (time) #:prefab)


(define-signature client^
  (make-client-server ;; (-> Void)
   ))

(define-signature server^
  (make-data-collection-server ;; (-> Void)
   ))

(define-signature config^
  (data-collection-server-host ;; String
   data-collection-server-port ;; Integer

   mzscheme-path ;; String
   
   client-hosts ;; (Listof String)

   client-n-threads ;; Integer
   client-thread-start-delay ;; Number
   client-action ;; (-> TimedResponse)
   ))

(provide
 (struct-out exn:load-test)
 (struct-out fail)
 (struct-out error)
 (struct-out success)

 client^
 server^
 config^)