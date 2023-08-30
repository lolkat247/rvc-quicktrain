#!/bin/bash
set -eux

if [[ "$OSTYPE" == "linux-gnu"* ]]
    then
        # ...
        PACKAGEMANAGER=(apt-get -y)
elif [[ "$OSTYPE" == "darwin"* ]] 
    then
        # Mac OSX
        PACKAGEMANAGER=brew
elif [[ "$OSTYPE" == "cygwin" ]] 
    then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "Add package manager to script"
elif [[ "$OSTYPE" == "msys" ]] 
    then
        echo "Add package manager to script"
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
elif [[ "$OSTYPE" == "win32" ]] 
    then
        echo "Add package manager to script"
        # I'm not sure this can happen.
elif [[ "$OSTYPE" == "freebsd"* ]] 
    then
        echo "Add package manager to script"
        # ...
else
    echo "Add package manager to script"
    # Unknown.
fi

MODELNAME="lulu"  # @param {type:"string"}
MODELEPOCH=9600  # @param {type:"integer"}
BITRATE=48000  # @param {type:"integer"}
THREADCOUNT=8  # @param {type:"integer"}
MODELNAME="lulu"  # @param {type:"string"}
USEGPU="0"  # @param {type:"string"}
BATCHSIZE=32  # @param {type:"integer"}
MODELEPOCH=3200  # @param {type:"integer"}
EPOCHSAVE=100  # @param {type:"integer"}
MODELSAMPLE="48k"  # @param {type:"string"}
CACHEDATA=1  # @param {type:"integer"}
ONLYLATEST=0  # @param {type:"integer"}

mkdir -p content

#nvidia-smi
$PACKAGEMANAGER install python3-dev ffmpeg #build-essential

pip3 install --upgrade setuptools wheel
pip3 install --upgrade pip
pip3 install faiss-cpu==1.7.2 fairseq gradio==3.14.0 ffmpeg ffmpeg-python praat-parselmouth pyworld numpy==1.23.5 numba==0.56.4 librosa==0.9.2

git clone --depth=1 -b stable https://github.com/fumiama/Retrieval-based-Voice-Conversion-WebUI
cd content/Retrieval-based-Voice-Conversion-WebUI
mkdir -p pretrained uvr5_weights

$PACKAGEMANAGER install -qq aria2

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/D32k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o D32k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/D40k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o D40k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/D48k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o D48k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/G32k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o G32k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/G40k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o G40k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/G48k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o G48k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0D32k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o f0D32k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0D40k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o f0D40k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0D48k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o f0D48k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0G32k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o f0G32k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0G40k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o f0G40k.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained/f0G48k.pth -d content/Retrieval-based-Voice-Conversion-WebUI/pretrained -o f0G48k.pth

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP2-人声vocals+非人声instrumentals.pth -d content/Retrieval-based-Voice-Conversion-WebUI/uvr5_weights -o HP2-人声vocals+非人声instrumentals.pth
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/uvr5_weights/HP5-主旋律人声vocals+其他instrumentals.pth -d content/Retrieval-based-Voice-Conversion-WebUI/uvr5_weights -o HP5-主旋律人声vocals+其他instrumentals.pth

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -d content/Retrieval-based-Voice-Conversion-WebUI -o hubert_base.pt

aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -d content/Retrieval-based-Voice-Conversion-WebUI -o rmvpe.pt

DATASET = $(read -p "Dataset location: ")

cd content/Retrieval-based-Voice-Conversion-WebUI

# @title 手动将训练后的模型文件备份到谷歌云盘
# @markdown 需要自己查看logs文件夹下模型的文件名，手动修改下方命令末尾的文件名

# @markdown 模型名
# @markdown 模型epoch
MODELEPOCH = 9600  # @param {type:"integer"}

cp content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/G_{MODELEPOCH}.pth content/drive/MyDrive/{MODELNAME}_D_{MODELEPOCH}.pth
cp content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/D_{MODELEPOCH}.pth content/drive/MyDrive/{MODELNAME}_G_{MODELEPOCH}.pth
cp content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/added_*.index content/drive/MyDrive/
cp content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/total_*.npy content/drive/MyDrive/

cp content/Retrieval-based-Voice-Conversion-WebUI/weights/{MODELNAME}.pth content/drive/MyDrive/{MODELNAME}{MODELEPOCH}.pth



mkdir -p content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}

cp content/drive/MyDrive/{MODELNAME}_D_{MODELEPOCH}.pth content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/G_{MODELEPOCH}.pth
cp content/drive/MyDrive/{MODELNAME}_G_{MODELEPOCH}.pth content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/D_{MODELEPOCH}.pth
cp content/drive/MyDrive/*.index content/
cp content/drive/MyDrive/*.npy content/
cp content/drive/MyDrive/{MODELNAME}{MODELEPOCH}.pth content/Retrieval-based-Voice-Conversion-WebUI/weights/{MODELNAME}.pth

python3 trainset_preprocess_pipeline_print.py content/dataset {BITRATE} {THREADCOUNT} logs/{MODELNAME} True`
python3 extract_f0_print.py logs/{MODELNAME} {THREADCOUNT} {ALGO}
python3 extract_feature_print.py cpu 1 0 0 logs/{MODELNAME}
python3 train_nsf_sim_cache_sid_load_pretrain.py -e lulu -sr {MODELSAMPLE} -f0 1 -bs {BATCHSIZE} -g {USEGPU} -te {MODELEPOCH} -se {EPOCHSAVE} -pg pretrained/f0G{MODELSAMPLE}.pth -pd pretrained/f0D{MODELSAMPLE}.pth -l {ONLYLATEST} -c {CACHEDATA}

echo "备份选中的模型。。。"
cp content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/G_{MODELEPOCH}.pth content/{MODELNAME}_D_{MODELEPOCH}.pth
cp content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/D_{MODELEPOCH}.pth content/{MODELNAME}_G_{MODELEPOCH}.pth

echo "正在删除。。。"
ls content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}
rm content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/*.pth

echo "恢复选中的模型。。。"
mv content/{MODELNAME}_D_{MODELEPOCH}.pth content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/G_{MODELEPOCH}.pth
mv content/{MODELNAME}_G_{MODELEPOCH}.pth content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}/D_{MODELEPOCH}.pth

echo "删除完成"
ls content/Retrieval-based-Voice-Conversion-WebUI/logs/{MODELNAME}`