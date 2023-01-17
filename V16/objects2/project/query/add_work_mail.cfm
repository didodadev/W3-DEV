<style type="text/css">
	.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
	.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
</style>
<!---<cfinclude template="../../objects/display/view_company_logo.cfm">--->
<br/>
<cfoutput>
<font class="css1">
	<cf_get_lang_main no='1368.Sayın'> #task_user_name# #task_user_surname#,,<br/>
		#session.pp.name# #session.pp.surname# <cf_get_lang no='1581.tarafından sizin adınıza yeni bir görevlendirme yapıldı'>.<br/>
	<cf_get_lang no='1582.Görev Başlığı'>:
	<cfif listfindnocase(partner_url,'#cgi.http_host#',';')>
		<a href ='#cgi.http_host#/#request.self#?fuseaction=objects2.updwork&id=#attributes.project_id#&work_id=#encrypt(attributes.work_id,"WORKCUBE","BLOWFISH","Hex")#'><font color="FF0000">#form.work_head#</font></a>
	<cfelse>
		<a href ='#employee_domain##request.self#?fuseaction=project.updwork&id=#attributes.work_id#'><font color="FF0000">#form.work_head#</font></a>
	</cfif>
	<br/>
	<cf_get_lang no='1579.Ayrıntı için lütfen görev başlığına tıklayın'>.
</font>
<br/>
<!---<cfinclude template="../../objects/display/view_company_info.cfm">--->
<hr>
<font class="css2">
	<cf_get_lang_main no='663.Bu mesaj'> <!---#check.company_name#---><cfoutput>#session.pp.company#</cfoutput> <cf_get_lang_main no='664.sistemi tarafından otomatik olarak gönderilmiştir'>.<br/>
	<cf_get_lang no='1580.Eğer bir sorun olduğunu düşünüyorsanız lütfen maili reply ediniz'>...<br/>
</font>	
</cfoutput>
