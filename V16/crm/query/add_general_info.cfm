<cfif (attributes.old_ims_code neq attributes.ims_code_id) or (attributes.old_city neq attributes.city)>
	<cfquery name="GET_BRANCH_RELATED1" datasource="#dsn#">
		SELECT 
			MUSTERIDURUM 
		FROM 
			COMPANY_BRANCH_RELATED 
		WHERE 
			MUSTERIDURUM IS NOT NULL AND
			COMPANY_ID = #attributes.cpid# AND 
			MUSTERIDURUM = 1
	</cfquery>
	<cfquery name="GET_BRANCH_RELATED2" datasource="#dsn#">
		SELECT 
			MUSTERIDURUM 
		FROM 
			COMPANY_BRANCH_RELATED 
		WHERE 
			MUSTERIDURUM IS NOT NULL AND
			COMPANY_ID = #attributes.cpid# AND 
			MUSTERIDURUM <> 1
	</cfquery>
	<cfif (get_branch_related1.recordcount gt 0) and (get_branch_related2.recordcount eq 0)>
	<cfelse>
		<cfquery name="UPD_CONTROL" datasource="#dsn#">
			SELECT 
				*
			FROM 
				COMPANY_BRANCH_RELATED
			WHERE
				MUSTERIDURUM IS NOT NULL AND
				COMPANY_ID = #attributes.cpid# AND
				RECORD_DATE < #DATEADD("d",-1,now())#
		</cfquery>
		<cfif upd_control.recordcount>
			<script type="text/javascript">
				alert("Bu Müşteri Bazı Şubeleriniz İle Hala Çalışmakta.Bu Sebeple IMS ve İl Bilgilerini Değiştirmeniz Durumunda Bu Kayıt İçin Güncelleme Yapamazsınız!Gerekli Bilgi İçin Yetkiliyi Arayınız!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>
<!--- TC Kimlik No ve Vergi Numarasi Kontrolu --->
<cfif (attributes.company_work_type eq 1) and (attributes.old_taxnum neq attributes.tax_num)>
	<cfquery name="CONTROL_VERGINO" datasource="#dsn#">
		SELECT COMPANY_ID FROM COMPANY WHERE TAXNO = '#attributes.tax_num#' AND COMPANY_ID <> #attributes.cpid#
	</cfquery>
	<cfif control_vergino.recordcount>
		<cfquery name="GET_KONTROL" datasource="#dsn#">
			SELECT MUSTERIDURUM,COMPANY_ID FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID IN (#valuelist(control_vergino.company_id)#)
		</cfquery>
		<cfoutput query="GET_KONTROL">
			<script type="text/javascript">
				alert('Vergi Numarası veya TC Kimlik No İle Eczane Var ! Kontrol Ediniz !');
				history.back();
			</script>
			<cfabort>
		</cfoutput>
	</cfif>
</cfif>
<cfset attributes.is_record = false>
<cftry>
  <cftransaction>
	<cfquery name="ADD_COMPANY" datasource="#DSN#">
		UPDATE
			COMPANY
		SET
			IS_BUYER = 1,
			COMPANYCAT_ID = <cfif len(attributes.companycat_id)>#attributes.companycat_id#<cfelse>NULL</cfif>,
			FULLNAME = '#attributes.fullname#',
			TAXOFFICE = '#attributes.tax_office#',
			COMPANY_TELCODE = '#attributes.telcod#',
			COMPANY_TEL1 = <cfif len(attributes.tel1)>'#attributes.tel1#'<cfelse>NULL</cfif>,
			COMPANY_TEL2 = <cfif len(attributes.tel2)>'#attributes.tel2#'<cfelse>NULL</cfif>,
			COMPANY_TEL3 = <cfif len(attributes.tel3)>'#attributes.tel3#'<cfelse>NULL</cfif>,
			DISTRICT = '#attributes.district#',
			MAIN_STREET = <cfif len(attributes.main_street)>'#attributes.main_street#'<cfelse>NULL</cfif>,
			IMS_CODE_ID = #attributes.ims_code_id#,
			STREET = <cfif len(attributes.street)>'#attributes.street#'<cfelse>NULL</cfif>,
			COMPANY_ADDRESS = <cfif len(attributes.district) or len(attributes.main_street) or len(attributes.street) or len(attributes.dukkan_no)>'#attributes.district# #attributes.main_street# #attributes.street# #attributes.dukkan_no#'<cfelse>NULL</cfif>,
			COMPANY_FAX = <cfif len(attributes.fax)>'#attributes.fax#'<cfelse>NULL</cfif>,
			COMPANY_FAX_CODE = <cfif len(attributes.faxcode)>'#attributes.faxcode#'<cfelse>NULL</cfif>,
			DUKKAN_NO = <cfif len(attributes.dukkan_no)>'#attributes.dukkan_no#'<cfelse>NULL</cfif>,
			COMPANY_EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
			COMPANY_POSTCODE = <cfif len(attributes.post_code)>'#attributes.post_code#'<cfelse>NULL</cfif>,
			HOMEPAGE = <cfif len(attributes.homepage)>'#attributes.homepage#'<cfelse>NULL</cfif>,
			EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>,
			SEMT = <cfif len(attributes.semt)>'#attributes.semt#'<cfelse>NULL</cfif>,
			CITY = <cfif len(attributes.city)>#attributes.city#<cfelse>NULL</cfif>,
			COUNTY = <cfif len(attributes.county)>#attributes.county_id#<cfelse>NULL</cfif>,
			COUNTRY = <cfif len(attributes.country_id)>#attributes.country_id#<cfelse>NULL</cfif>,
			TAXNO = '#attributes.tax_num#',
			GRUP_RISK_LIMIT = <cfif len(attributes.group_risk_limit)>#attributes.group_risk_limit#<cfelse>0</cfif>,
			MONEY_CURRENCY = '#attributes.money_cat_expense#',
			GUESS_ENDORSEMENT = <cfif len(attributes.guess_endorsement)>#attributes.guess_endorsement#<cfelse>0</cfif>,
			GUESS_ENDORSEMENT_MONEY = '#attributes.guess_endorsement_money#',
			COMPANY_WORK_TYPE = #attributes.company_work_type#,
			EKSTRE = <cfif isdefined("attributes.ekstre")>1<cfelse>0</cfif>,
			GLNCODE = <cfif isdefined("attributes.glncode") and Len(attributes.glncode)>'#attributes.glncode#'<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'			
		WHERE
			COMPANY_ID = #attributes.cpid#
	</cfquery>
	<cfquery name="ADD_COMPANY_PARTNER" datasource="#DSN#">
		UPDATE
			COMPANY_PARTNER
		SET
			COMPANY_PARTNER_NAME = '#attributes.company_partner_name#',
			COMPANY_PARTNER_SURNAME = '#attributes.company_partner_surname#',
			COMPANY_PARTNER_EMAIL = <cfif len(attributes.email)>'#attributes.email#'<cfelse>NULL</cfif>
		  	<cfif (attributes.company_work_type eq 1) and (attributes.old_taxnum neq attributes.tax_num)>
			,TC_IDENTITY = '#attributes.tax_num#'
			</cfif>
		WHERE 
			PARTNER_ID = #attributes.company_partner_id#
	</cfquery>
	<cfquery name="GET_COMP_POTANTIAL" datasource="#DSN#">
		SELECT ISPOTANTIAL FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
	</cfquery>
	<cfquery name="GET_BSM_INFO" datasource="#DSN#">
		SELECT 
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_EMAIL,
			COMPANY.FULLNAME
		FROM
			COMPANY,
			COMPANY_BRANCH_RELATED,
			EMPLOYEE_POSITIONS
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			COMPANY.COMPANY_ID = #attributes.cpid# AND
			COMPANY_BRANCH_RELATED.COMPANY_ID = COMPANY.COMPANY_ID AND
			EMPLOYEE_POSITIONS.POSITION_CODE = COMPANY_BRANCH_RELATED.SALES_DIRECTOR AND 
			COMPANY_BRANCH_RELATED.MUSTERIDURUM NOT IN (1,4)
	</cfquery>
	<cfquery name="CHECK" datasource="#DSN#">
		SELECT ASSET_FILE_NAME2 FROM OUR_COMPANY WHERE COMP_ID = #session.ep.company_id#
	</cfquery>
	<cfoutput query="get_bsm_info">
	  <cfif len(get_bsm_info.employee_email)>
		<cfmail from="workcube@hedefalliance.com.tr" to="#get_bsm_info.employee_email#" subject="Güncelleme - #fullname#" type="html">
		<table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
		  <tr bgcolor="##000000">
			<td>
			<table cellspacing="1" cellpadding="2" width="100%" border="0">
			  <tr bgcolor="##FFFFFF">
			  	<td>
			  <cfif len(check.asset_file_name2)>
				<table cellpadding="10" cellspacing="10" bgcolor="FFFFFF" width="100%">
				  <tr> 
					<td align="center"><img src="#user_domain##file_web_path#settings/#check.asset_file_name2#" border="0"></td>
				  </tr>
				</table>
			  </cfif>
				</td>
			  </tr>
			  <tr bgcolor="##FFFFFF">
			  	<td>
				<table align="left">
				  <tr>
					<td colspan="2" style="font-size:12px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;font-weight: bold;">Sayın #employee_name# #employee_surname# ............</td>
				  </tr>
				  <tr>
					<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/><br/>#fullname# Genel Bilgilerinde #session.ep.name# #session.ep.surname# Tarafından Güncelleme Yapılmıştır.Bilginize..... </td>
				  </tr>
				  <tr>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">&nbsp;</td>
				  </tr>
				  <tr>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Eczane</td>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: #fullname#</td>
				  </tr>
				  <tr>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Güncelleme Yapan</td>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: #session.ep.name# #session.ep.surname#</td>
				  </tr>
				  <tr>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Güncelleme Tarihi</td>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: #dateformat(now(),dateformat_style)# #timeformat(now(), timeformat_style)#</td>
				  </tr>
				  <tr>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">Link</td>
					<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">: <a href="#employee_domain##request.self#?fuseaction=crm.form_upd_company&cpid=#attributes.cpid#" class="tableyazi ">#fullname#</a></td>
				  </tr>
				  <tr>
					<td></td>
				  </tr>
				</table>
			  	</td>
			  </tr>
			</table>
			</td>
		  </tr>
		</table>
		</cfmail>
	  </cfif>
	</cfoutput>
	<cfset attributes.is_record = true>
	</cftransaction>
	<cfcatch type="any">
		<script type="text/javascript">
			alert("Müşteri Bilgileri Güncellemede Problem Oluştu Lütfen Sistem Yönetisici İle Görüşün !");
			history.go(-1);
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<cfif attributes.is_record>
	<!--- KAPANMIS,DEVIR,DIGER,SUBE DEGISIKLIGI (1,2,4,66)--->
	<cfquery name="GET_BRANCH_RELATED" datasource="#dsn#">
		SELECT RELATED_ID, DEPO_STATUS FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid# AND MUSTERIDURUM NOT IN (1,2,4,66) AND DEPO_STATUS IS NOT NULL
	</cfquery>
	<cfoutput query="get_branch_related">
		<cfif len(get_branch_related.depo_status)>
			<cfset max_branch_id = get_branch_related.related_id>
			<cfset cpid = attributes.cpid>
			<cfset is_insert_type = 5>
			<cf_workcube_process 
				is_upd='1' 
				process_stage='#get_branch_related.depo_status#' 
				record_member='#session.ep.userid#' 
				record_date='#now()#' 
				action_page='#request.self#?fuseaction=crm.form_upd_company&cpid=#attributes.cpid#' 
				action_id='#attributes.cpid#'
				old_process_line='#get_branch_related.depo_status#' 
				warning_description = 'Müşteri : #attributes.fullname#'>
		</cfif>
	</cfoutput>
</cfif>
<cflocation url="#request.self#?fuseaction=crm.popup_general_info&cpid=#attributes.cpid#" addtoken="no">
