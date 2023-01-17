<cfset gotv = createObject("component","V16.settings.cfc.otv")/>
<cfset get_otv= gotv.Select()/>
<table>
    <cfif get_otv.recordcount>
        <cfset tax_list=''>
        <cfoutput query="get_otv">
            <cfif not listfind(tax_list,tax)>
                <cfset tax_list=listappend(tax_list,tax)>
            </cfif>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.list_otv&event=upd&oid=#otv_ID#" class="tableyazi"><cfif tax_type eq 1>#tlformat(tax,4)# &nbsp<cf_get_lang dictionary_id='58544.Sabit'> <cfelseif tax_type eq 2>#tlformat(tax)#% <cfelse>#tax#</cfif></a></td>
            </tr>
        </cfoutput>
        <cfset tax_list=listsort(tax_list,"numeric")>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>    
    </cfif>
</table>