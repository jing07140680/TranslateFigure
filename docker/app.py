from flask import Flask, Response
import cv2
from ultralytics import YOLO

app = Flask(__name__)
model = YOLO("yolov8n.pt")
cap = cv2.VideoCapture("bunny.mp4")  # change to your video file

def gen_frames():
    while True:
        success, frame = cap.read()
        if not success:
            cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
            continue

        results = model(frame)
        annotated = results[0].plot()

        _, buffer = cv2.imencode('.jpg', annotated)
        frame = buffer.tobytes()
        yield (b'--frame\r\n'
               b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')

@app.route('/')
def index():
    return '<h1>YOLOv8 Video Stream</h1><img src="/video">'

@app.route('/video')
def video():
    return Response(gen_frames(), mimetype='multipart/x-mixed-replace; boundary=frame')

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000)
