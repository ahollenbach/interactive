# Interactive Music Experience
Interactive is an experiment in projection mapping computer generated visuals and videos that respond to changes in music. The project is built in Processing.


## Setup
This project has a few dependencies before we can get started.

First, install [Processing](https://processing.org/download/?processing). This has been tested with Processing 2.2.1. 

Once you install Processing, you need to install our custom fork of [SketchMapper](https://github.com/ahollenbach/sketch-mapper), which is a system that allows us to map our content (Processing sketches, video, images) to surfaces. The instructions for installation can be found in that repository.

Once SketchMapper is installed, (the ```target``` directory has been copied to your Processing library folder), we need to install [Generative Gestaltung](http://www.generative-gestaltung.de/code#library), a library/series of beautiful visualizations that we're using (at least for testing). Download the _Generative Design Library_. You'll also need to grab a few of the dependencies. _ControlP5_ is already provided by SketchMapper, so don't install that, but _Geomerative_ and _treemap_ may be necessary, depending on the visualizations used. To install these libraries, drag them to ```<Processing_Directory>/libraries``` (as you did for SketchMapper).

Lastly, clone this repository.

## Running
Simply open SketchMapperMain and press play! To go full-screen, go to ```Menu > Sketch > Present```. To change the visualization, click on a quad surface and change the source file.

## Adding visualizations
Adding visualizations is simple. I recommend copying the format of the existing visualizations and starting from there. If you want a non-black background, be sure to establish it in ```setup()```, as establishing it in the ```draw()``` routine will overwrite the visualization every time (unless this is something you want to do). You also need to add your sketch to the list of possible sketches in [SketchMapperMain.pde](SketchMapperMain/SketchMapperMain.pde). Make sure to give it a human-readable name that will appear in the dropdown.


## Team
- Andrew Hollenbach (@ahollenbach)
- Isaac Banner (@ibanner56)
- Janice Mok
- Thomas Tikos-Kadji
