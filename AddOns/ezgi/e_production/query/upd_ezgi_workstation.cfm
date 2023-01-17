<cfif not isdefined("attributes.cc_emp_ids") or not len(attributes.cc_emp_ids)>
	<script>
    	alert("<cf_get_lang_main no='782.Zorunlu Alan'> <cf_get_lang_main no='157.Görevli'>");
		window.location.href="<cfoutput>#request.self#?fuseaction=prod.upd_workstation&station_id=#attributes.station_id#</cfoutput>";
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
            IS_CAPACITY = <cfif isdefined("attributes.is_capacity")>1<cfelse>0</cfif>,
            UP_STATION = <cfif isdefined("attributes.UP_STATION") and len(attributes.UP_STATION)>#attributes.UP_STATION#<cfelse>NULL</cfif>,
            STATION_NAME = '#attributes.station_name#',
            BRANCH = #attributes.branch_id_sta#,
            DEPARTMENT = #attributes.department_id#,
            ENERGY = #attributes.energy#,
            EMP_ID = '#employee_list#',
            OUTSOURCE_PARTNER = <cfif len(attributes.partner_id)>#attributes.partner_id#<cfelse>NULL</cfif>,
            COMMENT = <cfif len(attributes.comment)>'#attributes.comment#'<cfelse>NULL</cfif>,
            ACTIVE = <cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
            COST = #attributes.cost#,
            COST_MONEY = <cfif len(attributes.cost_money)>'#attributes.cost_money#'<cfelse>'#session.ep.money#'</cfif>,
            EMPLOYEE_NUMBER = <cfif len(attributes.employee_number)>#attributes.employee_number#<cfelse>NULL</cfif>,
            SET_PERIOD_HOUR = <cfif len(attributes.setting_period_hour)>#attributes.setting_period_hour#<cfelse>NULL</cfif>,
            SET_PERIOD_MINUTE = <cfif len(attributes.setting_period_minute)>#attributes.setting_period_minute#<cfelse>NULL</cfif>,
            AVG_CAPACITY_DAY = <cfif len(attributes.avg_capacity_day)>#attributes.avg_capacity_day#<cfelse>NULL</cfif>,
            AVG_CAPACITY_HOUR = <cfif len(attributes.avg_capacity_hour)>#attributes.avg_capacity_hour#<cfelse>NULL</cfif>,
            BASIC_INPUT_ID = <cfif isdefined("attributes.basic_type") and len(attributes.basic_type)>#attributes.basic_type#<cfelse>NULL</cfif>,
            AVG_COST = <cfif len(attributes.ws_avg_cost)>#attributes.ws_avg_cost#<cfelse>NULL</cfif>,
            EXIT_DEP_ID = <cfif len(attributes.exit_department) and len(attributes.exit_department_id)>'#attributes.exit_department_id#'<cfelse>NULL</cfif>,
            EXIT_LOC_ID = <cfif len(attributes.exit_department) and len(attributes.exit_location_id)>'#attributes.exit_location_id#'<cfelse>NULL</cfif>,
            ENTER_DEP_ID = <cfif len(attributes.enter_department) and len(attributes.enter_department_id)>'#attributes.enter_department_id#'<cfelse>NULL</cfif>,
            ENTER_LOC_ID = <cfif len(attributes.enter_department) and len(attributes.enter_location_id)>'#attributes.enter_location_id#'<cfelse>NULL</cfif>,
            PRODUCTION_DEP_ID = <cfif len(attributes.production_department) and len(attributes.production_department_id)>'#attributes.production_department_id#'<cfelse>NULL</cfif>,
            PRODUCTION_LOC_ID = <cfif len(attributes.production_department) and len(attributes.production_location_id)>'#attributes.production_location_id#'<cfelse>NULL</cfif>,
            WIDTH=<cfif len(attributes.width)>#attributes.width#<cfelse>NULL</cfif>,
            LENGTH=<cfif len(attributes.length)>#attributes.length#<cfelse>NULL</cfif>,
            HEIGHT=<cfif len(attributes.height)>#attributes.height#<cfelse>NULL</cfif>,
            UPDATE_EMP = #session.ep.userid#,
            UPDATE_DATE = #now()#,
            UPDATE_IP = '#cgi.remote_addr#',
            EZGI_SETUP_TIME = <cfif len(attributes.ezgi_setup)>#attributes.ezgi_setup#<cfelse>0</cfif>,
            EZGI_KATSAYI = <cfif len(attributes.ezgi_katsayi)>#attributes.ezgi_katsayi#<cfelse>0</cfif>
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
    <cflocation url="#request.self#?fuseaction=prod.upd_ezgi_workstation&station_id=#attributes.station_id#" addtoken="no">
</cfif>