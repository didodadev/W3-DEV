<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
	SELECT 
    	EVENT_PLAN_ID, 
        EVENT_PLAN_HEAD, 
        DETAIL, 
        EVENT_STATUS, 
        ANALYSE_ID, 
        ISPOTANTIAL, 
        MAIN_START_DATE, 
        MAIN_FINISH_DATE, 
        EVENT_CAT, 
        SALES_ZONES, 
        IS_ACTIVE, 
        IS_SALES, 
        IS_DAILY, 
        VIEW_TO_ALL, 
        IS_WIEW_BRANCH, 
        IS_WIEW_DEPARTMENT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	EVENT_PLAN 
    WHERE 
    	EVENT_PLAN_ID = #attributes.visit_id#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" height="100%">
  <tr>
  	<td class="headbold" height="35"><cf_get_lang_main no='1010.Ziyaret Planı'> : <cfoutput>#get_event_plan.event_plan_head#</cfoutput></td>
  </tr>
  <tr>
  	<td valign="top" colspan="2">
	<table width="100%" border="0" cellspacing="1" cellpadding="2" height="100%">
	  <tr>
		<td valign="top">
		<table border="0">
		  <tr>
			<td><b><cf_get_lang_main no='75.No'></b></td>
			<td>: <cfoutput>#get_event_plan.event_plan_id#</cfoutput></td>
			<td width="50" valign="top"><b><cf_get_lang_main no='217.açıklama'></b></td>
			<td rowspan="3" valign="top">: <cfoutput>#get_event_plan.detail#</cfoutput></td>
		  </tr>
		  <tr>
		  	<td width="80"><b><cf_get_lang no='414.Plan Adı'></b></td>
		  	<td width="300">: <cfoutput>#get_event_plan.event_plan_head#</cfoutput></td>
		  </tr>
		  <tr>
		  	<td><b><cf_get_lang_main no='642.Süreç  Aşama'></b></td>
		  	<td> : 
			  <cfquery name="GET_P_ROW" datasource="#DSN#">
				SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #get_event_plan.event_status#
			  </cfquery>
			  <cfoutput>#get_p_row.stage#</cfoutput>
			</td>
		  </tr>
		  <tr>
			<td><b><cf_get_lang no='379.Ziyaret Formu'></b></td>
			<td>: 
			  <cfif len(get_event_plan.analyse_id)>
			  	<cfquery name="GET_ANALYSIS" datasource="#dsn#">
					SELECT ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = #get_event_plan.analyse_id#
				</cfquery>
			   <cfoutput>#GET_ANALYSIS.ANALYSIS_HEAD#</cfoutput>
			  </cfif>
			</td>
		  </tr>
		  <tr>
		  	<td><b><cf_get_lang no='107.Yetkili Şubeler'></b></td>
		  	<td> : 
		  	  <cfquery name="GET_BRANCH" datasource="#dsn#">
				SELECT
					BRANCH_NAME,
					BRANCH_ID
				FROM
					BRANCH
				WHERE
					BRANCH_ID = #get_event_plan.sales_zones#
				ORDER BY
					BRANCH_NAME
			  </cfquery>
			  <cfoutput>#get_branch.branch_name#</cfoutput>
		  	</td>
		  	<td><b><cf_get_lang_main no='330.Tarih'></b></td>
		  	<td>: <cfoutput>#dateformat(get_event_plan.main_start_date,dateformat_style)#- #dateformat(get_event_plan.main_finish_date,dateformat_style)#</cfoutput></td>
		  </tr>
		  <tr>
		  	<td><b><cf_get_lang_main no='71.Kayıt'></b></td>
		  	<td>:<cfoutput>#get_emp_info(get_event_plan.record_emp,0,0)# - #dateformat(get_event_plan.record_date,dateformat_style)#</cfoutput></td>
		  	<td><b><cf_get_lang_main no='291.Güncelleme'></b></td>
		  	<td valign="top">: <cfoutput>#get_emp_info(get_event_plan.update_emp,0,0)# <cfif len(get_event_plan.update_date)>-</cfif> #dateformat(get_event_plan.update_date,dateformat_style)#</cfoutput></td>
		  </tr>
		</table>
		</td>
	  </tr>
	  <tr>
		<td height="100%" colspan="2" valign="top">
		<cfquery name="GET_ROW" datasource="#DSN#">
			SELECT
				EVENT_PLAN_ROW_ID, 
                IS_SALES, 
                IS_ACTIVE, 
                BRANCH_ID, 
                COMPANY_ID, 
                PARTNER_ID, 
                CONSUMER_ID, 
                START_DATE, 
                FINISH_DATE, 
                EVENT_PLAN_ID, 
                WARNING_ID, 
                EXPENSE, 
                MONEY_CURRENCY, 
                EXPENSE_ITEM, 
                RECORD_EMP, 
                RECORD_DATE, 
                RECORD_IP, 
                UPDATE_EMP, 
                UPDATE_DATE, 
                UPDATE_IP, 
                ASSET_ID, 
                PROJECT_ID
			FROM
				EVENT_PLAN_ROW
			WHERE
				EVENT_PLAN_ID = #attributes.visit_id#
			ORDER BY
				EVENT_PLAN_ROW_ID
		</cfquery>
		<cfset row_count = get_row.recordcount>
		<table name="table1" id="table1" border="1" bordercolor="#000000">
		  <tr height="22">
			<td nowrap colspan="2"><b><cf_get_lang no='207.Ziyaret Edilecek'></b></td>
			<td width="90" nowrap><b><cf_get_lang_main no='330.Tarih'></b></td>
			<td width="95" nowrap><b><cf_get_lang_main no='243.Başlama Saati'></b></td>
			<td width="95" nowrap><b><cf_get_lang_main no='288.Bitiş Saati'></b></td>
			<td width="155" nowrap><b><cf_get_lang no='270.Ziyaret Nedeni'></b></td>
			<td nowrap><b><cf_get_lang no='384.Ziyaret Edecekler'></b></td>
		  </tr>
		<cfoutput query="get_row">
		  <tr>
			<td>
			  <cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
				SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_row.company_id#
			  </cfquery>
			  #get_company_name.fullname#
			</td>
			<td>
			  <cfif len(get_row.partner_id)>
				<cfquery name="GET_PARTNER" datasource="#DSN#">
					SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_row.partner_id#
				</cfquery>
				#get_partner.company_partner_name# #get_partner.company_partner_surname#
			  </cfif>
			</td>
			<td>#dateformat(get_row.start_date,dateformat_style)#</a>
			<td>#hour(get_row.start_date)# : #numberformat(minute(get_row.start_date),'00')#</td>
			<td>#hour(get_row.finish_date)# : #numberformat(minute(get_row.finish_date),'00')#</td>
			<td>
			  <cfquery name="GET_EVENT_CATS" datasource="#DSN#">
				SELECT 
        	        VISIT_TYPE_ID, 
                    VISIT_TYPE, 
                    DETAIL, 
                    RECORD_IP, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    UPDATE_IP, 
                    UPDATE_DATE,
                    UPDATE_EMP 
                FROM 
    	            SETUP_VISIT_TYPES 
                WHERE 
	                VISIT_TYPE_ID = #get_row.warning_id# ORDER BY VISIT_TYPE
			  </cfquery>
			  #get_event_cats.visit_type#
			</td>
			<td>
			  <cfquery name="GET_ROW_POS" datasource="#DSN#">
				SELECT EVENT_POS_ID FROM EVENT_PLAN_ROW_PARTICIPATION_POS WHERE EVENT_ROW_ID = #event_plan_row_id#
			  </cfquery>
			  <cfloop query="get_row_pos">,#get_emp_info(event_pos_id,1,0)#</cfloop>
			</td>
		  </tr>
		</cfoutput>
		</table>
		</td>
	  </tr>
	</table>
  	</td>
  </tr>
</table>
<script type="text/javascript">
	window.print();
</script>
