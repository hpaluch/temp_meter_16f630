# Thermometer with PIC16F630 and DS18B20

Hello!

Here is  project for PIC16F630 microcontroller
made by http://www.microchip.com.

![PIC16F630 Temp meter prototype](https://raw.githubusercontent.com/hpaluch/temp_meter_16f630/master/temp-meter-prototype.jpg)

Above image is from revived project in 2022 (original was written in 2013)
  
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

According to various reports including this:

> https://forum.arduino.cc/t/ds18b20-self-heating-or-what/208495
>
> Bare device, 5-V supply, 1-second polling - self-heating up to 2-Celsius and rising.
> Stuck an old Stanley knife blade on as a heat sink and self-heating
> at 30-second polling less than +0.5-Celsius.

So I have to use TO-92 heat sink for DS18B20 and possibly even reduce poll interval
to avoid _self-heting_ of temperature sensor.



# Resources

Realated projects:

- https://github.com/hpaluch/microstick2-projects#project-pic24fj-thermometer
  - Thermometer with PIC24FJ64GB002, DS18B20 and 4-digit multiplexed LED display BQ-M512RD
  - written in C (no assembly)

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
