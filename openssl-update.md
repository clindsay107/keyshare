# OpenSSL on OSX

If you are on OSX, you can check your openSSL version with the following:

    $ openssl version

If you have a version less than what was specified above, you can upgrade through homebrew like so:

    $ brew update
    $ brew install openssl
    $ brew link --force openssl

Then verify you have the correct version installed. If you still have a bad version, try the following:

Get your openssl path

    $ which openssl

Backup the old version

    $ mv /usr/bin/openssl /usr/bin/openssl_OLD

Then replace with a symlink to `/usr/local/Cellar/openssl/1.0.2d/bin/openssl`. For example, I would type the following:

    $ ln -s /usr/local/Cellar/openssl/1.0.2d/bin/openssl /usr/bin/openssl
