# Jenkins Master Attributes
default[:jenkins][:master][:repository] 	= 'http://pkg.jenkins-ci.org/debian-stable'
default[:jenkins][:master][:repository_key] 	= 'http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key'
default[:jenkins][:master][:version] 		= '2.7.1'
override[:jenkins][:master][:jvm_options] 	= '-Djenkins.install.runSetupWizard=false'
