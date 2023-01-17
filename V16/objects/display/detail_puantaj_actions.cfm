<cfif type eq 1><!--- cari hareketler listesinden geliyorsa tekli display sayfası --->
	<cfif isdefined("attributes.period_id") and len(attributes.period_id) >
		<cfquery name="get_period" datasource="#DSN#">
			SELECT * FROM SETUP_PERIOD WHERE PERIOD_ID = #attributes.period_id#
		</cfquery>
		<cfset db_adres = "#dsn#_#get_period.period_year#_#get_period.our_company_id#">
	<cfelse>
		<cfset db_adres = "#dsn2#">
	</cfif>
	<cfquery name="get_action_detail" datasource="#db_adres#">
		SELECT * FROM CARI_ROWS WHERE CARI_ACTION_ID = #attributes.ID#
	</cfquery>
     <cfquery name="GET_CARD" datasource="#dsn2#">
        SELECT
            ACS.CARD_ID
        FROM
            ACCOUNT_CARD ACS
        WHERE
            ACS.ACTION_TYPE = #get_action_detail.action_type_id#
            AND ACS.ACTION_ID =  #get_action_detail.ACTION_ID#
    </cfquery>
    <cfsavecontent variable="right">
        <cfif GET_CARD.recordcount  and isdefined("session.ep.user_level") and listgetat(session.ep.user_level,22)>
            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=account.popup_list_card_rows&action_id=#get_action_detail.ACTION_ID#&process_cat=#get_action_detail.action_type_id#</cfoutput>','page');"><img src="/images/extre.gif"  border="0" title="<cf_get_lang dictionary_id ='59032.Muhasebe Hareketleri'>"></a>
        </cfif>
	</cfsavecontent>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='32906.Kesinti Tahakkuk Fişi'></cfsavecontent>
	<cf_popup_box title="#message#" right_images="#right#">	
	<table>
		<cfoutput>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id ='57742.Tarih'></td>
			<td>#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
		</tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id ='57576.Çalışan'></td>
			<td>
				<cfif len(get_action_detail.to_employee_id)>
					#get_emp_info(get_action_detail.to_employee_id,0,0,0,get_action_detail.acc_type_id)#
				<cfelseif len(get_action_detail.from_employee_id)>
					#get_emp_info(get_action_detail.from_employee_id,0,0,0,get_action_detail.acc_type_id)#
				<cfelseif len(get_action_detail.from_cmp_id)>
					#get_par_info(get_action_detail.from_cmp_id,1,1,0)#
				<cfelseif len(get_action_detail.from_consumer_id)>
					#get_cons_info(get_action_detail.from_consumer_id,0,0)#
				</cfif>
			</td>
		</tr>
		<tr>
			<td class="txtbold" height="20"><cf_get_lang dictionary_id ='57673.Tutar'></td>
			<td>#TLFormat(get_action_detail.ACTION_VALUE)# #session.ep.money#</td>
		</tr>
		<tr>
			<td class="txtbold" height="20"><cf_get_lang dictionary_id ='58056.Dövizli Tutar'></td>
			<td>#TLFormat(get_action_detail.OTHER_CASH_ACT_VALUE)# #get_action_detail.OTHER_MONEY#</td>
		</tr>
		<tr>
			<td class="txtbold" height="20"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td>#get_action_detail.action_detail#</td>
		</tr>
		</cfoutput>
	</table>
	</cf_popup_box>
	<cf_popup_box_footer>
		<cf_record_info query_name="get_action_detail">
	</cf_popup_box_footer>
<cfelseif type eq 2><!--- puantaj detayından geliyorsa --->
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			CR.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME 
		FROM 
			CARI_ROWS CR,
			#dsn_alias#.EMPLOYEES E 
		WHERE 
			CR.RECORD_EMP = E.EMPLOYEE_ID AND
			CR.ACTION_TYPE_ID =161 AND 
			CR.ACTION_ID = #attributes.puantaj_id#
	</cfquery>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id ='32909.Kesinti Tahakkuk Fişleri'></cfsavecontent>
	<cf_popup_box title="#message#">
		<table>
			<tr class="txtboldblue">
				<td><cf_get_lang dictionary_id ='57519.Cari Hesap'></td>
				<td><cf_get_lang dictionary_id ='57629.Açıklama'></td>
				<td width="75"><cf_get_lang dictionary_id ='57879.İşlem T'></td>
				<td class="txtbold" height="20"><cf_get_lang dictionary_id ='57673.Tutar'></td>
			</tr>
			<cfoutput query="get_action_detail">
				<tr height="20">
					<td>
						<cfif len(get_action_detail.to_employee_id)>
							#get_emp_info(get_action_detail.to_employee_id,0,1,0,get_action_detail.acc_type_id)#
						<cfelseif len(get_action_detail.from_employee_id)>
							#get_emp_info(get_action_detail.from_employee_id,0,1,0,get_action_detail.acc_type_id)#
						<cfelseif len(get_action_detail.from_cmp_id)>
							#get_par_info(get_action_detail.from_cmp_id,1,1,1)#
						<cfelseif len(get_action_detail.from_consumer_id)>
							#get_cons_info(get_action_detail.from_consumer_id,0,1)#
					  </cfif>
					</td>
					<td>#action_detail#</td>
					<td>#dateformat(get_action_detail.ACTION_DATE,dateformat_style)#</td>
					<td style="text-align:right;">#TLFormat(get_action_detail.ACTION_VALUE)# #session.ep.money#</td>
				</tr>
			</cfoutput>
		</table>
		</cf_popup_box>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_action_detail">
		</cf_popup_box_footer>
<cfelseif type eq 3><!--- Puantaj detayından bütçe kayıtları için açılıyorsa --->
	<cfquery name="get_action_detail" datasource="#dsn2#">
		SELECT
			EX.*,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME 
		FROM 
			EXPENSE_ITEMS_ROWS EX,
			#dsn_alias#.EMPLOYEES E 
		WHERE 
			EX.RECORD_EMP = E.EMPLOYEE_ID 
			AND EX.EXPENSE_COST_TYPE = 161 
			AND EX.ACTION_ID = #attributes.puantaj_id#
			AND EX.ACTION_TABLE = 'EMPLOYEES_PUANTAJ'
	</cfquery>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='32907.Puantaj Tahakkuk Fişleri'></cfsavecontent>
	<cf_popup_box title="#message#">
		<table>
			<tr class="txtboldblue">
				<td><cf_get_lang dictionary_id ='57629.Açıklama'></td>
				<td width="75"><cf_get_lang dictionary_id ='57879.İşlem T'></td>
				<cfif get_action_detail.company_partner_id neq 0>
					<td width="120"><cf_get_lang dictionary_id ='33257.Harcama Yapan'></td>
				</cfif>
				<td class="txtbold" height="20"><cf_get_lang dictionary_id ='57673.Tutar'></td>
			</tr>
			<cfoutput query="get_action_detail">
				<tr height="20">
					<td nowrap>#detail#</td>
					<td>#dateformat(get_action_detail.expense_date,dateformat_style)#</td>
					<cfif get_action_detail.company_partner_id neq 0>
						<td>#get_emp_info(get_action_detail.company_partner_id,0,0)#</td>
					</cfif>
					<td style="text-align:right;">#TLFormat(get_action_detail.total_amount)# #session.ep.money#</td>
				</tr>
			</cfoutput>
		</table>
		</cf_popup_box>
		<cf_popup_box_footer>
			<cf_record_info query_name="get_action_detail">
		</cf_popup_box_footer>
</cfif>
