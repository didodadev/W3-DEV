<cfif not isdefined("attributes.cari_letter_id") or not len(attributes.cari_letter_id)>
	<cflocation url="index.cfm?fuseaction=finance.list_cari_letter" addtoken="no">
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.isch" default="">
<cfparam name="attributes.isba" default="">
<cfparam name="attributes.isbs" default="">
<cfquery name="GETMAIN" datasource="#dsn2#">
	SELECT * FROM CARI_LETTER WHERE CARI_LETTER_ID = #attributes.cari_letter_id#
</cfquery>

<cfquery name="GETROW" datasource="#dsn2#">
	SELECT  
		CARI_LETTER_ROW.CARI_LETTER_ID,
		CARI_LETTER_ROW.CARI_LETTER_ROW_ID,
		CARI_LETTER_ROW.UNIQUE_ID,
		CARI_LETTER_ROW.COMPANY_ID,
		CARI_LETTER_ROW.START_DATE,
		CARI_LETTER_ROW.FINISH_DATE,
		CARI_LETTER_ROW.CARI_STATUS,
		CARI_LETTER_ROW.IS_CH_AMOUNT,
		CARI_LETTER_ROW.IS_CR_AMOUNT,
		CARI_LETTER_ROW.IS_BA_TOTAL,
		CARI_LETTER_ROW.IS_BA_AMOUNT,
		CARI_LETTER_ROW.IS_BS_TOTAL,
		CARI_LETTER_ROW.IS_BS_AMOUNT,
		CARI_LETTER_ROW.CH_EMAIL,
		CARI_LETTER_ROW.AS_EMAIL,
		CARI_LETTER_ROW.RECORD_EMP,
		CARI_LETTER_ROW.RECORD_DATE,
		CARI_LETTER_ROW.RECORD_IP,
		CARI_LETTER_ROW.ACCOUNT_CODE,
		CARI_LETTER_ROW.ACCOUNT_AMOUNT,
		CARI_LETTER_ROW.IS_SEND,
		CARI_LETTER_ROW.IS_SEND_DATE,
		CARI_LETTER_ROW.IS_SEND_IP,
		CARI_LETTER_ROW.ACCEPT_USER,
		CARI_LETTER_ROW.ACCEPT_DATE,
		CARI_LETTER_ROW.ACCEPT_NAME,
		CARI_LETTER_ROW.ACCEPT_DETAIL,
		CARI_LETTER_ROW.ACCEPT_TOTAL,
		CARI_LETTER_ROW.ACCEPT_TYPE,
		CARI_LETTER_ROW.OTHER_MONEY,
		CARI_LETTER_ROW.ACCEPT_AMOUNT,
		CARI_LETTER_ROW.ACCEPT_STATUS,
		CARI_LETTER_ROW.AMOUNT_OTHER,
		COMPANY.COMPANY_ID,
		COMPANY.MEMBER_CODE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_EMAIL,
		SETUP_CITY.CITY_NAME,
		SETUP_COUNTY.COUNTY_NAME,
		SETUP_COMMETHOD.COMMETHOD
	FROM 
		CARI_LETTER_ROW
		INNER JOIN #dsn_alias#.COMPANY COMPANY ON CARI_LETTER_ROW.COMPANY_ID = COMPANY.COMPANY_ID 
		LEFT OUTER JOIN #dsn_alias#.SETUP_CITY ON SETUP_CITY.CITY_ID = COMPANY.CITY
		LEFT OUTER JOIN #dsn_alias#.SETUP_COUNTY ON SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY 
		LEFT OUTER JOIN #dsn_alias#.SETUP_COMMETHOD ON SETUP_COMMETHOD.COMMETHOD_ID = CARI_LETTER_ROW.ACCEPT_TYPE
	WHERE 
		CARI_LETTER_ROW.CARI_LETTER_ID = #attributes.cari_letter_id# 
		<cfif len(attributes.keyword)>AND COMPANY.FULLNAME LIKE '%#attributes.keyword#%'</cfif>
		<cfif len(attributes.isch)>
			<cfif attributes.isch eq 0>AND CARI_LETTER_ROW.IS_CH_AMOUNT IS NULL</cfif>
			<cfif attributes.isch eq 1>AND CARI_LETTER_ROW.IS_CH_AMOUNT = 1</cfif>
			<cfif attributes.isch eq 2>AND CARI_LETTER_ROW.IS_CH_AMOUNT = 2</cfif>
		</cfif>
		<cfif len(attributes.isba)>
			<cfif attributes.isba eq 0>AND CARI_LETTER_ROW.IS_BA_AMOUNT IS NULL</cfif>
			<cfif attributes.isba eq 1>AND CARI_LETTER_ROW.IS_BA_AMOUNT = 1</cfif>
			<cfif attributes.isba eq 2>AND CARI_LETTER_ROW.IS_BA_AMOUNT = 2</cfif>
		</cfif>
		<cfif len(attributes.isbs)>
			<cfif attributes.isbs eq 0>AND CARI_LETTER_ROW.IS_BS_AMOUNT IS NULL</cfif>
			<cfif attributes.isbs eq 1>AND CARI_LETTER_ROW.IS_BS_AMOUNT = 1</cfif>
			<cfif attributes.isbs eq 2>AND CARI_LETTER_ROW.IS_BS_AMOUNT = 2</cfif>
		</cfif>
				
	GROUP BY 
		CARI_LETTER_ROW.CARI_LETTER_ID,
		CARI_LETTER_ROW.CARI_LETTER_ROW_ID,
		CARI_LETTER_ROW.UNIQUE_ID,
		CARI_LETTER_ROW.COMPANY_ID,
		CARI_LETTER_ROW.START_DATE,
		CARI_LETTER_ROW.FINISH_DATE,
		CARI_LETTER_ROW.CARI_STATUS,
		CARI_LETTER_ROW.IS_CH_AMOUNT,
		CARI_LETTER_ROW.IS_CR_AMOUNT,
		CARI_LETTER_ROW.IS_BA_TOTAL,
		CARI_LETTER_ROW.IS_BA_AMOUNT,
		CARI_LETTER_ROW.IS_BS_TOTAL,
		CARI_LETTER_ROW.IS_BS_AMOUNT,
		CARI_LETTER_ROW.CH_EMAIL,
		CARI_LETTER_ROW.AS_EMAIL,
		CARI_LETTER_ROW.RECORD_EMP,
		CARI_LETTER_ROW.RECORD_DATE,
		CARI_LETTER_ROW.RECORD_IP,
		CARI_LETTER_ROW.ACCOUNT_CODE,
		CARI_LETTER_ROW.ACCOUNT_AMOUNT,
		CARI_LETTER_ROW.IS_SEND,
		CARI_LETTER_ROW.IS_SEND_DATE,
		CARI_LETTER_ROW.IS_SEND_IP,
		CARI_LETTER_ROW.ACCEPT_USER,
		CARI_LETTER_ROW.ACCEPT_DATE,
		CARI_LETTER_ROW.ACCEPT_NAME,
		CARI_LETTER_ROW.ACCEPT_DETAIL,
		CARI_LETTER_ROW.ACCEPT_TOTAL,
		CARI_LETTER_ROW.ACCEPT_TYPE,
		CARI_LETTER_ROW.OTHER_MONEY,
		CARI_LETTER_ROW.ACCEPT_AMOUNT,
		CARI_LETTER_ROW.ACCEPT_STATUS,
		CARI_LETTER_ROW.AMOUNT_OTHER,
		COMPANY.COMPANY_ID,
		COMPANY.MEMBER_CODE,
		COMPANY.FULLNAME,
		COMPANY.COMPANY_EMAIL,
		SETUP_CITY.CITY_NAME,
		SETUP_COUNTY.COUNTY_NAME,
		SETUP_COMMETHOD.COMMETHOD
	ORDER BY 
		COMPANY.FULLNAME
