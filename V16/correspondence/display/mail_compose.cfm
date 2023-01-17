<cfsetting showdebugoutput="no">
	<cfparam name="attributes.old_attachment" default="">
	<cfparam name="attributes.old_attachment_name" default="">
	<cfparam name="attributes.mail_type" default="">
    <cfsavecontent variable="my_signature"><cfinclude template="#file_web_path#cubemail/signature.cfm"></cfsavecontent>
	<cfset work_company_id = ''>
	<cfset work_company_name = ''>
	<cfset work_partner_id = ''>
	<cfset work_partner_name = ''>
	
	<cfquery name="EMP_MAIL_LIST" datasource="#DSN#">
		SELECT 
			* 
		FROM 
			CUBE_MAIL 
		WHERE 
			EMPLOYEE_ID = #session.ep.userid# and
			ISACTIVE = 1
		ORDER BY
			PRIORITY ASC
	</cfquery>
    <cfif isdefined("attributes.mail_id") and len(attributes.mail_id)>
    <cfquery name="get_bcc" datasource="#dsn#">
        SELECT 
            COMPANY.COMPANY_EMAIL  AS EMAIL
        FROM 
            MAILS_RELATION,
            COMPANY
        WHERE
            MAILS_RELATION.MAIL_ID = #attributes.mail_id#
            AND MAILS_RELATION.RELATION_TYPE = 'COMPANY_ID'
            AND MAILS_RELATION.TYPE = 2
            AND MAILS_RELATION.RELATION_TYPE_ID = COMPANY.COMPANY_ID
        UNION
        SELECT 
            COMPANY_PARTNER.COMPANY_PARTNER_EMAIL AS EMAIL
        FROM 
            MAILS_RELATION,
            COMPANY_PARTNER
        WHERE
            MAILS_RELATION.MAIL_ID = #attributes.mail_id#
            AND MAILS_RELATION.RELATION_TYPE = 'PARTNER_ID'
            AND MAILS_RELATION.TYPE = 2
            AND MAILS_RELATION.RELATION_TYPE_ID = COMPANY_PARTNER.PARTNER_ID
        UNION
        SELECT 
            CONSUMER.CONSUMER_EMAIL AS EMAIL
        FROM 
            MAILS_RELATION,
            CONSUMER
        WHERE
            MAILS_RELATION.MAIL_ID = #attributes.mail_id#
            AND MAILS_RELATION.RELATION_TYPE = 'CONSUMER_ID'
            AND MAILS_RELATION.TYPE = 2
            AND MAILS_RELATION.RELATION_TYPE_ID = CONSUMER.CONSUMER_ID
        UNION
        SELECT 
            EMPLOYEES.EMPLOYEE_EMAIL AS EMAIL
        FROM 
            MAILS_RELATION,
            EMPLOYEES
        WHERE
            MAILS_RELATION.MAIL_ID = #attributes.mail_id#
            AND MAILS_RELATION.RELATION_TYPE = 'EMPLOYEE_ID'
            AND MAILS_RELATION.TYPE = 2
            AND MAILS_RELATION.RELATION_TYPE_ID = EMPLOYEES.EMPLOYEE_ID
    </cfquery>
    </cfif>
	<cfif isdefined("attributes.relation_type") and attributes.relation_type is 'project_id'>
		<cfquery name="GET_MAIL_GROUP" datasource="#DSN#">
			SELECT
				CP.COMPANY_PARTNER_EMAIL AS MAIL_ADRESI,
				CP.PARTNER_ID AS USER_ID
			FROM  
				WORKGROUP_EMP_PAR WE,
				COMPANY_PARTNER CP		
			WHERE 
				WE.PROJECT_ID= #attributes.relation_type_id# AND
				WE.PARTNER_ID = CP.PARTNER_ID
			UNION 
			SELECT
				C.CONSUMER_EMAIL AS MAIL_ADRESI,
				C.CONSUMER_ID AS USER_ID
			FROM  
				WORKGROUP_EMP_PAR WE,
				CONSUMER C		
			WHERE 
				WE.PROJECT_ID= #attributes.relation_type_id# AND
				WE.CONSUMER_ID = C.CONSUMER_ID
			UNION 
			SELECT
				E.EMPLOYEE_EMAIL AS MAIL_ADRESI,
				E.EMPLOYEE_ID AS USER_ID
			FROM  
				WORKGROUP_EMP_PAR WE,
				EMPLOYEES E	
			WHERE 
				WE.PROJECT_ID= #attributes.relation_type_id# AND
				WE.EMPLOYEE_ID = E.EMPLOYEE_ID
		</cfquery>
		<cfoutput query="GET_MAIL_GROUP">
			<cfset mail_list=valuelist(GET_MAIL_GROUP.MAIL_ADRESI,',')>
		</cfoutput>
	<cfelseif isdefined("attributes.relation_type") and relation_type is 'COMPANY_ID'>
		<cfquery name="GET_MAIL_GROUP" datasource="#DSN#">
			SELECT 
				COMPANY_EMAIL
			FROM 
				COMPANY
			WHERE 
				COMPANY_ID = #attributes.relation_type_id#
		</cfquery>
			<cfset mail_list=GET_MAIL_GROUP.COMPANY_EMAIL>
	<cfelseif isdefined("attributes.relation_type") and relation_type is 'CONSUMER_ID'>
		<cfquery name="GET_MAIL_GROUP" datasource="#DSN#">
			SELECT 
				CONSUMER_EMAIL
			FROM
				CONSUMER
			WHERE 
				CONSUMER_ID = #attributes.relation_type_id#
		</cfquery>
		<cfset mail_list=GET_MAIL_GROUP.CONSUMER_EMAIL>
	</cfif>
	
	<cfif isDefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="GET_PARTNER" datasource="#DSN#">
			SELECT 
				COMPANY_PARTNER_EMAIL,
				PARTNER_ID
			FROM
				COMPANY_PARTNER
			WHERE 
				PARTNER_ID = #attributes.pid#
		</cfquery>
	</cfif>
	<cfif isdefined('attributes.mail_id') or (isdefined('attributes.direction_type') and attributes.direction_type is 'forward')>
	   <cfquery name="GET_ALL_MAILS_LIST2" datasource="#DSN#">
			 SELECT MAIL_TO,MAIL_CC FROM MAILS WHERE MAIL_ID = #attributes.mail_id#
	   </cfquery>
	</cfif>
	<cfquery name="GET_SIGN" datasource="#DSN#">
		SELECT * FROM CUBE_MAIL_SIGNATURE WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
    <cfquery name="GET_TEMPLATE" datasource="#DSN#">
        SELECT * FROM SETUP_CORR
    </cfquery>
    <cfoutput query="GET_TEMPLATE">
    	<cfset template_detail_= Replace(detail,"#chr(34)#","#chr(39)#","All")>
		<input type="hidden" name="template_icerigi_#corrcat_id#" id="template_icerigi_#corrcat_id#" value="#template_detail_#">
	</cfoutput>
	<cfoutput query="get_sign">
		<cfset signature_detail_= Replace(signature_detail,"#chr(34)#","#chr(39)#","All")>
		<input type="hidden" name="imza_icerigi_#signature_id#" id="imza_icerigi_#signature_id#" value="#signature_detail_#">
		<cfif STANDART_SIGNATURE eq 1>
			<cfsavecontent variable="my_signature">#signature_detail#</cfsavecontent>
		</cfif>
	</cfoutput>
	<cfif isDefined("attributes.mail_id")><cfset extras = '&mail_type=#attributes.mail_type#&mail_id=#attributes.mail_id#'><cfelse><cfset extras = ''></cfif>
		<iframe src="" name="mail_send_frame" id="mail_send_frame" width="0" height="0" style="display:none;"></iframe> 
		<cfform name="send_mail" enctype="multipart/form-data" action="#request.self#?fuseaction=correspondence.emptypopup_add_sent_mail#extras#" method="post">
		<cf_box title="Mail Oluştur" closable="0" collapsable="0">
				<table border="0">
				<input type="hidden" name="mail_content" id="mail_content" value="" />
				<input type="hidden" name="mail_type" id="mail_type" value="0">
				<input type="hidden" name="type" id="type" value="0">
				<cfif isdefined("attributes.relation_type") and len(attributes.relation_type)>
					<input type="hidden" name="relation_type" id="relation_type" value="<cfoutput>#attributes.relation_type#</cfoutput>" />
					<input type="hidden" name="relation_type_id" id="relation_type_id" value="<cfoutput>#attributes.relation_type_id#</cfoutput>" />
				</cfif>
				<cfif IsDefined('direction_type')>
					<input type="hidden" name="direction_type" id="direction_type" value="<cfoutput>#attributes.direction_type#</cfoutput>">
				</cfif>
					<tr>
						<td width="60"><cf_get_lang_main no='512.Kime'></td>
						<td  id="names" width="540">
							<cfif isDefined("attributes.mail_id") and len(attributes.mail_id)>
								<cfset attributes.type = attributes.mail_type>
								<cfinclude template="../query/mail_control.cfm">
								<cfif isdefined('attributes.all_replies') or (isdefined('attributes.direction_type') and attributes.direction_type is 'forward') or (isdefined('attributes.direction_type') and attributes.direction_type is 'template')><!--- Eğer hepsini yanıtla seçildiyse mails'den to ve cc kısımlarını doldurmak için. --->
									<cfquery name="GET_ALL_MAILS_LIST" datasource="#DSN#">
										SELECT replace(MAIL_TO,'"','') AS MAIL_TO,replace(MAIL_CC,'"','') AS MAIL_CC FROM MAILS WHERE MAIL_ID = #attributes.mail_id#
									</cfquery>
								</cfif>
								<cfif (attributes.type eq 0) or (attributes.type eq 2)>
									<cfquery name="GET_MAILFROM" datasource="#dsn#">
										SELECT
										<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
											EMPLOYEE_EMAIL
										<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
											COMPANY_PARTNER_EMAIL
										</cfif>
										FROM
										<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
											EMPLOYEE_POSITIONS
										<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
											COMPANY_PARTNER
										</cfif>		
										WHERE
										<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
											EMPLOYEE_ID=#SELECT_MAIL.SENDER#
										<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
											PARTNER_ID=#SELECT_MAIL.SENDER#
										</cfif>
									</cfquery>
									<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
										<cfset from = "<#EMP_MAIL_LIST.EMAIL#>">
									<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
										<cfset from = "<#GET_MAILFROM.COMPANY_PARTNER_EMAIL#>">
									</cfif>
								<cfelseif attributes.type eq 1>
									<cfset from = SELECT_MAIL.MAIL_FROM>
								<cfelseif attributes.type eq 3>
									<cfset from = SELECT_MAIL.MAIL_FROM>
								</cfif>								
							</cfif>
							<cfoutput>	
								<input type="hidden" name="emp_id" id="emp_id" value="<cfif not isdefined('attributes.all_replies') and  isDefined('attributes.direction_type') and (attributes.direction_type eq 'reply')>#from#,<cfelseif isdefined('attributes.all_replies')>#from#,#trim(GET_ALL_MAILS_LIST.MAIL_TO)#,</cfif>">
								<cfif not isdefined('attributes.all_replies') and isDefined("attributes.direction_type") and (attributes.direction_type eq 'reply')>	
									<input type="text" name="emp_name" id="emp_name" style="width:500px;" value="#from#" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<cfelseif isDefined("attributes.direction_type") and (attributes.direction_type eq 'forward')>
									<input type="text" name="emp_name" id="emp_name" style="width:500px;" value="" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<cfelseif not isdefined('attributes.all_replies') and isDefined("attributes.mail_id") and (attributes.type eq 3)>
									<input type="text" name="emp_name" id="emp_name" style="width:500px;" value="#ListSort(ValueList(GET_ALL_MAILS_LIST.MAIL_TO,','),'textnocase','asc',',')#" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<cfelseif isdefined("attributes.mail_id")>
									<input type="text" name="emp_name" id="emp_name" style="width:500px;" value="#from#,#trim(GET_ALL_MAILS_LIST.MAIL_TO)#" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<cfelseif isdefined("attributes.pid") and len(attributes.pid)>
									<input type="text" name="emp_name" id="emp_name" style="width:500px;" value="#trim(GET_PARTNER.COMPANY_PARTNER_EMAIL)#" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<cfelseif isdefined("attributes.relation_type")>
									<input type="text" name="emp_name" id="emp_name" style="width:500px" value="<cfif isdefined('mail_list')>#mail_list#</cfif>" />
								<cfelseif isdefined('attributes.all_replies')>
									<input type="text" name="emp_name" id="emp_name" style="width:500px;" value="#from#,#trim(GET_ALL_MAILS_LIST.MAIL_TO)#" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								<cfelse>
									<cfinput type="text" name="emp_name" id="emp_name" style="width:500px;" value="" onFocus="AutoComplete_Create('emp_name','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id');">
								</cfif>
								<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=send_mail.emp_id&names=send_mail.emp_name')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='61.Kisi Ekle'>" title="<cf_get_lang no='61.Kisi Ekle'>" border="0" align="absmiddle"></a>
							</cfoutput>
							<cfquery name="GET_MAILFROM" datasource="#DSN#">
								SELECT
								<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
									EMPLOYEE_EMAIL
								<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
									COMPANY_PARTNER_EMAIL
								</cfif>
								FROM
								<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
									EMPLOYEE_POSITIONS
								<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
									COMPANY_PARTNER
								</cfif>
								WHERE
								<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
									EMPLOYEE_ID=#session.ep.USERID#
								<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
									PARTNER_ID=#session.pp.USERID#
								</cfif>
							</cfquery>
							<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
								<cfset sender = "<#EMP_MAIL_LIST.EMAIL#>">
							<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
								<cfset sender = "<#GET_MAILFROM.COMPANY_PARTNER_EMAIL#>">
							</cfif>
							<input type="hidden" id="from" name="from" value="<cfoutput>#sender#</cfoutput>">
						</td>
						<td><cf_get_lang no='49.Ekler'></td>
						<td id="table1" rowspan="4" valign="top">
							<input type="hidden" name="attachment_count" id="attachment_count" value="10">
							<cf_workcube_multiple_file field_count='10' div_width='250' div_height='70'>
						</td>
						<cfif isDefined("attributes.mail_id") and (attributes.direction_type is 'forward' or attributes.direction_type is 'template')>			  
							<cfoutput> 
							<input type="hidden" name="old_attach_dir" id="old_attach_dir" value="#attach_dir#">
								<cfloop query="GET_MAIL_ATTACHMENT" startrow="1">
									<cfset attributes.old_attachment = ListAppend(attributes.old_attachment,GET_MAIL_ATTACHMENT.ATTACHMENT_FILE, ',')>
									<cfset attributes.old_attachment_name = ListAppend(attributes.old_attachment_name,GET_MAIL_ATTACHMENT.ATTACHMENT_NAME, ',')>
								</cfloop>
								<input type="hidden" id="old_attachment" name="old_attachment" value="#attributes.old_attachment#">
								<input type="hidden" id="old_attachment_name" name="old_attachment_name" value="#attributes.old_attachment_name#">
								<td rowspan="4" valign="top">
									<div style="overflow:auto"><cfif attach neq ''>#attach#</cfif></div>
							   </td>
							</cfoutput>
						</cfif>	
					</tr>
					<tr>
					<!---CC--->
					<td><cf_get_lang_main no='144.CC'></td>
					<td height="20" id="names">
						<input type="hidden" id="emp_id_cc" name="emp_id_cc" value="<cfif isdefined('attributes.direction_type') and attributes.direction_type is 'forward' ><cfoutput>#trim(GET_ALL_MAILS_LIST.MAIL_CC)#,</cfoutput><cfelse><cfif isdefined('attributes.all_replies')><cfoutput>#trim(GET_ALL_MAILS_LIST.MAIL_CC)#,</cfoutput></cfif></cfif>">
						<cfif isdefined('attributes.direction_type') and attributes.direction_type is 'forward' >
						 <input type="text" id="emp_name_cc" name="emp_name_cc"  style="width:500px;" 
						value="<cfoutput>#trim(GET_ALL_MAILS_LIST.MAIL_CC)#</cfoutput>" onFocus="AutoComplete_Create('emp_name_cc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_cc');">
						<cfelse>
						<cfif isDefined("attributes.mail_id") and (attributes.type eq 3)>
						<input type="text" id="emp_name_cc" name="emp_name_cc"  style="width:500px;" 
						value="
						<cfoutput>#ListSort(ValueList(GET_ALL_MAILS_LIST.MAIL_CC,","),'textnocase','asc',',')#</cfoutput>" onFocus="AutoComplete_Create('emp_name_cc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_cc');">
						<cfelseif isdefined('attributes.all_replies')>
						<input type="text" id="emp_name_cc" name="emp_name_cc"  style="width:500px;" 
						value="<cfoutput>#trim(GET_ALL_MAILS_LIST.MAIL_CC)#</cfoutput>" onFocus="AutoComplete_Create('emp_name_cc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_cc');">
						<cfelse>
						<cfinput type="text" id="emp_name_cc" name="emp_name_cc" style="width:500px;" value="" autocomplete="off" onFocus="AutoComplete_Create('emp_name_cc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_cc');">
						</cfif>
						</cfif>
						<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=send_mail.emp_id_cc&names=send_mail.emp_name_cc','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='61.Kisi Ekle'>" title="<cf_get_lang no='61.Kisi Ekle'>" border="0" align="absmiddle"></a>
					</td>
					</tr>
					<tr>
						<td><cf_get_lang no='20.BCC'></td>
						<td height="20" id_"names">
							<input type="hidden" name="emp_id_bcc" id="emp_id_bcc">
							<cfif isDefined("attributes.mail_id") and (attributes.type eq 3)>
								<input type="text" id="emp_name_bcc" name="emp_name_bcc"  style="width:500px;" value="<cfif isDefined("attributes.mail_id") and (attributes.type eq 3)><cfoutput>#ListSort(ValueList(get_bcc.EMAIL,","),'textnocase','asc',',')#</cfoutput></cfif>" onFocus="AutoComplete_Create('emp_name_bcc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_bcc');">
							<cfelse>
								<cfinput type="text" id="emp_name_bcc" name="emp_name_bcc"  style="width:500px;" autocomplete="off" onFocus="AutoComplete_Create('emp_name_bcc','AB_EMAIL','AB_EMAIL','get_addressbook','','ID_KEY','emp_id_bcc');">
							</cfif>
							<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=send_mail.emp_id_bcc&names=send_mail.emp_name_bcc','list')"><img src="/images/plus_thin.gif" alt="<cf_get_lang no='61.Kisi Ekle'>" title="<cf_get_lang no='61.Kisi Ekle'>" border="0" align="absmiddle"></a>
						</td>
					</tr>
					<tr>
						<td><cf_get_lang_main no='68.Konu'></td>
						<td class="txtbold">
							<input style="width:500px;" type="text" name="subject" id="subject" <cfif isDefined("attributes.mail_id")> value="<cfif isDefined("attributes.direction_type") and (direction_type neq 'forward') and (direction_type neq 'template')>Re : <cfelseif isDefined("attributes.direction_type") and (direction_type eq 'forward')>FW : </cfif><cfoutput>#SELECT_MAIL.SUBJECT#</cfoutput>"</cfif>>
							<textarea name="template_icerigi" id="template_icerigi" style=" display:none;"></textarea>
						</td>
					</tr>
                    <tr>
                    	<td>Dijital Varlık</td>
                    	<td>
                            <input type="hidden" name="asset_id" id="asset_id" />
                            <input type="text" style="width:500px;" name="asset_name" id="asset_name" />
                            <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_asset_digital&module=correspondence&module_id=29&action=MAIL_ID&asset_archive=true&sbmt=1&field_name=asset_name&field_id=asset_id&is_multi_selection=1</cfoutput>','page','popup_asset_digital')"><img align="absmiddle" src="/images/plus_thin.gif" border="0" alt=""></a>
                        </td>
                        <td><cf_get_lang_main no="4.Proje"></td>
                        <td>
                            <cfset project_name = "">
                        	<cfif isdefined("attributes.mail_id") and len(attributes.mail_id) and not isdefined("attributes.relation_type")>
                                <cfquery name="get_rel" datasource="#dsn#">
                                    SELECT RELATION_TYPE_ID FROM MAILS_RELATION WHERE MAIL_ID = #attributes.mail_id# AND RELATION_TYPE = 'PROJECT_ID'
                                </cfquery>
                                <cfif get_rel.recordcount>
                                    <cfquery name="get_project_name" datasource="#dsn#">
                                        SELECT PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID = #get_rel.RELATION_TYPE_ID#
                                    </cfquery>
                                    <cfif get_project_name.recordcount>
                                        <cfif isdefined("xml_project_no")>
                                            <cfset project_name = get_project_name.PROJECT_NUMBER>
                                        <cfelse>
                                            <cfset project_name = get_project_name.PROJECT_HEAD>
                                        </cfif>
                                    <cfelse>
                                        <cfset project_name = "">
                                    </cfif>
                                </cfif>
                            </cfif>
                            <input type="hidden" name="project_id1" id="project_id1" value="<cfif isdefined("attributes.relation_type") and attributes.relation_type is 'PROJECT_ID'><cfoutput>#attributes.relation_type_id#</cfoutput><cfelseif  isdefined("attributes.mail_id") and len(attributes.mail_id) and len(project_name)><cfoutput>#get_rel.RELATION_TYPE_ID#</cfoutput></cfif>">
							<cfif isdefined("attributes.relation_type") and attributes.relation_type is 'PROJECT_ID'>
                            	<cfquery name="get_project_name" datasource="#dsn#">
                                	SELECT PROJECT_HEAD,PROJECT_NUMBER FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.relation_type_id#
                                </cfquery>
                                <cfif get_project_name.recordcount>
                                	<cfif isdefined("xml_project_no")>
                                    	<cfset project_name = get_project_name.PROJECT_NUMBER>
                                    <cfelse>
                                    	<cfset project_name = get_project_name.PROJECT_HEAD>
                                    </cfif>
                                <cfelse>
                                	<cfset project_name = "">
                                </cfif>
                            </cfif>
                            
                            <input type="text" name="project_head1"  id="project_head1" style="width:150px;" value="<cfoutput>#project_name#</cfoutput>">
							<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=send_mail.project_id1&project_head=send_mail.project_head1');"><img src="/images/plus_thin.gif" border="0" alt="Proje"  align="absmiddle"></a>
                        </td>
                    </tr>
			</table>
			<cf_box_footer>
			<table>
					<tr>
						<td>
						<cfif EMP_MAIL_LIST.ISACTIVE eq 1>
							<select name="mailbox_id" id="mailbox_id" onchange="get_active_account(this.value);">
								<cfoutput query="EMP_MAIL_LIST">
									<option value="#MAILBOX_ID#">#EMAIL#</option>
								</cfoutput>
							</select>
						  <input type="button" name="Gonder" value="Gönder" onclick="control(0);">
						  <input type="button" name="Kaydet" value=" Taslaklara Kaydet" onclick="control(3);">
						  <input type="submit" value="Gönder" style="display:none;"/>
						<cfelse>
						  <cf_get_lang dictionary_id="54833.Aktif Mail Hesabınız Yoktur">
						</cfif>
						</td>
					</tr>
			   </table>
		   </cf_box_footer>
		</cf_box>
		<cf_box>
	<cfif not isDefined("attributes.mail_id")> 
		<cfset body = ''>
		<cfmodule
			template="/fckeditor/fckeditor.cfm"
			toolbarSet="mailcompose"
			basePath="/fckeditor/"
			instanceName="message"
			value="#body#<br/><br/>#my_signature#"
			width="100%"
			height="395">
	<cfelse>
	<!--- mail forward ya da reply,allreplies yapılmışsa--->
		<cfquery name="get_attachmentlist" datasource="#dsn#">
			SELECT * FROM MAILS_ATTACHMENT WHERE MAIL_ID = #attributes.mail_id# AND SPECIAL_CODE IS NOT NULL
		</cfquery>
			<cfquery name="get_mail_body" datasource="#dsn#">
					SELECT 
						M.CONTENT_FILE,
						M.FOLDER_ID ,
						MB.EMPLOYEE_ID
					FROM 
						MAILS M,
						CUBE_MAIL MB
					WHERE 
						M.MAIL_ID = #attributes.mail_id# AND
						MB.MAILBOX_ID = M.MAILBOX_ID
			</cfquery>
            <input type="hidden" name="folder_id_" id="folder_id_" value="<cfoutput>#get_mail_body.FOLDER_ID#</cfoutput>" />
			<cfset body = "">
			<cfif get_mail_body.FOLDER_ID eq -3>
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator##get_mail_body.CONTENT_FILE#")>
					<cffile action="read" file="#emp_mail_path##session.ep.userid##dir_seperator#sendbox#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
				</cfif>
			<cfelseif get_mail_body.FOLDER_ID eq -2>
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator##get_mail_body.CONTENT_FILE#")>
					 <cffile action="read" file="#emp_mail_path##session.ep.userid##dir_seperator#deleted#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
				</cfif>
			<cfelseif get_mail_body.FOLDER_ID eq -1>
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator#draft#dir_seperator##get_mail_body.CONTENT_FILE#")>
					<cffile action="read" file="#emp_mail_path##session.ep.userid##dir_seperator#draft#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
				</cfif>
			<cfelse>
				<cfif FileExists("#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator##get_mail_body.CONTENT_FILE#")> 
					<cffile action="read" file="#emp_mail_path##session.ep.userid##dir_seperator#inbox#dir_seperator##get_mail_body.CONTENT_FILE#" variable="body" charset ="UTF-8">
				</cfif>
			</cfif>
			<cfset root=listfirst(fusebox.server_machine_list,';')>
			<cfif get_mail_body.FOLDER_ID eq -3>
				<cfset source_adress_ = "#root#/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/sendbox/attachments/">
			<cfelseif get_mail_body.FOLDER_ID eq -2>
				<cfset source_adress_ = "#root#/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/deleted/attachments/">
			<cfelseif get_mail_body.FOLDER_ID eq -1>
				<cfset source_adress_ = "#root#/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/draft/attachments/">
			<cfelse>
				<cfset source_adress_ = "#root#/documents/emp_mails/#get_mail_body.EMPLOYEE_ID#/inbox/attachments/">
			</cfif>
			<cfset m_code_list = ''>
			<cfset m_name_list = ''>
			<cfoutput query="get_attachmentlist">
				<cfset deger_ = mid(special_code,2,len(special_code)-2)>
				<cfset m_code_list = listappend(m_code_list,deger_)>
				<cfset m_name_list = listappend(m_name_list,attachment_file)>
			</cfoutput>
			<cfset body=replace(replacelist(replace(body,'src="cid:','src="#source_adress_#','all'),'#m_code_list#','#m_name_list#'),'<a','<a target="blank"','all')>
			<cfif get_mail_body.FOLDER_ID eq -1>
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="mailcompose"
                    basePath="/fckeditor/"
                    instanceName="message"
                    value="#body#"
                    width="99%"
                    height="395">
            <cfelse>
            	<cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="mailcompose"
                    basePath="/fckeditor/"
                    instanceName="message"
                    value="<br/><br/>#my_signature#<br/><br/><font color='red'>Original Mail</font><hr>#body#"
                    width="99%"
                    height="395">
            </cfif>
		</cfif>	
		</cf_box>
	</cfform>
	<script type="text/javascript">
	function control(type_gelen)
	{
		var oEditor = CKEDITOR.instances.message;
		document.getElementById('mail_content').value = oEditor.getData();
		var aaa = document.send_mail.emp_name.value;
		if (((aaa.indexOf('@') < 1) || (aaa.length < 6))&&type_gelen==0)
		{ 
		alert("<cf_get_lang_main no='1072.Lütfen geçerli bir e-mail adresi giriniz'>");
		return false;
		}	
		document.send_mail.type.value = type_gelen;
		get_wrk_message_div('CubeMail','Mail Gönderiliyor');
		document.send_mail.target = 'mail_send_frame';
		document.send_mail.submit();
	}
	
	function get_active_account(mb_id)
	{	
		var ext_params_ = mb_id;
		var deger_query = wrk_safe_query('get_active_account','dsn',10,ext_params_);
		if(deger_query.recordcount > 0)
			{
				var email_ = deger_query.EMAIL;
				document.getElementById('from').value = email_;
			}
	
	}
	
	function add_signature(s_id)
	{
		var oEditor = CKEDITOR.instances.message;
			<cfif GET_SIGN.recordcount>
				var icerik_ = eval("document.getElementById('imza_icerigi_" + s_id + "')").value;
				oEditor.setData(icerik_);
			</cfif>
	}
	
	function add_template(template_no)
	{
		var oEditor = CKEDITOR.instances.message;
			//var get_temp_ = wrk_safe_query('corr_get_temp_3','dsn',0,template_no);
				var icerik_ = eval("document.getElementById('template_icerigi_" + template_no + "')").value;
			//document.send_mail.template_icerigi.value = get_temp_.DETAIL;
			//var icerik_ = document.send_mail.template_icerigi.value;
			oEditor.insertHtml(icerik_);
			gizle(template_div);
	}
	var row_count=2;
	</script>
