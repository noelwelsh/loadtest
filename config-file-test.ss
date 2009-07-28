#lang scheme/base

(require scheme/unit
         (planet schematics/schemeunit:3/test)
         (only-in "base.ss" config^)
         "config-file.ss")

(define/provide-test-suite config-file-tests
  (test-case
   "read-config-file returns expected results"
   (let ([config (read-config-file "config.ss")])
     (define-values/invoke-unit config (import) (export config^))
     (check string=? data-collection-server-host "localhost")
     (check = data-collection-server-port 4578)
     (check-equal? client-hosts (list "localhost" "localhost"))
     (check = client-n-threads 50)
     (check = client-thread-start-delay 1)))
  )