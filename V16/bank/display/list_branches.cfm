<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_branches.cfm">
<cfelse>
	<cfset get_branches.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.bank" default=''>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.totalrecords" default='#get_branches.recordcount#'>
<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cf_get_lang_set module_name="bank"><!--- sayfanin en altinda kapanisi var  VE YERİ DEĞİŞMESİN,üstteki include ları etkiliyor--->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
        <cfform name="form" id="form" action="" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" maxlength="50" name="keyword" placeholder="#getLang(48,'Filtre',57460)#" id="keyword" value="#attributes.keyword#">
                </div>
                <div class="form-group">
                    <select name="bank" id="bank" style="width:150px;" >
                        <option value=""><cf_get_lang dictionary_id='57521.Banka'></option>
                        <cfinclude template="../query/get_banks.cfm">
                        <cfoutput query="get_banks">
                            <option value="#bank_name#" <cfif isdefined('attributes.bank') and attributes.bank eq bank_name>selected</cfif>>#bank_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(2245,'Banka Şubeleri',30042)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='29532.Şube Adı'></th>
                    <th><cf_get_lang dictionary_id='59005.Şube Kodu'></th>
                    <th><cf_get_lang dictionary_id='48695.Banka Adı'></th>
                    <th><cf_get_lang dictionary_id='57578.Yetkili'></th>
                    <th><cf_get_lang dictionary_id='57971.Şehir'></th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center">
                        <cfif not listfindnocase(denied_pages,"#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('bank'))#.popup_add_bank_branch")>
                            <a href="<cfoutput>#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#</cfoutput>.list_bank_branch&event=add"><i class="fa fa-plus" alt="<cf_get_lang dictionary_id='57582.Ekle'>" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                        </cfif>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
                <cfif get_branches.recordcount>
                    <cfoutput query="get_branches" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <cfset branch_id=get_branches.bank_branch_id>
                            <td>#get_branches.currentrow#&nbsp;</td>
                            <td><a class="tableyazi" href="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_branch&event=upd&ID=#branch_id#">#get_branches.bank_branch_name#</a></td>
                            <td>#get_branches.branch_code#&nbsp;</td>
                            <td>#get_branches.bank_name#&nbsp;</td>
                            <td>#get_branches.contact_person#&nbsp;</td>
                            <td>#get_branches.bank_branch_city#&nbsp;</td>
                            <!-- sil -->
                            <td style="text-align:center;">
                                <cfif not listfindnocase(denied_pages,"#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('bank'))#.popup_upd_bank_branch")>
                                    <a href="#request.self#?fuseaction=#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_branch&event=upd&id=#branch_id#"><i class="fa fa-pencil"  alt="<cf_get_lang dictionary_id='57464.Güncelle'>" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
                                </cfif>
                            </td>  
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset url_str = "#iif(fusebox.circuit eq 'ehesap',DE('ehesap'),DE('finance'))#.list_bank_branch">
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.bank") and len(attributes.bank)>
            <cfset url_str = "#url_str#&bank=#attributes.bank#">
        </cfif>
        <cfset url_str = "#url_str#&form_submitted=1">
        <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#url_str#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
