(in-package :stumpwm)

(defun alist-define-keys (map alist)
  "define key using alist."
  (loop for (key . command) in alist
        do (define-key map (kbd key) command)))

(defmacro create-map (var key &key (on *top-map*))
  `(progn
     (defvar ,var (make-sparse-keymap))
     (define-key ,on (kbd ,key) ',var)
     ,var))

(alist-define-keys *top-map*
                   '(("s-h" . "move-focus left")
                     ("s-j" . "move-focus down")
                     ("s-k" . "move-focus up")
                     ("s-l" . "move-focus right")

                     ("s-H" . "move-window left")
                     ("s-J" . "move-window down")
                     ("s-K" . "move-window up")
                     ("s-L" . "move-window right")

                     ("s-M-H" . "exchange-direction left")
                     ("s-M-J" . "exchange-direction down")
                     ("s-M-K" . "exchange-direction up")
                     ("s-M-L" . "exchange-direction right")

                     ("s-;" . "colon")

                     ("s-b" . "fullscreen")

                     ("s-r" . "loadrc")

                     ("s-z" . "gprev")
                     ("s-x" . "gnext")

                     ("s-n" . "next-in-frame")
                     ("s-p" . "prev-in-frame")

                     ("s-q" . "session-menu")

                     ("s-`" . "show-yakyak")

                     ("XF86ScreenSaver" . "lock")

                     ("S-XF86MonBrightnessUp" . "xbacklight =100%")
                     ("S-XF86MonBrightnessDown" . "xbacklight =3%")
                     ("XF86MonBrightnessUp" . "xbacklight +5%")
                     ("XF86MonBrightnessDown" . "xbacklight -5%")

                     ("XF86AudioRaiseVolume" . "amixer -c 0 sset Master 1+")
                     ("XF86AudioLowerVolume" . "amixer -c 0 sset Master 1-")

                     ("XF86AudioMute" . "amixer sset Master,0 toggle")

                     ("S-XF86AudioRaiseVolume" . "amixer -c 0 sset Capture 1+")
                     ("S-XF86AudioLowerVolume" . "amixer -c 0 sset Capture 1-")

                     ("XF86AudioMicMute" . "amixer sset Capture,0 toggle")))

(loop for i from 0 to 9
      do (define-key *top-map* (kbd (format nil "s-~A" i)) (format nil "gselect ~A" i)))
(loop for ch in '(#\) #\! #\@ #\# #\$ #\% #\^ #\& #\* #\()
      and i from 0 to 9
      do (define-key *top-map* (kbd (format nil "s-~A" ch)) (format nil "gmove ~A" i)))

(alist-define-keys (create-map *frame-map* "s-f")
                   '(("f" . "frame-windowlist")
                     ("s-f" . "fother")
                     ("n" . "next-in-frame")
                     ("p" . "prev-in-frame")
                     ("e" . "fclear")
                     ("m" . "only")
                     ("=" . "balance-frames")))

(alist-define-keys (create-map *window-map* "s-w")
                   '(("h" . "move-focus left")
                     ("j" . "move-focus down")
                     ("k" . "move-focus up")
                     ("l" . "move-focus right")

                     ("q" . "delete")
                     ("Q" . "kill")

                     ("n" . "pull-hidden-next")
                     ("p" . "pull-hidden-previous")

                     ("w" . "windowlist")
                     ("s-w" . "pull-hidden-other")

                     ("g" . "gmove")
                     ("m" . "only")

                     ("s" . "vsplit")
                     ("v" . "hsplit")
                     ("d" . "remove")
                     ("r" . "iresize")))

(alist-define-keys (create-map *window-move-map* "m" :on *window-map*)
                   '(("h" . "move-window left")
                     ("j" . "move-window down")
                     ("k" . "move-window up")
                     ("l" . "move-window right")))

(alist-define-keys (create-map *window-transpose-map* "t" :on *window-map*)
                   '(("h" . "exchange-direction left")
                     ("j" . "exchange-direction down")
                     ("k" . "exchange-direction up")
                     ("l" . "exchange-direction right")))

(alist-define-keys (create-map *group-map* "s-g")
                   '(("g" . "grouplist")
                     ("s-g" . "gother")

                     ("n" . "gnext")
                     ("N" . "gnext-with-window")

                     ("p" . "gprev")
                     ("P" . "gprev-with-window")

                     ("c" . "gnew")
                     ("q" . "gkill")
                     ("r" . "grename")))
(loop for i from 0 to 9
      do (define-key
             *group-map*
             (kbd (format nil "~A" i))
           (format nil "gselect ~A" i)))

(alist-define-keys (create-map *group-map* "s-s")
                   '(("j" . "stumptray-toggle-hidden-icons-visibility")
                     ("k" . "systray-toggle-icon-hiding")

                     ("h" . "systray-selection-left")
                     ("l" . "systray-selection-right")

                     ("H" . "systray-move-icon-left")
                     ("L" . "systray-move-icon-right")

                     ("s" . "stumptray")))

(alist-define-keys (create-map *applications-map* "s-a")
                   '(("f" . "run-firefox")
                     ("c" . "run-chrome")
                     ("k" . "run-keepassxc")
                     ("t" . "run-named-terminal main")
                     ("m" . "run-thunderbird")
                     ("y" . "run-yakyak")))

(alist-define-keys (create-map *applications-emacs* "e" :on *applications-map*)
                   '(("e" . "display-named-emacs main")))
(loop for c across "abcdfghijklmnopqrstuvwxyz0123456789"
      do (define-key *applications-emacs* (kbd (format nil "~C"c)) (format nil "display-named-emacs ~C" c)))