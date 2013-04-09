#!/bin/sh

#  BuildForWindows.sh
#  TPPopoverTestHarness
#
#  Created by Frank Le Grand on 4/3/13.
#  Copyright (c) 2013 TestPlant. All rights reserved.

# You must run this script from the root folder of the project,
# using the --project option of pbxbuild is currently unreliable
# (at least on my machine).
export BASEPATH=`pwd`

#generate the pbxbuild directory:
pbxbuild -g
echo __________________________________
if [ -d pbxbuild ]
then
echo       PBXBUILD EXISTS --
echo Copying modified *.hm to TPPopoverTestHarness.app target...
find . -maxdepth 1 -name '*.[hm]' -newer pbxbuild/TPPopoverTestHarness.app -print -exec cp {} pbxbuild/TPPopoverTestHarness.app \;

echo Copying modified English.lproj files to TPPopoverTestHarness.app...
find en.lproj -type f ! -iwholename '*.svn*' -newer pbxbuild/TPPopoverTestHarness.app -print -exec cp {} pbxbuild/TPPopoverTestHarness.app/{} \;

touch pbxbuild/TPPopoverTestHarness.app

else
echo PBXBUILD DOES NOT EXIST -- Building
# Sometimes a stray Info-gnustep.plist file here messes up the build
rm -rf Info-gnustep.plist
pbxbuild -g
fi

echo _________________________
echo Copy customized makefiles
cp TPPopoverTestHarness_GNUmakefile pbxbuild/TPPopoverTestHarness.app/GNUmakefile


cd pbxbuild/
#cd ..

echo ______________
echo Kill Any Running Processes
taskkill //F //IM TPPopoverTestHarness.exe || true

echo ______________
echo Build TPPopoverTestHarness


#VERBOSE:
#make messages=yes install
#make install
make

RESULT=$?

cd $BASEPATH

# Return the value of the result, but don't exit the calling shell
$(exit $RESULT)
