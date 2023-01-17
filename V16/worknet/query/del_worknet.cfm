    <cfset uploadFolder = application.systemParam.systemParam().upload_folder>
    <cfset del_worknet = createObject("component", "V16.worknet.cfc.worknet")>

    <cfset getWorknet = del_worknet.select(wid:attributes.wid)>
    <cffile action="delete" file="#uploadFolder#asset/watalogyImages/#getWorknet.IMAGE_PATH#">

    <cfset delete = del_worknet.delete(wid : attributes.wid)>
    <cfset delRelationProduct = del_worknet.delRelationProduct(wid : attributes.wid)>
    <cfset delRelationCompany = del_worknet.delRelationCompany(wid : attributes.wid)>