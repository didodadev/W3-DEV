<cfsetting showdebugoutput="no">
<script type="text/javascript">
	function mail_signature(){
			if(employee_mail_signature.name.value == "")
			{
				alert("<cf_get_lang no='250.Ltfen Imza Adi Giriniz'>");
				return false;
			}
		return true;
	}
</script>
<cfquery name="add_signature" datasource="#DSN#">
  	SELECT * FROM CUBE_MAIL_SIGNATURE
  </cfquery>
<cf_box title="Imza Ekle" collapsable="0" style="position:absolute; overflow:auto;width:550px;">
    
<table>   
	<cfform action="#request.self#?fuseaction=correspondence.emptypopup_mail_signature_setting" method="post" name="employee_mail_signature">
	<cfinput type="Hidden" name="employee_id" value="#attributes.employee_id#">
 	<tr>
        <td><cf_get_lang no='230.Imza Tanimi'>
        <cfinput type="text" name="name" style="width:320px;">
		</td>
		<td align="left">Standart Imza
		<input type="checkbox" name="standart_signature" id="standart_signature" /> 
		</td>
    </tr>
    <tr>
		<td colspan="2">
		<cfmodule 		
			template="/fckeditor/fckeditor.cfm"
			toolbarSet="WRKContent"
			basePath="/fckeditor/"
			instanceName="detail"
			value=""
			height="300">
			<input type="hidden" name="event_id" id="event_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		</td>

    </tr>
   <!---  <tr>
        <td>Kelime</td>
        <td><cfinput type="text" name="words" value="" style="width:150px;"></td>
    </tr>
    <tr>
        <td>Tasinacak Klasr</td>
        <td>
		<select name="folder" style="width:150px;">
			<cfinclude template="../query/get_folders.cfm">
			<cfoutput query="get_folders">
			<option value="#folder_id#">#folder_name#</option> </cfoutput>
		</select></td>
    </tr> --->
	<tr height="35">
        <td colspan="2" style="text-align:right;"><cf_workcube_buttons is_upd='0' is_cancel="0" add_function="mail_signature()"></td>
    </tr>	
	</cfform>
</table>
</cf_box>		

