<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfif form_varmi eq 1>
    <cfinclude template="../query/get_rival_list.cfm">
<cfelse>
	<cfset get_rival_list.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_rival_list.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=store.rivals" method="post">
    <cf_big_list_search title="#getLang('store',18)#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                	<cfinput type="hidden" name="is_form_submitted" value="1">
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="50"></td>
                    <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" style="width:25px;" required="yes" onKeyUp="isNumber(this)" maxlength="3" value="#attributes.maxrows#" validate="integer" range="1,250" message="#message#" ></td>
                    <td><cf_wrk_search_button></td>
                <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list>
    <thead>
        <tr>
            <th width="30"><cf_get_lang_main no='1165.Sıra'></th>
            <th><cf_get_lang_main no='1367.Rakip'></th>
            <th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=store.popup_form_add_rival</cfoutput>','medium');"><img src="/images/plus_list.gif" title="<cf_get_lang no='111.Rakip Ekle'>"></a></th>
           
        </tr>
    </thead>
    <tbody>
        <cfif get_rival_list.recordcount>
        <cfoutput query="get_rival_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
            <tr>
                <td>#currentrow#</td>
                <td><a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=store.popup_form_upd_rival&r_id=#r_id#','medium');">#rival_name#</a></td>
                <!-- sil -->
                <td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=store.popup_form_upd_rival&r_id=#r_id#','medium');"><img src="/images/update_list.gif" title="<cf_get_lang no='110.Rakibi Düzenle'>"></a></td>
                <!-- sil -->
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="3"><cfif form_varmi eq 0><cf_get_lang_main no="289.Filtre Ediniz">!<cfelse><cf_get_lang_main no='72.Kayıt Yok'>!</cfif></td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list>
<cfset url_str = "store.rivals">
<cfif isdefined("attributes.is_form_submitted")>
	<cfset url_str = "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
</cfif>
<cfif len(attributes.keyword)>
    <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.branch_id")>
    <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
