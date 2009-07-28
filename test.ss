#lang scheme/base

(require (prefix-in client: "client.ss")
         (prefix-in server: "server.ss"))

(define config "config.ss")

(server:main config)
