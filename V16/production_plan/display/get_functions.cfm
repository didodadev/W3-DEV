<!--- <cfinclude template="../query/get_company_info_with_func.cfm">
<CFFUNCTION name="GET_STATION">
    <cfargument name="get_station_id" type="numeric" required="true">
	<cfargument name="get_other" type="string"  default=""  required="false">
	<cfquery name="GET_STATION_OF_ORDER" datasource="#DSN#">
		SELECT
			W.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			E.EMPLOYEE_ID,
			B.BRANCH_ID,
			B.BRANCH_NAME
		FROM
			#dsn3_alias#.WORKSTATIONS W,
			EMPLOYEES E,
			BRANCH B
		WHERE
			W.EMP_ID=E.EMPLOYEE_ID
		AND
			W.BRANCH=B.BRANCH_ID
		AND
			W.STATION_ID=#get_station_id#
	</cfquery>
	<cfif  get_other eq "uye">
		<cfif LEN(GET_STATION_OF_ORDER.OUTSOURCE_PARTNER) AND ISNUMERIC(GET_STATION_OF_ORDER.OUTSOURCE_PARTNER)>
			<cfreturn #get_par_info(GET_STATION_OF_ORDER.OUTSOURCE_PARTNER,0,-1,1)#> 
		<cfelse>
			<cfreturn ''>	
		</cfif>
	<cfelseif  get_other eq "yetkili">	
		<cfif GET_STATION_OF_ORDER.RECORDCOUNT>
			<cfset DEGER= "<a href=""javascript://""  onclick=""windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=" &  #GET_STATION_OF_ORDER.employee_id# & "','medium');"" class=""tableyazi"">" & #GET_STATION_OF_ORDER.FULLNAME2# & "</a>">
			<CFRETURN DEGER>	
		<cfelse>
			<cfreturn ''>
		</cfif> 
	<cfelse>
		<cfif GET_STATION_OF_ORDER.RECORDCOUNT>
			<cfreturn GET_STATION_OF_ORDER.STATION_NAME>
		<cfelse>
			<cfreturn ''>
		</cfif> 
	</cfif>
</CFFUNCTION>
<CFFUNCTION name="GET_ROUTE">
    <cfargument name="get_route_id" type="numeric" required="true">
	<cfquery name="GET_ROUTE_OF_ORDER" datasource="#DSN3#">
		SELECT
				ROUTE
		FROM
			ROUTE
		WHERE
			ROUTE_ID=#get_route_id#			
	</cfquery>
	<cfif GET_ROUTE_OF_ORDER.RECORDCOUNT>
	 	<cfreturn GET_ROUTE_OF_ORDER.ROUTE>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</CFFUNCTION>
<CFFUNCTION name="GET_PROSPECTUS">
    <cfargument name="get_prospectus_id" type="numeric" required="true">
	<cfquery name="GET_PROSPECTUS_OF_ORDER" datasource="#DSN3#">
		SELECT
				PROSPECTUS_NAME
		FROM
				PROSPECTUS
		WHERE
			PROSPECTUS_ID=#get_prospectus_id#			
	</cfquery>
	<cfif GET_PROSPECTUS_OF_ORDER.RECORDCOUNT>
	 	<cfreturn GET_PROSPECTUS_OF_ORDER.PROSPECTUS_NAME>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</CFFUNCTION>
<CFFUNCTION name="GET_PRODUCT_UNIT">
    <cfargument name="get_product_id" type="numeric" required="true">
	<cfquery name="GET_PRODUCT_UNIT_OF_ORDER" datasource="#DSN3#">
		SELECT
				MAIN_UNIT
		FROM
				PRODUCT_UNIT
		WHERE
			PRODUCT_ID=#get_product_id#			
	</cfquery>
	<cfif GET_PRODUCT_UNIT_OF_ORDER.RECORDCOUNT>
	 	<cfreturn GET_PRODUCT_UNIT_OF_ORDER.MAIN_UNIT>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</CFFUNCTION>
 --->
