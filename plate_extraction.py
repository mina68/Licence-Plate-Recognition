# -*- coding: utf-8 -*-
"""
Created on Fri Feb 21 12:20:49 2020

@author: Mina
"""

import cv2
import pytesseract
import numpy as np

pytesseract.pytesseract.tesseract_cmd = 'C:\Program Files\Tesseract-OCR\\tesseract.exe'

originalImg = cv2.imread('DOCS/Data-Images/Cars/23.jpg', cv2.IMREAD_GRAYSCALE)
black_img = np.zeros((originalImg.shape[0], originalImg.shape[1]), np.uint8)

filtered = cv2.bilateralFilter(originalImg, 11, 17, 17)
edged = cv2.Canny(filtered, 200, 255) #Perform Edge detection

kernel = np.ones((5,1),np.uint8)
img = cv2.morphologyEx(edged, cv2.MORPH_OPEN, kernel)
img = cv2.dilate(img,kernel,iterations = 1)

kernel = np.ones((1,30),np.uint8)
img = cv2.morphologyEx(img, cv2.MORPH_CLOSE, kernel)

orig_contours, hierarchy = cv2.findContours(img, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)

contours = []
for contour in orig_contours:
    x,y,width,height = cv2.boundingRect(contour)
    area = cv2.contourArea(contour)
    
    if (area > 500 and width/height < 5 and width/height > 2):
        
        orig_cropped_img = originalImg[y:y+height, x:x+width]
        edged_cropped_img = edged[y:y+height, x:x+width]
        char_contours, hierarchy = cv2.findContours(edged_cropped_img, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
        
        for char_contour in char_contours:
            x,y,width,height = cv2.boundingRect(char_contour)
            area = cv2.contourArea(char_contour)
            
            if (width/height > .2 and width/height < 1):
                char = orig_cropped_img[y:y+height, x:x+width]
                text = pytesseract.image_to_string(char, config='--psm 10 --oem 3 -c tessedit_char_whitelist=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')
                print("Detected Number is:",text)
                
                cv2.imshow('sample image',char)
                cv2.waitKey(0)

cv2.drawContours(black_img, contours, -1, (255,255,255), 1)
