(in-package :stumpwm)

;; :click, :ignore, :sloppy
(setf *mouse-focus-policy* :sloppy)

(defun temporarilly-disable-sloppy-pointer ()
  "Disable the sloppy pointer for a brief period of time."
  (when (eq *mouse-focus-policy* :sloppy)
    (setf *mouse-focus-policy* :ignore)
    (run-with-timer 0.2 nil #'reenable-sloppy-pointer)))

(defun reenable-sloppy-pointer ()
  (setf *mouse-focus-policy* :sloppy))

(defun mouse-inside-frame-p (frame)
  "Determine if mouse already inside frame."
  (multiple-value-bind (mouse-x mouse-y window)
      (xlib:global-pointer-position  *display*)
    (let* ((group (current-group))
           (min-x (frame-x frame))
           (min-y (frame-display-y group frame))
           (max-x (+ min-x (frame-width frame)))
           (max-y (+ min-y (frame-display-height group frame))))
      (and (<= min-x mouse-x max-x)
           (<= min-y mouse-y max-y)))))

(defun my-banish-frame (frame)
  "Banish mouse to corner of frame"
  (let* ((group (current-group))
         (x-offset 15)
         (y-offset 15)
         (win-x (frame-x frame))
         (win-y (frame-display-y group frame))
         (w (frame-width frame))
         (h (frame-display-height group frame))
         (x (- (+ win-x w)
               x-offset))
         (y (- (+ win-y h)
               y-offset)))
    (temporarilly-disable-sloppy-pointer)
    (ratwarp x y)))

(defun my-focus-frame-hook (cur-frame last-frame)
  (unless (eq cur-frame last-frame)
    (unless (mouse-inside-frame-p cur-frame)
      (my-banish-frame cur-frame))))

(defun my-split-frame-hook (original-frame a-frame b-frame)
  "Reposition the mouse when a frame is created."
  (my-banish-frame a-frame))

(defun my-remove-split-hook (cur-frame old-frame)
  "Reposition the mouse when a frame is removed."
  (my-banish-frame cur-frame))

;; Clear hooks I use on restart
(remove-all-hooks *focus-frame-hook*)
(remove-all-hooks *split-frame-hook*)
(remove-all-hooks *remove-split-hook*)

(add-hook *focus-frame-hook* #'my-focus-frame-hook)
(add-hook *split-frame-hook* #'my-split-frame-hook)
(add-hook *remove-split-hook* #'my-remove-split-hook)