<cfparam name="attributes.period" default="">
<cfquery name="GET_POSITION" datasource="#dsn#">
	SELECT POSITION_CODE,DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfscript>
	if (get_position.recordcount)
	{
		position_list = valuelist(get_position.position_code,',');
		department_list = valuelist(get_position.department_id,',');
	}
	else
	{
		position_list = session.ep.position_code;
		department_list = 0;
	}
</cfscript>
<cfquery name="GET_COMPANY" datasource="#dsn#">
	SELECT 
		COMPANY_NAME,
		COMP_ID,
		NICK_NAME,
		MANAGER_POSITION_CODE,
		MANAGER_POSITION_CODE2
	FROM 
		OUR_COMPANY 
		<cfif not session.ep.ehesap>WHERE MANAGER_POSITION_CODE IN (#position_list#)</cfif>
	ORDER BY 
		COMPANY_NAME
</cfquery>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
  <tr> 
	<td valign="top">	
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr> 
    <td height="35" class="headbold"><cf_get_lang dictionary_id='31348.Hedef Yetkinlik Belirleme'></td>
  </tr>
</table>
<table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
  <tr class="color-border"> 
    <td> 
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
       <tr height="20" class="color-row">
          <td>
		  	<table>
				<form name="add_perfection" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.emptypopup_add_target_perfection">
				<tr>
					<td><cf_get_lang dictionary_id='57574.Şirket'>*</td>
					<td><select name="company_id" id="company_id" style="width:250;">
						<option value=""><cf_get_lang dictionary_id='57574.Şirket'></option>
						<cfoutput query="get_company">
							<option value="#comp_id#">#company_name#</option>
						</cfoutput>
					</select></td>
				</tr>
				<tr>
					<td width="70"><cf_get_lang dictionary_id='58472.Dönem'>*</td>
					<td><select name="period" id="period" style="width:250">
						<cfloop from="#year(now())-2#" to="#year(now())+2#" index="i">
							<cfoutput>
								<option value="#i#" <cfif i eq year(now())>selected</cfif>>#i#</option>
							</cfoutput>
						</cfloop>
					</select></td>
				</tr>
				<tr>
					<td><cf_get_lang dictionary_id='31599.Hedef Ağırlığı'>*</td>
					<td><input type="text" name="target_size" id="target_size" style="width:250;" value="50" readonly="" maxlength="2" onKeyup="return(FormatCurrency(this,event));"></td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang dictionary_id='57758.Şirket Vizyonu'></td>
					<td><textarea name="vizyon" id="vizyon" style="width:250;height:80;"></textarea></td>
				</tr>
				<tr>
					<td valign="top"><cf_get_lang dictionary_id='57629.Açıklama'></td>
					<td><textarea name="detail" id="detail" style="width:250;height:80;"></textarea></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><cf_workcube_buttons add_function='control()'></td>
				</tr>
				</form>
			</table>
		  </td>
        </tr>
      </table>
  </td>
 </tr>
</table>
</td>
 </tr>
</table>
<script language="javascript">
function control()
{
	x = document.add_perfection.company_id.selectedIndex;
	if (document.add_perfection.company_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='57574.Şirket'>!");
		return false;
	}
	if(document.add_perfection.target_size.value == "")
	{
		alert("<cf_get_lang no='965.Hedef Ağırlığı'>!");
		return false;
	}
}
</script>
