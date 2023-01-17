<cf_date tarih='attributes.birthdate1'>
<cf_date tarih='attributes.married_date1'>
<cfquery name="SEARCH_RESULTS" datasource="#DSN#">
	SELECT 
		COMPANYCAT_TYPE,
		COMPANY_ID,
		PARTNER_ID,
		FULLNAME,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME,
		MANAGER_PARTNER_ID
		<cfif isdefined("attributes.COMPANYCAT_VIEW")>,COMPANYCAT_ID</cfif>
		<cfif isdefined("attributes.IMS_CODE_VIEW")>,IMS_CODE_ID</cfif>
		<cfif isdefined("attributes.CITY_NAME_VIEW")>,CITY_ID</cfif>
		<cfif isdefined("attributes.COUNTY_NAME_VIEW")>,COUNTY_ID</cfif>
		<cfif isdefined("attributes.COMPANY_ADDRESS_VIEW")>,DISTRICT</cfif>
		<cfif isdefined("attributes.SEMT_VIEW")>,SEMT</cfif>
		<cfif isdefined("attributes.CADDE_VIEW")>,MAIN_STREET</cfif>
		<cfif isdefined("attributes.SOKAK_VIEW")>,STREET</cfif>
		<cfif isdefined("attributes.NO_VIEW")>,DUKKAN_NO</cfif>
		<cfif isdefined("attributes.ASSISTANCE_STATUS_VIEW")>,MISSION</cfif>
		<cfif isdefined("attributes.BIRTHPLACE_VIEW")>,BIRTHPLACE</cfif>
		<cfif isdefined("attributes.BIRTHDATE_VIEW")>,BIRTHDATE</cfif>
		<cfif isdefined("attributes.MARRIED_DATE_VIEW")>,MARRIED_DATE</cfif>
		<cfif isdefined("attributes.UNIVERSITY_NAME_VIEW")>,UNIVERSITY_ID</cfif>
		<cfif isdefined("attributes.MARITAL_STATUS_NAME_VIEW")>,MARRIED</cfif>
		<cfif isdefined("attributes.GRADUATE_YEAR_VIEW")>,GRADUATE_YEAR</cfif>
		<cfif isdefined("attributes.SEX_NAME_VIEW")>,SEX</cfif>
		<cfif isdefined("attributes.MOBIL_CODE_VIEW")>,MOBIL_CODE, MOBILTEL</cfif>
		<cfif isdefined("attributes.NOBET_DURUMU_VIEW")>,DUTY_PERIOD</cfif>
		<cfif isdefined("attributes.SETUP_STOCK_AMOUNT_VIEW")>,STOCK_AMOUNT</cfif>
		<cfif isdefined("attributes.ISSMS_VIEW")>,IS_SMS</cfif>
		<cfif isdefined("attributes.TAXNUM_NAME_VIEW")>,TAXNO</cfif>
		<cfif isdefined("attributes.TAXOFFICE_NAME_VIEW")>,TAXOFFICE</cfif>
		<cfif isdefined("attributes.TELEPHONE_NAME_VIEW")>,COMPANY_TELCODE,COMPANY_TEL1</cfif>
		<cfif isdefined("attributes.EMAIL_NAME_VIEW")>,COMPANY_EMAIL</cfif>
		<cfif isdefined("attributes.TC_IDENTITY_VIEW")>,TC_IDENTITY</cfif>
	FROM 
		GET_COMPANY_PARTNER_MAIN
	WHERE
		1 = 1
		<cfif attributes.is_type eq 1>
			AND MANAGER_PARTNER_ID = PARTNER_ID
		<cfelseif attributes.is_type eq 2>
			AND MANAGER_PARTNER_ID <> PARTNER_ID
		</cfif>
			<!--- Bit İle Gelenler --->
			<cfif len(attributes.city_id)>AND CITY_ID  = #attributes.city_id#</cfif>
			<cfif len(attributes.COUNTY_ID) and len(attributes.COUNTY_NAME)>AND COUNTY_ID = #attributes.COUNTY_ID#</cfif>
			<cfif len(attributes.GRADUATE_YEAR)>AND GRADUATE_YEAR #attributes.GRADUATE_YEAR_CONDITION# #attributes.GRADUATE_YEAR#</cfif>
			<cfif len(attributes.MOBIL_CODE)>AND MOBIL_CODE #attributes.MOBIL_CODE_CONDITION# '#attributes.MOBIL_CODE#'</cfif>
			<cfif len(attributes.GRADUATE_YEAR)>AND GRADUATE_YEAR #attributes.GRADUATE_YEAR_CONDITION# #attributes.GRADUATE_YEAR#</cfif>
			<cfif len(attributes.ISSMS)>AND IS_SMS = #attributes.ISSMS#</cfif>
			<cfif len(attributes.HEDEFKODU)>AND COMPANY_ID  = #attributes.HEDEFKODU#</cfif>
			<!--- Int İle Gelenler --->
			<cfif isdefined("attributes.COMPANYCAT")>AND COMPANYCAT_ID IN (#attributes.COMPANYCAT#)</cfif>
			<cfif len(attributes.IMS_CODE)>AND IMS_CODE_ID IN (#attributes.IMS_CODE#)</cfif>
			<cfif isdefined("attributes.ASSISTANCE_STATUS") and len(attributes.ASSISTANCE_STATUS)>AND MISSION IN (#attributes.ASSISTANCE_STATUS#)</cfif>
			<cfif isdefined("attributes.MARITAL_STATUS_NAME") and len(attributes.MARITAL_STATUS_NAME)>AND MARRIED IN (#attributes.MARITAL_STATUS_NAME#)</cfif>
			<cfif isdefined("attributes.UNIVERSITY_NAME") and len(attributes.UNIVERSITY_NAME)>AND UNIVERSITY_ID IN (#attributes.UNIVERSITY_NAME#)</cfif>
			<cfif isdefined("attributes.SEX_NAME") and len(attributes.SEX_NAME)>AND SEX IN (#attributes.SEX_NAME#)</cfif>
			<cfif isdefined("attributes.PERIOD_NAME") and len(attributes.PERIOD_NAME)>AND DUTY_PERIOD IN (#attributes.PERIOD_NAME#)</cfif>
			<cfif len(attributes.SETUP_STOCK_AMOUNT)>AND STOCK_AMOUNT IN (#attributes.SETUP_STOCK_AMOUNT#)</cfif>
			<!--- Query + In İle Gelenler --->
			<cfif len(attributes.PLASIYER_ID)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND PLASIYER_ID = #attributes.PLASIYER_ID# )</cfif>
			<cfif len(attributes.BSM_ID)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND SALES_DIRECTOR = #attributes.BSM_ID# )</cfif>
			<cfif len(attributes.TELEFON_ID)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND TEL_SALE_PREID = #attributes.TELEFON_ID# )</cfif>
			<cfif len(attributes.TAHSILAT_ID)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND TAHSILATCI = #attributes.TAHSILAT_ID# )</cfif>
			<cfif len(attributes.ITRIYAT_ID)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND ITRIYAT_GOREVLI = #attributes.ITRIYAT_ID# )</cfif>
			<cfif len(attributes.BOLGE_KODU)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND BOLGE_KODU LIKE '%#attributes.BOLGE_KODU#%' )</cfif>
			<cfif len(attributes.ODEME_SEKLI)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CALISMA_SEKLI LIKE '%#attributes.ODEME_SEKLI#%' )</cfif>
			<cfif len(attributes.CEP_SIRA)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CEP_SIRA LIKE '%#attributes.CEP_SIRA#%' )</cfif>
			<cfif isdefined("attributes.TR_STATUS") and len(attributes.TR_STATUS)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND MUSTERIDURUM IN (#attributes.TR_STATUS#))</cfif>
			<cfif isdefined("attributes.NICK_NAME") and len(attributes.NICK_NAME)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (#attributes.NICK_NAME#))
			<cfelse>
				AND COMPANY_ID IN (SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND COMPANY_BRANCH_RELATED.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
			</cfif>
			<cfif isdefined("attributes.PARTNER_RELATION") and len(attributes.PARTNER_RELATION)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND COMPANY_BRANCH_RELATED.RELATION_STATUS IN (#attributes.PARTNER_RELATION#))</cfif>
			<cfif isdefined("attributes.RESOURCE") and len(attributes.RESOURCE)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND COMPANY_BRANCH_RELATED.RELATION_START IN (#attributes.RESOURCE#))</cfif>
			<cfif len(attributes.HOBBY_NAME)>AND PARTNER_ID IN ( SELECT PARTNER_ID FROM COMPANY_PARTNER_HOBBY WHERE HOBBY_ID IN (#attributes.HOBBY_NAME#))</cfif>
			<cfif len(attributes.SOCIETY)>AND PARTNER_ID IN ( SELECT COMPANY_ID FROM COMPANY_PARTNER_SOCIETY WHERE SOCIETY_ID IN (#attributes.SOCIETY#))</cfif>
			<cfif len(attributes.GENEL_KONUM)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_POSITION WHERE POSITION_ID IN (#attributes.GENEL_KONUM#))</cfif>
			<cfif len(attributes.SECTOR_CAT)>AND PARTNER_ID IN ( SELECT PARTNER_ID FROM COMPANY_PARTNER_JOB_OTHER WHERE JOB_ID IN (#attributes.SECTOR_CAT#))</cfif>
			<cfif len(attributes.BURO_YAZILIMLARI)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_OFFICE_SOFTWARES WHERE SOFTWARE_ID IN (#attributes.BURO_YAZILIMLARI#))</cfif>
			<cfif len(attributes.CONNECTION_NAME)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_SERVICE_INFO WHERE NET_CONNECTION IN (#attributes.CONNECTION_NAME#))</cfif>
			<cfif len(attributes.PC_NUMBER)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_SERVICE_INFO WHERE PC_NUMBER IN (#attributes.PC_NUMBER#))</cfif>
			<cfif len(attributes.CONCERN_NAME)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_SERVICE_INFO WHERE IT_CONCERNED IN (#attributes.CONCERN_NAME#))</cfif>
			<cfif len(attributes.RIVAL_NAME)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_PARTNER_RIVAL WHERE RIVAL_ID IN (#attributes.RIVAL_NAME#))</cfif>
			<cfif len(attributes.SUNULAN_OPSIYON)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_RIVAL_OPTION_APPLY WHERE OPTION_ID IN (#attributes.SUNULAN_OPSIYON#))</cfif>
			<cfif len(attributes.YAPILAN_ETKINLIKLER)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_RIVAL_ACTIVITY WHERE ACTIVITY_ID IN (#attributes.YAPILAN_ETKINLIKLER#))</cfif>
			<cfif len(attributes.SERVIS_SAYISI)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_RIVAL_DETAIL WHERE (SERVICE_NUMBER #attributes.SERVIS_SAYISI_CONDITION# #attributes.SERVIS_SAYISI#))</cfif>
			<cfif len(attributes.ILISKI_DUZEYI)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_RIVAL_DETAIL WHERE RELATION_LEVEL =  #attributes.ILISKI_DUZEYI#)</cfif>
			<cfif len(attributes.OZEL_BILGILER)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_RIVAL_DETAIL WHERE SPECIAL_INFO LIKE '%#attributes.OZEL_BILGILER#%' )</cfif>
		<!--- Datetime Values --->
		<cfif len(attributes.BIRTHDATE1) and (attributes.BIRTHDATE1 neq "NULL")>AND BIRTHDATE #attributes.BIRTHDATE_CONDITION# <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.BIRTHDATE1#"></cfif>
		<cfif len(attributes.MARRIED_DATE1) and (attributes.MARRIED_DATE1 neq "NULL")>AND MARRIED_DATE #attributes.MARRIED_DATE_CONDITION# <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.MARRIED_DATE1#"></cfif>
		<!--- Vharchar ve Text Valueler --->
		<cfif len(attributes.TAXNUM)>AND TAXNO #attributes.TAXNUM_CONDITION#  '<cfif attributes.TAXNUM_CONDITION is "LIKE">%</cfif>#attributes.TAXNUM#<cfif attributes.TAXNUM_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.TAXOFFICE)>AND TAXOFFICE #attributes.TAXOFFICE_CONDITION#  '<cfif attributes.TAXOFFICE_CONDITION is "LIKE">%</cfif>#attributes.TAXOFFICE#<cfif attributes.TAXOFFICE_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.TELEPHONE)>AND COMPANY_TEL1 #attributes.TELEPHONE_CONDITION#  '<cfif attributes.TELEPHONE_CONDITION is "LIKE">%</cfif>#attributes.TELEPHONE#<cfif attributes.TELEPHONE_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.EMAIL)>AND COMPANY_EMAIL #attributes.EMAIL_CONDITION#  '<cfif attributes.EMAIL_CONDITION is "LIKE">%</cfif>#attributes.EMAIL#<cfif attributes.EMAIL_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.FULLNAME)>AND FULLNAME #attributes.FULLNAME_CONDITION#  '<cfif attributes.FULLNAME_CONDITION is "LIKE">%</cfif>#attributes.FULLNAME#<cfif attributes.FULLNAME_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.COMPANY_PARTNER_AD)>AND COMPANY_PARTNER_NAME #attributes.COMPANY_PARTNER_AD_CONDITION#  '<cfif attributes.COMPANY_PARTNER_AD_CONDITION is "LIKE">%</cfif>#attributes.COMPANY_PARTNER_AD#<cfif attributes.COMPANY_PARTNER_AD_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.COMPANY_PARTNER_SOYAD)>AND COMPANY_PARTNER_SURNAME #attributes.COMPANY_PARTNER_AD_CONDITION#  '<cfif attributes.COMPANY_PARTNER_AD_CONDITION is "LIKE">%</cfif>#attributes.COMPANY_PARTNER_SOYAD#<cfif attributes.COMPANY_PARTNER_AD_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.COMPANY_ADDRESS)>AND DISTRICT #attributes.COMPANY_ADDRESS_CONDITION# '<cfif attributes.COMPANY_ADDRESS_CONDITION is "LIKE">%</cfif>#attributes.COMPANY_ADDRESS#<cfif attributes.COMPANY_ADDRESS_CONDITION eq "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.SEMT)>AND SEMT #attributes.SEMT_CONDITION# '<cfif attributes.SEMT_CONDITION is "LIKE">%</cfif>#attributes.SEMT#<cfif attributes.SEMT_CONDITION is "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.CADDE)>AND MAIN_STREET #attributes.CADDE_CONDITION# '<cfif attributes.CADDE_CONDITION is "LIKE">%</cfif>#attributes.CADDE#<cfif attributes.CADDE_CONDITION eq "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.SOKAK)>AND STREET #attributes.SOKAK_CONDITION# '<cfif attributes.SOKAK_CONDITION is "LIKE">%</cfif>#attributes.SOKAK#<cfif attributes.SOKAK_CONDITION eq "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.NO)>AND DUKKAN_NO #attributes.NO_CONDITION# '<cfif attributes.NO_CONDITION is "LIKE">%</cfif>#attributes.NO#<cfif attributes.NO_CONDITION eq "LIKE">%</cfif>'</cfif>
		<cfif len(attributes.BIRTHPLACE) and (attributes.BIRTHPLACE neq "NULL")>AND BIRTHPLACE = '#attributes.BIRTHPLACE#'</cfif>
		<cfif len(attributes.TC_IDENTITY) and TC_IDENTITY_CONDITION eq 1>AND TC_IDENTITY = '#attributes.TC_IDENTITY#'<cfelseif TC_IDENTITY_CONDITION eq 2>AND TC_IDENTITY IS NULL</cfif>
		<cfif len(attributes.CARIHESAPKOD)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CARIHESAPKOD = '#attributes.CARIHESAPKOD#' )</cfif>
		<cfif len(attributes.ISCUSTOMERCONTRACT)>AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND CUSTOMER_CONTRACT_STATUTE = #attributes.ISCUSTOMERCONTRACT#)</cfif>
	ORDER BY
		FULLNAME,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
</cfquery>
<cfif isdefined("attributes.RISK_LIMIT_VIEW")>
	<cfquery name="GET_RISK" datasource="#DSN#">
		SELECT
			COMPANY_CREDIT.COMPANY_ID,
			COMPANY_CREDIT.TOTAL_RISK_LIMIT,
			COMPANY_CREDIT.MONEY
		FROM
			COMPANY_CREDIT
	</cfquery>
</cfif>
<cfif isdefined("attributes.COMPANYCAT_VIEW")>
	<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
		SELECT COMPANYCAT, COMPANYCAT_ID FROM COMPANY_CAT <cfif isdefined("attributes.COMPANYCAT") and len(attributes.COMPANYCAT)>WHERE COMPANYCAT_ID IN (#attributes.COMPANYCAT#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.IMS_CODE_VIEW")>
	<cfquery name="GET_IMS_CODE" datasource="#DSN#">
		SELECT IMS_CODE_ID, IMS_CODE, IMS_CODE_NAME FROM SETUP_IMS_CODE <cfif len(attributes.IMS_CODE)>WHERE IMS_CODE_ID IN (#attributes.IMS_CODE#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.CITY_NAME_VIEW")>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_ID, CITY_NAME FROM SETUP_CITY <cfif len(attributes.city_id)>WHERE CITY_ID = #attributes.city_id#</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.COUNTY_NAME_VIEW")>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY <cfif len(attributes.COUNTY_NAME)>WHERE COUNTY_ID = #attributes.COUNTY_ID#</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.NICK_NAME_VIEW") or isdefined("attributes.PARTNER_RELATION_VIEW") or isdefined("attributes.RESOURCE_VIEW") or isdefined("attributes.PLASIYER_ID_VIEW") or isdefined("attributes.BSM_ID_VIEW") or isdefined("attributes.TELEFON_ID_VIEW") or isdefined("attributes.TAHSILAT_ID_VIEW") or isdefined("attributes.ITRIYAT_ID_VIEW")  or isdefined("attributes.BOLGE_KODU_VIEW") or isdefined("attributes.ODEME_SEKLI_VIEW") or isdefined("attributes.CEP_SIRA_VIEW") or isdefined("attributes.TR_STATUS_VIEW") or isdefined("attributes.CARIHESAPKOD_VIEW") or isdefined("attributes.ISCUSTOMERCONTRACT_VIEW")>
	<cfquery name="GET_NICKNAME" datasource="#DSN#">
		SELECT 
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			COMPANY_BRANCH_RELATED.COMPANY_ID,
			COMPANY_BRANCH_RELATED.RELATION_STATUS,
			COMPANY_BRANCH_RELATED.RELATION_START,
			COMPANY_BRANCH_RELATED.PLASIYER_ID,
			COMPANY_BRANCH_RELATED.SALES_DIRECTOR,
			COMPANY_BRANCH_RELATED.TEL_SALE_PREID,
			COMPANY_BRANCH_RELATED.TAHSILATCI,
			COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI,
			COMPANY_BRANCH_RELATED.BOLGE_KODU,
			COMPANY_BRANCH_RELATED.CALISMA_SEKLI,
			COMPANY_BRANCH_RELATED.CEP_SIRA,
			COMPANY_BRANCH_RELATED.MUSTERIDURUM,
			COMPANY_BRANCH_RELATED.CARIHESAPKOD,
			COMPANY_BRANCH_RELATED.CUSTOMER_CONTRACT_STATUTE
		FROM
			BRANCH,
			COMPANY_BRANCH_RELATED
		WHERE			
			BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
			COMPANY_BRANCH_RELATED.CARIHESAPKOD IS NOT NULL
			<cfif isdefined("attributes.TR_STATUS") and len(attributes.TR_STATUS)>AND COMPANY_BRANCH_RELATED.MUSTERIDURUM IN (#attributes.TR_STATUS#)</cfif>
			<cfif isdefined("attributes.TELEFON_ID") and len(attributes.TELEFON_ID)>AND COMPANY_BRANCH_RELATED.TEL_SALE_PREID = #attributes.TELEFON_ID#</cfif>
			<cfif isdefined("attributes.BSM_ID") and len(attributes.BSM_ID)>AND COMPANY_BRANCH_RELATED.ZONE_DIRECTOR = #attributes.BSM_ID#</cfif>
			<cfif isdefined("attributes.PLASIYER_ID") and len(attributes.PLASIYER_ID)>AND COMPANY_BRANCH_RELATED.PLASIYER_ID = #attributes.PLASIYER_ID#</cfif>
			<cfif isdefined("attributes.TAHSILAT_ID") and len(attributes.TAHSILAT_ID)>AND COMPANY_BRANCH_RELATED.TAHSILATCI = #attributes.TAHSILAT_ID#</cfif>
			<cfif isdefined("attributes.ITRIYAT_ID") and len(attributes.ITRIYAT_ID)>AND COMPANY_BRANCH_RELATED.ITRIYAT_GOREVLI = #attributes.ITRIYAT_ID#</cfif>
			<cfif isdefined("attributes.BOLGE_KODU") and len(attributes.BOLGE_KODU)>AND COMPANY_BRANCH_RELATED.BOLGE_KODU LIKE '%#attributes.BOLGE_KODU#%'</cfif>
			<cfif isdefined("attributes.ODEME_SEKLI") and len(attributes.ODEME_SEKLI)>AND COMPANY_BRANCH_RELATED.CALISMA_SEKLI LIKE '%#attributes.ODEME_SEKLI#%'</cfif>
			<cfif isdefined("attributes.CEP_SIRA") and len(attributes.CEP_SIRA)>AND COMPANY_BRANCH_RELATED.CALISMA_SEKLI LIKE '%#attributes.CEP_SIRA#%'</cfif>
			<cfif isdefined("attributes.NICK_NAME") and len(attributes.NICK_NAME)>AND BRANCH.BRANCH_ID IN (#attributes.NICK_NAME#)</cfif>
			<cfif isdefined("attributes.PARTNER_RELATION") and len(attributes.PARTNER_RELATION)>AND COMPANY_BRANCH_RELATED.RELATION_STATUS IN (#attributes.PARTNER_RELATION#)</cfif>
			<cfif isdefined("attributes.RESOURCE") and len(attributes.RESOURCE)>AND COMPANY_BRANCH_RELATED.RELATION_START IN (#attributes.RESOURCE#)</cfif>
			<cfif isdefined("attributes.CARIHESAPKOD") and len(attributes.CARIHESAPKOD)>AND COMPANY_BRANCH_RELATED.CARIHESAPKOD = '#attributes.CARIHESAPKOD#'</cfif>
			<cfif len(attributes.ISCUSTOMERCONTRACT) and attributes.ISCUSTOMERCONTRACT eq 1>AND COMPANY_BRANCH_RELATED.CUSTOMER_CONTRACT_STATUTE = 1<cfelseif len(attributes.ISCUSTOMERCONTRACT) and attributes.ISCUSTOMERCONTRACT eq 0>AND COMPANY_BRANCH_RELATED.CUSTOMER_CONTRACT_STATUTE = 0</cfif>
	</cfquery>
</cfif>

<cfif isdefined("attributes.ASSISTANCE_STATUS_VIEW")>
	<cfquery name="GET_MISSION" datasource="#DSN#">
		SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION <cfif isdefined("attributes.ASSISTANCE_STATUS") and len(attributes.ASSISTANCE_STATUS)>WHERE PARTNER_POSITION_ID IN (#attributes.ASSISTANCE_STATUS#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.UNIVERSITY_NAME_VIEW")>
	<cfquery name="GET_UNIVERSTY" datasource="#DSN#">
		SELECT UNIVERSITY_NAME, UNIVERSITY_ID FROM SETUP_UNIVERSITY <cfif isdefined("attributes.UNIVERSITY_NAME") and len(attributes.UNIVERSITY_NAME)>WHERE UNIVERSITY_ID IN (#attributes.UNIVERSITY_NAME#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.HOBBY_NAME_VIEW")>
	<cfquery name="GET_HOBBY" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_HOBBY.HOBBY_ID,
			SETUP_HOBBY.HOBBY_NAME,
			COMPANY_PARTNER_HOBBY.PARTNER_ID
		FROM
			SETUP_HOBBY,
			COMPANY_PARTNER_HOBBY
		WHERE
			COMPANY_PARTNER_HOBBY.HOBBY_ID = SETUP_HOBBY.HOBBY_ID
			<cfif len(attributes.HOBBY_NAME)>AND COMPANY_PARTNER_HOBBY.HOBBY_ID IN (#attributes.HOBBY_NAME#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.SOCIETY_VIEW")>
	<cfquery name="GET_SOCIETY" datasource="#DSN#">
		SELECT
			SETUP_SOCIAL_SOCIETY.SOCIETY_ID,
			SETUP_SOCIAL_SOCIETY.SOCIETY,
			COMPANY_PARTNER_SOCIETY.COMPANY_ID
		FROM
			SETUP_SOCIAL_SOCIETY,
			COMPANY_PARTNER_SOCIETY
		WHERE
			SETUP_SOCIAL_SOCIETY.SOCIETY_ID = COMPANY_PARTNER_SOCIETY.SOCIETY_ID
			<cfif len(attributes.SOCIETY)>AND COMPANY_PARTNER_SOCIETY.SOCIETY_ID IN (#attributes.SOCIETY#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.GENEL_KONUM_VIEW")>
	<cfquery name="GET_POSITION" datasource="#DSN#">
		SELECT 
			COMPANY_POSITION.COMPANY_ID,
			COMPANY_POSITION.POSITION_ID,
			SETUP_CUSTOMER_POSITION.POSITION_NAME 
		FROM 
			SETUP_CUSTOMER_POSITION, 
			COMPANY_POSITION
		WHERE 
			COMPANY_POSITION.POSITION_ID = SETUP_CUSTOMER_POSITION.POSITION_ID
			<cfif len(attributes.GENEL_KONUM)>AND COMPANY_POSITION.POSITION_ID IN (#attributes.GENEL_KONUM#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.SECTOR_CAT_VIEW")>
	<cfquery name="GET_SECTORCAT" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_JOB_OTHER.JOB_ID,
			COMPANY_PARTNER_JOB_OTHER.COMPANY_ID,
			SETUP_SECTOR_CATS.SECTOR_CAT
		FROM 
			COMPANY_PARTNER_JOB_OTHER,
			SETUP_SECTOR_CATS
		WHERE 
			COMPANY_PARTNER_JOB_OTHER.JOB_ID = SETUP_SECTOR_CATS.SECTOR_CAT_ID
			<cfif len(attributes.SECTOR_CAT)>AND SETUP_SECTOR_CATS.SECTOR_CAT_ID IN (#attributes.SECTOR_CAT#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.NOBET_DURUMU_VIEW")>
	<cfquery name="GET_NOBET" datasource="#DSN#">
		SELECT PERIOD_ID, PERIOD_NAME FROM SETUP_DUTY_PERIOD <cfif isdefined("attributes.PERIOD_NAME") and len(attributes.PERIOD_NAME)>WHERE PERIOD_ID IN (#attributes.PERIOD_NAME#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.BURO_YAZILIMLARI_VIEW")>
	<cfquery name="GET_STUFF" datasource="#DSN#">
		SELECT 
			COMPANY_OFFICE_SOFTWARES.SOFTWARE_ID,
			SETUP_OFFICE_STUFF.STUFF_NAME,
			COMPANY_OFFICE_SOFTWARES.COMPANY_ID 
		FROM 
			SETUP_OFFICE_STUFF,
			COMPANY_OFFICE_SOFTWARES
		WHERE 
			SETUP_OFFICE_STUFF.STUFF_ID = COMPANY_OFFICE_SOFTWARES.SOFTWARE_ID
			<cfif len(attributes.BURO_YAZILIMLARI)>AND COMPANY_OFFICE_SOFTWARES.SOFTWARE_ID IN (#attributes.BURO_YAZILIMLARI#)</cfif> 
	</cfquery>
</cfif>
<cfif isdefined("attributes.CONNECTION_NAME_VIEW")>
	<cfquery name="GET_NET_CONNECTION" datasource="#DSN#">
		SELECT
			SETUP_NET_CONNECTION.CONNECTION_ID, 
			SETUP_NET_CONNECTION.CONNECTION_NAME,
			COMPANY_SERVICE_INFO.COMPANY_ID
		FROM 
			COMPANY_SERVICE_INFO,
			SETUP_NET_CONNECTION
		WHERE
			COMPANY_SERVICE_INFO.NET_CONNECTION = SETUP_NET_CONNECTION.CONNECTION_ID
			<cfif len(attributes.CONNECTION_NAME)>AND SETUP_NET_CONNECTION.CONNECTION_ID IN (#attributes.CONNECTION_NAME#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.PC_NUMBER_VIEW")>
	<cfquery name="GET_PC_NUMBER" datasource="#DSN#">
		SELECT 
			SETUP_PC_NUMBER.UNIT_ID, 
			SETUP_PC_NUMBER.UNIT_NAME,
			COMPANY_SERVICE_INFO.COMPANY_ID
		FROM 
			SETUP_PC_NUMBER,
			COMPANY_SERVICE_INFO
		WHERE
			COMPANY_SERVICE_INFO.PC_NUMBER = SETUP_PC_NUMBER.UNIT_ID
			<cfif len(attributes.PC_NUMBER)>AND SETUP_PC_NUMBER.UNIT_ID = #attributes.PC_NUMBER#</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.CONCERN_NAME_VIEW")>
	<cfquery name="GET_CONCERN" datasource="#DSN#">
		SELECT 
			SETUP_IT_CONCERNED.CONCERN_ID,
			SETUP_IT_CONCERNED.CONCERN_NAME,
			COMPANY_SERVICE_INFO.COMPANY_ID
		FROM
			COMPANY_SERVICE_INFO,
			SETUP_IT_CONCERNED
		WHERE
			SETUP_IT_CONCERNED.CONCERN_ID = COMPANY_SERVICE_INFO.IT_CONCERNED
			<cfif len(attributes.CONCERN_NAME)>AND SETUP_IT_CONCERNED.CONCERN_ID = #attributes.CONCERN_NAME#</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.RIVAL_NAME_VIEW")>
	<cfquery name="GET_RIVAL" datasource="#DSN#">
		SELECT
			SETUP_RIVALS.R_ID,
			SETUP_RIVALS.RIVAL_NAME,
			COMPANY_PARTNER_RIVAL.COMPANY_ID
		FROM
			COMPANY_PARTNER_RIVAL,
			SETUP_RIVALS
		WHERE
			COMPANY_PARTNER_RIVAL.RIVAL_ID = SETUP_RIVALS.R_ID
			<cfif len(attributes.RIVAL_NAME)>AND SETUP_RIVALS.R_ID IN  (#attributes.RIVAL_NAME#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.SUNULAN_OPSIYON_VIEW")>
	<cfquery name="GET_APPLY" datasource="#DSN#">
		SELECT
			COMPANY_RIVAL_OPTION_APPLY.OPTION_ID,
			SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON,
			COMPANY_RIVAL_OPTION_APPLY.COMPANY_ID
		FROM
			SETUP_RIVAL_PREFERENCE_REASONS,
			COMPANY_RIVAL_OPTION_APPLY
		WHERE
			COMPANY_RIVAL_OPTION_APPLY.OPTION_ID = SETUP_RIVAL_PREFERENCE_REASONS.PREFERENCE_REASON_ID
			<cfif len(attributes.SUNULAN_OPSIYON)>AND COMPANY_RIVAL_OPTION_APPLY.OPTION_ID IN (#attributes.SUNULAN_OPSIYON#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.YAPILAN_ETKINLIKLER_VIEW")>
	<cfquery name="GET_ETKINLIK" datasource="#DSN#">
		SELECT 
			A.ACTIVITY_ID, 
			B.ACTIVITY_NAME,
			A.COMPANY_ID
		FROM 
			COMPANY_RIVAL_ACTIVITY A, 
			SETUP_RIVALS_ACTIVITY B
		WHERE 
			A.ACTIVITY_ID = B.ACTIVITY_ID
			<cfif len(attributes.YAPILAN_ETKINLIKLER)>AND A.ACTIVITY_ID IN (#attributes.YAPILAN_ETKINLIKLER#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.SERVIS_SAYISI_VIEW")>
	<cfquery name="GET_RIVAL_DETAIL" datasource="#DSN#">
		SELECT SERVICE_NUMBER, COMPANY_ID FROM COMPANY_RIVAL_DETAIL
	</cfquery>
</cfif>
<cfif isdefined("attributes.OZEL_BILGILER")>
	<cfquery name="GET_SPECIAL" datasource="#DSN#">
		SELECT SPECIAL_INFO, COMPANY_ID FROM COMPANY_RIVAL_DETAIL
	</cfquery>
</cfif>
<cfif isdefined("attributes.YAPILAN_ETKINLIKLER_VIEW")>
	<cfquery name="GET_ETKINLIK" datasource="#DSN#">
		SELECT 
			A.ACTIVITY_ID, 
			B.ACTIVITY_NAME,
			A.COMPANY_ID
		FROM 
			COMPANY_RIVAL_ACTIVITY A, 
			SETUP_RIVALS_ACTIVITY B
		WHERE 
			A.ACTIVITY_ID = B.ACTIVITY_ID
			<cfif len(attributes.YAPILAN_ETKINLIKLER)>AND A.ACTIVITY_ID IN (#attributes.YAPILAN_ETKINLIKLER#)</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.TR_STATUS_VIEW")>
	<cfquery name="GET_STATUS" datasource="#DSN#">
		SELECT 
			TR_ID, 
			TR_NAME 
		FROM 
			SETUP_MEMBERSHIP_STAGES
	</cfquery>
</cfif>
