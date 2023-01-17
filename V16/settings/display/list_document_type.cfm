<cfquery name="GET_DOCUMENT_TYPES" datasource="#DSN#">
	SELECT 
		#dsn#.Get_Dynamic_Language(DOCUMENT_TYPE_ID,'#session.ep.language#','SETUP_DOCUMENT_TYPE','DOCUMENT_TYPE_NAME',NULL,NULL,DOCUMENT_TYPE_NAME) AS DOCUMENT_TYPE_NAME,
		DOCUMENT_TYPE_ID 
	FROM 
		SETUP_DOCUMENT_TYPE 
	ORDER BY 
		DOCUMENT_TYPE_NAME
</cfquery>

<table width="200" cellpadding="0" cellspacing="0" border="0">
<cfif get_document_types.recordcount>
  <cfoutput query="get_document_types">
    <tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
	    <td width="150">&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_document_type&document_type_id=#document_type_id#">#document_type_name#</a></td>
	</tr>
  </cfoutput>
<cfelse>
	<tr>
    	<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
        <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
    </tr>
</cfif>
</table>
