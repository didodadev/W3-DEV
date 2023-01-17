<cfquery name="CAMPAIGN" datasource="#DSN3#">
	SELECT
		CAMP_ID,
		USER_FRIENDLY_URL,
		PROJECT_ID,
		CAMP_HEAD,
		COMPANY_CAT,
		IS_EXTRANET,
		CONSUMER_CAT,
		IS_INTERNET,
		CAMP_STATUS,
		CAMP_NO,
		CAMP_TYPE,
		CAMP_CAT_ID,
		PROCESS_STAGE,
		CAMP_STARTDATE,
		CAMP_FINISHDATE,
		CAMP_OBJECTIVE,
		LEADER_EMPLOYEE_ID,
		RECORD_EMP,
		UPDATE_EMP,
		RECORD_DATE,
		UPDATE_DATE,
		CAMP_STAGE_ID,
		PART_TIME
   	FROM
		CAMPAIGNS   
    WHERE
        1=1    
        <cfif isDefined("camp_id") and len(camp_id)>
        	AND	CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#">
        </cfif>
        <cfif isdefined('attributes.start_date')>
            AND	CAMP_STARTDATE > #attributes.start_date#
        </cfif>
        <cfif isdefined('attributes.finish_date')>
            AND	CAMP_FINISHDATE < #attributes.finish_date#
        </cfif>
    ORDER BY 
    	CAMP_STARTDATE
</cfquery>

