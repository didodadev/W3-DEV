<cfif len(form.plus_date)><cf_date tarih="attributes.plus_date"></cfif>
<cfquery name="UPD_ORGANIZATION_PLUS" datasource="#dsn#">
	UPDATE 
		ORGANIZATION_PLUS 
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
		ORGANIZATION_PLUS_ID = #FORM.ORGANIZATION_PLUS_ID#					  	
</cfquery>

<cfif isdefined('attributes.email') and attributes.email eq 'true'>
	<cfquery name="GET_ORGANIZATION" datasource="#DSN#">
		SELECT
			ORGANIZATION_HEAD,
			ORGANIZATION_DETAIL
		FROM
			ORGANIZATION
		WHERE
			ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_id#">
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
				<tr>
					<td class="color-row" colspan="2"><b>Organizasyon Bilgileri</b></td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='68.Konu'> :</b></td>
					<td><cfoutput>#GET_ORGANIZATION.service_head#</cfoutput></td>
				</tr>
				<tr>
					<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.Açıklama'> :</b></td>
					<td><cfoutput>#htmlcodeformat(GET_ORGANIZATION.service_detail)#</cfoutput></td>
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
					<td colspan="2"><a href="<cfoutput>#target_domain#/#request.self#</cfoutput>?fuseaction=campaign.list_organization&event=upd&org_id=<cfoutput>#attributes.organization_id#</cfoutput>"><cf_get_lang no='30.Detaylı Bilgi İçin Tıklayınız'></a></td>
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

		 <cf_popup_box title="#getLang('call',119)#">
			<table width="100%">
				<tr height="300">
					<td class="formbold" style="text-align:center"><cf_get_lang_main no='101.Mail Başarıyla Gönderildi'></td>
				</tr>
			</table>
		</cf_popup_box>
	
		<cfcatch>		
			<cf_popup_box title="#getLang('call',119)#">
				<table width="100%">
					<tr height="300">
						<td class="formbold" style="text-align:center">Organizasyon Takip Kaydedildi Fakat Mail Göndermede Bir Hata Oldu Lütfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz</td>
					</tr>
				</table>
			</cf_popup_box>
		</cfcatch>
	</cftry>
	<script type="text/javascript">
		<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
			location.href =document.referrer;
		<cfelseif not isDefined('attributes.draggable') or attributes.draggable eq 0>
			wrk_opener_reload();
			function waitfor(){
			window.close();
			}
			setTimeout("waitfor()",5000); 	
		</cfif>
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
	<cfif isDefined('attributes.draggable') and attributes.draggable eq 1>
		location.href =document.referrer;
	<cfelseif not isDefined('attributes.draggable') or attributes.draggable eq 0>
		wrk_opener_reload();
		window.close();
	</cfif>
</script>
