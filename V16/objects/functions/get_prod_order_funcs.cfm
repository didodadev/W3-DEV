<!--- get_prod_order_funcs.cfm --->
<!---<cffunction name="GET_STATION_PROD">
    <cfargument name="get_station_id" type="numeric" required="true">
	<cfargument name="get_other" type="string"  default=""  required="false">
	<cfquery name="GET_STATION_OF_ORDER" datasource="#DSN#">
		SELECT
			W.*,
			B.BRANCH_ID,
			B.BRANCH_NAME
		FROM
			#dsn3_alias#.WORKSTATIONS W,
			BRANCH B
		WHERE
			W.BRANCH = B.BRANCH_ID AND
			W.STATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_station_id#">
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
			<cfreturn DEGER>	
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
</cffunction>--->
<!---<cffunction name="GET_ROUTE_PROD">
    <cfargument name="get_route_id" type="numeric" required="true">
	<cfquery name="GET_ROUTE_OF_ORDER" datasource="#DSN3#">
		SELECT ROUTE FROM ROUTE WHERE ROUTE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_route_id#">
	</cfquery>
	<cfif GET_ROUTE_OF_ORDER.RECORDCOUNT>
	 	<cfreturn GET_ROUTE_OF_ORDER.ROUTE>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</cffunction>--->
<!---<cffunction name="GET_PROSPECTUS_PROD">
    <cfargument name="get_prospectus_id" type="numeric" required="true">
	<cfquery name="GET_PROSPECTUS_OF_ORDER" datasource="#DSN3#">
		SELECT PROSPECTUS_NAME FROM PROSPECTUS WHERE PROSPECTUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prospectus_id#">
	</cfquery>
	<cfif GET_PROSPECTUS_OF_ORDER.RECORDCOUNT>
	 	<cfreturn GET_PROSPECTUS_OF_ORDER.PROSPECTUS_NAME>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</cffunction>--->

<!---<cffunction name="GET_STATUS_PROD_ORDER">
    <cfargument name="status_id" type="numeric" required="true">
	<cfquery name="GET_STATUS_OF_PROD" datasource="#DSN#">
		SELECT STATUS_NAME FROM PRODUCTION_STATUS WHERE STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#status_id#">
	</cfquery>
	<cfif GET_STATUS_OF_PROD.RECORDCOUNT>
	 	<cfreturn GET_STATUS_OF_PROD.STATUS_NAME>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</cffunction>--->

<!---<cffunction name="GET_PRODUCT_PROPERTY_PROD">
    <cfargument name="stock_id" type="numeric" required="true">
	<cfargument name="be_wanted" type="string" required="false" default="pro_name">
	<cfquery name="GET_PRODUCT_NAMES" datasource="#DSN3#">
		SELECT
			S.PRODUCT_NAME,
			S.PROPERTY,
			PU.MAIN_UNIT,
			S.PRODUCT_ID
		FROM
			STOCKS AS S,
			PRODUCT_UNIT AS PU
		WHERE
			PU.PRODUCT_ID = S.PRODUCT_ID AND
			STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#">
	</cfquery>
	<cfif GET_PRODUCT_NAMES.RECORDCOUNT>
		<cfif len(be_wanted)>
			<cfset 	deger = "#be_wanted#">
			<cfswitch expression="#deger#">
				<cfcase value="unit">
					<cfset deger = GET_PRODUCT_NAMES.MAIN_UNIT >
				</cfcase>
				<cfcase value="pro">
					<cfset deger = GET_PRODUCT_NAMES.PRODUCT_ID & " " & GET_PRODUCT_NAMES.PRODUCT_ID >
				</cfcase>
				<cfdefaultcase>
					<cfset deger = GET_PRODUCT_NAMES.PRODUCT_NAME>
				</cfdefaultcase>
			</cfswitch>
			<cfreturn deger>
		<cfelse>
			<cfreturn GET_PRODUCT_NAMES.PRODUCT_NAME & " " &  GET_PRODUCT_NAMES.PROPERTY>
		</cfif>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</cffunction>--->

<!---<cffunction name="GET_PRODUCT_UNIT_PROD">
    <cfargument name="get_product_id" type="numeric" required="true">
	<cfquery name="GET_PRODUCT_UNIT_OF_ORDER" datasource="#DSN3#">
		SELECT MAIN_UNIT FROM PRODUCT_UNIT WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_id#">
	</cfquery>
	<cfif GET_PRODUCT_UNIT_OF_ORDER.RECORDCOUNT>
	 	<cfreturn GET_PRODUCT_UNIT_OF_ORDER.MAIN_UNIT>
	<cfelse>
		<cfreturn ''>
	</cfif> 
</cffunction>--->
