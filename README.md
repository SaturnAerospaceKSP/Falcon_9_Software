# Falcon 9 Software
### Created in KRSS 2.5x 

## Current Version
- [x] Launch To Orbit
- [x] Booster Landing (RTLS & ASDS)
- [x] Recovery Accuracy = ~4m
- [X] Tundra Pad 40 & 39 Clamp Support

## In Development 
- [ ] Working Telemetry CPU
- [ ] Static Fires
- [ ] Dragon Operations
- [ ] Interplanetary Launches
- [ ] Specific LAN Targeting
- [ ] Smoother & Accurate Landings

## Mod List
[Tundra Explorations](https://github.com/TundraMods/TundraExploration/tree/master) 

[kOS](https://spacedock.info/mod/60/kOS:%20Scriptable%20Autopilot%20System)

[Trajectories](https://spacedock.info/mod/396/Trajectories)

[Droneship](https://spacedock.info/mod/3133/SpaceX%20Barge%20Lander%202)

[Hyperedit](https://www.kerbaltek.com/hyperedit)

[VesselMover](https://spacedock.info/mod/860/VesselMover)

[Realistic Towers (Optional)](https://spacedock.info/mod/626/SpaceX%20Launch%20Towers)

## INSTALLATION & USE
***BEFORE ANY ASDS Landings you MUST ensure that the droneship you want to place is placed somewhere in the world (if it's a vessel). Otherwise the code wont work. You can delete it using hyperedit once you place the real droneship!***

Ensure you have installed the software from here, then you must place it in this folder: 
[Install Location](https://lh3.googleusercontent.com/xGoidraLFlPYJURH5FbmFJYoXSEe2wbdf6UTdZ0SUE1UEoh3LnTnO3P6lzuYygtz86o4kGbp_Pmogsj4Qmb6fAL4H5IxgQwjMXYhB1evQhrFKqCmRzBWKyOuZHd85A9Fnw=w1280)

After this, you can enter the *Falcon_9_Software* folder and use the *Config* folder to setup the mission you intend to do, you may also link a custom launch site **(which you'll need to do for non KRSS 2.5x)** in [*landing_sites.ks*](https://lh6.googleusercontent.com/wC1QQI00l8736Chnv2XETbnAmFvAgIU6I_brWI_rKPQNmRJ75_HI9D0_yumezlsugoWFSMHN7eR5C0QTZxkVqQ15ZjSiKXfWma5qT2FVs7GTs4YtR1IotWOf5Fy3J5Gv0g=w1280) and change the setting for *Landing_Zone* in the [*settings.ks*](https://lh5.googleusercontent.com/hGPCexl7oTn4vFM4t8PRQpQV_3x-iHKgATIOtP9f1dPIMWwCzFDtMf7omE-kR4AEvUCzw5bD9fEsJPBOVqyTKWGAZNi1xdUBxM4yW1VAs7o5QPpYNvHAIiQEfEb9r-L2KQ=w1280) file.
Feel free to configure the settings to your hearts desire, as long as they make sense then they will work!

When you have configured the settings, you can now setup the craft. It is highly advised that you use the provided craft and have it as a template, as otherwise you will require a bit of kOS knowledge in order to understand part tags & where to put things.
When you open the craft you can add a payload, change the booster style and even change the strongback (the vehicle detects this automatically and will work with the Science818 towers)

### You can refer to this tutorial video for droneship placement on ASDS recoveries. 
If your droneship / barge has a different name in KSP then you can change it in *Falcon_9_Software > Initialization > Booster_Init.ks* on [this line ](https://lh4.googleusercontent.com/t959KoIUq39LPHs0FRumXB6_xKeZ6KxMvBEPxOqyTsw_LICfUL6AibIJEQiQobDUy56myJCTJsszW_0RVB7O2cZoxR9YYJIysZryWsieQnOF7cadpJeaiz91sh3cOoQtHw=w1280)

**Once on the pad, click AG6 to begin your countdown!**
If anything is wrong during the countdown, you may click AG9. This holds the countdown. From here you can click ag6 to continue, or AG9 to recycle the software (setting change for example)

### Stage 1 / 2
If you want to select which part of the vehicle to fly on, you may use a mod like [EasyVesselSwitch](https://spacedock.info/mod/1906/Easy%20Vessel%20Switch), or alternatively, you can just click the left or right square bracket after the stages separate.

# Thank you
Huge thank you to whoever uses my software, it would be great if you could credit me in your videos. I appreciate it!
