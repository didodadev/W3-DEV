<cfsetting showdebugoutput="no">
<cfset my_file_ = listlast(cgi.path_info,'/')>
<cfset file_show = 1>

<cfquery name="GET_ASSET" datasource="#dsn#">
	SELECT TOP 1
    	ASSET_ID,
		ASSET_FILE_REAL_NAME,
		ASSET_FILE_NAME,
		RECORD_EMP,
        RECORD_PUB,
        RECORD_PAR
	FROM 
		ASSET
	WHERE 
		ASSET_FILE_NAME = '#my_file_#'
</cfquery>
<cfif GET_ASSET.recordcount>
    <cfquery name="GET_ASSET_REL" datasource="#dsn#">
        SELECT * FROM ASSET_RELATED WHERE ASSET_ID = #GET_ASSET.asset_id#
    </cfquery>
	<cfif get_asset_rel.recordcount>
        <cfquery name="GET_ALL_PEOPLE" dbtype="query">
            SELECT ASSET_ID FROM GET_ASSET_REL WHERE ALL_PEOPLE = 1
        </cfquery>
		<cfif GET_ALL_PEOPLE.recordcount>
			<cfset file_show = 1>
        <cfelse>
			<cfif isdefined("session.ep.userid")>
            	<cfquery name="GET_EMP_ALL" dbtype="query">
                    SELECT ASSET_ID FROM GET_ASSET_REL WHERE ALL_EMPLOYEE = 1
                </cfquery>
                <cfif not GET_EMP_ALL.RECORDCOUNT>
                    <cfquery name="GET_USER_CAT" datasource="#DSN#">
                        SELECT USER_GROUP_ID,POSITION_CAT_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
                    </cfquery>
                    <cfquery name="GET_DIGITAL_GROUP" datasource="#DSN#"><!--- Dijital varlık grubuna göre LS --->
                        SELECT GROUP_ID FROM DIGITAL_ASSET_GROUP_PERM WHERE POSITION_CODE = #session.ep.position_code# OR POSITION_CAT = (SELECT EP.POSITION_CAT_ID FROM EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = #session.ep.position_code#)
                    </cfquery>                    
                   <cfquery name="CONTROL_USER_CAT" dbtype="query">
                        SELECT 
                            ASSET_ID 
                        FROM 
                            GET_ASSET_REL
                        WHERE 
                        <cfif len(get_user_cat.user_group_id)>
                            (
                            USER_GROUP_ID = #get_user_cat.user_group_id# OR
                        </cfif> 
                            POSITION_CAT_ID = #get_user_cat.position_cat_id#
                        <cfif len(get_user_cat.user_group_id)>
                             )
                        </cfif> 
                        <cfif len(get_digital_group.group_id)>
                            OR DIGITAL_ASSET_GROUP_ID = #get_digital_group.group_id#
                        </cfif>
                    </cfquery>
                    <cfif not control_user_cat.recordcount and session.ep.userid neq get_asset.record_emp>
                        <cfset file_show = 0>
                    </cfif>
                </cfif>
            <cfelseif isdefined("session.pp.userid")>
            	 <cfquery name="CONTROL_USER_CAT" dbtype="query">
                    SELECT 
                        ASSET_ID 
                    FROM 
                        GET_ASSET_REL
                    WHERE                    
                        COMPANY_CAT_ID = #session.pp.company_category#
                </cfquery>
                <cfif not control_user_cat.recordcount and session.pp.userid neq get_asset.RECORD_PAR>
                    <cfset file_show = 0>
                </cfif>
            <cfelseif isdefined("session.ww.userid")>
            	<cfquery name="CONTROL_USER_CAT" dbtype="query">
                    SELECT 
                        ASSET_ID 
                    FROM 
                        GET_ASSET_REL
                    WHERE                    
                        CONSUMER_CAT_ID = #session.ww.consumer_category#
                </cfquery>
                <cfif not control_user_cat.recordcount and session.ww.userid neq get_asset.RECORD_PUB>
                    <cfset file_show = 0>
                </cfif>
            <cfelseif isdefined("session.cp")>
            	<cfquery name="GET_CAR_ALL" dbtype="query">
                    SELECT ASSET_ID FROM GET_ASSET_REL WHERE ALL_CAREER = 1
                </cfquery>
                <cfif not GET_CAR_ALL.RECORDCOUNT>
                	<cfset file_show = 0>
                </cfif>
            <cfelseif isdefined("session.ww") and not isdefined("session.ww.userid")>
            	<cfquery name="GET_PUB_ALL" dbtype="query">
                    SELECT ASSET_ID FROM GET_ASSET_REL WHERE ALL_INTERNET = 1
                </cfquery>
                <cfif not GET_PUB_ALL.RECORDCOUNT>
                	<cfset file_show = 0>
                </cfif>
            <cfelse>
            	 <cfset file_show = 0>        
            </cfif>
        </cfif>
	</cfif>
</cfif>
<cfif file_show eq 1>
	<cfheader name="Content-Disposition" value="attachment;filename=#my_file_#">
	<cfcontent file="#GetDirectoryFromPath(GetCurrentTemplatePath())#documents#replace(cgi.path_info,'/','\','all')#" type="application/octet-stream" deletefile="no">
<cfelse>
	<cfoutput>No Authorization!</cfoutput>
</cfif>
