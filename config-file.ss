;;;
;;; Time-stamp: <2009-07-28 21:45:26 noel>
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

(require scheme/unit
         "base.ss")

(define (require-config file-name id)
  (define-values (base name _) (split-path file-name))
  (parameterize ([current-directory (if (eq? base 'relative)
                                        (current-directory)
                                        base)])
    (dynamic-require (path->string name) id)))

;; read-config-file : (U path string) -> config@
(define (read-config-file file-name)
  (define data-collection-server-host
    (require-config file-name 'data-collection-server-host))
  (define data-collection-server-port
    (require-config file-name 'data-collection-server-port))
  (define client-hosts (require-config file-name 'client-hosts))
  (define client-n-threads (require-config file-name 'client-n-threads))
  (define client-thread-start-delay (require-config file-name 'client-thread-start-delay))
  (define client-action (require-config file-name 'client-action))

  (unit-from-context config^))

(provide read-config-file)