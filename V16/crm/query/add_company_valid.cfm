<cfif len(attributes.open_date_val)>
	<cf_date tarih='attributes.open_date_val'>
</cfif>
<cfscript>
	attributes.fullname = trim(attributes.fullname);
	attributes.company_partner_name = trim(attributes.company_partner_name);
	attributes.company_partner_surname = trim(attributes.company_partner_surname);
	attributes.tax_num = trim(attributes.tax_num);
	attributes.tel1 = trim(attributes.tel1);
	attributes.telcod = trim(attributes.telcod);
</cfscript>
<cfquery name="GET_COMP_KONTROL" datasource="#dsn#">
	SELECT 
		COMPANY.COMPANY_ID,
		COMPANY.FULLNAME,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY.TAXOFFICE,
		COMPANY.TAXNO,
		COMPANY.COMPANY_TELCODE,
		COMPANY.COMPANY_TEL1,
		COMPANY.ISPOTANTIAL,
		COMPANY.COMPANY_STATE,
		COMPANY_CAT.COMPANYCAT_TYPE,
		COMPANY_CAT.COMPANYCAT
	FROM 
		COMPANY,
		COMPANY_PARTNER,
		COMPANY_CAT
	WHERE 
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
		COMPANY_CAT.COMPANYCAT_ID = COMPANY.COMPANYCAT_ID AND
		COMPANY_PARTNER.PARTNER_ID = COMPANY.MANAGER_PARTNER_ID AND
		(
			COMPANY.COMPANY_ID IS NULL
			<cfif len(attributes.fullname)>OR COMPANY.FULLNAME = '#attributes.fullname#'</cfif>
			<cfif len(attributes.company_partner_name) or len(attributes.company_partner_surname)>
				<cfif database_type is "MSSQL">
					OR COMPANY_PARTNER.COMPANY_PARTNER_NAME + ' '+ COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.company_partner_name# #attributes.company_partner_surname#'
				<cfelseif database_type is "DB2">
					OR COMPANY_PARTNER.COMPANY_PARTNER_NAME ||' '|| COMPANY_PARTNER.COMPANY_PARTNER_SURNAME = '#attributes.company_partner_name# #attributes.company_partner_surname#'
				</cfif>
			</cfif>
			<cfif len(attributes.tax_num)>OR COMPANY.TAXNO = '#attributes.tax_num#'</cfif>
			<cfif len(attributes.tel1)>OR COMPANY.COMPANY_TEL1 = '#attributes.tel1#'</cfif>
		)
	ORDER BY
		COMPANY.FULLNAME
