<cfif len(form.plus_date)><cf_date tarih="form.plus_date"></cfif>
<cfquery name="ADD_ORGANIZATION_PLUS" datasource="#DSN#">
	INSERT INTO 
		ORGANIZATION_PLUS 
	(
		SUBJECT,
		ORGANIZATION_ID,
		PLUS_DATE,
		COMMETHOD_ID,
		PLUS_CONTENT,
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
		#form.organization_id#,
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
		'#form.plus_content#',
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

<cfif isDefined('attributes.email') and attributes.email eq 'true'>
	<cfset sender='#session.ep.company#<#session.ep.company_email#>'>
	<cfquery name="GET_ORGANIZATION" datasource="#DSN#">
		SELECT ORGANIZATION_HEAD, ORGANIZATION_DETAIL FROM ORGANIZATION WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.organization_id#">
	</cfquery>
	
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
				<tr>
					<td class="color-row" colspan="2"><b>Etkinlik Bilgileri</b></td>
				</tr>
				<tr>
					<td><b><cf_get_lang_main no='68.Konu'> :</b></td>
					<td><cfoutput>#get_organization.organization_head#</cfoutput></td>
				</tr>
				<tr>
					<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.A????klama'> :</b></td>
					<td><cfoutput>#htmlcodeformat(get_organization.organization_detail)#</cfoutput></td>
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
					<td nowrap="nowrap" valign="top"><b><cf_get_lang_main no='217.A????klama'> :</b></td>
					<td><cfoutput>#attributes.plus_content#</cfoutput></td>
				</tr>
                <cfif domain_control neq 1>
                    <tr>
                        <td colspan="2"><a href="<cfoutput>#target_domain#/#request.self#</cfoutput>?fuseaction=campaign.list_organization&event=upd&org_id=<cfoutput>#attributes.organization_id#</cfoutput>"><cf_get_lang no='30.Detayl?? Bilgi ????in T??klay??n??z'></a></td>
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

		 <cf_popup_box title="Takip">
			<table width="100%">
				<tr height="300">
					<td class="formbold" style="text-align:center"><cf_get_lang_main no='101.Mail Ba??ar??yla G??nderildi'></td>
				</tr>
			</table>
		</cf_popup_box>
	
		<cfcatch>		
			<cf_popup_box title="Takip">
				<table width="100%">
					<tr height="300">
						<td class="formbold" style="text-align:center">Etkile??im Takip Kaydedildi Fakat Mail G??ndermede Bir Hata Oldu L??tfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz</td>
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
