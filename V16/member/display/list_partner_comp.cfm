<cfif fusebox.use_period eq true>
	<cfset dsn=dsn>
<cfelse>
	<cfset dsn=dsn>
</cfif>
<cf_xml_page_edit fuseact="member.list_partner_comp">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.search_potential" default="0">
<cfparam name="attributes.search_status" default=1>
<cfparam name="attributes.partner_position" default="">
<cfparam name="attributes.partner_department" default="">
<cfinclude template="../query/get_partner_all.cfm">
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_partner_all.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="title_">
	<cfif isdefined("attributes.comp_cat") and len(attributes.comp_cat) and attributes.comp_cat neq 0>
        <cfquery name="GET_SELECTED_CAT" datasource="#dsn#">
            SELECT 
    	        COMPANYCAT_ID, 
                COMPANYCAT, 
                DETAIL, 
                RECORD_EMP, 
                RECORD_DATE, 
                RECORD_IP,
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
	            COMPANY_CAT
            WHERE 
            	COMPANYCAT_ID = #attributes.COMP_CAT#
        </cfquery>
        <cfif GET_SELECTED_CAT.recordcount>
            <cfoutput>#GET_SELECTED_CAT.COMPANYCAT# <cf_get_lang dictionary_id='58875.Çalışanlar'></cfoutput>
        </cfif>
    <cfelse>
        <cf_get_lang dictionary_id='30431.Kurumsal Üye Çalışanları'>
    </cfif>
</cfsavecontent>
<cfform name="form" action="#request.self#?fuseaction=member.partner_list_comp" method="post">
<cf_big_list_search title="#title_#">
	<cf_big_list_search_area>
		<table>
	        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<tr>
				<td><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></td>
				<td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" style="width:100px;"></td>
				<td><cf_get_lang dictionary_id='30368.Çalışan'>-<cf_get_lang dictionary_id='57571.Ünvan'></td>
				<td><cfinput type="text" name="keyword_partner" value="#attributes.keyword_partner#" maxlength="255" style="width:100px;"></td>
				<td>
					<select name="search_type" id="search_type">
						<option value="0" <cfif isDefined('attributes.search_type') and attributes.search_type is 0>selected</cfif>><cf_get_lang dictionary_id='29531.Şirketler'></option>
						<option value="1" <cfif isDefined('attributes.search_type') and attributes.search_type is 1>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'></option>
					</select>
					<select name="search_status" id="search_status">
						<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="" <cfif isDefined('attributes.search_status') and not Len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
					</select>   
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
    </cf_big_list_search_area>
    <cf_big_list_search_detail_area>
        <table>
            <tr>
                <td>
                    <select name="comp_cat" id="comp_cat">
                        <option value=""><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></option> 
                        <cfoutput query="get_companycat">
                            <option value="#get_companycat.COMPANYCAT_ID#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq get_companycat.COMPANYCAT_ID>selected</cfif>>#get_companycat.companycat#</option>
                        </cfoutput>
                    </select>
                    <select name="partner_position" id="partner_position">
                        <option value=""><cf_get_lang dictionary_id='57573.Görev'></option>
                        <cfoutput query="get_partner_positions">
                            <option value="#partner_position_id#" <cfif attributes.partner_position eq partner_position_id>selected</cfif>>#partner_position#</option>
                        </cfoutput>
                    </select>
                    <select name="partner_department" id="partner_department">
                        <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                        <cfoutput query="get_partner_departments">
                            <option value="#partner_department_id#" <cfif attributes.partner_department eq partner_department_id>selected</cfif>>#partner_department#</option>
                        </cfoutput>
                    </select>
                    <select name="search_potential" id="search_potential" style="width:80px;">
                        <option value=""  <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
                        <option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>                
                    </select>
                    <select name="is_sale_purchase" id="is_sale_purchase" style="width:80px;">
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                        <option value="1" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 1>selected</cfif>><cf_get_lang dictionary_id="58733.Alıcı"></option>
                        <option value="2" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 2>selected</cfif>><cf_get_lang dictionary_id="58873.Satıcı"></option>
                    </select>
                </td>
            </tr>
        </table>
    </cf_big_list_search_detail_area>
