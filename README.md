# Choroid_Segmentation_GUI_ResUNet
The choroid layer segmentation process and its associated correction GUI, which utilizes ResUNet, are initiated through the primary function "Choroid_Volume_Interactive_Quant_GU.m". The key supporting script, "Ch_Topography_Seg_500_250_6x6_1.m", requires specification of the output folder path for storing the results in a .mat file. Additionally, it's essential to provide the local paths for two critical components:

    1) The ResUNet model file: "VKKResUnet_CS_3594_Raw_10Val_90Train_RS42_8_80_256.h5"
    2) A Python script: "maskGen.py"

Ensuring these paths are correctly set will enable smooth execution of the segmentation process.
