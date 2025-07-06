# 📱 YOLOv8-Powered English Learning Video Streamer (Dockerized)

This project explores the potential of using **YOLOv8 object detection** to power an **iOS app aimed at assisting English language learners**. The current prototype uses **Flask and OpenCV** to run YOLO inference on a video file and stream annotated frames to a browser in real time. The long-term vision is to apply this capability to live or recorded video content on mobile devices, helping users associate words with visual objects.

---

## 🎯 Project Goal

Build a foundational prototype to:

* Evaluate YOLOv8’s ability to detect and label objects in real time
* Stream predictions over a network to simulate mobile consumption
* Eventually integrate into an iOS app for **interactive vocabulary learning**

---

## 🧾 Project Structure

```
yolov8-flask-stream/
├── app.py             # Flask app that loads video, runs YOLOv8, streams results
├── bunny.mp4          # Sample video file (or replace with your own)
├── Dockerfile         # Builds the YOLO + Flask environment inside Docker
├── requirements.txt   # Python dependencies
├── setup.sh           # Installs Docker, builds and runs the container, sets up SSH tunnel
└── README.md          # You're reading it!
```

---

## 🚀 What This Prototype Does

* Loads a **video file** (`bunny.mp4`)
* Runs **YOLOv8 inference** on each frame
* Streams **annotated video frames** in real time to your browser at `http://localhost:5000`
* Entire detection and serving process is **containerized with Docker**

---

## 🧰 Prerequisites

* Python 3.10+ (if running without Docker)
* Docker (auto-installed by `setup.sh` if missing)
* SSH access (if deploying to a remote server)

---

## ▶️ How to Use

### Step 1: Prepare the Environment

Clone the project and place your video (or rename to `bunny.mp4`) in the root directory.

### Step 2: Run the Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

This will:

* Install Docker (if needed)
* Build the image `yolov8-streamer`
* Run the container
* Optionally set up SSH port forwarding

### Step 3: Open in Browser

Navigate to:

```
http://localhost:5000
```

If running remotely, you’ll see the stream via SSH tunnel.

---

## 📄 File-by-File Breakdown

| File               | Description                                                         |
| ------------------ | ------------------------------------------------------------------- |
| `app.py`           | Flask server that loads video, applies YOLOv8, streams MJPEG frames |
| `bunny.mp4`        | Sample video used for detection                                     |
| `Dockerfile`       | Installs Python, OpenCV, Flask, Ultralytics inside Docker           |
| `requirements.txt` | Python packages required by `app.py`                                |
| `setup.sh`         | Builds and runs Docker container; sets up optional SSH tunnel       |
| `README.md`        | Project overview, goal, usage guide                                 |

---

## 🧠 Notes

* YOLOv8 model used: `yolov8n.pt` (changeable in `app.py`)
* Video stream is MJPEG via HTTP, compatible with any modern browser
* Can be extended to read live camera feeds, screen recordings, or mobile input

---

## ✅ Next Steps Toward iOS Integration

* [ ] Convert browser stream into a mobile web view or iOS SwiftUI viewer
* [ ] Add image-to-text mappings ("label: word") for language learning
* [ ] Enable speech or tooltip overlays for pronunciation
* [ ] Record learner progress and vocabulary exposure
* [ ] Optimize YOLO model for on-device (Core ML or ONNX)

---

Let me know if you'd like a `docker-compose.yml` version or a Swift prototype for iOS integration!
