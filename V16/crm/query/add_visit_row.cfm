<cfif isdefined("attributes.partner_id")>
	<cfquery name="GET_PLAN_RESULT" datasource="#dsn#">
		SELECT
			EVENT_PLAN.EVENT_PLAN_HEAD,
			COMPANY.FULLNAME,
			COMPANY_PARTNER.COMPANY_PARTNER_NAME,
			COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
			EVENT_PLAN.EVENT_PLAN_ID,
			EVENT_PLAN_ROW.START_DATE,
			EVENT_PLAN_ROW.FINISH_DATE,
			SETUP_VISIT_TYPES.VISIT_TYPE
		FROM
			EVENT_PLAN,
			EVENT_PLAN_ROW,
			COMPANY,
			COMPANY_PARTNER,
			SETUP_VISIT_TYPES
		WHERE
			EVENT_PLAN.ISPOTANTIAL = 1 AND
			EVENT_PLAN.IS_ACTIVE = 1 AND
			EVENT_PLAN_ROW.PLAN_ROW_STATUS = 1 AND
			COMPANY_PARTNER.PARTNER_ID = #attributes.partner_id# AND
			COMPANY_PARTNER.PARTNER_ID = EVENT_PLAN_ROW.PARTNER_ID AND
			COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
			SETUP_VISIT_TYPES.VISIT_TYPE_ID = EVENT_PLAN_ROW.WARNING_ID AND
			EVENT_PLAN_ROW.EVENT_PLAN_ID = EVENT_PLAN.EVENT_PLAN_ID AND
			EVENT_PLAN_ROW.RESULT_RECORD_EMP IS NOT NULL
	</cfquery>
	<cfif (get_plan_result.recordcount) and (not isdefined("attributes.is_submitted"))>
	<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
	  <tr class="color-border">
		<td>
		<table width="100%" height="100%" border="0" cellpadding="2" cellspacing="1">
		  <tr class="color-list">
		  	<td height="35" class="headbold"><cf_get_lang no ='922.Bu Müşteriye Daha Önceden Planlanmış Ziyaretleriniz Var'></td>
		  </tr>
		  <tr class="color-row">
		  	<td valign="top">
			<table>
			<cfoutput query="get_plan_result">
			  <tr>
				<td class="txtboldblue" width="40"><cf_get_lang_main no ='512.Kime'></td>
				<td width="200">: #fullname# - #company_partner_name# #company_partner_surname#</td>
				<td width="75" class="txtboldblue"><cf_get_lang no ='923.Ziyaret Tarihi'></td>
				<td width="150">: #dateformat(start_date,dateformat_style)# #timeformat(start_date, timeformat_style)# #timeformat(finish_date, timeformat_style)#</td>
			  </tr>
			  <tr>
				<td class="txtboldblue"><cf_get_lang no ='273.Plan'></td>
				<td>: <a href="##" onBlur="go_result('#event_plan_id#');" class="tableyazi">#event_plan_head#</a></td>
				<td class="txtboldblue"><cf_get_lang no ='270.Ziyaret Nedeni'></td>
				<td>: #visit_type#</td>
			  </tr>
			  <tr>
				<td colspan="4"><hr></td>
			  </tr>
			</cfoutput>
			<form name="add_values" method="post" action="">
			  <tr>
				<td colspan="4">
				  <cfloop list="#form.fieldnames#" index="i">
					<cfoutput><input type="hidden" name="#i#" id="#i#" value="#evaluate(i)#"></cfoutput>
				  </cfloop>
				  <input type="hidden" name="is_submitted" id="is_submitted" value="1">
				  <input type="button" name="Geri" value=" Geri Dön " onClick="history.back();">
				  <input type="submit" name="Devam" value=" Varolan Kaydı Gözardı Et " onClick="form.submit();">
			  </tr>
			</form>
			</table>
			</td>
		  </tr>
		</table>
		</td>
	  </tr>
	</table>
	<cfelse>
	  <cfif isdefined("attributes.partner_id")>
		<cf_date tarih='attributes.execute_startdate'>
		<cfscript>
			form_execute_start_date = date_add("h", attributes.execute_start_clock, attributes.execute_startdate);
			form_execute_start_date = date_add('n', attributes.execute_start_minute, form_execute_start_date);
			form_execute_finish_date = date_add('h', attributes.execute_finish_clock, attributes.execute_startdate);
			form_execute_finish_date = date_add('n', attributes.execute_finish_minute, form_execute_finish_date);
		</cfscript>
		<cfquery name="ADD_EVENT_PLAN_ROW" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				EVENT_PLAN_ROW
			(
				BRANCH_ID,
				IS_ACTIVE,
				IS_SALES,
				COMPANY_ID,
				PARTNER_ID,
				WARNING_ID,
				START_DATE,
				FINISH_DATE,
				VISIT_STAGE,
				EXPENSE,
				MONEY_CURRENCY,
				EXECUTE_STARTDATE,
				EXECUTE_FINISHDATE,
				EXPENSE_ITEM,
				PLAN_ROW_STATUS,
				RESULT_DETAIL,
				RESULT_RECORD_DATE,
				RESULT_RECORD_IP,
				RESULT_RECORD_EMP,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				<cfif len(attributes.sales_zones)>#attributes.sales_zones#<cfelse>NULL</cfif>,
				1,
				0,
				#attributes.company_id#,
				#attributes.partner_id#,
				#attributes.visit_type#,
				#form_execute_start_date#,
				#form_execute_finish_date#,
				#attributes.visit_stage#,
				<cfif len(attributes.visit_expense)>#attributes.visit_expense#<cfelse>NULL</cfif>,
				<cfif len(attributes.money)>'#attributes.money#'<cfelse>NULL</cfif>,
				#form_execute_start_date#,
				#form_execute_finish_date#,
				<cfif len(attributes.expense_item)>#attributes.expense_item#<cfelse>NULL</cfif>,
				1,
				'#attributes.detail#',
				#now()#,
				'#cgi.remote_addr#',
				#session.ep.userid#,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
		</cfquery>
		<cfif len(attributes.employee_id) and len(attributes.employee_name)>
		  <cfloop from="1" to="#listlen(attributes.employee_id,',')#" index="i">
			<cfquery name="ADD_ROW_POS" datasource="#DSN#">
				INSERT INTO
					EVENT_PLAN_ROW_PARTICIPATION_POS
				(
					EVENT_ROW_ID,
					EVENT_POS_ID
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					#listgetat(attributes.employee_id, i, ',')#
				)
			</cfquery>
		  </cfloop> 
		</cfif>
	  </cfif>
	  <script type="text/javascript">
	  	<cfif not isdefined("attributes.draggable")>
			wrk_opener_reload();
			window.close();
		<cfelse>
			location.href = document.referrer;
		</cfif>
	  </script>
	</cfif>
</cfif>
<script type="text/javascript">
function go_result(url_id)
{
	opener.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=crm.form_upd_visit&visit_id=' + url_id;
	window.close();
}
</script>
