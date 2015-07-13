#!/bin/sh
#
# Helper script for bootstrapping the FreeNAS 10 GUI development environment
# on *BSD, OS X or Linux hosts.
#
# Author: jkh
# Company: iXsystems, Inc.

_SYSTEM=`uname -s`
_PREFIX=/usr/local/bin
_EXEC_SHELL=bash
_SUDO=sudo
_PKG_INSTALL="nopkg"
_FREENAS_GUI_REPO="http://github.com/freenas/gui"
_FREENAS_DEV="gulp"
_NPM_THINGS="bower gulp forever jshint jscs esprima-fb@15001.1.0-dev-harmony-fb"
_NODE_VERSION=0.12.7

whitcher()
{
	if ! which $1 >/dev/null 2>&1 ; then
		return 0
	else
		return 1
	fi
}

resolve()
{
	if [ "${_PKG_INSTALL}" == "nopkg" ]; then
		echo "I lack the talent to install packages on ${_SYSTEM} systems.  You will have to"
		echo "install the $1 package yourself.  I give up!"
		return 3
	fi

	if whitcher ${_SUDO}; then
		echo "I have no sudo command, so I am going to try installing packages non-privileged."
		_SUDO=""
	fi
	echo "I see you do not have $1.  I will now attempt to install it."
	if [ "${_PKG_INSTALL}" == "brew install" ]; then
		if ! ${_PKG_INSTALL} $1; then
			return 1
		fi
	elif ! ${_SUDO} ${_PKG_INSTALL} $1; then
		return 2
	fi
	return 0
}

echo "Hi, I am the FreeBSD GUI SDK bootstrapper!  I will now attempt to sniff your"
echo "system in various locations to make sure everything is in order, installing"
echo "software as necessary.  This may require sudo privileges, so be prepared for"
echo "me to ask you for your password."
echo
echo "Checking out your system..."
case "${_SYSTEM}" in
	Darwin)
		echo "Congratulations, you're on a Mac!"
		if ! whitcher port; then
			_PKG_INSTALL="port install"
		elif ! whitcher brew; then
			_PKG_INSTALL="brew install"
		fi
		;;
	FreeBSD)
		echo "You seem to be running FreeBSD.  Excellent choice."
		_PKG_INSTALL="pkg install"
		;;
	Linux)
		echo "I do not judge you for running Linux."
		if ! whitcher apt-get; then
			_PKG_INSTALL="apt-get install"
		else
			_PKG_INSTALL="yum install"
		fi
		;;
	*)
		echo "I'm sorry, but ${SYSTEM} is an unsupported platform"
		exit 1
		;;
esac

if ! echo "$PATH" | grep -q ${_PREFIX}; then
	echo "I'm sorry, but ${_PREFIX} must be in your PATH. Please edit your"
	echo "startup file(s) for ${SHELL} to include it and run me again!"
	exit 2
fi

if whitcher "${_EXEC_SHELL}" ; then
	_MSG="I cannot find the ${_EXEC_SHELL} shell"
	if /bin/sh --version 2>&1 | grep -q ${_EXEC_SHELL}; then
		echo "${_MSG} - however, your /bin/sh is ${_EXEC_SHELL} so OK"
	else
		echo "${_MSG} - you should install it and run me again."
		exit 3
	fi
fi

if whitcher python; then
	echo "Huh, no python on this system.  Let me try to install one."
	if ! resolve python; then
		echo "Can't install python interpreter on this system.  Unfortunately, all the webby"
		echo "things require python these days!  I must exit."
		exit 11
	fi
fi

if whitcher git; then
	if ! resolve git; then
		echo "I could not install git on this platform.  Your development experience may"
		echo "be less than satisfactory, but it's optional so proceeding anyway."
	else
		_HAVE_GIT="yes"
	fi
else
	_HAVE_GIT="yes"
fi

if [ "${_SYSTEM}" = "FreeBSD" ]; then
	if whitcher gmake; then
		if ! resolve gmake; then
			echo "Sorry, can't install gmake and I need that for FreeBSD specifically."
			echo "Please resolve this on your own and retry."
			exit 12
		fi
	fi
fi

if whitcher node; then
	if ! resolve npm; then
		echo "I wasn't able to install nodejs. Please do that yourself."
		exit 13
	fi
fi

if whitcher npm; then
	if ! resolve npm; then
		echo "I wasn't able to install npm. Please do that yourself."
		exit 14
	fi
fi

echo "Now installing all of the little fiddly things that node needs."
if ! npm install -g ${_NPM_THINGS}; then
	echo "Looks like some of the npm tools didn't install.  Whoops!"
	exit 10
fi

if [ ! -f bootstrap.sh -a "${_HAVE_GIT}" = "yes" ]; then
	echo "OK, the dev tools look good, now checking out the sources you will need"
	echo "to develop for the FreeNAS GUI."
	if [ -d gui ]; then
		echo "Using existing gui directory.  You might want to git pull"
	elif ! git clone ${_FREENAS_GUI_REPO}; then
		echo "Unable to clone the ${_FREENAS_GUI_REPO}. You will have to do this"
		echo "before you can develop for the FreeNAS 10 GUI."
		exit 8
	else
		echo "Sources are now checked out in the `pwd`/gui directory."
		echo "cd into that directory to begin developing with the ${_FREENAS_DEV} command"
	fi
	cd gui
fi
echo "Now resolving npm's installation dependencies.  This may take a moment."
npm install

echo "Congratulations, you have everything you need to develop for the FreeNAS GUI!"
echo "${_FREENAS_DEV} --help will provide basic usage instructions"
exit 0
