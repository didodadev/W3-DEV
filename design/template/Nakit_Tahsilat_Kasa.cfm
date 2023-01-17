<cf_get_lang_set module_name="cash"><!--- sayfanin en altinda kapanisi var --->
<!--- Standart Print Sablonu Kasa Nakit Tahsilat Islemi FB 20080115 --->
<cfif isdefined("attributes.keyword") and attributes.keyword is 'is_multi'>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			CM.*,
			CA.CASH_ACTION_FROM_COMPANY_ID,
			CA.CASH_ACTION_FROM_CONSUMER_ID,
			CA.CASH_ACTION_FROM_EMPLOYEE_ID,
			CA.OTHER_CASH_ACT_VALUE,
			CA.PROJECT_ID,
			CA.PAPER_NO,
			CA.CASH_ACTION_VALUE,
			CA.CASH_ACTION_CURRENCY_ID,
			CA.ACTION_DETAIL,
			CA.ACTION_ID,
			CA.OTHER_MONEY AS ACTION_CURRENCY,
			CA.REVENUE_COLLECTOR_ID,
			CM.UPD_STATUS
		FROM
			CASH_ACTIONS_MULTI CM,
			CASH_ACTIONS CA
		WHERE
			CM.MULTI_ACTION_ID = CA.MULTI_ACTION_ID 
			AND CM.MULTI_ACTION_ID = #attributes.action_id#
	</cfquery>
<cfelse>
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT * FROM CASH_ACTIONS WHERE ACTION_ID = #attributes.action_id#
	</cfquery>
</cfif>
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
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("session.ep.company_id")>
		COMP_ID = #session.ep.company_id#
	<cfelseif isDefined("session.pp.company")>	
		COMP_ID = #session.pp.company#
	</cfif>
</cfquery>

<table width="650" border="0" cellspacing="0" cellpadding="0">
	<cfoutput query="check">
	<tr> 
		<td valign="top">
			<table>
				<cfif len(asset_file_name3)>
					<tr>
						<td style="text-align:right;"><cf_get_server_file output_file="settings/#asset_file_name3#" output_server="#asset_file_name3_server_id#" output_type="5"></td>
					</tr>
				</cfif>
				<tr>
					<td class="headbold">#company_name#</td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='87.Telefon'>:</b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4#</td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='76.Fax'>:</b> (#tel_code#) - #fax#</td>
				</tr>
				<tr>
					<td>#address#</td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='1350.Vergi Dairesi'>:</b> #tax_office# - <b><cf_get_lang_main no='340.Vergi No'>:</b> #tax_no#</td>
				</tr>
				<tr>
					<td>#web#  #email#</td>
				</tr>
			</table>
		</td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="2"><hr></td>
	</tr>
</table>
<cfoutput query="get_action_detail">
<table width="650">
	<tr>
		<td><cf_get_lang no='117.Tahsilat Makbuzu No'>: <strong>#get_action_detail.paper_no#</strong></td>
		<td style="text-align:right;"><cf_get_lang_main no='330.Tarih'>: <strong>#dateformat(get_action_detail.action_date,dateformat_style)#</strong></td>
	</tr>
	<tr>
		<td height="30" colspan="2" valign="bottom">
			<strong>
			<cfif len(get_action_detail.CASH_ACTION_FROM_COMPANY_ID)>
				#get_par_info(get_action_detail.CASH_ACTION_FROM_COMPANY_ID,1,1,0)#
			<cfelseif len(get_action_detail.CASH_ACTION_FROM_CONSUMER_ID)>
				#get_cons_info(get_action_detail.CASH_ACTION_FROM_CONSUMER_ID,0,0)#
			<cfelseif len(get_action_detail.CASH_ACTION_FROM_EMPLOYEE_ID)>
				#get_emp_info(get_action_detail.CASH_ACTION_FROM_EMPLOYEE_ID,0,0)#
			</cfif>
			</strong>
			<cf_get_lang no='108.Hesabına Mahsuben Yalnız'>
			<cfset mynumber = get_action_detail.cash_action_value>
			<cfset mybirim = get_action_detail.cash_action_currency_id>
			<cf_n2txt number="mynumber" para_birimi="#mybirim#"><strong>#myNumber#</strong>
			<cf_get_lang no='119.Tahsil Edilmiştir'>
		</td>
	</tr>
</table>
<table width="650">
	<tr>
		<td><hr></td>
	</tr>
	<tr>
		<td style="text-align:right;">
		<table>
			<tr>
				<td width="50"><strong><cf_get_lang_main no='1233.Nakit'> :</strong></td>
				<td width="150"> #TLFormat(get_action_detail.CASH_ACTION_VALUE)#&nbsp;#get_action_detail.cash_action_currency_id#</td>
				<td width="100"><strong><cf_get_lang no='22.Tahsil Eden'> :</strong></td>
				<td> <cfif len(get_action_detail.revenue_collector_id)>#get_emp_info(get_action_detail.revenue_collector_id,0,0)#</cfif></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr height="30">
		<td>&nbsp;</td>
	</tr>
</table>
</cfoutput>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

