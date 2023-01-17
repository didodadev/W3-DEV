<!--- Cari Virman --->
<cfset satir_sayisi=23>
<cfset satir_basla=1>
<cfset yazilan_satir=1>
<cfquery name="GET_CARI_ACTIONS" datasource="#dsn2#">
	SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.action_id#
</cfquery>

<cfif GET_CARI_ACTIONS.recordcount>
	<cfset page=Ceiling(GET_CARI_ACTIONS.recordcount/satir_sayisi)>
<cfelse>
	<cfset page=1>
</cfif>

<cfscript>
	sepet_total = 0;
	sepet_toplam_indirim = 0;
	sepet_total_tax = 0;
	sepet_net_total = 0;
</cfscript>


<cfset satir_sayisi=35>
<cfset satir_basla=1>
<cfset total_a = 0>
<cfset total_b = 0>

<cfquery name="GET_CARI_ACTIONS" datasource="#dsn2#">
	SELECT * FROM CARI_ACTIONS WHERE ACTION_ID = #attributes.action_id#
</cfquery>

<cfif GET_CARI_ACTIONS.recordcount>
	<cfset page=Ceiling(GET_CARI_ACTIONS.recordcount/satir_sayisi)>
<cfelse>
	<cfset page=1>
</cfif>

<cfif len(get_cari_actions.to_cmp_id) and get_cari_actions.to_consumer_id neq 0>
	<cfset comp = "to_cmp">
	<cfquery name="get_member_info" datasource="#dsn#">
		SELECT
			TAXOFFICE VERGI_DA,
			TAXNO VERGI_NO,
			FULLNAME MEMBER_NAME,
			COMPANY_ADDRESS MEMBER_ADDRESS,
			SEMT SEMT,
			COUNTY ILCE,
			CITY SEHIR,
			COUNTRY ULKE,
			MEMBER_CODE MEMBER_CODE
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID = #get_cari_actions.to_cmp_id#
	</cfquery>
<cfelseif len(get_cari_actions.to_consumer_id)>
	<cfquery name="get_member_info" datasource="#dsn#">
		SELECT 
			TAX_OFFICE VERGI_DA,
			TAX_NO VERGI_NO,
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
			TAX_ADRESS MEMBER_ADDRESS,
			TAX_SEMT SEMT,
			TAX_COUNTY_ID ILCE,
			TAX_CITY_ID SEHIR,
			TAX_COUNTRY_ID ULKE,
			MEMBER_CODE MEMBER_CODE
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = #get_cari_actions.to_consumer_id#
	</cfquery>
<cfelseif len(get_cari_actions.to_employee_id)>
	<cfquery name="get_member_info" datasource="#dsn#">
		SELECT 
			'' VERGI_DA,
			'' VERGI_NO,
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME MEMBER_NAME,
			(SELECT HOMEADDRESS FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) MEMBER_ADDRESS,
			'' SEMT,
			(SELECT HOMECOUNTY FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) ILCE,
			(SELECT HOMECITY FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) SEHIR,
			(SELECT HOMECOUNTRY FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) ULKE,
			MEMBER_CODE MEMBER_CODE
		FROM 
			EMPLOYEES E
		WHERE 
			E.EMPLOYEE_ID = #get_cari_actions.to_employee_id#
	</cfquery>
</cfif>

<cfif len(get_cari_actions.from_cmp_id) and get_cari_actions.from_consumer_id neq 0>
	<cfset comp = "from_cmp">
	<cfquery name="get_member_alacak_info" datasource="#dsn#">
		SELECT
			TAXOFFICE VERGI_DA,
			TAXNO VERGI_NO,
			FULLNAME MEMBER_NAME,
			COMPANY_ADDRESS MEMBER_ADDRESS,
			SEMT SEMT,
			COUNTY ILCE,
			CITY SEHIR,
			COUNTRY ULKE,
			MEMBER_CODE MEMBER_CODE
		FROM
			COMPANY
		WHERE 
			COMPANY.COMPANY_ID=#get_cari_actions.from_cmp_id#
	</cfquery>
<cfelseif len(get_cari_actions.from_consumer_id)>
	<cfquery name="get_member_alacak_info" datasource="#dsn#">
		SELECT 
			TAX_OFFICE VERGI_DA,
			TAX_NO VERGI_NO,
			CONSUMER_NAME + ' ' + CONSUMER_SURNAME MEMBER_NAME,
			TAX_ADRESS MEMBER_ADDRESS,
			TAX_SEMT SEMT,
			TAX_COUNTY_ID ILCE,
			TAX_CITY_ID SEHIR,
			TAX_COUNTRY_ID ULKE,
			MEMBER_CODE MEMBER_CODE
		FROM 
			CONSUMER
		WHERE 
			CONSUMER_ID = #get_cari_actions.from_consumer_id#
	</cfquery>
<cfelseif len(get_cari_actions.from_employee_id)>
	<cfquery name="get_member_alacak_info" datasource="#dsn#">
		SELECT 
			'' VERGI_DA,
			'' VERGI_NO,
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME MEMBER_NAME,
			(SELECT HOMEADDRESS FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) MEMBER_ADDRESS,
			'' SEMT,
			(SELECT HOMECOUNTY FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) ILCE,
			(SELECT HOMECITY FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) SEHIR,
			(SELECT HOMECOUNTRY FROM EMPLOYEES_DETAIL ED WHERE ED.EMPLOYEE_ID = E.EMPLOYEE_ID) ULKE,
			MEMBER_CODE MEMBER_CODE
		FROM 
			EMPLOYEES E
		WHERE 
			E.EMPLOYEE_ID = #get_cari_actions.from_employee_id#
	</cfquery>
