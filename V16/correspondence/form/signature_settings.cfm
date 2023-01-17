<cfsetting showdebugoutput="no">
<script type="text/javascript">
	function mail_signature()
	{		
		if(employee_mail_signatures.name.value == "")
		{
			alert("<cf_get_lang no='250.Lutfen Imza Adi Giriniz!'>");
			return false;
		}
		return true;		 
	}
	function signature_delete()
	{
		document.employee_mail_signatures.operation.value='del';
	}
</script>
<cfsavecontent variable="mailaccount"><cf_get_lang no ='102.Mail Account'></cfsavecontent>
<cf_box title="G�ncelleme" collapsable="0" style="position:absolute;width:550px;">
<cfform action="#request.self#?fuseaction=correspondence.emptypopup_upd_signature_settings&signature_id=#attributes.signature_id#&employee_id=#attributes.employee_id#" method="post" name="employee_mail_signatures">
<input type="Hidden" name="employee_id" id="employee_id" value="#attributes.employee_id#">
<input type="hidden" name="operation" id="operation" value="upd" />
<cfquery name="up_signature" datasource="#DSN#">
	SELECT 
		SIGNATURE_ID, 
		EMPLOYEE_ID, 
		SIGNATURE_NAME, 
		SIGNATURE_DETAIL, 
		STANDART_SIGNATURE 
	FROM 
		CUBE_MAIL_SIGNATURE 
	WHERE 
		SIGNATURE_ID=#attributes.signature_id#
</cfquery>
<table> 
<cfif up_signature.recordcount>  
<cfoutput query="up_signature">
 	<tr>
        <td><cf_get_lang no='230.Imza Tanimi'><cfinput type="text" name="name" value="#SIGNATURE_NAME#" style="width:320px;" ></td>
		<td><cf_get_lang dictionary_id="30472.Standart Imza"> <input type="checkbox" name="standart_signature" id="standart_signature" value="1" <cfif standart_signature eq 1>checked</cfif>/></td>
    </tr>
	<tr>
	<td colspan="2">
	<cfmodule 			
        template="/fckeditor/fckeditor.cfm"
        toolbarSet="WRKContent"
        basePath="/fckeditor/"
        instanceName="detail"
        value="#SIGNATURE_DETAIL#"
        height="300">
		<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		</td>
	</tr></cfoutput>
	<tr height="35">
        <td style="text-align:right" colspan="2">
		<cf_workcube_buttons is_upd='1' del_function="signature_delete()" is_cancel="0" add_function="mail_signature()"></td>
    </tr>	
</cfif>
</table>
</cfform>
</cf_box>

