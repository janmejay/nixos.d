
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load-file "~/.emacs.d/emacs.el")

(put 'narrow-to-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode nil nil (cua-base))
 '(ecb-options-version "2.40")
 '(ecb-source-path (find-all-emacs-projects))
 '(ecb-tip-of-the-day nil)
 '(ecb-windows-width 0.2)
 '(gdb-many-windows t)
 '(highlight-current-line-globally t)
 '(jde-gen-k&r t)
 '(jde-jdk-registry '(("1.6" . "/usr/local/jdk_1_6/bin/java")))
 '(package-selected-packages
   '(company-coq "company-coq" proof-general helm-ag helm-projectile))
 '(safe-local-variable-values
   '((eval setq ac-clang-flags
      (let*
          ((cppdefs
            '(("_SCONS" . "1")
              ("MONGO_EXPOSE_MACROS" . "1")
              ("SUPPORT_UTF8" . "1")
              ("_FILE_OFFSET_BITS" . "64")
              ("_DEBUG" . "1")
              ("BOOST_ALL_NO_LIB" . "1")
              ("MONGO_HAVE_HEADER_UNISTD_H" . "1")
              ("MONGO_HAVE_EXECINFO_BACKTRACE" . "1")))
           (project-root
            (expand-file-name
             (locate-dominating-file buffer-file-name ".dir-locals.el")))
           (includes
            '("/" "/mongo" "/third_party/pcre-8.30" "/third_party/boost"))
           (cflags
            '("-pthread" "-Wall" "-Wsign-compare" "-Wno-unknown-pragmas" "-Winvalid-pch" "-Werror"))
           (cxxflags
            '("-Wnon-virtual-dtor" "-Woverloaded-virtual"))
           (cppflags
            (append
             (mapcar
              (lambda
                  (x)
                (concat "-D"
                        (car x)
                        "="
                        (cdr x)))
              cppdefs)
             (mapcar
              (lambda
                  (x)
                (concat "-I" project-root "src" x))
              includes))))
        (append cppflags cflags cxxflags)))
     (eval setq ac-clang-flags
      (let*
          ((cppdefs
            '(("_SCONS" . "1")
              ("MONGO_EXPOSE_MACROS" . "1")
              ("SUPPORT_UTF8" . "1")
              ("_FILE_OFFSET_BITS" . "64")
              ("_DEBUG" . "1")
              ("BOOST_ALL_NO_LIB" . "1")
              ("MONGO_HAVE_HEADER_UNISTD_H" . "1")
              ("MONGO_HAVE_EXECINFO_BACKTRACE" . "1")))
           (project-root
            (expand-file-name
             (locate-dominating-file buffer-file-name ".dir-locals.el")))
           (includes
            '("/" "/mongo" "/third_party/pcre-8.30" "/third_party/boost"))
           (cflags
            '("-pthread" "-Wall" "-Wsign-compare" "-Wno-unknown-pragmas" "-Winvalid-pch" "-Werror"))
           (cxxflags
            '("-Wnon-virtual-dtor" "-Woverloaded-virtual"))
           (cppflags
            (append
             (mapcar
              (lambda
                  (x)
                (concat "-D"
                        (car x)
                        "="
                        (cdr x)))
              cppdefs)
             (mapcar
              (lambda
                  (x)
                (concat "-I" project-root "src" x))
              includes))))
        (append cppflags cflags)))
     (ruby-compilation-executable . "ruby")
     (ruby-compilation-executable . "ruby1.8")
     (ruby-compilation-executable . "ruby1.9")
     (ruby-compilation-executable . "rbx")
     (ruby-compilation-executable . "jruby")))
 '(semanticdb-default-file-name ".semantic.cache")
 '(semanticdb-default-save-directory "~/.emacs.d/.semantic")
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width expanded :foundry "unknown" :family "DejaVu Sans Mono")))))
