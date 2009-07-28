#lang scheme/base

(require (prefix-in client: "client.ss")
         (prefix-in server: "server.ss"))

(define config "config.ss")

(define server (thread (lambda () (server:main config))))

(for ([i (in-range 5)])
     (printf "Starting client ~a\n" i)
     (thread (lambda () (client:main config))))

(sync server)