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
			Sayın #task_user_name# #task_user_surname#,<br/>
			#session.ep.name# #session.ep.surname# tarafından adınıza  bir servis görevi  yapıldı.
			<br/><br/><br/>
			<b>İlgili İş Linki</b>
			<cfif len(form.task_position_code)>
				<a href ='#user_domain##request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#'><font color="FF0000"><cfif len(form.service_head)>#form.service_head#<cfelse>Konu Yok</cfif></font></a>
			<cfelse>
				<a href ='#partner_domain##request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#'><font color="FF0000"><cfif len(form.service_head)>#form.service_head#<cfelse>Konu Yok</cfif></font></a>
			</cfif>
		</td>
	</tr>
  	<tr>
  		<td><cf_get_lang_main no='1055.Başlama'></td>
		<td><cfif isdefined("attributes.start_date1") and len(attributes.start_date1)>
				#dateformat(date_add("h",session.ep.time_zone,attributes.start_date1),dateformat_style)#&nbsp;#timeformat(date_add("h",session.ep.time_zone,attributes.start_date1),timeformat_style)#
			<cfelseif isdefined("attributes.apply_date") and len(attributes.apply_date)>
				#dateformat(date_add("h",session.ep.time_zone,attributes.apply_date),dateformat_style)#&nbsp;#timeformat(date_add("h",session.ep.time_zone,attributes.apply_date),timeformat_style)#
			</cfif>
  		</td>
	</tr>
  	<tr>
  		<td><cf_get_lang_main no='90.Bitiş'></td>
		<td><cfif isdefined("attributes.finish_date1") and len(attributes.finish_date1)>
				#dateformat(date_add("h",session.ep.time_zone,attributes.finish_date1),dateformat_style)#&nbsp;#timeformat(date_add("h",session.ep.time_zone,attributes.finish_date1),timeformat_style)#
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
<table width="100%">
	<tr align="left">
		<td><cfinclude template="../../objects/display/view_company_info.cfm">&nbsp;</td>
	</tr>
	<tr height="50" valign="bottom">
		<td><font class="css2">
				<cf_get_lang no='100.Bu mesaj'>
				<cfoutput>#session.ep.company#</cfoutput>
				<cf_get_lang_main no='664.sistemi tarafından otomatik olarak gönderilmiştir'>.<br/>
				<cf_get_lang_main no='665.Eğer bir sorun olduğunu düşünüyorsanız lütfen maili siliniz'>...<br/>
			</font>		
		</td>
	</tr>
</table>
