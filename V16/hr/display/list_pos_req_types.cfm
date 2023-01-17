<cfif isdefined("attributes.position_id")>
  <cfset is_add = "hr.emptypopup_add_pos_requirement">
<cfelseif isdefined("attributes.employee_id")>
  <cfset is_add = "hr.emptypopup_add_emp_requirement">
</cfif>

<cfquery name="pos_req_types" datasource="#dsn#">
	SELECT 
		PRQ.REQ_TYPE_ID,
		PRQ.REQ_TYPE
	FROM 
		POSITION_REQ_TYPE PRQ,
		POSITION_REQUIREMENTS PR
	WHERE
		PR.POSITION_ID = #attributes.POSITION_ID#
		AND PR.REQ_TYPE_ID = PRQ.REQ_TYPE_ID
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#pos_req_types.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>


<cfscript>
url_string = '';

if (isdefined('attributes.maxrows')) url_string = '#url_string#&maxrows=#attributes.maxrows#';

</cfscript>

<cfquery name="GET_POS_NAME" datasource="#DSN#">
  SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_ID = #attributes.POSITION_ID#
</cfquery>

<table width="98%" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td class="headbold" valign="middle"><cf_get_lang dictionary_id='58497.pozisyon'> : <cfoutput>#GET_POS_NAME.POSITION_NAME#</cfoutput>
    </td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" border="0" width="98%" align="center">
<cfform action="#request.self#?fuseaction=hr.popup_pos_fit_employees" method="post" name="search">
         <cfif isDefined("attributes.position_id")>
		  <input type="hidden" name="position_id" id="position_id" value="<cfoutput>#attributes.position_id#</cfoutput>">
		 <cfelseif isDefined("attributes.EMPLOYEE_ID")>
		   <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
		 </cfif> 
  <tr class="color-border">
    <td>
		  <table cellspacing="1" cellpadding="2" width="100%" border="0">
			  <tr class="color-header">
				<td height="22" class="form-title" colspan="2"><cf_get_lang dictionary_id='57529.tanımlar'></td>
			  </tr>
			<cfoutput query="pos_req_types" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			 <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="20"><input type="checkbox" name="REQ_TYPE_ID" id="REQ_TYPE_ID" value="#REQ_TYPE_ID#"></td>
				<td>#REQ_TYPE#</td>
			  </tr>
			</cfoutput>
		  </table>
    </td>
  </tr>
  <tr>
    <td height="30"  style="text-align:right;">
	  <cf_workcube_buttons is_upd='0'>
	</td>
  </tr>
</table>
</cfform>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
    <tr>
      <td><cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="hr.pos_req_types#url_string#"> </td>
      <!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57492.toplam'>:#pos_req_types.recordcount#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
    </tr>
  </table>
</cfif><br/>

