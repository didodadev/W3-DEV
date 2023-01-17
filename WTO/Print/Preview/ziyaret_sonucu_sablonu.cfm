<!--- Standart Print Sablonu Ziyaret Sonucu GI 20201016 --->
<cfquery name="GET_PLAN_ROW" datasource="#DSN#">
	SELECT
		1 TYPE,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.ANALYSE_ID, 
		EVENT_PLAN_ROW.SUB_EXPENSE_ID,
		EVENT_PLAN_ROW.SUB_EST_LIMIT,
		EVENT_PLAN_ROW.SUB_MONEY,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE, 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN_ROW.VISIT_STAGE,
		EVENT_PLAN_ROW.EXPENSE,
		EVENT_PLAN_ROW.MONEY_CURRENCY,
		EVENT_PLAN_ROW.EXPENSE_ITEM,
		EVENT_PLAN_ROW.PARTNER_ID,
		EVENT_PLAN_ROW.IS_SALES,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_ID MEMBER_ID,
		COMPANY_PARTNER.PARTNER_ID PARTNER_ID,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER.COMPANY_PARTNER_SURNAME MEMBER_PARTNER_NAME,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN.EVENT_CAT,
		EVENT_PLAN_ROW.RESULT_DETAIL,
        EVENT_PLAN_ROW.ASSET_ID,
		EVENT_PLAN_ROW.RESULT_PROCESS_STAGE,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.VISIT_RESULT_ID

	FROM
		COMPANY,
		COMPANY_PARTNER,
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = #attributes.action_id# AND 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		EVENT_PLAN_ROW.COMPANY_ID = COMPANY.COMPANY_ID AND
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID
	
	UNION ALL
		
	SELECT
		2 TYPE,
		EVENT_PLAN.EVENT_PLAN_HEAD,
		EVENT_PLAN.ANALYSE_ID, 
		EVENT_PLAN_ROW.SUB_EXPENSE_ID,
		EVENT_PLAN_ROW.SUB_EST_LIMIT,
		EVENT_PLAN_ROW.SUB_MONEY,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN_ROW.START_DATE,
		EVENT_PLAN_ROW.FINISH_DATE, 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID,
		EVENT_PLAN_ROW.VISIT_STAGE,
		EVENT_PLAN_ROW.EXPENSE,
		EVENT_PLAN_ROW.MONEY_CURRENCY,
		EVENT_PLAN_ROW.EXPENSE_ITEM,
		EVENT_PLAN_ROW.PARTNER_ID,
		EVENT_PLAN_ROW.IS_SALES,
		CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME FULLNAME,
		CONSUMER.CONSUMER_ID MEMBER_ID,
		'' PARTNER_ID,
		CONSUMER.CONSUMER_NAME + ' ' + CONSUMER.CONSUMER_SURNAME MEMBER_PARTNER_NAME,
		EVENT_PLAN_ROW.WARNING_ID,
		EVENT_PLAN.EVENT_CAT,
		EVENT_PLAN_ROW.RESULT_DETAIL,
        EVENT_PLAN_ROW.ASSET_ID,
		EVENT_PLAN_ROW.RESULT_PROCESS_STAGE,
		EVENT_PLAN_ROW.EXECUTE_STARTDATE,
		EVENT_PLAN_ROW.EXECUTE_FINISHDATE,
		EVENT_PLAN_ROW.VISIT_RESULT_ID
	FROM
		CONSUMER,
		EVENT_PLAN,
		EVENT_PLAN_ROW
	WHERE 
		EVENT_PLAN_ROW.EVENT_PLAN_ROW_ID = #attributes.action_id# AND 
		EVENT_PLAN_ROW.CONSUMER_ID = CONSUMER.CONSUMER_ID AND
		EVENT_PLAN.EVENT_PLAN_ID = EVENT_PLAN_ROW.EVENT_PLAN_ID
</cfquery>
<cfquery name="check" datasource="#dsn#">
	SELECT
		COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("session.ep.company_id")>
		COMP_ID = #session.ep.company_id#
	<cfelseif isDefined("session.pp.company")>	
        COMP_ID = #session.pp.company#
    <cfelseif isDefined("session.ww.company")>	
		COMP_ID = #session.pp.company#
	</cfif>
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn#">
	SELECT
		*
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #session.ep.period_id# AND
		MONEY_STATUS = 1 AND
		MONEY <> '#session.ep.money#'
