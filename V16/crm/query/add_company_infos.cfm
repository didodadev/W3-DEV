<cfif (attributes.old_fullname neq attributes.fullname) or (attributes.old_city neq attributes.city_id) or (attributes.old_county_id neq attributes.county_id_) or (attributes.old_ims_code neq attributes.ims_code_id)>
	<cfquery name="UPD_CONTROL" datasource="#dsn#">
		SELECT 
			RECORD_DATE
		FROM 
			COMPANY_BRANCH_RELATED
		WHERE
			MUSTERIDURUM IS NOT NULL AND
			BRANCH_ID = #attributes.old_branch_id# AND
			COMPANY_ID = #attributes.cpid# AND
			RECORD_DATE > #DATEADD("d",-1,now())#
	</cfquery>
	<cfif UPD_CONTROL.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no ='987.Bu Kayıt İçin Güncelleme Yapamazsınız!Gerekli Bilgi İçin Yetkiliyi Arayınız'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>
<cfif isdefined("attributes.open_date") and len(attributes.open_date)>
	<cf_date tarih='attributes.open_date'>
</cfif>
<cfquery name="UPD_COMPANY" datasource="#dsn#">
	UPDATE
		COMPANY
	SET
		FULLNAME = '#attributes.fullname#',
		COMPANYCAT_ID = #attributes.companycat_id#,
		TAXNO = <cfif len(attributes.tax_num)>'#attributes.tax_num#',<cfelse>NULL,</cfif>
		TAXOFFICE = <cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
		DISTRICT = <cfif len(attributes.district)>'#attributes.district#',<cfelse>NULL,</cfif>
		CITY = <cfif len(attributes.city_id)>#attributes.city_id#,<cfelse>NULL,</cfif>
		MAIN_STREET = <cfif len(attributes.main_street)>'#attributes.main_street#',<cfelse>NULL,</cfif>
		COUNTY = <cfif len(attributes.county_id_)>#attributes.county_id_#,<cfelse>NULL,</cfif>
		STREET = <cfif len(attributes.street)>'#attributes.street#',<cfelse>NULL,</cfif>
		SEMT = <cfif len(attributes.semt)>'#attributes.semt#',<cfelse>NULL,</cfif>
		DUKKAN_NO = <cfif len(attributes.dukkan_no)>'#attributes.dukkan_no#',<cfelse>NULL,</cfif>
		COUNTRY = <cfif len(attributes.country_)>#attributes.country_#,<cfelse>NULL,</cfif>
		COMPANY_POSTCODE = <cfif len(attributes.post_code)>'#attributes.post_code#',<cfelse>NULL,</cfif>
		COMPANY_TELCODE = <cfif len(attributes.telcod)>'#attributes.telcod#',<cfelse>NULL,</cfif>
		COMPANY_TEL1 = <cfif len(attributes.country_)>'#attributes.tel1#',<cfelse>NULL,</cfif>
		IMS_CODE_ID = <cfif len(attributes.ims_code_id)>#attributes.ims_code_id#<cfelse>NULL</cfif>
	WHERE
		COMPANY_ID = #attributes.cpid#
</cfquery>
<cfquery name="UPD_COMPANY_PARTNER" datasource="#dsn#">
	UPDATE
		COMPANY_PARTNER
	SET
		COMPANY_PARTNER_NAME = '#attributes.company_partner_name#',
		COMPANY_PARTNER_SURNAME = '#attributes.company_partner_surname#'
	WHERE
		PARTNER_ID = #attributes.partner_id#
</cfquery>
<cfquery name="UPD_BRANCH_RELATED" datasource="#dsn#">
	UPDATE
		COMPANY_BRANCH_RELATED
	SET
		MUSTERIDURUM = <cfif len(attributes.durum)>#attributes.durum#,<cfelse>NULL,</cfif>
		BRANCH_ID = <cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
		TEL_SALE_PREID = <cfif len(attributes.telefon_satis) and len(attributes.telefon_satis_id)>#attributes.telefon_satis_id#,<cfelse>NULL,</cfif>
		PLASIYER_ID = <cfif len(attributes.plasiyer) and len(attributes.plasiyer_id)>#attributes.plasiyer_id#,<cfelse>NULL,</cfif>
		SALES_DIRECTOR = <cfif len(attributes.satis_muduru) and len(attributes.satis_muduru_id)>#attributes.satis_muduru_id#,<cfelse>NULL,</cfif>
		VALID_EMP = #session.ep.userid#,
		VALID_DATE = #now()#,
		CARIHESAPKOD = <cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#',<cfelse>NULL,</cfif> 
		TAHSILATCI = <cfif len(attributes.tahsilatci) and len(attributes.tahsilatci_id)>#attributes.tahsilatci_id#,<cfelse>NULL,</cfif>
		ITRIYAT_GOREVLI = <cfif len(attributes.itriyat) and len(attributes.itriyat_id)>#attributes.itriyat_id#,<cfelse>NULL,</cfif>
		BOYUT_TAHSILAT = <cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#',<cfelse>NULL,</cfif>
		BOYUT_ITRIYAT = <cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#',<cfelse>NULL,</cfif>
		BOYUT_TELEFON = <cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#',<cfelse>NULL,</cfif>
		BOYUT_PLASIYER = <cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#',<cfelse>NULL,</cfif>
		BOYUT_BSM = <cfif len(attributes.boyut_bsm)>'#attributes.boyut_bsm#',<cfelse>NULL,</cfif>
		OPEN_DATE = <cfif isdefined("attributes.open_date") and len(attributes.open_date)>#attributes.open_date#,<cfelse>NULL,</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
	WHERE
		BRANCH_ID = #attributes.old_branch_id# AND
		COMPANY_ID = #attributes.cpid#
</cfquery>
<!--- kapama ve devir islemleri icin,
bir sube kapandıgında veya devir oldugunda diger butun subeler kapanmalı veya devir olmalıdır--->
<cfif listfind("1,2",attributes.durum,',')>
	<cfquery name="CLOSE_COMPANY_RELATED" datasource="#dsn#">
		UPDATE 
			COMPANY_BRANCH_RELATED
		SET
			MUSTERIDURUM = #attributes.durum#
		WHERE
			COMPANY_ID = #attributes.cpid#
	</cfquery>
</cfif>
<script type="text/javascript">
	location.href = document.referrer;
</script>
