;;;
;;; Time-stamp: <2009-07-28 14:16:26 noel>
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

;; read-config-file : (U path string) -> config@
(define (read-config-file file-name)
  (define data-collection-server-host
    (dynamic-require file-name 'data-collection-server-host))
  (define data-collection-server-port
    (dynamic-require file-name 'data-collection-server-port))
  (define n-clients (dynamic-require file-name 'n-clients))
  (define client-n-threads (dynamic-require file-name 'client-n-threads))
  (define client-thread-start-delay (dynamic-require file-name 'client-thread-start-delay))
  (define client-action (dynamic-require file-name 'client-action))

  (unit-from-context config^))

(provide read-config-file)