#lang scheme/base

(require scheme/file
         scheme/system
         (planet schematics/sake:1))

(define-task compile
  ()
  (action:compile "all-tests.ss"))

(define-task test
  (compile)
  (action:test "all-tests.ss" 'all-tests))

(define-task planet-install
  (test)
  (when (file-exists? "load-test.plt")
    (delete-file "load-test.plt"))
  (make-directory* "build/load-test")
  (system "git checkout-index -a -f --prefix=build/load-test/")
  (parameterize ([current-directory "build/load-test"])
    (action:planet-archive "."))
  (copy-file "build/load-test/load-test.plt" "load-test.plt")
  (delete-directory/files "build/load-test")
  (with-handlers
      ([exn? (lambda (e)
               (printf "Caught exception ~a while uninstalling, but continuing onwards!" e))])
    (action:planet-remove "untyped" "load-test.plt" 1 0))
  (action:planet-install "untyped" "load-test.plt" 1 0))


(define-task all
  (planet-install))

(define-task default
  (all))


