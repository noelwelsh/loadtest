#lang scheme/base

(require "config.ss"
         "client.ss"
         "server.ss")

(define data-collection-server (thread make-data-collection-server))

(for ([i (in-range n-clients)])
     (printf "Starting client ~a\n" i)
     (thread make-client-server))

(sync data-collection-server)