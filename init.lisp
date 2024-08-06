(in-package :stumpwm)

(ql:quickload :slynk)

;; start server for sly
(defcommand jacob-open-connection () ()
  (slynk:create-server :dont-close t))

;; set prefix key
(set-prefix-key (kbd "s-t"))

;; toggle stumpwm modeline
(toggle-mode-line (current-screen)
                  (current-head))

;; parameters

(defparameter *jacob-browser* "firefox"
  "Browser program to use.")

;; (setq *jacob-browser* "google-chrome")

;; commands

;; JACOBTODO: support multiple browsers with one command
(defcommand jacob-browser () ()
  "Run or raise the browser."
  (run-or-raise *jacob-browser* '(:role "browser")))

(defcommand jacob-terminal () ()
  "Run or raise the terminal."
  (run-or-raise "xfce4-terminal" '(:class "Xfce4-terminal")))

(defcommand jacob-vertical-split () ()
  "Vertically split the screen showing the browser and emacs."
  (if (only-one-frame-p)
      (progn
        (emacs)
        (hsplit)
        (move-focus :right)
        (jacob-browser))
      (only)))

;; keybinds
(define-key *top-map* (kbd "s-1") "emacs")
(define-key *top-map* (kbd "s-2") "jacob-browser")
(define-key *top-map* (kbd "s-3") "jacob-vertical-split")
(define-key *top-map* (kbd "s-4") "jacob-terminal")
(define-key *top-map* (kbd "s-k") "delete")

;; add date/time to mode line
(setq *time-modeline-string* "^B%H:%M^b %d/%m/%y")
(setq *screen-mode-line-format* (list "[^B%n^b] %W ^> %d"))
(setq *mode-line-timeout* 10)

;; make mouse change focused window
(setq *mouse-focus-policy* :sloppy)


;; modules

;; git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/modules


;; battery
(load-module "battery-portable")

(unless (member " %B" *screen-mode-line-format* :test #'string=)
  (nconc *screen-mode-line-format* '(" %B")))


;; view current network connection
(load-module "wifi")

(unless (member " %I" *screen-mode-line-format* :test #'string=)
  (nconc *screen-mode-line-format* '(" %I")))


;; third party modules

;; git clone https://github.com/Junker/stumpwm-pamixer ~/.stumpwm.d/modules/pamixer
;; sudo apt install pamixer

(add-to-load-path "~/.stumpwm.d/modules/pamixer")
(load-module "pamixer")

(unless (member " %P" *screen-mode-line-format* :test #'string=)
  (nconc *screen-mode-line-format* '(" %P")))

