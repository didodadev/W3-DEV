<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.cp_name" default="">
<cfparam name="attributes.cp_surname" default="">
<cfparam name="attributes.vergi_no" default="">
<cfparam name="attributes.hedef_kodu" default="">
		<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
		  <tr>
			<td height="35" class="headbold"><cf_get_lang dictionary_id="33539.CRM Admin"></td>
		  </tr>
		  <tr>
			<td colspan="4" class="color-border">
			  <table width="100%" border="0" cellspacing="1" cellpadding="2">
				<tr class="color-row">
				  <td>
					<table>
					  <tr>
						<td valign="top">
						  <table width="100%">
						  <cfform name="search_company" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.#fusebox.fuseaction#">
							<input type="hidden" name="is_submitted" id="is_submitted" value="1"/>
							<tr>
								<td>&nbsp;<cf_get_lang no='668.Hedef Kodu'>&nbsp;<cfinput type="text" name="hedef_kodu" value="#attributes.hedef_kodu#"/>
								<td>&nbsp;<cf_get_lang_main no='338.İşyeri Adı'>&nbsp;</td>
								<td><cfinput type="text" name="fullname" style="width:105px;" value="#attributes.fullname#" maxlength="255"></td>
								<td>&nbsp;<cf_get_lang_main no='219.Ad'>&nbsp;<cfinput type="text" name="cp_name" style="width:90px;" value="#attributes.cp_name#" maxlength="255"></td>	
								<td>&nbsp;<cf_get_lang_main no='1314.Soyad'>&nbsp;</td>
								<td><cfinput type="text" name="cp_surname" style="width:90px;" value="#attributes.cp_surname#" maxlength="255"></td>
								<td>&nbsp;<cf_get_lang_main no='340.Vergi No'>&nbsp;<cfinput type="text" name="vergi_no" style="width:75px" value="#attributes.vergi_no#"></td>
								<td><cf_wrk_search_button search_function='hepsini_sec()'></td>
							</tr>
							</cfform>
						  </table>
						</td>
					  </tr>
					</table>
			  </td>
			</tr>
		  </table>
		 </td>
		</tr>
		</table>
		<cfset url_str="">
		<cfif len(attributes.is_submitted)>
			<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
		</cfif>
		<cfif len(attributes.fullname)>
			<cfset url_str = "#url_str#&fullname=#attributes.fullname#">
		</cfif>
		<cfif len(attributes.cp_name)>
			<cfset url_str = "#url_str#&cp_name=#attributes.cp_name#">
		</cfif>
		<cfif len(attributes.cp_surname)>
			<cfset url_str = "#url_str#&cp_surname=#attributes.cp_surname#">
		</cfif>
		<cfif len(attributes.vergi_no)>
			<cfset url_str = "#url_str#&vergi_no=#attributes.vergi_no#">
		</cfif>
		<cfif len(attributes.hedef_kodu)>
			<cfset url_str = "#url_str#&hedef_kodu=#attributes.hedef_kodu#">
		</cfif>
		<cfif len(attributes.is_submitted)>
			<cfif not isnumeric(attributes.hedef_kodu)>
				<p align="center"><b><cf_get_lang dictionary_id="33532.Lütfen Hedef Kodunu Nümerik Giriniz"> !</b></p>
			<cfelse>
			<cfquery name="GET_COMPANY" datasource="#dsn#">
				SELECT
					COMPANY.COMPANY_STATUS,
					COMPANY.COMPANY_ID,
					COMPANY.FULLNAME,
					COMPANY.ISPOTANTIAL,
					COMPANY_PARTNER.COMPANY_PARTNER_NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
					COMPANY.TAXNO,
					SETUP_COUNTY.COUNTY_NAME,
					SETUP_CITY.CITY_NAME,
					COMPANY.COMPANY_TELCODE,
					COMPANY.COMPANY_TEL1
				FROM
					COMPANY,
					COMPANY_PARTNER,
					SETUP_CITY,
					SETUP_COUNTY
				WHERE
					COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID AND
					COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID AND
					SETUP_CITY.CITY_ID = COMPANY.CITY AND
					SETUP_COUNTY.COUNTY_ID = COMPANY.COUNTY
					<cfif len(attributes.fullname)>AND COMPANY.FULLNAME = '#attributes.fullname#'</cfif>
					<cfif len(attributes.cp_name)>AND COMPANY_PARTNER.COMPANY_PARTNER_NAME LIKE '#attributes.fullname#'</cfif>
					<cfif len(attributes.cp_surname)>AND COMPANY.COMPANY_PARTNER_SURNAME LIKE '#attributes.fullname#'</cfif>
					<cfif len(attributes.vergi_no)>AND COMPANY.TAXNO LIKE '#attributes.vergi_no#'</cfif>
					<cfif len(attributes.hedef_kodu)>AND COMPANY.COMPANY_ID = #attributes.hedef_kodu#</cfif>
				ORDER BY
					COMPANY.FULLNAME,
					COMPANY_PARTNER.COMPANY_PARTNER_NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
			</cfquery>
			<br/>
			<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
			  <tr class="color-border">
				<td>
				  <table cellspacing="1" cellpadding="2" width="100%" border="0">
					<tr class="color-header" height="22">
					  <td class="form-title" width="30"><cf_get_lang_main no='75.No'></td>
					  <td class="form-title" width="65"><cf_get_lang no='668.Hedef Kodu'></td>
					  <td class="form-title"><cf_get_lang_main no='338.İşyeri Adı'></td>
					  <td class="form-title" width="180"><cf_get_lang_main no='158.Ad Soyad'></td>
					  <td class="form-title" width="80" nowrap><cf_get_lang_main no='340.Vergi No'></td>
					  <td class="form-title" width="70"><cf_get_lang_main no='87.Telefon'></td>
					  <td class="form-title" width="90"><cf_get_lang_main no='1196.İl'></td>
					  <td class="form-title" width="120"><cf_get_lang_main no='1226.İlçe'></td>
					  <td class="form-title" align="center" width="30"><cf_get_lang_main no='344.Durum'></td>
					  <td class="form-title" align="center" width="30"><cf_get_lang no='670.Cari/Potansiyel'></td>
					</tr>
					  <cfif get_company.recordcount>
						<cfform name="add_form" action="#request.self#?fuseaction=crm.form_add_member_admin&url_str=#url_str#" method="post">
						<cfoutput query="get_company">
						  <input type="hidden" name="operation_type" id="operation_type" value="1"/>
						  <input type="hidden" name="company_id" id="company_id" value="#get_company.company_id#">
						  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td width="30">#currentrow#</td>
							<td>#company_id#</td>
							<td>#fullname#</td>
							<td>#company_partner_name# #company_partner_surname#</td>
							<td>#taxno#</td>
							<td>#company_telcode# #company_tel1#</td>
							<td>#city_name#</td>
							<td>#county_name#</td>
							<td align="center"><cfif get_company.recordcount eq 1><input type="checkbox" name="company_status" id="company_status" <cfif company_status eq 1>checked</cfif>/><cfelse>&nbsp;</cfif></td>
							<td align="center"><cfif get_company.recordcount eq 1><input type="checkbox" name="ispotantial" id="ispotantial" <cfif ispotantial eq 1>checked</cfif>/><cfelse>&nbsp;</cfif></td>
						  </tr>
						</cfoutput>
						  <cfoutput>
						  <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
							<td colspan="10"  style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
						  </tr>
						  </cfoutput>
						  </cfform>
						<cfelse>
						<tr height="22">
						  <td colspan="30" class="color-row"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
						</tr>
					  </cfif>
				  </table>
				</td>
			  </tr>
			</table>
			<br/>
			<cfif get_company.recordcount and (get_company.recordcount gt 1)>
				<p align="center"><b><cf_get_lang dictionary_id="33531.Lütfen Yukarıdaki Hedef Kodlu Eczanelerden Sadece Birisini Filtreleyiniz"> !</b></p>
			<cfelseif get_company.recordcount>
				<cfquery name="GET_RELATED" datasource="#dsn#">
					SELECT
						COMPANY_BRANCH_RELATED.RELATED_ID,
						COMPANY_BRANCH_RELATED.IS_SELECT,
						COMPANY_BRANCH_RELATED.CARIHESAPKOD,
						COMPANY_BRANCH_RELATED.MUHASEBEKOD,
						BRANCH.BRANCH_NAME,
						PROCESS_TYPE_ROWS.STAGE
					FROM
						COMPANY_BRANCH_RELATED,
						BRANCH,
						PROCESS_TYPE_ROWS
					WHERE
						COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
						COMPANY_BRANCH_RELATED.COMPANY_ID = #get_company.company_id# AND
						COMPANY_BRANCH_RELATED.BRANCH_ID = BRANCH.BRANCH_ID AND
						PROCESS_TYPE_ROWS.PROCESS_ROW_ID = COMPANY_BRANCH_RELATED.DEPO_STATUS
				</cfquery>
				<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
				  <tr class="color-border">
					<td>
					  <table cellspacing="1" cellpadding="2" width="100%" border="0">
						<tr class="color-header" height="22">
						  <td class="form-title" width="30"><cf_get_lang dictionary_id="57487.No"></td>
						  <td class="form-title"><cf_get_lang dictionary_id="57453.Şube"></td>
						  <td class="form-title" width="140"><cf_get_lang dictionary_id="30155.Carihesap Kod"></td>
						  <td class="form-title" width="140"><cf_get_lang dictionary_id="58811.Muhasebe Kod"></td>
						  <td class="form-title" width="140"><cf_get_lang dictionary_id="57500.Onay"></td>
						  <td width="19">&nbsp;</td>
						</tr>
						  <cfif get_company.recordcount>
							<cfoutput query="get_related">
							  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
								<td width="30">#currentrow#</td>
								<td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=crm.popup_add_admin_branch_related&related_id=#related_id#' ,'medium');">#branch_name#</a></td>
								<td>#carihesapkod#</td>
								<td>#muhasebekod#</td>
								<td>#stage#</td>
								<td><cfif not listfindnocase(denied_pages,'crm.del_member_admin')>
										<a href="#request.self#?fuseaction=crm.del_member_admin&cpid=#get_company.company_id#&related_id=#related_id#&url_str=#url_str#&operation_type=2"><img src="images/delete_list.gif" border="0"/></a>
									</cfif>
								</td>
							  </tr>
							</cfoutput>
							<cfelse>
							<tr height="22">
							  <td colspan="30" class="color-row"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
							</tr>
						  </cfif>
					  </table>
					</td>
				  </tr>
				</table>
			  <br/>
			</cfif>
			</cfif>
		</cfif>
