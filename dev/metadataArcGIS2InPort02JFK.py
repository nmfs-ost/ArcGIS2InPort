#!/usr/bin/env python
# coding: utf-8

import arcpy
import os
from arcpy import metadata as md

# ----- variables section -------

arcpy.env.overwriteOutput = True


# This is where you saved the template xsl files
# xslTemplatePath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\ArcGIS2InPort"
#xslTemplatePath = os.path.dirname(os.path.realpath(__file__))
xslTemplatePath =  r'C:\Users\john.f.kennedy\Documents\GitHub\DisMAP\ArcGIS Analysis - Python\ArcGIS2InPort'

# Template XSL file for InPort record
mainXslFilename = "ArcGIS2InportV07.xsl"

# this is the path that your shapefile or geodatabase resides in
# workspacepath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\metadatafromscratch"
workspacepath = r"C:\Users\john.f.kennedy\Documents\GitHub\DisMAP\ArcGIS Analysis - Python\May 16 2022"

if not os.path.isdir(workspacepath+"/Export Metadata/"):
    os.makedirs(workspacepath+"/Export Metadata/")

#enter the gdb name here if using one, e.g. mystuff.gdb
#gdbname = ""
gdbname = "DisMAP May 16 2022 Dev.gdb"


# Do not include .shp if using a shapefile
# fcname = "template_poly_range"

# before running this notebook, you set the required constants below
#
# defaultEffectiveDate is always required. Example 2018-06
#    - defaultEffectiveDate (effective dates for contacts - there is no where to enter this in metadata so it must be entered in the xslt file)
# one of these is always required
#    - parentCatalogItemId (use when creating a new inport record, leave blank '' when updating an inport record)
#    - catalogItemId (use when updating an inport record, leave bland '' when creating a new inport record)
# the following are only needed if you do not provide these contacts directly in your metadata
#    - defaultPointOfContactEmail (in ArcGIS Pro metadata, define this contact in Resource>Points of Contact)
#    - defaultDataStewardEmail (in ArcGIS Pro metadata, define this contact in Overview>Citation Contacts)
#    - defaultMetadataContactEmail (in ArcGIS Pro metadata, define this contact in Metadata>Contacts)
#    - defaultOrganizationName (in ArcGIS Pro metadata, define this contact in Resource>Distribution>Distributor )


# In[15]:

# parameters = {
#               'defaultEffectiveDate':"2021-01",
#               'parentCatalogItemId':"99999",
#               'catalogItemId':"",
#               'defaultPointOfContactEmail':"pointofcontact@noaa.gov",
#               'defaultDataStewardEmail':"datasteward@noaa.gov",
#               'defaultMetadataContactEmail':"metadata@noaa.gov",
#               'defaultOrganizationName':"Default OrgName"
#              }

parameters = {
              'defaultEffectiveDate':"2022-05-16",
              'parentCatalogItemId':"99999",
              'catalogItemId':"",
              'defaultPointOfContactEmail':"pointofcontact@noaa.gov",
              'defaultDataStewardEmail':"datasteward@noaa.gov",
              'defaultMetadataContactEmail':"metadata@noaa.gov",
              'defaultOrganizationName':"Default OrgName"
             }

# ----- end variables section ------

# Read in the xsl file and replace the parameter values
with open(xslTemplatePath+"\\"+mainXslFilename, 'r') as file:
    filedata = file.read()

for k in parameters:
    # Replace the target string
    filedata = filedata.replace("["+k+"]", parameters[k])

# Write the file out again to the workspace folder
with open(workspacepath+"\\"+mainXslFilename, 'w') as file:
  file.write(filedata)


if gdbname:
    arcpy.env.workspace = workspacepath+"/"+gdbname
else:
    arcpy.env.workspace = workspacepath

# In[24]:

# fcs = arcpy.ListFeatureClasses(fcname+"*")
fcs = arcpy.ListFeatureClasses("*Survey_Locations")

# In[26]:

#if len(fcs) == 0:
#    print("Can't find feature class or shapefile")
#else:
#    print("working")
#    layer_metadata = md.Metadata(fcs[0])
#    layer_metadata.exportMetadata(workspacepath+"/"+fcname+"InPort.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+mainXslFilename)

if len(fcs) == 0:
    print("Can't find feature class or shapefile")
else:
    print("working")
    # Looping feature classes
    for fc in fcs:
        print("\t {0}".format(fc))
        try:

            #layer_metadata = md.Metadata(fcs[0])
            layer_metadata = md.Metadata(fc)
            print("\t\t {0}".format(layer_metadata.title))
            #layer_metadata.exportMetadata(workspacepath+"/"+fcname+"InPortEntity.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+mainXslFilename)
            # Adding the Export Metadata folder to path
            layer_metadata.exportMetadata(workspacepath+"/Export Metadata/"+fc+"_InPort.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+mainXslFilename)
            del layer_metadata

        except:
            print("###--->>> Something wrong with: {0} <<<---###".format(fc))
            import sys, traceback
            # Get the traceback object
            tb = sys.exc_info()[2]
            tbinfo = traceback.format_tb(tb)[0]
            # Concatenate information together concerning the error into a message string
            pymsg = "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
            print(pymsg)
            del pymsg, tb, tbinfo



# In[ ]:




