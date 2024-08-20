#!/bin/bash

if [ "$#" -ne 6 ]; then
    echo "Requires 6 arguments: $0 input_path output_path lm_model_path model_fname_option resolution_option out_model_path"
    exit 1
fi

INPUT_PATH="$1"
OUTPUT_PATH="$2"
LM_MODEL_PATH="$3"
MODEL_FNAME_OPTION="$4"
RESOLUTION_OPTION="$5"
OUT_MODEL_PATH="$6"

MODEL_FNAME_PATH=''

if [ "$MODEL_FNAME_OPTION" == "male" ]; then
    MODEL_FNAME_PATH='./models/male_model.pkl'
elif [ "$MODEL_FNAME_OPTION" == "female" ]; then
    MODEL_FNAME_PATH='./models/female_model.pkl'
else 
    MODEL_FNAME_PATH='./models/generic_model.pkl'
fi

RESOLUTION_PATH=''
if [ "$RESOLUTION_OPTION" == 256 ]; then
    RESOLUTION_PATH='./data/texture_data_256.npy'
elif [ "$RESOLUTION_OPTION" == 1024 ]; then
    RESOLUTION_PATH='./data/texture_data_1024.npy'
elif [ "$RESOLUTION_OPTION" == 2048 ]; then
    RESOLUTION_PATH='./data/texture_data_2048.npy'
else 
    RESOLUTION_PATH='./data/texture_data_512.npy'
fi

FILENAME=$(basename -- "$OUTPUT_PATH")
BASENAME="${FILENAME%.*}"
LMK_PATH="./test_images/${BASENAME}_lmks.npy"


# Preprocess image and obtain landmarks
python3 preprocess_test_image.py --input_path "$INPUT_PATH" --output_path "$OUTPUT_PATH" --lm_model_path "$LM_MODEL_PATH"


# Fit the 2D landmark file to a 3D mesh
python3 fit_2D_landmarks.py --model_fname "$MODEL_FNAME_PATH" --flame_lmk_path './data/flame_static_embedding.pkl' --texture_mapping "$RESOLUTION_PATH" --target_img_path "$OUTPUT_PATH" --target_lmk_path "$LMK_PATH" --out_path "$OUT_MODEL_PATH" --visualize False

MODIFIED_MESH_PATH="${OUTPUT_PATH%.*}.obj"
echo $MODIFIED_MESH_PATH
TARGET_MESH_PATH="${MODIFIED_MESH_PATH/test_images/test_results}"
MODIFIED_MESH_FNAME="${OUTPUT_PATH%.*}_fitted.ply"
OUT_MESH_FNAME="${MODIFIED_MESH_FNAME/test_images/test_results}"

# The issue here is that we are taking the output_path, which is technically wrong
# Convert the mesh to full FLAME topology
python3 fit_3D_mesh.py --model_fname "$MODEL_FNAME_PATH" --target_mesh_path "$TARGET_MESH_PATH" --out_mesh_fname "$OUT_MESH_FNAME" --show_fitting False

# ./imageToMesh.sh ./test_images/pexels_tester.jpg ./test_images/pexels_tester.jpg ./models/shape_predictor_68_face_landmarks.dat female 512 ./test_results/