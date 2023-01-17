<cfif isdefined('attributes.today') and len(attributes.today)>
	<cfset today_first = createDateTime(year(attributes.today),month(attributes.today),day(attributes.today),0,0,0)>
	<cfset today_last = createDateTime(year(attributes.today),month(attributes.today),day(attributes.today),23,59,59)>
<cfelse>
	<cfset today_first = createDateTime(year(now()),month(now()),day(now()),0,0,0)>
	<cfset today_last = createDateTime(year(now()),month(now()),day(now()),23,59,59)>
</cfif>
<cfquery name="get_time_cost" datasource="#dsn#">
	SELECT
		CASE WHEN TC.COMPANY_ID IS NOT NULL THEN C.MEMBER_CODE WHEN TC.CONSUMER_ID IS NOT NULL THEN CON.MEMBER_CODE END AS MEMBER_CODE,
		PP.PROJECT_NUMBER,
		PP.PROJECT_HEAD,
		TC.TIME_COST_ID,
		TC.COMMENT,
		TC.FINISH,
		TC.START,
		TC.FINISH_MIN,
		TC.START_MIN,
		TC.EXPENSED_MINUTE,
		TC.BUG_ID,
		SA.ACTIVITY_NAME,
		TCC.TIME_COST_CAT,
		PTR.STAGE
	FROM
		TIME_COST TC
		LEFT JOIN COMPANY C ON TC.COMPANY_ID = C.COMPANY_ID
		LEFT JOIN CONSUMER CON ON TC.CONSUMER_ID = CON.CONSUMER_ID
		LEFT JOIN PRO_PROJECTS PP ON TC.PROJECT_ID = PP.PROJECT_ID
		LEFT JOIN SETUP_ACTIVITY SA ON TC.ACTIVITY_ID = SA.ACTIVITY_ID
		LEFT JOIN TIME_COST_CAT TCC ON TC.TIME_COST_CAT_ID = TCC.TIME_COST_CAT_ID
		LEFT JOIN PROCESS_TYPE_ROWS PTR ON TC.TIME_COST_STAGE = PTR.PROCESS_ROW_ID
	WHERE
		TC.EVENT_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today_first#">
		AND TC.EVENT_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#today_last#">
		AND TC.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
</cfquery>
<!--- <cf_medium_list> --->

		<cf_grid_list >
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='30817.Müşteri No'></th>
					<th><cf_get_lang dictionary_id='30886.Proje No'></th>
					<th><cf_get_lang dictionary_id='31027.Proje Adı'></th>
					<th><cf_get_lang dictionary_id='29513.Süre'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='31087.Aktivite'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				</tr>
			</thead>
				<cfif get_time_cost.recordcount>
					<cfoutput query="get_time_cost">
						<tbody>
							<tr>
								<cfif fusebox.circuit eq 'myhome'>
									<cfset time_cost_id_ = contentEncryptingandDecodingAES(isEncode:1,content:time_cost_id,accountKey:'wrk')>
								<cfelse>
									<cfset time_cost_id_ = time_cost_id>
								</cfif>
								<td><a href="#request.self#?fuseaction=myhome.mytime_management&event=upd&time_cost_id=#time_cost_id_#" class="tableyazi">#currentrow#</a></td>
								<td>#member_code#</td>
								<td>#project_number#</td>
								<td>#project_head#</td>
								<td>
									<cfif not len(bug_id) and len(finish) and len(start) and len(finish_min) and len(start_min)>
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
										<cfset mytime="#totalhour#:#totalminute# Saat">
										<cfif totalhour eq 0>
											<cfset mytime="#totalminute# Dakika">
										</cfif>
										#mytime#
									<cfelse>
										<cfset totalminute = expensed_minute mod 60>
										<cfset totalhour = (expensed_minute-totalminute)/60>
										#totalhour#:#totalminute#<cf_get_lang dictionary_id='57491.Saat'>
									</cfif>
								</td>
								<td>#comment#</td>
								<td>#activity_name#</td>
								<td>#time_cost_cat#</td>
								<td>#stage#</td>
							</tr>
						</tbody>
						</cfoutput>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
							</tr>
						</tbody>
				</cfif>
		</cf_grid_list>
	
		
	
<!--- </cf_medium_list> --->