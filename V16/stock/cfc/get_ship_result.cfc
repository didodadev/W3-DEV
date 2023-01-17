<cffunction name="get_ship_result_fnc" returntype="query">
	<cfargument name="ship_number" default="">
	<cfargument name="keyword" default="">
	<cfargument name="process_stage_type" default="">
	<cfargument name="start_date" default="">
	<cfargument name="finish_date" default="">
	<cfargument name="ship_method_name" default="">
	<cfargument name="ship_method_id" default="">
	<cfargument name="department_id" default="">
	<cfargument name="department_name" default="">
	<cfargument name="transport_comp_id" default="">
	<cfargument name="transport_comp_name" default="">
	<cfargument name="company_id" default="">
	<cfargument name="company" default="">
	<cfargument name="consumer_id" default="">
	<cfargument name="county_id" default="">
	<cfargument name="county" default="">
	<cfargument name="city_id" default="">
	<cfargument name="city" default="">
    <cfargument name="project_id" default=""><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
	<cfargument name="project_head" default=""><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
	<cfquery name="GET_SHIP_RESULT" datasource="#this.DSN2#">
		SELECT 
			SR.SHIP_FIS_NO,
			SR.OUT_DATE,
			SR.DELIVERY_DATE,
			SR.SHIP_RESULT_ID,
			SR.SHIP_METHOD_TYPE,
			SR.SHIP_STAGE,
			SR.NOTE,
			SMT.SHIP_METHOD,
            PP.PROJECT_HEAD
		FROM 
			SHIP_RESULT SR
            LEFT JOIN  #this.dsn_alias#.PRO_PROJECTS PP on SR.PROJECT_ID=PP.PROJECT_ID,
			#this.dsn_alias#.SHIP_METHOD SMT
		WHERE 
			SR.SHIP_METHOD_TYPE = SMT.SHIP_METHOD_ID AND
			SR.MAIN_SHIP_FIS_NO IS NULL 
		  <cfif len(arguments.ship_number)><!---  Irsaliye numarasina gore arama --->
			 AND SHIP_RESULT_ID IN(
									SELECT DISTINCT
										SHIP_RESULT_ID
									FROM
										SHIP_RESULT_ROW
									WHERE
										SHIP_ID IN (SELECT SHIP_ID FROM SHIP WHERE SHIP_NUMBER LIKE '%#arguments.ship_number#%') OR SHIP_ID IS NULL
									)		  
		  </cfif>		  
		  <cfif len(arguments.keyword)>
			AND (SR.SHIP_FIS_NO LIKE '%#arguments.keyword#%' OR SR.REFERENCE_NO LIKE '%#arguments.keyword#%')
		  </cfif>
		  <cfif len(arguments.process_stage_type)>
		    AND SR.SHIP_STAGE = #arguments.process_stage_type#</cfif>
		  <cfif len(arguments.start_date)>
			AND SR.OUT_DATE >= #arguments.start_date#
		  </cfif>
		  <cfif len(arguments.finish_date)>
		  	AND SR.OUT_DATE <= #arguments.finish_date#
		  </cfif>
		  <cfif len(arguments.ship_method_name) and len(arguments.ship_method_id)>
		  	AND SR.SHIP_METHOD_TYPE = #arguments.ship_method_id#
		  </cfif>
		  <cfif len(arguments.department_id) and len(arguments.department_name)>
		  	AND SR.DEPARTMENT_ID = #arguments.department_id#
		  </cfif>
		  <cfif len(arguments.transport_comp_id) and len(arguments.transport_comp_name)>
		  	AND SR.SERVICE_COMPANY_ID = #arguments.transport_comp_id#
		  </cfif>
		  <cfif len(arguments.company_id) and len(arguments.company)>
		  	AND SR.COMPANY_ID = #arguments.company_id#
		 <cfelseif len(arguments.consumer_id) and len(arguments.company)>
		  	AND SR.CONSUMER_ID = #arguments.consumer_id#
		  </cfif>
		  <cfif len(arguments.county_id) and len(arguments.county)>
		  	AND SR.SENDING_COUNTY_ID = #arguments.county_id#
		  </cfif>
		  <cfif len(arguments.city_id) and len(arguments.city)>
		  	AND SR.SENDING_CITY_ID = #arguments.city_id#
		  </cfif>
           <cfif len(arguments.project_id) and len(arguments.project_head)><!--- #67836 numaraları iş gereği MCP tarafından EKLENDİ. --->
		  	AND PP.PROJECT_ID = #arguments.project_id#
		  </cfif>
		ORDER BY 
			SR.SHIP_RESULT_ID DESC
	</cfquery>
	<cfreturn GET_SHIP_RESULT>
</cffunction>