</cfquery>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default="#getrow.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>	
<cf_catalystHeader>
<div class="col col-12 col-xs-12">
	<cf_box>
		<cfform name="deleteform" method="post" action="">
			<cfoutput>
				<cf_box_elements>
					<div class="col col-12 col-xs-6">
						<div class="col col-4 col-xs-12">
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
							<label class="col col-6 col-xs-12">: #dateformat(getmain.start_date,'dd/mm/yyyy')#</label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='57460.Filtre'></label>
							<label class="col col-6 col-xs-12">: #getmain.keyword#</label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='59088.Tip'></label>
							<label class="col col-6 col-xs-12">: <cfif getmain.is_zero eq 0><cf_get_lang dictionary_id='64405.Sıfır Bakiyelileri Getirilmedi'></cfif><cfif getmain.is_zero eq 1><cf_get_lang dictionary_id='64406.Sıfır Bakiyelileri Getirildi'></cfif><cfif getmain.is_zero eq ""><cf_get_lang dictionary_id='64407.Hem Sıfır Bakiyeliler hem de Sıfır Bakiyeli Olmayanlar Getirildi'></cfif></label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='58924.Sıralama'></label>
							<label class="col col-6 col-xs-12">: <cfif getmain.search_order_id eq 0><cf_get_lang dictionary_id="33944.İsim A'dan Z'ye"></cfif><cfif getmain.search_order_id eq 1><cf_get_lang dictionary_id="33931.İsim Z'dan A'ye"></cfif></label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
							<label class="col col-6 col-xs-12">: <cfif getmain.is_ch eq 1><cf_get_lang dictionary_id='56646.Mutabakat'></cfif><cfif getmain.is_cr eq 1><cf_get_lang dictionary_id='33786.Cari Hatırlatma'></cfif><cfif getmain.is_ba eq 1><cf_get_lang dictionary_id='60230.BA'></cfif><cfif getmain.is_bS eq 1><cf_get_lang dictionary_id='33806.BS'></cfif></label>
						</div>
						<div class="col col-4 col-xs-12">
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<label class="col col-6 col-xs-12">: #dateformat(getmain.finish_date,'dd/mm/yyyy')#</label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='58924.Sıralama'></label>
							<label class="col col-6 col-xs-12">: <cfif getmain.search_type_id eq 0><cf_get_lang dictionary_id='33749.Alacaklılar'></cfif><cfif getmain.search_type_id eq 1><cf_get_lang dictionary_id='33957.Borçlular'></cfif><cfif getmain.search_type_id eq ""><cf_get_lang dictionary_id='58081.Hepsi'></cfif></label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='56646.Mutabakat'><cf_get_lang dictionary_id='30111.Durumu'></label>
							<label class="col col-6 col-xs-12">: <cfif getmain.is_action eq 0><cf_get_lang dictionary_id='33911.Son Mutabakattan Sonra Hareket Yoksa Getirme'></cfif><cfif getmain.is_action eq 1><cf_get_lang dictionary_id='33910.Son Mutabakattan Sonra Hareket Yoksa Getir'></cfif></label>
							<label class="col col-6 col-xs-12 bold"><cf_get_lang dictionary_id='64408.Mutabakat Aşaması'></label>
							<label class="col col-6 col-xs-12">: <cfif getmain.is_open eq 0><cf_get_lang dictionary_id='33909.Mutabakat Yapılabilecekler'></cfif><cfif getmain.is_open eq 1><cf_get_lang dictionary_id='33908.Mutabakat Yapılmayacaklar'></cfif><cfif getmain.is_open eq ""><cf_get_lang dictionary_id='58081.Hepsi'></cfif></label>
						</div>
					</div>
				
				</cf_box_elements>
			</cfoutput>
				<cf_box_footer>
					<cf_record_info query_name="getmain">
						<cf_workcube_buttons is_upd='0' insert_info='#getLang('','Sil',57463)#' insert_alert='#getLang('','Silmek İstediğinizden Emin Misiniz?',57533)#' add_function='delaccept()' class="ui-wrk-btn ui-wrk-btn-red">
				</cf_box_footer>
		</cfform>
	</cf_box>
	<cf_box>
		<cfform name="searchform" method="post" action="index.cfm?fuseaction=finance.list_cari_letter&event=upd&cari_letter_id=#attributes.cari_letter_id#">
			<cf_box_search plus="0">
				<div class="form-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="isch" id="isch">
						<option value=""><cf_get_lang dictionary_id='56646.Mutabakat'></option>
						<option value="0" <cfif attributes.isch eq 0>selected</cfif>><cf_get_lang dictionary_id='49900.Beklemede'></option>
						<option value="1" <cfif attributes.isch eq 1>selected</cfif>><cf_get_lang dictionary_id='64416.Onaylananlar'></option>
						<option value="2" <cfif attributes.isch eq 2>selected</cfif>><cf_get_lang dictionary_id='31208.Reddedilenler'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="isba" id="isba">
						<option value=""><cf_get_lang dictionary_id='60230.BA'></option>
						<option value="0" <cfif attributes.isba eq 0>selected</cfif>><cf_get_lang dictionary_id='49900.Beklemede'></option>
						<option value="1" <cfif attributes.isba eq 1>selected</cfif>><cf_get_lang dictionary_id='64416.Onaylananlar'></option>
						<option value="2" <cfif attributes.isba eq 2>selected</cfif>><cf_get_lang dictionary_id='31208.Reddedilenler'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="isbs" id="isbs">
						<option value=""><cf_get_lang dictionary_id='33806.BS'></option>
						<option value="0" <cfif attributes.isbs eq 0>selected</cfif>><cf_get_lang dictionary_id='49900.Beklemede'></option>
						<option value="1" <cfif attributes.isbs eq 1>selected</cfif>><cf_get_lang dictionary_id='64416.Onaylananlar'></option>
						<option value="2" <cfif attributes.isbs eq 2>selected</cfif>><cf_get_lang dictionary_id='31208.Reddedilenler'></option>
					</select>
				</div>
				<div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber(this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3">
                </div>
				<div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Cari Listesi',64417)#" uidrop="1" hide_table_column="1">
		<cfform method="post" name="sendaction" action="index.cfm?fuseaction=finance.add_cari_letter">
			<input type="hidden" name="cari_letter_id" value="<cfoutput>#attributes.cari_letter_id#</cfoutput>">
			<cf_grid_list>
				<thead>
					<tr>
						<th style="width:35px;"><cf_get_lang dictionary_id='55657.Sıra No'></th>
						<th align="center" nowrap="nowrap"><cf_get_lang dictionary_id='50167.Cari Kod'></th>
						<th align="center"><cf_get_lang dictionary_id='33907.Cari Adı'></th>
						<th align="center"><cf_get_lang dictionary_id='58608.İl'></th>
						<th align="center"><cf_get_lang dictionary_id='63898.İlçe'></th>
						<cfif getmain.is_ch eq 1>
							<th align="center"><cf_get_lang dictionary_id='34066.Mutabakat Email'></th>
							<th align="center"><cf_get_lang dictionary_id='57589.Bakiye'></th>
							<th align="center">D</th>
						</cfif>
						<cfif getmain.is_cr eq 1>
							<th align="center"><cf_get_lang dictionary_id='33786.Cari Hatırlatma'><cf_get_lang dictionary_id='39210.Email'></th>
							<th align="center"><cf_get_lang dictionary_id='57589.Bakiye'></th>
							<th align="center">D</th>
						</cfif>
						<cfif getmain.is_ba eq 1>	
							<th align="center"><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='39210.Email'></th>
							<th align="center"><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='57492.Toplam'></th>
							<th align="center"><cf_get_lang dictionary_id='60230.BA'><cf_get_lang dictionary_id='57673.Tutar'></th>
						</cfif>
						<cfif getmain.is_bs eq 1>	
							<th align="center"><cf_get_lang dictionary_id='33806.BS'><cf_get_lang dictionary_id='39210.Email'></th>
							<th align="center"><cf_get_lang dictionary_id='33806.BS'><cf_get_lang dictionary_id='57492.Toplam'></th>
							<th align="center"><cf_get_lang dictionary_id='33806.BS'><cf_get_lang dictionary_id='57673.Tutar'></th>
						</cfif>
						<th align="center"><cf_get_lang dictionary_id='58121.Islem Dövizi'><cf_get_lang dictionary_id='54452.Tutarı'></th>
						<th><cf_get_lang dictionary_id='30636.Para Birimi'></th>
						<th align="center"><cf_get_lang dictionary_id='33800.Gönderim Tarihi'></th>
						<th align="center"><cf_get_lang dictionary_id='57066.Gönderen'></th>
						<th align="center"><cf_get_lang dictionary_id='55839.Onay Tarihi'></th>
						<th align="center"><cf_get_lang dictionary_id='55260.Onaylayan'></th>
						
						<cfif getmain.is_ba eq 1 or getmain.is_bs eq 1>
							<th align="center"><cf_get_lang dictionary_id='46129.Onaylanan'><cf_get_lang dictionary_id='57468.Belge'><cf_get_lang dictionary_id='58659.Toplamı'></th>
						</cfif>
						<th align="center"><cf_get_lang dictionary_id='46129.Onaylanan'><cf_get_lang dictionary_id='57673.Tutar'></th>
						<th align="center"><cf_get_lang dictionary_id='46129.Onaylanan'><cf_get_lang dictionary_id='29831.Kişi'></th>
						<th align="center"><cf_get_lang dictionary_id='57629.Açıklama'></th>
						<th align="center"><cf_get_lang dictionary_id='57500.Onay'> <cf_get_lang dictionary_id='57065.Tipi'></th>
						<th align="center"><cf_get_lang dictionary_id='55804.Onay Durumu'></th>
						<!-- sil --><th></th><!-- sil -->
						<!-- sil --><th></th><!-- sil -->
						<!-- sil --><th></th><!-- sil -->
						<!-- sil --><th></th><!-- sil -->
						<!-- sil -->
						<th height="22" style="text-align:center" class="header_icn_none"><input type="checkbox" name="is_all" id="is_all" onclick="checkhepsi();" /></th>
						<!-- sil -->	
					</tr>
				</thead>
				<tbody>
					<cfif getrow.recordcount>
					<cfoutput query="getrow" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfquery name="GETMUTABAKAT" datasource="#dsn#">
							SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND MISSION = 2
						</cfquery>
						<cfquery name="GETFINANCE" datasource="#dsn#">
							SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND MISSION = 9999
						</cfquery>
						<cfquery name="GETBABS" datasource="#dsn#">
							SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE COMPANY_ID = #company_id# AND MISSION = 1
						</cfquery>
						<tr>
							<td>#currentrow#</td>
							<td><a href="index.cfm?fuseaction=member.detail_company&cpid=#company_id#" class="tableyazi" target="_blank">#member_code#</a></td>
							<td><a href="index.cfm?fuseaction=myhome.my_company_details&cpid=#company_id#" class="tableyazi" target="_blank">#fullname#</a></td>
							<td nowrap="nowrap">#city_name#</td>
							<td nowrap="nowrap">#county_name#</td>
							<input type="hidden" name="chemail#currentrow#" id="chemail#currentrow#" value="<cfif len(CH_EMAIL)>#CH_EMAIL#</cfif><!---<cfif len(getmutabakat.company_partner_email)>#getmutabakat.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>--->">
							<input type="hidden" name="asemail#currentrow#" id="asemail#currentrow#" value="<cfif len(AS_EMAIL)>#AS_EMAIL#</cfif><!---<cfif len(getbabs.company_partner_email)>#getbabs.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>--->">
							<cfif getmain.is_ch eq 1>
								<td align="center" nowrap>#CH_EMAIL#<!---<cfif len(getmutabakat.company_partner_email)>#getmutabakat.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>---></td>
								<td align="center" nowrap><input style="width:80px;" type="text" name="is_ch_amount#currentrow#" id="is_ch_amount#currentrow#" value="#tlformat(is_ch_amount)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</td>
								<td align="center" nowrap style="text-align:center "><cfif cari_status eq 1>B</cfif><cfif cari_status eq 0>A</cfif></td>
							</cfif>
							<cfif getmain.is_cr eq 1>
								<td align="center" nowrap>#CH_EMAIL#<!---<cfif len(getmutabakat.company_partner_email)>#getmutabakat.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>---></td>
								<td align="center" nowrap><input style="width:80px;" type="text" name="is_cr_amount#currentrow#" id="is_cr_amount#currentrow#" value="#tlformat(is_cr_amount)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</td>
								<td align="center" nowrap style="text-align:center "><cfif cari_status eq 1>B</cfif><cfif cari_status eq 0>A</cfif></td>
							</cfif>
							<cfif getmain.is_ba eq 1>	
								<td align="center" nowrap>#AS_EMAIL#<!---<cfif len(getbabs.company_partner_email)>#getbabs.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>---></td>
								<td align="center" nowrap><input style="width:40px;" type="text" name="is_ba_total#currentrow#" id="is_ba_total#currentrow#" value="#is_ba_total#" class="moneybox"></td>
								<td align="center" nowrap><input style="width:80px;" type="text" name="is_ba_amount#currentrow#" id="is_ba_amount#currentrow#" value="#tlformat(is_ba_amount)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</td>
							</cfif>
							<cfif getmain.is_bs eq 1>	
								<td align="center" nowrap>#AS_EMAIL#<!---<cfif len(getbabs.company_partner_email)>#getbabs.company_partner_email#<cfelseif len(getfinance.company_partner_email)>#getfinance.company_partner_email#<cfelse>#company_email#</cfif>---></td>
								<td align="center" nowrap><input style="width:40px;" type="text" name="is_bs_total#currentrow#" id="is_bs_total#currentrow#" value="#is_bs_total#" class="moneybox"></td>
								<td align="center" nowrap><input style="width:80px;" type="text" name="is_bs_amount#currentrow#" id="is_bs_amount#currentrow#" value="#tlformat(is_bs_amount)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> #session.ep.money#</td>
							</cfif>
							<td align="center" nowrap><input style="width:80px;" type="text" name="cariamount_sistem#currentrow#" id="cariamount_sistem#currentrow#" value="#tlformat(AMOUNT_OTHER)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"> </td>
							<td><input type="hidden" name="moneytype#currentrow#" id="moneytype#currentrow#" value="#OTHER_MONEY#"> #OTHER_MONEY#</td>
							<td align="center">
								<cfif len(is_send_date)>#dateformat(is_send_date,'dd/mm/yyyy')#</cfif>
							</td>
							<td align="center">
								<cfif len(is_send)>#get_emp_info(is_send,0,1)#</cfif>
							</td>
							<td align="center">
								<cfif len(accept_date)>#dateformat(accept_date,'dd/mm/yyyy')#</cfif>
							</td>
							<td align="center">
								<cfif accept_user eq -1>
									<cf_get_lang dictionary_id='57457.Müşteri'><cf_get_lang dictionary_id='30975.Onayladı'>
								<cfelse>
									<cfif len(accept_user)>#get_emp_info(accept_user,0,1)#</cfif>
								</cfif>
							</td>
							<cfif getmain.is_ba eq 1 or getmain.is_bs eq 1>
								<td align="center">#accept_total#</td>
							</cfif>
							<td align="center" style="text-align:right"><cfif len(accept_amount)>#tlformat(accept_amount)# #session.ep.money#</cfif></td>
							<td align="center"><cfif accept_status eq 1><font color="##009933">#accept_name#</font><cfelseif accept_status eq 0><font color="##990000">#accept_name#</font><cfelse>#accept_name#</cfif></td>
							<td align="center"><cfif accept_status eq 1><font color="##009933">#accept_detail#</font><cfelseif accept_status eq 0><font color="##990000">#accept_detail#</font><cfelse>#accept_detail#</cfif></td>
							<td align="center"><cfif accept_status eq 1><font color="##009933">#commethod#</font><cfelseif accept_status eq 0><font color="##990000">#commethod#</font><cfelse>#commethod#</cfif></td>
							<td align="center"><cfif accept_status eq 1><font color="##009933"><cf_get_lang dictionary_id='57500.Onay'></font><cfelseif accept_status eq 0><font color="##990000"><cf_get_lang dictionary_id='29537.Red'></font><cfelse></cfif></td>
							<!-- sil --><td nowrap="nowrap"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_comp_extre&member_type=partner&member_id=#company_id#','page');" class="tableyazi"><i class="fa fa-calculator" align="absmiddle" alt="<cf_get_lang dictionary_id='47101.Cari Extre'>" title="<cf_get_lang dictionary_id='47101.Cari Extre'>" border="0"></i></a></td><!-- sil -->
							<!-- sil --><td nowrap="nowrap"><a href="index.cfm?fuseaction=account.list_account_card_rows&acc_code1_1=#account_code#&acc_code2_1=#account_code#&form_is_submitted=1&date1=#dateformat(start_date,'dd/mm/yyyy')#&date2=#dateformat(finish_date,'dd/mm/yyyy')#" class="tableyazi" target="_blank"><i class="fa fa-table" title="<cf_get_lang dictionary_id='32124.Muhasebe Ekstresi'>" alt="<cf_get_lang dictionary_id='32124.Muhasebe Ekstresi'>" align="absmiddle" border="0"></i></a></td><!-- sil -->
							<!-- sil --><td nowrap="nowrap">
								<!---<cfif accept_status eq "">--->
								<ul class="ui-icon-list">
									<li><a  href="javascript://" onclick="windowopen('index.cfm?fuseaction=finance.popup_accept_cari_letter&company_id=#company_id#&cari_letter_row_id=#cari_letter_row_id#&cari_letter_id=#cari_letter_id#&acceptstatus=1','project')"><i class="fa fa-check-square" align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='58475.Onayla'>" title="<cf_get_lang dictionary_id='58475.Onayla'>" /></i></a></li>
									<li><a  href="javascript://" onclick="windowopen('index.cfm?fuseaction=finance.popup_accept_cari_letter&company_id=#company_id#&cari_letter_row_id=#cari_letter_row_id#&cari_letter_id=#cari_letter_id#&acceptstatus=0','project')"><i class="fa fa-times-rectangle" align="absmiddle" border="0" alt="<cf_get_lang dictionary_id='58461.Reddet'>" title="<cf_get_lang dictionary_id='58461.Reddet'>" /></i></a></li>
								</ul>
								<!---</cfif>--->
							</td><!-- sil -->
							<!-- sil --><td align="center" style="text-align:center"><a href="javascript://" onclick="windowopen('index.cfm?fuseaction=finance.popup_form_print_cari&money_type=#OTHER_MONEY#&company_id=#company_id#&start_date_=#dateformat(start_date,'dd/mm/yyyy')#&finish_date_=#dateformat(finish_date,'dd/mm/yyyy')#','project')"><i class="fa fa-print" align="absmiddle" title="<cf_get_lang dictionary_id='56646.Mutabakat'><cf_get_lang dictionary_id='57474.Yazdır'>" alt="<cf_get_lang dictionary_id='56646.Mutabakat'><cf_get_lang dictionary_id='57474.Yazdır'>" border="0" /></i></a></td><!-- sil -->
							<!-- sil --><td bgcolor="##FFFFFF" align="center" style="text-align:center">
								<input type="hidden" name="company_id_#currentrow#" id="company_id_#currentrow#" value="#company_id#">
								<input type="checkbox" name="company_id" id="company_id" value="#currentrow#" />
							</td><!-- sil -->
						</tr>
					</cfoutput>
					<tfoot>
						<tr>
							<td class="text-right" colspan="22" style="border-right:0px!important;">
								<cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol()'>
							</td>
							<td colspan="2" style="border-left:0px!important;">
								<cf_workcube_buttons is_upd='0' insert_info='#getLang('','E-mail Gönder',36339)#'  add_function='sendemailletter()' class="ui-wrk-btn ui-wrk-btn-extra" insert_alert='#getLang('','	E-maili göndermek istediğinize emin misiniz?',64434)#'>
							</td>
						</tr>
					</tfoot>
					<cfelse>
						<tr>
							<td colspan="28"><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</td>
						</tr>
					</cfif>
				</tbody>
				
			</cf_grid_list>
		</cfform>
		<cfset url_str = "">
		<cfset url_str = "#url_str#&cari_letter_id=#attributes.cari_letter_id#">
		<cfif len(attributes.isch)>
			<cfset url_str = "#url_str#&isch=#attributes.isch#">
		</cfif>
		<cfif len(attributes.isba)>
			<cfset url_str = "#url_str#&isba=#attributes.isba#">
		</cfif>
		<cfif len(attributes.isbs)>
			<cfset url_str = "#url_str#&isbs=#attributes.isbs#">
		</cfif>
		<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="finance.list_cari_letter&event=upd&#url_str#">
	</cf_box>
</div>
<script language="javascript">
function sendemailletter()
{
	document.sendaction.action = "index.cfm?fuseaction=finance.send_cari_letter_mail";
	document.sendaction.submit();
}
function delaccept()
{
	document.deleteform.action='index.cfm?fuseaction=finance.list_cari_letter&event=del&cari_letter_id=<cfoutput>#attributes.cari_letter_id#</cfoutput>';
	document.deleteform.submit();
}
<cfif isdefined("getrow")>
function checkhepsi()
{
	if(document.sendaction.is_all.checked==true)
	{
		<cfoutput query="getrow">
			document.sendaction.company_id[#currentrow-1#].checked=true;
		</cfoutput> 
	}
	else 
	{
		<cfoutput query="getrow">
			document.sendaction.company_id[#currentrow-1#].checked=false;
		</cfoutput> 
	}
}
</cfif>
function kontrol()
{

}
</script>