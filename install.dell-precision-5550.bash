# Dell Precision 5550 fingerprint driver install

# adapt key in apt-key line if key is not matching
#W: GPG error: http://linux.dell.com/repo/community/ubuntu bionic Release: The following signatures couldn't
# be verified because the public key is not available: NO_PUBKEY F9FDA6BED73CDC22
#E: The repository 'http://linux.dell.com/repo/community/ubuntu bionic Release' is not signed.
#N: Updating from such a repository can't be done securely, and is therefore disabled by default.
#N: See apt-secure(8) manpage for repository creation and user configuration details.
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F9FDA6BED73CDC22

# Add dell apt repos to allow driver install (and get updates later)
sudo add-apt-repository 'deb http://dell.archive.canonical.com/updates focal-oem public'
sudo add-apt-repository 'deb http://dell.archive.canonical.com/updates focal-dell public'
sudo add-apt-repository 'deb http://dell.archive.canonical.com/updates focal-somerville public'

# Add fingerprint driver
sudo apt-get update
sudo apt -y install libfprint-2-tod1-goodix
