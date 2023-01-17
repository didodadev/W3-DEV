<cfsetting showdebugoutput="no">
<!--- Sanal Poslar --->
<cfquery name="getSanalPos" datasource="#DSN#">
	SELECT DISTINCT
		CPT.NUMBER_OF_INSTALMENT,
		CPT.FIRST_INTEREST_RATE,
		POS_REL.POS_ID,
		POS_REL.POS_NAME
	FROM 
		OUR_COMPANY_POS_RELATION AS POS_REL,
		#dsn3_alias#.CREDITCARD_PAYMENT_TYPE CPT
	WHERE
		CPT.POS_TYPE = POS_REL.POS_ID AND
		POS_REL.IS_ACTIVE = 1 AND
		ISNULL(CPT.IS_SPECIAL,0) <> 1 AND
		CPT.IS_ACTIVE = 1 AND
        <cfif get_ins_products.recordcount>
        	CPT.NUMBER_OF_INSTALMENT = 0 AND
        </cfif>
		<cfif isdefined("session.ww.userid")>
			CPT.IS_PUBLIC = 1 AND
		<cfelse>
			CPT.IS_PARTNER = 1 AND
		</cfif>
		CPT.POS_TYPE IS NOT NULL
		<!--- Odeme Yonteminde tanimlanan public minimum tutar kontrolu yapiliyor GA 05032013--->
        <cfif isDefined('attributes.grosstotal') and len(attributes.grosstotal)>
	    	AND ISNULL(CPT.PUBLIC_MIN_AMOUNT,0) <= #attributes.grosstotal#
		</cfif>
	ORDER BY
		POS_REL.POS_NAME
</cfquery>
<!--- parapuan --->
<cfquery name="GET_MONEY_CREDITS" datasource="#DSN3#">
	SELECT
		ISNULL(SUM(MONEY_CREDIT-ISNULL(USE_CREDIT,0)),0) AS TOTAL_MONEY_CREDIT
	FROM
		ORDER_MONEY_CREDITS
	WHERE
		MONEY_CREDIT_STATUS = 1 AND
		ISNULL(IS_TYPE,0) = 0 AND
		VALID_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
		<cfif isdefined('session.pp.userid')>
			AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		<cfelseif isDefined('session.ww.userid')>
			AND CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
</cfquery>
<cfif not isdefined("attributes.is_detail_address")>
	<cfset attributes.is_detail_address = 0>
</cfif>
<cfif not isdefined("attributes.is_residence_select")>
	<cfset attributes.is_residence_select = 0>
</cfif>
<cfif attributes.is_detail_address eq 0>
	<cfset attributes.is_residence_select = 0>
</cfif>
<!--- uyenin tanimli kredi kartlari --->
<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfquery name="GET_CREDIT_CARDS" datasource="#DSN#">
		SELECT
			CC.CONSUMER_CC_ID,
            CC.CONSUMER_ID,
            CC.CONSUMER_CC_NUMBER,
			SC.CARDCAT
		FROM
			CONSUMER_CC CC,
			SETUP_CREDITCARD SC
		WHERE
			CC.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#"> AND
			CC.CONSUMER_CC_TYPE = SC.CARDCAT_ID
		ORDER BY
			(CC.ACC_OFF_DAY-DAY(GETDATE()))
	</cfquery>
<cfelseif isdefined("attributes.company_id")>
	<cfquery name="GET_CREDIT_CARDS" datasource="#DSN#">
		SELECT
			CC.COMPANY_CC_ID,
            CC.COMPANY_ID,
            CC.COMPANY_CC_NUMBER,
			SC.CARDCAT
		FROM
			COMPANY_CC CC,
			SETUP_CREDITCARD SC
		WHERE
			CC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			CC.COMPANY_CC_TYPE = SC.CARDCAT_ID AND
			IS_DEFAULT = 1
		ORDER BY
			(CC.ACC_OFF_DAY-DAY(GETDATE()))
	</cfquery>
</cfif>
<!--- uye blok kontrolu --->
<cfif isdefined("session.ww.userid")>
	<cfquery name="GET_BLOCK_INFO" datasource="#DSN#">
		SELECT 
			BG.BLOCK_GROUP_PERMISSIONS  AS BLOCK_STATUS
		FROM 
			COMPANY_BLOCK_REQUEST CBL,
			BLOCK_GROUP BG 
		WHERE 
			CBL.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
			CBL.BLOCK_GROUP_ID = BG.BLOCK_GROUP_ID AND
			CBL.BLOCK_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			ISNULL(CBL.BLOCK_FINISH_DATE,GETDATE()) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
	</cfquery>
<cfelse>
	<cfset get_block_info.recordcount = 0>
</cfif>
<cfif isdefined("attributes.is_save_adresss") and attributes.is_save_adresss eq 1>
	<input type="hidden" name="is_save_adresss" id="is_save_adresss" value="1">
</cfif>
<cfif isdefined("session.pp.userid") and not isdefined("attributes.partner_id")>
	<cfset attributes.partner_id = session.pp.userid>
</cfif>
<cfif isdefined('attributes.is_default_risc_info') and attributes.is_default_risc_info eq 1>
	<cfquery name="GET_CREDIT_LIMIT" datasource="#DSN#">
		SELECT
			SHIP_METHOD_ID,
			REVMETHOD_ID
		FROM
			COMPANY_CREDIT
		WHERE
			<cfif isdefined('session.pp.userid')>
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
			<cfelseif isdefined('session.ww.userid')>
				OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">			
			</cfif>
	</cfquery>
	<cfset attributes.default_ship_method_id = get_credit_limit.ship_method_id>
	<cfset attributes.default_pay_method_id = get_credit_limit.revmethod_id>
</cfif>
<cfoutput><!--- actionda kullanıldıgı için inputlara set edildi --->
	<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#</cfif>">
	<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id") and len(attributes.partner_id)>#attributes.partner_id#</cfif>">
	<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
