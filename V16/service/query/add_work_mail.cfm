<style type="text/css">
	.label {font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
	.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
	.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
</style>
<cfinclude template="../../objects/display/view_company_logo.cfm">
<cfoutput>
<table width="590">
  <tr>
	<td colspan="2">
	  <cf_get_lang_main no='1368.Sayın'> #task_user_name# #task_user_surname#,<br/>
		#session.ep.name# #session.ep.surname# <cf_get_lang no='173.tarafından adınıza yapılmış bir servis görevi  yapıldı'>
		<br/><br/><br/>
		<b><cf_get_lang no='174.İlgili İş Linki'></b>
		<cfif len(form.task_emp_id)>
		  <!--- BK 060710 <a href ='#employee_domain##request.self#?fuseaction=service.list_service&event=upd&service_id=#get_last_id.service_id#'><font color="FF0000">#FORM.SERVICE_HEAD#</font></a> --->		
		  <a href ='#user_domain##request.self#?fuseaction=service.list_service&event=upd&service_id=#GET_SERVICE1.service_id#'><font color="FF0000">#FORM.SERVICE_HEAD#</font></a>
		<cfelse>
		  <a href ='#partner_domain##request.self#?fuseaction=service.list_service&event=upd&service_id=#GET_SERVICE1.service_id#'><font color="FF0000">#FORM.SERVICE_HEAD#</font></a>
		</cfif>
	</td>
  </tr>
  <tr>
	<td><cf_get_lang_main no='89.Başlama'></td>
	<td>
	  <cfif len(attributes.START_DATE1)>
	    <cfoutput>#dateformat(date_add("h",session.ep.TIME_ZONE,attributes.START_DATE1),dateformat_style)#&nbsp;#TIMEFORMAT(date_add("h",session.ep.TIME_ZONE,attributes.START_DATE1),timeformat_style)#</cfoutput>
	  </cfif>
	</td>
  </tr>
  <tr>
	<td><cf_get_lang_main no='90.Bitiş'></td>
	<td>
	  <cfif isdefined("attributes.FINISH_DATE1") and len(attributes.FINISH_DATE1)>
		<cfoutput>#dateformat(date_add("h",session.ep.TIME_ZONE,attributes.FINISH_DATE1),dateformat_style)#&nbsp;#TIMEFORMAT(date_add("h",session.ep.TIME_ZONE,attributes.FINISH_DATE1),timeformat_style)#</cfoutput>
	  </cfif>
	</td>
  </tr>
</table>
<br/>
<table width="100%">
  <tr>
	<td>&nbsp;</td>
  </tr>
</table>
</cfoutput>
<cfinclude template="../../objects/display/view_company_info.cfm">
<font class="css2">
	<cf_get_lang no='175.Bu mesaj'> <!--- <cfoutput>#check.company_name#</cfoutput> --->
	<cfoutput>#SESSION.EP.COMPANY#</cfoutput> <cf_get_lang no='176.sistemi tarafından otomatik olarak gönderilmiştir'><br/>
	<cf_get_lang no='177.Eğer bir sorun olduğunu düşünüyorsanız lütfen maili siliniz'>...<br/>
</font>
