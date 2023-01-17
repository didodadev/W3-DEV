<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.comp_cat" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.oby" default="1">
<cfparam name="attributes.detail_type" default="1">
<cfparam name="attributes.customer_type" default="2">
<cfparam name="attributes.sales_zones" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.vade_oran" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.buy_status" default="">
<cfif isdefined("attributes.form_varmi")>
	<cfquery name="GET_COMP_REMAINDER" datasource="#DSN2#">
		SELECT 
			C.COMPANY_ID COMPANY_ID,
			ROUND(CRM.BAKIYE,3) BAKIYE,
			ROUND(CRM.BAKIYE2,3) BAKIYE2,
			C.FULLNAME FULLNAME,
			C.SALES_COUNTY SALES_COUNTY,
			C.CITY CITY,
			C.MEMBER_CODE,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_VALUE,
			CR.ACTION_DATE ACTION_DATE,
			CR.DUE_DATE,
			INV.CARD_PAYMETHOD_ID,
			INV.PAY_METHOD,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			CR.ACTION_VALUE_2,
			CR.ACTION_CURRENCY_2,
			CR.ACTION_TYPE_ID,
			ISNULL(CR.DUE_DATE,CR.ACTION_DATE) DUE_DATE2
		FROM 
			COMPANY_REMAINDER CRM,
			#dsn_alias#.COMPANY C,
			CARI_ROWS CR,
			INVOICE INV
		WHERE 
			CRM.COMPANY_ID = C.COMPANY_ID AND
		<cfif attributes.customer_type eq 1>
			CR.FROM_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID IN (49,51,54,55,59,60,601,63,64,65,68,690,691,591,592,120) AND<!--- alis faturalari --->
			ROUND(CRM.BAKIYE,3) < 0 AND
		<cfelse>
			CR.TO_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID IN (48,50,52,53,56,561,58,62,66,531,121) AND<!--- satis faturalari --->
			ROUND(CRM.BAKIYE,3) > 0 AND
		</cfif>	
			INV.INVOICE_ID = CR.ACTION_ID AND
			INV.CASH_ID IS NULL AND
			CR.ACTION_DATE < #DATEADD('d',1,now())#<!--- ileri tarihli islem varsa gelmesin --->
		<cfif len(attributes.company) and len(attributes.company_id)>
			AND C.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
			AND C.COMPANYCAT_ID IN (#attributes.comp_cat#)
		</cfif>
		<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
			AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
		</cfif> 
		<cfif isdefined("attributes.city") and len(attributes.city)>
			AND C.CITY = #attributes.city#
		</cfif>
		<cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
			AND C.SALES_COUNTY = #attributes.sales_zones#
		</cfif>
		<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
			AND C.COMPANY_VALUE_ID = #attributes.customer_value#
		</cfif>
		<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
			AND C.IS_BUYER = 1
		</cfif>
		<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
			AND C.IS_SELLER= 1
		</cfif>
		<!--- <cfif isDefined("attributes.duedate_control")><!--- vadesi ileri tarihli olanlar gelmesin seçilirse --->
			AND (CR.DUE_DATE IS NULL OR CR.DUE_DATE < #DATEADD('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))#)
		</cfif> --->
	UNION
		SELECT 
			C.COMPANY_ID COMPANY_ID,
			ROUND(CRM.BAKIYE,3) BAKIYE,
			ROUND(CRM.BAKIYE2,3) BAKIYE2,
			C.FULLNAME FULLNAME,
			C.SALES_COUNTY SALES_COUNTY,
			C.CITY CITY,
			C.MEMBER_CODE,
			CR.ACTION_NAME,
			CR.ACTION_ID,
			CR.PAPER_NO,
			CR.ACTION_VALUE,
			CR.ACTION_DATE ACTION_DATE,
			CR.DUE_DATE,
			-1 AS CARD_PAYMETHOD_ID,
			-1 AS PAY_METHOD,
			CR.OTHER_CASH_ACT_VALUE,
			CR.OTHER_MONEY,
			CR.ACTION_VALUE_2,
			CR.ACTION_CURRENCY_2,
			CR.ACTION_TYPE_ID,
			ISNULL(CR.DUE_DATE,CR.ACTION_DATE) DUE_DATE2
		FROM 
			COMPANY_REMAINDER CRM,
			#dsn_alias#.COMPANY C,
			CARI_ROWS CR
		WHERE 
			CRM.COMPANY_ID = C.COMPANY_ID AND 
		<cfif attributes.customer_type eq 1>
			CR.FROM_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID = 40 AND<!--- acilis fisi--->
			ROUND(CRM.BAKIYE,3) < 0 AND
		<cfelse>
			CR.TO_CMP_ID = C.COMPANY_ID AND
			CR.ACTION_TYPE_ID = 40 AND<!--- acilis fisi--->
			ROUND(CRM.BAKIYE,3) > 0 AND
		</cfif>	
			CR.ACTION_DATE < #DATEADD('d',1,now())#<!--- ileri tarihli islem varsa gelmesin --->
		<cfif len(attributes.company) and len(attributes.company_id)>
			AND C.COMPANY_ID = #attributes.company_id#
		</cfif>
		<cfif isDefined("attributes.comp_cat") and len(attributes.comp_cat)>
			AND C.COMPANYCAT_ID IN (#attributes.comp_cat#)
		</cfif>
		<cfif isDefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text)>
			AND C.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #attributes.pos_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id# AND COMPANY_ID IS NOT NULL)
		</cfif>
		<cfif isdefined("attributes.city") and len(attributes.city)>
			AND C.CITY = #attributes.city#
		</cfif>
		<cfif isdefined("attributes.sales_zones") and len(attributes.sales_zones)>
			AND C.SALES_COUNTY = #attributes.sales_zones#
		</cfif>
		<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
			AND C.COMPANY_VALUE_ID = #attributes.customer_value#
		</cfif>
		<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 1>
			AND C.IS_BUYER = 1
		</cfif>
		<cfif isdefined("attributes.buy_status") and attributes.buy_status eq 2>
			AND C.IS_SELLER= 1
		</cfif>
		<!--- <cfif isDefined("attributes.duedate_control")>
			AND (CR.DUE_DATE IS NULL OR CR.DUE_DATE < #DATEADD('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#'))#)
		</cfif> --->
	<cfif isDefined('attributes.oby') and attributes.oby eq 1>
		ORDER BY
			FULLNAME,COMPANY_ID,ISNULL(CR.DUE_DATE,CR.ACTION_DATE) DESC
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 2>
		ORDER BY
			ROUND(BAKIYE,3) DESC,C.COMPANY_ID,ISNULL(CR.DUE_DATE,CR.ACTION_DATE) DESC
	<cfelseif isDefined('attributes.oby') and attributes.oby eq 3>
		ORDER BY
			ROUND(BAKIYE,3),COMPANY_ID,ISNULL(CR.DUE_DATE,CR.ACTION_DATE) DESC
	<cfelse>
		ORDER BY
			COMPANY_ID,ISNULL(CR.DUE_DATE,CR.ACTION_DATE) DESC
	</cfif>
	</cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset GET_COMP_REMAINDER.recordcount = 0>
	<cfset arama_yapilmali = 1>
</cfif>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="headbold" height="35">
  <tr>
    <td><cf_get_lang no='115.Tahsilat Takip'></td>
	<!-- sil -->
	<td style="text-align:right;">
	<table>
	<cfform name="list_revenue" method="post" action="#request.self#?fuseaction=ch.list_revenue_collector">
	  <tr>
		<td <cfif attributes.detail_type eq 1>style="display:none;"</cfif> id="vade_1">Vade :</td>
		<td <cfif attributes.detail_type eq 1>style="display:none;"</cfif> id="vade_2">
			<input type="text" name="vade_oran" id="vade_oran" value="<cfoutput>#attributes.vade_oran#</cfoutput>" style="width:45px;">
		</td>
		<td>İleri Vadelileri Gösterme<input type="checkbox" name="duedate_control" id="duedate_control" <cfif isdefined('attributes.duedate_control')>checked</cfif>></td>
		<td>
		  <select name="detail_type" id="detail_type" onClick="ayarla_gizle_goster(this.value);">
			<option value="1" <cfif isDefined('attributes.detail_type') and attributes.detail_type eq 1>selected</cfif>><cf_get_lang_main no='1373.Detaylı'></option>
			<option value="2" <cfif isDefined('attributes.detail_type') and attributes.detail_type eq 2>selected</cfif>><cf_get_lang no='147.Detaysız'></option>
		  </select>
		</td>
		<td>
		  <select name="oby" id="oby">
			<option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang no='148.Alfabetik'></option>
			<option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang no='149.Azalan Bakiye'></option>
			<option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang no='150.Artan Bakiye'></option>
		  </select>
		</td>
		<td>
		  <select name="customer_type" id="customer_type">
			<option value="1" <cfif isDefined('attributes.customer_type') and attributes.customer_type eq 1>selected</cfif>><cf_get_lang dictionary_id="49994.Alacaklı Üyeler"></option>
			<option value="2" <cfif isDefined('attributes.customer_type') and attributes.customer_type eq 2>selected</cfif>><cf_get_lang dictionary_id=" 49995.Borçlu Üyeler"></option>
		  </select>
		</td>
		<td><cf_wrk_search_button></td>
		  <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
	  </tr>
	</table>
	</td>
  	<!-- sil -->
  </tr>
</table>
<table cellpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border">
    <td>
	<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<!-- sil -->
	  <tr class="color-list">
		<td style="text-align:right;" height="20" colspan="11">
		<table>
		<input name="form_varmi" id="form_varmi" value="1" type="hidden">
		  <tr height="22">
		  	<td></td>
			<td><cf_get_lang_main no='107.Cari Hesap'></td>
			<td>
			  <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
			  <input type="text" name="company" id="company" style="width:120px;" value="<cfif len(attributes.company) ><cfoutput>#attributes.company#</cfoutput></cfif>">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=list_revenue.company&field_comp_id=list_revenue.company_id&field_member_name=list_revenue.company</cfoutput>&keyword='+encodeURIComponent(document.list_revenue.company.value),'list')"><img src="/images/plus_thin.gif"  alt="<cf_get_lang_main no='322.seçiniz'>" title="<cf_get_lang_main no='322.seçiniz'>" border="0" align="absmiddle"></a>
			</td>
			<td><cf_get_lang_main no='496.Temsilci'></td>
			<td>
			  <input type="hidden" name="pos_code" id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
			  <input type="text" name="pos_code_text" id="pos_code_text" style="width:120px;" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=list_revenue.pos_code&field_name=list_revenue.pos_code_text&select_list=1','list')"><img src="/images/plus_thin.gif" border="0" alt="<cf_get_lang_main no='322.seçiniz'>" title="<cf_get_lang_main no='322.seçiniz'>" align="absmiddle"></a>
			</td>
			<td><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
			<td>
			  <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfoutput>#attributes.card_paymethod_id#</cfoutput>">
			  <input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfoutput>#attributes.payment_type_id#</cfoutput>">
			  <input type="text" name="payment_type" id="payment_type" value="<cfoutput>#attributes.payment_type#</cfoutput>" style="width:120px;" onKeyup="list_revenue.payment_type_id.value='';list_revenue.card_paymethod_id.value=''">
			  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=list_revenue.payment_type_id&field_name=list_revenue.payment_type&field_card_payment_id=list_revenue.card_paymethod_id&field_card_payment_name=list_revenue.payment_type','list');"><img src="/images/plus_thin.gif"  alt="<cf_get_lang_main no='322.seçiniz'>" title="<cf_get_lang_main no='322.seçiniz'>"  align="absmiddle" border="0"></a>
			</td>
			 <td rowspan="2">
			  <cfquery name="GET_COMPANYCAT" datasource="#DSN#">
				SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
			  </cfquery>
			  <select name="comp_cat" id="comp_cat" style="width:160px;height:50px;" multiple>
			  <cfoutput query="get_companycat">
				<option value="#COMPANYCAT_ID#" <cfif listfind(attributes.comp_cat,COMPANYCAT_ID,',')>selected</cfif>>#companycat#</option>
			  </cfoutput>
			  </select>
			</td> 
		  </tr>
		  <tr height="22">
			<td colspan="2">
				<select name="customer_value" id="customer_value" style="width:120px;">
					<option value=""><cf_get_lang_main no='1140.Müşteri Değeri'></option>
					<cfoutput query="get_customer_value">
					<option value="#customer_value_id#" <cfif isdefined('attributes.customer_value') and customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
					</cfoutput>
				</select>
			</td>
			<td>
				<select name="buy_status" id="buy_status" style="width:120px;">
					<option value="">Alıcı / Satıcı</option>
					<option value="1" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 1>selected</cfif>>Alıcı</option>
					<option value="2" <cfif isDefined('attributes.buy_status') and attributes.buy_status eq 2>selected</cfif>>Satıcı</option>
				</select>
			</td>
			<td>Satış Bölgesi</td>
			<td>
			<cfquery name="GET_SALES_ZONES" datasource="#DSN#">
				SELECT SZ_ID, SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
			</cfquery>
			  <select name="sales_zones" id="sales_zones" style="width:120px;">
			  <option value="">Satış Bölgesi</option>
			  <cfoutput query="get_sales_zones">
				<option value="#sz_id#" <cfif sz_id eq attributes.sales_zones> selected</cfif>>#sz_name#</option>
			  </cfoutput>
			  </select>
			</td>
			<td>Şehir</td>
			<td>
			<cfquery name="GET_CITY" datasource="#DSN#">
				SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
			</cfquery>
			  <select name="city" id="city" style="width:120px;">
			  <option value="">Şehir</option>
			  <cfoutput query="get_city">
				<option value="#city_id#" <cfif attributes.city eq city_id>selected</cfif>>#city_name#</option>
			  </cfoutput>
			  </select>
			</td>
		  </tr>
		</table>
		</td>
	  </tr>
	<!-- sil -->
	</cfform>
	<cfif get_comp_remainder.recordcount>
		<cfset city_id_list = ''>
		<cfset sales_county_list = ''>
		<cfset pos_code_list = ''>
		<cfoutput query="get_comp_remainder">
			<cfif len(sales_county) and not listfind(sales_county_list,sales_county,',')>
				<cfset sales_county_list = listappend(sales_county_list,sales_county,',')>
			</cfif>
			<cfif len(city) and not listfind(city_id_list,city,',')>
				<cfset city_id_list = listappend(city_id_list,city,',')>
			</cfif>
			<cfif len(pos_code) and not listfind(pos_code_list,pos_code,',')>
				<cfset pos_code_list = listappend(pos_code_list,pos_code,',')>
			</cfif>
		</cfoutput>
		<cfset sales_county_list = listsort(sales_county_list,"numeric","ASC",",")>
		<cfif len(sales_county_list)>
			<cfquery name="get_zones" datasource="#dsn#">
				SELECT SZ_ID,SZ_NAME FROM SALES_ZONES WHERE SZ_ID IN(#sales_county_list#) ORDER BY SZ_ID
			</cfquery>
			<cfset sales_county_list = listsort(valuelist(get_zones.sz_id,','),"numeric","ASC",',')>
		</cfif>
		<cfset city_id_list = listsort(city_id_list,"numeric","ASC",",")>
		<cfif len(city_id_list)>
			<cfquery name="get_city_name" datasource="#dsn#">
				SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN(#city_id_list#) ORDER BY CITY_ID
			</cfquery>
			<cfset city_id_list = listsort(valuelist(get_city_name.city_id,','),"numeric","ASC",',')>
		</cfif>
		<cfset pos_code_list = listsort(pos_code_list,"numeric","ASC",",")>
		<cfif len(pos_code_list)>
			<cfquery name="get_pos" datasource="#dsn#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE IN (#pos_code_list#) ORDER BY POSITION_CODE
			</cfquery>
			<cfset pos_code_list = listsort(valuelist(get_pos.position_code,','),"numeric","ASC",',')>
		</cfif>
		<cfquery name="get_paymethod" datasource="#dsn#">
			SELECT PAYMETHOD_ID,PAYMETHOD FROM SETUP_PAYMETHOD ORDER BY PAYMETHOD_ID
		</cfquery>
		<cfset paymethod_id_list=listsort(valuelist(get_paymethod.PAYMETHOD_ID,','),"numeric","ASC",",")>
		<cfquery name="get_card_paymethod" datasource="#dsn3#">
			SELECT CARD_NO,PAYMENT_TYPE_ID FROM CREDITCARD_PAYMENT_TYPE ORDER BY PAYMENT_TYPE_ID
		</cfquery>
		<cfset card_paymethod_id_list=listsort(valuelist(get_card_paymethod.PAYMENT_TYPE_ID,','),"numeric","ASC",",")>
		<cfif attributes.detail_type eq 2>
			<tr height="22" class="color-header">
				<td class="form-title"><cf_get_lang dictionary_id="57487.No"></td>
				<td class="form-title"><cf_get_lang dictionary_id="58585.Kod"></td>
				<td class="form-title" width="30%"><cf_get_lang_main no='107.Cari Hesap'></td>
				<td class="form-title"><cf_get_lang dictionary_id="57908.Temsilci"></td>
				<td class="form-title"><cf_get_lang dictionary_id="57659.Satış Bölgesi"> </td>
				<td class="form-title"><cf_get_lang dictionary_id="57971.Şehir"</td>
				<td width="75" class="form-title" style="text-align:right;"><cf_get_lang_main no='228.Vade'></td>
				<td width="100" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id = '57882.İşlem Tutarı'></td>
				<td width="100" class="form-title" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'></td>
				<td width="100" class="form-title" style="text-align:right;"><cfoutput>#session.ep.money2#</cfoutput> <cf_get_lang_main no='177.Bakiye'></td>
			</tr>
		</cfif>
		<cfset company_currentrow = 0>
		<cfset company_currentrow_2 = 0>
		<cfset genel_toplam_hesap = 0>
		<cfset genel_toplam_hesap_money2 = 0>
		<cfset genel_bakiye = 0>
		<cfset genel_bakiye2 = 0>
		<cfset genel_vade_toplam_hesap = 0>
		<cfset genel_vade_toplam_hesap_detaysiz = 0>
		<cfset genel_ort_vade = 0>
		<cfoutput query="GET_COMP_REMAINDER" group="COMPANY_ID">
			<cfset company_currentrow = company_currentrow+1>
			<cfset vade_toplam_hesap = 0>
			<cfset toplam_hesap = 0>
			<cfset toplam_hesap_money2 = 0>
			<cfset temp_borc_tutar = abs(BAKIYE)>
			<cfif attributes.detail_type eq 1>
				<tr height="22" class="color-header">
					<td class="form-title"><cf_get_lang_main no='468.Belge No'></td>
					<td class="form-title"><cf_get_lang_main no='280.İşlem'></td>
					<td class="form-title"><cf_get_lang_main no='330.Tarih'></td>
					<td class="form-title"><cf_get_lang_main no='1439.Ödeme Tarihi'></td>
					<td class="form-title"><cf_get_lang_main no='1104.Ödeme Yöntemi'></td>
					<td width="75" class="form-title" style="text-align:right;"><cf_get_lang_main no='228.Vade'>/<cf_get_lang_main no='78.Gün'></td>
					<td width="75" class="form-title" style="text-align:right;">#session.ep.money# <cf_get_lang_main no='261.Tutar'></td>
					<td width="75" class="form-title" style="text-align:right;">#session.ep.money2# <cf_get_lang dictionary_id="57673.Tutar"></td>
					<td width="75" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id="54948.İşlem Tutar"></td>
				</tr>
			</cfif>
			<cfoutput>
				<cfif temp_borc_tutar gte ACTION_VALUE>
					<cfset temp_borc_tutar = temp_borc_tutar - ACTION_VALUE>
					<cfset belge_tutar = ACTION_VALUE>
				<cfelse>
					<cfset belge_tutar = temp_borc_tutar><!--- kalan kismin hepsi --->
					<cfset temp_borc_tutar = temp_borc_tutar - ACTION_VALUE>
				</cfif>
				<cfif attributes.detail_type eq 1 and belge_tutar gt 0 and 
					(
					not len(attributes.payment_type)
					or (len(attributes.payment_type_id) and attributes.payment_type_id eq PAY_METHOD)
					or (len(attributes.card_paymethod_id) and attributes.card_paymethod_id eq CARD_PAYMETHOD_ID)
					)>
					<cfif
					(
					not isDefined("attributes.duedate_control")
					or (isDefined("attributes.duedate_control") and not len(DUE_DATE))
					or (isDefined("attributes.duedate_control") and DUE_DATE lt date_add('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')))
					)>
						<cfif len(DUE_DATE)>
							<cfset gun_farki = datediff('d',DUE_DATE,now())>
						<cfelse>
							<cfset gun_farki = datediff('d',ACTION_DATE,now())>
						</cfif>
						<cfset vade_toplam_hesap = vade_toplam_hesap + (gun_farki * belge_tutar)>
						<cfset toplam_hesap = toplam_hesap + belge_tutar>
						<cfif len(ACTION_VALUE_2)>
							<cfset toplam_hesap_money2 = toplam_hesap_money2 + wrk_round(ACTION_VALUE_2)>
						</cfif>
						<cfset genel_toplam_hesap = genel_toplam_hesap + belge_tutar>
						<cfif len(ACTION_VALUE_2)>
							<cfset genel_toplam_hesap_money2 = genel_toplam_hesap_money2 + wrk_round(ACTION_VALUE_2)>
						</cfif>
						<cfset genel_vade_toplam_hesap = genel_vade_toplam_hesap + (gun_farki * belge_tutar)>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&ID=#ACTION_ID#','medium');">#PAPER_NO#</a></td>
						<td><cfif ACTION_TYPE_ID eq 40 and not len(ACTION_NAME)><cf_get_lang dictionary_id="58756.Açılış Fişi"><cfelse>#ACTION_NAME#</cfif></td>
						<td>#dateformat(ACTION_DATE,dateformat_style)#</td>
						<td>#dateformat(DUE_DATE,dateformat_style)# <cfif len(DUE_DATE)>(#datediff('d',ACTION_DATE,DUE_DATE)#)</cfif></td>
						<td>
							<cfif len(PAY_METHOD)>
								#get_paymethod.paymethod[listfind(paymethod_id_list,PAY_METHOD,',')]#
							<cfelseif len(CARD_PAYMETHOD_ID)>				
								#get_card_paymethod.CARD_NO[listfind(card_paymethod_id_list,CARD_PAYMETHOD_ID,',')]#
							</cfif>
						</td>
						<td style="text-align:right;"><cfif len(DUE_DATE)><cfif datediff('d',DUE_DATE,now()) gt 0>+</cfif>#datediff('d',DUE_DATE,now())#<cfelse><cfif datediff('d',ACTION_DATE,now()) gt 0>+</cfif>#datediff('d',ACTION_DATE,now())#</cfif></td>
						<td style="text-align:right;">#TLFormat(belge_tutar)#</td>
						<td style="text-align:right;"><cfif len(ACTION_VALUE_2)>#TLFormat(ACTION_VALUE_2)#</cfif></td>
						<td style="text-align:right;">#TLFormat(OTHER_CASH_ACT_VALUE)# #OTHER_MONEY#</td>
					</tr>
					</cfif>
				<cfelseif attributes.detail_type eq 2 and belge_tutar gt 0>
					<cfif
					(
					not isDefined("attributes.duedate_control")
					or (isDefined("attributes.duedate_control") and not len(DUE_DATE))
					or (isDefined("attributes.duedate_control") and DUE_DATE lt date_add('d',1,createodbcdatetime('#year(now())#-#month(now())#-#day(now())#')))
					)>
						<cfif len(DUE_DATE)>
							<cfset gun_farki = datediff('d',DUE_DATE,now())>
						<cfelse>
							<cfset gun_farki = datediff('d',ACTION_DATE,now())>
						</cfif>
						<cfset vade_toplam_hesap = vade_toplam_hesap + (gun_farki * belge_tutar)>
						<cfset toplam_hesap = toplam_hesap + belge_tutar>
						<cfset genel_toplam_hesap = genel_toplam_hesap + belge_tutar>
						<cfset genel_vade_toplam_hesap = genel_vade_toplam_hesap + (gun_farki * belge_tutar)>
					</cfif>
				</cfif>
			</cfoutput>
				<cfif attributes.detail_type eq 1>
				<tr class="color-list" height="20">
					<td>#company_currentrow#-<a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','list','popup_com_det');">#fullname#&nbsp;-&nbsp;#member_code#</a></td>
					<td><cfif len(sales_county)>#get_zones.sz_name[listfind(sales_county_list,sales_county,',')]#</cfif></td>
					<td><cfif len(city)>#get_city_name.city_name[listfind(city_id_list,city,',')]#</cfif></td>
					<td colspan="2" style="text-align:right;">
					  <cfset genel_bakiye = genel_bakiye + ABS(BAKIYE)>
					  Toplam <cf_get_lang_main no='177.Bakiye'> : #TLFormat(ABS(BAKIYE))#
					</td>
					<cfif toplam_hesap>
						<td style="text-align:right;">#round(vade_toplam_hesap/toplam_hesap)#</td>
						<td style="text-align:right;">#TLFormat(ABS(toplam_hesap))#</td>
						<td style="text-align:right;">#TLFormat(ABS(toplam_hesap_money2))#</td>
						<td colspan="1"></td>
					<cfelse>
						<td colspan="4"></td>
					</cfif>
				</tr>
				<cfelse>
					<cfif toplam_hesap and isDefined("attributes.vade_oran") and round(vade_toplam_hesap/toplam_hesap) gte attributes.vade_oran>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<cfset company_currentrow_2 = company_currentrow_2 + 1>
						<cfset genel_vade_toplam_hesap_detaysiz = genel_vade_toplam_hesap_detaysiz + toplam_hesap>
						<cfset genel_ort_vade = genel_ort_vade + round(vade_toplam_hesap/toplam_hesap)>
						<td>#company_currentrow_2#</td>
						<td>#member_code#</td>
						<td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#COMPANY_ID#','list','popup_com_det');">#FULLNAME#</a></td>
						<td><cfif len(pos_code_list)>#get_pos.employee_name[listfind(pos_code_list,pos_code,',')]#&nbsp;#get_pos.employee_surname[listfind(pos_code_list,pos_code,',')]#</cfif></td>
						<td><cfif len(sales_county)>#get_zones.sz_name[listfind(sales_county_list,sales_county,',')]#</cfif></td>
						<td><cfif len(city)>#get_city_name.city_name[listfind(city_id_list,city,',')]#</cfif></td>
						<cfset genel_bakiye = genel_bakiye + ABS(BAKIYE)>
						<cfset genel_bakiye2 = genel_bakiye2 + ABS(BAKIYE2)>
						<cfif toplam_hesap>
							<td style="text-align:right;">#round(vade_toplam_hesap/toplam_hesap)#</td>
							<td style="text-align:right;">#TLFormat(ABS(toplam_hesap))#</td>
							<td style="text-align:right;">#TLFormat(ABS(BAKIYE))#</td>
							<td style="text-align:right;">#TLFormat(ABS(BAKIYE2))#</td>
						<cfelse>
							<td colspan="5"></td>
						</cfif>
					</tr>
					</cfif>
				</cfif>
		</cfoutput>	
		<!--- En alt toplam bolumu --->
		<cfoutput>
		<tr class="color-list" height="20">
		<cfif attributes.detail_type eq 1 and genel_toplam_hesap>
			<td colspan="3"><cf_get_lang_main no='268.Genel Toplam'></td>
			<td colspan="2" style="text-align:right;"><cf_get_lang_main no='177.Bakiye'>: #TLFormat(genel_bakiye)#</td>
			<td style="text-align:right;">#round(genel_vade_toplam_hesap/genel_toplam_hesap)#</td>
			<td style="text-align:right;">#TLFormat(ABS(genel_toplam_hesap))#</td>
			<td style="text-align:right;">#TLFormat(ABS(genel_toplam_hesap_money2))#</td>
			<td colspan="1"></td>
		<cfelseif attributes.detail_type eq 2 and company_currentrow_2>
			<td></td>
			<td colspan="5"><cf_get_lang_main no='268.Genel Toplam'> :</td>
			<td style="text-align:right;">#round(genel_ort_vade/company_currentrow_2)#</td>
			<td style="text-align:right;">#TLFormat(ABS(genel_vade_toplam_hesap_detaysiz))#</td>
			<td style="text-align:right;">#TLFormat(genel_bakiye)#</td>
			<td style="text-align:right;">#TLFormat(genel_bakiye2)#</td>
		</cfif>	
		</tr>
		</cfoutput>
	<cfelse>
	<tr class="color-row" height="20">
		<td colspan="11"><cfif arama_yapilmali eq 1><cf_get_lang_main no='289.Filtre Ediniz'> !<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
	</tr>
	</cfif>
	</table>
    </td>
  </tr>
</table>
<br/>
<script type="text/javascript">
function ayarla_gizle_goster(id)
{
	if(id==2)
	{
		vade_1.style.display='';
		vade_2.style.display='';
	}
	else
	{
		vade_1.style.display='none';
		vade_2.style.display='none';
	}
}
</script>