</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
        <tr>
            <th width="20"></td>
            <cfif xml_pdks_number eq 1>
                <th width="150"><cf_get_lang dictionary_id='30757.PDKS No'></th>
            </cfif>
            <th width="150"><cf_get_lang dictionary_id='30368.Çalışan'></th>
            <th width="100"><cf_get_lang dictionary_id='57573.Görev'></th>
            <th><cf_get_lang dictionary_id='57574.Şirket'></th>
            <th width="100"><cf_get_lang dictionary_id='57572.Departman'></th>
            <cfif xml_start_finish_date eq 1>
                <th width="150"><cf_get_lang dictionary_id='57628.Giriş Tarihi'></th>
                <th width="150"><cf_get_lang dictionary_id='29438.Çıkış Tarihi'></th>
            </cfif>
            <th width="100"><cf_get_lang dictionary_id='58143.İletişim'></th>
        </tr>
    </thead>
    <tbody>
		<cfif get_partner_all.recordcount>
            <cfset country_list = "">
            <cfset mission_list = "">
            <cfset department_list = "">
            <cfoutput query="get_partner_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                <cfif len(country) and not listfind(country_list,country,',')>
                    <cfset country_list = Listappend(country_list,country,',')>
                </cfif>
                <cfif len(mission) and not listfind(mission_list,mission,',')>
                    <cfset mission_list = Listappend(mission_list,mission,',')>
                </cfif>
                <cfif len(department) and not listfind(department_list,department,',')>
                    <cfset department_list = Listappend(department_list,department,',')>
                </cfif>
            </cfoutput>
            <cfif Len(country_list)>
                <cfquery name="get_country_list" datasource="#dsn#">
                    SELECT COUNTRY_ID,COUNTRY_PHONE_CODE FROM SETUP_COUNTRY WHERE COUNTRY_ID IN (#country_list#) ORDER BY COUNTRY_ID
                </cfquery>
                <cfset country_list = ListSort(ListDeleteDuplicates(ValueList(get_country_list.country_id,',')),"numeric","asc",",")>
            </cfif>
            <cfif Len(mission_list)>
                <cfquery name="get_mission_list" datasource="#dsn#">
                    SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID IN (#mission_list#) ORDER BY PARTNER_POSITION_ID
                </cfquery>
                <cfset mission_list = ListSort(ListDeleteDuplicates(ValueList(get_mission_list.partner_position_id,',')),"numeric","asc",",")>
            </cfif>
            <cfif Len(department_list)>
                <cfquery name="get_department_list" datasource="#dsn#">
                    SELECT PARTNER_DEPARTMENT_ID,PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT WHERE PARTNER_DEPARTMENT_ID IN (#department_list#) ORDER BY PARTNER_DEPARTMENT_ID
                </cfquery>
                <cfset department_list = ListSort(ListDeleteDuplicates(Valuelist(get_department_list.partner_department_id,',')),"numeric","asc",",")>
            </cfif>
            <cfoutput query="get_partner_all" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                <tr>
                    <td width="21"><cf_online id="#get_partner_all.partner_id#" zone="pp"></td>
                    <cfif xml_pdks_number eq 1>
                        <td>#PDKS_NUMBER#</td>
                    </cfif>
                    <td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#get_partner_all.partner_id#" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
                    <td><cfif Len(mission)>#get_mission_list.partner_position[listfind(mission_list,mission,',')]#</cfif></td>
                    <td><a href="#request.self#?fuseaction=member.form_list_company&event=upd&cpid=#get_partner_all.COMPANY_ID#" class="tableyazi">#fullname#</a></td>
                    
                    <td><cfif Len(department)>#get_department_list.partner_department[listfind(department_list,department,',')]#</cfif></td>
                    <cfif xml_start_finish_date eq 1>
                        <td>#dateformat(start_date,dateformat_style)#</td>
                        <td>#dateformat(finish_date,dateformat_style)#</td>
                    </cfif>
                    <td><cfif len(COMPANY_PARTNER_EMAIL)>
                            <a href="mailto:#COMPANY_PARTNER_EMAIL#"><img src="/images/mail.gif"  title="<cf_get_lang dictionary_id='57428.E-mail'>:#COMPANY_PARTNER_EMAIL#" border="0"></a>
                        </cfif>
                        <cfif len(COMPANY_PARTNER_TEL)>
                            &nbsp;<img src="/images/tel.gif" title="<cf_get_lang dictionary_id='57499.Telefon'>: <cfif len(country) and len(company_partner_tel) and len(get_country_list.country_phone_code[listfind(country_list,country,',')])>(#get_country_list.country_phone_code[listfind(country_list,country,',')]#) </cfif>#COMPANY_PARTNER_telcode# - #COMPANY_PARTNER_TEL# <cfif len(company_partner_tel_ext)>(#company_partner_tel_ext#)</cfif>" border="0">
                        </cfif>
                        <cfif len(COMPANY_PARTNER_FAX)>
                            &nbsp;<img src="/images/fax.gif" title="<cf_get_lang dictionary_id='57488.Fax'>:#COMPANY_PARTNER_telcode# - #COMPANY_PARTNER_FAX#" border="0">
                        </cfif>
                        <cfif len(mobiltel)><img src="/images/mobil.gif"  title="<cf_get_lang dictionary_id='30254.Kod/Mobil Tel'>:#MOBIL_CODE# - #MOBILTEL#" border="0"></cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfset adres = "member.partner_list_comp">
<cfset adres = adres&"&search_status="&attributes.search_status>
<cfset adres = adres&"&search_potential="&attributes.search_potential>
<cfset adres = adres&"&partner_position="&attributes.partner_position>
<cfset adres = adres&"&partner_department="&attributes.partner_department>
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset adres = adres&"&keyword="&attributes.keyword>
</cfif>
<cfif isDefined('attributes.keyword_partner') and len(attributes.keyword_partner)>
	<cfset adres = adres&"&keyword_partner="&attributes.keyword_partner>
</cfif>
<cfif isDefined('attributes.comp_cat') and len(attributes.comp_cat)>
	<cfset adres = adres&"&comp_cat="&attributes.comp_cat>
</cfif>
<cfif isdefined("attributes.is_sale_purchase") and len(attributes.is_sale_purchase)>
	<cfset adres = adres&"&is_sale_purchase="&attributes.is_sale_purchase>
</cfif>
<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#"
	totalrecords="#get_partner_all.recordcount#"
	startrow="#attributes.startrow#"
	adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
