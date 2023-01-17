<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.account_type_status" default='1'>
<cfset url_str = "">
<cfset payroll_accounts= createObject("component","V16.hr.ehesap.cfc.payroll_accounts_code") />
<cfif isdefined("attributes.form_submitted")>
	<cfset get_accounts=payroll_accounts.GET_ACCOUNTS(keyword:attributes.keyword,account_type_status:attributes.account_type_status)/>
<cfelse>
	<cfset get_accounts.recordcount = 0>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="filter_list_payroll_accounts" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50" placeholder="#getLang(48,'Filtre',57460)#">
                </div>
                <div class="form-group">
                    <select name="account_type_status" id="account_type_status">
                        <option value="1" <cfif isDefined("attributes.account_type_status")and (attributes.account_type_status eq 1)>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                        <option value="0" <cfif isDefined("attributes.account_type_status")and(attributes.account_type_status eq 0)>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                        <option value="-1" <cfif isDefined("attributes.account_type_status")and (attributes.account_type_status eq -1)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53139.Muhasebe Hesap Grupları"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cfparam name="attributes.keyword" default="">
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.totalrecords" default="#get_accounts.recordcount#">
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='58233.Tanım'></td>
                    <th width="20" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=ehesap.list_payroll_accounts&event=add</cfoutput>')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    <th width="20" class="header_icn_none"><a href="javascript://" ><i class="fa fa-copy"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_accounts.recordcount>
                        <cfoutput query="get_accounts" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_payroll_accounts&event=add&payroll_id=#payroll_id#')" class="tableyazi">#DEFINITION#</a></td>
                                <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_payroll_accounts&event=add&payroll_id=#payroll_id#')"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                                <td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=ehesap.list_payroll_accounts&event=add&payroll_id=#payroll_id#&is_copy=1')"><i class="fa fa-copy" title="<cf_get_lang dictionary_id='57476.Kopyala'>" alt="<cf_get_lang dictionary_id='57476.Kopyala'>"></i></a></td>
                            </tr>
                        </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list> 
        <cfset url_str = ''>
        <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
            <cfset url_str = '#url_str#&keyword=#attributes.keyword#'>
        </cfif>
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
        </cfif>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#attributes.fuseaction##url_str#">
    </cf_box>
</div>
<script type="text/javascript">
    	document.getElementById('keyword').focus();
</script>
