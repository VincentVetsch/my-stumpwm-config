(in-package :stumpwm)

(clear-window-placement-rules)

;; Clear hooks I use on restart
(remove-all-hooks *focus-frame-hook*)
(remove-all-hooks *split-frame-hook*)
(remove-all-hooks *remove-split-hook*)