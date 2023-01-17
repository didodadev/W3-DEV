<cfif isdefined("form.plus_content") and len(form.plus_content)>
	<cfset attributes.plus_content_ = attributes.plus_content>
<cfelse>
	<cfset attributes.plus_content_ = "">
</cfif>
<cfif len(form.plus_date)><cf_date tarih="form.plus_date"></cfif>
<script>
	<cfif isdefined("attributes.is_worktips")>
		var formObject = {}
		var el_content = "<cfoutput>#attributes.plus_content_#</cfoutput>";
		var obj = {"active": true, options : {"left":"", "top":"", "el_id":"", "el_content":el_content, "el_node":"DIV"}};
		formObject.help_topic = JSON.stringify(obj);
		formObject.help_head =  "<cfoutput>#form.header#</cfoutput>";
		formObject.help_fuseaction =  "<cfif isdefined("attributes.url") and len(attributes.url)><cfoutput>#attributes.url#</cfoutput><cfelse>call.list_service</cfif>";
		formObject.recorder_name =  "<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>";
		formObject.recorder_email =  "<cfoutput>#session.ep.username#</cfoutput>";
		formObject.recorder_domain =  "<cfoutput>#HTTP_REFERER#</cfoutput>";
		$.ajax({
			url :'/wex.cfm/tour/insert',
			method: 'post',
			contentType: 'application/json; charset=utf-8',
			dataType: "json",
			data : JSON.stringify(formObject),
			error :  function(response){
				if(trim(response.responseText) === "Ok"){
					alert("<cf_get_lang dictionary_id='61777.Yardım notu eklendi.'>");
				}
				else{
					alert("<cf_get_lang dictionary_id='52126.An error occurred'>!");
				}
			}
		});
	</cfif>
</script>
<cfquery name="ADD_ORDER_PLUS" datasource="#DSN#">
	INSERT INTO 
		G_SERVICE_PLUS 
	(
		SUBJECT,
		SERVICE_ID,
		PLUS_DATE,
		COMMETHOD_ID,
		PLUS_CONTENT,
		SERVICE_ZONE,
		<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
			PARTNER_ID,
			CONSUMER_ID,
		<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			CONSUMER_ID,
			PARTNER_ID,
		<cfelse>
			CONSUMER_ID,
			PARTNER_ID,	
		</cfif>
		MAIL_SENDER,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
        IS_MAIL
	)
	VALUES 
	(
		'#form.header#',
		#form.service_id#,
		<cfif len(attributes.plus_date)>
			#form.plus_date#,
		<cfelse>
			NULL,
		</cfif>
		<cfif form.commethod_id is "0">
			17,
		<cfelse>
			#form.commethod_id#,
		</cfif>
		'#attributes.plus_content_#',
		0,
		<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
			#attributes.partner_id#,
			NULL,
		<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			#attributes.consumer_id#,
			NULL,
		<cfelse>
			NULL,
			NULL,
		</cfif>
		<cfif isdefined("attributes.partner_names") and len(attributes.partner_names)>					
			'#attributes.partner_names#',
		<cfelse>
			'',
		</cfif>	
		#now()#,
		<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>-1</cfif>,
		'#cgi.remote_addr#'	,
        <cfif isDefined('attributes.email') and attributes.email eq 'true'>1<cfelse>0</cfif>	
	)
</cfquery>

<cfif x_subs_team_mail_takip eq 1 and isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfquery name="get_subscription_team" datasource="#dsn#">
		SELECT 
			EMPLOYEE_NAME +' '+ EMPLOYEE_SURNAME AS NAME, 
			EMPLOYEE_EMAIL,
			SUBSCRIPTION_STAGE,
			STAGE
		FROM WORK_GROUP 
		LEFT JOIN #dsn3#.SUBSCRIPTION_CONTRACT ON WORK_GROUP.ACTION_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_ID
		LEFT JOIN PROCESS_TYPE_ROWS ON PROCESS_TYPE_ROWS.PROCESS_ROW_ID = SUBSCRIPTION_CONTRACT.SUBSCRIPTION_STAGE
		LEFT JOIN WORKGROUP_EMP_PAR ON WORK_GROUP.WORKGROUP_ID = WORKGROUP_EMP_PAR.WORKGROUP_ID 
		LEFT JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID= WORKGROUP_EMP_PAR.EMPLOYEE_ID
		WHERE 
			ACTION_FIELD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="subscription"> 
			AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	</cfquery>	
	<cfquery name="GET_SERVICE" datasource="#DSN#">
		SELECT SERVICE_NO, SERVICE_HEAD, SERVICE_DETAIL FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
	<cfif isdefined("get_service.service_detail") and len(get_service.service_detail)>
		<cfset service_detail_ = replace(get_service.service_detail,'<p>','','all')>
		<cfset service_detail_ = replace(service_detail_,'</p>','','all')>
	<cfelse>
		<cfset service_detail_ = "">
	</cfif>
	<cfset target_domain = employee_url>
	<cftry>
		<cfset sender='#session.ep.company#<#session.ep.company_email#>'>
		<cfoutput query="get_subscription_team">	
			<cfif len(employee_email)>
				<cfmail from="#sender#" to="#employee_email#" subject="Takip Kayıt Bilgilendirme - #GET_SERVICE.service_no#" type="html" charset="utf-8">	
					<table width="50%" border="0">
						<tr class="color-header">
							<td colspan="2"><b><cf_get_lang dictionary_id='58780.Sayın'></b> #name#,</td>
						</tr>
						<tr>
							<td colspan="2"><b><cf_get_lang dictionary_id='38254.You have a new notification'></b></td>
						</tr>
						<tr class="color-header">
							<td colspan="2"><cf_get_lang no='97.Başvuru No'> : #get_service.service_no#</td>
						</tr>
						<tr>
							<td class="color-row" colspan="2"><b><cf_get_lang no='125.Basvuru Bilgileri'></b></td>
						</tr>
						<tr>
							<td><b><cf_get_lang_main no='68.Konu'> :</b></td>
							<td>#get_service.service_head#</td>
						</tr>
						<tr>
							<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.Açıklama'> :</b></td>
							<td>#service_detail_#</td>
						</tr>
						<tr height="20">
							<td></td>
						</tr>
						<tr>
							<td><b><cf_get_lang dictionary_id='40124.Abone Durumu'> :</b></td>
							<td>#stage#</td>
						</tr>
						<tr>
							<td class="headbold" colspan="2"><b><cf_get_lang no='126.Takip Bilgileri'></b></td>
						</tr>
						<tr>
							<td><b><cf_get_lang_main no='68.Konu'> :</b></td>
							<td>#attributes.header#</td>
						</tr>
						<tr>
							<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.Açıklama'> :</b></td>
							<td>#attributes.plus_content_#</td>
						</tr>
						<tr>
							<td colspan="2"><a href="#target_domain#/#request.self#?fuseaction=call.list_service&event=upd&service_id=#attributes.service_id#"><cf_get_lang no='30.Detaylı Bilgi İçin Tıklayınız'></a></td>
						</tr>
						<tr>
							<td colspan="2"><b><cf_get_lang dictionary_id='41084.İyi çalışmalar'></b></td>
						</tr>
					</table>	
				</cfmail>
			</cfif>	
		</cfoutput>
		<script type="text/javascript">
		 	alert("<cf_get_lang_main no='101.Mail Başarıyla Gönderildi'>");
		</script>
		<cfcatch>	
			<script type="text/javascript">
				alert("Mail gönderilemedi!");
		   </script>	
		</cfcatch>
	</cftry>
