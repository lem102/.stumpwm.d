(in-package :stumpwm-user)

(ql:quickload :slynk)

;; start server for sly
(defcommand jacob-open-connection () ()
  (slynk:create-server :dont-close t))

;; set prefix key
(set-prefix-key (kbd "s-t"))

;; parameters

(defparameter *jacob-browser* "firefox"
  "Browser program to use.")

;; (setq *jacob-browser* "google-chrome")

;; JACOBTODO: steal this idea https://github.com/alezost/stumpwm-config/blob/0e6877778d36148f3be53dbe1f81404f2892963f/utils.lisp#L365

(defun jacob-executable-exists? (name)
  "Return t, if NAME executable exists in PATH.

Stolen from https://github.com/alezost/stumpwm-config/blob/0e6877778d36148f3be53dbe1f81404f2892963f/utils.lisp#L27"
  (zerop
   (nth-value 2
              (uiop:run-program (concat "command -v " name)
                                :force-shell t
                                :ignore-error-status t))))

;; commands

;; JACOBTODO: support multiple browsers with one command
(defcommand jacob-browser () ()
  "Run or raise the browser."
  (run-or-raise *jacob-browser* '(:role "browser")))

(defcommand jacob-terminal () ()
  "Run or raise the terminal."
  (run-or-raise "xfce4-terminal" '(:class "Xfce4-terminal")))

;; JACOBTODO: windows don't appear in correct place when running from
;; window that isn't emacs/browser
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
(setq *time-modeline-string* "^8*%H:%M %d/%m/%y^n")
(setq *screen-mode-line-format* (list "[^8*%n^n] %W ^> %d"))
(setq *mode-line-timeout* 2)

;; `modus-vivendi', is that you?
(setq *mode-line-background-color* "#323232")
(setq *mode-line-border-color* "#a8a8a8")

(setq *colors* `("black"
                 "red"
                 "green"
                 "yellow"
                 "blue"
                 "magenta"
                 "cyan"
                 "white"
                 "white"))              ; extra white is to be used
                                        ; for emphasis instead of
                                        ; bright


;; activate the mode line

(defun jacob-setup-modeline (&key
                               (foreground *mode-line-foreground-color*)
                               (background *mode-line-background-color*)
                               (border *mode-line-border-color*)
                               (yellow (nth 3 *colors*))
                               (red (nth 1 *colors*))
                               (emphasis (nth 8 *colors*)))
  "Set variables, reload the modeline.

If variable is not passed in, use its current value."
  (setq *mode-line-foreground-color* foreground)
  (setq *mode-line-background-color* background)
  (setq *mode-line-border-color* border)

  (setq *colors* `("black"
                   ,red
                   "green"
                   ,yellow
                   "blue"
                   "magenta"
                   "cyan"
                   "white"
                   ,emphasis))

  (update-color-map (current-screen))

  (enable-mode-line (current-screen) (current-head) t)
  (toggle-mode-line (current-screen) (current-head))
  (toggle-mode-line (current-screen) (current-head)))

;; make mouse change focused window
(setq *mouse-focus-policy* :sloppy)


;; modules

;; git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/modules


;; battery
;; JACOBTODO: disable on desktop
(load-module "battery-portable")

(unless (member " %B" *screen-mode-line-format* :test #'string=)
  (nconc *screen-mode-line-format* '(" %B")))


;; view current network connection
;; JACOBTODO: disable when wifi not used
(load-module "wifi")

(unless (member " %I" *screen-mode-line-format* :test #'string=)
  (nconc *screen-mode-line-format* '(" %I")))


;; fonts

;; this project was taken off quicklisp but is needed for "modern" fonts. clone it before loading ttf-fonts module
;; git clone https://github.com/lihebi/clx-truetype.git ~/quicklisp/local-projects/clx-truetype

(ql:quickload :clx-truetype)
(load-module "ttf-fonts")

(xft:cache-fonts) ; make sure it knows about the fonts
;; (clx-truetype:get-font-families) ; check available font familes
;; (clx-truetype:get-font-subfamilies "DejaVu Sans Mono") ; check available font subfamiles

(set-font (make-instance 'xft:font
                         :family "DejaVu Sans Mono"
                         :subfamily "Book"
                         :size 12))


;; third party modules


;; pulse-audio

;; git clone https://github.com/Junker/stumpwm-pamixer ~/.stumpwm.d/modules/pamixer
;; sudo apt install pamixer pavucontrol

(add-to-load-path "~/.stumpwm.d/modules/pamixer")
(load-module "pamixer")

(unless (member " %P" *screen-mode-line-format* :test #'string=)
  (nconc *screen-mode-line-format* '(" %P")))


;; activate mode line

(jacob-setup-modeline)
