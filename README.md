# Zebra App

Installation Instructions

1. Download Xcode on a Mac
2. Be sure you have RubyGems on your computer and download Cocoapods
  1. Open a terminal window and type:
      `sudo gem install cocoapods`
  2. If you get an error saying something like "gem is not a valid command," download RubyGems from the following website: https://rubygems.org/pages/download/
  3. Otherwise, type in your password for your Mac, and a lot of files will be installed
3. Download the Xcode project onto your computer from Github
  1. In a Terminal window, type the following commands
      `cd ~/Desktop
      git clone https://github.com/cjbara/zebra.git`
  2. You might have to type your github username and password for this to work
4. Install the required Pods
  1. Once you have the project installed on your computer from Github, in a terminal, type
      `cd ~/Desktop/zebra/iOS/
      pod install`
  2. This should install the correct dependencies
5. Open the project
  1. Type
      `open Zebra.xcworkspace`
6. Run the project
  1. Either run it on the simulator or on an iPhone
  2. Click Device and select your correct device
  3. Click the play button in the top left of the Xcode screen
