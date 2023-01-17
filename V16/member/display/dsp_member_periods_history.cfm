<!---
	FBS 20080416 Kurumsal ve Bireysel Uyelerin MUHASEBE DONEMLERININ history kayitlarini goruntulemek icin olusturuldu
	member_type --> consumer veya company - required
	member_id   --> company_id veya consumer_id - required
	Ornek Link : <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=member.popup_member_periods_history&member_type=company&member_id=#attributes.cpid#</cfoutput>','medium','popup_member_periods_history');"><img src="/images/history.gif" title="<cf_get_lang_main no='61.Tarihçe'>" border="0"></a>
--->
<cfquery name="get_member_periods_history" datasource="#dsn#">
	SELECT
		*
	FROM
		MEMBER_PERIODS_HISTORY
	WHERE
	<cfif attributes.member_type is "company">
		COMPANY_ID = #attributes.member_id#
	<cfelseif attributes.member_type is "consumer">
		CONSUMER_ID = #attributes.member_id#
	</cfif>
	ORDER BY
		HISTORY_ID DESC,
		RECORD_DATE DESC
</cfquery>
<cfif get_member_periods_history.recordcount>
	<cfset record_list = "">
	<cfset period_list = "">
	<cfoutput query="get_member_periods_history">
		<cfif len(record_emp) and not listfind(record_list,record_emp)>
			<cfset record_list=listappend(record_list,record_emp)>
		</cfif>
		<cfif len(period_id) and not listfind(period_list,period_id)>
			<cfset period_list=listappend(period_list,period_id)>
		</cfif>
	</cfoutput>
	<cfif len(record_list)>
		<cfset record_list = listsort(record_list,'numeric','ASC',',')>
		<cfquery name="get_record" datasource="#dsn#">
			SELECT EMPLOYEE_ID, EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_list#) ORDER BY EMPLOYEE_ID
		</cfquery>
		<cfset record_list = listsort(listdeleteduplicates(valuelist(get_record.employee_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(period_list)>
		<cfset period_list = listsort(period_list,'numeric','ASC',',')>
		<cfquery name="get_period" datasource="#dsn#">
			 SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD WHERE PERIOD_ID IN (#period_list#) ORDER BY PERIOD_ID
		</cfquery>
		<cfset period_list = listsort(listdeleteduplicates(valuelist(get_period.period_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif attributes.member_type is "company">
		<cfquery name="get_period_year" datasource="#dsn#">
			SELECT
				CP.PERIOD_ID,
				C.PERIOD_ID AS DEFAULT_PERIOD
			FROM
				COMPANY_PERIOD CP,
				COMPANY C
			WHERE
				CP.COMPANY_ID = #attributes.member_id# 
				AND CP.COMPANY_ID = C.COMPANY_ID
		</cfquery>
	<cfelseif attributes.member_type is "consumer">
		<cfquery name="get_period_year" datasource="#dsn#">
			SELECT
				CP.PERIOD_ID,
				C.PERIOD_ID AS DEFAULT_PERIOD
			FROM
				CONSUMER_PERIOD CP,
				CONSUMER C
			WHERE
				C.CONSUMER_ID = #attributes.member_id# AND
				CP.CONSUMER_ID = C.CONSUMER_ID
		</cfquery>
	</cfif>
</cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='30172.Muhasebe Dönemi'> <cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
<cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cf_grid_list>
		<cfif get_member_periods_history.recordcount>
			<thead>
				<tr align="left">
					<th colspan="13" height="30" align="left">
						<strong>
						<cfif attributes.member_type is "company">
							<cfoutput>#get_par_info(get_member_periods_history.company_id,-1,0,0)#</cfoutput>
						<cfelseif attributes.member_type is "consumer">
							<cfoutput>#get_cons_info(get_member_periods_history.consumer_id,0,0,0)#</cfoutput>
						</cfif>
						</strong>
					</th>
				</tr>
				<tr class="txtboldblue">
					<th><cf_get_lang dictionary_id ='57485.Öncelik'></th>
					<th><cf_get_lang dictionary_id ='30633.Periyod'></th>
					<th><cf_get_lang dictionary_id ='58605.Period / Yıl'></th>
					<th><cf_get_lang dictionary_id ='30634.Muhasebe Hesabı'></th>
					<cfif attributes.member_type is "company"><th width="10%"><cf_get_lang dictionary_id ='57916.Konsinye Mal Hesabı'></th></cfif>
					<th><cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></th>
					<th><cf_get_lang dictionary_id='38373.Satış Hesabı'></th>
					<th><cf_get_lang dictionary_id='38375.Alış Hesabı'></th>
					<th><cf_get_lang dictionary_id='40316.Alınan Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></th>
					<th><cf_get_lang dictionary_id='58490.Verilen'><cf_get_lang dictionary_id='58689.Teminat'><cf_get_lang dictionary_id='48668.Hesabı'></th>
					<th><cf_get_lang dictionary_id='58488.Alınan'><cf_get_lang dictionary_id='58204.Avans'><cf_get_lang dictionary_id='48668.Hesabı'></th>
					<th><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38373.Satış Hesabı'></th>
					<th><cf_get_lang dictionary_id='44411.İhraç Kayıtlı'><cf_get_lang dictionary_id='38375.Alış Hesabı'></th>
				</tr>
			</thead>
			<cfoutput query="get_member_periods_history" group="history_id">
				<tbody>
					<tr>
						<td><cfif get_period_year.default_period eq period_id><input type="radio" value="1" checked disabled><cfelse><input type="radio" value="1" disabled></cfif></td>
						<td><cfif len(period_id)>#get_period.period[listfind(period_list,period_id,',')]#</cfif></td>
						<td><cfif len(period_id)>#get_period.period_year[listfind(period_list,period_id,',')]#</cfif></td>
						<td>#account_code#</td>
						<cfif attributes.member_type is "company"><td>#konsinye_code#</td></cfif>
						<td>#advance_payment_code#</td>
						<td>#sales_account#</td>
						<td>#purchase_account#</td>
						<td>#received_guarantee_account#</td>
						<td>#given_guarantee_account#</td>
						<td>#received_advance_account#</td>
						<td>#export_registered_sales_account#</td>
						<td>#export_registered_buy_account#</td>
					</tr>
					<tr>
						<td class="txtboldblue"><cf_get_lang dictionary_id='57899.Kaydeden'></td>
						<td colspan="12"><cfif len(record_emp)><strong>#get_record.employee_name[listfind(record_list,record_emp,',')]# #get_record.employee_surname[listfind(record_list,record_emp,',')]# - #DateFormat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</strong></cfif></td>
					</tr>
				</tbody>
			</cfoutput>
		<cfelse>
			<tr height="20">
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</cf_grid_list>
</cf_box>

