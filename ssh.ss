;;;
;;; Time-stamp: <2009-07-29 10:52:17 noel>
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
         scheme/system)

;; struct result : Integer Bytes Bytes
(define-struct result (exit-code out err))

;; ssh : string [#:host string] [#:username string] any ... -> (channelof (vector number bytes bytes))
;;
;; Run a ssh process asynchronously. Return a channel that
;; is syncable when the process finishes. The value in the
;; channel is a process-result structure, which contains
;;
;; - the exit code of the process
;; - the contents of stdout
;; - the contents of stderr
(define (ssh command #:host [host "localhost"] #:username [username #f] . args)
  (match-define (list in out pid err inspect)
    (process
     (format "ssh ~a~a ~a ~a"
             (if username (string-append username "@") "")
             host
             command
             (apply string-append
                    (for/list ([arg (in-list args)])
                              (format "'~a' " arg))))))
  (define chan (make-channel))
  (define thd
    (thread
     (lambda ()
       (inspect 'wait)
       (let ([exit-code (inspect 'exit-code)]
             [stdout (read-all-bytes in)]
             [stderr (read-all-bytes err)])
         (close-input-port in)
         (close-output-port out)
         (close-input-port err)
         (channel-put chan (make-result exit-code stdout stderr))))))
  chan)


;; read-all-bytes : input-port -> bytes
(define (read-all-bytes port)
  (apply bytes-append
         (let loop ()
           (let* ([buf (make-bytes 4096)]
                  [result (read-bytes-avail! buf port)])
             (cond
              [(eof-object? result) null]
              [(= 4096 result) (cons buf (loop))]
              [else (list (subbytes buf 0 result))])))))


(provide
 (struct-out result)
 ssh

 read-all-bytes)