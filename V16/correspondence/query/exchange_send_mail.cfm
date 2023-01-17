<cfsetting showdebugoutput="no">
<cfparam name="FORM.folder" default="Gelen Kutusu">
<cfparam name="FORM.islem" default="">
<cfparam name="FORM.msgFrom" default="">
<cfparam name="FORM.msgTo" default="">
<cfparam name="FORM.msgCc" default="">
<cfparam name="FORM.msgBcc" default="">
<cfparam name="FORM.msgSubject" default="">
<cfparam name="FORM.uploads_name" default="">

<cftry>
	<cfmail from="#FORM.msgFrom#" 
			to="#FORM.msgTo#" 
			cc="#FORM.msgCc#" 
			bcc="#FORM.msgBcc#" 
			subject="#FORM.msgSubject#" 
			failto="#session.mailbox_username#" 
			type="html" 
			username = "#session.mailbox_username#" password="#session.mailbox_password#" server="#session.mailbox_server#"  spoolEnable="yes" charset="utf-8" remove="yes" replyto="#FORM.msgFrom#">
		#FORM.message#
		<cfloop list="#FORM.uploads_name#" index="ind">
			<cfif FileExists('#ExpandPath( "./" )#documents/temp/#session.mailbox_username_folder#/#ind#')>
				<cfmailparam file="#ExpandPath( "./" )#documents/temp/#session.mailbox_username_folder#/#ind#" remove="true"/>
			</cfif>
		</cfloop>
	</cfmail>
	Mailiniz başarıyla gönderilmiştir.
<cfcatch>
	Mailiniz iletilememiştir.
</cfcatch>
</cftry>

