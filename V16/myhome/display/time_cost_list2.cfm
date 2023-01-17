<cfquery name="GET_TIME_COST" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		TIME_COST
	WHERE 
		SUBSCRIPTION_ID=#attributes.subscription_id#
		<cfif isDefined("attributes.STARTDATE") and len(attributes.STARTDATE) AND isDefined("attributes.FINISHDATE") and len(attributes.FINISHDATE)>
			AND EVENT_DATE >= #attributes.STARTDATE#
			AND EVENT_DATE <= #attributes.FINISHDATE#
		</cfif>
	ORDER BY
		TIME_COST_ID DESC
</cfquery>

<cf_grid_list>
	<thead>
		<tr>
			<td class="form-title" width="20"><cf_get_lang dictionary_id='57487.No'></td>
			<td class="form-title" width="65"><cf_get_lang dictionary_id='57742.Tarih'></td>
			<td class="form-title" width="50"><cf_get_lang dictionary_id='29513.Süre'></td>
			<td class="form-title"><cf_get_lang dictionary_id='58445.İş'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57658.Üye'></td>
			<td class="form-title"><cf_get_lang dictionary_id='29510.Olay'></td>
			<td class="form-title"><cf_get_lang dictionary_id='58235.Masraf Merkezi'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57416.Proje'></td>
			<td class="form-title"><cf_get_lang dictionary_id='58832.Abone'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57419.Eğitim'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'></td>
		</tr>
	</thead>
		<cfif get_time_cost.recordcount>
			<cfoutput query="get_time_cost">
				<tbody>
					<tr>
						<td><!--- <a href="#request.self#?fuseaction=myhome.popup_form_upd_timecost&time_cost_id=#time_cost_id#" class="tableyazi">#time_cost_id#</a> --->
							<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=myhome.popup_form_upd_timecost&time_cost_id=#time_cost_id#','list');" class="tableyazi">#time_cost_id#</a>
						</td>
						<td><cfset tarih=dateformat(event_date,dateformat_style)>#tarih#</td>
						<td><cfif len(finish) and len(start) and len(finish_min) and len(start_min)>
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
									<cfset mytime="0 : #totalminute# <!---Dakika--->">
								</cfif>
							#mytime#
							<cfelse>
								<cfif Find('.',wrk_round(get_time_cost.TOTAL_TIME)) gt 0>
									<cfset dakika_oran = "0." & "#right(wrk_round(get_time_cost.TOTAL_TIME),len(wrk_round(get_time_cost.TOTAL_TIME)) - Find('.',wrk_round(get_time_cost.TOTAL_TIME)))#">
									#left(wrk_round(get_time_cost.TOTAL_TIME),Find('.',wrk_round(get_time_cost.TOTAL_TIME))-1)# : #wrk_round(dakika_oran * 60,0)#
								<cfelse>
									<!--- #wrk_round(get_time_cost.TOTAL_TIME)# : 00 --->
									<cfset totalhour = get_time_cost.TOTAL_TIME / 60>
									<cfset totalminute = get_time_cost.TOTAL_TIME - (int(totalhour)*60)>
									#int(totalhour)# : #totalminute# 
								</cfif>
							</cfif>
						</td>
						<td><cfif len(work_id)>
								<cfquery name="get_work" datasource="#dsn#">
									SELECT WORK_HEAD FROM PRO_WORKS WHERE WORK_ID = #WORK_ID#
								</cfquery>
								#get_work.WORK_HEAD#
							</cfif>
						</td>
						<td><cfif len(partner_id)>
								<cfquery name="get_cmp" datasource="#dsn#">
									SELECT
										COMPANY.NICKNAME,
										COMPANY_PARTNER.COMPANY_PARTNER_NAME,
										COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
									FROM
										COMPANY_PARTNER,
										COMPANY
									WHERE
										COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
										COMPANY_PARTNER.PARTNER_ID = #ListChangeDelims(PARTNER_ID,'',',')#
								</cfquery>
								#get_cmp.NICKNAME# - #get_cmp.COMPANY_PARTNER_NAME# #get_cmp.COMPANY_PARTNER_SURNAME#
							</cfif>
						</td>
						<td><cfif len(event_id)>
								<cfquery name="get_event" datasource="#dsn#">
									SELECT EVENT_HEAD FROM EVENT WHERE EVENT_ID = #EVENT_ID#
								</cfquery>
								#get_event.EVENT_HEAD#
							</cfif>
						</td>
						<td><cfif len(expense_id)>
								<cfquery name="get_exp" datasource="#dsn2#">
									SELECT EXPENSE FROM EXPENSE_CENTER WHERE EXPENSE_ID = #EXPENSE_ID#
								</cfquery>
								#get_exp.EXPENSE#
							</cfif>
						</td>
						<td><cfif len(project_id)>
								<cfquery name="get_pro" datasource="#dsn#">
									SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #PROJECT_ID#
								</cfquery>
								#get_pro.PROJECT_HEAD#
							</cfif>
						</td>
						<td><cfif len(subscription_id)>
								<cfquery name="get_subscription" datasource="#dsn3#">
									SELECT SUBSCRIPTION_NO FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID = #SUBSCRIPTION_ID#
								</cfquery>
								#get_subscription.SUBSCRIPTION_NO#
							</cfif>
						</td>
						<td><cfif len(CLASS_ID)>
								<cfquery name="get_class" datasource="#dsn#">
									SELECT CLASS_NAME FROM TRAINING_CLASS WHERE CLASS_ID = #CLASS_ID#
								</cfquery>
								#get_class.CLASS_NAME#
							</cfif>
						</td>
						<td>#comment#</td>
					</tr>
				</tbody>
			</cfoutput>
	 	<cfelse>
			<tbody>
				<tr height="20">
					<td colspan="12" class="color-row"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
				</tr>
			</tbody>
		</cfif>
</cf_grid_list>
	