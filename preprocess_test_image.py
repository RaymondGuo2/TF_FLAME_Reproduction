import argparse
from utils.resize_image import detect_and_crop_head
from utils.convert_51_landmark import get_51_landmarks
import os
import numpy as np

parser = argparse.ArgumentParser(description="Pre-process a test image and return landmarks")
parser.add_argument('--input_path', type=str, help="Path to input image")
parser.add_argument('--output_path', type=str, help="Path to output directory")
parser.add_argument('--lm_model_path', type=str, default='./models/shape_predictor_68_face_landmarks.dat', help="Path to landmark detector")
args = parser.parse_args()

detect_and_crop_head(args.input_path, args.output_path)
filename = os.path.splitext(args.output_path)[0]
lmk_file = f"{filename}_lmks.npy"
landmark_array = get_51_landmarks(args.output_path, args.lm_model_path)
np.save(lmk_file, landmark_array)

# python3 preprocess_test_image.py --input_path ./data/pexels_tester.jpg --output_path ./test_images/pexels_tester.jpg --lm_model_path ./models/shape_predictor_68_face_landmarks.dat
# python3 preprocess_test_image.py ./data/pexels_tester.jpg ./test_images/pexels_tester.jpg