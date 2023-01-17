<!---
*************************************************************************
	Description : Hata Oluştuğunda Ekranda Gösterilip Mail Atılıyor.
	Düzenleme ve Aktif Etme : YO 26122018
*************************************************************************
--->
<cfparam name="attributes.error_mail" default="1">
<cfparam name="attributes.error_mail_info" default="">
<cfparam  name="workcube_mode" default="1">
<cfif isdefined("hata") and not isDefined("errorCode")>
	<cfset errorCode = 1531>
	<cfif hata eq 5>
		<cfset errorCode = 127>
	<cfelseif hata eq 6>
		<cfset errorCode = 263>
	</cfif>
</cfif>
<cfif isDefined("hata_mesaj")>
	<cfset errorMessage = hata_mesaj>
</cfif>

	<link href="/css/assets/template/catalyst/catalyst.css" rel="stylesheet" type="text/css" />
	<link href="/css/assets/template/error.css" rel="stylesheet" type="text/css" />
	<div class = "col col-12">
        <div class="boxRow uniqueBox" id="unique_error">
            <div id="box_error_manager" class="portBox portBottom" style="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08)">
                <div id="header_error" class="portHeadLight">
                    <div class="portHeadLightTitle">
                        <span id="handle_error">
                            <a href="javascript://">Oops :(</a>
                        </span> 
                    </div>
                </div>
        <cfsavecontent variable="attributes.error_mail_info">
			<div class="portBoxBodyStandart">
				<div class = "col col-12 scrollContent" style="max-height:600px;">
					<h2>Contact the system administrator.</h2>
					<cfif isdefined("errorMessage")><p><cfoutput>#errorMessage#</cfoutput></p></cfif>
					<cfif (workcube_mode eq 0 or (isdefined("session.ep.admin") and session.ep.admin eq 1)) and isDefined("Exception")>
						<p><a href="javascript://" onclick="document.getElementById('error_detail').style.display='block';" class="error_detail">Detail</a></p>
						<cfdump var="#Exception#">
					</cfif>
				</div>
			</div>
		</cfsavecontent>
		<cfoutput>
		<div class="portBoxBodyStandart">
			<div class = "col col-12 scrollContent" style="max-height:600px;">
				<cfif isDefined("session.ep.USERID")>
					<h2>Contact the system administrator.</h2>
					<cfif isdefined("errorMessage")><p><cfoutput>#errorMessage#</cfoutput></p></cfif>
					<cfif isDefined("session.ep") and (workcube_mode eq 0 or (isdefined("session.ep.admin") and session.ep.admin eq 1)) and isDefined("Exception")>
						<p><a href="javascript://" onclick="document.getElementById('error_detail').style.display='block';" class="error_detail">Detail</a></p>
						<cfdump var="#Exception#">
					</cfif>
				<cfelse>
					<h3>The system is temporarily unavailable! The system administrator has been informed. Thank you for your time and consideration.</h3>
				</cfif>
			</div>
		</div>
		</cfoutput>

<cfif attributes.error_mail eq 1 and isdefined("server_detail")>
	<cfparam name='attributes.admin_mail' default='#listfirst(server_detail)#'>
	<cfparam name='attributes.workcube_server' default='#listlast(server_detail)#'>
	<cfquery name="GET_ADMIN" datasource="#DSN#">
		SELECT ADMIN_MAIL FROM OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL
	</cfquery>
	
	<cfif (not isDefined('hata')) and isdefined("attributes.fuseaction") and listlen(attributes.fuseaction,'.')>
		<cfset attributes.subject = "#cgi.server_name# #listgetat(attributes.fuseaction,1,'.')# Hata Bildirim Mesajı ">
		<cfif isDefined('error.type')>
            <cflog type="error"
			  file="workcube_errors"
			  text="Type: #error.type# - Description: #error.diagnostics#">
		</cfif>
	<cfelseif isDefined('hata') and listlen(attributes.fuseaction,'.')>
		<cfset attributes.subject = "#cgi.server_name# #listgetat(attributes.fuseaction,1,'.')# Message: #hata#">
	<cfelse>
		<cfset attributes.subject = "#cgi.server_name# Message: Fuseaction not found!">
	</cfif>
	
	<cfset mailto="#get_admin.admin_mail#">
	<cfset attributes.mailfrom="#attributes.workcube_server#<#attributes.admin_mail#>">
	<cftry>
		<cfmail to="#mailto#" from="#attributes.mailFrom#" subject="#attributes.subject#" type="HTML">
			<cfinclude template="error_mail.cfm">
		</cfmail>
		<cfcatch type="any">No Mail Server!</cfcatch>
	</cftry>
</cfif>