# -*- coding: utf-8 -*-
"""
Created on Fri Dec 18 09:43:45 2020

@author: Emre Yazıcı
"""

import cv2

image = cv2.imread('2.png')
original = image.copy()
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (3, 3), 0)
thresh = cv2.threshold(blurred, 230,255,cv2.THRESH_BINARY_INV)[1]

# kontürleri buluyoruz
cnts = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
cnts = cnts[0] if len(cnts) == 2 else cnts[1]

# iterasyonla kontürleri filtrele ve kes
image_number = 0
for c in cnts:
    x,y,w,h = cv2.boundingRect(c)
    cv2.rectangle(image, (x, y), (x + w, y + h), (36,255,12), 2)
    ROI = original[y:y+h, x:x+w]
    cv2.imwrite("ROI_{}.png".format(image_number), ROI)
    image_number += 1

cv2.imshow('thresh', thresh)
cv2.imshow('image', image)
cv2.waitKey(0)