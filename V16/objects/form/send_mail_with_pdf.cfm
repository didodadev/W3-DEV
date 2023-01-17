<cfif attributes.form_id contains ','>
	<cfset form_id = listlast(attributes.form_id)>
<cfelse>
	<cfset form_id = attributes.form_id>
</cfif>
<cfquery name="GET_FILE" datasource="#dsn3#">
	SELECT TEMPLATE_FILE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form_id#">
</cfquery>
<cfif get_file.is_standart eq 1>
	<cfset template_ ="/#get_file.template_file#">
	<cfset path = "#download_folder##get_file.template_file#">
<cfelse>
	<cfif ListLast(get_file.template_file,'.') is 'xml'>
		<cfset template_ ="print_files_xml.cfm">
	<cfelse>
		<cfset template_ ="#file_web_path#settings/#get_file.template_file#">
		<cfset path = "#download_folder##file_web_path#settings/#get_file.template_file#">
	</cfif>
</cfif>
<cfset path = "#download_folder##template_#">
<cfset path = replace(path,'/','\','all')>
<cfset path = replace(path,'\\','\','all')>
<cffile action="read" file="/#path#" variable="icerik_" charset="UTF-8">
<cfset icerik_ = wrk_content_clear_pdf(icerik_)>

<cfset filename1 = "#createuuid()#">
<cffile action="write" output="<cfprocessingdirective pageencoding='utf-8'>#icerik_#" file="#download_folder##file_web_path#settings/#filename1#.cfm" charset="UTF-8">
<cfsavecontent variable="content">
	<cfinclude template="/documents/settings/#filename1#.cfm">
</cfsavecontent>
<cfdocument format="pdf" overwrite="yes" filename="#upload_folder#reserve_files/#filename1#.pdf" orientation="portrait" backgroundvisible="false" pagetype="a4" unit="cm"  marginleft="0" marginright="0" margintop="0" marginbottom="0" fontembed="no">
	<cfoutput>
		#content#
	</cfoutput>
</cfdocument>
<cfif isdefined("attributes.print_type") and isdefined("attributes.action_id")>
	<cfset send_id_list = "">
	<cfset send_mail_list = "">
	<cfif attributes.print_type eq 91>
		<cfquery name="GET_ORDER_" datasource="#DSN3#">
			SELECT
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				ORDER_HEAD
			FROM
				ORDERS
			WHERE
				ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfset send_mail_subject = get_order_.order_head>
		<cfif len(get_order_.partner_id)>
			<cfquery name="GET_PARTNER_MAIL" datasource="#DSN#">
				SELECT
					C.COMPANY_EMAIL,
					CP.COMPANY_PARTNER_EMAIL
				FROM
					COMPANY C,
					COMPANY_PARTNER CP
				WHERE
					C.COMPANY_ID = CP.COMPANY_ID AND
					CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_.partner_id#">
			</cfquery>
			<cfif len(get_partner_mail.company_partner_email)>
				<cfset send_id_list = "par-#get_order_.partner_id#">
				<cfset send_mail_list = "#get_partner_mail.company_partner_email#">
			<cfelseif len(get_partner_mail.company_email)>
				<cfset send_id_list = "comp-#get_order_.company_id#">
				<cfset send_mail_list = "#get_partner_mail.company_email#">
			</cfif>
		</cfif>
		<cfif len(get_order_.consumer_id)>
			<cfquery name="GET_CONSUMER_MAIL" datasource="#DSN#">
				SELECT
					CONSUMER_EMAIL
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_.consumer_id#">
			</cfquery>
			<cfif len(get_consumer_mail.consumer_email)>
				<cfset send_id_list = "con-#get_order_.consumer_id#">
				<cfset send_mail_list = "#get_consumer_mail.consumer_email#">
			</cfif>
		</cfif>
	</cfif>
    <cfif attributes.print_type eq 90>
		<cfquery name="GET_OFFER_" datasource="#DSN3#">
			SELECT
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				OFFER_HEAD
			FROM
				OFFER
			WHERE
				OFFER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
		</cfquery>
		<cfset send_mail_subject = get_offer_.offer_head>
		<cfif len(get_offer_.partner_id)>
			<cfquery name="GET_PARTNER_MAIL" datasource="#DSN#">
				SELECT
					C.COMPANY_EMAIL,
					CP.COMPANY_PARTNER_EMAIL
				FROM
					COMPANY C,
					COMPANY_PARTNER CP
				WHERE
					C.COMPANY_ID = CP.COMPANY_ID AND
					CP.PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_.partner_id#">
			</cfquery>
			<cfif len(get_partner_mail.company_partner_email)>
				<cfset send_id_list = "par-#get_offer_.partner_id#">
				<cfset send_mail_list = "#get_partner_mail.company_partner_email#">
			<cfelseif len(get_partner_mail.company_email)>
				<cfset send_id_list = "comp-#get_offer_.company_id#">
				<cfset send_mail_list = "#get_partner_mail.company_email#">
			</cfif>
		</cfif>
		<cfif len(get_offer_.consumer_id)>
			<cfquery name="GET_CONSUMER_MAIL" datasource="#DSN#">
				SELECT
					CONSUMER_EMAIL
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_.consumer_id#">
			</cfquery>
			<cfif len(get_consumer_mail.consumer_email)>
				<cfset send_id_list = "con-#get_offer_.consumer_id#">
				<cfset send_mail_list = "#get_consumer_mail.consumer_email#">
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfset sender = "#session.ep.company#<#session.ep.company_email#>">
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfset sender = "#session.pp.our_name#<#session.pp.our_company_email#>">
<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>
	<cfset sender = "#session.cp.our_name#<#session.cp.our_company_email#>">
<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
	<cfset sender = "#session.ww.our_name#<#session.ww.our_company_email#>">
</cfif>
<cfquery name="GET_MAILFROM" datasource="#DSN#">
	SELECT
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME,
			EMPLOYEE_EMAIL
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,COMPANY_PARTNER_EMAIL
		<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>NAME,SURNAME,EMAIL
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>NAME,SURNAME,EMAIL
		</cfif>
	FROM		
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
			EMPLOYEES
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER
		<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>EMPLOYEES_APP
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>CONSUMER
		</cfif>
	WHERE
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
		<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
		</cfif>
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>AND EMPLOYEE_EMAIL IS NOT NULL
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>AND COMPANY_PARTNER_EMAIL IS NOT NULL
		<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>AND EMAIL IS NOT NULL
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>AND CONSUMER_EMAIL IS NOT NULL
		</cfif>	
</cfquery>
<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfset sender = "#get_mailfrom.employee_name# #get_mailfrom.employee_surname#<#get_mailfrom.employee_email#>">
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfset sender = "#get_mailfrom.company_partner_name# #get_mailfrom.company_partner_surname#&lt;#get_mailfrom.company_partner_email#&gt;">
<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>
	<cfset sender = "#get_mailfrom.name# #get_mailfrom.surname#&lt;#get_mailfrom.email#&gt;">
</cfif>
<cfif isdefined("x_mail_list") and listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfquery name="GET_DEP_NAME" datasource="#DSN#">
        SELECT          
            BRANCH.BRANCH_EMAIL,
            DEPARTMENT.DEPARTMENT_EMAIL
        FROM
            EMPLOYEE_POSITIONS,
            DEPARTMENT,
            BRANCH
        WHERE
            EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
            DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
            EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfif x_mail_list eq 0 and len(get_dep_name.department_email)>
		<cfset sender = get_dep_name.department_email>
	<cfelseif x_mail_list eq 1 and len(get_dep_name.branch_email)>
		<cfset sender = get_dep_name.branch_email>
	<cfelseif x_mail_list eq 2>
		<cfset sender = session.ep.company_email>
	</cfif>
</cfif>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='57475.Mail Gönder'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="mail_form" action="#request.self#?fuseaction=objects.popup_mail_act" method="post" enctype="multipart/form-data">
		<table>
		<tr>
			<td><input type="hidden" name="filename" id="filename" value="<cfoutput>#filename1#</cfoutput>" /></td>
			<td><input type="checkbox" name="trail" id="trail" value="1" <cfif isdefined("attributes.trail") and attributes.trail>checked</cfif>/> <cf_get_lang dictionary_id="33129.Maile Şirket Logo ve Antetini Ekle"></td>
		</tr>
		<tr>
			<td width="80">&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id='53155.Kimden'></td>
			<td>
				<input type="text" name="mailfrom" id="mailfrom" value="<cfoutput>#sender#</cfoutput>" readonly="readonly"  style="width:450px;" maxlength="50">
			</td>
		</tr>
		<tr>
			<td width="80">&nbsp;&nbsp;<cf_get_lang dictionary_id='57924.Kime'> *</td>
			<td>
				<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#send_id_list#</cfoutput>" style="width:300px;">
				<input type="text" name="emp_name" id="emp_name" value="<cfoutput>#send_mail_list#</cfoutput>" style="width:450px;">
			</td>	
			<td>
				<cfif not isdefined("session.cp") and not isDefined('session.pp')>
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=mail_form.emp_id&names=mail_form.emp_name')"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></a>
				</cfif>
			</td>
		</tr>
		 <tr>
			<td width="80">&nbsp;&nbsp;<cf_get_lang dictionary_id='57556.CC'></td>
			<td>
				<input type="hidden" name="emp_id_cc" id="emp_id_cc" style="width:300px;" value="">
				<input type="text" name="emp_name_cc" id="emp_name_cc" style="width:450px;" value="">
			</td>	
			<td>
				<cfif not isdefined("session.cp")>
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=mail_form.emp_id_cc&names=mail_form.emp_name_cc')"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></a>
				</cfif>
			</td>
		</tr>
		 <tr>
			<td width="80">&nbsp;&nbsp;<cf_get_lang no='717.BCC'></td>
			<td>
				<input type="hidden" name="emp_id_bcc" id="emp_id_bcc" style="width:300px;" value="">
				<input type="text" name="emp_name_bcc" id="emp_name_bcc" style="width:450px;" value="">
			</td>	
			<td>
				<cfif not isdefined("session.cp")>
					<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=mail_form.emp_id_bcc&names=mail_form.emp_name_bcc')"><img src="/images/plus_thin.gif" alt="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></a>
				</cfif>
			</td>
		</tr>
		<tr>
			<td width="80">&nbsp;&nbsp;<cf_get_lang_main no='68.Konu'> *</td>
			<td><input type="text" name="subject" id="subject" value="<cfoutput>#send_mail_subject#</cfoutput>"  style="width:450px;" maxlength="255"></td>
		</tr>
		<tr>
			<td>&nbsp;&nbsp;<cf_get_lang_main no='279.Dosya'></td>
			<td><input type="file" name="attachment" id="attachment" style="width:300px;"></td>
		</tr>
		<tr>
            <td><cf_get_lang dictionary_id='57629.Açıklama'></td>
            <td> 
                <div id="fckedit">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="mail_detail"
                        valign="top"
                        value=""
                        width="435"
                        height="180">
                </div>
            </td>
		</tr>
	</table>
	<cf_popup_box_footer>
		<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
            <input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>" />
            <input type="hidden" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>" />
        </cfif>
        <input type="hidden" name="icerik" id="icerik" value="">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58743.Gönder'></cfsavecontent>
        <cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='control()'>
	</cf_popup_box_footer>
	</cfform>
</cf_popup_box> 

<script type="text/javascript">
	function control()
	{
		if(document.getElementById('emp_name').value==''||document.getElementById('subject').value=='')
		{
			alert("<cf_get_lang dictionary_id='29722.zorunlu alanları doldurunuz'>")	;
			return false;
		}	
	}
</script>

<cffunction name="wrk_content_clear_pdf" output="false" returntype="string">
	<cfargument name="cont" required="true" type="string" default="">
		<cfset cont = ReReplaceNoCase(cont,"<cfdocument[^>]*>", "", "ALL")>
		<cfset cont = ReReplaceNoCase(cont,"</cfdocument>", "", "ALL")>
	<cfreturn cont>
</cffunction>
