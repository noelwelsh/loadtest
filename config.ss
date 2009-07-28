;;;
;;; Time-stamp: <2009-07-28 14:49:06 noel>
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

(require (planet untyped/http-client:1))

(define data-collection-server-host "localhost")
(define data-collection-server-port 4578)


(define n-clients 5)


(define client-n-threads 50)
(define client-thread-start-delay 1)
(define client-action
  (lambda ()
    (begin
      (get "http://localhost/"))))

(provide
 data-collection-server-host
 data-collection-server-port

 n-clients
 
 client-n-threads
 client-thread-start-delay
 client-action)