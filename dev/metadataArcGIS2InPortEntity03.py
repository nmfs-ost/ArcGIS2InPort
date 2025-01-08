#!/usr/bin/env python
# coding: utf-8

import arcpy
from arcpy import metadata as md
import os
import xml.dom.minidom

def prettyXML(metadata):
    try:
        dom = xml.dom.minidom.parse(metadata) # or xml.dom.minidom.parseString(xml_string)

        pretty_xml_as_string = dom.toprettyxml()

        lines = pretty_xml_as_string.split("\n")

        non_empty_lines = [line for line in lines if line.strip() != ""]

        string_without_empty_lines = ""

        for line in non_empty_lines:
            string_without_empty_lines += line + "\n"

        #open(metadata, 'w').write(pretty_xml_as_string)
        open(metadata, 'w').write(string_without_empty_lines)

        del dom, pretty_xml_as_string, lines, non_empty_lines
        del string_without_empty_lines, line
        del metadata

    except:
        import sys, traceback
        # Get the traceback object
        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        # Concatenate information together concerning the error into a message string
        pymsg = "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
        msgs = "Arcpy Errors:\n" + arcpy.GetMessages(2) + "\n"
        arcpy.AddError(pymsg)
        arcpy.AddError(msgs)
        arcpy.AddMessage(pymsg)
        arcpy.AddMessage(msgs)
        del tb, tbinfo, pymsg, msgs

# ----- variables section ----
arcpy.env.overwriteOutput = True

# XSL Location
# Path
xslTemplatePath = r'C:\Users\john.f.kennedy\Documents\GitHub\DisMAP\ArcGIS Analysis - Python\ArcGIS2InPort'

# make sure the name of the XSL style sheet is up-to-date
mainXslFilename = 'ArcGIS2InportV08.xsl'

# make sure the name of the xsl style sheet is up-to-date
entityXslFilename = "ArcGIS2InPort_entityV02.xsl"

# ----- Project section ----
# Project Folder
projectFolder = r'C:\Users\john.f.kennedy\Documents\GitHub\DisMAP\ArcGIS Analysis - Python\May 16 2022'

# Import Metadata Path - can be a folder or a geodatabase
importMetadataPath = os.path.join(projectFolder, 'ArcGIS Metadata May 16 2022 Dev')
#importMetadataPath = os.path.join(projectFolder, 'DisMAP May 16 2022 Dev.gdb')

# Export Metadata Path - is a folder
exportMetadataPath = os.path.join(projectFolder, 'Export Metadata May 16 2022 Dev')
# wildcard
wildcard = 'Indicators'
#wildcard = 'Regions'
#wildcard = 'Survey Locations'

# before running this notebook, you set the required constants below:
#    - parentCatalogItemId (use when creating a new inport record, leave blank '' when updating an inport record)
#    - catalogItemId (use when updating an inport record, leave bland '' when creating a new inport record)

##parameters = {
##              'parentCatalogItemId':"99999",
##              'catalogItemId':"",
##             }

#parentCatalogItemId = "67352" # DisMAP Regions
parentCatalogItemId = "" # Survey Locations
catalogItemId       = "67346"
#parentCatalogItemId = "" # Survey Locations
#catalogItemId       = "67363"


parameters = {
                'parentCatalogItemId' : parentCatalogItemId,
                'catalogItemId'       : catalogItemId,
             }

del parentCatalogItemId, catalogItemId

# ----- end variables section ------

# Read in the xsl file and replace the parameter values
with open(xslTemplatePath+"\\"+entityXslFilename, 'r') as file:
    filedata = file.read()

for k in parameters:
    # Replace the target string
    filedata = filedata.replace("["+k+"]", parameters[k])

if k: del k

# Write the file out again to the workspace folder
with open(exportMetadataPath+"\\"+entityXslFilename, 'w') as file:
    file.write(filedata)
    file.close()
    del file, filedata

# Describe importMetadataPath
desc = arcpy.Describe(importMetadataPath)

# Get Import Metadata Path Type
importMetadataPathType = desc.workspaceType

# Print Message
arcpy.AddMessage("Import Metadata Path '{0}' is a {1}".format(os.path.basename(importMetadataPath), desc.workspaceType))
del desc

# Describe exportMetadataPath
desc = arcpy.Describe(exportMetadataPath)

# Print Message
arcpy.AddMessage("Export Metadata Path '{0}' is a {1}".format(os.path.basename(exportMetadataPath), desc.workspaceType))
del desc

arcpy.env.workspace = importMetadataPath

##        datasets = list(set(arcpy.ListDatasets("*")) |
##                        set(arcpy.ListFeatureClasses("*")) |
##                        set(arcpy.ListRasters("*")) |
##                        set(arcpy.ListTables("*")) |
##                        set(arcpy.ListFiles("*"))
##                        )

if importMetadataPathType == "FileSystem":
    datasets = list(
                    set(arcpy.ListFiles(f"*{wildcard}*.xml"))
                   )
elif importMetadataPathType == "LocalDatabase":
    datasets = list(
                    set(arcpy.ListDatasets(f"*{wildcard}*")) |
                    set(arcpy.ListFeatureClasses(f"*{wildcard}*")) |
                    set(arcpy.ListRasters(f"*{wildcard}*")) |
                    set(arcpy.ListTables(f"*{wildcard}*"))
                   )
else:
    arcpy.AddMessage("Not supported import path type")

