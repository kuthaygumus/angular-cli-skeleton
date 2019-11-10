#!/usr/bin/env bash

echo "Before script - OS is $TRAVIS_OS_NAME"

echo "Apply this temporary fix https://github.com/travis-ci/travis-ci/issues/9024"
sudo chown root /opt/google/chrome/chrome-sandbox
sudo chmod 4755 /opt/google/chrome/chrome-sandbox

# update webdriver (like npm run webdriver:update)
node ./node_modules/protractor/bin/webdriver-manager update
# rebuild again node-sass
npm rebuild node-sass

echo "Setting xvfb based on TRAVIS_OS_NAME"
# setting xvfb on Linux https://docs.travis-ci.com/user/gui-and-headless-browsers/#Using-xvfb-to-Run-Tests-That-Require-a-GUI
if [[ $TRAVIS_OS_NAME == 'linux' ]]; then
    # config required to run browsers
    export DISPLAY=:99.0
    echo "DISPLAY is $DISPLAY"
    sh -e /etc/init.d/xvfb start
    sleep 3 # give xvfb some time to start
else
    echo "Installing cask on $TRAVIS_OS_NAME"
    brew tap caskroom/cask

    echo "Installing chrome on $TRAVIS_OS_NAME"
    brew cask install google-chrome
fi


# codeclimate test reporter
echo "Preparing codeclimate test reporter - OS is $TRAVIS_OS_NAME"
curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
chmod +x ./cc-test-reporter
./cc-test-reporter before-build
