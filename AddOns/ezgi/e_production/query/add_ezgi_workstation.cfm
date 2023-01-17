<cfif not isdefined("attributes.cc_emp_ids") or not len(attributes.cc_emp_ids)>
	<script>
    	alert("<cf_get_lang_main no='782.Zorunlu Alan'> <cf_get_lang_main no='157.Görevli'>");
		window.location.href="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.add_workstation";
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
			RECORD_IP,
            EZGI_SETUP_TIME,
            EZGI_KATSAYI
		)
		VALUES
		(
			<cfif isdefined("attributes.is_capacity")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.up_station") and len(attributes.up_station)>#attributes.up_station#<cfelse>NULL</cfif>,
			'#attributes.station_name#',
			#attributes.branch_id#,
			#attributes.department_id#,
			#attributes.energy#,
			'#employee_list#',
			<cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
			<cfif len(attributes.comment)>'#attributes.comment#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
			#attributes.cost#,
			<cfif len(attributes.cost_money)>'#attributes.cost_money#'<cfelse>'#session.ep.money#'</cfif>,
			<cfif len(attributes.employee_number)>#attributes.employee_number#<cfelse>NULL</cfif>,
			<cfif len(attributes.setting_period_hour)>#attributes.setting_period_hour#<cfelse>NULL</cfif>,
			<cfif len(attributes.setting_period_minute)>#attributes.setting_period_minute#<cfelse>NULL</cfif>,
			<cfif len(attributes.avg_capacity_day)>#attributes.avg_capacity_day#<cfelse>NULL</cfif>,
			<cfif len(attributes.avg_capacity_hour)>#attributes.avg_capacity_hour#<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.basic_type") and len(attributes.basic_type)>#attributes.basic_type#<cfelse>NULL</cfif>,
			<cfif len(attributes.exit_department) and len(attributes.exit_department_id)>'#attributes.exit_department_id#'<cfelse>NULL</cfif>,
			<cfif len(attributes.exit_department) and len(attributes.exit_location_id)>'#attributes.exit_location_id#'<cfelse>NULL</cfif>,
			<cfif len(attributes.enter_department) and len(attributes.enter_department_id)>'#attributes.enter_department_id#'<cfelse>NULL</cfif>,
			<cfif len(attributes.enter_department) and len(attributes.enter_location_id)>'#attributes.enter_location_id#'<cfelse>NULL</cfif>,
			<cfif len(attributes.production_department) and len(attributes.production_department_id)>'#attributes.production_department_id#'<cfelse>NULL</cfif>,
			<cfif len(attributes.production_department) and len(attributes.production_location_id)>'#attributes.production_location_id#'<cfelse>NULL</cfif>,
			<cfif len(attributes.width)>#attributes.width#<cfelse>NULL</cfif>,
			<cfif len(attributes.length)>#attributes.length#<cfelse>NULL</cfif>,
			<cfif len(attributes.height)>#attributes.height#<cfelse>NULL</cfif>,
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#',
            <cfif len(attributes.ezgi_setup)>#attributes.ezgi_setup#<cfelse>0</cfif>,
            <cfif len(attributes.ezgi_katsayi)>#attributes.ezgi_katsayi#<cfelse>0</cfif>
		)
	</cfquery> 
	<script type="text/javascript">
        wrk_opener_reload();
        window.close();	
    </script>
</cfif>