</cfquery>
<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfif get_comp_kontrol.recordcount>
	<cfif not isdefined("attributes.is_search_add")>
		<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
		  <tr>
			<td height="35" class="headbold"><!--- <cf_get_lang no='471. --->Benzer Kriterlerde Kayitlar !</td>
		  </tr>
		</table>
		<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
		  <tr class="color-border">
			<td>
			  <table cellspacing="1" cellpadding="2" width="100%" border="0">
				<tr height="22" class="color-header">
					<td class="form-title" width="25"><cf_get_lang_main no='75.No'></td>
					<td class="form-title" nowrap><cf_get_lang_main no='338.İşyeri Adı'></td>
					<td class="form-title" nowrap><cf_get_lang_main no='74.Kategori'></td>
					<td class="form-title" nowrap><cf_get_lang_main no='158.Ad Soyad'></td>
					<td class="form-title"><cf_get_lang_main no='340.Vergi No'></td>
					<td class="form-title" nowrap><cf_get_lang_main no='87.Telefon'></td>
					<td class="form-title"><cf_get_lang no='472.Grupla Çalistigi Şubeler'></td>
				  </tr>
				  <form name="search_" method="post" action="">
				  <input type="hidden" name="is_search_add" id="is_search_add" value="1">
				  <cfoutput>
					<cfloop from="1" to="#listlen(fieldnames)#" index="i">
						<input type="hidden" name="#listgetat(fieldnames,i,',')#" id="#listgetat(fieldnames,i,',')#" value="#evaluate(listgetat(fieldnames,i,','))#">
					</cfloop>
				  </cfoutput>
				  <cfif get_comp_kontrol.recordcount>
					  <cfoutput query="get_comp_kontrol">
						<cfquery name="GET_COMPANY_BRANCH" datasource="#dsn#">
							SELECT
								BRANCH.BRANCH_ID,
								BRANCH.BRANCH_NAME,
								OUR_COMPANY.COMPANY_NAME,
								OUR_COMPANY.NICK_NAME
							FROM
								OUR_COMPANY,
								BRANCH,
								COMPANY_BRANCH_RELATED
							WHERE
								COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
								COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
								BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
								COMPANY_BRANCH_RELATED.IS_SELECT = 1 AND
								COMPANY_BRANCH_RELATED.COMPANY_ID = #get_comp_kontrol.company_id#
								<cfif get_branch.recordcount>
									AND BRANCH.BRANCH_ID IN (#valuelist(get_branch.branch_id,',')#)
								<cfelse>
									AND BRANCH.BRANCH_ID = 0
								</cfif>
						</cfquery>
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td>#currentrow#</td>
						<td nowrap><cfif attributes.fullname eq trim(fullname)><font color="##990000">#fullname#</font><cfelse>#fullname#</cfif></td>
						<td nowrap>#companycat#</td>
						<td nowrap><cfif attributes.company_partner_name eq trim(company_partner_name)><font color="##990000">#company_partner_name#</font><cfelse>#company_partner_name#</cfif>
						<cfif attributes.company_partner_surname eq trim(company_partner_surname)><font color="##990000">#company_partner_surname#</font><cfelse>#company_partner_surname#</cfif></td>
						<td><cfif attributes.tax_num eq trim(taxno)><font color="##990000">#taxno#</font><cfelse>#taxno#</cfif></td>
						<td nowrap><cfif attributes.tel1 eq trim(company_tel1)><font color="##990000">#company_telcode# #company_tel1#</font><cfelse>#company_telcode# #company_tel1#</cfif></td>
						<td><cfloop query="get_company_branch">#nick_name# / #branch_name# - <a href="#request.self#?fuseaction=crm.popup_upd_company_infos&is_search=1&cpid=#get_comp_kontrol.company_id#&branch_id=#get_company_branch.branch_id#" class="tableyazi">Varolan Kayda Git</a><br/></cfloop></td>
					</tr>
					</cfoutput>
					<tr class="color-row">
					<td height="35" colspan="8"  style="text-align:right;"><input type="submit" name="Devam" value=" Varolan Kayıtları Gözardi Et "></td>
					</tr>
					<cfelse>
						<tr class="color-row">
							<td height="20" colspan="8"><cf_get_lang_main no='72.Kayit Bulunamadi'> !</td>
						</tr>
					</cfif>
					</form>
			  </table>
			</td>
		  </tr>
		</table>
	<cfelse>
		<cflock  name="#CREATEUUID()#" timeout="20">
			<cftransaction>
				<cfquery name="UPD_COMPANY" datasource="#dsn#" result="GET_MAX">
					INSERT
					INTO
						COMPANY
						(
							FULLNAME,
							COMPANYCAT_ID,
							TAXNO,
							TAXOFFICE,
							DISTRICT,
							CITY,
							MAIN_STREET,
							COUNTY,
							STREET,
							SEMT,
							DUKKAN_NO,
							COUNTRY,
							COMPANY_POSTCODE,
							COMPANY_TELCODE,
							COMPANY_TEL1,
							IMS_CODE_ID,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP
						)
						VALUES
						(
							'#attributes.fullname#',
							#attributes.companycat_id#,
							<cfif len(attributes.tax_num)>'#attributes.tax_num#',<cfelse>NULL,</cfif>
							<cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
							<cfif len(attributes.district)>'#attributes.district#',<cfelse>NULL,</cfif>
							<cfif len(attributes.city_id)>#attributes.city_id#,<cfelse>NULL,</cfif>
							<cfif len(attributes.main_street)>'#attributes.main_street#',<cfelse>NULL,</cfif>
							<cfif len(attributes.county_id_)>#attributes.county_id_#,<cfelse>NULL,</cfif>
							<cfif len(attributes.street)>'#attributes.street#',<cfelse>NULL,</cfif>
							<cfif len(attributes.semt)>'#attributes.semt#',<cfelse>NULL,</cfif>
							<cfif len(attributes.dukkan_no)>'#attributes.dukkan_no#',<cfelse>NULL,</cfif>
							<cfif len(attributes.country_)>#attributes.country_#,<cfelse>NULL,</cfif>
							<cfif len(attributes.post_code)>'#attributes.post_code#',<cfelse>NULL,</cfif>
							<cfif len(attributes.telcod)>'#attributes.telcod#',<cfelse>NULL,</cfif>
							<cfif len(attributes.country_)>'#attributes.tel1#',<cfelse>NULL,</cfif>
							<cfif len(attributes.ims_code_id)>#attributes.ims_code_id#,<cfelse>NULL,</cfif>
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#'
						)
				</cfquery>
                <cfset GET_MAX.MAX_ID = GET_MAX.IDENTITYCOL>
				<cfquery name="UPDATE_COMPANY_INFO" datasource="#dsn#">
					UPDATE COMPANY SET MEMBER_CODE = '#get_max.max_id#' WHERE COMPANY_ID = #get_max.max_id#			
				</cfquery>
				<cfquery name="UPD_COMPANY_PARTNER" datasource="#dsn#">
					INSERT INTO
						COMPANY_PARTNER
					(
						COMPANY_ID,
						COMPANY_PARTNER_NAME,
						COMPANY_PARTNER_SURNAME
					)
					VALUES
					(
						#get_max.max_id#,
						'#attributes.company_partner_name#',
						'#attributes.company_partner_surname#'
					)
				</cfquery>
				<cfquery name="GET_MAXPARTNER" datasource="#dsn#">
					SELECT MAX(PARTNER_ID) AS MAX_PARTNER_ID FROM COMPANY_PARTNER
				</cfquery>
				<cfquery name="ADD_COMPANY_DETAIL" datasource="#dsn#">
					INSERT
					INTO
						COMPANY_PARTNER_DETAIL
						(
							PARTNER_ID
						)
						VALUES
						(
							#get_maxpartner.max_partner_id#
						)
				</cfquery>
				<cfquery name="UPDATE_COMPANY_INFO" datasource="#dsn#">
					UPDATE COMPANY SET MANAGER_PARTNER_ID = #get_maxpartner.max_partner_id# WHERE COMPANY_ID = #get_max.max_id#
				</cfquery>
				<cfquery name="GET_BRANCH_COMPANY" datasource="#dsn#">
					SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
				</cfquery>
				<cfquery name="UPD_BRANCH_RELATED" datasource="#dsn#">
					INSERT
					INTO
						COMPANY_BRANCH_RELATED
						(
							COMPANY_ID,
							OUR_COMPANY_ID,
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
							 #get_max.max_id#,
							 #get_branch_company.company_id#,
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
							 <cfif len(attributes.open_date_val)>#attributes.open_date_val#<cfelse>NULL</cfif>
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
							#get_max.max_id#,
							#get_our_company.company_id#
						)
				</cfquery>
			</cftransaction>
		</cflock>
		<script type="text/javascript">
			window.location.href = '<cfoutput>#request.self#?fuseaction=crm.my_buyers</cfoutput>';
		</script>
	</cfif>
<cfelse>
	<cflock  name="#CREATEUUID()#" timeout="20">
		<cftransaction>
			<cfquery name="UPD_COMPANY" datasource="#dsn#">
				INSERT
				INTO
					COMPANY
					(
						FULLNAME,
						COMPANYCAT_ID,
						TAXNO,
						TAXOFFICE,
						DISTRICT,
						CITY,
						MAIN_STREET,
						COUNTY,
						STREET,
						SEMT,
						DUKKAN_NO,
						COUNTRY,
						COMPANY_POSTCODE,
						COMPANY_TELCODE,
						COMPANY_TEL1,
						IMS_CODE_ID,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP
					)
					VALUES
					(
						'#attributes.fullname#',
						#attributes.companycat_id#,
						<cfif len(attributes.tax_num)>'#attributes.tax_num#',<cfelse>NULL,</cfif>
						<cfif len(attributes.tax_office)>'#attributes.tax_office#',<cfelse>NULL,</cfif>
						<cfif len(attributes.district)>'#attributes.district#',<cfelse>NULL,</cfif>
						<cfif len(attributes.city_id)>#attributes.city_id#,<cfelse>NULL,</cfif>
						<cfif len(attributes.main_street)>'#attributes.main_street#',<cfelse>NULL,</cfif>
						<cfif len(attributes.county_id_)>#attributes.county_id_#,<cfelse>NULL,</cfif>
						<cfif len(attributes.street)>'#attributes.street#',<cfelse>NULL,</cfif>
						<cfif len(attributes.semt)>'#attributes.semt#',<cfelse>NULL,</cfif>
						<cfif len(attributes.dukkan_no)>'#attributes.dukkan_no#',<cfelse>NULL,</cfif>
						<cfif len(attributes.country_)>#attributes.country_#,<cfelse>NULL,</cfif>
						<cfif len(attributes.post_code)>'#attributes.post_code#',<cfelse>NULL,</cfif>
						<cfif len(attributes.telcod)>'#attributes.telcod#',<cfelse>NULL,</cfif>
						<cfif len(attributes.country_)>'#attributes.tel1#',<cfelse>NULL,</cfif>
						<cfif len(attributes.ims_code_id)>#attributes.ims_code_id#,<cfelse>NULL,</cfif>
						#now()#,
						#session.ep.userid#,
						'#cgi.REMOTE_ADDR#'
					)
			</cfquery>
			<cfquery name="GET_MAX" datasource="#dsn#">
				SELECT MAX(COMPANY_ID) AS MAX_ID FROM COMPANY
			</cfquery>
			<cfquery name="UPDATE_COMPANY_INFO" datasource="#dsn#">
				UPDATE COMPANY SET MEMBER_CODE = '#get_max.max_id#' WHERE COMPANY_ID = #get_max.max_id#			
			</cfquery>
			<cfquery name="UPD_COMPANY_PARTNER" datasource="#dsn#">
				INSERT
				INTO
					COMPANY_PARTNER
					(
						COMPANY_ID,
						COMPANY_PARTNER_NAME,
						COMPANY_PARTNER_SURNAME
					)
					VALUES
					(
						#get_max.max_id#,
						'#attributes.company_partner_name#',
						'#attributes.company_partner_surname#'
					)
			</cfquery>
			<cfquery name="GET_MAXPARTNER" datasource="#dsn#">
				SELECT MAX(PARTNER_ID) AS MAX_PARTNER_ID FROM COMPANY_PARTNER
			</cfquery>
			<cfquery name="ADD_COMPANY_DETAIL" datasource="#dsn#">
				INSERT
				INTO
					COMPANY_PARTNER_DETAIL
					(
						PARTNER_ID
					)
					VALUES
					(
						#get_maxpartner.max_partner_id#
					)
			</cfquery>
			<cfquery name="UPDATE_COMPANY_INFO" datasource="#dsn#">
				UPDATE COMPANY SET MANAGER_PARTNER_ID = #get_maxpartner.max_partner_id# WHERE COMPANY_ID = #get_max.max_id#
			</cfquery>
			<cfquery name="GET_BRANCH_COMPANY" datasource="#dsn#">
				SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
			</cfquery>
			<cfquery name="UPD_BRANCH_RELATED" datasource="#dsn#">
				INSERT
				INTO
					COMPANY_BRANCH_RELATED
					(
						COMPANY_ID,
						OUR_COMPANY_ID,
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
						DEPO_STATUS
					)
					VALUES
					(
						 #get_max.max_id#,
						 #get_branch_company.company_id#,
						 <cfif len(attributes.durum)>#attributes.durum#,<cfelse>NULL,</cfif>
						 <cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
						 <cfif len(attributes.telefon_satis_id)>#attributes.telefon_satis_id#,<cfelse>NULL,</cfif>
						 <cfif len(attributes.plasiyer_id)>#attributes.plasiyer_id#,<cfelse>NULL,</cfif>
						 <cfif len(attributes.satis_muduru_id)>#attributes.satis_muduru_id#,<cfelse>NULL,</cfif>
						 #session.ep.userid#,
						 #now()#,
						 <cfif len(attributes.carihesapkod)>'#attributes.carihesapkod#',<cfelse>NULL,</cfif> 
						 <!--- <cfif len(attributes.muhasebekod)>'#attributes.muhasebekod#',<cfelse>NULL,</cfif> --->
						 <cfif len(attributes.tahsilatci_id)>#attributes.tahsilatci_id#,<cfelse>NULL,</cfif>
						 <cfif len(attributes.itriyat_id)>#attributes.itriyat_id#,<cfelse>NULL,</cfif>
						 <cfif len(attributes.boyut_tahsilat)>'#attributes.boyut_tahsilat#',<cfelse>NULL,</cfif>
						 <cfif len(attributes.boyut_itriyat)>'#attributes.boyut_itriyat#',<cfelse>NULL,</cfif>
						 <cfif len(attributes.boyut_telefon)>'#attributes.boyut_telefon#',<cfelse>NULL,</cfif>
						 <cfif len(attributes.boyut_plasiyer)>'#attributes.boyut_plasiyer#',<cfelse>NULL,</cfif>
						 <cfif len(attributes.boyut_bsm)>'#attributes.boyut_bsm#',<cfelse>NULL,</cfif>
						 1,
						 13
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
						#get_max.max_id#,
						#get_our_company.company_id#
					)
			</cfquery>
			<!--- <cfquery name="ADD_BOYUT" datasource="#dsn#">
				INSERT
				INTO
					COMPANY_BOYUT
					(
						COMPANY_ID,
						PARTNER_ID,
						BRANCH_ID,
						IS_UPDATE,
						IS_INSERT,
						RECORD_DATE,
						RECORD_IP,
						RECORD_EMP
					)
					VALUES
					(
						#get_max.max_id#,
						#get_maxpartner.max_partner_id#,
						#attributes.branch_id#,
						0,
						1,
						#now()#,
						'#cgi.REMOTE_ADDR#',
						#session.ep.userid#
					)
			</cfquery> --->
		</cftransaction>
	</cflock>
	<script type="text/javascript">
		location.href = document.referrer;
	</script>
</cfif>
