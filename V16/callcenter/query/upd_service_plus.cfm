<cfif len(form.plus_date)><cf_date tarih="attributes.plus_date"></cfif>
<cfquery name="UPD_SERVICE_PLUS" datasource="#dsn#">
	UPDATE 
		G_SERVICE_PLUS 
	SET 
	<cfif isdefined("header")>
		SUBJECT = '#header#',
	</cfif>
	<cfif len(form.plus_date)>
		PLUS_DATE = #attributes.plus_date#,
	<cfelse>
		PLUS_DATE = NULL,
	</cfif>
		COMMETHOD_ID = <cfif FORM.COMMETHOD_ID IS "0">17<cfelse>#FORM.COMMETHOD_ID#</cfif>,	
		<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>
			PARTNER_ID = #attributes.partner_id#,
			CONSUMER_ID = NULL,
		<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
			CONSUMER_ID = #attributes.consumer_id#,
			PARTNER_ID = NULL,
		<cfelse>
			CONSUMER_ID = NULL,
			PARTNER_ID = NULL,	
		</cfif>
		PLUS_CONTENT = '#FORM.PLUS_CONTENT#',
		UPDATE_DATE = #NOW()#,
		UPDATE_EMP = #SESSION.EP.USERID#,
		UPDATE_IP = '#REMOTE_ADDR#',
		MAIL_SENDER = '#attributes.partner_names#',
        IS_MAIL = <cfif isDefined('attributes.email') and attributes.email eq 'true'>1<cfelse>0</cfif>	
	WHERE 
		SERVICE_PLUS_ID = #FORM.SERVICE_PLUS_ID#					  	
</cfquery>

<cfif isdefined('attributes.email') and attributes.email eq 'true'>
	<cfquery name="GET_SERVICE" datasource="#DSN#">
		SELECT
			SERVICE_NO,
			SERVICE_HEAD,
			SERVICE_DETAIL
		FROM
			G_SERVICE
		WHERE
			SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.service_id#">
	</cfquery>

	<cfset target_domain = employee_url>
    <cfset domain_control = 0>
	
	<cftry>
		<cfmail from="#session.ep.company#<#session.ep.company_email#>" to="#attributes.partner_names#" subject="#attributes.header#" type="HTML">
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
					<td><cfoutput>#htmlcodeformat(get_service.service_detail)#</cfoutput></td>
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
					<td><cfoutput>#attributes.plus_content#</cfoutput></td>
				</tr>
				<tr>
					<td colspan="2"><a href="<cfoutput>#target_domain#/#request.self#</cfoutput>?fuseaction=call.list_service&event=upd&service_id=<cfoutput>#attributes.service_id#</cfoutput>"><cf_get_lang no='30.Detaylı Bilgi İçin Tıklayınız'></a></td>
				</tr>
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
       <!--- <cfset attributes.from = "#session.ep.company#<#session.ep.company_email#>">	  
		<cfset attributes.body="#css##attributes.plus_content#">
		<cfset attributes.to_list="#attributes.partner_names#">
		<cfset attributes.type=0>
		<cfset attributes.module="service">
		<cfset attributes.subject="#attributes.header#">
		 BK Kapatti 20131205 <cfinclude template="../../objects/query/add_mail.cfm">--->

		<script type="text/javascript">
			alert("<cf_get_lang_main no='101.Mail Başarıyla Gönderildi'>");
		   location.href = document.referrer;
	    </script>
		<cfcatch>	
			<script type="text/javascript">
				alert("Servis Takip Kaydedildi Fakat Mail Göndermede Bir Hata Oldu! Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz.");
			   location.href = document.referrer;
		   </script>	
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		location.href = document.referrer;	
	</script>
	<cfabort>	
</cfif>

<script type="text/javascript">
	location.href = document.referrer;
</script>
