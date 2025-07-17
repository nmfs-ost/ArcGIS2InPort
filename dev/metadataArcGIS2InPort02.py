#!/usr/bin/env python
# coding: utf-8

# In[3]:


import arcpy


# In[4]:


from arcpy import metadata as md


# In[ ]:


# ----- variables section ----


# In[5]:


xslTemplatePath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\ArcGIS2InPort"


# In[ ]:


mainXslFilename = "ArcGIS2InportV07.xsl"


# In[6]:


workspacepath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\metadatafromscratch"


# In[ ]:


#enter the gdb name here if using one, e.g. mystuff.gdb
gdbname = ""


# In[ ]:


#do not include .shp if using a shapefile
fcname = "template_poly_range" 


# In[8]:


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


parameters = {
    'defaultEffectiveDate':"2021-01",
    'parentCatalogItemId':"99999",
    'catalogItemId':"",
    'defaultPointOfContactEmail':"pointofcontact@noaa.gov",
    'defaultDataStewardEmail':"datasteward@noaa.gov",
    'defaultMetadataContactEmail':"metadata@noaa.gov",
    'defaultOrganizationName':"Default OrgName"}


# In[ ]:


# ----- end variables section ------


# In[18]:


# Read in the xsl file and replace the parameter values
with open(xslTemplatePath+"\\"+mainXslFilename, 'r') as file :
  filedata = file.read()

for k in parameters:
    # Replace the target string
    filedata = filedata.replace("["+k+"]", parameters[k])

# Write the file out again to the workspace folder
with open(workspacepath+"\\"+mainXslFilename, 'w') as file:
  file.write(filedata)


# In[22]:


arcpy.env.overwriteOutput = True


# In[23]:


if gdbname:
    arcpy.env.workspace = workspacepath+"/"+gdbname
else:
    arcpy.env.workspace = workspacepath


# In[24]:


fcs = arcpy.ListFeatureClasses(fcname+"*")


# In[26]:


if len(fcs) == 0:
    print("Can't find feature class or shapefile")
else:
    print("working")
    layer_metadata = md.Metadata(fcs[0])
    layer_metadata.exportMetadata(workspacepath+"/"+fcname+"InPort.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+mainXslFilename)
    


# In[ ]:




