#!/usr/bin/env python
# coding: utf-8

# In[1]:


import arcpy
import os

# In[4]:


from arcpy import metadata as md


# In[ ]:


# ----- variables section -------


# In[5]:


# This is where you saved the template xsl files
# xslTemplatePath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\ArcGIS2InPort"
xslTemplatePath = "C:\\Users\\john.f.kennedy\\Documents\\GitHub\\DisMap\\ArcGIS Analysis\\March 2022\\ArcGIS2InPort"


# In[ ]:


# make sure the name of the xsl style sheet is up-to-date
entityXslFilename = "ArcGIS2InPort_entityV02.xsl"


# In[6]:


# this is the path that your shapefile or geodatabase resides in
# workspacepath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\metadatafromscratch"
workspacepath = "C:\\Users\\john.f.kennedy\\Documents\\GitHub\\DisMap\\ArcGIS Analysis\\March 2022"

if not os.path.isdir(workspacepath+"/Export Metadata/"):
    os.makedirs(workspacepath+"/Export Metadata/")

# In[ ]:


#enter the gdb name here if using one, e.g. mystuff.gdb
#gdbname = ""
gdbname = "DisMap March 2022 Dev.gdb"


# In[ ]:


#do not include .shp if using a shapefile
#fcname = "template_poly_range"


# In[12]:


# before running this notebook, you set the required constants below:
#    - parentCatalogItemId (use when creating a new inport record, leave blank "" when updating an inport record)
#    - catalogItemId (use when updating an inport record, leave blank "" when creating a new inport record)


# In[21]:


parameters = {
    'parentCatalogItemId':"99999",
    'catalogItemId':"",
}


# In[ ]:


# ----- end variables section -----


# In[22]:


# Read in the xsl file and replace the parameter values
with open(xslTemplatePath+"\\"+entityXslFilename, 'r') as file :
  filedata = file.read()

for k in parameters:
    # Replace the target string
    filedata = filedata.replace("["+k+"]", parameters[k])

# Write the file out again to the workspace folder
with open(workspacepath+"\\"+entityXslFilename, 'w') as file:
  file.write(filedata)


# In[25]:


arcpy.env.overwriteOutput = True


# In[26]:


if gdbname:
    arcpy.env.workspace = workspacepath+"/"+gdbname
else:
    arcpy.env.workspace = workspacepath


# In[27]:

#fcs = arcpy.ListFeatureClasses(fcname+"*")
fcs = arcpy.ListFeatureClasses("*Survey_Locations")


# In[28]:


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
            #layer_metadata.exportMetadata(workspacepath+"/"+fcname+"InPortEntity.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+entityXslFilename)
            # Adding the Export Metadata folder to path
            layer_metadata.exportMetadata(workspacepath+"/Export Metadata/"+fc+"_InPort_Entity.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+entityXslFilename)
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