</cfoutput>
<!--- FA 20101209 Taksitli Kredi Kartı Kontrol icin eklendi.  --->
<input type="hidden" name="accountRecordcount" id="accountRecordcount" value="<cfoutput>#get_accounts.recordcount#</cfoutput>">
<input type="hidden" name="account_recordcount" id="account_recordcount" value="">
<br/>			
<!--- proje baglantilari --->
<cfif isdefined('attributes.is_attachment') and (attributes.is_attachment eq 1 or attributes.is_attachment eq 2) and isdefined('session.pp.userid')>
	<cfquery name="GET_PROJECT_ATTACHMENT" datasource="#DSN#">
    	SELECT 
        	P.PROJECT_ID,
            P.PROJECT_HEAD
        FROM 
        	PRO_PROJECTS P,
            #dsn3#.PROJECT_DISCOUNTS PD
       	WHERE 
			PD.PROJECT_ID = P.PROJECT_ID AND
			PD.FINISH_DATE >= #now()# AND
			<cfif isdefined('attributes.is_pro_process_cat') and len(attributes.is_pro_process_cat)>
				P.PROCESS_CAT IN (#attributes.is_pro_process_cat#) AND
			</cfif>
			P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			P.PROJECT_STATUS = 1
    </cfquery>
    <table border="0" cellpadding="2" cellspacing="1" align="center" id="project_attach_" style="width:98%">
    	<tr>
        	<td><cf_get_lang no ='1636.Bağlantılar'>
				<select name="project_attachment" id="project_attachment" onchange="if (this.options[this.selectedIndex].value != 'null') check_project_discount(this.options[this.selectedIndex].value);" <cfif attributes.is_attachment eq 2>disabled</cfif>>
					<option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
					<cfoutput query="get_project_attachment">
						<option value="#project_id#" <cfif isDefined('attributes.default_project_attachment') and attributes.default_project_attachment eq project_id>selected</cfif>>#project_head#</option>
					</cfoutput>
				</select>
        	</td>
      	</tr>
    </table>
</cfif>
<!--- gonderi kismi --->
<table border="0" cellpadding="2" cellspacing="1" class="color-header" align="center" id="teslimat_info" style="width:98%; height:100%">
	<tr class="color-list" style="height:25px;">
		<td class="formbold"><cf_get_lang no ='1637.Teslimat Bilgileri'><cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>(<cfoutput>#get_cons_info(attributes.consumer_id,0,0)#</cfoutput>)</cfif></td>
  	</tr>
  	<tr>
		<td class="color-row">
			<table cellpadding="2" cellspacing="2" style="width:100%; height:100%;" border="0">
			  	<tr>
					<input type="hidden" name="is_new_tax_address" id="is_new_tax_address" value="<cfif isdefined('attributes.is_new_tax_address')><cfoutput>#attributes.is_new_tax_address#</cfoutput></cfif>">
					<input type="hidden" name="is_new_ship_address" id="is_new_ship_address" value="<cfif isdefined('attributes.is_new_ship_address')><cfoutput>#attributes.is_new_ship_address#</cfoutput></cfif>">
			  		<cfif isdefined('attributes.is_tax_address') and (attributes.is_tax_address eq 1 or attributes.is_tax_address eq 2)>
						<td style="vertical-align:top; width:45%;">
							<table border="0">
								<cfif get_tax_address.recordcount>
									<cfoutput query="get_tax_address">
										<cfif len(city)>
											<cfquery name="TAX_GET_CITY" datasource="#DSN#">
												SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_tax_address.city#">
											</cfquery>
										</cfif>
										<cfif len(country)>
											<cfquery name="TAX_GET_COUNTRY" datasource="#DSN#">
												SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_tax_address.country#">
											</cfquery>
										</cfif>
										<cfif len(county)>
											<cfquery name="TAX_GET_COUNTY" datasource="#DSN#">
												SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_tax_address.county#">
											</cfquery>
										</cfif>
						 				<tr>
											<td>
                                            	<cfif isdefined('attributes.is_tax_address') and attributes.is_tax_address eq 2 and (get_address.recordcount or (isDefined('attributes.is_new_tax_address') and attributes.is_new_tax_address eq 1)) and isDefined('attributes.is_address_keyword') and attributes.is_address_keyword eq 0>
													<input type="radio" name="tax_address_row" id="tax_address_row" class="radio_frame" value="-1" onclick="yeni_fatura_adres(this);" checked="checked">
												<cfelse>
													<input type="hidden" name="tax_address_row" id="tax_address_row" value="-1">  
												</cfif>
												<input type="hidden" name="tax_address_id-1" id="tax_address_id-1" value="">
												<input type="hidden" name="tax_address-1" id="tax_address-1" value="#address# #postcode# #semt# <cfif len(county)>#tax_get_county.county_name# / </cfif><cfif len(city)>#tax_get_city.city_name#</cfif> <cfif len(country)>#tax_get_country.country_name#</cfif>">
												<input type="hidden" name="tax_address_city-1" id="tax_address_city-1" value="<cfif len(city)>#tax_get_city.city_id#</cfif>">
												<input type="hidden" name="tax_address_county-1" id="tax_address_county-1" value="<cfif len(county)>#tax_get_county.county_id#</cfif>">
												<input type="hidden" name="tax_address_branch_name-1" id="tax_address_branch_name-1" value="Fatura">
												<input type="hidden" name="tax_address_nick_name-1" id="tax_address_nick_name-1" value="">
												<input type="hidden" name="tax_address_country-1" id="tax_address_country-1" value="<cfif len(country)>#tax_get_country.country_id#</cfif>">
												<b> (Fatura)</b>
												#address# #postcode# #semt#  <cfif len(county)>#tax_get_county.county_name# / </cfif><cfif len(city)>#tax_get_city.city_name#</cfif> <cfif len(country)>#tax_get_country.country_name# </cfif>
												<cfif (isdefined("attributes.is_change_inv_address") and attributes.is_change_inv_address eq 1) or not isdefined("attributes.is_change_inv_address")>
													<cfif isdefined("session.ww.userid") and session.ww.userid eq attributes.consumer_id>
														(<a href="#request.self#?fuseaction=objects2.me&orderww_back=1<cfif isDefined('attributes.grosstotal')>&grosstotal=#attributes.grosstotal#</cfif>" class="tableyazi"><cf_get_lang no ='1330.Değiştir'></a>)
													<cfelseif isdefined("session.pp.userid") and session.pp.userid eq attributes.partner_id>
														(<a href="#request.self#?fuseaction=objects2.form_upd_my_company&orderww_back=1<cfif isDefined('attributes.grosstotal')>&grosstotal=#attributes.grosstotal#</cfif>" class="tableyazi"><cf_get_lang no ='1330.Değiştir'></a>) 
													</cfif>
												</cfif>
											</td>
									  	</tr>
									</cfoutput>
								</cfif>
								<cfset adres_var_ = 0>
								<cfif isdefined('attributes.is_tax_address') and attributes.is_tax_address eq 2>
									<cfif isDefined('attributes.is_address_keyword') and attributes.is_address_keyword eq 0>
										<cfoutput query="get_address">
											<tr>
												<td>
													<cfif len(address_detail)>
														<cfif len(main_street)>
															<cfset main_street_ = '#main_street# Cad.'>
														<cfelse>
															<cfset main_street_ =''>
														</cfif>
														<cfif len(street)>
															<cfset street_ = '#street# Sok.'>
														<cfelse>
															<cfset street_ =''>
														</cfif>
														<cfset address_ = '#main_street_# #street_# #address_detail#'>
													<cfelse>
														<cfset address_ = address>
													</cfif>
													<cfif len(trim(address_))>
														<cfif len(district)>
															<cfquery name="GET_DISTRICT" datasource="#DSN#">
																SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#district#">
															</cfquery>
															<cfset home_dis = '#get_district.district_name# '>
														<cfelse>
															<cfset home_dis = ''>
														</cfif>
														<cfset adres_var_ = 1>
														<cfif isdefined('session.pp')>
															<cfquery name="GET_PARTNER_BRANCH" datasource="#DSN#">
																SELECT COMPBRANCH_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
															</cfquery>
															<input type="radio" name="tax_address_row" id="tax_address_row" class="radio_frame" value="#currentrow#" onclick="yeni_fatura_adres(this);" <cfif get_partner_branch.compbranch_id eq get_address.compbranch_id> checked<cfelseif currentrow eq 1>checked</cfif>>
														<cfelse>
															<input type="radio" name="tax_address_row" id="tax_address_row" class="radio_frame" value="#currentrow#" onclick="yeni_fatura_adres(this);" <!---<cfif currentrow eq 1>checked</cfif>--->>
														</cfif>
														<input type="hidden" name="tax_address_id#currentrow#" id="tax_address_id#currentrow#" value="#address_id#">
														<input type="hidden" name="tax_address#currentrow#" id="tax_address#currentrow#" value="<cfif len(home_dis)>#home_dis# </cfif>#address_# #postcode# #semt# <cfif len(county)>#listgetat(county_name_list,listfind(county_list_id,county,','),',')# / </cfif><cfif len(city)>#listgetat(city_name_list,listfind(city_list_id,city,','),',')#</cfif> <cfif len(country)>#listgetat(country_name_list,listfind(country_list_id,country,','),',')#</cfif>">
														<input type="hidden" name="tax_address_city#currentrow#" id="tax_address_city#currentrow#" value="#city#">
														<input type="hidden" name="tax_address_county#currentrow#" id="tax_address_county#currentrow#" value="#county#">
														<input type="hidden" name="tax_address_branch_name#currentrow#" id="tax_address_branch_name#currentrow#" value="#adress_name#">
														<input type="hidden" name="tax_address_nick_name#currentrow#" id="tax_address_nick_name#currentrow#" value="<cfif isdefined('session.pp.userid')>#compbranch_nickname#</cfif>">
														<input type="hidden" name="tax_address_country#currentrow#" id="tax_address_country#currentrow#" value="#country#">
														<cfif len(adress_name)><b>(#adress_name#)&nbsp;&nbsp;&nbsp;</b></cfif><cfif len(home_dis)>#home_dis# </cfif>#address_# #postcode# #semt# <cfif len(county)>#listgetat(county_name_list,listfind(county_list_id,county,','),',')# / </cfif><cfif len(city)>#listgetat(city_name_list,listfind(city_list_id,city,','),',')#</cfif> <cfif len(country)>#listgetat(country_name_list,listfind(country_list_id,country,','),',')#</cfif><br />
													</cfif>
												</td>
											</tr>
										</cfoutput>
									<cfelse>
										<tr>
											<td>
												<cf_get_lang no='18.Adres Ara'> :
												<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
													<cfset _id_ = attributes.company_id>
													<cfset _type_ = 'partner'>
												<cfelse>
													<cfset _id_ = attributes.consumer_id>
													<cfset _type_ = 'consumer'>
												</cfif>
												 <input type="text" name="address_keyword" id="address_keyword" value="" style="width:120px;" />
												 <input type="button" name="addres_ara" id="addres_ara" onclick="address_sonuc(<cfoutput>#_id_#,'#_type_#'</cfoutput>);" value="Ara" /> <br />
												 <cfif get_address.recordcount>
													<cfset adres_var_ = 1>
												 </cfif>
												 <div id="show_address_page"></div>
											</td>
										</tr>
									</cfif>
									<tr>
										<td>
											<cfif isdefined('attributes.is_new_tax_address') and attributes.is_new_tax_address eq 1>
												<!---<cfif adres_var_ eq 1>--->
													<input type="radio" name="tax_address_row" id="tax_address_row" class="radio_frame" value="0" onclick="yeni_fatura_adres(this);"  <cfif not get_address.recordcount>checked</cfif>>
													<font class="txtbold">Yeni bir adrese fatura adresi tanımlamak için seçiniz...</font>
												<!---<cfelse>
													<input type="hidden" name="tax_address_row" id="tax_address_row" value="0">
												</cfif>--->
											</cfif>
										</td>
									</tr>
								</cfif>
							</table>
						</td>
					</cfif>
					<td style="vertical-align:top;">
                    	<cfif isdefined('attributes.is_ship_address') and attributes.is_ship_address eq 1>
                            <table cellpadding="2" cellspacing="2">
                                <cfif (isdefined('attributes.is_tax_address') and (attributes.is_tax_address eq 1 or attributes.is_tax_address eq 2)) and (isdefined('attributes.xml_is_same_tax_ship') and attributes.xml_is_same_tax_ship eq 1)>
                                    <tr style="height:25px;"><!--- gizle_goster(shipaddress0); --->
                                        <td><input type="checkbox" name="is_same_tax_ship" id="is_same_tax_ship" onclick="div_gizle_goster();"/>&nbsp;Teslimat Adresim Fatura Adresimle Aynı Olsun</td>
                                    </tr>
                                </cfif>
                                <tr id="del_date1" style="display:;">
                                    <td><cf_get_lang no='1007.Lütfen Teslim Adresinizi Tanımlayınız'>...</td>
                                </tr>
                                <tr id="del_date2" style="display:;">
                                    <td style="vertical-align:top;">
                                        <cfset adres_var_ = 0>
                                        <cfif isDefined('attributes.is_address_keyword') and attributes.is_address_keyword eq 0>
                                            <cfoutput query="get_address">
                                                <cfif len(address_detail)>
                                                    <cfif len(main_street)>
                                                        <cfset main_street_ = '#main_street# Cad.'>
                                                    <cfelse>
                                                        <cfset main_street_ =''>
                                                    </cfif>
                                                    <cfif len(street)>
                                                        <cfset street_ = '#street# Sok.'>
                                                    <cfelse>
                                                        <cfset street_ =''>
                                                    </cfif>
                                                    <cfset address_ = '#main_street_# #street_# #address_detail#'>
                                                <cfelse>
                                                    <cfset address_ = address>
                                                </cfif>
                                                <cfif len(trim(address_))>
                                                    <cfif len(district)>
                                                        <cfquery name="GET_DISTRICT" datasource="#DSN#">
                                                            SELECT DISTRICT_NAME FROM SETUP_DISTRICT WHERE DISTRICT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#district#">
                                                        </cfquery>
                                                        <cfset home_dis = '#get_district.district_name# '>
                                                    <cfelse>
                                                        <cfset home_dis = ''>
                                                    </cfif>
                                                    <cfset adres_var_ = 1>
                                                    <cfif isdefined('session.pp')>
                                                        <cfquery name="GET_PARTNER_BRANCH" datasource="#DSN#">
                                                            SELECT COMPBRANCH_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
                                                        </cfquery>
                                                        <input type="radio" name="ship_address_row" id="ship_address_row" class="radio_frame" value="#currentrow#" onclick="yeni_adres(this);" <cfif get_partner_branch.compbranch_id eq get_address.compbranch_id> checked<cfelseif currentrow eq 1>checked</cfif>>
                                                    <cfelse>
                                                        <input type="radio" name="ship_address_row" id="ship_address_row" class="radio_frame" value="#currentrow#" onclick="yeni_adres(this);" <cfif currentrow eq 1>checked</cfif>>
                                                    </cfif>
                                                    <input type="hidden" name="ship_address_id#currentrow#" id="ship_address_id#currentrow#" value="#address_id#">
                                                    <input type="hidden" name="ship_address#currentrow#" id="ship_address#currentrow#" value="<cfif len(home_dis)>#home_dis# </cfif>#address_# #postcode# #semt# <cfif len(county)>#listgetat(county_name_list,listfind(county_list_id,county,','),',')# / </cfif><cfif len(city)>#listgetat(city_name_list,listfind(city_list_id,city,','),',')#</cfif> <cfif len(country)>#listgetat(country_name_list,listfind(country_list_id,country,','),',')#</cfif>">
                                                    <input type="hidden" name="ship_address_city#currentrow#" id="ship_address_city#currentrow#" value="#city#">
                                                    <input type="hidden" name="ship_address_county#currentrow#" id="ship_address_county#currentrow#" value="#county#">
                                                    <input type="hidden" name="ship_address_branch_name#currentrow#" id="ship_address_branch_name#currentrow#" value="#adress_name#">
                                                    <input type="hidden" name="ship_address_nick_name#currentrow#" id="ship_address_nick_name#currentrow#" value="<cfif isdefined('session.pp.userid')>#compbranch_nickname#</cfif>">
                                                    <input type="hidden" name="ship_address_country#currentrow#" id="ship_address_country#currentrow#" value="#country#">
                                                    <cfif len(adress_name)><b>(#adress_name#)&nbsp;&nbsp;&nbsp;</b></cfif><cfif len(home_dis)>#home_dis# </cfif>#address_# #postcode# #semt# <cfif len(county)>#listgetat(county_name_list,listfind(county_list_id,county,','),',')# / </cfif><cfif len(city)>#listgetat(city_name_list,listfind(city_list_id,city,','),',')#</cfif> <cfif len(country)>#listgetat(country_name_list,listfind(country_list_id,country,','),',')#</cfif><br />
                                                </cfif>
                                            </cfoutput>
                                        <cfelse>
                                            <cf_get_lang no='18.Adres Ara'> :
                                            <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
                                                <cfset _id_ = attributes.company_id>
                                                <cfset _type_ = 'partner'>
                                            <cfelse>
                                                <cfset _id_ = attributes.consumer_id>
                                                <cfset _type_ = 'consumer'>
                                            </cfif>
                                             <input type="text" name="address_keyword" id="address_keyword" value="" style="width:120px;" />
                                             <input type="button" name="addres_ara" id="addres_ara" onclick="address_sonuc(<cfoutput>#_id_#,'#_type_#'</cfoutput>);" value="<cf_get_lang_main no='153.Ara'>" /> <br />
                                             <cfif get_address.recordcount>
                                                <cfset adres_var_ = 1>
                                             </cfif>
                                             <div id="show_address_page"></div>
                                        </cfif>
                                        <cfif isdefined('attributes.is_new_ship_address') and attributes.is_new_ship_address eq 1>
                                            <cfif adres_var_ eq 1>
                                                <input type="radio" name="ship_address_row" id="ship_address_row" class="radio_frame" value="0" onclick="yeni_adres(this);">
                                                <b class="txtbold"><cf_get_lang no='1008.Yeni bir adrese teslimat yapmak istiyorsanız seçiniz'>...</b>
                                            <cfelse>
                                                <input type="hidden" name="ship_address_row" id="ship_address_row" value="0">
                                            </cfif>
                                        </cfif>
                                    </td>
                                </tr>
                            </table>
                        </cfif>
					</td>
				</tr>
                <tr>
                    <cfif isdefined('attributes.is_tax_address') and (attributes.is_tax_address eq 1 or attributes.is_tax_address eq 2)>
                        <td style="vertical-align:top;">
                        	<cfif isdefined('attributes.is_tax_address') and attributes.is_tax_address eq 2>
                            	<cfif isdefined('attributes.is_new_tax_address') and attributes.is_new_tax_address eq 1>
                                    <table id="taxaddress0" <cfif adres_var_ eq 1>style="display:none;"</cfif> border="0">
                                        <input type="hidden" name="ship_address_branch_name0" id="ship_address_branch_name0" value="<cf_get_lang_main no='744.Diğer'> <cf_get_lang_main no='1311.Adres'>">
                                        <tr>
                                            <td colspan="2"><font color="red" style="font-weight:bold;"><cf_get_lang no='542.Siparişinizin en kısa sürede teslim edilebilmesi için aşağıdaki alanları eksiksiz doldurunuz'>!</font><br><br></td>
                                        </tr>
                            
                                        <tr>
                                            <td><cf_get_lang_main no='807.Ülke'></td>
                                            <td>
                                                <select name="tax_address_country0" id="tax_address_country0" style="width:150px;" onchange="LoadCity(this.value,'tax_address_city0','tax_address_county0',''<cfif attributes.is_residence_select eq 1>,'tax_district_id0'</cfif>)">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                    <cfoutput query="get_country_all">
                                                        <option value="#country_id#" <!---<cfif country_id eq 1> selected</cfif>--->>#country_name#</option>
                                                    </cfoutput>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no='559.İl'> *</td>
                                            <td>
                                                <select name="tax_address_city0" id="tax_address_city0" style="width:150px;" onchange="LoadCounty(this.value,'tax_address_county0',''<cfif attributes.is_residence_select eq 1>,'tax_district_id0'</cfif>)">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr> 
                                            <td nowrap="nowrap"><cf_get_lang_main no='1226.İlçe'> *</td>
                                            <td>
                                                <select name="tax_address_county0" id="tax_address_county0" style="width:150px;" <cfif attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'tax_district_id0');"</cfif>>
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no='720.Semt'></td>
                                            <td><input type="text" name="tax_address_semt0" id="tax_address_semt0" value="" maxlength="50" style="width:150px;"></td>
                                        </tr>
                                        <tr>
                                            <td><cf_get_lang_main no='60.Posta Kodu'></td>
                                            <td><input type="text" name="tax_address_postcode0" id="tax_address_postcode0" value="" style="width:150px;" maxlength="5"></td>
                                        </tr>
                                        <cfif attributes.is_detail_address eq 1>
                                            <tr>
                                                <td><cf_get_lang_main no='1323.Mahalle'></td>
                                                <td>
                                                    <cfif attributes.is_residence_select eq 0>
                                                        <input type="text" name="tax_district0" id="tax_district0" style="width:150px;" value="">
                                                    <cfelse>
                                                        <select name="tax_district_id0" id="tax_district_id0" style="width:150px;">
                                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                        </select>
                                                    </cfif>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no ='1335.Cadde'></td>
                                                <td><input type="text" name="tax_main_street0" id="tax_main_street0" maxlength="50" style="width:150px;"/></td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no ='1334.Sokak'></td>
                                                <td><input type="text" name="tax_street0" id="tax_street0" maxlength="50" style="width:150px;"/></td>
                                            </tr>
                                            <tr>
                                                <td valign="top"><cf_get_lang no ='1628.Adres Detay'></td>
                                                <td><textarea name="tax_work_doorno0" id="tax_work_doorno0" style="width:150px;" maxlength="200"></textarea></td>
                                            </tr>
                                        <cfelse>
                                            <tr> 
                                                <td valign="top"><cf_get_lang_main no='1311.Adres'> *</td>
                                                <td><textarea name="tax_address0" id="tax_address0" style="width:200px;height:50px;"></textarea></td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td colspan="2"><input type="checkbox" name="is_company0" id="is_company0" value="1" onclick="dis_buttons();"> <cf_get_lang no='960.Kurumsal'></td>
                                        </tr>
                                        <tr id="comp_info" style="display:none;">
                                            <td colspan="2">
                                                <table width="100%">											
                                                    <tr>
                                                        <td><cf_get_lang_main no='1073.Şirket Adı'></td>
                                                        <td>
                                                            <cfinput type="text" name="company_name0"  id="company_name0" style="width:150px;" maxlength="200"/></td>
                                                    </tr>
                                                    <tr>
                                                        <td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
                                                        <td>
                                                            <cfsavecontent variable="alert"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1350.Vergi Dairesi'></cfsavecontent>
                                                            <cfinput type="text" name="tax_office0" id="tax_office0" maxlength="50" style="width:150px;" tabindex="8" message="#alert#">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td><cf_get_lang_main no='340.Vergi No'> </td>
                                                        <td><cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='340.Vergi No!'>*</cfsavecontent>
                                                            <cfinput type="text" name="tax_no0" id="tax_no0" validate="integer" message="#message#" tabindex="8" maxlength="11" onKeyUp="isNumber(this);" style="width:150px;" value=""> 
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </cfif>
                            </cfif>
						</td>
                    </cfif>
					<td style="vertical-align:top;">
						<table id="shipaddress0" cellpadding="2" cellspacing="2" <cfif isDefined('adres_var_') and adres_var_ eq 1>style="display:none;"</cfif> border="0">
                        	<cfif isdefined('attributes.is_ship_address') and attributes.is_ship_address eq 1>
                                <input type="hidden" name="tax_address_branch_name0" id="tax_address_branch_name0" value="<cf_get_lang_main no='744.Diğer'> <cf_get_lang_main no='1311.Adres'>">
                                <tr>
                                    <td colspan="2"><font color="red" style="font-weight:bold;"><cf_get_lang no='542.Siparişinizin en kısa sürede teslim edilebilmesi için aşağıdaki alanları eksiksiz doldurunuz'>!</font><br><br></td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang no='1346.Adres Adı'></td>
                                    <td>
                                        <input type="text" name="ship_contact_name0" id="ship_contact_name0" value="<cf_get_lang_main no='744.Diğer'> <cf_get_lang_main no='1311.Adres'>" maxlength="50" style="width:150px;">
                                    </td>
                                </tr>
                                <cfif isDefined('attributes.is_ship_contact_delivery') and attributes.is_ship_contact_delivery eq 1>
                                    <tr>
                                        <td><cf_get_lang no='103.Teslim Edilecek'></td>
                                        <td>
                                            <input type="text" name="ship_contact_delivery0" id="ship_contact_delivery0" value="" maxlength="50" style="width:150px;">
                                        </td>
                                    </tr>
                                </cfif>
                                <tr>
                                    <td><cf_get_lang_main no='1173.Kod'>/ <cf_get_lang_main no='87.Telefon'></td>
                                    <td>
                                        <cfinput type="text" name="ship_contact_telcode0" id="ship_contact_telcode0" value="" maxlength="5" onKeyUp="isNumber(this);" style="width:55px;">
                                        <cfinput type="text" name="ship_contact_tel0" id="ship_contact_tel0" value="" maxlength="10" onKeyUp="isNumber(this);" style="width:86px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='807.Ülke'></td>
                                    <td>
                                        <select name="ship_address_country0" id="ship_address_country0" style="width:156px;" onchange="LoadCity(this.value,'ship_address_city0','ship_address_county0'<cfif attributes.is_residence_select eq 1>,'ship_district_id0'</cfif>)">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                            <cfoutput query="get_country_all">
                                                <option value="#country_id#" <!---<cfif country_id eq 1> selected</cfif>--->>#country_name#</option>
                                            </cfoutput>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='559.İl'> *</td>
                                    <td>
                                        <select name="ship_address_city0" id="ship_address_city0" style="width:156px;" onchange="LoadCounty(this.value,'ship_address_county0','ship_contact_telcode0'<cfif attributes.is_residence_select eq 1>,'ship_district_id0'</cfif>)">
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </td>
                                </tr>
                                <tr> 
                                    <td nowrap="nowrap"><cf_get_lang_main no='1226.İlçe'> *</td>
                                    <td>
                                        <select name="ship_address_county0" id="ship_address_county0" style="width:156px;" <cfif attributes.is_residence_select eq 1>onChange="LoadDistrict(this.value,'ship_district_id0');"</cfif>>
                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='720.Semt'></td>
                                    <td><input type="text" name="ship_address_semt0" id="ship_address_semt0" value="" maxlength="50" style="width:150px;"></td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='60.Posta Kodu'></td>
                                    <td><input type="text" name="ship_address_postcode0" id="ship_address_postcode0" value="" style="width:150px;" maxlength="5"></td>
                                </tr>
                                <cfif attributes.is_detail_address eq 1>
                                    <tr>
                                        <td><cf_get_lang_main no='1323.Mahalle'></td>
                                        <td>
                                            <cfif attributes.is_residence_select eq 0>
                                                <input type="text" name="ship_district0" id="ship_district0" style="width:150px;" value="">
                                            <cfelse>
                                                <select name="ship_district_id0" id="ship_district_id0" style="width:156px;">
                                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                </select>
                                            </cfif>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang no ='1335.Cadde'></td>
                                        <td><input type="text" name="ship_main_street0" id="ship_main_street0" maxlength="50" style="width:150px;"/></td>
                                    </tr>
                                    <tr>
                                        <td><cf_get_lang no ='1334.Sokak'></td>
                                        <td><input type="text" name="ship_street0" id="ship_street0" maxlength="50" style="width:150px;"/></td>
                                    </tr>
                                    <tr>
                                        <td style="vertical-align:top;"><cf_get_lang no='1628.Adres Detay'></td>
                                        <td><textarea name="ship_work_doorno0" id="ship_work_doorno0" style="width:150px;" maxlength="200"></textarea></td>
                                    </tr>
                                <cfelse>
                                    <tr> 
                                        <td style="vertical-align:top;"><cf_get_lang_main no='1311.Adres'> *</td>
                                        <td><textarea name="ship_address0" id="ship_address0" style="width:200px;height:50px;"></textarea></td>
                                    </tr>
                                </cfif>
							</table>
                        </cfif>
					</td>
				</tr>
				<!--- Kimlik bilgileri --->
				<cfif isdefined("attributes.is_identy_control") and attributes.is_identy_control eq 1 and isdefined("session.ww.userid")>
					<cfquery name="GET_TC" datasource="#DSN#">
						SELECT TC_IDENTY_NO FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
					</cfquery>
					<tr>
						<td colspan="2"><div style="height:1px; background-color:#CCC;">&nbsp;</div></td>
					</tr>
					<tr>
						<td>
							<table>
								<tr height="25">
									<td width="120"><cf_get_lang_main no='613.TC Kimlik Numaranız'> *</td>
									<cfsavecontent variable="idnty_msg"><cf_get_lang_main no='1275.Lütfen TC Kimlik No Giriniz'></cfsavecontent>
									<td><cfinput type="text" name="tc_identy_no" id="tc_identy_no" value="#get_tc.tc_identy_no#" style="width:200px;" maxlength="11" required="yes" message="#idnty_msg#"></td>
								</tr>
							</table>
						</td>
					</tr>
				</cfif>
				<cfif isdefined("attributes.is_identy_control") and attributes.is_identy_control eq 1 and isdefined("session.pp.userid")>
					<tr>
						<td class="txtboldblue">1.(a) - <cf_get_lang no='20.Vergi Bilgileriniz'></td>
					</tr>
					<cfquery name="GET_VERGI" datasource="#DSN#">
						SELECT TAXOFFICE,TAXNO FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
					</cfquery>
					<tr>
						<td><cf_get_lang_main no='1350.Vergi Dairesi'></td>
					</tr>
					<tr>
						<td>
							<cfsavecontent variable="tax_msg"><cf_get_lang no='507.Lütfen vergi dairesi giriniz'></cfsavecontent>
							<cfinput type="text" name="tax_office" id="tax_office" value="#get_vergi.taxoffice#" maxlength="30" required="yes" message="#tax_msg#"></td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='340.Vergi Numaranız'></td>
					</tr>
					<tr>
						<td>
							<cfsavecontent variable="tax_msg2"><cf_get_lang no='508.Lütfen vergi numarası giriniz'></cfsavecontent>
							<cfinput type="text" name="tax_no" id="tax_no" value="#get_vergi.taxno#" maxlength="12" required="yes" message="#tax_msg2#"></td>
					</tr>
				</cfif>
				<!--- siparis ek bilgileri --->
				<cfif isdefined('attributes.is_order_ref_no') and attributes.is_order_ref_no eq 1>
					<tr>
						<td>
							<table>
								<tr>
									<td><cf_get_lang_main no='68.Konu'> : </td>
									<td><input type="text" name="order_head_" id="order_head_" value="" maxlength="40" style="width:150px;" /></td>
								</tr>
								<tr>
									<td><cfif session.pp.language eq 'tr'>Sevk Yeri<cfelse>Delivery Location</cfif> : </td>
									<td><input type="text" name="ref_no" id="ref_no" value="" maxlength="40" style="width:150px;" /></td>
								</tr>	
							</table>
						</td>
						<cfif isdefined('attributes.is_order_ref_no') and attributes.is_order_ref_no eq 1 and isDefined('session.pp.userid')>
                            <cfquery name="GET_SALES_ZONES" datasource="#DSN#">
                                SELECT 
                                    SZ.SZ_ID, 
                                    SZ.SZ_NAME 
                                FROM 
                                    SALES_ZONES SZ
                                WHERE 
                                    SZ.KEY_ACCOUNT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                            </cfquery>
                            <cfif get_sales_zones.recordcount>
                                <td>
                                    <table>
                                        <tr>
                                            <td><cf_get_lang_main no='355.Satış Bölgeleri'></td>
                                        </tr>
                                        <cfoutput query="get_sales_zones">
                                            <tr>
                                                <td>
                                                    <input type="radio" name="sales_zone" id="sales_zone" value="#sz_id#" <cfif get_sales_zones.recordcount eq 1>checked</cfif>/> #sz_name#<br/>
                                                </td>
                                            </tr>
                                        </cfoutput>
                                    </table>
                                </td>
                            </cfif>
                        </cfif>  
					</tr>
				</cfif>  
				<!--- XML den tanımlanan dosya include edilir silmeyiniz --->
				<cfif isdefined('attributes.is_order_info_file') and len(attributes.is_order_info_file)>
					<tr>
						<td><cfinclude template="#attributes.is_order_info_file#"></td>
					</tr>
				</cfif>
			</table>
		</td>
	</tr>
</table>
<table id="teslimat_devam" align="right">
	<tr>
		<td align="right">
			<cfsavecontent variable="alert2"><cf_get_lang no ='1552.Sepete Dön'></cfsavecontent>
			<cfif isdefined('attributes.is_back_basket') and attributes.is_back_basket eq 1>
				<input type="button" onclick="kontrol_page();" class="back_basket">
			</cfif>
			<input type="button" onclick="next_orders(1);" class="devam_btn" value="<cf_get_lang_main no='714.Devam'>">
        </td>
	</tr>
</table>
<br/>
<!--- sevkiyat kismi --->
<div id="cargo_action_div" style="display:none;"></div>
<table cellpadding="2" cellspacing="1" class="color-header" align="center" id="sevkiyat_info" style="display:none; width:98%; height:100%">
	<tr class="color-list" style="height:25px;">
		<td class="formbold"><cf_get_lang no='23.Sevkiyat Bilgileri'></td>
	</tr>
	<tr class="color-row">
		<td style="vertical-align:top;">
			<table align="center" style="width:98%">
				<tr>
					<td><cf_get_lang no='1006.Sevk Yöntemini Seçiniz'></td>
				</tr>
				<tr style="display:none;">
					<td>
                    	<cfif isDefined('attributes.extra_process_row_id') and len(attributes.extra_process_row_id)>
	                        <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0' extra_process_row_id='#attributes.extra_process_row_id#'>
						<cfelse>
	                        <cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>                        
                        </cfif>
                        <input type="hidden" name="deliverdate" id="deliverdate" value="<cfoutput>#dateformat(now(),'dd/mm/yyyy')#</cfoutput>" validate="eurodate">
					</td>
				</tr>
				<tr>
					<td>
						<select name="ship_method_id" id="ship_method_id" style="width:170px;" <cfif isdefined("attributes.is_ship_method_change") and attributes.is_ship_method_change eq 0>disabled</cfif> <cfif not isdefined("attributes.is_puan_basket")>onChange="if (this.options[this.selectedIndex].value != 'null') change_cargo_info(this.options[this.selectedIndex].value);"</cfif>>
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_shipmethod">
                            	<cfif session_base.language neq 'tr'>
                                	<cfquery name="GET_FOR_SHIP_MET" dbtype="query">
                                    	SELECT * FROM GET_FOR_SHIP_METS WHERE UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ship_method_id#">
                                    </cfquery>
                                    <cfif get_for_ship_met.recordcount>
										<option value="#ship_method_id#" <cfif isdefined("attributes.default_ship_method_id") and len(attributes.default_ship_method_id) and attributes.default_ship_method_id eq ship_method_id> selected</cfif>>#get_for_ship_met.item#</option>                                   
                                    <cfelse>                                    
										<option value="#ship_method_id#" <cfif isdefined("attributes.default_ship_method_id") and len(attributes.default_ship_method_id) and attributes.default_ship_method_id eq ship_method_id> selected</cfif>>#ship_method#</option>                                    
                                    </cfif>
                                <cfelse>
									<option value="#ship_method_id#" <cfif isdefined("attributes.default_ship_method_id") and len(attributes.default_ship_method_id) and attributes.default_ship_method_id eq ship_method_id> selected</cfif>>#ship_method#</option>
								</cfif>
								<!--- <option value="#ship_method_id#" <cfif isdefined("attributes.default_ship_method_id") and len(attributes.default_ship_method_id) and attributes.default_ship_method_id eq ship_method_id> selected</cfif>>#ship_method#</option> --->
							</cfoutput>
						</select>
					</td>
				</tr>
				<tr id="kargo_info_tr" style="display:none;">
					<td id="kargo_info_td">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table id="sevkiyat_devam" align="right" style="display:none;">
	<tr>
		<td>
			<cfsavecontent variable="alert2"><cf_get_lang no ='1552.Sepete Dön'></cfsavecontent>
			<cfif isdefined('attributes.is_back_basket') and attributes.is_back_basket eq 1>
				<input type="button" onclick="kontrol_page();" class="back_basket">
			</cfif>
			<input type="button" onclick="back_orders(1);" class="geri_btn" value="<cf_get_lang_main no ='20.Geri'>">
		</td>
		<td>
			<input type="button" onclick="next_orders(2);" class="devam_btn" value="<cf_get_lang_main no='714.Devam'>">
        	<!---<a href="javascript://" onclick="back_orders(1);">Geri</a>&nbsp;&nbsp;&nbsp;<a href="javascript://" onclick="next_orders(2);">Devamı</a>--->
        </td>
	</tr>
</table>
<br /> 
<!--- odeme kismi --->
<table border="0" cellpadding="2" cellspacing="1" class="color-header" align="center" id="pay_info"  style="display:none; width:98%; height:100%">
    <tr class="color-list" style="height:25px;">
		<td class="formbold"><cf_get_lang no='25.Ödeme Bilgileri'></td>
  	</tr>
  	<tr class="color-row">
		<td style="vertical-align:top;">
			<div id="puan_action_div" style="display:none;"></div>
			<table width="98%" align="center">
				<cfif isdefined('attributes.is_money_credit_use') and attributes.is_money_credit_use eq 1>
					<tr>
						<td class="txtbold">
                        	<input type="hidden" name="is_great_point" id="is_great_point" value="0" >
							<input type="checkbox" name="money_credit_id" id="money_credit_id" class="radio_frame" value="1" onclick="comp_money_cred();" <cfif get_money_credits.total_money_credit lte 0>disabled</cfif>> 
							<cf_get_lang no='57.Para Puanımı Kullanmak İstiyorum'>
						</td>
					</tr>
					<tr>
						<td>
							<table>
								<tr>
									<td><cf_get_lang no='59.Parapuan'></td>
									<td><input type="text"  name="money_credit_value" id="money_credit_value" value="<cfoutput>#TLFormat(get_money_credits.total_money_credit)#</cfoutput>" class="moneybox" style="width:70px;" readonly /></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td><div style="height:1px; background-color:#CCC;">&nbsp;</div></td>
					</tr>
				</cfif>
				<!--- Parapuan --->
				
				<!--- hediye çeki --->
				<cfif isdefined('attributes.is_gift_card_use') and attributes.is_gift_card_use eq 1>
					<tr>
						<td class="txtbold">
							<input type="checkbox" name="gift_card_id" id="gift_card_id" class="radio_frame" value="1" onclick="control_gift_card();"> 
							<cf_get_lang no='61.Hediye Çeki Kullanmak İstiyorum'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							&nbsp;&nbsp;
						</td>
					</tr>
					<tr id="gift_card_td">
						<td>
							<table>
								<tr>
									<td><cf_get_lang no='62.Hediye Çeki Numarası'></td>
									<td>
										<input type="text" name="gift_card_no" id="gift_card_no" value="" style="width:110px;" onblur="control_gift_card();">
										<input type="hidden" name="gift_money_credit_id" id="gift_money_credit_id" value="" >
                                        <input type="hidden" name="is_great_gift" id="is_great_gift" value="0" >
									</td>
								</tr>
								<tr id="gift_value" style="display:none;">
									<td><cf_get_lang no='63.Hediye Çeki Tutarı'></td>
									<td>
										<input type="text" name="gift_card_value" id="gift_card_value" value="" readonly class="moneybox" style="width:110px;">
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td><div style="height:1px; background-color:#CCC;">&nbsp;</div></td>
					</tr>
				</cfif>
				<!--- hediye çeki --->

				<!--- havale/eft --->
				<cfif get_havale.recordcount> 
					<tr>
						<td class="txtbold">
							<input type="hidden" name="paymethod_id_1" id="paymethod_id_1" value="<cfoutput>#get_havale.paymethod_id#,#get_havale.due_day#</cfoutput>">
							<input type="radio" name="paymethod_type" id="paymethod_type" class="radio_frame" value="1" onclick="odemeyontemi(1);" <cfif isdefined('attributes.default_pay_method_id') and (attributes.default_pay_method_id eq get_havale.paymethod_id)>checked="checked"</cfif>>
							<cfoutput>
								#get_havale.paymethod# 
								<cfif len(get_havale.first_interest_rate) and get_havale.first_interest_rate neq 0>
									<input type="hidden" name="first_interest_rate" id="first_interest_rate" value="#get_havale.first_interest_rate#">
									<font color="FF0000">(% #get_havale.first_interest_rate# Havale İndirimi)</font>
								</cfif>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td>
							<table id="pay_type_1" cellpadding="0" cellspacing="0">
								<tr>
									<cfquery name="GET_PROCESS_CAT_TALIMAT" datasource="#DSN3#">
										SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE <cfif isdefined("attributes.company_id") and len(attributes.company_id)>IS_PARTNER = 1<cfelse>IS_PUBLIC = 1</cfif> AND PROCESS_TYPE = 251
									</cfquery>
									<input type="hidden" name="process_cat_talimat" id="process_cat_talimat" value="<cfoutput>#get_process_cat_talimat.process_cat_id#</cfoutput>">
									<input type="hidden" name="process_type_talimat" id="process_type_talimat" value="251">
									<td width="100"><cf_get_lang no='1009.Banka Hesaplarımız'></td>
									<td>
										<select name="account_id" id="account_id" style="width:200px;">
											<cfoutput query="get_bank">
												<option value="#account_id#,#account_currency_id#,0,#branch_code#,#account_no#,#account_owner_customer_no#,#bank_branch_name#,#bank_name#">#account_name#</option>
											</cfoutput>
										</select>
									</td>
								</tr>
								<cfoutput>
									<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
										<tr>
											<cfif len(get_order_bakiye.nettotal)>
												<cfset net_bakiye = get_company_risk.bakiye + get_order_bakiye.nettotal>								
											<cfelseif len(get_company_risk.bakiye)>
												<cfset net_bakiye = get_company_risk.bakiye>
											<cfelse>
												<cfset net_bakiye = 0>
											</cfif>
											<cfif net_bakiye lt 0><td><cf_get_lang_main no='176.Alacak'> <cf_get_lang_main no='177.Bakiye'></td><cfelse><td><cf_get_lang_main no='175.Borç'> <cf_get_lang_main no='177.Bakiye'></td></cfif>
											<td><input type="text" name="bakiye" id="bakiye" value="#TLFormat(abs(net_bakiye),2)#" style="width:125px;" class="moneybox" readonly/></td>
										</tr>
									</cfif>
									<tr>
										<td width="150"><cf_get_lang no='384.Havale'>/<cf_get_lang no='1010.EFT Tutarı'></td>
										<td>
											<input type="hidden" name="paym_date" id="paym_date" value="#dateformat(now(),'dd/mm/yyyy')#">
											<input type="hidden" name="act_date" id="act_date" value="#dateformat(now(),'dd/mm/yyyy')#">
											<input type="hidden" name="order_amount" id="order_amount" value="">
											<input type="text" name="order_amount_dsp" id="order_amount_dsp" value="" style="width:193px;" class="moneybox" readonly>
											<cfif len(get_havale.first_interest_rate) and get_havale.first_interest_rate neq 0>
												<font color="FF0000">&nbsp;&nbsp;&nbsp;(<cf_get_lang no='384.Havale'> <cf_get_lang no='399.Özel Fiyatı'>)</font>
											</cfif>
										</td>
									</tr>
								</cfoutput>
							</table>
						</td>
					</tr>
					<tr>
						<td height="1"><div style="height:1px; background-color:#CCC;">&nbsp;</div></td>
					</tr>
				</cfif>
				<!--- kapida ödeme --->		
				<cfif get_door_paymethod.recordcount>
					<cfif isdefined('attributes.is_door_paymethod_multiple') and attributes.is_door_paymethod_multiple eq 1><!--- eğer parametre çoklu seçime izin verirse --->
						<cfoutput>
							<tr>
								<td class="txtbold" colspan="2">
									<!---<input type="hidden" name="paymethod_id_7" value="#get_door_paymethod.paymethod_id#,#get_door_paymethod.due_day#">--->
									<input type="radio" name="paymethod_type" id="paymethod_type" class="radio_frame" value="7" onclick="odemeyontemi(7);">
									Kapıda Ödeme
									<cfif len(get_door_paymethod.first_interest_rate) and get_door_paymethod.first_interest_rate neq 0>
										<input type="hidden" name="first_interest_rate_door" id="first_interest_rate_door" value="#get_door_paymethod.first_interest_rate#">
										&nbsp;&nbsp;&nbsp;<font color="FF0000">(% #get_door_paymethod.first_interest_rate# <cf_get_lang no='26.Kapıda Ödeme İndirimi'>)</font>
									</cfif>
								</td>
							</tr>
						</cfoutput>
						<tr>
							<td>
								<table id="pay_type_door" style="display:none;">
									<tr>
										<td><!---<select name="paymethod_id_7" id="paymethod_id_7">
												<cfoutput query="get_door_paymethod">
													<option value="#paymethod_id#,#due_day#">#paymethod#</option>
												</cfoutput>
											</select>--->
											<cfoutput query="get_door_paymethod">
												<input type="radio" name="paymethod_id_7" id="paymethod_id_7" class="radio_frame" value="#paymethod_id#,#due_day#">#paymethod#<br/>
											</cfoutput>
										</td>
									</tr>
									<cfoutput>
										<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
											<tr>
												<cfif len(get_order_bakiye.nettotal)>
													<cfset net_bakiye = get_company_risk.bakiye + get_order_bakiye.nettotal>								
												<cfelseif len(get_company_risk.bakiye)>
													<cfset net_bakiye = get_company_risk.bakiye>
												<cfelse>
													<cfset net_bakiye = 0>
												</cfif>
												<cfif net_bakiye lt 0><td><cf_get_lang_main no='176.Alacak'> <cf_get_lang_main no='177.Bakiye'></td><cfelse><td><cf_get_lang_main no='175.Borç'> <cf_get_lang_main no='177.Bakiye'></td></cfif>
												<td><input type="text" name="bakiye" id="bakiye" value="#TLFormat(abs(net_bakiye),2)#" style="width:125px;" class="moneybox" readonly/></td>
											</tr>
										</cfif>
										<tr>
											<td><cf_get_lang no='39.Kapıda Ödeme Tutarı'></td>
											<td>
												<input type="text" name="door_pay_amount" id="door_pay_amount" value="" style="width:125px;" class="moneybox" readonly>
												<cfif len(get_door_paymethod.first_interest_rate) and get_door_paymethod.first_interest_rate neq 0>
													<font color="FF0000">&nbsp;&nbsp;&nbsp;(<cf_get_lang no='26.Kapıda Ödeme İndirimi'>)</font>
												</cfif>
											</td>
										</tr>
									</cfoutput>
								</table>
							</td>
						</tr>
					<cfelse>
						<cfoutput>
							<tr>
								<td class="txtbold" colspan="2">
									<input type="hidden" name="paymethod_id_7" id="paymethod_id_7" value="#get_door_paymethod.paymethod_id#,#get_door_paymethod.due_day#">
									<input type="radio" name="paymethod_type" id="paymethod_type" class="radio_frame" value="7" onclick="odemeyontemi(7);">
									#get_door_paymethod.paymethod# 
									<cfif len(get_door_paymethod.first_interest_rate) and get_door_paymethod.first_interest_rate neq 0>
										<input type="hidden" name="first_interest_rate_door" id="first_interest_rate_door" value="#get_door_paymethod.first_interest_rate#">
										&nbsp;&nbsp;&nbsp;<font color="FF0000">(% #get_door_paymethod.first_interest_rate# <cf_get_lang no='26.Kapıda Ödeme İndirimi'>)</font>
									</cfif>
								</td>
							</tr>
							<tr>
								<td>
									<table id="pay_type_door" style="display:none;">
										<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
											<tr>
												<cfif len(get_order_bakiye.nettotal)>
													<cfset net_bakiye = get_company_risk.bakiye + get_order_bakiye.nettotal>								
												<cfelseif len(get_company_risk.bakiye)>
													<cfset net_bakiye = get_company_risk.bakiye>
												<cfelse>
													<cfset net_bakiye = 0>
												</cfif>
												<cfif net_bakiye lt 0><td><cf_get_lang_main no='176.Alacak'> <cf_get_lang_main no='177.Bakiye'></td><cfelse><td><cf_get_lang_main no='175.Borç'> <cf_get_lang_main no='177.Bakiye'></td></cfif>
												<td><input type="text" name="bakiye" id="bakiye" value="#TLFormat(abs(net_bakiye),2)#" style="width:125px;" class="moneybox" readonly/></td>
											</tr>
										</cfif>
										<tr>
											<td><cf_get_lang no='39.Kapıda Ödeme Tutarı'></td>
											<td>
												<input type="text" name="door_pay_amount" id="door_pay_amount" value="" style="width:125px;" class="moneybox" readonly>
												<cfif len(get_door_paymethod.first_interest_rate) and get_door_paymethod.first_interest_rate neq 0>
													<font color="FF0000">&nbsp;&nbsp;&nbsp;(<cf_get_lang no='26.Kapıda Ödeme İndirimi'>)</font>
												</cfif>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</cfoutput>
					</cfif>
					<tr>
						<td><div style="height:1px; background-color:#CCC;">&nbsp;</div></td>
					</tr>
				</cfif>
				<!--- kredi karti --->
			 	<cfif get_accounts.recordcount>
					<tr style="height:25px;">
						<td class="txtbold"><input type="radio" name="paymethod_type" id="paymethod_type" class="radio_frame" value="2" onclick="odemeyontemi(2);" <cfif isDefined("attributes.paymethod_id_com")>checked</cfif>> <cf_get_lang no='1015.Kredi Kartı İle Ödemek İstiyorum'></td>
					</tr>
			    	<tr>
						<td>
							<input type="hidden" name="joker_options_value" id="joker_options_value" value="">
							<table style="width:100%;">
								<tr>
									<td valign="top" id="pay_type_2" <cfif not isDefined("attributes.paymethod_id_com")>style="display:none;"</cfif>>
										<table>
											<tr>
												<td style="width:200px;"><cf_get_lang_main no ='109.Banka'> *</td>
												<td><select name="pos_type_id" id="pos_type_id" style="width:200px;" onchange="if (this.options[this.selectedIndex].value != ''){ listAccounts(); }"><!---sistem yönetimi sanal pos tanımlarından getirir dinamik hale getirmek için yapıldı FA24012011--->
														<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
														<cfoutput query="getSanalPos" group="POS_ID">
															<option value="#pos_id#">#pos_name#</option>
														</cfoutput>
													</select>
												</td>
											</tr>
											<cfset readonly_info = 0>
											<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
												<tr height="20" class="color-row">
													<td><cf_get_lang_main no='787.Kredi Kartı'></td>
													<td>
														<select name="member_credit_card" id="member_credit_card" style="width:200px;" onchange="get_card_no(0,0);">
															<cfif get_credit_cards.recordcount>														
																<cfoutput query="get_credit_cards">
                                                                    <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                                                        <cfset key_type = '#CONSUMER_ID#'>
                                                                        <cfset cc_number_ = consumer_cc_number>
                                                                        <cfset cc_id_ = consumer_cc_id>
                                                                    <cfelse>
                                                                        <cfset key_type = '#COMPANY_ID#'>
                                                                        <cfset cc_number_ = company_cc_number>
                                                                        <cfset cc_id_ = company_cc_id>
                                                                    </cfif>
                                                                    <!--- 
                                                                        FA-09102013 kredi kartı Gelişmiş şifreleme standartları ile şifrelenmesi. 
                                                                        Bu sistemin çalışması için sistem/güvenlik altında kredi kartı şifreleme anahtarlırının tanımlanması gerekmektedir 
                                                                    --->
                                                                    <cfscript>
                                                                        getCCNOKey = createObject("component", "V16.settings.cfc.setupCcnoKey");
                                                                        getCCNOKey.dsn = dsn;
                                                                        getCCNOKey1 = getCCNOKey.getCCNOKey1();
                                                                        getCCNOKey2 = getCCNOKey.getCCNOKey2();
                                                                    </cfscript>
                                                                    <!--- key 1 ve key 2 DB ye kaydedilmiş ise buna göre encryptleme sistemi çalışıyor --->
                                                                    <cfif getCCNOKey1.recordcount and getCCNOKey2.recordcount>
                                                                        <!--- anahtarlar decode ediliyor --->
                                                                        <cfset ccno_key1 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey1.record_emp,content:getCCNOKey1.ccnokey) />
                                                                        <cfset ccno_key2 = contentEncryptingandDecodingAES(isEncode:0,accountKey:getCCNOKey2.record_emp,content:getCCNOKey2.ccnokey) />
                                                                        <!--- kart no encode ediliyor --->
                                                                        <cfset content = contentEncryptingandDecodingAES(isEncode:0,content:cc_number_,accountKey:key_type,key1:ccno_key1,key2:ccno_key2) />
                                                                        <cfset content = '#mid(content,1,4)#********#mid(content,Len(content) - 3, Len(content))#'>
                                                                    <cfelse>
                                                                        <cfset content = '#mid(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(cc_number_,key_type,"CFMX_COMPAT","Hex")))#'>
                                                                    </cfif>
                                                                    <option value="#cc_id_#">#content#</option>
                                                                </cfoutput>
                                                            <cfelse>
                                                                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                            </cfif>
														</select>
													</td>
												</tr>
											</cfif>
											<tr>
												<td><cf_get_lang no='260.Kart Hamili'></td>
												<td><input type="text" name="card_owner" id="card_owner" style="width:194px;" maxlength="30" <cfif isdefined("readonly_info") and readonly_info eq 1>readonly</cfif>></td>
											</tr>
											<tr>
												<cfquery name="GET_PROCESS_CAT_TAHSILAT" datasource="#DSN3#">
													SELECT PROCESS_CAT_ID FROM SETUP_PROCESS_CAT WHERE <cfif isdefined("attributes.company_id") and len(attributes.company_id)>IS_PARTNER = 1<cfelse>IS_PUBLIC = 1</cfif> AND PROCESS_TYPE = 241
												</cfquery>
												<cfoutput>
													<input type="hidden" name="process_cat_rev" id="process_cat_rev" value="#get_process_cat_tahsilat.process_cat_id#">
													<input type="hidden" name="process_type" id="process_type" value="241">
													<input type="hidden" name="action_from_company_id" id="action_from_company_id" value="<cfif isdefined("attributes.company_id") and len(attributes.company_id)>#attributes.company_id#<cfelse>#attributes.consumer_id#</cfif>">
													<input type="hidden" name="action_date" id="action_date" value="#dateformat(now(),'dd/mm/yyyy')#">
												</cfoutput>
												<div id="show_member_card" style="display:none;"></div>
												<td><cf_get_lang no ='258.Kart Numarası'>*</td>
												<td>
													<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
														<cfsavecontent variable="message"><cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!</cfsavecontent>
														<cfinput type="hidden" name="card_no" id="card_no" validate="creditcard" maxlength="16" message="#message#" autocomplete="off"  style="width:195px;">
														<cfif isdefined("readonly_info") and readonly_info eq 1>
															<cfinput type="text" name="dsp_card_no" id="dsp_card_no" maxlength="16" autocomplete="off" onKeyUp="kontrol_cardno();" readonly style="width:195px;">
														<cfelse>
															<cf_input_pcKlavye name="dsp_card_no" value="" type="text" numpad="true" accessible="true" maxlength="16" inputStyle="width:195px;" message="#message#" required="no" validate="creditcard" onKeyUp="kontrol_cardno();isNumber(this);">
														</cfif>
													<cfelse>
														<cfsavecontent variable="message"><cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!</cfsavecontent>
														<cfif isdefined("readonly_info") and readonly_info eq 1>
															<cfinput type="text" name="card_no" id="card_no" validate="creditcard" maxlength="16" message="#message#" autocomplete="off" readonly style="width:195px;">
														<cfelse>
															<cf_input_pcKlavye name="card_no" value="" type="text" numpad="true" accessible="true" maxlength="16" inputStyle="width:195px;" message="#message#" required="no" validate="creditcard" onKeyUp="isNumber(this);">
														</cfif>
													</cfif>
													<cfif isDefined("session.ep")><a href="javascript://" onclick="get_card_no(1,0);"><img src="/images/mobil.gif" style="cursor:pointer;" align="absmiddle" border="0" title="<cf_get_lang no ='64.IVR dan Kredi Kartı Bilgisi Al'>"></a></cfif>
												</td>
											</tr>
											<tr height="25">
												<td><cf_get_lang no ='1269.Kart Güvenlik Kodu(CVV)'>*</td>
												<td>
													<cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
														<cfsavecontent variable="alert"><cf_get_lang no ='1270.Lütfen Güvenlik Kodu(CVV No) Giriniz'></cfsavecontent>
														<cfinput type="hidden" name="cvv_no" id="cvv_no" style="width:50px;" maxlength="3" message="#alert#" autocomplete="off" readonly>
														<cfif isdefined("readonly_info") and readonly_info eq 1>
															<cfinput type="text" name="dsp_cvv_no" id="dsp_cvv_no" maxlength="3" autocomplete="off"  onKeyUp="kontrol_cardno();isNumber(this);" readonly style="width:50px;">
														<cfelse>
															<cf_input_pcKlavye name="dsp_cvv_no" value="" type="text" numpad="true" accessible="true" maxlength="3" inputStyle="width:50px;" message="#alert#" required="no" validate="integer" onKeyUp="kontrol_cardno();isNumber(this);">
														</cfif>
													<cfelse>
														<cfsavecontent variable="alert"><cf_get_lang no ='1270.Lütfen Güvenlik Kodu(CVV No) Giriniz'></cfsavecontent>
														<cfif isdefined("readonly_info") and readonly_info eq 1>
															<cfinput type="text" name="cvv_no" id="cvv_no" maxlength="3" message="#alert#" onKeyUp="isNumber(this);" autocomplete="off" readonly style="width:50px;">
														<cfelse>
															<cf_input_pcKlavye name="cvv_no" value="" type="text" numpad="true" accessible="true" maxlength="3" inputStyle="width:50px;" message="#alert#" required="no" validate="integer" onKeyUp="isNumber(this);">
														</cfif>
													</cfif>
													<div style="position:absolute; padding:2px; width:550px; margin-left:80px; margin-top:-27px;display:none;border:thin; border:1px solid;" id="show_message_cvv"></div><a href="javascript://" onclick="show_cvv_info();"><img src="/images/question.gif" style="cursor:pointer;" align="absmiddle" border="0" title="<cf_get_lang no ='1271.Güvenlik Kodu(CVV), Tüm Kredi Kartlarının Arka Yüzünde Bulunan 3 Haneli Numaradır'>."></a>
												</td>
											</tr>
											<tr>
												<td><cf_get_lang no ='1272.Kart Son Kullanma Tarihi'>*</td>
												<td>
													<select name="exp_month" id="exp_month" style="width:50px;" <cfif isdefined("readonly_info") and readonly_info eq 1>disabled</cfif>>
														<cfloop from="1" to="12" index="k">
															<cfoutput>
															<option value="#k#">#NumberFormat(k,00)#<!---#k#---></option>
															</cfoutput> 
														</cfloop>
													</select>
													<select name="exp_year" id="exp_year" style="width:50px;" <cfif isdefined("readonly_info") and readonly_info eq 1>disabled</cfif>>
														<cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
															<cfoutput>
															<option value="#i#">#i#</option>
															</cfoutput> 
														</cfloop>
													</select>
												</td>
											</tr>
											<cfif isdefined('attributes.is_basis_of_receiving') and attributes.is_basis_of_receiving eq 1>
												<tr>
													<cfif len(get_order_bakiye.nettotal)>
														<cfset net_bakiye = get_company_risk.bakiye + get_order_bakiye.nettotal>								
													<cfelseif len(get_company_risk.bakiye)>
														<cfset net_bakiye = get_company_risk.bakiye>
													<cfelse>
														<cfset net_bakiye = 0>
													</cfif>
													<cfif net_bakiye lt 0><td><cf_get_lang_main no='176.Alacak'> <cf_get_lang_main no='177.Bakiye'></td><cfelse><td><cf_get_lang_main no='175.Borç'> <cf_get_lang_main no='177.Bakiye'></td></cfif>
													<td><input type="text" name="bakiye" id="bakiye" value="<cfoutput>#TLFormat(abs(net_bakiye),2)#</cfoutput>" style="width:200px;" class="moneybox" readonly/></td>
											 	</tr>
									   		</cfif>
											<tr>
												<td><cf_get_lang_main no='1737.Toplam Tutar'>*</td>
												<td>
													<input type="hidden" name="sales_credit_old" id="sales_credit_old" value="">
													<input type="text" name="sales_credit" id="sales_credit" value="">
													<input type="text" name="sales_credit_dsp" id="sales_credit_dsp" style="width:195px;" readonly class="moneybox" value="">
												</td>
											</tr>
											<tr>
												<td valign="top" colspan="2">
													<div id="list_accounts"></div>
												</td>
											</tr>
											<tr style="display:none" id="joker_info">
												<td colspan="2">
													<input type="checkbox" name="joker_vada" id="joker_vada" onclick="show_hide_joker_vada(this.checked);" class="radio_frame" checked="checked"><cf_get_lang no ='1333.Joker Vada Kullanmak İstiyorum'>
													<div id="_show_joker_vada_" style="overflow:auto;height:79;width:300;"></div>
												</td>
											</tr>
											<cfif isdefined("attributes.is_credit_card_rules") and len(attributes.is_credit_card_rules)>
												<tr>
													<td colspan="2">
														<table width="100%" align="center" cellpadding="1" cellspacing="1" border="0">
															<tr height="35">
																<td class="txtboldblue"><a href="javascript:gizle_goster(credit_card_rules_);"><cf_get_lang no='45.Kredi Kartı Kullanım Şartları'>.</a><br /></td>
															</tr>
															<tr id="credit_card_rules_" style="display:none;" height="90" valign="top">
																<td>
																	<div id="creditcard_rules_" style="position:absolute;width:330px;height:80px;;z-index:1;overflow:auto;">
																		<table>
																			<tr>
																				<td><cfoutput>#attributes.is_credit_card_rules#</cfoutput></td>
																			</tr>
																		</table>
																	</div>
																</td>
															</tr>
															<tr>
																<td nowrap="nowrap">
																	<input type="checkbox" name="credit_card_rules" id="credit_card_rules" class="radio_frame" value="1" />
																	<cf_get_lang no='45.Kredi Kartı Kullanım Şartlarını Kabul Ediyorum'> *
																</td>
															</tr>
														</table>
													</td>
												  </tr>
											</cfif>
											<cfif isDefined("session.pp")>
												<cfif isdefined("attributes.is_view_last_user_price") and attributes.is_view_last_user_price eq 1>
													<tr>
														<td><input type="checkbox" name="is_price_standart" id="is_price_standart" class="radio_frame" onclick="use_price_standart();"><cf_get_lang no='968.Son Kullanıcı Fiyatı'></td>
														<td style="display:none" id="price_standart_info">
															<input type="hidden" name="price_standart_last" id="price_standart_last" value="">
															<input type="hidden" name="price_standart_old" id="price_standart_old" value="">
															<input type="text" name="price_standart_dsp" id="price_standart_dsp" style="width:160px" class="moneybox" onkeyup="return(FormatCurrency(this,event));" value="">
														</td>
													</tr>
												</cfif>
												<cfif is_order_to_directcustomer eq 1>
													<tr style="display:none" id="price_standart_info2">
														<td valign="top">
															<input type="checkbox" name="consumer_info" id="consumer_info" class="radio_frame" onclick="add_consumer(this)">
															<cf_get_lang no ='1332.Yeni Üye Ekle'>
														</td>
														<td>&nbsp;</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
														<td valign="top">
															<table id="add_consumer_table" style="display:none">
																<tr>
																	<input type="hidden" name="consumer_stage" id="consumer_stage" value="<cfif get_consumer_stage.recordcount><cfoutput>#get_consumer_stage.process_row_id#</cfoutput></cfif>">
																	<td><cf_get_lang_main no='158.Ad Soyad'></td>
																	<td>
																	<input type="text" name="member_name" id="member_name" value="" style="width:80px;">
																	<input type="text" name="member_surname" id="member_surname" value="" style="width:80px;">
																	</td>
																	<td><cf_get_lang no='257.Firma'></td>
																	<td width="150">
																		<input type="text" name="comp_name" id="comp_name" value="" style="width:120px;">
																	</td>
																</tr>
																<tr>
																	<td nowrap><cf_get_lang_main no='1350.Vergi Dairesi'>-<cf_get_lang_main no='340.Vergi No'></td>
																	<td nowrap>
																		<cfinput type="text" name="tax_office" id="tax_office" maxlength="30" style="width:80px;">
																		<cfsavecontent variable="alert"><cf_get_lang_main no ='340.Vergi No'></cfsavecontent>
																		<cfinput type="text" name="tax_num" id="tax_num" tabindex="8" style="width:80px;" maxlength="10" validate="integer" message="#alert#">
																	</td>
																	<td><cf_get_lang_main no='87.Telefon'></td>
																	<td nowrap><cfsavecontent variable="message"><cf_get_lang no='250.Telefon Kodu '>!</cfsavecontent>
																		<cfinput type="text" name="tel_code" id="tel_code" style="width:45px;" maxlength="5" validate="integer" message="#message#">
																		<cfsavecontent variable="message"><cf_get_lang no='22.Telefon Numarası'>!</cfsavecontent>
																		<cfinput type="text" name="tel_number" id="tel_number" tabindex="9"  style="width:72px;" maxlength="7"  validate="integer" message="#message#">
																	</td>
																</tr>
																<tr>
																	<td rowspan="2"><cf_get_lang_main no='1311.Adres'></td>
																	<td rowspan="2"><textarea name="address" id="address" style="width:163px;height:45px;"></textarea></td>
																	<td><cf_get_lang_main no='559.İl'> - <cf_get_lang_main no='1226.İlçe'></td>
																	<td nowrap>                       
																		<select name="city" id="city" style="width:80px;">
																			<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
																			<cfoutput query="get_city_all">
																				<option value="#city_id#">#city_name#</option>
																			</cfoutput>
																		  </select>
																		<input type="text" name="county" id="county" value="" maxlength="30" style="width:80px;" readonly="yes">
																		<a href="javascript://" onclick="pencere_ac2();"><img src="/images/plus_list.gif" title="<cf_get_lang_main no ='322.Seçiniz'>" border="0" align="absmiddle"></a>
																		<input type="hidden" name="county_id" id="county_id" readonly="">
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</cfif>
											</cfif>
										</table>
									</td>
								</tr>
							</table>
						</td>
			    	</tr>
				</cfif>
			 	<tr id="risk_table" style="display:;">
					<cfif ((isdefined("attributes.is_risk_payment") and attributes.is_risk_payment eq 1) or not isdefined("attributes.is_risk_payment")) and ((get_block_info.recordcount and listgetat(get_block_info.block_status,1,',') eq 0) or get_block_info.recordcount eq 0)>
						<td colspan="2" class="txtbold">
							<input type="radio" name="paymethod_type" id="paymethod_type" value="3" class="radio_frame" onclick="odemeyontemi(3);clear_pos_row();"><cfif get_credit.recordcount eq 0 or get_credit.open_account_risk_limit eq 0> <cf_get_lang no='1016.Alacağıma İstinaden Sipariş Vermek İstiyorum'> <cfelse> <cf_get_lang no='264.Kredi Limitimi Kullanmak İstiyorum'></cfif>
						</td>
					</cfif>
					<input type="hidden" name="kalan_risk_info" id="kalan_risk_info" value="">
					<input type="hidden" name="risk_paymethod" id="risk_paymethod" value="<cfoutput>#get_credit.revmethod_id#</cfoutput>">
					<input type="hidden" name="risk_due_day" id="risk_due_day" value="<cfif len(get_credit.revmethod_id)><cfoutput>#get_due_day.due_day#</cfoutput></cfif>">
				</tr>
				<!--- limit asimi --->
                <tr id="risk_credit_table" style="display:none;">
                    <td>
                        <table style="width:100%;">
                            <cfif get_accounts.recordcount>
                                <tr>
                                    <td><div style="height:1px; background-color:#CCC;">&nbsp;</div></td>
                                </tr>
                                <tr>
                                    <td colspan="2" class="txtbold">
                                        <input type="radio" name="paymethod_type" id="paymethod_type" value="4" class="radio_frame" onclick="odemeyontemi(4);"> <cf_get_lang no ='48.Limit Aşımını Kredi Kartı İle Ödemek İstiyorum'>
                                    </td>

                                </tr>
                                <tr>
                                    <td valign="top" id="pay_type_4" <cfif not isDefined("attributes.paymethod_id_com")>style="display:none;"</cfif>>
                                        <table>
                                            <tr>
                                                <td style="width:200px;"><cf_get_lang_main no ='109.Banka'> *</td>
                                                <td>
                                                <select name="lim_pos_type_id" id="lim_pos_type_id" style="width:200px;" onchange="if (this.options[this.selectedIndex].value != ''){ limListAccounts(); }"><!---sistem yönetimi sanal pos tanımlarından getirir dinamik hale getirmek için yapıldı FA24012011--->
                                                    <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                                    <cfoutput query="getSanalPos" group="pos_id">
                                                        <!--- limitlide taksitli secenekler gelmez FA --->
                                                            <cfif isdefined('number_of_instalment') and (not len(number_of_instalment) or number_of_instalment eq 0) and (not len(first_interest_rate) or first_interest_rate  eq 0)>
                                                                <option value="#pos_id#">#pos_name#</option>
                                                            </cfif>
                                                    </cfoutput>
                                                </select>
                                                </td>
                                            </tr>
                                            <cfset readonly_info = 0>
                                            <cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
                                                <tr height="20" class="color-row">
                                                    <td><cf_get_lang_main no='787.Kredi Kartı'></td>
                                                    <td><select name="lim_member_credit_card" id="lim_member_credit_card" style="width:200px;" onchange="get_card_no(0,1);">
                                                        <cfif get_credit_cards.recordcount>														
                                                            <cfoutput query="get_credit_cards">
                                                                <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                                                    <cfset key_type = '#CONSUMER_ID#'>
                                                                    <option value="#consumer_cc_id#">#mid(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(consumer_cc_number,key_type,"CFMX_COMPAT","Hex")))#</option>
                                                                <cfelse>
                                                                    <cfset key_type = '#COMPANY_ID#'>
                                                                    <option value="#company_cc_id#">#mid(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex"),1,4)#********#mid(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex"),Len(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex")) - 3, Len(Decrypt(company_cc_number,key_type,"CFMX_COMPAT","Hex")))#</option>	
                                                                </cfif>
                                                            </cfoutput>
                                                        <cfelse>
                                                            <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                                        </cfif>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </cfif>
                                            <tr>
                                                <td><cf_get_lang no ='258.Kart Numarası'>*</td>
                                                <td><cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
                                                        <cfsavecontent variable="message"><cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!</cfsavecontent>
                                                        <cfinput type="hidden" name="lim_card_no" id="lim_card_no" style="width:195px;" maxlength="16" message="#message#" autocomplete="off">
                                                        <cfif isdefined("readonly_info") and readonly_info eq 1>
                                                            <cfinput type="text" name="lim_dsp_card_no" id="lim_dsp_card_no" style="width:195px;" maxlength="16" autocomplete="off" onKeyUp="kontrol_cardno(1);" readonly>
                                                        <cfelse>
                                                            <cfinput type="text" name="lim_dsp_card_no" id="lim_dsp_card_no" style="width:195px;" maxlength="16" autocomplete="off" onKeyUp="kontrol_cardno(1);">
                                                        </cfif>
                                                    <cfelse>
                                                        <cfsavecontent variable="message"><cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!</cfsavecontent>
                                                        <cfif isdefined("readonly_info") and readonly_info eq 1>
                                                            <cfinput type="text" name="lim_card_no" id="lim_card_no" style="width:195px;" maxlength="16" message="#message#" autocomplete="off" readonly>
                                                        <cfelse>
                                                            <cfinput type="text" name="lim_card_no" id="lim_card_no" style="width:195px;" maxlength="16" message="#message#" autocomplete="off">
                                                        </cfif>
                                                    </cfif>
                                                    <cfif isDefined("session.ep")><a href="javascript://" onclick="get_card_no(1,1);"><img src="/images/mobil.gif" style="cursor:pointer;" align="absmiddle" border="0" title="<cf_get_lang no ='64.IVR dan Kredi Kartı Bilgisi Al'>"></a></cfif>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no='260.Kart Hamili'></td>
                                                <td><input type="text" name="lim_card_owner" id="lim_card_owner" style="width:195px;" maxlength="30" <cfif isdefined("readonly_info") and readonly_info eq 1>readonly</cfif>></td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no ='1269.Kart Güvenlik Kodu(CVV)'>*</td>
                                                <td><cfif isdefined("attributes.is_credit_card_select") and attributes.is_credit_card_select eq 1>
                                                        <cfsavecontent variable="alert"><cf_get_lang no ='1270.Lütfen Güvenlik Kodu(CVV No) Giriniz'></cfsavecontent>
                                                        <cfinput type="hidden" name="lim_cvv_no" id="lim_cvv_no" style="width:50px;" maxlength="3" message="#alert#" autocomplete="off" readonly>
                                                        <cfif isdefined("readonly_info") and readonly_info eq 1>
                                                            <cfinput type="text" name="lim_dsp_cvv_no" id="lim_dsp_cvv_no" style="width:50px;" maxlength="3" autocomplete="off"  onKeyUp="kontrol_cardno(1);" readonly>
                                                        <cfelse>
                                                            <cfinput type="text" name="lim_dsp_cvv_no" id="lim_dsp_cvv_no" style="width:50px;" maxlength="3" autocomplete="off" onKeyUp="kontrol_cardno(1);">
                                                        </cfif>
                                                    <cfelse>
                                                        <cfsavecontent variable="alert"><cf_get_lang no ='1270.Lütfen Güvenlik Kodu(CVV No) Giriniz'></cfsavecontent>
                                                        <cfif isdefined("readonly_info") and readonly_info eq 1>
                                                            <cfinput type="text" name="lim_cvv_no" id="lim_cvv_no" style="width:50px;" maxlength="3" message="#alert#" autocomplete="off" readonly>
                                                        <cfelse>
                                                            <cfinput type="text" name="lim_cvv_no" id="lim_cvv_no" style="width:50px;" maxlength="3" message="#alert#" autocomplete="off">
                                                        </cfif>
                                                    </cfif>
                                                    <div style="position:absolute; padding:2px; width:550px; margin-left:80px; margin-top:-27px;display:none;border:thin; border:1px solid;" id="show_message_cvv"></div><a href="javascript://" onclick="show_cvv_info();"><img src="/images/question.gif" style="cursor:pointer;" align="absmiddle" border="0" title="<cf_get_lang no ='1271.Güvenlik Kodu(CVV), Tüm Kredi Kartlarının Arka Yüzünde Bulunan 3 Haneli Numaradır'>."></a>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang no ='1272.Kart Son Kullanma Tarihi'>*</td>
                                                <td><select name="lim_exp_month" id="lim_exp_month" style="width:50px;" <cfif isdefined("readonly_info") and readonly_info eq 1>disabled</cfif>>
                                                    <cfloop from="1" to="12" index="k">
                                                        <cfoutput>
                                                            <option value="#k#">#k#</option>
                                                        </cfoutput> 
                                                    </cfloop>
                                                    </select>
                                                    <select name="lim_exp_year" id="lim_exp_year" style="width:50px;" <cfif isdefined("readonly_info") and readonly_info eq 1>disabled</cfif>>
                                                    <cfloop from="#dateFormat(now(),'yyyy')#" to="#dateFormat(now(),'yyyy')+10#" index="i">
                                                        <cfoutput>
                                                            <option value="#i#">#i#</option>
                                                        </cfoutput> 
                                                    </cfloop>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><cf_get_lang_main no='1737.Toplam Tutar'>*</td>
                                                <td><input type="hidden" name="lim_sales_credit" id="lim_sales_credit" value="">
                                                    <input type="text" name="lim_sales_credit_dsp" id="lim_sales_credit_dsp" style="width:195px;" readonly class="moneybox" value="">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="top" colspan="2">
                                                    <div id="lim_list_accounts"></div>
                                                </td>
                                            </tr>
                                            <tr style="display:none" id="lim_joker_info">
                                                <td></td>
                                                <td><input type="checkbox" name="lim_joker_vada" id="lim_joker_vada" class="radio_frame" checked="checked"><cf_get_lang no ='1333.Joker Vada Kullanmak İstiyorum'></td>
                                            </tr>
                                            <cfif isdefined("attributes.is_credit_card_rules") and len(attributes.is_credit_card_rules)>
                                                <tr>
                                                    <td>
                                                        <table width="100%" align="center" cellpadding="1" cellspacing="1" border="0">
                                                            <tr height="35">
                                                                <td class="txtboldblue"><a href="javascript:gizle_goster(lim_credit_card_rules_);"><cf_get_lang no ='45.Kredi Kartı Kullanım Şartları'>.</a><br /></td>
                                                            </tr>
                                                            <tr id="lim_credit_card_rules_" style="display:none;" height="90" valign="top">
                                                                <td>
                                                                    <div id="lim_creditcard_rules_" style="position:absolute;width:330px;height:80px;;z-index:1;overflow:auto;">
                                                                        <table>
                                                                            <tr>
                                                                                <td><cfoutput>#attributes.is_credit_card_rules#</cfoutput></td>
                                                                            </tr>
                                                                        </table>
                                                                    </div>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td>
                                                                    <input type="checkbox" name="lim_credit_card_rules" id="lim_credit_card_rules" class="radio_frame" value="1" />
                                                                    <cf_get_lang no ='46.Kredi Kartı Kullanım Şartlarını Kabul Ediyorum'> *
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                            </cfif>
                                        </table>
                                    </td>
                                </tr>
                            </cfif>
                        </table>
                    </td>
                </tr>
				<!--- risk --->
				<cfif isdefined("attributes.is_dsp_risk_info") and attributes.is_dsp_risk_info eq 1>
					<tr id="risk_info" style="display:none;">
						<td>

							<cfinclude template="member_risk_info.cfm">
						</td>
					</tr>							
				</cfif>						
			</table>
		</td>
	</tr>
</table>
<table id="odeme_devam" align="right" style="display:none;">
	<tr>
    	<td>
			<cfsavecontent variable="alert2"><cf_get_lang no ='1552.Sepete Dön'></cfsavecontent>
			<cfif isdefined('attributes.is_back_basket') and attributes.is_back_basket eq 1>
				<input type="button" onclick="kontrol_page();" class="back_basket">
			</cfif>
			<input type="button" onclick="back_orders(2);" class="geri_btn" value="<cf_get_lang_main no ='20.Geri'>">
        </td>
        <td>
			<input type="button" onclick="next_orders(3);" class="devam_btn" value="<cf_get_lang_main no='714.Devam'>">
        </td>
		<!---<td style="text-align:right;"><a href="javascript://" onclick="back_orders(2);">Geri</a>&nbsp;&nbsp;&nbsp;<a href="javascript://" onclick="next_orders(3);">Devam</a></td>--->
	</tr>
</table>
<br/>
<!--- notlar - aciklama --->
<table border="0" cellpadding="2" cellspacing="1" class="color-header" align="center" id="note_info" style="display:none; width:98%">
    <tr class="color-list" style="height:25px;">
        <td class="formbold">
			<cfif (isdefined("attributes.is_view_detail") and attributes.is_view_detail eq 1) or not isdefined("attributes.is_view_detail")>
				<cf_get_lang_main no='10.Notlar'> - <cf_get_lang_main no='217.Açıklama'> <cf_get_lang_main no='577.ve'> <cf_get_lang no='65.Sipariş Sonlandırma'>
			<cfelse>
				<cf_get_lang no='65.Sipariş Sonlandırma'>
			</cfif>
        </td>
    </tr>
    <tr class="color-row">
        <td style="vertical-align:top;">
            <table>
                <cfif (isdefined("attributes.is_view_detail") and attributes.is_view_detail eq 1) or not isdefined("attributes.is_view_detail")>
					<tr>
						<td class="txtboldblue" style="vertical-align:top;"><br/><cf_get_lang_main no='10.Notlar'>-<cf_get_lang_main no='217.Açıklama'></td>
						<td rowspan="2" id="bank_acc_info"></td>
					</tr>
					<tr>
						<td><textarea name="order_detail" id="order_detail" style="width:260px;height:60px;"></textarea></td>
					</tr>
                 <!--- <tr>
                    <td><input type="hidden" name="asset_property_id" id="asset_property_id" value="<cfif isdefined('attributes.asset_property_id') and len(attributes.asset_property_id)><cfoutput>#attributes.asset_property_id#</cfoutput></cfif>" />
                        <input type="hidden" name="asset_cat_id" id="asset_cat_id" value="-12" />
                        <input type="file" name="asset_file"/>
                    </td>
                  </tr>--->
                </cfif>
            </table>
        </td>
	</tr>
	<!--- siparis kosullari xml den content_id ile geliyor --->
	<cfif isdefined('attributes.is_order_content_id') and len(attributes.is_order_content_id)>
		<cfquery name="GET_CONTENT_ORDER" datasource="#DSN#" maxrows="1">
			SELECT CONT_HEAD FROM CONTENT WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_order_content_id#">
		</cfquery>
		<tr class="color-row">
			<td style="vertical-align:top;">
				<table>
					<tr style="height:35px;">
						<td class="txtboldblue"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_content_notice&content_id=#attributes.is_order_content_id#</cfoutput>','list');"><cfoutput>#get_content_order.cont_head#</cfoutput></a><br /></td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" name="order_rules" id="order_rules" class="radio_frame" value="1" /><cf_get_lang no='66.Sipariş Koşullarını Kabul Ediyorum'>.*
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
	<cfif isdefined('attributes.is_order_content_template') and attributes.is_order_content_template eq 1>
		<input type="hidden" name="order_contract" id="order_contract" value="0" />
	</cfif>
	<!--- siparis kosullari xml den content_id ile geliyor --->
</table>
<br />
<table id="buton_info" align="right" style="display:none;">
	<tr style="height:30px;">
		<cfif isdefined('attributes.is_order_last_button') and attributes.is_order_last_button eq 1>
			<td>
				<input type="button" onclick="back_orders(3);" class="geri_btn" value="<cf_get_lang_main no ='20.Geri'>">
				<cfif isdefined('attributes.is_back_basket') and attributes.is_back_basket eq 1>
					<input type="button" onclick="kontrol_page();" class="back_basket" value="">
				</cfif>
			</td>
			<td>
            	<!---<cfsavecontent variable="alert"><cf_get_lang no ='1331.Siparişi Bitir'></cfsavecontent>
				<input type="submit" id="order_submit_button" name="order_submit_button" value="<cfoutput>#alert#</cfoutput>" onclick="return kontrol();" class="sale_finish">--->
				<input type="submit" name="order_submit_button" id="order_submit_button" value="" onclick="return kontrol();" class="sale_finish">
				<input type="button" name="order_submit_button2" id="order_submit_button2" value="" class="sale_finish" style="display:none;" disabled=""> 
			</td>
		<cfelse>
			<td>
				<input type="button" onclick="back_orders(3);" value="<cf_get_lang_main no='20.Geri'>">
			</td>
			<td>
				<cfsavecontent variable="alert"><cf_get_lang no ='1331.Siparişi Bitir'></cfsavecontent>
                <input type="submit" name="order_submit_button" id="order_submit_button" onclick="return kontrol();" value="<cfoutput>#alert#</cfoutput>">
				<cfsavecontent variable="alert2"><cf_get_lang no ='1552.Sepete Dön'></cfsavecontent>
				<cfif isdefined('attributes.is_back_basket') and attributes.is_back_basket eq 1>
					<input type="button" onclick="kontrol_page();" value="<cfoutput>#alert2#</cfoutput>">
				</cfif>
			</td>
		</cfif>
	</tr>
</table>
<br/>

<!--- 3d silmeyin fatih --->
<input type="hidden" value="" name="md" id="md" />
<input type="hidden" value="" name="oid" id="oid" />
<input type="hidden" value="" name="amount" id="amount" />
<input type="hidden" value="" name="taksit" id="taksit" />
<input type="hidden" value="" name="xid" id="xid" />
<input type="hidden" value="" name="eci" id="eci" />
<input type="hidden" value="" name="cavv" id="cavv" />
<input type="hidden" value="" name="mdstatus" id="mdstatus" />
<input type="hidden" value="" name="error_code" id="error_code" />

<script type="text/javascript">
	function dis_buttons()
	{
		if(document.getElementById('is_company0').checked == false)
		{
			document.getElementById('comp_info').style.display = 'none';
		}
		else
		{
			document.getElementById('comp_info').style.display = '';
		}
	}
	
	function show_hide_joker_vada(checked){
		if(checked){ 
			goster(_show_joker_vada_);
			open_joker_vada();
		}	
		else 
			gizle(_show_joker_vada_);
	}
	function kontrol_cardno(limit_info)
	{  
		if(limit_info == undefined)
		{  
			document.getElementById('card_no').value = document.getElementById('dsp_card_no').value; 
			document.getElementById('cvv_no').value = document.getElementById('dsp_cvv_no').value;
		}
		else
		{  
			document.getElementById('lim_card_no').value = document.getElementById('lim_dsp_card_no').value;
			document.getElementById('lim_cvv_no').value = document.getElementById('lim_dsp_cvv_no').value;
		}
	}
	function kontrol_page()
	{
		window.location.href="<cfoutput>#request.self#?fuseaction=objects2.list_basket</cfoutput>";
	}
	function get_card_no(ivr_info,limit_info)
	{  
		if(limit_info == 0)
		{
			if(ivr_info != 0)
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&ivr_info='+ivr_info+'&consumer_id='+document.getElementById('consumer_id').value,'show_member_card');
			else
			{
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&consumer_cc_id='+document.getElementById('member_credit_card').value,'show_member_card');
				<cfelse>
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&company_cc_id='+document.getElementById('member_credit_card').value,'show_member_card');
				</cfif>
			}
		}
		else
		{
			if(ivr_info != 0)
				AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&limit_info='+limit_info+'&ivr_info='+ivr_info+'&consumer_id='+document.getElementById('consumer_id').value,'show_member_card');
			else
			{
				<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&limit_info='+limit_info+'&consumer_cc_id='+document.getElementById('lim_member_credit_card').value,'show_member_card');
				<cfelse>
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_dsp_credit_card</cfoutput>&limit_info='+limit_info+'&company_cc_id='+document.getElementById('lim_member_credit_card').value,'show_member_card');
				</cfif>
			}
		}
	}
	function address_sonuc(id_,type_)
	{
		address_keyword = document.getElementById('address_keyword').value;
		if(address_keyword=='')
		{
			alert("<cf_get_lang no='68.Adres arama alanı dolu olmalıdır'>");
		}
		else
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_member_address&keyword_='+address_keyword+'&_id='+id_+'&_type='+type_</cfoutput>,'SHOW_ADDRESS_PAGE');
	}
	
	//secilen sanal posa göre ödeme tiplerini getirir FA
	function listAccounts()
	{	
		var pos_type_ = document.getElementById('pos_type_id').value;
		if (pos_type_ != undefined)
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_credit_accounts_list_ajax&type_=1&nettotal='+document.getElementById('nettotal').value+'<cfif get_ins_products.recordcount>&is_ins_pay=1</cfif><cfif isdefined('attributes.order_from_basket_express')>&order_from_basket_express=#attributes.order_from_basket_express#</cfif><cfif isdefined('attributes.xml_reload')>&xml_reload=#attributes.xml_reload#</cfif><cfif isdefined('attributes.is_basis_of_receiving')>&is_basis_of_receiving=#attributes.is_basis_of_receiving#</cfif>&claim_info=#claim_info#&IS_INSTALMENT_INFO=#get_credit.IS_INSTALMENT_INFO#<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif><cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>&partner_id=#attributes.partner_id#</cfif><cfif isdefined('attributes.company_id') and len(attributes.company_id)>&company_id=#attributes.company_id#</cfif><cfif isDefined("attributes.campaign_id") and len(attributes.campaign_id)>&campaing_id=#attributes.campaign_id#</cfif><cfif isdefined("attributes.order_id_info") and len(attributes.order_id_info)>&order_id_info=#order_id_info#</cfif><cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>&action_to_account_id=#attributes.action_to_account_id#</cfif><cfif isDefined("camp_id_info") and len(camp_id_info)>&camp_id_info=#camp_id_info#</cfif><cfif isdefined("attributes.is_view_commision")>&is_view_commision=#attributes.is_view_commision#</cfif><cfif isdefined("attributes.is_view_multiplier")>&is_view_multiplier=#attributes.is_view_multiplier#</cfif>&pos_type_id='+pos_type_+'','list_accounts',1)</cfoutput>;
		}
	}
	//limit asimi secilen sanal posa göre ödeme tiplerini getirir FA
	function limListAccounts()
	{	
		var pos_type_ = document.getElementById('lim_pos_type_id').value;
		if (pos_type_ != undefined)
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_credit_accounts_list_ajax&type_=2&nettotal='+document.getElementById('nettotal').value+'<cfif isdefined('attributes.order_from_basket_express')>&order_from_basket_express=#attributes.order_from_basket_express#</cfif><cfif isdefined('attributes.xml_reload')>&xml_reload=#attributes.xml_reload#</cfif><cfif isdefined('attributes.is_basis_of_receiving')>&is_basis_of_receiving=#attributes.is_basis_of_receiving#</cfif>&claim_info=#claim_info#&IS_INSTALMENT_INFO=#get_credit.IS_INSTALMENT_INFO#<cfif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>&consumer_id=#attributes.consumer_id#</cfif><cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>&partner_id=#attributes.partner_id#</cfif><cfif isdefined('attributes.company_id') and len(attributes.company_id)>&company_id=#attributes.company_id#</cfif><cfif isDefined("attributes.campaign_id") and len(attributes.campaign_id)>&campaing_id=#attributes.campaign_id#</cfif><cfif isdefined("attributes.order_id_info") and len(attributes.order_id_info)>&order_id_info=#order_id_info#</cfif><cfif isDefined("attributes.action_to_account_id") and len(attributes.action_to_account_id)>&action_to_account_id=#attributes.action_to_account_id#</cfif><cfif isDefined("camp_id_info") and len(camp_id_info)>&camp_id_info=#camp_id_info#</cfif><cfif isdefined("attributes.is_view_commision")>&is_view_commision=#attributes.is_view_commision#</cfif><cfif isdefined("attributes.is_view_multiplier")>&is_view_multiplier=#attributes.is_view_multiplier#</cfif>&pos_type_id='+pos_type_+'','lim_list_accounts',1)</cfoutput>;
		}
	}
	
	function next_orders(type)
	{	
		<cfif isdefined('attributes.is_attachment') and attributes.is_attachment eq 1 and isdefined('session.pp.userid')>
			if(document.getElementById('project_attachment').value == '')
			{
				alert("<cf_get_lang no='69.Bağlantı seçmelisiniz'>");
				return false;
			}	
		</cfif>
		
		<cfif isdefined('attributes.is_order_checked') and attributes.is_order_checked eq 1>
			if(document.getElementById('urun_kontrol')!=undefined && document.getElementById('urun_kontrol').value == 0)
			{
				alert("<cf_get_lang_main no='815.Ürün Seçmelisiniz !'>");
				return false;
			}	
		</cfif>
		<cfif (isdefined('attributes.is_ship_address') and attributes.is_ship_address eq 0) and (isdefined('attributes.is_tax_address') and attributes.is_tax_address eq 0)>
			alert("Lütfen fatura veya teslim adresinden en az birini seçiniz!");
			return false;
		</cfif>
		//standart sepet ile parca talepli sepeti ayiriyoruz
		is_part_ok_ = 0;
		is_no_part_ok_ = 0;
		if(document.getElementById('is_part')!=undefined && document.getElementById('is_part').length!=undefined)
		{
			for(var j=0;j<document.getElementById('is_part').length;j++)
			{
				if(document.getElementById('is_checked')[j].checked==true && document.getElementById('is_part')[j].value == '1')
					is_part_ok_ = 1;
				else if(document.getElementById('is_checked')[j].checked==true && document.getElementById('is_part')[j].value == '0')
					is_no_part_ok_ = 1;
			}
		}
		
		if(is_part_ok_ == '1' && is_no_part_ok_ == '1')
		{
			alert("<cf_get_lang no ='70.Standart Satınalma ile Parça Talebini Aynı Siparişte Toplayamazsınız'>");
			return false;
		}
		
		/*if(document.getElementById('project_attachment')!=undefined && document.getElementById('project_attachment').options[document.getElementById('project_attachment').selectedIndex].value!='')
		{
			{	
				var prj_id_ = document.getElementById('project_attachment').value;
				if(!check_member_project_risk_limit(prj_id_)) return false;
			}
		}*/
		var kontrol=0;
		if(type == 1)
		{
			<cfif isdefined('attributes.is_order_ref_no') and attributes.is_order_ref_no eq 1>
				var sales_zone_sel = 0; 
				if(document.list_basketww.sales_zone.length != undefined) 
				{
					for(var k=0;k<document.list_basketww.sales_zone.length;k++)
						if(document.list_basketww.sales_zone[k].checked == true) var sales_zone_sel = 1;
				}
		
				if(sales_zone_sel == 0)
				{
					alert("<cf_get_lang no ='261.Satış bölgesi seçmelsiniz!'>");
					return false;
				}							
			</cfif>
			<cfif isdefined('attributes.is_order_info_file') and len(attributes.is_order_info_file)>
				if(!order_info_control())
				{
					return false;
				}
			</cfif>

			if(document.list_basketww.ship_address_row!=undefined && document.list_basketww.ship_address_row.length>=1)
			{
				if(document.getElementById('is_same_tax_ship') != undefined && document.getElementById('is_same_tax_ship').checked == false)
				{
					for(var j=0;j<document.list_basketww.ship_address_row.length;j++)
					{
						if(document.list_basketww.ship_address_row[j].checked==true)
						{
							<cfif isdefined('attributes.is_new_ship_address') and attributes.is_new_ship_address eq 1>
								if(document.list_basketww.ship_address_row[document.list_basketww.ship_address_row.length-1].checked==true)
								{
									if(document.getElementById('ship_address_country0').value.length==0)
									{
										alert("<cf_get_lang no ='1092.Teslim Ülke Giriniz'>!");
										return false;
									}
									
									if(document.getElementById('ship_address_city0').value.length==0)
									{
										alert("<cf_get_lang no ='1093.Teslim Şehri Giriniz'>!");
										return false;
									}
									
									<cfif isDefined('attributes.is_county_required') and attributes.is_county_required eq 1>
										if(document.getElementById('ship_address_county0').value.length==0)
										{
											alert("<cf_get_lang no ='1094.Teslim İlçe Giriniz'>!");
											return false;
										}
									</cfif>
									
									if(document.getElementById('ship_district_id0') != undefined && document.getElementById('ship_district_id0').value=="")
									{
										alert("<cf_get_lang no ='1303.Teslim Mahalle Giriniz'> !");
										return false;
									}
									if(document.getElementById('ship_address0') != undefined && document.getElementById('ship_address0').value.length==0)
									{
										alert("<cf_get_lang no ='1096.Teslim Adresi Giriniz'>!");
										return false;
									}
								}
							</cfif>
							kontrol=1;
							break;
						}
					}
				}
			}
			else if(document.list_basketww.ship_address_row!=undefined && document.list_basketww.ship_address_row.length == undefined)
			{
				if(document.getElementById('is_same_tax_ship') == undefined || (document.getElementById('is_same_tax_ship') != undefined && document.getElementById('is_same_tax_ship').checked == false))
				{
					<cfif isdefined('attributes.is_new_ship_address') and attributes.is_new_ship_address eq 1>
						if(document.getElementById('ship_address_country0').value.length==0)
						{
							alert("<cf_get_lang no ='1092.Teslim Ülke Giriniz'>!");
							return false;
						}
						
						if(document.getElementById('ship_address_city0').value.length==0)
						{
							alert("<cf_get_lang no ='1093.Teslim Şehri Giriniz'>!");
							return false;
						}
						
						<cfif isDefined('attributes.is_county_required') and attributes.is_county_required eq 1>
							if(document.getElementById('ship_address_county0').value.length==0)
							{
								alert("<cf_get_lang no ='1094.Teslim İlçe Giriniz'>!");
								return false;
							}
						</cfif>
						
						if(document.list_basketww.ship_address0 != undefined && document.getElementById('ship_address0').value.length==0)
						{
							alert("<cf_get_lang no ='1096.Teslim Adresi Giriniz'>!");
							return false;
						}
					<cfelse>
						if(document.getElementById('ship_address_country1').value.length==0)
						{
							alert("<cf_get_lang no ='1092.Teslim Ülke Giriniz'>!");
							return false;
						}
						
						if(document.getElementById('ship_address_city1').value.length==0)
						{
							alert("<cf_get_lang no ='1093.Teslim Şehri Giriniz'>!");
							return false;
						}
						
						<cfif isDefined('attributes.is_county_required') and attributes.is_county_required eq 1>
							if(document.getElementById('ship_address_county1').value.length==0)
							{
								alert("<cf_get_lang no ='1094.Teslim İlçe Giriniz'>!");
								return false;
							}
						</cfif>
						
						if(document.getElementById('ship_address1') != undefined && document.getElementById('ship_address1').value.length==0)
						{
							alert("<cf_get_lang no ='1096.Teslim Adresi Giriniz'>!");
							return false;
						}
					</cfif>
				}
				kontrol=1;
			}
			else if(document.list_basketww.ship_address_row == undefined)
			{
				alert("Lütfen bir teslim adresi giriniz!");
				return false;				
			}
			if(document.getElementById('is_same_tax_ship') != undefined && document.getElementById('is_same_tax_ship').checked == false)
			{
				if(kontrol==0)
				{
					alert("<cf_get_lang no ='1097.Teslim Adres Bilgilerini Giriniz'>!");
					return false;
				}
			}

			<cfif isdefined('attributes.is_tax_address') and attributes.is_tax_address eq 2>
				<cfif isdefined('attributes.is_new_tax_address') and attributes.is_new_tax_address eq 1>
					var uyarim_ = 1;
					for (i=0; i < document.list_basketww.tax_address_row.length; i++)
					{
						if(document.list_basketww.tax_address_row[i].checked == true)
							var uyarim_ = 0;
					}
					if(uyarim_ == 1)
					{
						alert('Lütfen Fatura Adresi Seçimi Yapınız!');
						return false;	
					}
					if(document.list_basketww.tax_address_row[0].checked == true)
					{
						if(document.getElementById('tax_address_city-1').value == '')
						{
							alert("Lütfen Fatura Adresi İçin Şehir Tanımlayınız!");
							return false;
						}
					}
					if(document.getElementById('taxaddress0').style.display == '')
					{
						if(document.getElementById('tax_address_country0').value.length==0)
						{
							alert("Lütfen Fatura Adresi İçin Ülke Giriniz!");
							return false;
						}
						
						if(document.getElementById('tax_address_city0').value.length==0)
						{
							alert("Lütfen Fatura Adresi İçin Şehir Giriniz!");
							return false;
						}
						
						if(document.getElementById('tax_address_county0').value.length==0)
						{
							alert("Lütfen Fatura Adresi İçin İlçe Giriniz!");
							return false;
						}
						if(document.getElementById('tax_address0') != undefined && document.getElementById('tax_address0').value.length==0)
						{
							alert("Lütfen Fatura Adresi İçin Adres Alanı Giriniz!");
							return false;
						}
						
						if(document.getElementById('is_company0').checked == 1)
						{
							if(document.getElementById('company_name0').value.length == 0)
							{
								alert("<cf_get_lang no ='538.Lütfen Şirket Adı Giriniz'>");
								return false;
							}
							if(document.getElementById('tax_office0').value.length == 0)
							{
								alert("<cf_get_lang no ='507.Lütfen Vergi Dairesi Adı Giriniz'>");
								return false;
							}
							if(document.getElementById('tax_no0').value.length == 0)
							{
								alert("<cf_get_lang no ='508.Lütfen Vergi Numarası Giriniz'>");
								return false;
							}
	
						}
						kontrol=1;
					}
					if(document.getElementById('is_same_tax_ship') != undefined && document.getElementById('is_same_tax_ship').checked == false)
					{
						if(kontrol==0)
						{
							alert("<cf_get_lang no ='1097.Teslim Adres Bilgilerini Giriniz'>!");
							return false;
						}
					}
				</cfif>
			</cfif>
			if(document.getElementById('project_attachment')!=undefined && document.list_basketww.project_attachment.options[document.list_basketww.project_attachment.selectedIndex].value!='')
			{
				/*{	
					var prj_id_ = document.getElementById('project_attachment').value;
					if(!check_member_project_risk_limit(prj_id_)) return false;
				}*/
				document.getElementById('project_attachment').disabled = true;
			}

			gizle(teslimat_info);
			gizle(teslimat_devam);
			goster(sevkiyat_info);
			goster(sevkiyat_devam);
			<cfif isdefined("attributes.default_ship_method_id") and len(attributes.default_ship_method_id)>
				<cfoutput>
					document.getElementById('ship_method_id').value = "#attributes.default_ship_method_id#";
					change_cargo_info("#attributes.default_ship_method_id#");
				</cfoutput>
			</cfif>
		}
		else if(type == 2)
		{
			if(document.getElementById('ship_method_id').value == '')
			{
				alert("<cf_get_lang no ='72.Sevkiyat Şekli Seçmelisiniz!'>");
				return false;
			}
			
			if(document.getElementById('cargo_kontrol').value=='0')
			{
				alert("<cf_get_lang no ='73.Kargo Firması Seçmelisiniz!'>");
				return false;
			}
			
			gizle(sevkiyat_info);
			gizle(sevkiyat_devam);
			goster(pay_info);
			goster(odeme_devam);
		}
		else if(type == 3)
		{
			if(document.getElementById('project_attachment')!=undefined && document.list_basketww.project_attachment.options[document.list_basketww.project_attachment.selectedIndex].value!='')
			{
				{	
					var prj_id_ = document.getElementById('project_attachment').value;
					if(!check_member_project_risk_limit(prj_id_)) return false;
				}
				// document.getElementById('project_attachment').disabled = true;
			}

			<cfif isdefined('attributes.is_order_content_template') and attributes.is_order_content_template eq 1>
				if(document.getElementById('order_contract').value == 0)
				{
					var pay_id ='';
					var address_popup = 0;
					if(document.getElementById('action_to_account_id') != undefined && document.getElementById('action_to_account_id').length != undefined)
					{
						for(var j=0;j<document.getElementById('action_to_account_id').length;j++)
						{
						if(document.getElementById('action_to_account_id')[j].checked)
							var pay_id = document.getElementById('action_to_account_id')[j].value;
						}
					}
					else
					{
						if(document.getElementById('action_to_account_id') != undefined && document.getElementById('action_to_account_id').checked)
							var pay_id = document.getElementById('action_to_account_id').value;
					}
					if(pay_id =='')
					{
						if(document.getElementById('action_to_account_id') != undefined && document.getElementById('action_to_account_id').checked)
							var pay_id = document.getElementById('lim_action_to_account_id').value;
					}
					
					if(document.list_basketww.ship_address_row.length != undefined)
					{
						for( var j=0;j<document.list_basketww.ship_address_row.length;j++)
						{
							if(document.list_basketww.ship_address_row[j].checked==true)
							{
								address_popup = 1;
								kkkk = document.list_basketww.ship_address_row[j].value;
								var country_ = document.getElementById('ship_address_country'+kkkk).value;
								var city_ = document.getElementById('ship_address_city'+kkkk).value;
								var county_ = document.getElementById('ship_address_county'+kkkk).value;
								var semt_ = document.getElementById('ship_address_county'+kkkk).value;
								if(j==0)
								{
									<cfif attributes.is_detail_address eq 0>
										var adres_ = document.getElementById('ship_address0').value;
									<cfelse>
										var adres_ = document.getElementById('ship_main_street0').value + ' ' + document.getElementById('ship_street0').value + ' ' + document.getElementById('ship_work_doorno0').value;
									</cfif>
								}
								else
									var adres_ = document.getElementById('ship_address'+kkkk).value;

								windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_order_contract&paymethod_type='+pay_id+'&country='+country_+'&city='+city_+'&county='+county_+'&semt='+semt_+'&adres='+adres_,'medium');
							}
						}
					}
					else
					{
						if(document.document.list_basketww.ship_address_row.checked == true)
							{
								address_popup = 1;
								kkkk = document.list_basketww.ship_address_row.value;
								var country_ = document.getElementById('ship_address_country'+kkkk).value;
								var city_ = document.getElementById('ship_address_city'+kkkk).value;
								var county_ = document.getElementById('ship_address_county'+kkkk).value;
								var semt_ = document.getElementById('ship_address_county'+kkkk).value;
								<cfif attributes.is_detail_address eq 0>
									var adres_ = document.getElementById('ship_address'+kkkk).value;
								<cfelse>
									var adres_ = document.getElementById('ship_main_street'+kkkk).value + ' ' + document.getElementById('ship_street'+kkkk).value + ' ' + document.getElementById('ship_work_doorno'+kkkk).value;
								</cfif>
								windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.popup_order_contract&paymethod_type='+pay_id+'&country='+country_+'&city='+city_+'&county='+county_+'&semt='+semt_+'&adres='+adres_,'medium');
							}
					}
					
					if(document.getElementById('ship_address_city0') !=undefined && document.getElementById('ship_address_city0').value != '' && address_popup == 0)
					{
						address_popup = 1;
						windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_order_contract&paymethod_type=</cfoutput>'+pay_id+'&country='+document.getElementById('ship_address_country0').value+'&city='+document.getElementById('ship_address_city0').value+'&county='+document.getElementById('ship_address_county0').value+'&semt='+document.getElementById('ship_address_semt0').value+'&postcode='+document.getElementById('ship_address_postcode0').value+'&adres='+document.getElementById('ship_address0').value,'medium');
					}
					if(address_popup == 0)
						windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_order_contract&paymethod_type=</cfoutput>'+pay_id,'medium');
					return false;
				}
			</cfif>
			
			<cfif (isdefined("attributes.is_view_detail") and attributes.is_view_detail eq 1) or not isdefined("attributes.is_view_detail")>
				<cfif get_havale.recordcount> 
					if(document.list_basketww.paymethod_type[0] != undefined && document.list_basketww.paymethod_type[0].checked)
					{
						bank_acc_info.innerHTML = '';
						bank_acc_info.style.display = '';
						bank_acc_info.innerHTML = '<b>Banka Adı ve Şubesi : </b>' +  list_getat(list_getat(document.getElementById('account_id').value,1,','),8,'-') +' - ' + list_getat(document.getElementById('account_id').value,7,'-') +' <br/><b>Şube No : </b>' + list_getat(document.getElementById('account_id').value,4,'-') +'<br/><b>Hesap Numarası : </b>'+ list_getat(document.getElementById('account_id').value,2,',')+'<br/><b>IBAN No : </b> ' + list_getat(document.getElementById('account_id').value,6,'-')+'<br/><b>EFT İşlemleri İçin Alıcı Ünvanı : </b><cfif isdefined('session.pp.userid')><cfoutput>#session.pp.our_name#</cfoutput><cfelseif isDefined('session.ww.userid')><cfoutput>#session.ww.our_name#</cfoutput></cfif>	<br/><br/><b>Lütfen EFT/Havale Açıklamasını Sipariş Numarası - Ad Soyad Şeklinde Belirtiniz!</b>';			
					}else
					{
						bank_acc_info.style.display = 'none';
					}
				</cfif>
			</cfif>	
			// odeme yöntemi
			kontrol=0;
			if(document.list_basketww.paymethod_type[0] != undefined && document.list_basketww.paymethod_type.checked==true)
				kontrol=1;
			
			if(document.list_basketww.paymethod_type.length == 1)
			//if(document.getElementById('paymethod_type').value != undefined)//tek ödeme yöntemli ve çoklular için 2 blok yapıldı.
			{
				if(document.list_basketww.paymethod_type.checked == true)
				{
					if(document.getElementById('paymethod_type').value == 2)//Kredi kartı ile ödeme yaparsa
					{
						if(document.getElementById('pos_type_id').value == "")
						{
							alert("<cf_get_lang_main no ='1528.Lütfen Banka Seçiniz'>");
							return false;
						}
						if(document.getElementById('action_to_account_id') == undefined)
						{
							alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
							return false;
						}
						if(document.getElementById('card_no').value == "")
						{
							alert("<cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!");
							return false;
						}
						if(document.getElementById('cvv_no').value == "")
						{
							alert("<cf_get_lang no ='1098.CVV No Giriniz'>!");
							return false;
						}
						if(document.getElementById('credit_card_rules') != undefined && document.getElementById('credit_card_rules').checked == false)
						{
							alert("<cf_get_lang no ='74.Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz'> !");
							return false;
						}
						if(document.getElementById('process_cat_rev').value == "" || document.getElementById('process_type').value == "")
						{
							alert("<cf_get_lang no ='1099.Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız'>!");
							return false;
						}
		
						if(document.list_basketww.action_to_account_id.length != undefined)
						{
							var uyari_ = 1;
							for (i=0; i < document.list_basketww.action_to_account_id.length; i++)
							{
								if(document.list_basketww.action_to_account_id[i].checked == true)
									var uyari_ = 0;
							}
							if(uyari_ == 1)
							{
								alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
								
						}
						else
						{
							if(document.getElementById('action_to_account_id').checked == false)
							{
								alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
						}
						
						if(parseFloat('<cfoutput>#claim_info#</cfoutput>') > parseFloat(document.getElementById('sales_credit_old').value))
						{
							if(confirm("<cf_get_lang no ='75.Alacak Bakiyeniz Sipariş Tutarınızdan Fazla. Kredi Kartıyla İşleme Devam Etmek İstiyor musunuz ?'>"))
								var a = 1;
							else
								return false;
						}
					}
					if(document.getElementById('paymethod_type').value == 4)//Kredi kartı ile ödeme yaparsa
					{
						if(document.getElementById('lim_pos_type_id').value == "")
						{
							alert("<cf_get_lang_main no ='1528.Lütfen Banka Seçiniz'>");
							return false;
						}
						if(document.getElementById('lim_action_to_account_id') == undefined)
						{
							alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
							return false;
						}
						if(document.getElementById('lim_card_no').value == "")
						{
							alert("<cf_get_lang no='519.Lütfen Geçerli Kredi Kartı Numarasını Giriniz'>!");
							return false;
						}
						if(document.getElementById('lim_cvv_no').value == "")
						{
							alert("<cf_get_lang no ='1098.CVV No Giriniz'>!");
							return false;
						}
						if(document.getElementById('lim_credit_card_rules') != undefined && document.getElementById('lim_credit_card_rules').checked == false)
						{
							alert("<cf_get_lang no ='74.Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz'>");
							return false;
						}
						if(document.getElementById('process_cat_rev').value == "" || document.getElementById('process_type').value == "")
						{
							alert("<cf_get_lang no ='1099.Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız'>!");
							return false;
						}

						if(document.getElementById('lim_action_to_account_id').length != undefined)
						{
							var uyari_ = 1;
							for (i=0; i<document.getElementById('lim_action_to_account_id').length; i++)
							{
								if(document.getElementById('lim_action_to_account_id')[i].checked == true) var uyari_ = 0;
							}
							if(uyari_ == 1)
							{
								alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
								
						}
						else
						{
							if(document.getElementById('lim_action_to_account_id').checked == false)
							{
								alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
						}
					}
					if(document.getElementById('paymethod_type').value == 1)//Havale ile ödeme yaparsa
					{
						x = document.getElementById('account_id').selectedIndex;
						if (document.getElementById('account_id')[x].value == "")
						{
							alert("<cf_get_lang no ='1101.Hesap Seçiniz'>!");
							return false;
						}
						if(document.getElementById('process_type_talimat').value == "" || document.getElementById('process_cat_talimat').value == "")
						{
							alert("<cf_get_lang no ='1102.Havale İşlem Tipi Tanımlayınız'>!");
							return false;
						}
						kontrol=1;
					}
					if(document.getElementById('paymethod_type').value == 3)//Risk limiti ile ödeme yaparsa
					{
						//alert(document.list_basketww.kalan_risk_info.value);
						if(document.getElementById('kalan_risk_info').value < 0)
							alert("<cf_get_lang no ='1103.Risk Limitiniz'>: " +commaSplit(document.getElementById('kalan_risk_info').value));
					}
					kontrol=1;
				}
			}
			<cfif isdefined('attributes.is_money_credit_use') and attributes.is_money_credit_use eq 1>
				else if(document.getElementById('money_credit_id').checked == true && (document.getElementById('money_credit_value').value < commaSplit(document.getElementById('total_discount').value))) kontrol=1;
			</cfif>
			else     
			{
				for(var j=0;j<document.list_basketww.paymethod_type.length;j++)
				{
					if(document.list_basketww.paymethod_type[j].checked==true)
					{
						if(document.list_basketww.paymethod_type[j].value == 2)//Kredi kartı ile ödeme yaparsa
						{
							if(document.getElementById('pos_type_id').value == "")
							{
								alert("<cf_get_lang_main no ='1528.Lütfen Banka Seçiniz'>");
								return false;
							}    
							if(document.getElementById('action_to_account_id') == undefined)
							{
								alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
							if(document.getElementById('card_no').value == "")
							{
								alert("<cf_get_lang no ='1104.Kredi Kartı No Giriniz'>!");
								return false;
							}
							if(document.getElementById('cvv_no').value == "")
							{
								alert("<cf_get_lang no ='1098.CVV No Giriniz'>!");
								return false;
							}   
							if(document.getElementById('credit_card_rules') != undefined && document.getElementById('credit_card_rules').checked == false)
							{
								alert("<cf_get_lang no ='74.Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz'>");
								return false;
							}
							if(document.getElementById('process_cat_rev').value == "" || document.getElementById('process_type').value == "")
							{
								alert("<cf_get_lang no ='1099.Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız'>!");
								return false;
							}   
							
							var credit_selected = 0;  
							
							if(document.list_basketww.action_to_account_id.length == undefined)
							{
								if(document.getElementById('action_to_account_id').checked == true)
									var credit_selected = 1;
							}
							else
							{
								for(var k=0;k<document.list_basketww.action_to_account_id.length;k++)
								{
									if(document.list_basketww.action_to_account_id[k].checked == true)
										var credit_selected = 1;
								}
							}
							
							if(credit_selected == 0)
							{
								alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
						
							if(parseFloat('<cfoutput>#claim_info#</cfoutput>') > parseFloat(document.getElementById('sales_credit_old').value))
							{
								if(confirm("<cf_get_lang no ='75.Alacak Bakiyeniz Sipariş Tutarınızdan Fazla. Kredi Kartıyla İşleme Devam Etmek İstiyor musunuz ?'>"))
									var a = 1;
								else
									return false;
							}
						}    
						if(document.list_basketww.paymethod_type[j].value == 4)//Kredi kartı ile ödeme yaparsa
						{
							if(document.getElementById('lim_pos_type_id').value == "")
							{
								alert("<cf_get_lang_main no ='1528.Lütfen Banka Seçiniz'>");
								return false;
							}  
							if(document.getElementById('lim_action_to_account_id') == undefined)
							{
								alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
							if(document.getElementById('lim_card_no').value == "")
							{
								alert("<cf_get_lang no ='1104.Kredi Kartı No Giriniz'>!");
								return false;
							}
							if(document.getElementById('lim_cvv_no').value == "")
							{
								alert("<cf_get_lang no ='1098.CVV No Giriniz'>!");
								return false;
							}   
							if(document.getElementById('lim_credit_card_rules') != undefined && document.getElementById('lim_credit_card_rules').checked == false)
							{
								alert("<cf_get_lang no ='74.Devam Etmek İçin Kredi Kartı Kullanım Şartlarını Kabul Etmelisiniz'>");
								return false;
							}
							if(document.getElementById('process_cat_rev').value == "" || document.getElementById('process_type').value == "")
							{
								alert("<cf_get_lang no ='1099.Kredi Kartı Tahsilat İşlem Tipi Tanımlayınız'>!");
								return false;
							}
							   
							var lim_credit_selected = 0;  
							
							if(document.list_basketww.lim_action_to_account_id.length == undefined)
							{
								if(document.getElementById('lim_action_to_account_id').checked == true)
									var lim_credit_selected = 1;
							}
							else
							{
								for(var k=0;k<document.list_basketww.lim_action_to_account_id.length;k++)
								{
									if(document.list_basketww.lim_action_to_account_id[k].checked == true)
										var lim_credit_selected = 1;
								}
							}
							
							if(lim_credit_selected == 0)
							{
								alert("<cf_get_lang no ='1100.Kredi Kartı Ödeme Yöntemi Seçiniz'>!");
								return false;
							}
						}
						if(document.list_basketww.paymethod_type[j].value == 1)//Havale ile ödeme yaparsa
						{
							x = document.getElementById('account_id').selectedIndex;
							if (document.getElementById('account_id')[x].value == "")
							{
								alert("<cf_get_lang no ='1101.Hesap Seçiniz'>!");
								return false;
							}    
							if(document.getElementById('process_type_talimat').value == "" || document.getElementById('process_cat_talimat').value == "")
							{
								alert("<cf_get_lang no ='1102.Havale İşlem Tipi Tanımlayınız'>!");
								return false;
							}
						}
						<cfif isDefined("session.pp")>  
							if(document.list_basketww.paymethod_type[j].value == 3)//Risk limiti ile ödeme yaparsa
							{
								if(document.getElementById('kalan_risk_info').value < 0)
									alert("<cf_get_lang no ='1103.Risk Limitiniz'>: " +commaSplit(document.getElementById('kalan_risk_info').value));
							}
						</cfif>
						kontrol=1;
						break
					}
				}
			}

			var selctd = 0; 
			if(document.list_basketww.paymethod_type.length != undefined) 
			{
				for(var k=0;k<document.list_basketww.paymethod_type.length;k++)
					if(document.list_basketww.paymethod_type[k].checked == true) var selctd = 1;
			}
			else
				if(document.getElementById('paymethod_type').checked == true) var selctd = 1;	

			if(document.getElementById('is_great_gift').value == 1 || document.getElementById('is_great_point').value == 1) selctd = 1;
			
			if(selctd == 0)
			{
				alert("<cf_get_lang_main no ='615.Ödeme Yöntemi Seçiniz'>!");
				return false;
			}
			
			<cfif isdefined('attributes.is_door_paymethod_multiple') and attributes.is_door_paymethod_multiple eq 1>
				var count = 0;
				if(pay_type_door.style.display == '')
				{
					<cfif get_door_paymethod.recordcount eq 1>  
						if(document.getElementById('paymethod_id_7').checked == true)
							{
								count = count + 1;
							}
					<cfelse>
						for(i=0;i<<cfoutput>#get_door_paymethod.recordcount#</cfoutput>;i++)
						{
							if(document.list_basketww.paymethod_id_7[i].checked == true)
							{
								count = count + 1;
							}
						}
					</cfif>
					if(count != 1)
					{
						alert('Lütfen Kapıda Ödeme Çeşidi Seçiniz');
						return false;
					}
				}
			</cfif>
			
			<cfif isDefined("session.pp")>
				<cfif isdefined("attributes.is_view_last_user_price") and attributes.is_view_last_user_price eq 1>
					<cfif get_accounts.recordcount>   
						if(document.getElementById('is_price_standart').checked)
							if(filterNum(document.getElementById('price_standart_dsp').value) > filterNum(document.getElementById('price_standart_old').value))
							{
								alert("<cf_get_lang no ='1105.Son Kullanıcı Fiyatından Daha Yüksek Tutar Giremezsiniz'>!");
								return false;
							}
						if(document.getElementById('is_price_standart').checked && (document.getElementById('consumer_info') != undefined && document.getElementById('consumer_info').checked))    
						{
							if(document.getElementById('member_name').value == "" || document.getElementById('member_surname').value == "" || document.getElementById('address').value=="")
								{
									alert("<cf_get_lang no ='1106.Müşteri İçin Ad Soyad ve Adres Bilgilerini Giriniz'>!");
									return false;
								}
							if(document.getElementById('consumer_stage').value=="")
								{
									alert("<cf_get_lang no ='1107.Bireysel Üye Süreçlerinizi Kontrol Ediniz'>!");
									return false;
								}
						}
					</cfif>
				</cfif>
			</cfif>  
			
			for(var j=0;j<document.list_basketww.paymethod_type.length;j++)
			{
				if(document.list_basketww.paymethod_type[j].checked==true && (document.list_basketww.paymethod_type[j].value == 2 || document.list_basketww.paymethod_type[j].value == 4))
				{
					account_sira = document.getElementById('account_recordcount').value;
					if(account_sira != '')
					{
						if(account_sira == 1)
						{
							var is_secure = list_getat(document.getElementById('action_to_account_id').value,8,';');
							var account_ = document.getElementById('action_to_account_id').value;
						}
						else
						{
							for(var acc_cont=0;acc_cont<account_sira;acc_cont++)
							{
								if(document.list_basketww.action_to_account_id != undefined)
								{
									if(document.list_basketww.action_to_account_id[acc_cont].checked == true)
									{
										var is_secure = eval('document.list_basketww.action_to_account_id[acc_cont]').value.split(';')[7];
										var account_ = eval('document.list_basketww.action_to_account_id[acc_cont]').value;
									}
								}
								else if(document.list_basketww.lim_action_to_account_id != undefined)
								{
									if(document.list_basketww.lim_action_to_account_id[acc_cont].checked == true)
									{
										var is_secure = eval('document.list_basketww.lim_action_to_account_id[acc_cont]').value.split(';')[7];
										var account_ = eval('document.list_basketww.lim_action_to_account_id[acc_cont]').value;
									}
								}
									
							}
						}
					}
					if (is_secure == 1)
					{
						card_no_ = document.getElementById('card_no').value;
						cvv_no_ = document.getElementById('cvv_no').value;
						exp_year_ = document.getElementById('exp_year').value;
						exp_month_ = document.getElementById('exp_month').value;
						tutar_ = document.getElementById('sales_credit_dsp').value;
						AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_form_3d&action_to_account_id='+account_+'&card_no='+card_no_+'&cvv_no='+cvv_no_+'&exp_year='+exp_year_+'&exp_month='+exp_month_+'&tutar_='+tutar_+'','ajax_form_3d',1);
					}
				}
			}

			if(document.list_basketww.order_submit_button2 != undefined)
				document.list_basketww.order_submit_button2.style.display ='none';
			if(document.list_basketww.order_submit_button != undefined)
				document.list_basketww.order_submit_button.style.display = '';
									
			gizle(pay_info);
			gizle(odeme_devam);
			goster(note_info);
			goster(buton_info);
		}
	}
	
	function back_orders(type)
	{
		if(type == 1)
		{
			gizle(sevkiyat_info);
			gizle(sevkiyat_devam);
			goster(teslimat_info);  
			<cfif not isDefined('attributes.is_attachment') or (isDefined('attributes.is_attachment') and attributes.is_attachment neq 2)>  
				if(document.getElementById('project_attachment')!=undefined)
				{
					document.getElementById('project_attachment').disabled = false;
				}
			</cfif>
			goster(teslimat_devam);
		}
		else if(type == 2)
		{
			gizle(pay_info);
			gizle(odeme_devam);
			goster(sevkiyat_info);
			goster(sevkiyat_devam);

		}
		else if(type == 3)
		{
			
			gizle(note_info);
			gizle(buton_info);
			goster(pay_info);
			goster(odeme_devam);
		}
	}

	function kontrol() 
	{	  
		if(document.getElementById('paymethod_type').value == 2)
		{
			if(document.getElementById('mdstatus').value != '' && document.getElementById('mdstatus').value != 1 && document.getElementById('mdstatus').value != 2 && document.getElementById('mdstatus').value != 3 && document.getElementById('mdstatus').value != 4)
			{
				alert('Kredi kartı işleminiz onay almamıştır. Lütfen tekrar deneyiniz.');
				gizle(note_info);
				gizle(buton_info);
				goster(pay_info);
				goster(odeme_devam);
				return false;
			}
		}
		if(document.getElementById('form_complete') == undefined)
		{
			alert("<cf_get_lang_main no ='1232.Sayfa Yükleniyor.'> <cf_get_lang_main no ='1480.Lütfen Bekleyiniz'>")
			return false;
		}
			
		<cfif isdefined('attributes.is_order_content_id') and len(attributes.is_order_content_id)><!---and isdefined("attributes.consumer_id") and len(attributes.consumer_id) and session_base.userid neq attributes.consumer_id--->	
			if(document.getElementById('order_rules').checked!=true)
			{   
				alert ("<cf_get_lang no ='77.Siparişi Koşullarını Kabul Ediyorum Seçeneğini Seçmelisiniz!'>");
				return false;
			}
		</cfif>
		<cfif isdefined('attributes.is_order_content_template') and attributes.is_order_content_template eq 1>
			if(document.getElementById('order_contract').value != 1)
			{
				alert ("<cf_get_lang no ='77.Siparişi Koşullarını Kabul Ediyorum Seçeneğini Seçmelisiniz!'>");
				windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_order_contract&paymethod_type=</cfoutput>'+document.getElementById('paymethod_type').value,'medium');
				return false;
			}
		</cfif>
		//getElementById('lim_exp_year')
		/*if(document.getElementById('sales_credit') != undefined) 
			document.getElementById('sales_credit').value = filterNum(document.getElementById('sales_credit').value);*/
		document.getElementById('ship_method_id').disabled = false;
		if(document.getElementById('exp_month') != undefined)
			document.getElementById('exp_month').disabled = false;
		if(document.getElementById('exp_year') != undefined)
			document.getElementById('exp_year').disabled = false;
		if(document.getElementById('lim_exp_month') != undefined)
			document.getElementById('lim_exp_month').disabled = false;
		if(document.getElementById('lim_exp_year') != undefined)
			document.getElementById('lim_exp_year').disabled = false;
		if(document.getElementById('joker_vada_control').value == 0 && document.getElementById('joker_vada') && document.getElementById('joker_vada').checked){//joker vada sayfası daha önce hiç açılmamış ise(ajax ile) ve  joker vada checkbox ı seçili ise..
			show_hide_joker_vada(true);
			open_joker_vada();
			return false;	
		}
		
		if(!process_cat_control()) 
		{
			return false;
		} 
		
		<cfif isdefined('attributes.is_order_last_button') and attributes.is_order_last_button eq 1> 
			if(document.list_basketww.order_submit_button != undefined)
				document.list_basketww.order_submit_button.style.display ='none';
			if(document.list_basketww.order_submit_button2 != undefined)
				document.list_basketww.order_submit_button2.style.display = '';
		</cfif> 

		if(document.getElementById('project_attachment')!=undefined)
		{
			document.getElementById('project_attachment').disabled = false;
		}
		
		if(confirm("<cf_get_lang no ='9.Siparişinizi onaylıyor musunuz?'>")); 
		else 
		{
			<cfif isdefined('attributes.is_order_last_button') and attributes.is_order_last_button eq 1> 
				if(document.list_basketww.order_submit_button != undefined)
					document.list_basketww.order_submit_button.style.display ='';
				if(document.list_basketww.order_submit_button2 != undefined)
					document.list_basketww.order_submit_button2.style.display = 'none';
			</cfif> 
			return false
		};
	}

	<cfif isdefined('attributes.is_money_credit_use') and attributes.is_money_credit_use eq 1>
		<cfoutput>
		function comp_money_cred()
		{
			if(document.getElementById('money_credit_id').checked == true)
			{
				if(parseFloat(document.getElementById('money_credit_value').value) < parseFloat(document.getElementById('tum_toplam_kdvli').value))
					add_amount = filterNum(document.getElementById('money_credit_value').value);
				else
				{
					add_amount = document.getElementById('tum_toplam_kdvli').value;
					document.getElementById('is_great_point').value = 1;
				}
				document.getElementById('price_catid_2').value = -2;
				document.getElementById('price').value = parseFloat(-1*add_amount);
				document.getElementById('price_old').value = '';
				document.getElementById('istenen_miktar').value = 1;
				document.getElementById('sid').value = '-1'; 
				document.getElementById('price_kdv').value = parseFloat(-1*add_amount);
				document.getElementById('price_money').value = '#session_base.money#';
				document.getElementById('price_standard_money').value = '#session_base.money#';
				document.getElementById('prom_id').value = '';
				document.getElementById('prom_discount').value = '';
				document.getElementById('prom_amount_discount').value = '';
				document.getElementById('prom_cost').value = '';
				document.getElementById('prom_free_stock_id').value = '';
				document.getElementById('prom_stock_amount').value = 1;
				document.getElementById('prom_free_stock_amount').value = 1;
				document.getElementById('prom_free_stock_price').value = 0;
				document.getElementById('prom_free_stock_money').value = '';
				document.getElementById('is_cargo').value = 0;
				document.getElementById('is_commission').value = 0;
				document.getElementById('is_discount').value = 1;
				//son kullanici
				document.getElementById('price_standard').value = parseFloat(-1*add_amount);
				document.getElementById('price_standard_kdv').value = parseFloat(-1*add_amount);
				<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
					<cfoutput>
						document.getElementById('consumer_id').value = '#attributes.consumer_id#';
						document.getElementById('company_id').value = '#attributes.company_id#';
						document.getElementById('partner_id').value = '#attributes.partner_id#';
						document.getElementById('order_from_basket_express').value = 1;
					</cfoutput>
				</cfif>
				satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
				AjaxFormSubmit('satir_gonder','puan_action_div',1,'','',sepet_adres_,'sale_basket_rows_list');
				clear_paymethod();
			}
			else
			{
				<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>
					adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww&is_delete_discount=1';
					AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
				</cfif>
			}
		}
		</cfoutput>
	</cfif>
	<cfif isdefined('attributes.is_gift_card_use') and attributes.is_gift_card_use eq 1>
		<cfoutput>
		function control_gift_card()
		{
			if(document.getElementById('gift_card_id').checked == true)
			{
				if(document.getElementById('gift_card_no').value == '')
				{
					alert("Hediye Çeki Kullanabilmek İçin Hediye Çeki Numarası Girmelisiniz !");
					return false;
				}
				else
				{
					var control_card_no = wrk_safe_query("control_gift_card_no","dsn3",0,document.getElementById('gift_card_no').value);
					if(control_card_no.recordcount == 0)
					{
						alert("Girdiğiniz Hediye Çeki numarası Geçerli Değil , Lütfen Numarayı Kontrol Ediniz !");
						return false;
					}
					else
					{
						<cfif isDefined('session.ww.userid')>
							var session_id = '#session.ww.userid#'

							var is_added_gift = wrk_safe_query("is_added_gift_card_no","dsn3",0,session_id);
							if(is_added_gift.recordcount > 0)
							{
								alert("Bu sepet için zaten bir hediye çeki kullanılmış!");
								return false;
							}
						</cfif>
						
						document.getElementById('gift_value').style.display = '';
						document.getElementById('gift_money_credit_id').value = control_card_no.ORDER_CREDIT_ID;
						document.getElementById('gift_card_value').value = commaSplit(control_card_no.MONEY_CREDIT);
						if(parseFloat(document.getElementById('gift_card_value').value) < parseFloat(document.getElementById('tum_toplam_kdvli').value))
							add_amount = filterNum(document.getElementById('gift_card_value').value);
						else
						{
							add_amount = document.getElementById('tum_toplam_kdvli').value;
							document.getElementById('is_great_gift').value = 1;
						}
						document.getElementById('price_catid_2').value = -2;
						document.getElementById('price').value = parseFloat(-1*add_amount);
						document.getElementById('price_old').value = '';
						document.getElementById('istenen_miktar').value = 1;
						document.getElementById('sid').value = '-1'; 
						document.getElementById('price_kdv').value = parseFloat(-1*add_amount);
						document.getElementById('price_money').value = '#session_base.money#';
						document.getElementById('price_standard_money').value = '#session_base.money#';
						document.getElementById('prom_id').value = '';
						document.getElementById('prom_discount').value = '';
						document.getElementById('prom_amount_discount').value = '';
						document.getElementById('prom_cost').value = '';
						document.getElementById('prom_free_stock_id').value = '';
						document.getElementById('prom_stock_amount').value = 1;
						document.getElementById('prom_free_stock_amount').value = 1;
						document.getElementById('prom_free_stock_price').value = 0;
						document.getElementById('prom_free_stock_money').value = '';
						document.getElementById('is_cargo').value = 0;
						document.getElementById('is_commission').value = 0;
						document.getElementById('is_discount').value = 2;
						//son kullanici
						document.getElementById('price_standard').value = parseFloat(-1*filterNum(add_amount));
						document.getElementById('price_standard_kdv').value = parseFloat(-1*filterNum(add_amount));
						
						<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
							<cfoutput>
								document.getElementById('consumer_id').value = '#attributes.consumer_id#';
								document.getElementById('company_id').value = '#attributes.company_id#';
								document.getElementById('partner_id').value = '#attributes.partner_id#';
								document.getElementById('order_from_basket_express').value = 1;
							</cfoutput>
						</cfif>
						satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
						AjaxFormSubmit('satir_gonder','puan_action_div',1,'','',sepet_adres_,'sale_basket_rows_list');
						clear_paymethod();
					}
				}
			}
			else
			{
				<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>
					adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww&is_delete_discount=2';
					AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
				</cfif>
			}
		}
		</cfoutput>
	</cfif>	
	<cfif isdefined('attributes.is_disc_coup_use') and attributes.is_disc_coup_use eq 1>
		<cfoutput>
		row_count=0;
		function add_row()
		{
			row_count = document.getElementById('record_num').value;
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("dis_table").insertRow(document.getElementById("dis_table").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);
						
			document.getElementById('record_num').value = row_count;

			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '';
					
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<input type="text" name="disc_coup_no' + row_count + '" id="disc_coup_no' + row_count + '" value="" style="width:110px;" onblur="is_equal(' + row_count + ');"><input type="hidden" name="disc_coup_money_credit_id' + row_count + '" id="disc_coup_money_credit_id' + row_count + '" value="" >';
		}
	
		function is_equal(crntrw)
		{
			for(i=1;i<=document.getElementById('record_num').value;i++)
			{
				if(i != crntrw && eval("document.getElementById('disc_coup_no" + i + "')").value == eval("document.getElementById('disc_coup_no" + crntrw + "')").value)
				{
					alert('Lütfen farklı indirim kodları giriniz!');
					return false;	
				}	
			}
		}
		function control_discount_coupon()
		{	
			if(document.getElementById('disc_coup_id').checked == true)
			{
				if(document.getElementById('disc_coup_no1').value == '')
				{
					alert("İndirim Kuponu Kullanabilmek İçin İndirim Kodu Girmelisiniz !");
					return false;
				}
				else
				{
					document.getElementById('disc_coup_value').value = 0;
					for(i=1;i<=document.getElementById('record_num').value;i++)
					{
						var params = eval("document.getElementById('disc_coup_no" + i + "')").value + '*' + document.getElementById('target_market_ids').value;
						var disc_coup_no = wrk_safe_query("control_disc_coup_no","dsn3",0,params);
						if(disc_coup_no.recordcount == 0)
						{
							alert("Girdiğiniz Hediye Çeki numarası Geçerli Değil , Lütfen Numarayı Kontrol Ediniz !");
							return false;
						}
						else
						{
							document.getElementById('disc_coup_value_tr').style.display = '';
							eval("document.getElementById('disc_coup_money_credit_id" + i + "')").value = disc_coup_no.ORDER_CREDIT_ID;
							document.getElementById('disc_coup_value').value = parseFloat(document.getElementById('disc_coup_value').value) + parseFloat(commaSplit(disc_coup_no.MONEY_CREDIT));
							if(parseFloat(filterNum(document.getElementById('disc_coup_value').value)) < parseFloat(document.getElementById('tum_toplam_kdvli').value))
								add_amount = filterNum(document.getElementById('disc_coup_value').value);
							else
								add_amount = document.getElementById('tum_toplam_kdvli').value;							
							document.getElementById('price_catid_2').value = -2;
							document.getElementById('price').value = parseFloat(commaSplit(-1 * disc_coup_no.MONEY_CREDIT));
							document.getElementById('price_old').value = '';
							document.getElementById('istenen_miktar').value = 1;
							document.getElementById('sid').value = '-1'; 
							document.getElementById('price_kdv').value = parseFloat(commaSplit(-1 * disc_coup_no.MONEY_CREDIT));
							document.getElementById('price_money').value = '#session_base.money#';
							document.getElementById('price_standard_money').value = '#session_base.money#';
							document.getElementById('prom_id').value = '';
							document.getElementById('prom_discount').value = '';
							document.getElementById('prom_amount_discount').value = '';
							document.getElementById('prom_cost').value = '';
							document.getElementById('prom_free_stock_id').value = '';
							document.getElementById('prom_stock_amount').value = 1;
							document.getElementById('prom_free_stock_amount').value = 1;
							document.getElementById('prom_free_stock_price').value = 0;
							document.getElementById('prom_free_stock_money').value = '';
							document.getElementById('is_cargo').value = 0;
							document.getElementById('is_commission').value = 0;
							document.getElementById('is_discount').value = 3;						
							//son kullanici
							document.getElementById('price_standard').value = parseFloat(-1*add_amount);
							document.getElementById('price_standard_kdv').value = parseFloat(-1*add_amount);
							<cfif isdefined('attributes.order_from_basket_express') and attributes.order_from_basket_express eq 1>
								<cfoutput>
									document.getElementById('consumer_id').value = '#attributes.consumer_id#';
									document.getElementById('company_id').value = '#attributes.company_id#';
									document.getElementById('partner_id').value = '#attributes.partner_id#';
									document.getElementById('order_from_basket_express').value = 1;
								</cfoutput>
							</cfif>
							satir_gonder.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_add_basketww_row';
							AjaxFormSubmit('satir_gonder','puan_action_div',1,'','',sepet_adres_,'sale_basket_rows_list');
							clear_paymethod();
						}
					}
				}
			}
			else
			{
				<!---<cfif isdefined("attributes.xml_reload") and attributes.xml_reload eq 1>--->
				adres_ = '<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.emptypopup_del_basketww&is_delete_discount=3';
				AjaxPageLoad(adres_,'sale_basket_rows_list','1','Hesaplanıyor!');
				<!--- </cfif> --->
			}
		}
		</cfoutput>
	</cfif>	
	function historyBack()
	{
		if(document.getElementById('error_code').value != '')
		{
			gizle(note_info);
			gizle(buton_info);
			goster(pay_info);
			goster(odeme_devam);
		}
	}
	
	function div_gizle_goster()
	{
		gizle_goster(del_date1);
		gizle_goster(del_date2);
		if(document.getElementById('is_same_tax_ship').checked == true)
		{
			gizle(shipaddress0);
		}
		else
		{
			goster(shipaddress0);	
		}
	}
	
	function butonActive()
	{
		goster(buton_info);
	}
</script>

