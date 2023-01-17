<cfset new_list_emp = attributes.emp_name>
<cfset new_list_emp = listsort(new_list_emp,'text')>
<cfset new_list_cc = attributes.emp_name_cc>
<cfset new_list_cc = listsort(new_list_cc,'text')>
<cfset new_list_bcc = attributes.emp_name_bcc>
<cfset new_list_bcc = listsort(new_list_bcc,'text')>

<cfif attributes.type eq 0>
	<cfset attachDir = "sendbox">
<cfelse>
	<cfset attachDir = "draft">
</cfif>
<cfif IsDefined('attributes.direction_type') and (attributes.direction_type eq 'reply' or attributes.direction_type eq 'replies' or attributes.direction_type eq 'forward')>
	<cfset attributes.mail_type=0>
</cfif>

<cfset count_ = 0>
<cfset folder_ = "">
<cfset wrk_id = 'mail' & dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmssL')&'_#session.ep.userid#_'&round(rand()*100)>
<cfif (IsDefined('attributes.attachment_count') and attributes.attachment_count gt 0) or (isdefined("attributes.asset_id") and len(attributes.asset_id))>
	<cfdirectory action="create" directory="#emp_mail_path##session.ep.userid##dir_seperator##attachDir##dir_seperator#attachments#dir_seperator##wrk_id#">
</cfif>
<cfif IsDefined('attributes.attachment_count') and attributes.attachment_count gt 0>
	<cfloop from="0" to="#attributes.attachment_count#" index="sayac">
		<cfif isdefined('attributes.file_#sayac#') and len(Evaluate('attributes.file_#sayac#'))>
			<cftry>
				<cffile action="UPLOAD" 
					nameconflict="MakeUnique" 
					filefield="file_#sayac#"
					destination="#emp_mail_path##session.ep.userid##dir_seperator##attachDir##dir_seperator#attachments#dir_seperator##wrk_id#">
				<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
						<cfset assetTypeName = listlast(cffile.serverfile,'.')>
						<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
						<cfif listfind(blackList,assetTypeName,',')>
							<cffile action="delete" file="#emp_mail_path##session.ep.userid##dir_seperator##attachDir##dir_seperator#attachments#dir_seperator##folder_##file_name#">
							<script type="text/javascript">
								alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
								history.back();
							</script>
							<cfabort>
						</cfif>		
				<cfset 'this_dosya_#sayac#' = file_name>
				<cfset 'attributes.file_name#sayac#' = cffile.serverfile>
                <cfset count_ = sayac>
				<cfcatch type="any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!"+<cfoutput>#sayac#</cfoutput>);
						history.back();
					</script>
					<cfabort>
				</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
</cfif>