</cfif>

<cfset musteri_kodu = "">
<cfset fatura_verilen = "">
<cfset adres = "">
<cfset semt = "">
<cfset ilce = "">
<cfset sehir = "">
<cfset ulke = "">
<cfset vergidairesi = "">
<cfset verginosu = "">
<cfif isdefined("get_member_info") and get_member_info.recordcount>
	<cfset musteri_kodu = get_member_info.member_code>
	<cfset fatura_verilen = get_member_info.member_name>
	<cfset adres = get_member_info.member_address>
	<cfset semt = get_member_info.semt>
	<cfif len(get_member_info.ilce)>
		<cfquery name="get_county" datasource="#dsn#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_member_info.ilce#
		</cfquery>
		<cfset ilce = get_county.county_name>
	</cfif>
	<cfif len(get_member_info.sehir)>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_member_info.sehir#
		</cfquery>
		<cfset sehir = ucase(get_city.city_name)>
	</cfif>
	<cfif len(get_member_info.ulke)>
		<cfquery name="get_country_name" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_member_info.ulke#
		</cfquery>
		<cfset ulke = ucase(get_country_name.country_name)>
	</cfif>
	<cfset vergidairesi = get_member_info.vergi_da>
	<cfset verginosu = get_member_info.vergi_no>
</cfif>

<cfset musteri_kodu_alacak = "">
<cfset fatura_verilen_alacak = "">
<cfset adres_alacak = "">
<cfset semt_alacak = "">
<cfset ilce_alacak = "">
<cfset sehir_alacak = "">
<cfset ulke_alacak = "">
<cfset vergidairesi_alacak = "">
<cfset verginosu_alacak = "">
<cfif get_member_alacak_info.recordcount>
	<cfset musteri_kodu_alacak = get_member_alacak_info.member_code>
	<cfset fatura_verilen_alacak = get_member_alacak_info.member_name>
	<cfset adres_alacak = get_member_alacak_info.member_address>
	<cfset semt_alacak = get_member_alacak_info.semt>
	<cfif len(get_member_alacak_info.ilce)>
		<cfquery name="get_county" datasource="#dsn#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_member_alacak_info.ilce#
		</cfquery>
		<cfset ilce_alacak = get_county.county_name>
	</cfif>
	<cfif len(get_member_alacak_info.sehir)>
		<cfquery name="get_city" datasource="#dsn#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_member_alacak_info.sehir#
		</cfquery>
		<cfset sehir_alacak = ucase(get_city.city_name)>
	</cfif>
	<cfif len(get_member_alacak_info.ulke)>
		<cfquery name="get_country_name" datasource="#dsn#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_member_alacak_info.ulke#
		</cfquery>
		<cfset ulke_alacak = ucase(get_country_name.country_name)>
	</cfif>
	<cfset vergidairesi_alacak = get_member_alacak_info.vergi_da>
	<cfset verginosu_alacak = get_member_alacak_info.vergi_no>
</cfif>


<br/>
<table width="650" border="1" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="4" height="100" valign="top"> <br/>
		<table width="95%"  border="0">
		<cfoutput>
			<tr>
				<td align="center" colspan="2" class="headbold"><cf_get_lang_main no='1770.Cari Virman'></td>
			</tr>
			<tr>
				<td width="40">&nbsp;<cf_get_lang_main no='534.Fiş No'> </td>
				<td>: #get_cari_actions.paper_no#</td>
			</tr>
			<tr>
				<td>&nbsp;<cf_get_lang_main no='330.Tarih'> </td>
				<td>: #dateformat(get_cari_actions.action_date,dateformat_style)#</td>
			</tr>
		</cfoutput>
		</table>
		</td>
	</tr>
	<tr align="center" height="30" class="formbold">
		<td><cf_get_lang no='1724.BORÇLU HESAP'></td>
		<td><cf_get_lang no='1725.ALACAKLI HESAP'></td>
		<td><cf_get_lang_main no='217.AÇIKLAMA'></td>
		<td><cf_get_lang_main no='261.TUTAR'></td>
	</tr>
	<cfoutput query="get_cari_actions" startrow="#satir_basla#" maxrows="#satir_sayisi#">
	<tr height="30">
		<td>&nbsp;&nbsp;&nbsp;<strong>#fatura_verilen#</strong> <!--- <br/> #adres# #semt# <br/> #ilce# #sehir# #ulke# <br/> #vergidairesi# - #verginosu# ---></td>
		<td>&nbsp;&nbsp;&nbsp;<strong>#fatura_verilen_alacak#</strong> <!--- <br/> #adres_alacak# #semt_alacak# <br/> #ilce_alacak# #sehir_alacak# #ulke_alacak# <br/> #vergidairesi_alacak# - #verginosu_alacak# ---></td>
		<td>&nbsp;#action_detail#</td>
		<td style="text-align:right;">#TLFormat(action_value)#&nbsp;#ACTION_CURRENCY_ID#</td>
	</tr>
	</cfoutput>
	<tr>
		<td colspan="4" valign="top"><br/>
		<table width="95%"  border="0">
			<tr>
				<td height="40" valign="top"><cf_get_lang_main no='1545.İMZA'>: </td>
			</tr>
			<tr>
				<td> <cf_get_lang no="831.Yazıyla">:
				<cfset mynumber = wrk_round(GET_CARI_ACTIONS.action_value)>
				<cf_n2txt number="mynumber" para_birimi="#GET_CARI_ACTIONS.ACTION_CURRENCY_ID#"><cfoutput>#mynumber#</cfoutput> 'dir.
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>
