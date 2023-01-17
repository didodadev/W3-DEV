<cf_xml_page_edit fuseact="myhome.welcome">
<cfif (not get_module_user(4)) and ((not isdefined('xml_is_my_members')) or xml_is_my_members neq 1)>
	<script language="javascript">
		alert("<cf_get_lang dictionary_id='59953.Sayfayı Görmek İçin Yetkiniz Yok'>!");
		history.back();
	</script>
</cfif>
<cfinclude template="../includes/get_company_cat.cfm">
<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
	<cfinclude template="../query/get_my_company.cfm">
<cfelse>
	<cfset get_my_company.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_my_company.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_submitted" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.is_submitted)>
	<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
</cfif>
<cfform action="#request.self#?fuseaction=myhome.my_companies" method="post" name="form">
    <input type="hidden" name="is_submitted" id="is_submitted" value="1">
    <cf_box id="list_worknet_search" closable="0" collapsable="0">
        <cf_big_list_search_area>
            <div class="row form-inline">
                <div class="form-group" id="form_ul_keyword">
                    <div class="input-group x-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                        <input type="text" name="keyword" id="keyword" value="<cfoutput>#attributes.keyword#</cfoutput>" style="width:100px;" placeholder="<cfoutput>#message#</cfoutput>">
                    </div>
                </div>
                <div class="form-group" id="form_ul_maxrows">
                    <div class="input-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
                    </div>
                </div>
                <div class="form-group" id="form_ul_search">
                    <div class="input-group">
                        <cf_wrk_search_button>
                        <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                    </div>
                </div>
            </div>
        </cf_big_list_search_area>
    </cf_box>
</cfform>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="31355.Üyelerim"></cfsavecontent>
<cf_box id="list_companies" closable="0" collapsable="0" title="#title#">
    <cf_ajax_list>
        <thead>
            <tr>
                <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                <th><cf_get_lang dictionary_id='57658.Üye'></th>
                <th><cf_get_lang dictionary_id='31097.Üye Tipi'></th>
                <th><cf_get_lang dictionary_id='57578.Yetkili'></th>
                <th><cf_get_lang dictionary_id='31099.Rol'></th>
            </tr>
        </thead>
        <tbody>
            <cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
                <cfif get_my_company.recordcount>
                <cfset roles_list = "">
                <cfoutput query="get_my_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <cfif len(role_id) and not listfind(roles_list,role_id)>
                        <cfset roles_list=listappend(roles_list,role_id)>
                    </cfif>
                </cfoutput>
                <cfif len(roles_list)>
                    <cfquery name="get_rol" datasource="#dsn#">
                        SELECT PROJECT_ROLES_ID,PROJECT_ROLES FROM SETUP_PROJECT_ROLES WHERE PROJECT_ROLES_ID IN (#roles_list#)ORDER BY PROJECT_ROLES	
                    </cfquery>
                    <cfset roles_list = listsort(listdeleteduplicates(valuelist(get_rol.project_roles_id,',')),'numeric','ASC',',')>
                </cfif>
                <cfoutput query="get_my_company" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td><cfif get_my_company.type is 'company'>
                                    <a href="#request.self#?fuseaction=myhome.my_company_details&cpid=#company_id#&member_type=partner" class="tableyazi">#fullname#</a>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=myhome.my_consumer_details&cid=#company_id#&member_type=consumer" class="tableyazi">
                                <cfset attributes.consumer_id = company_id>
                                <cfinclude template="../query/get_consumer.cfm">
                                #get_consumer.consumer_name# #get_consumer.consumer_surname#</a>
                            </cfif>
                        </td>
                        <td>
                            <cfif get_my_company.type is 'COMPANY'>
                                <cf_get_lang dictionary_id='31100.Kurumsal'>
                            <cfelse>
                                <cf_get_lang dictionary_id='31101.Bireysel'>
                            </cfif>
                        </td>
                        <td><cfif len(manager_partner_id) and manager_partner_id neq "0">
                                <cfquery name="get_manager" datasource="#dsn#">
                                    SELECT 
                                        COMPANY_PARTNER_NAME, 
                                        COMPANY_PARTNER_SURNAME, 
                                        COMPANY_PARTNER_EMAIL
                                    FROM 
                                        COMPANY_PARTNER 
                                    WHERE 
                                        PARTNER_ID = #manager_partner_id#
                                </cfquery>
                                    <a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#manager_partner_id#" class="tableyazi">#get_manager.company_partner_name# #get_manager.company_partner_surname#</a> &nbsp;
                                <cfelse>
                                <cf_get_lang dictionary_id='30875.Yönetici Seçilmedi'>
                            </cfif>
                        </td>
                        <td><cfif (get_my_company.position_code eq session.ep.position_code) and (get_my_company.is_master eq 1)>
                                <cf_get_lang dictionary_id='57908.Temsilci'>
                            <cfelseif len(role_id)>
                            <cfset attributes.company_id = company_id>
                                <cf_get_lang dictionary_id='31103.Ekip Çalışanı'> : #get_rol.project_roles[listfind(roles_list,role_id,',')]#
                            <cfelse>
                                <cf_get_lang dictionary_id='31103.Ekip Çalışanı'>
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
                <cfelse>
                    <tr>
                        <td colspan="5"><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</td>
                    </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>
</cf_box>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="myhome.my_companies#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
