# -*- coding: utf-8 -*-
"""
Created on Wed Dec  9 14:41:39 2020

@author: Emre Yazıcı
"""

import pyzbar.pyzbar as pyzbar
import numpy as np
import cv2
import time

# kamerayı aç
cap = cv2.VideoCapture(0)

cap.set(3,640)
cap.set(4,480)
#160.0 x 120.0
#176.0 x 144.0
#320.0 x 240.0
#352.0 x 288.0
#640.0 x 480.0
#1024.0 x 768.0
#1280.0 x 1024.0
time.sleep(2)

def decode(im) : 
    # barkodları ve QR kodları bul
    decodedObjects = pyzbar.decode(im)
    # Print results
    for obj in decodedObjects:
        print('Type : ', obj.type)
        print('Data : ', obj.data,'\n')     
    return decodedObjects


font = cv2.FONT_HERSHEY_SIMPLEX

while(cap.isOpened()):
    # burada yakaladığımız qr ve barkodları karelere çevreliyoruz
    ret, frame = cap.read()
    # Çerçeve üzerindeki işlemlerimiz buraya geliyor
    im = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
         
    decodedObjects = decode(im)

    for decodedObject in decodedObjects: 
        points = decodedObject.polygon
     
        # bulduğumuz noktalar bir kare oluşturmuyorsa dışbükey şekilleri tespit ediyoruz.
        if len(points) > 4 : 
          hull = cv2.convexHull(np.array([point for point in points], dtype=np.float32))
          hull = list(map(tuple, np.squeeze(hull)))
        else : 
          hull = points;
         
        # nokta sayısı
        n = len(hull)     
        # algılanan QR kodun etrafını çerçeveye al.
        for j in range(0,n):
          cv2.line(frame, hull[j], hull[ (j+1) % n], (255,255,0), 3)

        x = decodedObject.rect.left
        y = decodedObject.rect.top

        print(x, y)

        print('Type : ', decodedObject.type)
        print('Data : ', decodedObject.data,'\n')

        barCode = str(decodedObject.data)
        cv2.putText(frame, barCode, (x, y), font, 1, (255,0,255), 2, cv2.LINE_AA)
               
    # QR sonuçlarını göster
    cv2.imshow('frame',frame)
    key = cv2.waitKey(1)
    if key & 0xFF == ord('q'):
        break
    elif key & 0xFF == ord('s'): # s tuşuna basarak kaydedelim
        cv2.imwrite('Capture.png', frame)     

# başka QR kod bulunamıyorsa pencereyi kapatıyoruz.
cap.release()
cv2.destroyAllWindows()