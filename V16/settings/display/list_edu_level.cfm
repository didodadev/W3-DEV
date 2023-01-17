<cfinclude template="../query/get_edu_level.cfm">
<table>
    <cfif GET_EDU.recordcount>
        <cfoutput query="GET_EDU">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_edu_level&edu_id=#EDU_LEVEL_ID#" class="tableyazi">#EDUCATION_NAME#</a></td>
            </tr>
    </cfoutput>
    <cfelse>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
    </cfif>
</table>
