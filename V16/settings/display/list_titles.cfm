<cf_get_lang_set module_name="settings">
<cfquery name="TITLECATEGORIES" datasource="#dsn#">
	SELECT HIERARCHY,TITLE,TITLE_ID FROM SETUP_TITLE ORDER BY TITLE
</cfquery>
<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center">
    <tr>
        <td class="headbold" height="35"><cf_get_lang no='165.Ünvanlar'></td>
    </tr>
</table>
<table width="98%" border="0" cellpadding="2" cellspacing="1" align="center" class="color-border">
    <tr height="22" class="color-header">
        <td class="form-title"><cf_get_lang_main no='159.Ünvan'></td>
        <td width="50" class="form-title"><cf_get_lang_main no='377.Özel Kod'></td>
        <td width="15">
        <cfif not (listfirst(url.fuseaction,".") is "hr")>
            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_title"><img src="/images/plus_square.gif" border="0" alt="<cf_get_lang no='666.Ünvan Kategorisi Ekle'>"></a>
        <cfelse>
            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.add_title"><img src="/images/plus_square.gif" border="0" alt="<cf_get_lang no='666.Ünvan Kategorisi Ekle'>"></a>
        </cfif>
        </td>
    </tr>
	<cfif titleCategories.recordcount>
		<cfoutput query="titleCategories">
            <tr class="color-row" height="20">
                <td>
                <cfif listfirst(url.fuseaction,'.') is 'hr'>
                    <a href="#request.self#?fuseaction=hr.upd_title&title_id=#TITLE_ID#" class="tableyazi">#title#</a>
                <cfelse>
                    <a href="#request.self#?fuseaction=settings.form_upd_title&title_id=#TITLE_ID#" class="tableyazi">#title#</a>
                </cfif>
                </td>
                <td>#HIERARCHY#</td>
                <td width="15">
                    <cfif listfirst(url.fuseaction,'.') is 'hr'>
                        <a href="#request.self#?fuseaction=hr.upd_title&title_id=#TITLE_ID#" class="tableyazi"><img src="/images/update_list.gif" border="0"></a>
                    <cfelse>
                        <a href="#request.self#?fuseaction=settings.form_upd_title&title_id=#TITLE_ID#" class="tableyazi"><img src="/images/update_list.gif" border="0"></a>
                    </cfif>
                </td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr height="20" class="color-row">
            <td colspan="3"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
<br/>
<cf_get_lang_set module_name="#fusebox.circuit#">
