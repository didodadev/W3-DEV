<cfinclude template="../fbx_workcube_param_gecici.cfm">

<cftry>

    <cfset acilis_codu_ = '<cfquery name="ADD_QUERY" datasource="#DSN#">'>
    <cfset kapanis_codu_ = '</cfquery>'>
    <cfset maxRowForQuery = 5000>

    <cfset fileNames = ["WRK_SOLUTION","WRK_FAMILY","WRK_MODULE","MODULES","WRK_OBJECTS"] >
    
    <cfloop from = "1" to = "#ArrayLen(fileNames)#" index = "i">
        
        <cfquery name="GET_MODUL_MENUS" datasource="#DSN#">
            SELECT TOP 1 * FROM #fileNames[i]#
        </cfquery>

        <cfif GET_MODUL_MENUS.recordcount eq 0>
            <cfset newFile = "">
            <cfset filePath = "moduleMenus/#fileNames[i]#.cfm">
            
            <cfsavecontent variable="fileContent"><cfinclude template="#filePath#"></cfsavecontent>
            <cfset fileContent = replace(fileContent,'v16_catalyst','#DSN#','all')>
            <cfset fileContent = replace(fileContent,'GO','','all')>
           
            <cfset linecount = listlen(fileContent,chr(13))>
            
            <cfif linecount gte 5000>

                <cfset row = 1>
                <cfset queryCount = 1>
                <cffile action="write" output="#fileContent#" addnewline="yes" file="#index_folder_ilk_#moduleMenus/#fileNames[i]#.txt" charset="utf-8">
                <cfset newFile = acilis_codu_>
                <cfloop index="line" file="#index_folder_ilk_#moduleMenus/#fileNames[i]#.txt" charset="utf-8">
                    
                    <cfif row MOD maxRowForQuery eq 0>
                        <cfset queryCount = queryCount + 1> 
                        <cfset newFile = "#newFile# #line# #kapanis_codu_##acilis_codu_#">
                    <cfelseif row eq linecount>
                        <cfset newFile = "#newFile# #line# #kapanis_codu_#">
                    <cfelse>
                        <cfset newFile = "#newFile# #line#">	
                    </cfif>
                    <cfset row = row + 1>

                </cfloop>
            
            <cfelse>
         
                <cfset newFile = "#acilis_codu_##fileContent##kapanis_codu_#">
        
            </cfif>
       
            <cffile action="write" output="#newFile#" addnewline="yes" file="#index_folder_ilk_##fileNames[i]#.cfm" charset="utf-8">
            
            <cftransaction>
                <cfinclude template="#fileNames[i]#.cfm">
            </cftransaction>

            <cfif FileExists("#index_folder_ilk_#moduleMenus/#fileNames[i]#.txt")>
                <cffile action="delete" file="#index_folder_ilk_#moduleMenus/#fileNames[i]#.txt">
            </cfif>
            <cffile action="delete" file="#index_folder_ilk_##fileNames[i]#.cfm">

        </cfif>
        
        
    </cfloop>

    <cfcatch type = "any">
        There was an error when system objects are creating!
        <cfabort>
    </cfcatch>

</cftry>
