<cfif not isdefined("attributes.cc_emp_ids") or not len(attributes.cc_emp_ids)>
	<script>
    	alert("<cf_get_lang_main no='782.Zorunlu Alan'> <cf_get_lang_main no='157.Görevli'>");
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.list_workstation&event=add";
    </script>
<cfelse>
	<cfset employee_list=",#listdeleteduplicates(attributes.cc_emp_ids,'numeric','ASC',',')#,">
	<cfquery name="ADD_WORKSTATION" datasource="#DSN3#">
		INSERT INTO
			WORKSTATIONS
		(
			IS_CAPACITY,
			UP_STATION,
			STATION_NAME,
			BRANCH,
			DEPARTMENT,
			ENERGY,
			EMP_ID,
			OUTSOURCE_PARTNER,
			COMMENT,
			ACTIVE,
			COST,
			COST_MONEY,
			EMPLOYEE_NUMBER,
			SET_PERIOD_HOUR,
			SET_PERIOD_MINUTE,
			AVG_CAPACITY_DAY,
			AVG_CAPACITY_HOUR,
			BASIC_INPUT_ID,
			EXIT_DEP_ID,
			EXIT_LOC_ID,
			ENTER_DEP_ID,
			ENTER_LOC_ID,
			PRODUCTION_DEP_ID,
			PRODUCTION_LOC_ID,
			WIDTH,
			LENGTH,
			HEIGHT,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		)
		VALUES
		(
			<cfif isdefined("attributes.is_capacity")><cfqueryparam value = "1" CFSQLType = "cf_sql_bit"><cfelse><cfqueryparam value = "0" CFSQLType = "cf_sql_bit"></cfif>,
			<cfif isdefined("attributes.up_station") and len(attributes.up_station)><cfqueryparam value = "#attributes.up_station#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
			<cfqueryparam value = "#attributes.station_name#" CFSQLType = "cf_sql_varchar">,
			<cfqueryparam value = "#attributes.branch_id#" CFSQLType = "cf_sql_integer">,
			<cfqueryparam value = "#attributes.department_id#" CFSQLType = "cf_sql_integer">,
			<cfqueryparam value = "#attributes.energy#" CFSQLType = "cf_sql_integer">,
			<cfqueryparam value = "#employee_list#" CFSQLType = "cf_sql_varchar">,
			<cfif len(attributes.partner_id)><cfqueryparam value = "#attributes.partner_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.comment)><cfqueryparam value = "#attributes.comment#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.active")><cfqueryparam value = "1" CFSQLType = "cf_sql_bit"><cfelse><cfqueryparam value = "0" CFSQLType = "cf_sql_bit"></cfif>,
			<cfqueryparam value = "#attributes.cost#" CFSQLType = "cf_sql_float">,
			<cfif len(attributes.cost_money)><cfqueryparam value = "#attributes.cost_money#" CFSQLType = "cf_sql_varchar"><cfelse><cfqueryparam value = "#session.ep.money#" CFSQLType = "cf_sql_varchar"></cfif>,
			<cfif len(attributes.employee_number)><cfqueryparam value = "#attributes.employee_number#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.setting_period_hour)><cfqueryparam value = "#attributes.setting_period_hour#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.setting_period_minute)><cfqueryparam value = "#attributes.setting_period_minute#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.avg_capacity_day)><cfqueryparam value = "#attributes.avg_capacity_day#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.avg_capacity_hour)><cfqueryparam value = "#attributes.avg_capacity_hour#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.basic_type") and len(attributes.basic_type)><cfqueryparam value = "#attributes.basic_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.exit_department) and len(attributes.exit_department_id)><cfqueryparam value = "#attributes.exit_department_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.exit_department) and len(attributes.exit_location_id)><cfqueryparam value = "#attributes.exit_location_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.enter_department) and len(attributes.enter_department_id)><cfqueryparam value = "#attributes.enter_department_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.enter_department) and len(attributes.enter_location_id)><cfqueryparam value = "#attributes.enter_location_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.production_department) and len(attributes.production_department_id)><cfqueryparam value = "#attributes.production_department_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.production_department) and len(attributes.production_location_id)><cfqueryparam value = "#attributes.production_location_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
			<cfif len(attributes.width)><cfqueryparam value = "#attributes.width#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
			<cfif len(attributes.length)><cfqueryparam value = "#attributes.length#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
			<cfif len(attributes.height)><cfqueryparam value = "#attributes.height#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
			<cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
			<cfqueryparam value = "#now()#" CFSQLType = "cf_sql_timestamp">,
			<cfqueryparam value = "#cgi.remote_addr#" CFSQLType = "cf_sql_varchar">		
		)
	</cfquery> 
    <cfquery name="get_max_workstation"  datasource="#DSN3#">
    	SELECT MAX(STATION_ID) AS MAX_ID FROM WORKSTATIONS
    </cfquery>
	<script type="text/javascript">
	  	window.location.href="<cfoutput>#request.self#?fuseaction=prod.list_workstation&event=upd&station_id=#get_max_workstation.MAX_ID#</cfoutput>";
    </script>
</cfif>
 

