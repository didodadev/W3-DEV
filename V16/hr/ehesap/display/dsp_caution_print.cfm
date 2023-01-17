<cfinclude template="../query/get_caution.cfm">
<div align="center">
<cfinclude template="../../../#application.objects['objects.popup_view_company_info_logo']['filePath']#"> 
<table width="650">
	<tr>
			<td><cf_get_lang dictionary_id="58772.İşlem No"> <cfoutput><STRONG>#get_caution.caution_id#</STRONG></cfoutput></td>		
			<td style="text-align:right;">
			<cf_get_lang dictionary_id="57879.İşlem Tarihi"> : 
			<cfset a_date=date_add('H',#SESSION.EP.TIME_ZONE#,get_caution.RECORD_DATE)>
			<cfset adate=dateformat(a_date,dateformat_style)>
			<cfoutput><STRONG>#adate#</STRONG></cfoutput>
			</td>
	</tr>
	<tr>
		<td height="50" colspan="2">
		<cfoutput>
		<STRONG>#get_caution.employee_name# #get_caution.employee_surname#</STRONG> <cf_get_lang dictionary_id="41543.adlı çalışan yukarıda belirtilen tarihte 
		disiplin cezası almıştır. İşlem Başlığı ve Metni Aşağıdadır.">
		</cfoutput>
		</td>                                                                                                                                                                                                                                                                                    </td>
	</tr>
  </table>	
<cfoutput>
  <table width="650">
    <tr>
      <td><strong>#get_caution.caution_head#</strong> <br/>
        #get_caution.caution_detail# </td>
    </tr>
  </table>
</cfoutput>	<br/>
	<table width="650">
  <tr>
  	<td class="formbold"><cf_get_lang dictionary_id='53092.Savunma'></td>
  </tr>
  <tr>
  	<td><cfoutput>#GET_CAUTION.APOLOGY#</cfoutput></td>
  </tr>
  <tr>
		<td style="text-align:right;">
	  	<table border="0">
			<tr>
				<td width="70"><STRONG><cf_get_lang dictionary_id="58586.İşlem Yapan"></STRONG></td>
				<td width="150">
					<cfset attributes.employee_id = get_caution.warner>
					<cfinclude template="../query/get_employee.cfm">
					<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput></td>
				<td width="70"><STRONG><cf_get_lang dictionary_id="57483.Kayıt"></STRONG></td>
				<td>
				<cfset attributes.employee_id = get_caution.record_emp>
				<cfinclude template="../query/get_employee.cfm">
				<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</div>
<script type="text/javascript">
	window.print();
</script>
