#!/usr/bin/env python
# coding: utf-8

# In[1]:


import arcpy


# In[4]:


from arcpy import metadata as md


# In[ ]:


# ----- variables section -------


# In[5]:


# This is where you saved the template xsl files
xslTemplatePath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\ArcGIS2InPort"


# In[ ]:


# make sure the name of the xsl style sheet is up-to-date
entityXslFilename = "ArcGIS2InPort_entityV02.xsl"


# In[6]:


# this is the path that your shapefile or geodatabase resides in
workspacepath = "C:\\Users\\tim.haverland\\Documents\\ArcGIS\\Projects\\metadatafromscratch"


# In[ ]:


#enter the gdb name here if using one, e.g. mystuff.gdb
gdbname = "" 


# In[ ]:


#do not include .shp if using a shapefile
fcname = "template_poly_range" 


# In[12]:


# before running this notebook, you set the required constants below:
#    - parentCatalogItemId (use when creating a new inport record, leave blank '' when updating an inport record)
#    - catalogItemId (use when updating an inport record, leave bland '' when creating a new inport record)


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


fcs = arcpy.ListFeatureClasses(fcname+"*")


# In[28]:


if len(fcs) == 0:
    print("Can't find feature class or shapefile")
else:
    print("working")
    layer_metadata = md.Metadata(fcs[0])
    layer_metadata.exportMetadata(workspacepath+"/"+fcname+"InPortEntity.xml","CUSTOM","EXACT_COPY",workspacepath+"/"+entityXslFilename)    


# In[ ]:




