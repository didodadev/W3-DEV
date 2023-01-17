<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_process_cancel" default="0">
<cfquery name="GET_PROVISION_IMPORTS" datasource="#dsn2#">
	SELECT
		FILE_IMPORT_BANK_POS_ROW_ID,
		F_I_ROW.SELLER_CODE,
		TERMINAL_NO,
		PROCESS_DATE,
		VALOR_DATE,
		BANK_TYPE,
		COMPANY_ID,
		ACCOUNT_ID,
		NET_TOTAL,
		COMMISSION,
		NUMBER_OF_INSTALMENT,
		AWARD,
		GROSS_TOTAL,
		CARI_TUTAR,
		POS_PROCESS_TYPE,
		EQUIPMENT,
		1 DEF_INFO,<!--- banka pos tanımlarda kaydı olması durumu --->
		F_I_ROW.IS_CANCEL
	FROM
		FILE_IMPORT_BANK_POS_ROWS F_I_ROW,
		#dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
	WHERE
		F_I_ROW.SELLER_CODE = POS_EQUIPMENT_BANK.SELLER_CODE AND
		<!--- F_I_ROW.TERMINAL_NO = POS_EQUIPMENT_BANK.POS_CODE AND --->
		F_I_ROW.FILE_IMPORT_ID = #attributes.i_id# AND
		F_I_ROW.CC_REVENUE_ID IS NULL
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND DATEDIFF(d,PROCESS_DATE,VALOR_DATE) = #attributes.keyword#
		</cfif>
		<cfif isDefined("attributes.is_process_cancel") and len(attributes.is_process_cancel)>
			AND F_I_ROW.IS_CANCEL = #attributes.is_process_cancel#
		</cfif>
UNION ALL
	SELECT
		FILE_IMPORT_BANK_POS_ROW_ID,
		F_I_ROW.SELLER_CODE,
		TERMINAL_NO,
		PROCESS_DATE,
		VALOR_DATE,
		BANK_TYPE,
		0 COMPANY_ID,
		0 ACCOUNT_ID,
		NET_TOTAL,
		COMMISSION,
		NUMBER_OF_INSTALMENT,
		AWARD,
		GROSS_TOTAL,
		CARI_TUTAR,
		POS_PROCESS_TYPE,
		'' EQUIPMENT,
		0 DEF_INFO,
		F_I_ROW.IS_CANCEL
	FROM
		FILE_IMPORT_BANK_POS_ROWS F_I_ROW
	WHERE
		F_I_ROW.FILE_IMPORT_ID = #attributes.i_id# AND
		F_I_ROW.CC_REVENUE_ID IS NULL AND
		F_I_ROW.SELLER_CODE NOT IN 
		(
			SELECT SELLER_CODE FROM #dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
		) 
		<!---(
			 OR
			F_I_ROW.TERMINAL_NO NOT IN
			(
				SELECT POS_CODE FROM #dsn3_alias#.POS_EQUIPMENT_BANK POS_EQUIPMENT_BANK
			) 
		)--->
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)><!--- kayıt getirmesin diye --->
			AND FILE_IMPORT_BANK_POS_ROW_ID IS NULL
		</cfif>
		<cfif isDefined("attributes.is_process_cancel") and len(attributes.is_process_cancel)>
			AND F_I_ROW.IS_CANCEL = #attributes.is_process_cancel#
		</cfif>
	ORDER BY
		FILE_IMPORT_BANK_POS_ROW_ID
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#dsn3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID,
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID,
		</cfif>
		CPT.PAYMENT_TYPE_ID,
		CPT.CARD_NO
	FROM
		ACCOUNTS ACCOUNTS,
		CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		<cfif session.ep.period_year lt 2009>
			ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL' AND<!--- toplu pos işlemlerinde sadece ytl işlemler alınabiliyor sisteme --->
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#' AND
		</cfif>
		ACCOUNTS.ACCOUNT_ID = CPT.BANK_ACCOUNT AND
		CPT.IS_ACTIVE = 1 AND
		POS_TYPE IS NULL<!--- sanal pos ödeme yöntemleri gelmesin --->
	ORDER BY
		ACCOUNTS.ACCOUNT_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#GET_PROVISION_IMPORTS.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="head_">
			<cfif GET_PROVISION_IMPORTS.BANK_TYPE eq 10>Akbank
			<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 11>İşBankası
			<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 12>HSBC
			<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 13>Garanti
			<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 14>YapıKredi
			<cfelseif GET_PROVISION_IMPORTS.BANK_TYPE eq 15>Finansbank
			</cfif>
			<cf_get_lang no ='337.Banka Pos Satırları'>
</cfsavecontent>
<cf_medium_list_search title="#head_#">
	<cf_medium_list_search_area>
	<cfform name="search_form" method="post" action="#request.self#?fuseaction=bank.popup_list_bank_pos_rows&i_id=#attributes.i_id#">
		<table>
			<tr>
				<td><cf_get_lang no ='338.Valor Tarihi Farkı'></td>
				<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
				<td>
					<select name="is_process_cancel" id="is_process_cancel" style="width:110px;">
						<option value="0" <cfif attributes.is_process_cancel eq 0>selected</cfif>><cf_get_lang no ='339.İptal Olmayanlar'></option>
						<option value="1" <cfif attributes.is_process_cancel eq 1>selected</cfif>><cf_get_lang no ='340.İptal Olanlar'></option>
					</select>
				</td>
				<td>
				<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
				<cf_workcube_file_action pdf='1' mail='0' doc='1' print='1'>
			</tr>
		</table>
	</cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<cfform action="" name="add_" method="post">
		<thead>
		<tr>
			<!-- sil --><th width="15"><input type="checkbox" name="hepsi" id="hepsi" value="1" onClick="check_all(this.checked);" checked></th><!-- sil -->
			<th>No</th>
			<th><cf_get_lang_main no ='1094.İptal'></th>
			<th><cf_get_lang_main no='649.Cari'></th>
			<th><cf_get_lang no ='336.İşyeri Kodu'></th>
			<th><cf_get_lang no ='341.Cihaz Kodu'></th>
			<th><cf_get_lang no ='342.Cihaz Adı'></th>
			<th><cf_get_lang_main no ='467.İşlem Tarihi'></th>
			<th><cf_get_lang no ='334.Valor Tarihi'></th>
			<th><cf_get_lang_main no='388.İşlem Tipi'></th>
			<th><cf_get_lang no ='144.Taksit Sayısı'></th>
			<th><cf_get_lang_main no='1379.Komisyon'></th>
			<th><cf_get_lang no ='332.Ödül'></th>
			<th><cf_get_lang_main no='470.İşlem Tutarı'></th>
			<th><cf_get_lang no ='331.Cari Tutar'></th>
			<th><cf_get_lang no ='330.Net Tutar'></th>
		</tr>
		</thead>
		<tbody>
			<cfif GET_PROVISION_IMPORTS.recordcount>
				<cfset company_id_list = ''>
				<cfoutput query="GET_PROVISION_IMPORTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(COMPANY_ID) and COMPANY_ID neq 0 and not listfind(company_id_list,COMPANY_ID)>
						<cfset company_id_list = listappend(company_id_list,COMPANY_ID)>
					</cfif>
				</cfoutput>
				<cfif len(company_id_list)>
					<cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
					<cfquery name="get_company_detail" datasource="#dsn#">
						SELECT NICKNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
					</cfquery>
				</cfif>
				<cfoutput query="GET_PROVISION_IMPORTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<!-- sil --><td width="15"><cfif DEF_INFO eq 1 and len(COMPANY_ID)><input type="checkbox" name="checked_value" id="checked_value" value="#FILE_IMPORT_BANK_POS_ROW_ID#" checked></cfif></td><!-- sil -->
						<td>#currentrow#</td>
						<td align="center"><cfif IS_CANCEL eq 1>*</cfif></td>
						<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','medium');" class="tableyazi" <cfif DEF_INFO neq 1 or not len(COMPANY_ID)>style="color:red;"</cfif>><cfif listfind(company_id_list,COMPANY_ID,',')>#get_company_detail.NICKNAME[listfind(company_id_list,COMPANY_ID,',')]#</cfif></a></td>
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#SELLER_CODE#</font><cfelse>#SELLER_CODE#</cfif></td>
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#TERMINAL_NO#</font><cfelse>#TERMINAL_NO#</cfif></td>
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#EQUIPMENT#</font><cfelse>#EQUIPMENT#</cfif></td>					
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#dateformat(PROCESS_DATE,dateformat_style)#</font><cfelse>#dateformat(PROCESS_DATE,dateformat_style)#</cfif></td>
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#dateformat(VALOR_DATE,dateformat_style)#</font><cfelse>#dateformat(VALOR_DATE,dateformat_style)#</cfif></td>
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#POS_PROCESS_TYPE#</font><cfelse>#POS_PROCESS_TYPE#</cfif></td>
						<td><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#NUMBER_OF_INSTALMENT#</font><cfelse>#NUMBER_OF_INSTALMENT#</cfif></td>
						<td style="text-align:right;"><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#TLFormat(COMMISSION)#</font><cfelse>#TLFormat(COMMISSION)#</cfif></td>
						<td style="text-align:right;"><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#TLFormat(AWARD)#</font><cfelse>#TLFormat(AWARD)#</cfif></td>
						<td style="text-align:right;"><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#TLFormat(GROSS_TOTAL)#</font><cfelse>#TLFormat(GROSS_TOTAL)#</cfif></td>
						<td style="text-align:right;"><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#TLFormat(CARI_TUTAR)#</font><cfelse>#TLFormat(CARI_TUTAR)#</cfif></td>
						<td style="text-align:right;"><cfif DEF_INFO neq 1 or not len(COMPANY_ID)><font color="FF0000">#TLFormat(NET_TOTAL)#</font><cfelse>#TLFormat(NET_TOTAL)#</cfif></td>
					</tr>
				</cfoutput>
					<tr>
						<td colspan="17">
							<table>
							<tr>
								<td colspan="3"><cf_get_lang_main no ='467.İşlem Tarihi'>
									<cfsavecontent variable="message"><cf_get_lang_main no='1091.Lutfen Tarih Giriniz'></cfsavecontent>
									<cfinput validate="#validate_style#" required="Yes" message="#message#" type="text" name="action_date" style="width:80px;" value="#dateformat(now(),dateformat_style)#">
									<cf_wrk_date_image date_field="action_date">
								</td>
								<td colspan="3">
								<cfif attributes.is_process_cancel eq 0>
									<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
										SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 241
									</cfquery>
									<cf_get_lang_main no='388.İşlem Tipi'> <cf_workcube_process_cat slct_width="175" process_cat="#GET_PROCESS_CAT.PROCESS_CAT_ID#">
								<cfelseif attributes.is_process_cancel eq 1>
									<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
										SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE = 245
									</cfquery>
									<cf_get_lang_main no='388.İşlem Tipi'><cf_workcube_process_cat slct_width="175" process_cat="#GET_PROCESS_CAT.PROCESS_CAT_ID#">
								<cfelse>
									<cf_get_lang_main no='388.İşlem Tipi'> <cf_workcube_process_cat slct_width="175">
								</cfif>
								</td>
								<td colspan="6">
									<cf_get_lang no ='370.Hesap/Ödeme Yöntemi'>
									<select name="action_to_account_id" id="action_to_account_id" style="width:325px;">
										<option value=""><cf_get_lang no ='305.Hesap ve Ödeme Yöntemi Seçiniz'></option>
										<cfoutput query="GET_ACCOUNTS"><!---eleman sırası değişmesin AE--->
										<option value="#ACCOUNT_ID#;#ACCOUNT_CURRENCY_ID#;#PAYMENT_TYPE_ID#;#listgetat(session.ep.user_location,2,'-')#">#ACCOUNT_NAME# / #CARD_NO#</option>
										</cfoutput>
									</select>
								</td>	
								<td colspan="5" style="text-align:right;"><cf_workcube_buttons is_upd='0' is_cancel='0' add_function='add_cc_revenue()'></td>
							</tr>
							</table>
						</td>
					</tr>
			<cfelse>
				<tr>
					<td colspan="17"><cf_get_lang_main no ='72.Kayıt Yok'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cfform>
</cf_medium_list>
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
	<cfset url_string = 'bank.popup_list_bank_pos_rows&i_id=#attributes.i_id#'>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
	</cfif>
	<cfif isDefined('attributes.is_process_cancel') and len(attributes.is_process_cancel)>
		<cfset url_string = '#url_string#&is_process_cancel=#attributes.is_process_cancel#'>
	</cfif>
	<table width="99%" align="center">
		<tr>
			<td><cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="#url_string#">
			</td>
		  <!-- sil -->
		  <td style="text-align:right;"><cfoutput><cf_get_lang_main no ='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;Sayfa:#attributes.page#/#lastpage#</cfoutput></td>
		  <!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
function check_all(deger)
{
	if(document.search_form.hepsi.checked)
	{
		if(search_form.checked_value != undefined)
		{
			if (search_form.checked_value.length > 1)
				for(i=0; i<search_form.checked_value.length; i++) search_form.checked_value[i].checked = true;
			else
				search_form.checked_value.checked = true;
		}
	}
	else
	{
		if(search_form.checked_value != undefined)
		{
			if (search_form.checked_value.length > 1)
				for(i=0; i<search_form.checked_value.length; i++) search_form.checked_value[i].checked = false;
			else
				search_form.checked_value.checked = false;
		}
	}
}
function add_cc_revenue()
{
	if (!chk_process_cat('add_')) return false;
	if(!check_display_files('add_')) return false;
	x = document.add_.action_to_account_id.selectedIndex;
	if (document.add_.action_to_account_id[x].value == "")
	{ 
		alert ("<cf_get_lang_main no='615.Lutfen Odeme Yontemi Seciniz'>");
		return false;
	}
	windowopen('','small','cc_paym');
	add_.action='<cfoutput>#request.self#?fuseaction=bank.emptypopupflush_add_cc_rev_from_bankpos</cfoutput>';
	add_.target='cc_paym';
	add_.submit();
	return false;
}
</script>
