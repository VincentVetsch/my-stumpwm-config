(in-package :cl-user)
(defpackage mouse-follow
  (:use :cl :stumpwm)
  (:export
   #:enable
   #:disable))
(in-package :mouse-follow)

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
           (min-y (stumpwm::frame-display-y group frame))
           (max-x (+ min-x (frame-width frame)))
           (max-y (+ min-y (stumpwm::frame-display-height group frame))))
      (and (<= min-x mouse-x max-x)
           (<= min-y mouse-y max-y)))))

(defun banish-frame (frame)
  "Banish mouse to corner of frame"
  (let* ((group (current-group))
         (x-offset 15)
         (y-offset 15)
         (win-x (frame-x frame))
         (win-y (stumpwm::frame-display-y group frame))
         (w (frame-width frame))
         (h (stumpwm::frame-display-height group frame))
         (x (- (+ win-x w)
               x-offset))
         (y (- (+ win-y h)
               y-offset)))
    (temporarilly-disable-sloppy-pointer)
    (ratwarp x y)))

(defun mouse-focus-frame-hook (cur-frame last-frame)
  (unless (eq cur-frame last-frame)
    (unless (mouse-inside-frame-p cur-frame)
      (banish-frame cur-frame))))

(defun mouse-split-frame-hook (original-frame a-frame b-frame)
  "Reposition the mouse when a frame is created."
  (banish-frame a-frame))

(defun mouse-remove-split-hook (cur-frame old-frame)
  "Reposition the mouse when a frame is removed."
  (banish-frame cur-frame))

(defvar *original-focus-policy* :ignore)
(defun enable ()
  "Enable mouse follows window mode."
  (setq *original-focus-policy* *mouse-focus-policy*)

  ;; :click, :ignore, :sloppy
  (setf *mouse-focus-policy* :sloppy)

  (add-hook *focus-frame-hook* #'mouse-focus-frame-hook)
  (add-hook *split-frame-hook* #'mouse-split-frame-hook)
  (add-hook *remove-split-hook* #'mouse-remove-split-hook))

(defun disable ()
  "Disable mouse follows window mode."
  (setq *mouse-focus-policy* *original-focus-policy*)

  (remove-hook *focus-frame-hook* #'mouse-focus-frame-hook)
  (remove-hook *split-frame-hook* #'mouse-split-frame-hook)
  (remove-hook *remove-split-hook* #'mouse-remove-split-hook))
