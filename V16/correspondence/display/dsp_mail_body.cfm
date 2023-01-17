<cfsetting showdebugoutput="no">
<cfquery name="get_mail_body" datasource="#dsn#">
	SELECT 
		M.CONTENT_FILE,
		M.FOLDER_ID ,
		M.UID,
		MB.EMPLOYEE_ID,
        M.WRK_ID
	FROM 
		MAILS M,
		CUBE_MAIL MB
	WHERE 
		M.MAIL_ID = #attributes.mail_id# AND
		MB.MAILBOX_ID = M.MAILBOX_ID
</cfquery>

<cfquery name="get_attachmentlist" datasource="#dsn#">
	SELECT 
		MAIL_ID, 
		ATTACHMENT_FILE, 
		SPECIAL_CODE
	FROM 
		MAILS_ATTACHMENT 
	WHERE 
		MAIL_ID = #attributes.mail_id# AND SPECIAL_CODE IS NOT NULL
</cfquery>
<cf_box style="height:99%; overflow:auto;" id="mail_body_id" body_style="height:100%;">
	<cfset body = "">
    <cfif get_mail_body.FOLDER_ID eq -3>
        <cfif FileExists("#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#sendbox#dir_seperator##get_mail_body.CONTENT_FILE#")>
            <cffile action="read" file="#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#sendbox#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
        </cfif>
    <cfelseif get_mail_body.FOLDER_ID eq -2>
        <cfif FileExists("#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#deleted#dir_seperator##get_mail_body.CONTENT_FILE#")>
             <cffile action="read" file="#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#deleted#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
        </cfif>
    <cfelseif get_mail_body.FOLDER_ID eq -1>
        <cfif FileExists("#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#draft#dir_seperator##get_mail_body.CONTENT_FILE#")>
            <cffile action="read" file="#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#draft#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
        </cfif>
    <cfelse>
        <cfif FileExists("#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#inbox#dir_seperator##get_mail_body.CONTENT_FILE#")> 
            <cffile action="read" file="#emp_mail_path##get_mail_body.EMPLOYEE_ID##dir_seperator#inbox#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
        </cfif>
    </cfif>
    <cfset mail_view_type_ = 0>
    <cfset html_cont_list = "<html;<body;<style;</body>;</style>;<p>;<script;<font;<img;<div;<br/>;<br>;<b>;</b>">
    <cfloop list="#html_cont_list#" index="deger_" delimiters=";">
        <cfif mail_view_type_ eq 0 and body contains deger_>
            <cfset mail_view_type_ = 1>
        </cfif>
    </cfloop>
    
    <cfif get_mail_body.FOLDER_ID eq -3>
        <cfset source_adress_ = "/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/sendbox/attachments/#get_mail_body.wrk_id#/">
    <cfelseif get_mail_body.FOLDER_ID eq -2>
        <cfset source_adress_ = "/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/deleted/attachments/">
    <cfelseif get_mail_body.FOLDER_ID eq -1>
        <cfset source_adress_ = "/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/draft/attachments/">
    <cfelse>
        <cfset source_adress_ = "/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/inbox/attachments/">
    </cfif>
    
    <cfif mail_view_type_ eq 1>
        <cfset m_code_list = ''>
        <cfset m_name_list = ''>
        <cfoutput query="get_attachmentlist">
            <cfif len(special_code) and special_code neq 'null'>
                <cfset deger_ = mid(special_code,2,len(special_code)-2)>
                <cfset m_code_list = listappend(m_code_list,deger_)>
            </cfif>
            <cfset m_name_list = listappend(m_name_list,attachment_file)>
        </cfoutput>
            <cfset body_= replace(replacelist(replace(body,'src="cid:','src="#source_adress_#','all'),'#m_code_list#','#m_name_list#'),'<a','<a target="blank"','all')>
            <cfset body_ = replace(body_,'<body','<bodyy','all')>
            <cfset body_ = replace(body_,'</body>','</bodyy>','all')>
        <cfoutput>#body_#</cfoutput>
    <cfelse>
        <cfoutput>#htmleditformat(BODY)#</cfoutput>
    </cfif>
</cf_box>
