<!--- SG 20131128 çalışan memnuniyeti anketi mail gönderme--->
<cfloop from="1" to="#attributes.record_num#" index="i">
	<cflock name="#createUUID()#" timeout="60">		
		<cftransaction>
			<cfif isdefined('attributes.control_#i#') and len(evaluate('attributes.email_#i#'))>
				<cftry>
					<cfmail
						to="#evaluate('attributes.email_#i#')#"
						from="#session.ep.company#<#session.ep.company_email#>"
						subject="Memnuniyet Anketi" 
						type="HTML">
					<style type="text/css">
						.label {font-size:11px;font-family:Geneva, tahoma, arial, Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
						.css1 {font-size:12px;font-family:arial,verdana;color:000000; background-color:white;}
						.css2 {font-size:9px;font-family:arial,verdana;color:999999; background-color:white;}
					</style>
					<table class="css1">
						<tr>
							<td>Değerli Çalışanımız,</td>
						</tr>
						<tr>
							<td>Mars Entertainment Group olarak, tüm çalışanlarımızın memnuniyetini sağlamak ve bu doğrultuda gerekli aksiyonları alabilmek adına 
							<b>"Çalışan Memnuniyet Anketi"</b> gerçekleştirmekteyiz.
							</td>
						</tr>
						<tr>
							<td>Bu nedenle görüş ve önerilerinizi almak üzere, anketimizi #attributes.survey_finish_date# tarihine kadar cevaplandırmanız gerekmektedir.</td>
						</tr>
						<tr>
							<td>
								<li>Anketimizdeki tüm soruların cevaplanması gerekmektedir.</li>
								<li>Tüm sorular cevaplandıktan sonra “Kaydet” butonuna basarak anket tamamlanır.</li>
								<li>Bir kez “Kaydet” e bastıktan sonra anket üzerinde herhangi bir değişiklik yapılamaz.</li>
							</td>
						</tr>
						<tr>
							<td>Ankete aşağıdaki link üzerinden ulaşabilirsiniz;</td>
						</tr>
						<tr>
							<td>						
								<b>
								<cfset cont_key = 'wrk'>
								<cfset control_value_ = Encrypt(evaluate('attributes.email_#i#'),cont_key,"CFMX_COMPAT","Hex")>
								<a href="http://#listfirst(server_url,';')#/#request.self#?fuseaction=objects.popup_form_add_detailed_survey_main_result&survey_id=#attributes.survey_main_id#&action_type=14&control_value=#control_value_#&is_popup=1&is_portal=1" target="_blank">
								"Çalışan Memnuniyet Anketi"</a></b>
							</td>
						</tr>
						<tr style="height:20px;">
							<td>Teşekkür Ederiz</td>
						</tr>
						<tr>
							<td>İnsan Kaynakları</td>
						</tr>
					</table>
					</cfmail>
					<cfset cont_key = 'wrk'>
					<cfset employee_id_ = Encrypt(evaluate('attributes.employee_id_#i#'),cont_key,"CFMX_COMPAT","Hex")>
					<cfset employee_email_ = Encrypt(evaluate('attributes.email_#i#'),cont_key,"CFMX_COMPAT","Hex")>
					<cfquery name="add_survey_control" datasource="#dsn#">
						INSERT INTO
							SURVEY_MAIN_RESULT_CONTROL
							(
								SURVEY_MAIN_ID,
								EMPLOYEE_ID,
								EMPLOYEE_EMAIL,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
							)
						VALUES
							(	
								#attributes.survey_main_id#,
								'#employee_id_#',
								'#employee_email_#',
								#now()#,
								#session.ep.userid#,
								'#cgi.REMOTE_ADDR#'
							)
					</cfquery>
					<cfcatch type="any">
						
					</cfcatch>
				</cftry>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
<script type="text/javascript">
	alert("Gönderim Tamamlandı!");
	window.location.href='<cfoutput>#request.self#?fuseaction=report.detail_report&event=det&report_id=#attributes.report_id#</cfoutput>';
</script>
