<cfoutput query="get_service_task">
	<cfif get_service_task.task_position_code neq 0>
		<cfinclude template="../query/get_task.cfm">
		<cfinclude template="../query/get_emp_detail.cfm">
		#get_service_task.task_partner_id#<br/>
		#get_service_task.task_cmp_id#<br/>
		#get_service_task.start_date#<br/>
		#get_service_task.finish_date#<br/>
    	#dateformat(get_service_task.start_date,timeformat_style)#<br/>
		#dateformat(get_service_task.finish_date,timeformat_style)#<br/>
		#get_service_task.detail#<br/>
		#get_service_task.task_id#<br/>
		#get_service_task.task_position_code#<br/>
	<cfelse>
		<cfset attributes.partner_id = get_service_task.task_partner_id>
		<cfinclude template="../query/get_partner_detail.cfm">
	    #get_partner_detail.company_partner_name# #get_partner_detail.company_partner_surname##get_partner_detail.fullname#
		#get_service_task.start_date#<br/>
		#get_service_task.finish_date#<br/>
		#get_service_task.detail#<br/>
	</cfif>
</cfoutput>
