# Thermometer with PIC16F630 and DS18B20

Hello!

Here is  project for PIC16F630 microcontroller
made by http://www.microchip.com.

![PIC16F630 Temp meter prototype](https://raw.githubusercontent.com/hpaluch/temp_meter_16f630/master/temp-meter-prototype.jpg)
  
Function: Digital temperature meter
with DS18B20 sensor and LED display.

First usable version starts with R0 TAG

Schematics is in [ExpressPCB/](ExpressPCB/) sub folder and is also shown below

![PIC16F630 Temp meter schematics](https://raw.githubusercontent.com/hpaluch/temp_meter_16f630/master/ExpressPCB/temp_meter_16F630.png)

Project has been tested on DM163045 PICDEM Lab Development Kit
with PicKit 3 programmer (included in PICDEM). 

Tested in MPLAB X IDE v2.35, installed to this custom directory (to avoid conflicts
with other MPLAB X versions:
```
c:\Program Files (x86)\Microchip\MPLABX\v2.35\
```

# Notes

Since beginning it seems that the temperature reported by DS18B20 seems
to be 3 to 5 degrees higher than actual. The cause is unknown.


# Resources

Project Specific Links:

* DS18B20 DataSheet
  - http://datasheets.maximintegrated.com/en/ds/DS18B20.pdf
* 1-Wire(R) Communication with a Microchip PICmicro Microcontroller
  - http://www.maximintegrated.com/app-notes/index.mvp/id/2420
* Teplotni cidlo DS18B20 ve spojeni s PIC12F629
  - http://pandatron.cz/?566&teplotni_cidlo_ds18b20_ve_spojeni_s_pic12f629

Microchip Links:

* PIC16F630 datasheet 
  - http://www.microchip.com/TechDoc.aspx?type=datasheet&product=16f630
* DM163045 - PICDEM Lab Development Kit 
  - http://www.microchipdirect.com/productsearch.aspx?keywords=DM163045
* MPLAB X IDE
  - http://www.microchip.com/pagehandler/en-us/family/mplabx/
* Using Stimulus for Algorithm Verification with the MPLAB(R) IDE Simulator
  - http://www.microchip.com/stellent/groups/SiteComm_sg/documents/DeviceDoc/en542701.pdf

Other Links:

* Gooligum PIC tutorials - intro to baseline PIC & MPASM
  - http://www.gooligum.com.au/tutorials.html
