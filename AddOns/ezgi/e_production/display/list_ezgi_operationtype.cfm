<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="">
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../../../../V16/production_plan/query/get_operation_type.cfm">
<cfelse>
	<cfset get_operation_type.recordcount=0>
</cfif>
<cfif not len(attributes.is_active)><cfset attributes.is_active = 1></cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_operation_type.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=prod.list_ezgi_operationtype" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_big_list_search title="#getLang('prod',63)#"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    <td nowrap>
                        <select name="is_active" id="is_active" style="width:50px;">
                            <option value="2"><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                            <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                        </select>
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
        <tr>
            <th width="30"><cf_get_lang_main no='1165.Sıra'></th>
            <th width="120"><cfoutput>#getLang('prod',64)#</cfoutput></th>
            <th width="200"><cf_get_lang_main no='388.İşlem Tipi'></th>
            <th width="120"><cfoutput>#getLang('ch',188)#</cfoutput></th>
            <th><cfoutput>#getLang('main',616)#</cfoutput></th>
            <th width="90"><cf_get_lang_main no='3291.Haz.Süresi'> (<cf_get_lang_main no='3223.Sn'>.)</th>
            <th width="90"><cf_get_lang_main no='3292.İşl.Süresi'> (<cf_get_lang_main no='3223.Sn'>.)</th>
            <th width="130"><cf_get_lang_main no ='487.Kaydeden'></th>
            <th width="60"><cf_get_lang_main no='71.Kayıt'></th>
            <!-- sil --><th class="header_icn_none"> <a href="<cfoutput>#request.self#?fuseaction=prod.add_ezgi_operationtype</cfoutput>"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='388.İşlem Tipi'>"> </a></th><!-- sil -->
        </tr>
    </thead>
    <tbody>
        <cfif get_OPERATION_TYPE.recordcount>
        <cfoutput query="get_OPERATION_TYPE" STARTROW="#attributes.startrow#" MAXROWS="#attributes.maxrows#">
            <tr>
                <td>#CURRENTROW#</td>
                <td>#OPERATION_CODE#</td>
                <td><a href="#request.self#?fuseaction=prod.upd_ezgi_operationtype&operation_type_id=#get_OPERATION_TYPE.operatIon_type_Id#" class="TABLEYAZI">#OPERATION_TYPE#</a></td>
                <td>
                	<cfif is_virtual eq 1><cf_get_lang_main no='1515.Sanal'></cfif>
                 	<cfif is_virtual eq 0><cf_get_lang_main no='3293.Gerçek'></cfif>
                </td>
                <td title="#EZGI_FORMUL#">#Left(EZGI_FORMUL,90)#<cfif len(EZGI_FORMUL) gt 90>...</cfif></td>
                <td>#EZGI_H_SURE#</td>
                <td>#O_MINUTE#</td>
                <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                <td>#dateformat(RECORD_DATE,'dd/mm/yyyy')#</td>
                <!-- sil --><td align="center" width="15"><a href="#request.self#?fuseaction=prod.upd_ezgi_operationtype&operation_type_id=#get_OPERATION_TYPE.operatIon_type_Id#"><img src="/images/update_list.gif" title="#getLang('prod',219)#"></a></td><!-- sil -->
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list> 
<cfset url_str = "">
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    <cfif isdefined("attributes.form_submitted")>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cfif isdefined ("attributes.is_active") and len(attributes.is_active)>
        <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
    </cfif>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#get_operation_type.recordcount#"
        startrow="#attributes.startrow#"
        adres="prod.list_ezgi_operationtype#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>