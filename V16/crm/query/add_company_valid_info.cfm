<cfif len(attributes.open_date)>
	<cf_date tarih='attributes.open_date'>
</cfif>
<cflock  name="#CREATEUUID()#" timeout="20">
	<cftransaction>
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
			INSERT
			INTO
				COMPANY_BRANCH_RELATED
				(
					COMPANY_ID,
					MUSTERIDURUM,
					BRANCH_ID,
					TEL_SALE_PREID,
					PLASIYER_ID,
					SALES_DIRECTOR,
					VALID_EMP,
					VALID_DATE,
					CARIHESAPKOD,
					<!--- MUHASEBEKOD, --->
					TAHSILATCI,
					ITRIYAT_GOREVLI,
					BOYUT_TAHSILAT,
					BOYUT_ITRIYAT,
					BOYUT_TELEFON,
					BOYUT_PLASIYER,
					BOYUT_BSM,
					IS_SELECT,
					DEPO_STATUS,
					OPEN_DATE
				)
				VALUES
				(
					 #attributes.cpid#,
					 <cfif len(attributes.durum)>#attributes.durum#,<cfelse>NULL,</cfif>
					 <cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
					 <cfif len(attributes.telefon_satis) and len(attributes.telefon_satis_id)>#attributes.telefon_satis_id#,<cfelse>NULL,</cfif>
					 <cfif len(attributes.plasiyer) and len(attributes.plasiyer_id)>#attributes.plasiyer_id#,<cfelse>NULL,</cfif>
					 <cfif len(attributes.satis_muduru) and len(attributes.satis_muduru_id)>#attributes.satis_muduru_id#,<cfelse>NULL,</cfif>
					 #session.ep.userid#,
					 #now()#,
					 <cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#',<cfelse>NULL,</cfif> 
					 <!--- <cfif len(attributes.muhasebekod)>'#attributes.muhasebekod#',<cfelse>NULL,</cfif> --->
					 <cfif len(attributes.tahsilatci) and len(attributes.tahsilatci_id)>#attributes.tahsilatci_id#,<cfelse>NULL,</cfif>
					 <cfif len(attributes.itriyat) and len(attributes.itriyat_id)>#attributes.itriyat_id#,<cfelse>NULL,</cfif>
					 <cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#',<cfelse>NULL,</cfif>
					 <cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#',<cfelse>NULL,</cfif>
					 <cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#',<cfelse>NULL,</cfif>
					 <cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#',<cfelse>NULL,</cfif>
					 <cfif len(attributes.boyut_bsm)>'#attributes.boyut_bsm#',<cfelse>NULL,</cfif>
					 1,
					 13,
					 #attributes.open_date#
				)
		</cfquery>
		<cfquery name="GET_OUR_COMPANY" datasource="#dsn#">
			SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_STORES_RELATED" datasource="#dsn#">
			INSERT
			INTO
				COMPANY_PARTNER_STORES_RELATED
				(
					COMPANY_ID,
					OUR_COMPANY_ID
				)
				VALUES
				(
					#attributes.cpid#,
					#get_our_company.company_id#
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	location.href = document.referrer;
</script>
