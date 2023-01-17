<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>

    <cfset _index_folder = replacelist(expandPath("/"), "\", "/")>
    
    <!--- TEST --->
    <cffunction name="test" access="remote" returntype="string" output="no">
    	<cfreturn "test component is accessible">
    </cffunction>

	<!--- GET CLASS INFORMATION --->
	<cffunction name="getClassInfo" access="remote" returntype="struct" output="no">
        <cfargument name="class_id" type="string" required="yes">
        
        <cfquery name="get_class_info" datasource="#dsn#" maxrows="1">
            SELECT TOP 1
				TC.CLASS_NAME,
				TCT.EMP_ID,
                TCT.PAR_ID,
                TCT.CONS_ID 
            FROM 
                TRAINING_CLASS_TRAINERS TCT,
				TRAINING_CLASS TC
            WHERE 
				TC.CLASS_ID = TCT.CLASS_ID AND
                TC.CLASS_ID = #arguments.class_id#
        </cfquery>
        
        <cfset info = StructNew()>
        <cfif len(get_class_info.EMP_ID)>
			<cfquery name="get_trainer" datasource="#dsn#">
            	SELECT
					EMPLOYEES.EMPLOYEE_NAME NAME,
					EMPLOYEES.EMPLOYEE_SURNAME SURNAME,
					WRK_SESSION.WORKCUBE_ID WORKCUBE_ID
				FROM
					EMPLOYEES
					LEFT JOIN WRK_SESSION ON EMPLOYEES.EMPLOYEE_ID = WRK_SESSION.USERID AND WRK_SESSION.USER_TYPE = 0
				WHERE
                    EMPLOYEES.EMPLOYEE_ID = #get_class_info.EMP_ID#
            </cfquery>
        <cfelseif len(get_class_info.TRAINER_PAR)>
        	<cfquery name="get_trainer" datasource="#dsn#">
            	SELECT
                	COMPANY_PARTNER.COMPANY_PARTNER_NAME NAME,
                    COMPANY_PARTNER.COMPANY_PARTNER_SURNAME SURNAME,
                    WRK_SESSION.WORKCUBE_ID WORKCUBE_ID
               	FROM
               		COMPANY_PARTNER
					LEFT JOIN WRK_SESSION ON COMPANY_PARTNER.PARTNER_ID = WRK_SESSION.USERID AND WRK_SESSION.USER_TYPE = 1
               	WHERE
                    COMPANY_PARTNER.PARTNER_ID = #get_class_info.TRAINER_PAR#
            </cfquery>
         <cfelseif len(get_class_info.TRAINER_CONS)>
         	<cfquery name="get_trainer" datasource="#dsn#">
            	SELECT
                	CONSUMER.CONSUMER_NAME NAME,
                    CONSUMER.CONSUMER_SURNAME SURNMAE,
                    WRK_SESSION.WORKCUBE_ID WORKCUBE_ID
               	FROM
               		CONSUMER
                    LEFT JOIN WRK_SESSION ON CONSUMER.CONSUMER_ID = WRK_SESSION.USERID AND WRK_SESSION.USER_TYPE = 2
               	WHERE
                    CONSUMER.CONSUMER_ID = #get_class_info.TRAINER_CONS#
            </cfquery>
         <cfelse>
         	 <cfset get_trainer.recordcount = 0>
         </cfif>
		<cfif get_trainer.recordcount>
			<cfscript>
                StructInsert(info, "educatorWorkcubeID", "#get_trainer.WORKCUBE_ID#");
                StructInsert(info, "educatorRealname", "#get_trainer.NAME# #get_trainer.SURNAME#");
                StructInsert(info, "educationName", "#get_class_info.CLASS_NAME#");
                StructInsert(info, "status", "success");
            </cfscript>
        <cfelse>
        	<cfscript>
				StructInsert(info, "status", "fail");
            </cfscript>
        </cfif>
        <cfreturn info>
	</cffunction>
    
    <!--- GET FILES --->
	<cffunction name="getFiles" access="remote" returntype="array" output="no">
        <cfargument name="class_id" type="string" required="yes">
        
        <cfquery name="get_files" datasource="#dsn#">
			SELECT
                A.ASSET_FILE_NAME,
                A.MODULE_NAME,
                A.ASSET_ID,
                A.ASSETCAT_ID,
                A.ASSET_NAME,
                A.ASSET_FILE_SIZE,
                A.ASSET_FILE_SERVER_ID,
                ASSET_CAT.ASSETCAT,
                ASSET_CAT.ASSETCAT_PATH
            FROM
                ASSET A,
                ASSET_CAT
            WHERE
	            A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
                A.ACTION_SECTION = 'CLASS_ID' AND
                A.ACTION_ID = #arguments.class_id#
            ORDER BY 
                A.RECORD_DATE DESC
        </cfquery>
        
        <cfset _files = []>
        <cfloop query="get_files">
			<cfif ASSETCAT_ID gte 0>
                <cfset _path = "/documents/asset/#ASSETCAT_PATH#/#ASSET_FILE_NAME#">
            <cfelse>
	            <cfset _path = "/documents/#ASSETCAT_PATH#/#ASSET_FILE_NAME#">
            </cfif>
            
        	<cfset _file = StructNew()>
            <cfscript>
				StructInsert(_file, "name", "#get_files.ASSET_NAME#");
				StructInsert(_file, "path", "#_path#");
				StructInsert(_file, "size", "#get_files.ASSET_FILE_SIZE#");
				ArrayAppend(_files, _file);
            </cfscript>
        </cfloop>
        
        <cfreturn _files>
   	</cffunction>
</cfcomponent>