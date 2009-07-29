;;;
;;; Time-stamp: <2009-07-29 10:04:32 noel>
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

(require scheme/tcp
         scheme/unit
         (planet untyped/http-client:1)
         "base.ss"
         "config-file.ss")


;; main : (U string path) -> void
(define (main config-file)
  (define-values/invoke-unit (read-config-file config-file)
    (import)
    (export config^))
  (define-values/invoke-unit client@
    (import config^)
    (export client^))
  (make-client-server))


(define-unit client@
  (import config^)
  (export client^)
  
  (define (make-client-server)
    (define me (current-thread))

    (send-results-to-server
     (let loop ([threads-to-start client-n-threads]
                [threads-running 0]
                [results null]
                [n-results 0]
                [alarm (make-alarm)]
                [mailbox (thread-receive-evt)])
       (cond
        [(= n-results client-n-threads)
         results]
        [(= threads-running client-max-concurrency)
         (let ([result (thread-receive)])
           (loop threads-to-start
                 (sub1 threads-running)
                 (cons result results)
                 (add1 n-results)
                 alarm
                 mailbox))]
        [else
         (let ([evt (sync alarm mailbox)])
           (cond 
            [(eq? evt alarm)
             (make-action-thread me client-action)
             (loop (sub1 threads-to-start)
                   (add1 threads-running)
                   results
                   n-results
                   (if (zero? (sub1 threads-to-start)) never-evt (make-alarm))
                   mailbox)]
            [(eq? evt mailbox)
             (let ([result (thread-receive)])
               (loop threads-to-start
                     (sub1 threads-running)
                     (cons result results)
                     (add1 n-results)
                     alarm
                     mailbox))]))]))))

  (define (make-alarm)
    (alarm-evt (+ (current-inexact-milliseconds) (* 1000 client-thread-start-delay))))
  
  (define (make-action-thread parent action)
    (thread
     (lambda ()
       (thread-send parent 
                    (with-handlers
                        ([exn? (lambda (e) (make-fail e))])
                      (let ([r (client-action)])
                        (if (2xx? (Response-status r))
                            (make-success (TimedResponse-duration r))
                            (make-error (Status-code (Response-status r))))))))))
   

  (define (send-results-to-server results)
    (define-values (in out)
      (tcp-connect data-collection-server-host data-collection-server-port))
    (display results out)
    (close-output-port out)
    (close-input-port in))
  )


(provide main
         client@)