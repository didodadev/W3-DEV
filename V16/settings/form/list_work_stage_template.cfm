<cfsetting showdebugoutput="no">
<cfquery name="GET_PROCESS" datasource="#DSN#">
	SELECT
		PT.STAGE,
		PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PT
	WHERE
		PT.PROCESS_ROW_ID IN(#attributes.process_id_list#)
	ORDER BY
		PT.STAGE
</cfquery>
<cfquery name="GET_CAT" datasource="#DSN#">
	SELECT TEMPLATE_ID,TEMPLATE_HEAD FROM TEMPLATE_FORMS WHERE TEMPLATE_MODULE = 1
</cfquery>
<cfquery name="get_template" datasource="#dsn#">
	SELECT 
    	PRO_WORK_CAT_TEMPLATE_ID, 
        PRO_WORK_CAT_ID, 
        PROCESS_ID, 
        TEMPLATE_ID 
    FROM 
    	PRO_WORK_CAT_TEMPLATE 
    WHERE 
	    PRO_WORK_CAT_ID = #work_cat_id#
</cfquery>
<cfform action="#request.self#?fuseaction=settings.emptypopup_pro_work_cat_upd_template" method="post" name="pro_work_cat_template">
<cf_box title="Aşama Şablon Seçimi">
<table border="0" width="200" cellpadding="2" cellspacing="1">
	<input type="hidden" name="work_cat_id" id="work_cat_id" value="<cfoutput>#work_cat_id#</cfoutput>">
	<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#get_process.recordcount#</cfoutput>">
	<cfoutput query="get_process">
		<input type="hidden" name="process_id_#currentrow#" id="process_id_#currentrow#" value="#process_row_id#">
		<cfquery name="get_row_template" dbtype="query">
			SELECT * FROM get_template WHERE PROCESS_ID = #process_row_id#
		</cfquery>
		<tr>
			<td>#STAGE#</td>
			<td>
				<select name="template_id_#currentrow#" id="template_id_#currentrow#" style="width:200px;">
					<option value="" selected="selected"><cf_get_lang_main no='1228.Şablon'></option>
					<cfloop query="get_cat">
						<option value="#template_id#" <cfif get_row_template.recordcount and get_row_template.template_id eq get_cat.template_id>selected</cfif>>#TEMPLATE_HEAD#</option>
					</cfloop>
				</select>
			</td>
		</tr>
	</cfoutput>
	<cfif get_process.recordcount>
		<tr>
			<td colspan="2" style="text-align:right"><input type="button" value="Güncelle" onClick="add_template()"></td>		
		</tr>
	</cfif>
</table>
</cfform>
<script language="javascript">
	function add_template()
	{
		document.pro_work_cat_template.submit();
	}
</script>
