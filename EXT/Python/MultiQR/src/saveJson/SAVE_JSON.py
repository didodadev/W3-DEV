# -*- coding: utf-8 -*-
"""
Created on Wed Dec  9 13:16:57 2020

@author: Emre Yazıcı
"""


import json

def writeToJSONFile(path, fileName, data):
    filePathNameWExt = './' + path + '/' + fileName + '.json'
    with open(filePathNameWExt, 'w') as fp:
        json.dump(data, fp)


# Example
data = {"ad": "Emre", "Diller": ["Turkce", "Ingilizce"], "Yas": 25}
data['key'] = 'value'

writeToJSONFile('./','QR',data)
# './' represents the current directory so the directory save-file.py is in
# 'test' is my file name