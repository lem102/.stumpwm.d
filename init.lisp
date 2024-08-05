(in-package :stumpwm)

;; to start server for sly
;; (ql:quickload :slynk)
;; (slynk:create-server :dont-close t)

;; set prefix key
(set-prefix-key (kbd "s-t"))

;; toggle stumpwm modeline
(toggle-mode-line (current-screen)
                  (current-head))

;; commands
(defcommand jacob-firefox () ()
  "Run or raise firefox."
  (run-or-raise "firefox" '(:class "Firefox")))

(defcommand jacob-terminal () ()
  "Run or raise the terminal."
  (run-or-raise "xfce4-terminal" '(:class "Xfce4-terminal")))

;; keybinds
(define-key *top-map* (kbd "s-1") "emacs")
(define-key *top-map* (kbd "s-2") "jacob-firefox")
(define-key *top-map* (kbd "s-4") "jacob-terminal")
(define-key *top-map* (kbd "s-k") "delete")

;; add date/time to mode line
(setq *time-modeline-string* "%H:%M %d/%m/%y")
(setq *screen-mode-line-format* (list "[^B%n^b] %W | %d"))
(setq *mode-line-timeout* 10)

;; make mouse change focused window
(setq *mouse-focus-policy* :sloppy)

;; system tray

;; git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/modules
;; sudo apt install pasystray

(load-module "stumptray")
(stumptray::stumptray)

(run-shell-command "pasystray")

;; JACOBTODO: create vertical split between emacs and browser

