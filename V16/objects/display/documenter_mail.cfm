<cf_xml_page_edit>
<!---
Description :
   convert html pages to mail
Parameters : none
syntax1 : #request.self#?fuseaction=objects.popup_mail
Note1 : Settle '<!-- sil -->' statement into the start and the end point of unnecessary part of the page
--->
<script language="JavaScript">
	function kontrol(){			
		if (document.mail_form.emp_name.value == ''){
			alert("<cf_get_lang dictionary_id ='33824.Kime alanı boş olmamalı'> !!!");
			return false;
		}
		else
		if (document.mail_form.subject.value == ''){
			alert("<cf_get_lang dictionary_id ='33825.Konu alanı boş olmamalı'>!!!");
			return false;
		}
		return true;
	}
</script>
<cfif isdefined("attributes.FORM_TYPE")>
	<cfif attributes.FORM_TYPE contains ','>
        <cfset FORM_TYPE = listlast(attributes.FORM_TYPE)>
    <cfelse>
        <cfset FORM_TYPE = attributes.FORM_TYPE>
    </cfif>
    <cfquery name="GET_FILE" datasource="#dsn3#">
        SELECT TEMPLATE_FILE,IS_STANDART,NAME FROM SETUP_PRINT_FILES WHERE FORM_ID = #FORM_TYPE#
    </cfquery>
    <cfif GET_FILE.NAME contains 'PDF' or GET_FILE.NAME contains 'pdf'>
		<cfif GET_FILE.is_standart eq 1>
            <cfset template_ ="/#GET_FILE.template_file#">
            <cfset path = "#download_folder##GET_FILE.template_file#">
        <cfelse>
            <cfif ListLast(GET_FILE.template_file,'.') is 'xml'>
                <cfset template_ ="print_files_xml.cfm">
            <cfelse>
                <cfset template_ ="#file_web_path#settings/#GET_FILE.template_file#">
                <cfset path = "#download_folder##file_web_path#settings/#GET_FILE.template_file#">
            </cfif>
        </cfif>
        <cfset path = "#download_folder##template_#">
        <cfset path = replace(path,'/','\','all')>
        <!---<cfset path = replace(path,'\\','\','all')>--->
        <cffile action="read" file="#path#" variable="icerik_" charset="UTF-8">
        <cfset icerik_ = wrk_content_clear_pdf(icerik_)>
        <cfset filename1 = "#createuuid()#">
        <cffile action="write" output="<cfprocessingdirective pageencoding='utf-8'>#icerik_#" file="#download_folder##file_web_path#settings/#filename1#.cfm" charset="UTF-8">
        <cfsavecontent variable="content">
            <!---<cfinclude template="../../documents/settings/#filename1#.cfm">--->
            <cfinclude template="#file_web_path#settings/#filename1#.cfm">
        </cfsavecontent>
        <cfdocument format="pdf" overwrite="yes" filename="#upload_folder#reserve_files/#filename1#.pdf" orientation="portrait" backgroundvisible="false" pagetype="a4" unit="cm"  marginleft="0" marginright="0" margintop="0" marginbottom="0" fontembed="no">
            <cfoutput>
                #content#
            </cfoutput>
        </cfdocument>
    </cfif>
</cfif>

<cfset send_id_list = "">
<cfset send_mail_list = "">
<cfset send_mail_subject = "">
<cfparam name="mail_body" default="">
<cfif isdefined("attributes.print_type") and isdefined("attributes.action_id")>
	<cfif attributes.print_type eq 91>
		<cfquery name="get_order_" datasource="#dsn3#">
			SELECT
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				ORDER_HEAD
			FROM
				ORDERS
			WHERE
				ORDER_ID = #attributes.action_id#
		</cfquery>
		<cfset send_mail_subject = get_order_.ORDER_HEAD>
		<cfif len(get_order_.PARTNER_ID)>
			<cfquery name="get_partner_mail" datasource="#dsn#">
				SELECT
					C.COMPANY_EMAIL,
					CP.COMPANY_PARTNER_EMAIL
				FROM
					COMPANY C,
					COMPANY_PARTNER CP
				WHERE
					C.COMPANY_ID = CP.COMPANY_ID AND
					CP.PARTNER_ID = #get_order_.PARTNER_ID#
			</cfquery>
			<cfif len(get_partner_mail.COMPANY_PARTNER_EMAIL)>
				<cfset send_id_list = "par-#get_order_.PARTNER_ID#">
				<cfset send_mail_list = "#get_partner_mail.COMPANY_PARTNER_EMAIL#">
			<cfelseif len(get_partner_mail.COMPANY_EMAIL)>
				<cfset send_id_list = "par-#get_order_.PARTNER_ID#">
				<cfset send_mail_list = "#get_partner_mail.COMPANY_PARTNER_EMAIL#">
			</cfif>
		</cfif>
		<cfif len(get_order_.CONSUMER_ID)>
			<cfquery name="get_consumer_mail" datasource="#dsn#">
				SELECT
					CONSUMER_EMAIL
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID = #get_order_.CONSUMER_ID#
			</cfquery>
			<cfif len(get_consumer_mail.CONSUMER_EMAIL)>
				<cfset send_id_list = "con-#get_order_.CONSUMER_ID#">
				<cfset send_mail_list = "#get_consumer_mail.CONSUMER_EMAIL#">
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
<cfquery name="GET_MAILFROM" datasource="#dsn#">
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
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID=#session.ep.USERID#
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID=#session.pp.USERID#
		<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>EMPAPP_ID=#session.cp.USERID#
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>CONSUMER_ID=#session.ww.USERID#
		</cfif>
		<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>AND EMPLOYEE_EMAIL IS NOT NULL
		<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>AND COMPANY_PARTNER_EMAIL IS NOT NULL
		<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>AND EMAIL IS NOT NULL
		<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>AND CONSUMER_EMAIL IS NOT NULL
		</cfif>	
</cfquery>
<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfset sender = "#GET_MAILFROM.EMPLOYEE_NAME# #GET_MAILFROM.EMPLOYEE_SURNAME#<#GET_MAILFROM.EMPLOYEE_EMAIL#>">
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfset sender = "#GET_MAILFROM.COMPANY_PARTNER_NAME# #GET_MAILFROM.COMPANY_PARTNER_SURNAME#&lt;#GET_MAILFROM.COMPANY_PARTNER_EMAIL#&gt;">
<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>
	<cfset sender = "#GET_MAILFROM.NAME# #GET_MAILFROM.SURNAME#&lt;#GET_MAILFROM.EMAIL#&gt;">
</cfif>
<cfif isdefined("x_mail_list") and listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfquery name="get_dep_name" datasource="#dsn#">
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
				EMPLOYEE_POSITIONS.POSITION_CODE = #session.ep.position_code#
	</cfquery>
	<cfif x_mail_list eq 0 and len(get_dep_name.DEPARTMENT_EMAIL)>
		<cfset sender = get_dep_name.DEPARTMENT_EMAIL>
	<cfelseif x_mail_list eq 1 and len(get_dep_name.BRANCH_EMAIL)>
		<cfset sender = get_dep_name.BRANCH_EMAIL>
	<cfelseif x_mail_list eq 2>
		<cfset sender = session.ep.company_email>
	</cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57475.Mail Gönder'></cfsavecontent>
	<cf_box title="#message#">
		<cfform name="mail_form" action="#request.self#?fuseaction=objects.popup_mail_act" method="post">
		<input type="hidden" name="filename" value="<cfoutput><cfif isdefined("filename1") and len(filename1)><cfif GET_FILE.NAME contains 'PDF' or GET_FILE.NAME contains 'pdf'>#filename1#</cfif></cfif></cfoutput>"/>
		<cfoutput>
			<input type="hidden" name="#listfirst(session.dark_mode,":")#"  value="#listlast(session.dark_mode,":")#">
		</cfoutput>
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					
					<div class="form-group" id="item-emp_name">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57924.Kime'> *</label>
						</div>
						<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="emp_id" id="emp_id" value="<cfoutput>#send_id_list#</cfoutput>">
								<input type="text" name="emp_name" id="emp_name" value="<cfoutput>#send_mail_list#</cfoutput>">
								<cfif not isdefined("session.cp") and not isDefined('session.pp')>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=mail_form.emp_id&names=mail_form.emp_name')" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-emp_name_cc">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='47860.CC'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="emp_id_cc" id="emp_id_cc" value="<cfoutput>#send_id_list#</cfoutput>">
								<input type="text" name="emp_name_cc" id="emp_name_cc" value="<cfoutput>#send_mail_list#</cfoutput>">
								<cfif not isdefined("session.cp")>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=mail_form.emp_id_cc&names=mail_form.emp_name_cc')" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-emp_name_bcc">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='32945.BCC'></label>
						</div>
						<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="emp_id_bcc" id="emp_id_bcc" value="<cfoutput>#send_id_list#</cfoutput>">
								<input type="text" name="emp_name_bcc" id="emp_name_bcc" value="<cfoutput>#send_mail_list#</cfoutput>">
								<cfif not isdefined("session.cp")>
								<span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.addressbook&mail_id=mail_form.emp_id_bcc&names=mail_form.emp_name_bcc')" title="<cf_get_lang dictionary_id ='32892.Kisi Ekle'>"></span>
								</cfif>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-subject">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='57480.Konu'> *</label>
						</div>
						<div class="col col-9 col-md-9 col-sm-8 col-xs-12">
							<input type="text" name="subject" id="subject" value="<cfoutput>#send_mail_subject#</cfoutput>" maxlength="255">
						</div>
					</div>

					<div class="form-group">
						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id='53155.Kimden'></label>
						</div>
						<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
							<input type="text" name="mailfrom" id="mailfrom" readonly="readonly" value="<cfoutput>#sender#</cfoutput>" maxlength="50">
						</div>

						<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
							<label><cf_get_lang dictionary_id="33129.Maile Şirket Logo ve Antetini Ekle"></label>
						</div>
						<div class="input-group">
							<input type="checkbox" name="trail" id="trail" value="1" <cfif isdefined("attributes.trail") and attributes.trail>checked</cfif>/>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<div id="fckedit">
				<cfif isdefined('attributes.mail_id')>
					<cfset mail_body = HTMLCodeFormat(mail_body)>
				</cfif>
				<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarset="Basic"
					basepath="/fckeditor/"
					instancename="mail_detail"
					valign="top"
					value="#mail_body#"
					width="99%"
					height="400">
			</div>
			<cf_box_footer>
				<div>
					<cfif isdefined("attributes.asset_id") and len(attributes.asset_id)>
						<input type="hidden" name="asset_id" id="asset_id" value="<cfoutput>#attributes.asset_id#</cfoutput>" />
						<input type="text" name="module" id="module" value="<cfoutput>#attributes.module#</cfoutput>" />
					</cfif>
				</div>
				<div>
					<input type="hidden" name="icerik" id="icerik" value="">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58743.Gönder'></cfsavecontent>
				</div>
				<div>
					<cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='control()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box> 
</div>
<cfif isdefined("attributes.extra_parameters") and len(attributes.extra_parameters)>
	<script language="JavaScript">
		mail_form.emp_name.value = opener.<cfoutput>#attributes.extra_parameters#</cfoutput>.value;
	</script>
</cfif>
<script language="javascript">
	<cfif isdefined("attributes.special_module")>
		<cfif attributes.module is 'action_page_div'>

			mail_form.icerik.value = '<link rel=stylesheet href=css/assets/template/style.css type=text/css>' + window.opener.document.querySelectorAll('.ListContent, .ReportContent')[0].innerHTML + '';
			<!--- if(window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML != undefined)
			{
				
				mail_form.icerik.value = '<link rel=stylesheet href=css/win_ie_1.css type=text/css>' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '';
			}
			else
			{
				mail_form.icerik.value = '<link rel=stylesheet href=css/win_ie_1.css type=text/css>' + window.opener.window.frames['<cfoutput>#attributes.module#</cfoutput>'].document.getElementById('<cfoutput>#attributes.module#</cfoutput>').innerHTML + '';
			} --->
			//mail_form.icerik.value = '<link rel=stylesheet href=css/win_ie_1.css type=text/css>' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '';
		<cfelse>
//			if(window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML != undefined)
			try
			{
				mail_form.icerik.value = '<!-- sil --><link rel=stylesheet href=css/win_ie_1.css type=text/css>' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '<!-- sil -->';
			}
//			else
			catch(e)
			{
				mail_form.icerik.value = '<!-- sil --><link rel=stylesheet href=css/win_ie_1.css type=text/css>' + window.opener.window.frames['<cfoutput>#attributes.module#</cfoutput>'].document.getElementById('<cfoutput>#attributes.module#</cfoutput>').innerHTML + '<!-- sil -->';
			}
			//mail_form.icerik.value = '<!-- sil --><link rel=stylesheet href=css/win_ie_1.css type=text/css>' + window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML + '<!-- sil -->';
		</cfif>
	<cfelse>
		if(findObj("<cfoutput>#attributes.module#</cfoutput>",opener.document)) {
			mail_form.icerik.value = window.opener.<cfoutput>#attributes.module#</cfoutput>.innerHTML;
		}
		else
		{	/* 
				Aşağıdakii classların html'ini alır.
				Eğer sayfada görüntülenmesini istemiyorsak class'ına no-shared-content verilir.
			*/
			shared_content = '<style>.shared-content{padding:5px;} .shared-content p { margin: 0; font-size: 14pt; font-weight: 600; } .shared-content .no-shared-content{display:none;} .shared-content table { margin-bottom: 15px; border-collapse: collapse; } .shared-content table td { border: 1px solid; padding: 3px; }</style> <div class="shared-content">';
			window.opener.$(".tableBoxOuter, .book, .basket_list , .report_list , .ListContent , .collectedPrint, .printThis, .ajax_list, .ui-info-bottom, .ui-card, .ui-table-list, .icmal_css").each( function(index, element){
				
				shared_content+= "<p>"+$(element).closest(".portBox").find('a').html()+"</p>";
				shared_content+= $(element).parent().html();
			});
			shared_content += '</div>';
			mail_form.icerik.value = shared_content;
		}
	</cfif>
	
	function control()
	{
		if(document.getElementById('emp_name').value==''||document.getElementById('subject').value=='')
		{
			alert("<cf_get_lang dictionary_id='29722.zorunlu alanları doldurunuz'>")	;
			return false;
		}
		<cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
			mail_form.icerik.value = '<!-- sil -->' + stripScripts(mail_form.icerik.value.replace(/<!-- sil -->/g,'')<cfif isdefined("attributes.noShow") and len(attributes.noShow)>,"<cfoutput>#attributes.noShow#</cfoutput>"</cfif>);
		</cfif>
	}
</script>

<cffunction name="wrk_content_clear_pdf" output="false" returntype="string">
    <cfargument name="cont" required="true" type="string" default="">
        <cfset cont = ReReplaceNoCase(cont,"<cfdocument[^>]*>", "", "ALL")>
        <cfset cont = ReReplaceNoCase(cont,"</cfdocument>", "", "ALL")>
    <cfreturn cont>
</cffunction>