<cfif isdefined("attributes.operation_type") and (attributes.operation_type eq 1)>
	<cfquery name="GET_OPERATION" datasource="#dsn#">
		UPDATE
			COMPANY
		SET
			ISPOTANTIAL = <cfif isdefined("attributes.ispotantial")>1<cfelse>0</cfif>,
			COMPANY_STATUS = <cfif isdefined("attributes.company_status")>1<cfelse>0</cfif>	
		WHERE
			COMPANY_ID = #attributes.company_id#
	</cfquery>
<cfelseif isdefined("attributes.operation_type") and (attributes.operation_type eq 2)>
	<cfquery name="Get_Company_Branch_Related_Info" datasource="#dsn#">
		SELECT 
			*
        FROM 
    	    COMPANY_BRANCH_RELATED 
        WHERE 
	        MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid# AND RELATED_ID = #attributes.related_id#
	</cfquery>
	<cfloop query="Get_Company_Branch_Related_Info">
		<!--- CarihesapKod, Branch_Id vb. bilgilerin kaybolmamasi gerekiyor --->
		<cfquery name="Add_Related_History" datasource="#dsn#">
			INSERT INTO
				COMPANY_BRANCH_RELATED_HISTORY
			(
				RELATED_ID,
				IS_CRM,
				COMPANY_ID,
				OUR_COMPANY_ID,
				BRANCH_ID,
				IS_SELECT,
				CARIHESAPKOD,
				MUSTERIDURUM,
				MUHASEBEKOD,
				DEPO_STATUS,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			VALUES
			(
				#Get_Company_Branch_Related_Info.Related_Id#,
				1,
				<cfif Len(Get_Company_Branch_Related_Info.Company_Id)>#Get_Company_Branch_Related_Info.Company_Id#<cfelse>NULL</cfif>,
				#session.ep.company_id#,
				<cfif Len(Get_Company_Branch_Related_Info.Branch_Id)>#Get_Company_Branch_Related_Info.Branch_Id#<cfelse>NULL</cfif>,
				<cfif Len(Get_Company_Branch_Related_Info.Is_Select)>#Get_Company_Branch_Related_Info.Is_Select#<cfelse>NULL</cfif>,
				<cfif Len(Get_Company_Branch_Related_Info.CariHesapKod)>#Get_Company_Branch_Related_Info.CariHesapKod#<cfelse>NULL</cfif>,
				<cfif Len(Get_Company_Branch_Related_Info.MusteriDurum)>#Get_Company_Branch_Related_Info.MusteriDurum#<cfelse>NULL</cfif>,
				<cfif Len(Get_Company_Branch_Related_Info.MuhasebeKod)>#Get_Company_Branch_Related_Info.MuhasebeKod#<cfelse>NULL</cfif>,
				<cfif Len(Get_Company_Branch_Related_Info.Depo_Status)>#Get_Company_Branch_Related_Info.Depo_Status#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'				
			)
		</cfquery>
	</cfloop>
	<cfquery name="GET_OPERATION" datasource="#dsn#">
		DELETE FROM COMPANY_BRANCH_RELATED WHERE MUSTERIDURUM IS NOT NULL AND COMPANY_ID = #attributes.cpid# AND RELATED_ID = #attributes.related_id#
	</cfquery>
	<cf_add_log log_type="-1" action_id="#attributes.related_id#" action_name="cpid=#attributes.cpid#">	
	<cfset url_str2="">
	<cfif isDefined("attributes.is_submitted") and len(attributes.is_submitted)><cfset url_str2 = "#url_str2#&is_submitted=#attributes.is_submitted#"></cfif>
	<cfif isDefined("attributes.fullname") and len(attributes.fullname)><cfset url_str2 = "#url_str2#&fullname=#attributes.fullname#"></cfif>
	<cfif isDefined("attributes.cp_name") and len(attributes.cp_name)><cfset url_str2 = "#url_str2#&cp_name=#attributes.cp_name#"></cfif>
	<cfif isDefined("attributes.cp_surname") and len(attributes.cp_surname)><cfset url_str2 = "#url_str2#&cp_surname=#attributes.cp_surname#"></cfif>
	<cfif isDefined("attributes.vergi_no") and len(attributes.vergi_no)><cfset url_str2 = "#url_str2#&vergi_no=#attributes.vergi_no#"></cfif>
	<cfif isDefined("attributes.hedef_kodu") and len(attributes.hedef_kodu)><cfset url_str2 = "#url_str2#&hedef_kodu=#attributes.hedef_kodu#"></cfif>
	<cflocation url="#request.self#?fuseaction=crm.form_add_member_admin#url_str2#" addtoken="no">
</cfif>
<script type="text/javascript">
function hepsini_sec()
{
	if((search_company.hedef_kodu.value == "") && (search_company.fullname.value == "") && (search_company.cp_name.value == "") && (search_company.cp_surname.value == "") && (search_company.vergi_no.value == ""))
	{
		alert("<cf_get_lang dictionary_id='33529.Lütfen Arama Kriterlerinden En Az Birisini Giriniz'>!");
		return false;
	}
	return true;
}
</script>
