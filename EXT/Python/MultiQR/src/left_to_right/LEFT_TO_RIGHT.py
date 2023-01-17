# -*- coding: utf-8 -*-
"""
Created on Tue Dec 15 00:38:08 2020

@author: Emre Yazıcı
"""

import sys, os
try:
    from pyzbar.pyzbar import decode, ZBarSymbol
except:
    cmd = ('py -m pip install "pyzbar"')
    os.system(cmd)
    from pyzbar.pyzbar import decode, ZBarSymbol

try:
    from PIL import Image
except:
    cmd = ('py -m pip install "Pillow"')
    os.system(cmd)
    from PIL import Image

decoded = decode(Image.open("2.png"), symbols=[ZBarSymbol.QRCODE])
qr_dic = {}
for qr in decoded:
    x = qr[2][0] # İlk tespit edilen QR kodun soluna doğru gidiyoruz.
    qr_dic[x] = qr[0] # QR kodun içerdiği veri.

for qr in sorted(qr_dic.keys()):
    print(qr_dic[qr])