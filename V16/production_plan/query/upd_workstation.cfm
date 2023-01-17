<cfif not isdefined("attributes.cc_emp_ids") or not len(attributes.cc_emp_ids)>
	<script>
    	alert("<cf_get_lang_main no='782.Zorunlu Alan'> <cf_get_lang_main no='157.Görevli'>");
		window.location.href="<cfoutput>#request.self#?fuseaction=prod.list_workstation&event=upd&station_id=#attributes.station_id#</cfoutput>";
    </script>
<cfelse>
	<cfset employee_list=",#listdeleteduplicates(attributes.cc_emp_ids,'numeric','ASC',',')#,">
	<cfif attributes.branch_id_sta eq 0 and attributes.DEPARTMENT_ID eq 0>
        <cflocation url="#request.self#?fuseaction=prod.upd_workstation&keyword=branch" addtoken="no">
    </cfif>
    <cfquery name="UPD_WORKSTATION" datasource="#DSN3#">
        UPDATE
            WORKSTATIONS
        SET
            IS_CAPACITY = <cfif isdefined("attributes.is_capacity")><cfqueryparam value = "1" CFSQLType = "cf_sql_bit"><cfelse><cfqueryparam value = "0" CFSQLType = "cf_sql_bit"></cfif>,
            UP_STATION = <cfif isdefined("attributes.UP_STATION") and len(attributes.UP_STATION)><cfqueryparam value = "#attributes.up_station#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
            STATION_NAME = <cfqueryparam value = "#attributes.station_name#" CFSQLType = "cf_sql_varchar">,
            BRANCH = <cfqueryparam value = "#attributes.branch_id_sta#" CFSQLType = "cf_sql_integer">,
            DEPARTMENT = <cfqueryparam value = "#attributes.department_id#" CFSQLType = "cf_sql_integer">,
            ENERGY = <cfqueryparam value = "#attributes.energy#" CFSQLType = "cf_sql_integer">,
            EMP_ID = <cfqueryparam value = "#employee_list#" CFSQLType = "cf_sql_varchar">,
            OUTSOURCE_PARTNER = <cfif len(attributes.partner_id)><cfqueryparam value = "#attributes.partner_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            COMMENT = <cfif len(attributes.comment)><cfqueryparam value = "#attributes.comment#" CFSQLType = "cf_sql_varchar"><cfelse>NULL</cfif>,
            ACTIVE = <cfif isdefined("attributes.active")><cfqueryparam value = "1" CFSQLType = "cf_sql_bit"><cfelse><cfqueryparam value = "0" CFSQLType = "cf_sql_bit"></cfif>,
            COST = <cfqueryparam value = "#attributes.cost#" CFSQLType = "cf_sql_float">,
            COST_MONEY = <cfif len(attributes.cost_money)><cfqueryparam value = "#attributes.cost_money#" CFSQLType = "cf_sql_varchar"><cfelse><cfqueryparam value = "#session.ep.money#" CFSQLType = "cf_sql_varchar"></cfif>,
            EMPLOYEE_NUMBER = <cfif len(attributes.employee_number)><cfqueryparam value = "#attributes.employee_number#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            SET_PERIOD_HOUR = <cfif len(attributes.setting_period_hour)><cfqueryparam value = "#attributes.setting_period_hour#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            SET_PERIOD_MINUTE = <cfif len(attributes.setting_period_minute)><cfqueryparam value = "#attributes.setting_period_minute#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            AVG_CAPACITY_DAY = <cfif len(attributes.avg_capacity_day)><cfqueryparam value = "#attributes.avg_capacity_day#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            AVG_CAPACITY_HOUR = <cfif len(attributes.avg_capacity_hour)><cfqueryparam value = "#attributes.avg_capacity_hour#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            BASIC_INPUT_ID = <cfif isdefined("attributes.basic_type") and len(attributes.basic_type)><cfqueryparam value = "#attributes.basic_type#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            AVG_COST = <cfif len(attributes.ws_avg_cost)><cfqueryparam value = "#attributes.ws_avg_cost#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
            EXIT_DEP_ID = <cfif len(attributes.exit_department) and len(attributes.exit_department_id)><cfqueryparam value = "#attributes.exit_department_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            EXIT_LOC_ID = <cfif len(attributes.exit_department) and len(attributes.exit_location_id)><cfqueryparam value = "#attributes.exit_location_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            ENTER_DEP_ID = <cfif len(attributes.enter_department) and len(attributes.enter_department_id)><cfqueryparam value = "#attributes.enter_department_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            ENTER_LOC_ID = <cfif len(attributes.enter_department) and len(attributes.enter_location_id)><cfqueryparam value = "#attributes.enter_location_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            PRODUCTION_DEP_ID = <cfif len(attributes.production_department) and len(attributes.production_department_id)><cfqueryparam value = "#attributes.production_department_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            PRODUCTION_LOC_ID = <cfif len(attributes.production_department) and len(attributes.production_location_id)><cfqueryparam value = "#attributes.production_location_id#" CFSQLType = "cf_sql_integer"><cfelse>NULL</cfif>,
            WIDTH=<cfif len(attributes.width)><cfqueryparam value = "#attributes.width#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
			LENGTH=<cfif len(attributes.length)><cfqueryparam value = "#attributes.length#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
			HEIGHT=<cfif len(attributes.height)><cfqueryparam value = "#attributes.height#" CFSQLType = "cf_sql_float"><cfelse>NULL</cfif>,
            UPDATE_EMP =<cfqueryparam value = "#session.ep.userid#" CFSQLType = "cf_sql_integer">,
            UPDATE_DATE =<cfqueryparam value = "#now()#" CFSQLType = "cf_sql_timestamp">,
            UPDATE_IP =<cfqueryparam value = "#cgi.remote_addr#" CFSQLType = "cf_sql_varchar">			
        WHERE
            STATION_ID = #attributes.station_id#
    </cfquery>
    <cfquery name="GET_POS_ID" datasource="#DSN#"> 
        SELECT 
            POSITION_ID
        FROM 
            EMPLOYEE_POSITIONS
        WHERE
            EMPLOYEE_ID IN (#listdeleteduplicates(attributes.cc_emp_ids,'numeric','ASC',',')#)
    </cfquery>
    
</cfif>
<cfset attributes.actionId=attributes.station_id>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=prod.list_workstation&event=upd&station_id=#attributes.station_id#</cfoutput>";
</script>
