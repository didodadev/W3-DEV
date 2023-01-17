<cfscript>
	attributes.employee_name = trim(attributes.employee_name);
	attributes.employee_surname = trim(attributes.employee_surname);
	if(isdefined("attributes.socialsecurity_no")){attributes.socialsecurity_no = trim(attributes.socialsecurity_no);}
	attributes.identycard_no = trim(attributes.identycard_no);	
	attributes.tax_number = trim(attributes.tax_number);	
</cfscript>
<cfquery name="GET_EMPLOYEES_APP" datasource="#dsn#">
	SELECT 
		EMPAPP_ID,
		NAME,
		SURNAME,
		TAX_NUMBER,
		WORKTELCODE,
		WORKTEL,
		MOBILCODE,
		MOBIL,
		SOCIALSECURITY_NO,
		IDENTYCARD_NO,
		EMAIL
	FROM
		EMPLOYEES_APP
	WHERE
		NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_name#"> OR
		SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.employee_surname#">
		<cfif isdefined("attributes.socialsecurity_no") and len(attributes.socialsecurity_no)>OR SOCIALSECURITY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.socialsecurity_no#"></cfif>
		<cfif len(attributes.identycard_no)>OR IDENTYCARD_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.identycard_no#"></cfif>
		<cfif len(attributes.tax_number)>OR TAX_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.tax_number#"></cfif>
</cfquery>
<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
  <tr>
	<td height="35" class="headbold"><cf_get_lang no='1021.Benzer Kriterlerde Kayitlar Bulundu'> !</td>
  </tr>
</table>
<table cellspacing="0" cellpadding="0" width="98%" border="0" align="center">
  <tr class="color-border">
    <td>
      <table cellspacing="1" cellpadding="2" width="100%" border="0">
		<tr height="22" class="color-header">
            <td class="form-title" width="25"><cf_get_lang_main no='75.No'></td>
			<td class="form-title" nowrap><cf_get_lang_main no='158.Ad soyad'></td>
			<td class="form-title" nowrap><cf_get_lang_main no='87.Telefon'></td>
			<td class="form-title" nowrap width="120">GSM</td>
            <td class="form-title" width="120"><cf_get_lang_main no='16.E Mail'></td>
            <td class="form-title" width="120"><cf_get_lang no='301.Kimlik Kartı No'></td>
            <td class="form-title" width="120"><cf_get_lang_main no='340.Vergi no'></td>
            <td class="form-title" width="120"><cf_get_lang no='1022.SSK No'></td>
		  </tr>
		  <form name="search_" method="post" action="">
		  <cfif GET_EMPLOYEES_APP.recordcount>
			  <cfoutput query="GET_EMPLOYEES_APP">
				<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td>#currentrow#</td>
				<td nowrap><a href="://javascript" onClick="control(1,#empapp_id#);" class="tableyazi">#name# #surname#</a></td>
				<td>#WORKTELCODE# #WORKTEL#</td>
				<td>#MOBILCODE# #MOBIL#</td>
				<td>#EMAIL#</td>
				<td>#IDENTYCARD_NO#</td>
				<td>#TAX_NUMBER#</td>
				<td>#SOCIALSECURITY_NO#</td>
			</tr>
			</cfoutput>
			<tr class="color-row">
			<td height="35" colspan="8" style="text-align:right;"><input type="submit" name="Devam" id="Devam" value="<cf_get_lang no ='1343.Varolan Kayıtları Gözardi Et'>  " onClick="control(2,0);"></td>
			</tr>
			<cfelse>
				<tr class="color-row">
					<td height="20" colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadi'> !</td>
				</tr>
			</cfif>
			</form>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
<cfif not GET_EMPLOYEES_APP.recordcount>
	opener.employe_detail.submit();
	window.close();
</cfif>
function control(id,value)
{
	if(id==1)
	{
		opener.location.href='<cfoutput>#request.self#?fuseaction=hr.form_upd_cv&empapp_id=</cfoutput>' + value;
		window.close();
	}
	if(id==2)
	{
		opener.employe_detail.submit();
		window.close();
	}
}
</script>