<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
<cfset attributes.asset_id = ListDeleteDuplicates(attributes.asset_id)>
<cfloop from="1" to="#listlen(attributes.asset_id)#" index="cc">
    <cfquery name="GET_ASSET" datasource="#DSN#">
        SELECT
            ASSET.ASSET_NAME,
            ASSET.ASSET_FILE_NAME,
            ASSET.ASSET_FILE_PATH_NAME,
            ASSET_CAT.ASSETCAT_ID,
            ASSET_CAT.ASSETCAT_PATH
        FROM
            ASSET,
            ASSET_CAT
        WHERE
            ASSET.ASSET_ID = #listgetat(attributes.asset_id,cc)# AND 
            ASSET_CAT.ASSETCAT_ID = ASSET.ASSETCAT_ID
    </cfquery>
    <cfif get_asset.assetcat_id gte 0>
		<cfset folder="asset/">
    <cfelse>
        <cfset folder="">
    </cfif>
    <cfif not len(get_asset.asset_file_path_name)>
       <cfset attch = "#upload_folder##folder##get_asset.assetcat_path#/#get_asset.asset_file_name#">
    <cfelse>
        <cfscript>
            get_asset.asset_file_path_name = replacelist(get_asset.asset_file_path_name, "/", "\");
            get_asset.asset_file_path_name = replacelist(get_asset.asset_file_path_name, ":", "$");
        </cfscript>
        <cfset attch = "#upload_folder##folder##get_asset.asset_file_path_name#">
    </cfif>
    <cftry>
    	<cfset ext_ = listlast(GET_ASSET.ASSET_FILE_NAME,'.')>
        <cffile action="copy" source="#attch#" destination="#emp_mail_path##session.ep.userid##dir_seperator##attachDir##dir_seperator#attachments#dir_seperator##wrk_id#">
        <cffile action="rename" source="#emp_mail_path##session.ep.userid##dir_seperator##attachDir##dir_seperator#attachments#dir_seperator##wrk_id##dir_seperator##GET_ASSET.ASSET_FILE_NAME#" 
        						destination="#emp_mail_path##session.ep.userid##dir_seperator##attachDir##dir_seperator#attachments#dir_seperator##wrk_id##dir_seperator##GET_ASSET.ASSET_NAME#.#ext_#">
		<cfset count_ = count_ + 1>
        <cfset 'this_dosya_#count_#' = GET_ASSET.ASSET_FILE_NAME>
        <cfset 'attributes.file_name#count_#' = '#GET_ASSET.ASSET_NAME#.#ext_#'>
    <cfcatch>
    	<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
			history.back();
		</script>
		<cfabort>
    </cfcatch>
    </cftry>
</cfloop>
</cfif>
<cfif isDefined("attributes.old_attachment") and (attributes.old_attachment neq '')>
	<cfloop from="1" to="#ListLen(attributes.old_attachment,',')#" index="ind">
		<cfif attributes.type eq 3 and attributes.folder_id_ neq -1>
			<cftry>
			<cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator##attributes.old_attach_dir##dir_seperator#attachments#dir_seperator##ListGetAt(attributes.old_attachment,ind ,',')#" destination="#emp_mail_path##session.ep.userid##dir_seperator#draft#dir_seperator#attachments">
			<cfcatch type="any">
				<script>
					alert("Ekli dosya taşınırken bir problem oluştu!");
				</script>
			</cfcatch>
			</cftry>		
		<cfelseif attributes.type eq 0>
			<cftry>
            <cfif attributes.old_attach_dir eq 'sendbox'>
            	<!--- Giden kutusundan mail iletirken --->
            	<cfquery name="get_old" datasource="#dsn#">
                	SELECT WRK_ID FROM MAILS WHERE MAIL_ID = #attributes.mail_id# 
                </cfquery>
		 		<cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator##attributes.old_attach_dir##dir_seperator#attachments#dir_seperator##get_old.wrk_id##dir_seperator##ListGetAt(attributes.old_attachment,ind,',')#" destination="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator#attachments#dir_seperator##wrk_id#">
            <cfelse>
                <cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator##attributes.old_attach_dir##dir_seperator#attachments#dir_seperator##ListGetAt(attributes.old_attachment,ind,',')#" destination="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator#attachments">
            </cfif>
			<cfcatch type="any">
				<script>
					alert("Ekli dosya taşınırken bir problem oluştu");
				</script>
			</cfcatch>
			</cftry>
		</cfif>
	</cfloop>
</cfif>

<cfquery name="MAIL_PASS" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		MAILBOX_ID = #attributes.MAILBOX_ID#
</cfquery>

<cfquery name="get_main_rules" datasource="#DSN#">
	SELECT 
		ACTION
	FROM 
		CUBE_MAIL_MAIN_RULES 
	WHERE 
		TYPE = 1 AND 
		RULE_NAME = '#MAIL_PASS.EMAIL#' AND 
		ACTION IS NOT NULL
</cfquery>
<cfset aktarilacak_list = listdeleteduplicates(valuelist(get_main_rules.action))>

<cfif len(attributes.EMP_NAME_BCC) and not get_main_rules.recordcount>
	<cfset bcc_ = "#attributes.EMP_NAME_BCC#">
<cfelse>
	<cfset bcc_ = "#attributes.EMP_NAME_BCC#,#aktarilacak_list#">
</cfif>
<cfif not attributes.from contains '<'>
<cfset attributes.from = '<'&#attributes.from#&'>'>
</cfif>
<cfif attributes.type eq 0>
		<cfset pass=Decrypt(MAIL_PASS.PASSWORD,MAIL_PASS.EMPLOYEE_ID)>
		<cfif len(MAIL_PASS.SMTP_PORT)>
			<cfset this_port_ = MAIL_PASS.SMTP_PORT>
		<cfelse>
			<cfset this_port_ = 25>
		</cfif>
        <cfif trim(MAIL_PASS.SMTP) is 'smtp.gmail.com'>
			<cfset ssl_ = "yes">
		<cfelse>
			<cfset ssl_ = "no">
		</cfif>
        <cfmail to = "#attributes.EMP_NAME#" from = "#session.ep.name# #session.ep.surname# #attributes.from#" subject = "#attributes.subject#" cc="#attributes.EMP_NAME_CC#"		  
			bcc="#bcc_#" server="#trim(MAIL_PASS.SMTP)#" username="#trim(MAIL_PASS.ACCOUNT)#" password="#trim(pass)#" port="#this_port_#" useSSL = "#ssl_#" charset="utf-8" type="HTML">
				<cfif IsDefined('attributes.attachment_count') and attributes.attachment_count gt 0>
					<cfloop from="0" to="#attributes.attachment_count#" index="sayac"> 
						<cfif isdefined("attributes.file_name#sayac#")>
							<cfmailparam file="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator#attachments#dir_seperator##wrk_id##dir_seperator##Evaluate('attributes.file_name#sayac#')#"> 	
						</cfif>
					</cfloop>
				</cfif>
				<cfif isDefined("attributes.old_attachment") and (attributes.old_attachment neq '')>
					<cfloop from="1" to="#ListLen(attributes.old_attachment,',')#" index="ind">
						<cfmailparam file="#emp_mail_path##session.ep.userid##dir_seperator##attributes.old_attach_dir##dir_seperator#attachments#dir_seperator##wrk_id##dir_seperator##ListGetAt(attributes.old_attachment , ind ,',')#">					
					</cfloop>
				</cfif>   
				<style type="text/css">
					.color-header{background-color: ##a7caed;}
					.color-border	{background-color:##6699cc;}
					.color-row{	background-color: ##f1f0ff;}
					.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
					.form-title	{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}
					.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}
					a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
					a.tableyazi:active {text-decoration: none;}
					a.tableyazi:hover {text-decoration: underline; color:##339900;}
					a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
					.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
				</style>
				#attributes.mail_content#
		  </cfmail>
		<cfsavecontent variable="css">
			<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			.form-title	{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}	
			.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}          
			a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;} 
			a.tableyazi:active {text-decoration: none;}
			a.tableyazi:hover {text-decoration: underline; color:##339900;}  
			a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
			.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>
		</cfsavecontent>
		<cfif isDefined("attributes.old_attachment") and (attributes.old_attachment neq '')>
			<cfset attributes.attachment = attributes.old_attachment>  
			<cfset attributes.attachment_name = attributes.old_attachment_name>
		</cfif>
		
		<cfset attributes.body="#css##attributes.mail_content#">
		<cfset attributes.module="correspondence">
		<cfset attributes.relation_list_emp = new_list_emp>
		<cfset attributes.relation_list_cc = new_list_cc>
		<cfset attributes.relation_list_bcc = new_list_bcc>
		<cfinclude template="../../objects/query/add_mail.cfm"> 
<cfelse>
		<cfif isdefined("attributes.folder_id_") and len(attributes.folder_id_)>
			<cfset folder_id_eski = attributes.folder_id_>
        <cfelse>
        	<cfset folder_id_eski = "">
        </cfif>
		<cfsavecontent variable="css">
			<style type="text/css">
			.color-header{background-color: ##a7caed;}
			.color-border	{background-color:##6699cc;}
			.color-row{	background-color: ##f1f0ff;}
			.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
			.form-title	{font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color:white;font-weight : bold;padding-left: 2px;}	
			.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}          
			a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;} 
			a.tableyazi:active {text-decoration: none;}
			a.tableyazi:hover {text-decoration: underline; color:##339900;}  
			a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
			.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>
		</cfsavecontent>
		<cfif isDefined("attributes.old_attachment") and (attributes.old_attachment neq '')>
			<cfset attributes.attachment = attributes.old_attachment>  
			<cfset attributes.attachment_name = attributes.old_attachment_name>  
		</cfif>
		<cfset attributes.module="correspondence">
		<cfset attributes.body="#css##attributes.mail_content#">
		
        <cfif isdefined("attributes.type") and (attributes.type eq 3) and (folder_id_eski eq -1) and isdefined("attributes.mail_id") and len(attributes.mail_id)>
			<cfset file_name = "#createUUID()#.eml">
            <cffile action="write" file="#emp_mail_path##session.ep.userid##dir_seperator#draft#dir_seperator##file_name#" output="#attributes.body#" charset ="UTF-8">	
            <cfquery name="upd_mail" datasource="#dsn#">
                UPDATE 
                    MAILS
                SET 
                    FOLDER_ID = -1,
                    SUBJECT = '#attributes.subject#',
                    CONTENT_FILE = '#file_name#',
                    MAIL_TO =  <cfif isDefined("attributes.to_list") and len(attributes.to_list) lte 500>'#trim(attributes.to_list)#',<cfelseif isdefined("attributes.emp_name")>'#attributes.emp_name#',<cfelseif isdefined("attributes.to")>'#attributes.to#',<cfelseif isdefined("attributes.to_id")>'#attributes.to_id#',<cfelseif isdefined("attributes.to_")>'#attributes.to_#',<cfelse>NULL,</cfif>
                    MAIL_CC =  <cfif isDefined("attributes.cc_list") and len(attributes.cc_list) lte 500>'#trim(attributes.cc_list)#',<cfelseif isdefined("attributes.emp_name_cc")>'#attributes.emp_name_cc#',<cfelse>NULL,</cfif>
                    IS_READ = 1,
                    UID = NULL
                WHERE
                    MAIL_ID = #attributes.mail_id#
            </cfquery>
            <cfif IsDefined('attributes.attachment_count') and attributes.attachment_count gt 0> 
                <cfif isdefined("attributes.attachment_count") and attributes.attachment_count gt 0>
                    <cfloop from="0" to="#attributes.attachment_count#" index="sayac">
                        <cfif isdefined('this_dosya_#sayac#') and len(Evaluate('this_dosya_#sayac#'))>
                            <cfset a = evaluate("this_dosya_#sayac#")>
                            <cfset a_name=evaluate("attributes.file_name#sayac#")>
                            <cfquery name="control_attc" datasource="#dsn#">
                                SELECT ATTACHMENT_FILE FROM MAILS_ATTACHMENT WHERE MAIL_ID = #attributes.mail_id# AND ATTACHMENT_FILE = '#a_name#'
                            </cfquery>
                            <cfif not control_attc.recordcount>
                                <cfquery name="add_att1" datasource="#DSN#">
                                    INSERT INTO 
                                        MAILS_ATTACHMENT
                                    (
                                        WRK_ID,
                                        MAIL_ID,
                                        ATTACHMENT_FILE,
                                        ATTACHMENT_NAME,
                                        ATTACH_SERVER_ID,
                                        SPECIAL_CODE
                                    )
                                    VALUES
                                    (
                                        '#wrk_id#',
                                        #attributes.mail_id#,
                                        '#a_name#',
                                        '#a_name#',
                                        2,
                                        <cfif isdefined("attributes.attachment_s_codes") and len(attributes.attachment_s_codes) and listlen(attributes.attachment_s_codes,'&')>
                                            <cfif listlen(attributes.attachment_s_codes,'&') gte sayac>
                                                <cfif listlast(listgetat(attributes.attachment_s_codes,sayac,"&"),"=") is 'null'>NULL<cfelse>'#listlast(listgetat(attributes.attachment_s_codes,sayac,"&"),"=")#'</cfif> 
                                            <cfelse>
                                                NULL
                                            </cfif>
                                        <cfelse>
                                            NULL
                                        </cfif>
                                    )
                                </cfquery>
                        	</cfif>
                        </cfif>
                    </cfloop>
                </cfif>
            </cfif>
        <cfelse>
        	<cfinclude template="../../objects/query/add_mail.cfm">
        </cfif>
</cfif>
<cfif isdefined("attributes.project_id1") and len(attributes.project_id1) and isdefined("attributes.project_head1") and len(attributes.project_head1)>
	<cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
    	<cfset MAX_MAIL_ID = attributes.mail_id>
    </cfif>
	<cfif isdefined("attributes.relation_type")>
        <cfquery name="control_relation" datasource="#dsn#">
            SELECT MAIL_ID FROM MAILS_RELATION WHERE RELATION_TYPE_ID = #attributes.relation_type_id# AND RELATION_TYPE = '#attributes.relation_type#' AND MAIL_ID = #MAX_MAIL_ID#
        </cfquery>
    <cfelse>
    	<cfset control_relation.recordcount = 0>
    </cfif>
        <cfif not control_relation.recordcount>
            <cfquery name="add_associate" datasource="#DSN#">
                INSERT INTO
                    MAILS_RELATION
                    (
                        MAIL_ID,
                        RELATION_TYPE,
                        RELATION_TYPE_ID
                    )
                    VALUES
                    (
                        #max_mail_id#,
                        'PROJECT_ID',
                        '#attributes.project_id1#'
                    )
            </cfquery>
        </cfif>
<cfelseif isdefined("attributes.project_id1") and len(attributes.project_id1) and isdefined("attributes.project_head1") and not len(attributes.project_head1)>
	<cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and attributes.type eq 3>
        <cfquery name="control_relation" datasource="#dsn#">
            SELECT MAIL_ID FROM MAILS_RELATION WHERE RELATION_TYPE_ID = #attributes.project_id1# AND RELATION_TYPE = 'PROJECT_ID' AND MAIL_ID = #attributes.mail_id#
        </cfquery>
        <cfif control_relation.recordcount>
        	<cfquery name="del_rel" datasource="#dsn#">
            	DELETE FROM MAILS_RELATION WHERE MAIL_ID = #attributes.mail_id# AND RELATION_TYPE_ID = #attributes.project_id1#
            </cfquery>
        </cfif>
    </cfif>
</cfif>

<cfif attributes.type eq 0>
	<cfset attributes.folder_id = -3>
<cfelse>
	<cfset attributes.folder_id = -1>
</cfif>

<cfquery name="EMP_MAIL_LIST" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		CUBE_MAIL 
	WHERE 
		EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfquery name="get_mail_counts" datasource="#dsn#">
	SELECT MAIL_ID,FOLDER_ID,IS_READ FROM MAILS WHERE MAILBOX_ID IN (#valuelist(EMP_MAIL_LIST.MAILBOX_ID)#)
</cfquery>

<cfquery name="get_mail_old_count" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.folder_id#
</cfquery>
<cfquery name="get_mail_old_count_read" dbtype="query">
	SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #attributes.folder_id# AND (IS_READ = 0 OR IS_READ IS NULL)
</cfquery>

	
<cfif get_main_rules.recordcount>
    <cfquery name="get_mails_" datasource="#dsn#">
        SELECT * FROM MAILS WHERE MAIL_ID = '#max_mail_id#'
    </cfquery>
    <cfif get_mails_.recordcount>
        <cfloop list="#aktarilacak_list#" index="ccm">
            <cfquery name="get_aktarim_settings" datasource="#DSN#">
                SELECT MAILBOX_ID,EMPLOYEE_ID FROM CUBE_MAIL WHERE EMAIL = '#ccm#'
            </cfquery>
            <cfif get_aktarim_settings.recordcount>
                    <cfquery name="add_" datasource="#dsn#" result="MAX_ID">
                        INSERT INTO 
                            MAILS
                        (
                            WRK_ID,
                            MAILBOX_ID,
                            FOLDER_ID,
                            SUBJECT,
                            SENDER,
                            CONTENT_FILE,
                            CONTENT_FILE_SERVER_ID,
                            MAIL_MODULE,
                            MAIL_FROM,
                            MAIL_TO,
                            MAIL_CC,	
                            RECORD_DATE,
                            REAL_DATE,
                            IS_READ,
                            UID
                        )
                        VALUES
                        (
                            '#wrk_id#',
                            #get_aktarim_settings.mailbox_id#,
                            -4,
                            '#get_mails_.subject#',
                            <cfif len(get_mails_.SENDER)>#get_mails_.SENDER#<cfelse>NULL</cfif>,
                            <cfif len(get_mails_.CONTENT_FILE)>'#get_mails_.CONTENT_FILE#'<cfelse>NULL</cfif>,
                            <cfif len(get_mails_.CONTENT_FILE_SERVER_ID)>#get_mails_.CONTENT_FILE_SERVER_ID#<cfelse>NULL</cfif>,
                            <cfif len(get_mails_.MAIL_MODULE)>'#get_mails_.MAIL_MODULE#'<cfelse>NULL</cfif>,
                            <cfif len(get_mails_.MAIL_FROM)>'#get_mails_.MAIL_FROM#'<cfelse>NULL</cfif>,
                            <cfif len(get_mails_.MAIL_TO)>'#get_mails_.MAIL_TO#'<cfelse>NULL</cfif>,
                            <cfif len(get_mails_.MAIL_CC)>'#get_mails_.MAIL_CC#'<cfelse>NULL</cfif>,
                            #now()#,
                            #date_add('h',session.ep.time_zone,now())#,
                            0,
                            <cfif len(get_mails_.uid)>'#get_mails_.uid#'<cfelse>NULL</cfif>
                        )
                    </cfquery>                    
                    <cfquery name="GET_MAIL_ATTACHMENTS" datasource="#dsn#">
                        SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID = #max_mail_id#
                    </cfquery>
					<cfscript>
                        if(Len(MAX_ID.IDENTITYCOL))
                            max_mail_id = MAX_ID.IDENTITYCOL;
                        else
                            max_mail_id = 1;	
                    </cfscript>
                    <cfif len(get_mails_.CONTENT_FILE)><cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator##get_mails_.CONTENT_FILE#" destination="#emp_mail_path##get_aktarim_settings.employee_id##dir_seperator#inbox"></cfif>
                    <cfif GET_MAIL_ATTACHMENTS.recordcount>
                        <cfloop query="GET_MAIL_ATTACHMENTS">
                        <cfquery name="add_attachments" datasource="#dsn#">
                            INSERT INTO 
                                MAILS_ATTACHMENT
                            (
                                MAIL_ID,
                                ATTACHMENT_FILE,
                                ATTACHMENT_NAME,
                                ATTACH_SERVER_ID,
                                WRK_ID,
                                SPECIAL_CODE 
                            )
                            VALUES
                            (
                                #max_mail_id#,
                                '#GET_MAIL_ATTACHMENTS.ATTACHMENT_FILE#',
                                '#GET_MAIL_ATTACHMENTS.ATTACHMENT_NAME#',
                                6,
                                '#GET_MAIL_ATTACHMENTS.WRK_ID#',
                                <cfif len(GET_MAIL_ATTACHMENTS.SPECIAL_CODE)>'#GET_MAIL_ATTACHMENTS.SPECIAL_CODE#'<cfelse>NULL</cfif>
                            )
                        </cfquery>
                        <cffile action="copy" source="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator#attachments#dir_seperator##wrk_id##dir_seperator##GET_MAIL_ATTACHMENTS.ATTACHMENT_FILE#" destination="#emp_mail_path##get_aktarim_settings.employee_id##dir_seperator#inbox#dir_seperator#attachments">
                        </cfloop>
                    </cfif>
            </cfif>
        </cfloop>
    </cfif>
</cfif>


<script type="text/javascript">
	function calistir()
	{ 
	<cfoutput> 
		window.top.document.getElementById("static_#-1*attributes.folder_id#").innerHTML = '(#get_mail_old_count_read.recordcount#/#get_mail_old_count.recordcount#)';
		window.top.list_mail(<cfif attributes.type eq 0>#attributes.folder_id#<cfelse>#attributes.folder_id#</cfif>);
	</cfoutput>
	}
		//window.top.document.getElementById("message_div").innerHTML = 'Gönderildi!';
		<cfif isdefined("attributes.relation_type")>
			window.top.document.getElementById("message_div").innerHTML ='';
			window.top.location.href='<cfoutput>#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=#attributes.relation_type#&relation_type_id=#attributes.relation_type_id#</cfoutput>';
		<cfelse>
			setTimeout("calistir();",2500);
		</cfif>
	
</script>

