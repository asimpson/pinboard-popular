;;; pinboard-popular.el --- Displays links from the pinboard.in popular page.   -*- lexical-binding: t; -*-

;; Adam Simpson <adam@adamsimpson.net>
;; Version: 0.1.0
;; Package-Requires: ((emacs "24"))
;; Keywords: news, pinboard
;; URL: https://github.com/asimpson/ivy-pinboard-popular

;;; Commentary:

;; Easily open a link from Pinboard's "popular" page.

;;; Code:
(require 'url)

;;;###autoload
(defun pinboard-popular()
  "Download and parse the pinboard.in/popular page."
  (interactive)
  (let ((url "https://pinboard.in/popular/"))
    (url-retrieve url (lambda(_)
                        (let (links)
                          (keep-lines "bookmark_title" (point-min) (point-max))
                          (goto-char (point-min))
                          (while (re-search-forward "href=\"" nil t)
                            (let ((beg (point)))
                              (search-forward "\"")
                              (let ((url (buffer-substring-no-properties beg (- (point) 1))))
                                (let ((beg (1+ (point))))
                                  (search-forward "<")
                                  (let ((title (buffer-substring-no-properties beg (- (point) 1))))
                                    (push (propertize title 'url url) links))
                                  (forward-line)
                                  (beginning-of-line)))))
                          (browse-url (get-text-property 0 'url (completing-read "Pinboard popular: " (reverse links) nil t))))))))

(provide 'pinboard-popular)

;;; pinboard-popular.el ends here
