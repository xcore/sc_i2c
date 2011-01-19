#The root of the sandbox
APPS_ROOT ?= ../..

#The name of the package. This will be appended with the version to make
#the name of the zipfile used to distribute the package.
PACKAGE=xmos_i2c

#The name of the viewfile for the package. This is assumed to be in 
#apps_views in the xgit domain.
VIEWFILE=swc_i2c.txt

#The version of the tools for which this is tested e.g. 9.9.2
TOOLS=9.9.2

#The version of the package
VERSION=module_i2c

#List of modules to be published
MODULES=module_i2c module_xmos_common

#List of apps to be published
APPS=app_xdk_xai_i2c_test

include $(APPS_ROOT)/infr_apps/build/Makefile.package