if datasets:
    try:

        for dataset in datasets:
            arcpy.AddMessage(f"\t {dataset}")

            dataset_metadata = md.Metadata(os.path.join(importMetadataPath, dataset))
            arcpy.AddMessage(f"\t\t {dataset_metadata.title}")

            #output_metadata = os.path.join(exportMetadataPath, f"{dataset.replace('.xml', '')} InPort.xml")
            #arcpy.AddMessage(f"\t\t {output_metadata}")

            output_metadata = os.path.join(exportMetadataPath, f"{dataset.replace('.xml', '')} InPort Entity.xml")
            arcpy.AddMessage(f"\t\t {output_metadata}")

            #custom_xsl = os.path.join(exportMetadataPath, mainXslFilename)
            #arcpy.AddMessage(f"\t\t {custom_xsl}")

            custom_xsl = os.path.join(exportMetadataPath, entityXslFilename)
            arcpy.AddMessage(f"\t\t {custom_xsl}")

            dataset_metadata.exportMetadata(output_metadata, "CUSTOM", "EXACT_COPY", custom_xsl)
            #dataset_metadata.saveAsUsingCustomXSLT(output_metadata, custom_xsl)

            prettyXML(output_metadata)

            #msg = arcpy.GetMessages()
            #msg = ">-> {0}".format(msg.replace('\n', '\n>-> '))
            #arcpy.AddMessage(msg)
            #del msg

            del dataset_metadata, output_metadata, custom_xsl

            del dataset
    except:
        import sys, traceback
        # Get the traceback object
        tb = sys.exc_info()[2]
        tbinfo = traceback.format_tb(tb)[0]
        # Concatenate information together concerning the error into a message string
        pymsg = "PYTHON ERRORS:\nTraceback info:\n" + tbinfo + "\nError Info:\n" + str(sys.exc_info()[1])
        msgs = "Arcpy Errors:\n" + arcpy.GetMessages(2) + "\n"
        arcpy.AddError(pymsg)
        arcpy.AddError(msgs)
        arcpy.AddMessage(pymsg)
        arcpy.AddMessage(msgs)
        del tb, tbinfo, pymsg, msgs

else:
    arcpy.AddMessage("Can't find datasets")

del importMetadataPathType

del xslTemplatePath, mainXslFilename, entityXslFilename, projectFolder, importMetadataPath
del exportMetadataPath, parameters, datasets, wildcard, prettyXML

localKeys =  [key for key in locals().keys() if not key.endswith('__') and key not in ['xml', 'logging', 'sys', 'time', 'datetime', 'math', 'numpy', 'arcpy', 'md', 'os']]

if localKeys:
    msg = "Local Keys: {0}".format(u", ".join(localKeys))
    arcpy.AddMessage(msg); del msg

###enter the gdb name here if using one, e.g. mystuff.gdb
##gdbname = ""
##
###do not include .shp if using a shapefile
##fcname = "template_poly_range"
##
### before running this notebook, you set the required constants below
###
### defaultEffectiveDate is always required. Example 2018-06
###    - defaultEffectiveDate (effective dates for contacts - there is no where to enter this in metadata so it must be entered in the xslt file)
### one of these is always required
###    - parentCatalogItemId (use when creating a new inport record, leave blank '' when updating an inport record)
###    - catalogItemId (use when updating an inport record, leave bland '' when creating a new inport record)
### the following are only needed if you do not provide these contacts directly in your metadata
###    - defaultPointOfContactEmail (in ArcGIS Pro metadata, define this contact in Resource>Points of Contact)
###    - defaultDataStewardEmail (in ArcGIS Pro metadata, define this contact in Overview>Citation Contacts)
###    - defaultMetadataContactEmail (in ArcGIS Pro metadata, define this contact in Metadata>Contacts)
###    - defaultOrganizationName (in ArcGIS Pro metadata, define this contact in Resource>Distribution>Distributor )
##
##parameters = {
##    'defaultEffectiveDate':"2021-01",
##    'parentCatalogItemId':"99999",
##    'catalogItemId':"",
##    'defaultPointOfContactEmail':"pointofcontact@noaa.gov",
##    'defaultDataStewardEmail':"datasteward@noaa.gov",
##    'defaultMetadataContactEmail':"metadata@noaa.gov",
##    'defaultOrganizationName':"Default OrgName"}
##
### ----- end variables section ------
##
### Read in the xsl file and replace the parameter values
##with open(xslTemplatePath+"\\"+mainXslFilename, 'r') as file :
##  filedata = file.read()
##
##for k in parameters:
##    # Replace the target string
##    filedata = filedata.replace("["+k+"]", parameters[k])
##
### Write the file out again to the workspace folder
##with open(exportMetadataPath+"\\"+mainXslFilename, 'w') as file:
##  file.write(filedata)
##
##arcpy.env.overwriteOutput = True
##
##if gdbname:
##    arcpy.env.workspace = exportMetadataPath+"/"+gdbname
##else:
##    arcpy.env.workspace = exportMetadataPath
##
##fcs = arcpy.ListFeatureClasses(fcname+"*")
##
##if len(fcs) == 0:
##    print("Can't find feature class or shapefile")
##else:
##    print("working")
##    layer_metadata = md.Metadata(fcs[0])
##    layer_metadata.exportMetadata(exportMetadataPath+"/"+fcname+"InPort.xml","CUSTOM","EXACT_COPY",exportMetadataPath+"/"+mainXslFilename)


