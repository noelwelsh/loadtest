;;;
;;; Time-stamp: <2009-07-28 22:17:40 noel>
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

(require scheme/path
         scheme/port
         scheme/system
         (planet untyped/http-client:1))

(define data-collection-server-host "localhost")
(define data-collection-server-port 4578)

(define mzscheme-path
  (let ([str (with-output-to-string (lambda () (system "which mzscheme")))])
    (if (zero? (string-length str))
        ;; We're running in a noninteractive shell and
        ;; relying on the server to send us the path
        str
        ;; String will contain a newline that we must trim,
        ;; and then take just the path
        (path-only (substring str 0 (sub1 (string-length str)))))))

(define client-hosts (list "localhost" "localhost"))

(define client-n-threads 50)
(define client-thread-start-delay 1)
(define client-action
  (lambda ()
    (begin
      (get "http://localhost/"))))

(provide
 data-collection-server-host
 data-collection-server-port

 mzscheme-path
 
 client-hosts
 
 client-n-threads
 client-thread-start-delay
 client-action)