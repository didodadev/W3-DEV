<cfcomponent>
	<cffunction name="getDistrict" access="public" returntype="query">
		<cfargument name="district_id" type="numeric" required="yes" default="0">
		<cfargument name="sortdir" type="string" required="no" default="ASC">
		<cfargument name="sortfield" type="string" required="no" default="DISTRICT_NAME">
		<cfquery name="Get_District" datasource="#this.dsn#">
			SELECT 
				*
			FROM 
				SETUP_DISTRICT
				<cfif arguments.district_id gt 0>
					WHERE
						DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.district_id#">
				</cfif>
			ORDER BY 
				#arguments.sortfield# #arguments.sortdir# 
		</cfquery>
		<cfreturn Get_District>
	</cffunction>
    
    <cffunction name="get_quarter_fnc" returntype="query">
    	<cfargument name="keyword" default="">
    	<cfargument name="city" default="">
    	<cfargument name="country" default="">
    	<cfquery name="get_quarter" datasource="#this.dsn#">
            SELECT 
                SD.*,
                SC.COUNTY_NAME,
                SCC.CITY_NAME,
                (SELECT IMS_CODE FROM SETUP_IMS_CODE WHERE IMS_CODE_ID = SD.IMS_CODE_ID) IMS_CODE,
                SD.POST_CODE	
            FROM
                SETUP_DISTRICT SD,
                SETUP_COUNTY SC,
                SETUP_CITY SCC
            WHERE
                SD.COUNTY_ID = SC.COUNTY_ID
                AND SC.CITY = SCC.CITY_ID
                <cfif len(arguments.keyword)>
                    AND (	SD.DISTRICT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            SCC.CITY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> OR
                            SC.COUNTY_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.keyword#%"> 
                        )
                </cfif>
                <cfif len(arguments.city)>
                    AND SCC.CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.city#"> 
                </cfif>
                <cfif len(arguments.country)>
                    AND SCC.COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.country#"> 
                </cfif>
            ORDER BY
                SCC.CITY_ID,
                SC.COUNTY_ID,
                SD.DISTRICT_NAME
        </cfquery>
		<cfreturn get_quarter>
    </cffunction>
    
    <cffunction name="UPD_IMS_CODE_FNC" returntype="any">
    	<cfargument name="ims_code_id" default="">
    	<cfquery name="UPD_IMS_CODE" datasource="#this.dsn#">
            UPDATE SETUP_IMS_CODE SET IMS_CODE = #arguments.ims_code# WHERE IMS_CODE_ID = #arguments.ims_code_id#
        </cfquery>
    </cffunction>
    
    <cffunction name="INS_IMS_CODE_FNC" returntype="any">
    	<cfargument name="ims_code" default="">
        <cfargument name="district_name" default="">
    	<cfquery name="INS_IMS_CODE" datasource="#this.dsn#">
            INSERT INTO 
                SETUP_IMS_CODE
            (
                IMS_CODE,
                IMS_CODE_NAME,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            ) 
            VALUES 
            (
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ims_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.district_name#">,
                '#cgi.remote_addr#',
                #now()#,
                #session.ep.userid#
            )
        </cfquery>
    </cffunction>
    
    <cffunction name="GET_IMS_CODE_FNC" returntype="query">
    	<cfargument name="ims_code" default="">
        <cfargument name="district_name" default="">
    	 <cfquery name="GET_IMS_CODE" datasource="#this.dsn#">
            SELECT 
                IMS_CODE_ID
            FROM 
                SETUP_IMS_CODE 
            WHERE 
                IMS_CODE = '#arguments.ims_code#' AND
                IMS_CODE_NAME = '#arguments.district_name#'
        </cfquery>
    </cffunction>
    
    <cffunction name="add_ins_fnc" returntype="any">
    	<cfargument name="county_id" default="">
        <cfargument name="district_name" default="">
        <cfargument name="ims_code_id" default="">
        <cfargument name="ims_code" default="">
        <cfargument name="post_code" default="">
        <cfargument name="part_name" default="">
    	<cfquery name="add_ins" datasource="#this.dsn#">
            INSERT INTO
                SETUP_DISTRICT
            (
                COUNTY_ID,
                DISTRICT_NAME,
                IMS_CODE_ID,
                POST_CODE,
                PART_NAME,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
            )
            VALUES
            (
                #arguments.county_id#,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.district_name#">,
                <cfif len(arguments.ims_code) and len(arguments.ims_code_id)>#arguments.ims_code_id#<cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.post_code#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.part_name#">,
                '#cgi.remote_addr#',
                #now()#,
                #session.ep.userid#
            )
        </cfquery>
    </cffunction>
    
    <cffunction name="upd_ins_fnc" returntype="any">
    	<cfargument name="county_id" default="">
        <cfargument name="district_name" default="">
        <cfargument name="ims_code_id" default="">
        <cfargument name="ims_code" default="">
        <cfargument name="post_code" default="">
        <cfargument name="part_name" default="">
        <cfargument name="district_id" default="">
    	<cfquery name="upd_ins" datasource="#this.dsn#">
            UPDATE
                SETUP_DISTRICT
            SET
                COUNTY_ID = #arguments.county_id#,
                DISTRICT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.district_name#">,
                IMS_CODE_ID = <cfif len(arguments.ims_code) and len(arguments.ims_code_id)>#arguments.ims_code_id#<cfelse>NULL</cfif>,
                UPDATE_IP = '#cgi.remote_addr#',
                POST_CODE=<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.post_code#">,
                PART_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.part_name#">,
                UPDATE_DATE = #now()#,
                UPDATE_EMP = #session.ep.userid#
            WHERE
                DISTRICT_ID = #arguments.district_id#	
        </cfquery>
    </cffunction>
</cfcomponent>
