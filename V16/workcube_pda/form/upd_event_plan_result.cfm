<cf_get_lang_set module_name="objects">
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.period_id#"> AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_STAGE_ROWS" datasource="#DSN#">
	SELECT VISIT_STAGE_ID, VISIT_STAGE FROM SETUP_VISIT_STAGES
</cfquery>
<cfif fusebox.use_period>
	<cfquery name="GET_EXPENSE_ROWS" datasource="#DSN2#">
		SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
	</cfquery>
<cfelse>
	<cfquery name="GET_EXPENSE_ROWS" datasource="#DSN#">
		SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS
	</cfquery>
</cfif>
<cfquery name="GET_PLAN_ROW" datasource="#DSN#">
	SELECT
		EVENT_PLAN_ROW.*,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.EXPENSE_ID,
		EVENT_PLAN.EST_LIMIT,
		EVENT_PLAN.EVENT_CAT,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN.EVENT_PLAN_ID,
		EVENT_PLAN.MAIN_START_DATE,
		EVENT_PLAN.MAIN_FINISH_DATE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID,
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN.ANALYSE_ID
	FROM
		COMPANY,
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN_ROW.COMPANY_ID = COMPANY.COMPANY_ID AND
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID AND
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.event_plan_row_id#">
</cfquery>
<cfform name="event_result" action="#request.self#?fuseaction=pda.emptypopup_upd_event_plan_result" method="post">
<input type="hidden" name="eventid" id="eventid" value="<cfoutput>#attributes.eventid#</cfoutput>">
<input type="hidden" name="event_plan_row_id" id="event_plan_row_id" value="<cfoutput>#attributes.event_plan_row_id#</cfoutput>">
<input type="hidden" name="today_value_" id="today_value_" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>">
<table cellspacing="1" cellpadding="2" class="color-border" style="width:100%; height:100%">
	<tr class="color-list" style="height:20px;">
		<td colspan="2" class="headbold">&nbsp;Ziyaret Sonucu Güncelle</td>
	</tr>
	<tr class="color-row">
		<td style="vertical-align:top">
			<table align="center" style="width:98%">
				<tr>
					<td class="infotag" style="width:70px;">Plan</td>
					<td class="infotag" style="width:200px;">: <cfoutput>#get_plan_row.event_plan_head#</cfoutput></td>
				</tr>
				<tr>
					<td class="infotag">Ziyaret Nedeni</td>
					<td class="infotag">:
						<cfif get_plan_row.is_sales eq 0>
							<cfquery name="GET_VISIT_TYPE" datasource="#DSN#">
								SELECT VISIT_TYPE FROM SETUP_VISIT_TYPES WHERE VISIT_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.warning_id#">
							</cfquery>
							<cfoutput>#get_visit_type.visit_type#</cfoutput>
						<cfelse><!--- sats dan kaydedilmisse --->
							<cfquery name="GET_VISIT_TYPE2" datasource="#DSN#">
								SELECT EVENTCAT FROM EVENT_CAT WHERE EVENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.warning_id#">
							</cfquery>				
							<cfoutput>#get_visit_type2.eventcat#</cfoutput>				
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="infotag" nowrap>Ziyaret Edilen</td>
					<td class="infotag" nowrap style="vertical-align:top">: <cfoutput>#get_plan_row.fullname#</cfoutput></td>
				</tr>
				<tr>
					<td class="infotag">Ziyaret Formu</td>
					<td >:
						<cfif len(get_plan_row.analyse_id)>
							<cfquery name="GET_ANALYSE" datasource="#DSN#">
								SELECT ANALYSIS_ID, ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.analyse_id#">
							</cfquery>
							<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=crm.popup_make_analysis&analysis_id=#get_plan_row.analyse_id#&member_type=partner&member_id=#get_plan_row.partner_id#' ,'list');">#get_analyse.analysis_head#&nbsp;</a></cfoutput>
						</cfif>
					</td>
				</tr>
				<tr>
					<td class="infotag" style="vertical-align:top"><cf_get_lang_main no ='178.Katılımcılar'></td>
					<td class="infotag">: 
						<cfquery name="GET_POSIDS" datasource="#DSN#">
							SELECT EVENT_POS_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#event_plan_row_id#">
						</cfquery>
						<cfset get_posids_list = valuelist(get_posids.event_pos_id, ',')>
						<cfoutput>				
						<cfloop query="get_posids">#get_emp_info(event_pos_id,1,0)#,</cfloop>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<td class="infotag" style="vertical-align:top"><cf_get_lang no ='1789.Planlanan Tarih'></td>
					<td class="infotag" style="vertical-align:top">: <cfoutput>#dateformat(get_plan_row.start_date,'dd/mm/yyyy')# #timeformat(get_plan_row.start_date,'HH:mm')# #timeformat(get_plan_row.finish_date,'HH:mm')#</cfoutput></td>
				</tr>
				<cfif listfind(get_posids_list, session.pda.position_code, ',')>
					<tr>
						<td class="infotag" style="vertical-align:top"><cf_get_lang_main no ='217.Açıklama'></td>
						<td style="vertical-align:top"><textarea name="result" id="result" style="width:150px; height:30px;"><cfoutput>#get_plan_row.result_detail#</cfoutput></textarea></td>
					</tr>
					<tr>
						<td class="infotag">Sonuç *</td>
						<td>
							<select name="visit_stage" id="visit_stage" style="width:155px;">
								<option value=""><cf_get_lang_main no ='272.Sonuç'></option>
								<cfoutput query="get_stage_rows">
									<option value="#visit_stage_id#" <cfif visit_stage_id eq get_plan_row.visit_stage>selected</cfif>>#visit_stage#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag">Harcama</td>
						<td>
							<cfsavecontent variable="alert"><cf_get_lang no ='1636.Sayısal Değer Giriniz'></cfsavecontent>
							<cfinput type="text" name="visit_expense" id="visit_expense" validate="float" message="#alert#" passthrough = "onKeyup='return(FormatCurrency(this,event));'" value="#tlformat(get_plan_row.expense)#" style="width:90px; vertical-align:top" class="moneybox">
							<select name="money_name" id="money_name" style="width:55px;">
								<cfoutput query="get_money">
									<option value="#money#" <cfif money eq get_plan_row.money_currency>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
							<select name="expense_item" id="expense_item" style="width:150;">
								<option value="">Gider Kalemi</option>
								<cfoutput query="get_expense_rows">
									<option value="#expense_item_id#" <cfif expense_item_id eq get_plan_row.expense_item>selected</cfif>>#expense_item_name#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td class="infotag">Gerçekleşen Tarih *</td>
						<td>
							<cfsavecontent variable="alert"><cf_get_lang no ='1785.Lütfen Başlama Tarihi Formatını Doğru Giriniz '></cfsavecontent>
							<cfif len(trim(get_plan_row.execute_startdate))>
								<cfinput type="text" name="execute_startdate" id="execute_startdate" style="width:75px; vertical-align:top;" validate="eurodate" message="#alert#" value="#dateformat(get_plan_row.execute_startdate,'dd/mm/yyyy')#" required="yes">
							<cfelse>
								<cfinput type="text" name="execute_startdate" id="execute_startdate" style="width:75px; vertical-align:top;" validate="eurodate" message="#alert#" value="#dateformat(now(),'dd/mm/yyyy')#" required="yes">
							</cfif>
							<select name="execute_start_clock" id="execute_start_clock" style="width:35px;">
								<option value="0" selected><cf_get_lang_main no ='79.Saat'></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<cfoutput>
									<option value="#saat#" <cfif len(get_plan_row.execute_startdate) and hour(get_plan_row.execute_startdate) eq saat>selected</cfif>>#saat#</option>
									</cfoutput>
								</cfloop>
							</select>
							<select name="execute_start_minute" id="execute_start_minute" style="width:35px;">
								<option value="00" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 00>selected</cfif>>00</option>
								<option value="05" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 05>selected</cfif>>05</option>
								<option value="10" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 10>selected</cfif>>10</option>
								<option value="15" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 15>selected</cfif>>15</option>
								<option value="20" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 20>selected</cfif>>20</option>
								<option value="25" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 25>selected</cfif>>25</option>
								<option value="30" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 30>selected</cfif>>30</option>
								<option value="35" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 35>selected</cfif>>35</option>
								<option value="40" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 40>selected</cfif>>40</option>
								<option value="45" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 45>selected</cfif>>45</option>
								<option value="50" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 50>selected</cfif>>50</option>
								<option value="55" <cfif len(get_plan_row.execute_startdate) and minute(get_plan_row.execute_startdate) eq 55>selected</cfif>>55</option>
							</select>
							<select name="execute_finish_clock" id="execute_finish_clock" style="width:35px;">
								<option value="0" selected><cf_get_lang_main no ='79.Saat'></option>
								<cfloop from="7" to="30" index="i">
									<cfset saat=i mod 24>
									<cfoutput>
									<option value="#saat#" <cfif len(get_plan_row.execute_finishdate) and hour(get_plan_row.execute_finishdate) eq saat>selected</cfif>>#saat#</option>
									</cfoutput>
								</cfloop>
							</select>
							<select name="execute_finish_minute" style="width:35px;">
								<option value="00" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 00>selected</cfif>>00</option>
								<option value="05" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 05>selected</cfif>>05</option>
								<option value="10" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 10>selected</cfif>>10</option>
								<option value="15" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 15>selected</cfif>>15</option>
								<option value="20" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 20>selected</cfif>>20</option>
								<option value="25" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 25>selected</cfif>>25</option>
								<option value="30" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 30>selected</cfif>>30</option>
								<option value="35" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 35>selected</cfif>>35</option>
								<option value="40" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 40>selected</cfif>>40</option>
								<option value="45" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 45>selected</cfif>>45</option>
								<option value="50" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 50>selected</cfif>>50</option>
								<option value="55" <cfif len(get_plan_row.execute_finishdate) and minute(get_plan_row.execute_finishdate) eq 55>selected</cfif>>55</option>
							</select>
						</td>
					</tr>
					<tr style="height:35px;">
						<td align="right">&nbsp;</td>
						<td align="left" style="text-align:left"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
					</tr>
				<cfelse>
					<tr>
						<td class="infotag"><cf_get_lang_main no ='272.Sonuç'></td>
						<td>: 
							<cfif len(get_plan_row.visit_stage)>
								<cfquery name="GET_STAGE" datasource="#DSN#">
									SELECT VISIT_STAGE FROM SETUP_VISIT_STAGES WHERE VISIT_STAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.visit_stage#">
								</cfquery>
								<cfoutput>#get_stage.visit_stage#</cfoutput>
							</cfif>
						</td>
						<td class="infotag"><cf_get_lang no ='1635.Gerç Tarihi'></td>
						<td>: 
							<cfoutput>
							<cfif len(get_plan_row.execute_startdate)>#dateformat(get_plan_row.execute_startdate, 'dd/mm/yyyy')# #timeformat(get_plan_row.execute_startdate, 'HH:mm')#</cfif>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang no ='1634.Harcama'></td>
						<td>: <cfoutput>#tlformat(get_plan_row.expense)# #get_plan_row.money_currency#</cfoutput></td>
						<td class="infotag"><cf_get_lang no ='608.Gider Kalemi'></td>
						<td>: 
							<cfif len(get_plan_row.expense_item)>
							  <cfquery name="GET_EXPENSE" datasource="#DSN2#">
								SELECT EXPENSE_ITEM_ID, EXPENSE_ITEM_NAME FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.expense_item#">
							  </cfquery>
							  <cfoutput>#get_expense.expense_item_name#</cfoutput>
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="infotag"><cf_get_lang_main no ='217.Açıklama'></td>
						<td>: <cfoutput>#get_plan_row.result_detail#</cfoutput></td>
					</tr>
				</cfif>
				<cfif len(get_plan_row.result_record_emp)>
					<tr>
						<td class="infotag"><cf_get_lang_main no ='71.Kayıt'></td>
						<td>: <cfoutput>#get_emp_info(get_plan_row.result_record_emp,0,0)# - #dateformat(get_plan_row.result_record_date,'dd/mm/yyyy')#</cfoutput></td>
					</tr>
				</cfif>	
				<cfif len(get_plan_row.result_update_emp)>
					<tr>
						<td class="infotag"><cf_get_lang_main no ='291.Güncelleme'></td>
						<td class="infotag">: <cfoutput>#get_emp_info(get_plan_row.result_update_emp,0,0)# <cfif len(get_plan_row.result_update_date)>- #dateformat(get_plan_row.result_update_date, 'dd/mm/yyyy')#</cfif></cfoutput></td>
					</tr>
				</cfif>
			</table> 
		</td>
	</tr>
</table>
</cfform>

<script type="text/javascript">
	function kontrol()
	{
		x = document.event_result.visit_stage.selectedIndex;
		if(document.event_result.visit_stage[x].value == "")
		{ 
			alert ("<cf_get_lang no ='1633.Lütfen Sonuç Giriniz'>!");
			return false;
		}
		
		tarih1_ = event_result.execute_startdate.value.substr(6,4) + event_result.execute_startdate.value.substr(3,2) + event_result.execute_startdate.value.substr(0,2);
		tarih2_ = event_result.today_value_.value.substr(6,4) + event_result.today_value_.value.substr(3,2) + event_result.today_value_.value.substr(0,2);
		if((event_result.execute_startdate.value != "") && (tarih1_ > tarih2_))
		{
			alert("<cf_get_lang no ='1632.Lütfen Gerçekleşme Tarihini Bugünden Önce Giriniz'> !");
			return false;
		}
		event_result.visit_expense.value = filterNum(event_result.visit_expense.value);
	}
</script>
<cf_get_lang_set module_name="objects">
