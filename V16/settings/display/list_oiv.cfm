<cfset goiv = createObject("component","V16.settings.cfc.oiv")/>
<cfset get_oiv= goiv.Select()/>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <cfif get_oiv.recordcount>
        <cfset tax_list=''>
        <cfoutput query="get_oiv">
            <cfif not listfind(tax_list,tax)>
                <cfset tax_list=listappend(tax_list,tax)>
            </cfif>
            <tr>
                <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>                  
                <td width="380"><a href="#request.self#?fuseaction=settings.list_oiv&event=upd&oid=#OIV_ID#" class="tableyazi">#tlformat(tax,3)#</a></td>
            </tr>
        </cfoutput>
        <cfset tax_list=listsort(tax_list,"numeric")>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><font class="tableyazi"><cf_get_lang_main dictionary_id='57484.Kayıt Yok'></font></td>
        </tr>    
    </cfif>
</table>