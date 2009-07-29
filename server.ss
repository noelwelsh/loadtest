;;;
;;; Time-stamp: <2009-07-29 10:52:27 noel>
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
         "config-file.ss"
         "ssh.ss")

;; main : (U String Path) -> Void
(define (main config-file)
  (define-values/invoke-unit (read-config-file config-file)
    (import)
    (export config^))
  (define-values/invoke-unit server@
    (import config^)
    (export server^))
  (make-data-collection-server config-file))

;; mzscheme-run-client-cmd : (U String Path) -> String
(define (mzscheme-run-client-cmd mzscheme-path config-file)
  (format "~a/mzscheme -p 'untyped/load-test:1/client' --main ~a"
          mzscheme-path
          (path->string (path->complete-path config-file))))

;; run-remote-client : String String String -> Channel
(define (run-remote-client host mzscheme-path config-file)
  (ssh (mzscheme-run-client-cmd mzscheme-path config-file) #:host host))


(define-unit server@
  (import config^)
  (export server^)

  ;; make-data-collection-server : (U String Path) -> Void
  (define (make-data-collection-server config-file)
    (define n-clients (length client-hosts))
    (define ssh-channels
      (map (lambda (host)
             (run-remote-client host mzscheme-path config-file))
           client-hosts))
    (define listener (tcp-listen data-collection-server-port))
    (define accept-evt (tcp-accept-evt listener))

    (display "Clients started. Waiting for results.\n")
    (let loop ([n-results 0] [results null])
      (if (= n-results n-clients)
          (begin
            (display "All results received.\n")
            (tcp-close listener)
            (report-results results))
          (match (apply sync accept-evt ssh-channels)
                 [(list in out)
                  (display "Results received.\n")
                  (loop (add1 n-results) (cons (read-all-bytes in) results))]
                 [(struct result (exit-code out err))
                  (printf "SSH Process returned with exit code ~a\n" exit-code)
                  (printf "stdout:\n~a\n" out)
                  (printf "stderr:\n~a\n" err)
                  (loop n-results results)]))))

  (define (report-results results)
    (display results))
  )


(provide main
         server@)