<cfset gbsmv = createObject("component","V16.settings.cfc.bsmv")/>
<cfset get_bsmv= gbsmv.Select()/>
<table>
    <cfif get_bsmv.recordcount>
    <cfset tax_list=''>
        <cfoutput query="get_bsmv">
            <cfif not listfind(tax_list,tax)>
                <cfset tax_list=listappend(tax_list,tax)>
            </cfif>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.list_bsmv&event=upd&bid=#BSMV_ID#" class="tableyazi">#tlformat(tax,3)#</a></td>
            </tr>
        </cfoutput>
        <cfset tax_list=listsort(tax_list,"numeric")>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td colspan="380"><cf_get_lang_main dictionary_id='57484.Kayıt Yok'></td>
        </tr>    
    </cfif>
</table>