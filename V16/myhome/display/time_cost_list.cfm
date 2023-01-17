<cfquery name="GET_TIME_COST" datasource="#DSN#">
	SELECT 
		TC.TIME_COST_ID,
        TC.FINISH,
        TC.START,
        TC.FINISH_MIN,
        TC.START_MIN,
        TC.EVENT_DATE,
        TC.EMPLOYEE_ID,
        TC.PARTNER_ID,
        C.NICKNAME,
        CP.COMPANY_PARTNER_NAME,
        CP.COMPANY_PARTNER_SURNAME,
        SC.SUBSCRIPTION_NO,
        PP.PROJECT_HEAD,
        PW.WORK_HEAD,
        E.EVENT_HEAD,
        EC.EXPENSE,
        TCL.CLASS_NAME,
        TC.CONSUMER_ID,
        TC.EVENT_ID,
        TC.EXPENSE_ID,
        TC.PROJECT_ID,
        TC.CLASS_ID,
        TC.SUBSCRIPTION_ID,
        TC.COMMENT,
        TC.TOTAL_TIME,
        TC.WORK_ID
	FROM 
		TIME_COST TC
        LEFT JOIN COMPANY C ON C.COMPANY_ID = TC.COMPANY_ID 
        LEFT JOIN COMPANY_PARTNER CP ON CP.PARTNER_ID = TC.PARTNER_ID 
        LEFT JOIN #dsn3_alias#.SUBSCRIPTION_CONTRACT SC ON SC.SUBSCRIPTION_ID = TC.SUBSCRIPTION_ID 
        LEFT JOIN #dsn2_alias#.EXPENSE_CENTER EC ON EC.EXPENSE_ID = TC.EXPENSE_ID 
        LEFT JOIN TRAINING_CLASS TCL ON TCL.CLASS_ID = TC.CLASS_ID 
        LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = TC.PROJECT_ID 
        LEFT JOIN PRO_WORKS PW ON PW.WORK_ID = TC.WORK_ID 
        LEFT JOIN EVENT E ON E.EVENT_ID = TC.EVENT_ID 
	WHERE 
		<cfif isdefined("attributes.is_service") and isdefined('attributes.service_id') and len(attributes.service_id)>
			TC.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
        <cfelseif isdefined('attributes.is_call_service') and isdefined("attributes.service_id") and len(attributes.service_id)>
        	TC.CRM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
		<cfelseif isdefined('attributes.cus_help_id') and len(attributes.cus_help_id)>
			TC.CUS_HELP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cus_help_id#">
		<cfelseif isdefined('attributes.p_order_result_id') and len(attributes.p_order_result_id)>
			TC.P_ORDER_RESULT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.p_order_result_id#">
		</cfif>
		<cfif isDefined("attributes.startdate") and len(attributes.startdate) and isDefined("attributes.finishdate") and len(attributes.finishdate)>
			AND TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
			AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
		</cfif>
	ORDER BY
		TC.TIME_COST_ID DESC
</cfquery>
                            
<!--- <cf_medium_list> --->
	
		<cf_grid_list>
			<thead>
			<tr>
				<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
				<th width="65"><cf_get_lang dictionary_id='57576.Çalışan'></th>
				<th width="50"><cf_get_lang dictionary_id='29513.Süre'></th>
				<th><cf_get_lang dictionary_id='58445.İş'></th>
				<th><cf_get_lang dictionary_id='57658.Üye'></th>
				<th><cf_get_lang dictionary_id='29510.Olay'></th>
				<th><cf_get_lang dictionary_id='58235.Masraf Merkezi'></th>
				<th><cf_get_lang dictionary_id='57416.Proje'></th>
				<th><cf_get_lang dictionary_id='58832.Abone'></th>
				<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
				<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
			</tr></thead>
			<cfif get_time_cost.recordcount>
				<cfoutput query="get_time_cost">
					<tbody>
					<tr>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_form_upd_timecost&time_cost_id=#time_cost_id#','page_horizantal');" class="tableyazi">#time_cost_id#</a></td>
						<td><cfset tarih = dateformat(event_date,dateformat_style)>#tarih#</td>
						<td>#get_emp_info(employee_id,0,0)#</td>
						<td>
							<cfif len(finish) and len(start) and len(finish_min) and len(start_min)>
								<cfset totalhour=finish-start>
								<cfset totalminute=finish_min-start_min>
								<cfif totalminute lt 0>
									<cfset totalminute=abs(totalminute)>
									<cfset totalminute=60-totalminute>
									<cfset totalhour=totalhour-1>
								</cfif>
								<cfif totalminute lt 10>
									<cfset totalminute="0#totalminute#">
								</cfif>
								<cfset mytime="#totalhour# : #totalminute# <!---Saat--->">
								<cfif totalhour eq 0>
									<cfset mytime="00 : #totalminute# <!---Dakika--->">
								</cfif>
								#mytime#
							<cfelse>
								<cfif Find('.',wrk_round(get_time_cost.total_time)) gt 0>
									<cfset dakika_oran = "0." & "#right(wrk_round(get_time_cost.TOTAL_TIME),len(wrk_round(get_time_cost.total_time)) - Find('.',wrk_round(get_time_cost.total_time)))#">
									#left(wrk_round(get_time_cost.total_time),Find('.',wrk_round(get_time_cost.total_time))-1)# : #wrk_round(dakika_oran * 60,0)#
								<cfelse>
									<cfif len(work_id)>
										<cfset totalhour = get_time_cost.total_time>
										<cfset totalminute = get_time_cost.total_time - (int(get_time_cost.total_time))>
										 #int(totalhour)# : #totalminute#  
									<cfelse>
										#wrk_round(get_time_cost.total_time)# : 0
									 </cfif>   
								</cfif>
							</cfif>	Saat
						</td>
						<td>#work_head#</td>
						<td>
							<cfif len(partner_id)>
								#nickname# - #company_partner_name# #company_partner_surname#
							<cfelseif len(consumer_id)><!--- cus_help_id--->
								#get_cons_info(consumer_id,2,0)#
							</cfif>
						</td>
						<td>#event_head#</td>
						<td>#expense#</td>
						<td>#project_head#</td>
						<td>#subscription_no#</td>
						<td>#class_name#</td>
						<td>#comment#</td>                     
					</tr></tbody>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</cfif>

		</cf_grid_list>
	
		

<!--- </cf_medium_list> --->