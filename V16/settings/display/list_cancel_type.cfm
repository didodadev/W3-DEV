<cfset setupCancel = CreateObject("component",'V16.settings.cfc.setupCancel') /> 
<cfset setupCancel.dsn3 = DSN3>
<cfset get_cancel_type = setupCancel.getCancelTypeFnc()>

<table>
	<cfif get_cancel_type.recordcount>
        <cfoutput query="get_cancel_type">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_cancel_type&id=#cancel_id#" class="tableyazi">#cancel_name# - <cfif get_cancel_type.cancel_type eq "CREDIT_CARD"> <cf_get_lang dictionary_id='57836.Kredi Kartı Tahsilat'></cfif></a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
