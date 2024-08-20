# FLAME: Articulated Expressive 3D Head Model (TF) Reproduction Repository

This is an unofficial implementation of [**FLAME** (Faces Learned with an Articulated Model and Expressions)](https://flame.is.tue.mpg.de/), a 
framework designed to model the variations in shape, pose, expression, and appearance in heads 
proposed by Li et al. (2017). This repository reproduces the official TensorFlow implementation of [FLAME](https://github.com/TimoBolkart/TF_FLAME?
tab=readme-ov-file), with the purpose of exploring the effectiveness of fitting FLAME topologies for head reconstruction
and simplifying the ease of setting-up the FLAME model in the [original repository]
(https://github.com/TimoBolkart/TF_FLAME?tab=readme-ov-file).


## Step 1: Install Dependencies

Create a Conda environment for the project, making sure to specify Python version 3.7 (since this is required to maintain TensorFlow 1.15). Then install the packages in `requirements.txt`.

```
conda create -n flame python=3.7
conda activate flame
pip install -r requirements.txt
```

The final requirement is the `psbody-mesh` package, which must be installed separately (link [here](https://github.com/MPI-IS/mesh)). This set-up can be a little bit complicated, requiring first the installation of the [Boost](https://www.boost.org/) libraries. Given the activation of the conda environment, execute:

```
conda install anaconda::boost
```

After successful installation of Boost to your conda environment, download the `psbody-mesh` package by executing:

```
git clone https://github.com/MPI-IS/mesh.git
cd mesh
python setup.py install
```

The final step is to satisfy the CUDA requirements for running the model. A working version was achieved using CUDA 10.0.130 with CUDNN 7.6.4.38. These environment variables must be set in the .bashrc file shown below:

```
export CUDA_HOME=/vol/cuda/10.0.130-cudnn7.6.4.38
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
```

## Step 2: Download Data and Models

The next step involves downloading the data and models from the official FLAME website ([here](https://flame.is.tue.mpg.de/index.html)). You will first need to set up an account and agree to the model license before you can download the data at this [link](https://flame.is.tue.mpg.de/download.php). There are a variety of models here, however you should find the Model section, and download the files titled "FLAME 2019 (fixed mouth, more data)" (simply the one tested here), and "FLAME texture space (for non-commercial use only)".

Create a directory in the root directory called "models", and place the files from the unzipped FLAME2019 folder inside it. To facilitate the landmark detection algorithm, a file called `shape_predictor_68_face_landmarks.dat` is required. This can be downloaded at this [link](https://www.kaggle.com/datasets/sergiovirahonda/shape-predictor-68-face-landmarksdat), and needs to also be placed in the models subdirectory. The file structure should look like this:

```
|--TF_FLAME_Reproduction 
    |--models
        |--female_model.pkl
        |--male_model.pkl
        |--generic_model.pkl
        |--shape_predictor_68_face_landmarks.dat
```

Another directory named `data` must be created in the root directory. To do so, simply unzip the .zip file found here [here](https://drive.google.com/drive/u/4/folders/15ItpuYbzUIMVPHg3RLshppNCc9RURMIL) into the root directory, such that the structure looks like this:

```
|--TF_FLAME_Reproduction 
    |--data
        |--<files inside the unzipped folder> 
```

Finally, create two folders in the root directory called `test_images` and `test_results`, which will store the input image and corresponding reconstruction outputs respectively. The final topology should look like this:

```
|--TF_FLAME_Reproduction 
    |--models
    |--data
    |--test_images
    |--test_results
    |--tf_smpl
    |--utils
    |--.gitignore
    |--fit_2D_landmarks.py
    |--fit_3D_mesh.py
    |--imageToMesh.sh
    |--preprocess_test_image.py
    |--README.md
    |--requirements.txt
```

## Step 3: Run the Script

For any images that you want to reconstruct, simply place the images inside the `test_images` folder. Once this has been completed, you can simply run the bash pipeline designed to preprocess the data and run the fitting process, writing the outputs in the `test_results` folder. 

The structure of the bash command is highly specific, so make sure to specify this correctly. Note that the `MODEL_TYPE` can take three different arguments: male, female or generic. The `RESOLUTION` can take four arguments: 256, 512, 1024, and 2048.

```
./imageToMesh.sh <PATH_TO_INPUT_IMAGE> <PATH_TO_PROCESSED_IMAGE> <PATH_TO_LANDMARK_PREDICTOR> <MODEL_TYPE> <RESOLUTION> <PATH_TO_OUTPUT_DIRECTORY>
```

An example is shown below. It is recommended based on the provided directory structure that only 3 arguments need to be modified from the example. The specific image path needs to be modified in `<PATH_TO_INPUT_IMAGE>` and `<PATH_TO_PROCESSED_IMAGE>`  to test one's custom images, and secondly, the `<MODEL_TYPE>` depending on the gender of the person in the image. If you are unsure, you can simply put `generic` as the argument. It is recommended to keep a resolution of 512.

```
./imageToMesh.sh ./test_images/pexels_tester.jpg ./test_images/pexels_tester.jpg ./models/shape_predictor_68_face_landmarks.dat female 512 ./test_results/
```

Note that for the bash script to run properly, execution right is required. Therefore, before executing for the first time, ensure you enter `chmod +x imageToMesh.sh` while in the root directory. Also make sure that you run the script as shown above and not using `sh imageToMesh.sh`.

## Visualise the Output

The results of the script should display in test_results. This can be viewed in MeshLab directly, or using Blender.

## Citation

This reproduction uses the code [here](https://github.com/TimoBolkart/TF_FLAME?
tab=readme-ov-file), and is cited below:

```
@article{FLAME:SiggraphAsia2017,
  title = {Learning a model of facial shape and expression from {4D} scans},
  author = {Li, Tianye and Bolkart, Timo and Black, Michael. J. and Li, Hao and Romero, Javier},
  journal = {ACM Transactions on Graphics, (Proc. SIGGRAPH Asia)},
  volume = {36},
  number = {6},
  year = {2017},
  url = {https://doi.org/10.1145/3130800.3130813}
}
```

## License

The FLAME model is under a Creative Commons Attribution license. By using this code, you acknowledge that you have read the terms and conditions (https://flame.is.tue.mpg.de/modellicense.html), understand them, and agree to be bound by them. If you do not agree with these terms and conditions, you must not use the code. You further agree to cite the FLAME paper when reporting results with this model.


