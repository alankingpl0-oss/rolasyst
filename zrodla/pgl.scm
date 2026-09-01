#|
   Interpreter PingLang
   Rozszerzenie plików: *.pgl
   (O> Pingwiny przejmują kontrolę nad kodem! <O)
|#

(import (chicken io))
(import srfi-1)

#| Lekser (rozbija kod na tokeny i ignoruje blokowe komentarze typu [ ... ]) |#
(define (tokenize chars)
  (let loop ((c chars) (tokens '()))
    (cond
      ((null? c) (reverse tokens))
      ((char-whitespace? (car c)) (loop (cdr c) tokens))

      #| Obsługa komentarzy w PingLang: [ treść komentarza... ] |#
      ((char=? (car c) #\[)
       (let skip-comment ((cc (cdr c)))
         (cond
           ((null? cc) (loop cc tokens))
           ((char=? (car cc) #\]) (loop (cdr cc) tokens))
           (else (skip-comment (cdr cc))))))

      #| Znaki specjalne języka |#
      ((char=? (car c) #\() (loop (cdr c) (cons 'lparen tokens)))
      ((char=? (car c) #\)) (loop (cdr c) (cons 'rparen tokens)))
      ((char=? (car c) #\;) (loop (cdr c) (cons 'semi tokens)))
      ((char=? (car c) #\,) (loop (cdr c) (cons 'comma tokens)))

      #| Łańcuchy znaków (argumenty wewnątrz cudzysłowów) |#
      ((char=? (car c) #\")
       (let str-loop ((cc (cdr c)) (acc '()))
         (cond
           ((null? cc) (loop cc tokens))
           ((char=? (car cc) #\") (loop (cdr cc) (cons `(string . ,(list->string (reverse acc))) tokens)))
           (else (str-loop (cdr cc) (cons (car cc) acc))))))

      #| Nazwy funkcji (np. karm_pingwina) |#
      ((or (char-alphabetic? (car c)) (char=? (car c) #\_))
       (let ident-loop ((cc c) (acc '()))
         (if (and (not (null? cc))
                  (or (char-alphabetic? (car cc))
                      (char-numeric? (car cc))
                      (char=? (car cc) #\_)))
             (ident-loop (cdr cc) (cons (car cc) acc))
             (loop cc (cons `(ident . ,(list->string (reverse acc))) tokens)))))
      (else (loop (cdr c) tokens)))))

#| Ewaluator rozczytujący tokeny i wywołujący akcje |#
(define (parse-and-eval tokens)
  (let loop ((t tokens))
    (unless (null? t)
      (if (and (pair? (car t)) (eq? (caar t) 'ident))
          (let* ((func-name (cdar t))
                 (rest1 (cdr t)))
            (if (and (not (null? rest1)) (eq? (car rest1) 'lparen))
                #| Przetwarzanie argumentów |#
                (let arg-loop ((rest2 (cdr rest1)) (args '()))
                  (cond
                    ((null? rest2) (print "Błąd: urwano kod w połowie! Można to było zwalić koncertowo."))
                    ((eq? (car rest2) 'rparen)
                     (if (and (not (null? (cdr rest2))) (eq? (cadr rest2) 'semi))
                         (begin
                           (execute-func func-name (reverse args))
                           (loop (cddr rest2)))
                         (print "Błąd składni: Brakuje średnika na końcu wywołania " func-name "!")))
                    ((eq? (car rest2) 'comma) (arg-loop (cdr rest2) args))
                    ((pair? (car rest2)) (arg-loop (cdr rest2) (cons (cdar rest2) args)))
                    (else (print "Błąd w argumentach."))))
                (print "Błąd składni: Oczekiwano znaku '(' po nazwie funkcji.")))
          (loop (cdr t))))))

#| Biblioteka standardowa PingLang |#
(define (execute-func name args)
  (cond
    ((string=? name "print")
       (for-each display args)
       (newline))
    ((string=? name "karm_pingwina")
       (print "(O> Nom nom nom... Zjadłem " (if (null? args) "nic" (car args)) "! Dziękuję!"))
    ((string=? name "idz_do_wody")
       (print "Plusk! Pingwin zanurkował pod lód."))
    (else
       (print "Błąd: Interpreter nie zna polecenia '" name "'. Zwalone koncertowo!"))))

#| Funkcja ładująca kod z pliku z rozszerzeniem .pgl |#
(define (run-pgl filename)
  (let* ((content (with-input-from-file filename read-string))
         (tokens (tokenize (string->list content))))
    (parse-and-eval tokens)))

#| Zostawiam tu zakomentowane wywołanie testowe. |#
#| Użyj tego, podając ścieżkę do swojego pliku w środowisku testowym. |#
#| (run-pgl "test.pgl") |#