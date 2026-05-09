# HIRAS-GEO

## Overview

This repository provides the implementation of the rigorous geometric positioning and correction model for the Hyperspectral Infrared Atmospheric Sounder (HIRAS) onboard the FY-3F satellite. It includes the derivation of adjustment equations, acquisition of geometric control points using the co-platform MERSI instrument, and comprehensive validation of the correction accuracy.

## Usage
The usage example is ..\1-GEO_HIRAS\bin\GEO_HIRAS.exe ..\1-GEO_HIRAS\order\order-20250622-1415-CH22.xml

Only one parameters are required. In the XML file, modify the data path in the corresponding location, including the HIRAS hdf file path, the MERSI hdf file path, and the SRF file path, among others. Judge execution by “step” tag in the XML file. This program would produce a TXT or HDF file result. 

The TXT dataset such as "FY3F_HIRAS_GRAN_L1_20250622_1415_014KM_V0_err22.txt" contain registration points / groud control points (GCPs), which could be used to validate the geolocation accuracy or acquire the correction parameters. The 1&2 columns are original lat&lon, 3&4 columns are true lat&lon, 5&6 columns are along&cross track accuracy (units: HIRAS FOV), 7 columns are geometric positioning error in kilometers. 

The evaluation data are also provided as examples, which can be downloaded from Test Data and Figure Data. The original datas inluding HIRAS and MERSI are required, which can be download from NSMC_data. This program is a part of our manuscript "Geometric Positioning and Correction for the FY-3F HIRAS".

## Related Links

- [Software](https://github.com/Alchemilla/HIRAS-GEO/releases/download/V1.0/1-GEO_HIRAS.rar)
- [Test Data](https://github.com/Alchemilla/HIRAS-GEO/releases/download/V1.0/2-TestData.rar)
- [Figure Data](https://github.com/Alchemilla/HIRAS-GEO/releases/download/V1.0/3-FigureData.rar)
- [NSMC_data](https://satellite.nsmc.org.cn/DataPortal/en/home/index.html)

## Contact
For questions or collaboration, please contact guanzc@cma.gov.cn