</cfquery>
<br/>
<table width="650" border="1" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="3" height="100" valign="top"><br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td colspan="2">
					<cfoutput query="check">
						<table border="0" cellpadding="0" cellspacing="0" width="98%" align="center">
							<tr>
								<td width="40%" style="text-align:left;" valign="top">
								<cf_get_server_file 
								output_file="settings/#CHECK.asset_file_name2#" 
								output_server="#CHECK.asset_file_name2_server_id#" 
								output_type="5" image_width="300">
								</td>
							</tr>
							<tr>
								<td width="170" style="text-align:center;font-size:20px!important;"><cfoutput>#get_plan_row.event_plan_head#</cfoutput></td>
							</tr>
							<tr>
								<td width="170" style="text-align:right"><cf_get_lang dictionary_id="39422.Belge Tarihi">&nbsp;:&nbsp;<cfoutput>#Dateformat(now(),dateformat_style)# #timeformat(now())#</cfoutput></td>
							</tr>
							<tr>
								<td width="170" style="text-align:left;font-size:16px;margin:10px!important;">
									<cfoutput>#get_plan_row.fullname#</cfoutput>   
								</td>
							</tr>
							<tr>
								<td width="170" style="text-align:left;font-size:12px;margin:10px!important;">
									<cf_get_lang dictionary_id="52370.Ziyaret Tarihi">&nbsp;:&nbsp;<cfoutput>#dateformat(get_plan_row.execute_startdate,dateformat_style)# #timeformat(get_plan_row.execute_startdate,timeformat_style)#</cfoutput> - <cfoutput>#timeformat(get_plan_row.execute_finishdate,timeformat_style)#</cfoutput></td> 
								</td>
							</tr>
							<tr>
								<td width="170" style="text-align:left;font-size:12px;margin:10px!important;">
									<cfquery name="GET_VISIT_TYPE" datasource="#DSN#">
										SELECT VISIT_TYPE,VISIT_TYPE_ID FROM SETUP_VISIT_TYPES WHERE VISIT_TYPE_ID = #get_plan_row.warning_id#
									</cfquery>
									<cf_get_lang dictionary_id ='34030.Ziyaret Nedeni'>&nbsp;:&nbsp;<cfoutput>#get_visit_type.visit_type#</cfoutput></td> 
								</td>
							</tr>
							<tr>
								<td width="170" style="text-align:left;font-size:12px;margin:10px!important;">
									<cf_get_lang dictionary_id="58859.Süreç">: 
									<cfif len(get_plan_row.result_process_stage)>
										<cfquery name="get_process_row_name" datasource="#DSN#">
											SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_plan_row.result_process_stage#">
										</cfquery>
										<cfoutput>&nbsp;:&nbsp;#get_process_row_name.stage#</cfoutput>
									</cfif>
								</td>
							</tr>
							<tr>
								<td width="170" style="text-align:left;font-size:12px;margin:10px!important;">
									<cf_get_lang dictionary_id="58437.Ziyaret Sonucu">: 
										<cfif len(get_plan_row.visit_result_id)>
									<cfquery datasource="#dsn#" name="get_result">
										SELECT VISIT_RESULT_ID,VISIT_RESULT FROM SETUP_VISIT_RESULT WHERE VISIT_RESULT_ID = #get_plan_row.visit_result_id# AND IS_ACTIVE = 1 
									</cfquery>
									<cfoutput>&nbsp;#get_result.visit_result#</cfoutput>
								</cfif>
								</td>
							</tr>
							<br/>
						</table>
					</cfoutput>
                </td>
            </tr>
		</table>
		</td>
	</tr>
</table><br/><br/>
<table width="650" border="1" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="4" valign="top"><br/>
			<table width="250" border="0">
				<tr>
					<td width="170" style="text-align:left;font-size:12px;margin:10px!important;"><cf_get_lang dictionary_id ='57590.Katılımcılar'></td>
				</tr>
			</table><hr>
			<table width="250" border="0">
				<tr>
					<td>
						<cfquery name="GET_POSIDS" datasource="#DSN#">
							SELECT EVENT_POS_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = #action_id#
						</cfquery>
						<cfset get_posids_list = valuelist(get_posids.event_pos_id, ',')>
						<cfoutput>				
						<cfloop query="get_posids">#get_emp_info(event_pos_id,1,0)#<cfif get_posids.currentrow neq get_posids.recordcount>,</cfif></cfloop></cfoutput>
					</td>
				</tr>
			</table>
		</td>
		<td><table width="350" border="0">
			<tr><td width="170" style="text-align:left;font-size:12px;margin:10px!important;"><cf_get_lang dictionary_id ='57629.Açıklama'>:<cfoutput>#get_plan_row.result_detail#</cfoutput></td></tr>
		</table></td>
	</tr>
</table>