</cfif>
<cfif isDefined('attributes.email') and attributes.email eq 'true'>
	<cfset sender='#session.ep.company#<#session.ep.company_email#>'>
	<cfquery name="GET_SERVICE" datasource="#DSN#">
		SELECT SERVICE_NO, SERVICE_HEAD, SERVICE_DETAIL FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>
	<cfif isdefined("get_service.service_detail") and len(get_service.service_detail)>
		<cfset service_detail_ = replace(get_service.service_detail,'<p>','','all')>
		<cfset service_detail_ = replace(service_detail_,'</p>','','all')>
	<cfelse>
		<cfset service_detail_ = "">
	</cfif>
		<cfset target_domain = employee_url>
    	<cfset domain_control = 0>
	<cftry>
		<cfmail from="#sender#" to="#attributes.partner_names#" subject="#attributes.header#" type="html">
			<style type="text/css">
				.color-header{background-color: ##a7caed; color:##FFFFFF;}
				.color-border	{background-color:##6699cc;}
				.color-row{font-weight:bold;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
			<table width="50%" border="0">
				<tr class="color-header">
					<td colspan="2"><cf_get_lang no='97.Başvuru No'> : <cfoutput>#get_service.service_no#</cfoutput></td>
				</tr>
				<tr>
					<td class="color-row" colspan="2"><b><cf_get_lang no='125.Basvuru Bilgileri'></b></td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='68.Konu'> :</b></td>
					<td><cfoutput>#get_service.service_head#</cfoutput></td>
				</tr>
				<tr>
					<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.Açıklama'> :</b></td>
					<td><cfoutput>#service_detail_#</cfoutput></td>
				</tr>
				<tr height="20">
					<td></td>
				</tr>
				<tr>
					<td class="headbold" colspan="2"><b><cf_get_lang no='126.Takip Bilgileri'></b></td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='68.Konu'> :</b></td>
					<td><cfoutput>#attributes.header#</cfoutput></td>
				</tr>
				<tr>
					<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.Açıklama'> :</b></td>
					<td><cfoutput>#attributes.plus_content_#</cfoutput></td>
				</tr>
                <cfif domain_control neq 1>
                    <tr>
                        <td colspan="2"><a href="<cfoutput>#target_domain#/#request.self#</cfoutput>?fuseaction=call.list_service&event=upd&service_id=<cfoutput>#attributes.service_id#</cfoutput>"><cf_get_lang no='30.Detaylı Bilgi İçin Tıklayınız'></a></td>
                    </tr>
                </cfif>
			</table>			
			<br/><br/>
		</cfmail>
	   
		<cfsavecontent variable="css">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>
		</cfsavecontent>	
      <!---  <cfset attributes.from = sender>  
		<cfset attributes.body="#css##attributes.plus_content_#">
		<cfset attributes.to_list="#attributes.partner_names#">
		<cfset attributes.type=0>
		<cfset attributes.module="service">
		<cfset attributes.subject="#attributes.header#">
		 BK Kapatti 20131205 <cfinclude template="../../objects/query/add_mail.cfm">--->
		<script type="text/javascript">
		 	alert("<cf_get_lang_main no='101.Mail Başarıyla Gönderildi'>");
				window.close();
		</script>
		<cfcatch>	
			<script type="text/javascript">
				alert("Servis Takip Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz");
				window.close();
		   </script>	
		</cfcatch>
	</cftry>
	<cfabort>	
</cfif>
<script type="text/javascript">
	window.close();
</script>