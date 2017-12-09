# Luz 2

Fullscreen interactive motion graphics toy builder!

[![Screenshot](http://41.media.tumblr.com/accf5bff3d48056e959747db5fed666a/tumblr_nh8q2pWPCs1te3fw8o1_540.png)](http://lighttroupe.tumblr.com/)

Just add music, input devices, a projector, and you've got an addiction.

<http://lighttroupe.tumblr.com>

Create 'actors' using: vector shapes, animated gifs, sprites, webcams and videos.

Every actor gets unlimited effects that layer and combine in delightful ways.

Every setting of every effect can be animated to time or beats, or connected to any button or axis of your various input devices.

Luz supports wiimotes, Wacom tablets, joysticks, gamepads, and MIDI devices.

Luz can also be driven by external OpenSoundControl sending software.

Luz is written in Ruby and offloads all the heavy pixel pushing to ffmpeg, OpenGL, and your modern graphics card.

The Luz 2.0 interface was designed in Inkscape and the source SVGs are in the gui/images directory.

Luz has provided interactive visuals at hundreds of venues, festivals, and house parties!

[![Code Climate](https://codeclimate.com/github/lighttroupe/luz-next.png)](https://codeclimate.com/github/lighttroupe/luz-next)

## The Luz Project consists of:

- **Luz 2**: fullscreen motion graphics editor and performer (Ruby, OpenGL, SDL, OSC input)
- **Luz Input Manager**: sends live input device data to Luz (C++, Gtk, libwiimote, SDL Input, OSC out)
- **Luz Spectrum Analyzer**: sends live audio information to Luz (C++, Gtk, OpenGL, FFTW, OSC out)

## Video Tutorials

Here are some Luz 1 videos and tutorials (all the same concepts apply, only the interface is different):

<https://www.youtube.com/user/superlighttube/videos?flow=grid&sort=da&view=0>

# Running Luz

Luz currently only runs on Linux.  (Help is welcome porting it to OSX and Windows.)

1. open a terminal
2. sudo apt-get install git ruby ruby-dev ruby-pango libsdl2-dev libglw1-mesa-dev freeglut3-dev ruby-rmagick
3. sudo gem install ruby-sdl2 syck opengl glu glut
4. git clone https://github.com/lighttroupe/luz-next.git
5. cd luz-next
6. Optionally run **./build.sh** in utils/webcam for the Webcam plugin.
7. Optionally run **./build.sh** in utils/video_file for the Video plugin.
8. ./go

## Running Input Manager and Spectrum Analyzer

1. Install dependencies: **sudo apt-get install build-essential libx11-dev libxext-dev libxi-dev libbluetooth-dev libportmidi-dev libcwiid-dev liblo-dev libunique-dev libgtkmm-2.4-dev libasound2-dev libfftw3-dev libgtkmm-2.4-dev libgtkglextmm-x11-1.2-dev libgl1-mesa-dev libglu1-mesa-dev**

2. Run **make** in the root directory to build Input Manager and Spectrum Analyzer.

3. Ctrl-F9 and Ctrl-F10 from within Luz launch the apps.
