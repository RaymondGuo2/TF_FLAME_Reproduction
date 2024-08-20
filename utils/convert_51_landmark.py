import dlib
import cv2
import numpy as np

def get_51_landmarks(image_path, model_path):
    # Load the detector and predictor
    detector = dlib.get_frontal_face_detector()
    predictor = dlib.shape_predictor(model_path)

    img = cv2.imread(image_path)
    grey = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    faces = detector(grey)

    print("Detection in progress")
    for face in faces:
        landmark_numpy = np.zeros((51, 2))
        landmarks = predictor(grey, face)
        count = 0
        for n in range(0, 68):
            if n >= 17:
                x = landmarks.part(n).x
                y = landmarks.part(n).y
                landmark_numpy[count, 0] = x
                landmark_numpy[count, 1] = y 
                count += 1
        # print(landmark_numpy)
        # print(landmark_numpy.shape)
        return landmark_numpy
        

if __name__ == '__main__':
    image_path = './data/pexels_tester.jpg'
    model_path = './models/shape_predictor_68_face_landmarks.dat'
    landmark_array = get_51_landmarks(image_path, model_path)
    np.save('./data/pexels_tester_lmks.npy', landmark_array)