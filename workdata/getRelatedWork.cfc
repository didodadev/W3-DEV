<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
		
        <cfargument name="other_parameters" default="">
        <cfset parameter_name_list = ''>
        <cfset parameter_value_list = ''>                
        
        <cfif len(arguments.other_parameters)>
            <cfloop list="#arguments.other_parameters#" delimiters="/" index="opind">
                <cfset parameter_name_list = listappend(parameter_name_list,ListGetAt(opind,1,'*'))>
                <cfif listlen(opind,'*') eq 2>
                    <cfset parameter_value_list = listappend(parameter_value_list,ListGetAt(opind,2,'*'))>
                <cfelse>
                    <cfset parameter_value_list = listappend(parameter_value_list,'*-*')>
                </cfif>
            </cfloop>
        </cfif>
            
        <cfquery name="getRelatedWork_" datasource="#dsn#">
            SELECT
                PW.WORK_ID,
                PW.WORK_HEAD,
                PW.TARGET_START,
                PP.PROJECT_ID,
                PP.PROJECT_HEAD
            FROM
                PRO_WORKS PW,
                PRO_PROJECTS PP,
                PRO_WORK_RELATIONS PWR
            WHERE
				<!--- <cfif listlen(parameter_name_list) and listfindnocase(parameter_name_list,'project_id')>
                    <cfset sira_ = listfindnocase(parameter_name_list,'project_id')>
                    <cfset deger_ = listgetat(parameter_value_list,sira_)>
                    PROJECT_ID = #deger_# AND
                </cfif> --->
                PWR.WORK_ID = PW.WORK_ID AND
                PW.PROJECT_ID = PP.PROJECT_ID AND
               	PW.WORK_STATUS = 1 AND 
                PW.PROJECT_ID IS NOT NULL AND
                WORK_HEAD LIKE '%#arguments.keyword#%'
            ORDER BY 
                WORK_ID
          </cfquery>
        <cfreturn getRelatedWork_>
    </cffunction>
</cfcomponent>

