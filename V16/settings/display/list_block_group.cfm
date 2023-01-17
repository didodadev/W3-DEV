<cfquery name="get_block_grpup" datasource="#dsn#">
	SELECT 
	    BLOCK_GROUP_ID, 
        BLOCK_GROUP_NAME, 
        BLOCK_GROUP_PERMISSIONS, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	BLOCK_GROUP
</cfquery>
<table>
	<cfif get_block_grpup.recordcount>
		<cfoutput query="get_block_grpup">
			<tr>
				<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_block_group&group_id=#block_group_id#" class="tableyazi">#block_group_name#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>
