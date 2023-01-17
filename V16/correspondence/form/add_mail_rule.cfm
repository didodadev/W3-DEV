<cfsetting showdebugoutput="no">
<script type="text/javascript">
	function mail_rule(){
			if(employee_mail_rules.name.value == "")
				{
					alert("<cf_get_lang no='244.Lütfen Kural Tanımı Giriniz!'>");
					return false;
				}
			if(employee_mail_rules.words.value == "")
				{
					alert("<cf_get_lang no='245.Lütfen Kelime Giriniz!'>");
					return false;
				}
		return true;
	}
</script>
<cfquery name="add_rule" datasource="#DSN#">
  	SELECT * FROM CUBE_MAIL_RULES
  </cfquery>
<cf_box title="Kural Ekle" collapsable="0" style="position:absolute;width:300px;">
    
<table>   
	<cfform action="#request.self#?fuseaction=correspondence.emptypopup_mail_rules_setting" method="post" name="employee_mail_rules">
	<cfinput type="Hidden" name="employee_id" value="#attributes.employee_id#">
 	<tr>
        <td><cf_get_lang no='246.Kural Tanımı'></td>
        <td><cfinput type="text" name="name" style="width:150px;"></td>
    </tr>
    <tr>
        <td><cf_get_lang no='226.Arama Tipi'></td>
		<td>
		<select name="type" id="type" style="width:150px;">
			<option value="1"><cf_get_lang no='235.Mail Kimden Satırında Ara'></option>
			<option value="2"><cf_get_lang no='236.Mail İçeriğinde Ara'></option>
			<option value="3"><cf_get_lang no='237.Mail Başlığında Ara'></option>
			<option value="4"><cf_get_lang no='238.Mail Kime Satırında Ara'></option>
		</select></td>
    </tr>
    <tr>
        <td><cf_get_lang no='227.Kelime'></td>
        <td><cfinput type="text" name="words" value="" style="width:150px;"></td>
    </tr>
    <tr>
        <td><cf_get_lang no='228.Taşınacak Klasör'></td>
        <td>
		<select name="folder" id="folder" style="width:150px;">
			<cfinclude template="../query/get_folders.cfm">
			<cfoutput query="get_folders">
				<cfif folder_id gt 0>
					<option value="#folder_id#">#folder_name#</option>
				</cfif>
			</cfoutput>
		</select>
		</td>
    </tr>
	<tr>
		<td><cf_get_lang_main no="73.Öncelik"></td>
		<td>
			<select name="priority" id="priority">
                <option value="0"><cf_get_lang_main no="322.Seçiniz"></option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
                <option value="9">9</option>
                <option value="10">10</option>
			</select>
		</td>
	</tr>
	<tr height="35">
        <td></td>
        <td style="text-align:right;" style="text-align:right;"><cf_workcube_buttons is_upd='0' is_cancel="0" add_function="mail_rule()">
		</td>
    </tr>	
	</cfform>
</table>
</cf_box>	
