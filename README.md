Determines the amount of time and percentage spent in each pre-configured HR zone. Enter your custom HR zones in either in the Rakefile and then generate the zones_config.yml file, or edit the yaml file directly. 

To run the script just run the main.rb script from the cli. This is still in progress, and intended to automate the logging of my race training season.  

Dependencies:

sudo apt-get install libxml2
sudo apt-get install python-pip
sudo pip install lxml
git clone https://github.com/dtcooper/python-fitparse.git
cp -R python-fitparse/fitparse /usr/local/lib/pythonX.Y/dist-packages

install gem https://github.com/fourq/google-drive-ruby

ruby main.rb
