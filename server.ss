;;;
;;; Time-stamp: <2009-07-28 14:56:43 noel>
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

(require scheme/match
         scheme/tcp
         scheme/unit
         "base.ss"
         "config-file.ss")
;; main : (U string path) -> void
(define (main config-file)
  (define-values/invoke-unit (read-config-file config-file)
    (import)
    (export config^))
  (define-values/invoke-unit server@
    (import config^)
    (export server^))
  (make-data-collection-server))


(define-unit server@
  (import config^)
  (export server^)
  
  (define (make-data-collection-server)
    (define listener (tcp-listen data-collection-server-port))
    (define mailbox (thread-receive-evt))
  
    (let loop ([n-results 0] [results null])
      (if (= n-results n-clients)
          (begin
            (tcp-close listener)
            (report-results results))
          (match (sync (tcp-accept-evt listener))
                 [(list in out)
                  (loop (add1 n-results) (cons (read in) results))]))))

  (define (report-results results)
    (display results))
  )


(provide main
         server@)