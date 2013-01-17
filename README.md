# puppet-sunjdk

Install the Sun (Oracle) JDK under /usr/java from a tarball.

## Usage

Include the sunjdk module in your puppet configuration:

    include sunjdk

and add required hiera configuration - for example:

    sunjdk::versions:
      jdk1.7.0_09:
        filename: 'jdk-7u9-linux-x64.tar.gz'
        default: true

## Support

License: Apache License, Version 2.0

GitHub URL: http://erwbgy.github.com/puppet-sunjdk

