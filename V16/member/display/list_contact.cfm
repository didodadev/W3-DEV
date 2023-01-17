<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.keyword_partner" default="">
<cfparam name="attributes.search_potential" default="0">
<cfparam name="attributes.search_status" default=1>
<cfparam name="attributes.partner_position" default="">
<cfparam name="attributes.partner_department" default="">
<cfif isDefined('attributes.form_submitted')>
	<cfinclude template="../query/get_partner_all.cfm">
<cfelse>
	<cfset get_partner_all.recordcount = 0>
</cfif>
<cfinclude template="../query/get_company_cat.cfm">
<cfinclude template="../query/get_partner_positions.cfm">
<cfinclude template="../query/get_partner_departments.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_partner_all.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form" action="#request.self#?fuseaction=member.list_contact" method="post">
            <cf_box_search plus="0">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='58585.Kod'>-<cf_get_lang dictionary_id='57574.Şirket'></cfsavecontent>
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="place"><cf_get_lang dictionary_id='30368.Çalışan'>-<cf_get_lang dictionary_id='57571.Ünvan'></cfsavecontent>
                    <cfinput type="text" name="keyword_partner" value="#attributes.keyword_partner#" maxlength="255" placeholder="#place#">
                </div>
                <div class="form-group">
                    <select name="search_status" id="search_status">
                        <option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value="" <cfif isDefined('attributes.search_status') and not Len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'></option>
                    </select>  
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div> 
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-comp_cat">
                        <label class="col col-12"><cf_get_lang dictionary_id='58137.Kategoriler'></label>
                        <div class="col col-12">
                            <select name="comp_cat" id="comp_cat">
                                <option value=""><cf_get_lang dictionary_id='29536.Tüm Kategoriler'></option> 
                                <cfoutput query="get_companycat">
                                    <option value="#get_companycat.COMPANYCAT_ID#" <cfif isdefined("attributes.comp_cat") and attributes.comp_cat eq get_companycat.COMPANYCAT_ID>selected</cfif>>#get_companycat.companycat#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-partner_position">
                        <label class="col col-12"><cf_get_lang dictionary_id='57573.Görev'></label>
                        <div class="col col-12">
                            <select name="partner_position" id="partner_position">
                                <option value=""><cf_get_lang dictionary_id='57573.Görev'></option>
                                <cfoutput query="get_partner_positions">
                                    <option value="#partner_position_id#" <cfif attributes.partner_position eq partner_position_id>selected</cfif>>#partner_position#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-partner_department">
                        <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                        <div class="col col-12">
                            <select name="partner_department" id="partner_department">
                                <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                                <cfoutput query="get_partner_departments">
                                    <option value="#partner_department_id#" <cfif attributes.partner_department eq partner_department_id>selected</cfif>>#partner_department#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                    <div class="form-group" id="item-search_potential">
                        <label class="col col-12"><cf_get_lang dictionary_id='62768.Cari Tipi'></label>
                        <div class="col col-12">
                            <select name="search_potential" id="search_potential">
                                <option value=""  <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
                                <option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>                
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="5" sort="true">
                    <div class="form-group" id="item-is_sale_purchase">
                        <label class="col col-12"><cf_get_lang dictionary_id='43926.Üye Tipi'></label>
                        <div class="col col-12">
                            <select name="is_sale_purchase" id="is_sale_purchase">
                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 1>selected</cfif>><cf_get_lang dictionary_id="58733.Alıcı"></option>
                                <option value="2" <cfif isDefined('attributes.is_sale_purchase') and attributes.is_sale_purchase is 2>selected</cfif>><cf_get_lang dictionary_id="58873.Satıcı"></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Kurumsal Hesap Kontak Kişiler',62037)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='30368.Çalışan'></th>
                    <th><cf_get_lang dictionary_id='57573.Görev'></th>
                    <th><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id='57572.Departman'></th>
                    <th width="50"><cf_get_lang dictionary_id='58143.İletişim'></th>
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
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#get_partner_all.partner_id#" class="tableyazi">#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</a></td>
                            <td><cfif Len(mission)>#get_mission_list.partner_position[listfind(mission_list,mission,',')]#</cfif></td>
                            <td><a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#get_partner_all.COMPANY_ID#" class="tableyazi">#fullname#</a></td>
                            
                            <td><cfif Len(department)>#get_department_list.partner_department[listfind(department_list,department,',')]#</cfif></td>
                            <td>
                                <ul class="ui-icon-list">
                                    <li>
                                        <cfif len(COMPANY_PARTNER_EMAIL)>
                                        <a href="mailto:#COMPANY_PARTNER_EMAIL#"><i class="fa fa-mail-forward" title="<cf_get_lang dictionary_id='57428.E-mail'>:#COMPANY_PARTNER_EMAIL#"></i></a>
                                        </cfif>
                                    </li>
                                    <li>
                                        <cfif len(COMPANY_PARTNER_TEL)>
                                            <a href="tel://#COMPANY_PARTNER_telcode##COMPANY_PARTNER_TEL#"><i class="fa fa-phone-square" title="<cf_get_lang dictionary_id='57499.Telefon'>: <cfif len(country) and len(company_partner_tel) and len(get_country_list.country_phone_code[listfind(country_list,country,',')])>(#get_country_list.country_phone_code[listfind(country_list,country,',')]#) </cfif>#COMPANY_PARTNER_telcode# - #COMPANY_PARTNER_TEL# <cfif len(company_partner_tel_ext)>(#company_partner_tel_ext#)</cfif>"></i></a>
                                        </cfif>
                                    </li>
                                    <li>
                                        <cfif len(COMPANY_PARTNER_FAX)>
                                            <i class="fa fa-fax" title="<cf_get_lang dictionary_id='57488.Fax'>:#COMPANY_PARTNER_telcode# - #COMPANY_PARTNER_FAX#"></i>
                                        </cfif>
                                    </li>
                                    <li>
                                        <cfif len(mobiltel)><a href="tel://#MOBIL_CODE##MOBILTEL#"><i class="fa fa-mobile-phone" title="<cf_get_lang dictionary_id='30254.Kod/Mobil Tel'>:#MOBIL_CODE# - #MOBILTEL#"></i></a></cfif>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9">
                            <cfif isDefined('attributes.form_submitted')>
                                <cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!
                            <cfelse>
                                <cf_get_lang dictionary_id='57701.Filtre Ediniz'>!
                            </cfif>
                        </td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
    
        <cfset adres = "member.list_contact">
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
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset adres = adres&"&form_submitted="&attributes.form_submitted>
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#get_partner_all.recordcount#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
