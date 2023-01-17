<cfif not isdefined("attributes.empapp_id") and not len(attributes.empapp_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='30956.Seçili bir kayıt yok'>");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="get_empapp" datasource="#dsn#">
	SELECT
		NAME,
		SURNAME
	FROM
		EMPLOYEES_APP
	WHERE
		EMPAPP_ID=#attributes.empapp_id#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57570.Ad Soyad'></cfsavecontent>
<cf_popup_box title="#message# : #get_empapp.name# #get_empapp.surname#">
<table align="center" width="100%">
	<tr>
    	<td>
			<!---form generator değerlendirme formları SG 20120905---->
			 <cf_get_workcube_form_generator action_type='7' related_type='7' action_type_id='#attributes.empapp_id#' design='3'>
			<br/>
		<!--- kabul edildigi ucret --->
		<cfsavecontent variable="txt">
			<cfoutput>#request.self#?fuseaction=myhome.popup_add_salary<cfif isdefined('attributes.list_id')>&list_id=#attributes.list_id#</cfif><cfif isdefined('attributes.list_row_id')>&list_row_id=#attributes.list_row_id#</cfif></cfoutput>
		</cfsavecontent>
		<cfsavecontent variable="message"><cf_get_lang dictionary_id='30988.Kabul edildiği ücret'></cfsavecontent>
		<cf_box closable="0" title="#message#" add_href="#txt#" add_href_size="small">
            <cf_ajax_list>
			<cfquery name="get_list_row" datasource="#dsn#">
				SELECT SALARY FROM EMPLOYEES_APP_SEL_LIST_ROWS WHERE LIST_ID = #attributes.list_id# AND LIST_ROW_ID = #attributes.list_row_id#
			</cfquery>
			<tbody>
				<cfif get_list_row.recordcount and len(get_list_row.salary)>
					<cfoutput query="get_list_row">
					<tr>
						<td><cfif len(salary)>#salary#</cfif></td>
					</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_ajax_list>
		<!--- //kabul edildiği ücret --->
		</cf_box>
		<br/>
		<!--- //Notlar --->
			<cf_get_workcube_note  action_section='LIST_ROW_ID' action_id='#attributes.list_row_id#'>
		<!--- //Notlar --->
		</td>
	</tr>
</table>
</cf_popup_box>
