<cfif isDefined("attributes.email") and (attributes.email eq "true")>
	<cfquery name="GET_MAILFROM" datasource="#DSN#">
		SELECT
			COMPANY_PARTNER_EMAIL
		FROM		
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
	</cfquery>
	<cfset sender = "#get_mailfrom.company_partner_email#">
</cfif>

<cfquery name="ADD_OFFER_PLUS" datasource="#DSN3#">
	INSERT INTO
		OFFER_PLUS
		(
			SUBJECT,
			OFFER_ID,
			PLUS_CONTENT,
			PLUS_DATE,
			PARTNER_ID,
			RECORD_DATE,
			RECORD_PAR,
			OFFER_ZONE,
			RECORD_IP,
			MAIL_SENDER
		)
		VALUES
		(
			'#attributes.opp_head#',
			#attributes.offer_id#,
			'#plus_content#',
			#now()#,
			#session.pp.userid#,
			#now()#,
			#session.pp.userid#,
			0,
			'#cgi.remote_addr#',
			<cfif isDefined("attributes.email") and (attributes.email eq "true")>'#sender#'<cfelse>''</cfif>
		)
</cfquery>
<cfif isDefined("attributes.email") and (attributes.email eq "true")>
	<cftry>
	  	<cfmail  
		  	to = "#attributes.employee#"
		  	from = "#sender#"
		  	subject = "#attributes.opp_head#" type="HTML">
			<style type="text/css">
				.color-header{background-color: ##a7caed;}
				.color-border	{background-color:##6699cc;}
				.color-row{	background-color: ##f1f0ff;}
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			</style>		  
			#attributes.plus_content#
	  	</cfmail>
	  
	  	<cfsavecontent variable="css">
			<style type="text/css">
                .color-header{background-color: ##a7caed;}
                .color-border	{background-color:##6699cc;}
                .color-row{	background-color: ##f1f0ff;}
                .label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
            </style>
	  	</cfsavecontent>
		<cfset attributes.from = sender>	  
        <cfset attributes.body="#css##attributes.plus_content#">
        <cfset attributes.to_list="#attributes.employee#">
        <cfset attributes.type=0>
        <cfset attributes.module="sales">
        <cfset attributes.subject="#attributes.opp_head#">
        <cfinclude template="../../objects/query/add_mail.cfm">

		<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
		</style>	  	  	   
		<table height="100%" width="100%" cellspacing="0" cellpadding="0">
			<tr class="color-border">
				<td valign="top"> 
					<table height="100%" width="100%" cellspacing="1" cellpadding="2">
						<tr class="color-row">
							<td align="center" class="headbold"><cf_get_lang_main no='101.Mail Basariyla Gnderildi'></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	<cfcatch type="any">
	<style type="text/css">
		.color-header{background-color: ##a7caed;}
		.color-border	{background-color:##6699cc;}
		.color-row{	background-color: ##f1f0ff;}
		.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
	</style>	
	<table height="100%" width="100%" cellspacing="0" cellpadding="0">
		<tr class="color-border">
			<td valign="top"> 
				<table height="100%" width="100%" cellspacing="1" cellpadding="2">
					<tr class="color-row">
						<td align="center" class="headbold">
							Yazismaniz Kaydedildi Fakat Mail Gndermede Bir Hata Oldu Ltfen Verileri Kontrol Edip Sonra Tekrar Deneyiniz
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</cfcatch>
	</cftry>
	<script type="text/javascript">
		wrk_opener_reload();
		function waitfor(){
		  window.close();
		}
		setTimeout("waitfor()",5000); 		
	</script>
	<cfabort>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
