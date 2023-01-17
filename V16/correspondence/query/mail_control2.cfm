<cfquery name="SELECT_MAIL" datasource="#DSN#">
	SELECT
		*
	FROM	   
		MAILS
	WHERE
		MAIL_ID	= #attributes.cpid#		  
</cfquery>

<cfif select_mail.folder_id eq -3>
	<cfset attributes.type = 0>
	<cfset attach_dir = "sendbox">
<cfelseif select_mail.folder_id eq -1>
	<cfset attributes.type = 3>
	<cfset attach_dir = "draft">
<cfelseif select_mail.folder_id eq -4>
	<cfset attributes.type = 1>
	<cfset attach_dir = "inbox">
<cfelseif select_mail.folder_id eq -2>
	<cfset attributes.type = 2>
	<cfset attach_dir = "deleted">
<cfelse>
	<cfset attributes.type = 1>
	<cfset attach_dir = "inbox">
</cfif>

<cfquery name="GET_MAIL_ATTACHMENT" datasource="#DSN#">
	SELECT
		*
	FROM	   
		MAILS_ATTACHMENT
	WHERE
		MAIL_ID	= #attributes.cpid#
</cfquery>
<cfif GET_MAIL_ATTACHMENT.recordcount gt 0>
<cfparam name="attachments" default="">
<cfparam name="attachments_name" default="">
<cfoutput query="GET_MAIL_ATTACHMENT">
	<cfset attachments=listappend(attachments,GET_MAIL_ATTACHMENT.ATTACHMENT_FILE)>
	<cfset attachments_name=listappend(attachments_name,GET_MAIL_ATTACHMENT.ATTACHMENT_NAME)>
</cfoutput>
</cfif>
<cfscript>	
	 attach = '';
	 for(i = 1 ;i lte GET_MAIL_ATTACHMENT.recordcount; i = i +1)
	 {
		 if(len(ListGetAt(attachments_name , i ,',')) gt 15)
		 {
			 a=ListGetAt(attachments_name , i ,',');
			 isim=Left(a,10);
			 uzanti=Right(a,len(a)-(find('.',a)-1));
			 a=isim&'.'&uzanti;
		 }
		 else
		 {
			a=ListGetAt(attachments_name,i,',');
		 }
		
		file_ = ListGetAt(attachments,i,',');
		attach = "#attach#<a href=""javascript://"" class=""tableyazi"" onClick=""windowopen('/documents/emp_mails/#session.ep.userid#/#attach_dir#/attachments/#file_#','large')"">#a#</a>";
			if (i neq ListLen(attachments,',')){ attach = attach & ' - ';}
	 }	
</cfscript>
