import cv2
import socket
import time
import sys
import os

print(os.getpid())

client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

face_classifier = cv2.CascadeClassifier(
    cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
)

ip = "127.0.0.1"
port = 4242
vc = cv2.VideoCapture(0)

if vc.isOpened(): # try to get the first frame
    rval, frame = vc.read()
else:
    rval = False

while rval:


    rval, frame = vc.read()
    if not rval:
        print("ERROR", rval)
    
    frame = cv2.cvtColor(frame, cv2.COLOR_RGB2GRAY)
    
    face = face_classifier.detectMultiScale(
        frame, scaleFactor= 1.1, minNeighbors=5, minSize= (40, 40)
    )
    for (x, y, w, h) in face:
        cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 255, 0), 4)
    encode, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 80])
    client_socket.sendto(bytes(buffer), (ip, port))

vc.release()