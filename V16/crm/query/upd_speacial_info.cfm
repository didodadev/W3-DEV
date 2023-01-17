<!--- TC Kimlik No ve Vergi Numarasi Kontrolu --->
<cfif len(attributes.tc_identity)>
	<cfquery name="GET_KONTROL" datasource="#DSN#">
		SELECT
			TC_IDENTITY
		FROM
			COMPANY_PARTNER
		WHERE
			TC_IDENTITY = '#attributes.tc_identity#' AND
			PARTNER_ID <> #attributes.partner_id#
	</cfquery>
	<cfif get_kontrol.recordcount>
	  <script type="text/javascript">
		alert('Aynı TC Kimlik No İle Bir Kayıt Mevcut . Kontrol Ediniz !');
		history.back();
	  </script>
	  <cfabort>
	</cfif>
</cfif>

<cfset attributes.is_record = false>
<cftry>
	<cftransaction>
		<cf_date tarih='attributes.birthday'>
		<cf_date tarih='attributes.marriage_date'>
		<cfquery name="upd_speacials" datasource="#DSN#">
			UPDATE 
				COMPANY_PARTNER 
			SET
				COMPANY_PARTNER_STATUS = 1,
				MOBIL_CODE = <cfif len(attributes.mobil_code)>'#attributes.mobil_code#'<cfelse>NULL</cfif>,
				MOBILTEL = <cfif len(attributes.mobil_num)>'#attributes.mobil_num#'<cfelse>NULL</cfif>,
				SEX = <cfif len(attributes.sexuality)>#attributes.sexuality#<cfelse>NULL</cfif>,
				NUMBER_OF_CHILD = <cfif len(attributes.child)>'#attributes.child#'<cfelse>NULL</cfif>,
				GRADUATE_YEAR = <cfif len(attributes.graduate_year)>#attributes.graduate_year#<cfelse>NULL</cfif>,
				IS_UNIVERSITY = 1,
				TITLE  = <cfif len(attributes.title)>'#attributes.title#'<cfelse>NULL</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_MEMBER = #session.ep.userid#,
				UPDATE_IP = '#cgi.remote_addr#',
				TC_IDENTITY = <cfif len(attributes.tc_identity)>'#attributes.tc_identity#'<cfelse>NULL</cfif>,
				IS_HAMSIS = <cfif isdefined("attributes.is_hamsis")>1<cfelse>0</cfif>
			WHERE
				PARTNER_ID = #attributes.partner_id# AND 
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfquery name="ADD_COMPANY_PARTNER_DETAIL" datasource="#DSN#">
			UPDATE
				COMPANY_PARTNER_DETAIL
			SET
				BIRTHDATE = <cfif len(attributes.birthday)>#attributes.birthday#<cfelse>NULL</cfif>,
				BIRTHPLACE = <cfif len(attributes.birthplace)>'#attributes.birthplace#'<cfelse>NULL</cfif>,
				MARRIED_DATE = <cfif len(attributes.marriage_date)>#attributes.marriage_date#<cfelse>NULL</cfif>,
				MARRIED = <cfif len(attributes.marital_status)>#attributes.marital_status#<cfelse>NULL</cfif>,
				FACULTY = <cfif len(attributes.faculty)>#listfirst(attributes.faculty, ',')#<cfelse>NULL</cfif>,
				CHILD = <cfif len(attributes.child)>#attributes.child#<cfelse>NULL</cfif>,
				EDU1_FINISH = <cfif len(attributes.graduate_year)>#attributes.graduate_year#<cfelse>NULL</cfif>,
				EDU1 = <cfif len(attributes.faculty)>'#listlast(attributes.faculty, ',')#'<cfelse>NULL</cfif>
			WHERE
				PARTNER_ID = #attributes.partner_id#
		</cfquery>
		<cfquery name="DEL_HOBBY" datasource="#DSN#">
			DELETE FROM
				COMPANY_PARTNER_HOBBY 
			WHERE
				PARTNER_ID = #attributes.partner_id# AND
				COMPANY_ID = #attributes.cpid#
		</cfquery>
		<cfif isDefined('attributes.hobby')>
			<cfloop list="#attributes.hobby#" index="i">
				<cfquery name="ADD_HOBBY" datasource="#DSN#">
					INSERT  INTO 
						COMPANY_PARTNER_HOBBY
					(
						HOBBY_ID,
						PARTNER_ID,
						COMPANY_ID
					)
					VALUES
					(
						#i#,
						#attributes.partner_id#,
						#attributes.cpid#
					)
				</cfquery>
			</cfloop>
		</cfif>
		<cfquery name="GET_POTANTIAL" datasource="#DSN#">
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
				EMPLOYEE_POSITIONS.POSITION_CODE = COMPANY_BRANCH_RELATED.SALES_DIRECTOR
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
										<td colspan="2" style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/><br/>#fullname# Eczacı Bilgilerinde #session.ep.name# #session.ep.surname# Tarafından Güncelleme Yapılmıştır.Bilginize.....</td>
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
										<td>&nbsp;</td>
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
			alert("<cf_get_lang no ='1018.Müşteri Bilgileri Güncellemede Problem Oluştu Lütfen Sistem Yönetisici İle Görüşün'> !");
			history.go(-1);
		</script>
	</cfcatch>
</cftry>
<!--- BK Aydın Ersoz istegi ile kapatildi 90 gune siline 20080917
<cfif attributes.is_record>
	<cfquery name="GET_BRANCH_RELATED" datasource="#DSN#">
		SELECT 
			COMPANY.FULLNAME,
			COMPANY_BRANCH_RELATED.RELATED_ID, 
			COMPANY_BRANCH_RELATED.DEPO_STATUS 
		FROM 
			COMPANY_BRANCH_RELATED,
			COMPANY
		WHERE
			COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
			COMPANY.COMPANY_ID = COMPANY_BRANCH_RELATED.COMPANY_ID AND
			COMPANY_BRANCH_RELATED.COMPANY_ID = #attributes.cpid# AND
			COMPANY_BRANCH_RELATED.DEPO_STATUS IS NOT NULL
	</cfquery>
	<cfoutput query="get_branch_related">
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
			warning_description = 'Müşteri : #get_branch_related.fullname#'>
	</cfoutput>
</cfif> --->
<cflocation url="#request.self#?fuseaction=crm.popup_special_info&cpid=#attributes.cpid#&iframe=1" addtoken="no">

