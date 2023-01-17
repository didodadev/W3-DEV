<cfsetting showdebugoutput="no">
<cfquery name="MAIL_SETTINGS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CUBE_MAIL
	WHERE 
		EMPLOYEE_ID = #session.ep.USERID# AND
		ISACTIVE = 1
	ORDER BY
		PRIORITY ASC
</cfquery>
<cfloop query="MAIL_SETTINGS">
<cfif len(POP_PORT)>
	<cfset this_port_ = POP_PORT>
<cfelse>
	<cfset this_port_ = 110>
</cfif>
<cfif MAIL_SETTINGS.present_isactive eq 1>
	<cfset this_present_isactive = 1>
</cfif>
<cfset ind = 1>
<cfset Message_Number = 0>
<cfset pop3 = POP>
<cfset account = ACCOUNT>
<cfset lastrow = 5>
<cfset mylist="">
<cfset sayac = 0>
<cfset password_ = Decrypt(PASSWORD,session.ep.userid)>
	<cfpop name="inbox"
		   startrow="#ind#" 
		   action="getHeaderOnly"
		   server="#POP#" 
		   username="#ACCOUNT#" 
		   password="#password_#"
		   maxrows="5"
		   port="#this_port_#">
	<cfif inbox.recordcount>
	<!---<cfoutput query="inbox">
		<cfset attributes.uid = uid>   
		<cfquery name="get_mail_uid" datasource="#DSN#">
			SELECT TOP 1 MAIL_ID FROM MAILS WHERE UID='#attributes.uid#' AND MAILBOX_ID = #MAIL_SETTINGS.mailbox_id#
		</cfquery>
		<cfset count = inbox.recordcount>
		<cfif get_mail_uid.recordcount>
			<cfset count = count - 1>
		<cfelse>
			<cfsavecontent variable="txt">#left(subject,100)# - #from# <br /></cfsavecontent>
				<cfset mylist = ListAppend(mylist,txt)>
				<cfset mylist= replace(mylist,',','','all')>
				<script type="text/javascript">
					document.getElementById("check_mail_div").style.display = "block";
					document.getElementById("check_mail_div").innerHTML = '<br />Yeni #count# mailiniz var<br />';
					document.getElementById('check_mail_div').innerHTML += '<a href="#request.self#?fuseaction=correspondence.cubemail">#mylist#</a>';
				</script>
		</cfif>
	</cfoutput>--->
	</cfif>
</cfloop>
