<cfquery name="WORK_CATS" datasource="#DSN#">
	SELECT WORK_CAT_ID,#dsn#.Get_Dynamic_Language(WORK_CAT_ID,'#session.ep.language#','PRO_WORK_CAT','WORK_CAT',NULL,NULL,WORK_CAT) AS WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
</cfquery>
<table>   
	<cfif WORK_CATS.RecordCount>
        <cfoutput query="WORK_CATS">
            <tr>
                <td width="20" class="text-right"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_pro_work_cat&ID=#WORK_CAT_ID#" class="tableyazi">#WORK_CAT#</a></td>
            </tr>
      </cfoutput>
    <cfelse>
        <tr>
            <td width="20" class="text-right"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
     </cfif>
</table>
