<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact ="correspondence.cubemail">
<!---<cfif isdefined("attributes.relation_type_id")>
    <cfquery name="get_rel" datasource="#dsn#">
        SELECT MAIL_ID FROM MAILS_RELATION WHERE RELATION_TYPE_ID = #attributes.relation_type_id# AND RELATION_TYPE = '#attributes.relation_type#'
    </cfquery>
    <cfset attributes.mail_id = get_rel.mail_id>
</cfif>--->
<cfif not isDefined("attributes.mail_id") and not isdefined("attributes.relation_type_id")>
	<cfset attributes.mail_id=attributes.id>
</cfif>
<cfinclude template="../query/mail_control.cfm">
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
     <cf_box title="#htmleditformat(SELECT_MAIL.SUBJECT)#" closable="0" collapsable="1">
        <table>
          <cfoutput query="SELECT_MAIL">
            <tr>
              <td width="75" class="txtbold"><cf_get_lang no='26.Gönderen'></td>
              <td id="sender">
              #replacelist(mail_from,'<,>',' , ')#
              <cfset sender_ =  replacelist(mail_from,'<,>',' , ')>
              <cfset sender_type = ''>
            <cfset sender_id = ''>
            
            <cfquery name="check_employee" datasource="#dsn#" maxrows="1">
                SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_EMAIL = '#MAIL_FROM#'
            </cfquery>
            <cfif check_employee.recordcount>
                <cfset sender_type = 'employee'>
                <cfset sender_id = '#check_employee.EMPLOYEE_ID#'>
            <cfelse>
                <cfquery name="check_consumer" datasource="#dsn#" maxrows="1">
                    SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_EMAIL = '#MAIL_FROM#'
                </cfquery>
                <cfif check_consumer.recordcount>
                    <cfset sender_type = 'consumer'>
                    <cfset sender_id = '#check_consumer.CONSUMER_ID#'>
                <cfelse>
                    <cfquery name="check_partner" datasource="#dsn#" maxrows="1">
                        SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '#MAIL_FROM#'
                    </cfquery>
                    <cfif check_partner.recordcount>
                        <cfset sender_type = 'partner'>
                        <cfset sender_id = '#check_partner.PARTNER_ID#'>
                    <cfelse>
                        <cfquery name="check_company" datasource="#dsn#" maxrows="1">
                            SELECT COMPANY_ID FROM COMPANY WHERE COMPANY_EMAIL = '#MAIL_FROM#'
                        </cfquery>
                        <cfif check_company.recordcount>
                            <cfset sender_type = 'company'>
                            <cfset sender_id = '#check_company.COMPANY_ID#'>
                        </cfif>
                    </cfif>
                </cfif>
            </cfif>
            <cfif len(sender_id)>
                - 
                <strong>Gönderen İlişkisi</strong> : 
                    <cfoutput>
                        <cfif sender_type is 'employee'>
                            Çalışan : #get_emp_info(sender_id,0,1)#
                        <cfelseif sender_type is 'consumer'>
                            Bireysel Üye : #get_cons_info(sender_id,1,1)#
                        <cfelseif sender_type is 'partner'>
                            Kurumsal Üye Çalışanı : #get_par_info(sender_id,0,0,1)#
                        <cfelseif sender_type is 'company'>
                            Kurumsal Üye : #get_par_info(sender_id,1,1,1)#
                        </cfif>
                    </cfoutput>
            <cfelse>
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=correspondence.popup_new_rec&sender=#sender_#','list')"><img src="../images/add_1.gif" title="Kişi Ekle" align="absmiddle" /></a>
            </cfif>
              </td>
            </tr>
            <tr>
              <td width="75" class="txtbold"><cf_get_lang_main no='330.Tarih'></td>
              <td>
                <cfif FOLDER_ID eq -3>
					<cfif len(REAL_DATE)>
						#dateformat(dateadd("h",session.ep.time_zone,REAL_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,REAL_DATE),timeformat_style)#
					<cfelse>
						#dateformat(dateadd("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#
					</cfif>
				<cfelseif FOLDER_ID eq -4>
					<cfif len(REAL_DATE)>
						#dateformat(REAL_DATE,dateformat_style)# #TimeFormat(REAL_DATE,timeformat_style)#
					<cfelse>
						#dateformat(dateadd("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#
					</cfif>
				<cfelse>
					<cfif len(REAL_DATE)>
						#dateformat(REAL_DATE,dateformat_style)# #TimeFormat(REAL_DATE,timeformat_style)#
					<cfelse>
						#dateformat(dateadd("h",session.ep.time_zone,RECORD_DATE),dateformat_style)# #TimeFormat(dateadd("h",session.ep.time_zone,RECORD_DATE),timeformat_style)#
					</cfif>
				</cfif>
              </td>
            </tr>
            <tr>
              <td class="txtbold"><cf_get_lang_main no='512.TO'></td>
        <td id="to_mails">#listfirst(replacelist(mail_to,'<,>',' , '),',')#</td>
        
            </tr>
            <tr>
              <td class="txtbold"><cf_get_lang_main no='144.CC'></td>
              <td id="cc_mails">
               <cfif attributes.type eq 0>
               		#ListSort(ValueList(SELECT_MAIL.MAIL_CC,","),'textnocase','asc',',')#
               <cfelseif attributes.type eq 1>
               <cfset mails_cc = "">
                <cfloop from="1" to="#listlen(MAIL_CC)#" index="sayac">
                    <cfif FindNoCase("<",ListGetAt(MAIL_CC,sayac,','),1) or FindNoCase("<",ListGetAt(MAIL_CC,sayac,','),1)>
                        <cfset mails_cc = Replace(mails_cc,'<',' ','all')>
                        <cfset mails_cc = Replace(mails_cc,'>',' ','all')>
                        <cfset mails_cc = ListAppend(mails_cc,ListGetAt(MAIL_CC,sayac,','),',')>
                        <cfset mails_cc = Replace(mails_cc,'<',' ','all')>
                        <cfset mails_cc = Replace(mails_cc,'>',' ','all')>
                    <cfelse>
                        <cfset mails_cc = ListAppend(mails_cc,ListGetAt(MAIL_CC,sayac,','),',')>
                    </cfif>
                </cfloop>
                #mails_cc#
               </cfif>
              </td>
            </tr>
            <tr>
              <td class="txtbold"><cf_get_lang no='20.BCC'></td>
              <td id="bcc_mails">#ListSort(ValueList(get_bcc.email,","),'textnocase','asc',',')#</td>
            </tr>
            <tr>
              <td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
              <td id="subject">#htmleditformat(SUBJECT)#</td> <!---Bu kısım konuyu getiriyor--->
            </tr>
            <tr>
              <td class="txtbold"><cf_get_lang no='49.Attechment'></td>
              <td id="attachment">#attach#</td>
            </tr>
            </cfoutput>
            <cfquery name="get_related_item" datasource="#DSN#">
                SELECT
                    1 AS TYPE,
                    PR.PROJECT_ID ACTION_ID,
                    <cfif isdefined("xml_project_no") and xml_project_no eq 1>
                    	PR.PROJECT_NUMBER ACTION_NAME
                    <cfelse>
                    	PR.PROJECT_HEAD ACTION_NAME
                    </cfif>
                FROM 
                    MAILS_RELATION MR,
                    PRO_PROJECTS PR
                WHERE 
                    MR.MAIL_ID= #attributes.mail_id# AND
                    MR.RELATION_TYPE ='PROJECT_ID' AND 
                    PR.PROJECT_ID = MR.RELATION_TYPE_ID 
                UNION ALL
                SELECT
                    2 AS TYPE,
                    C.CONSUMER_ID ACTION_ID,
                    C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME ACTION_NAME
                FROM 
                    MAILS_RELATION MR ,
                    CONSUMER C
                WHERE 
                    MR.MAIL_ID=#attributes.mail_id# AND
                    MR.RELATION_TYPE ='CONSUMER_ID' AND 
                    C.CONSUMER_ID = MR.RELATION_TYPE_ID
                UNION ALL
                SELECT
                    3 AS TYPE,
                    C.COMPANY_ID ACTION_ID,
                    C.FULLNAME ACTION_NAME
                FROM 
                    MAILS_RELATION MR ,
                    COMPANY C
                WHERE 
                    MR.MAIL_ID=#attributes.mail_id# AND
                    MR.RELATION_TYPE ='COMPANY_ID' AND 
                    C.COMPANY_ID = MR.RELATION_TYPE_ID 
                UNION ALL
                SELECT
                    4 AS TYPE,
                    O.OFFER_ID ACTION_ID,
                    O.OFFER_HEAD ACTION_NAME
                FROM 
                    MAILS_RELATION MR ,
                    #dsn3_alias#.OFFER O
                WHERE 
                    MR.MAIL_ID=#attributes.mail_id# AND
                    MR.RELATION_TYPE ='OFFER_ID' AND 
                    O.OFFER_ID = MR.RELATION_TYPE_ID AND
                    MR.OUR_COMPANY_ID = #session.ep.company_id#
            </cfquery>
            <tr>
                <td class="txtbold"><cf_get_lang_main no="1921.İlişkiler"></td>
                <td>
                <cfoutput query="get_related_item" group="type">				
                    <cfif type eq 1>
                        <strong>Proje:</strong>
                    <cfelseif type eq 3>
                        <strong>Kurumsal Üye:</strong> 
                    <cfelseif type eq 2>
                        <strong>Bireysel Üye:</strong> 
					<cfelseif type eq 4>
                        <strong>Teklif:</strong> 
                    </cfif>
                    <cfoutput>
                        <cfif type eq 1>
                             <a href="#request.self#?fuseaction=project.projects&event=det&id=#ACTION_ID#" target="_new" class="altbar">#ACTION_NAME#,</a>
                        <cfelseif type eq 3>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#ACTION_ID#','medium');" class="altbar">#ACTION_NAME#,</a>
                        <cfelseif type eq 2>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#ACTION_ID#','medium')" class="altbar">#ACTION_NAME#,</a>
                        <cfelseif type eq 4>
                            <a href="#request.self#?fuseaction=sales.list_offer&event=upd&offer_id=#ACTION_ID#" target="_new" class="altbar">#ACTION_NAME#,</a>
                        </cfif>
                    </cfoutput>
                </cfoutput>
                </td>
            </tr>
          </table>			  
     </cf_box>
     <iframe frameborder="0" src="<cfoutput>#request.self#?fuseaction=correspondence.popup_get_cubemail_body&mail_id=#attributes.mail_id#</cfoutput>&iframe=1" scrolling="no" style="width:100%; height:450px;"></iframe>
<cfif SELECT_MAIL.IS_READ eq 0>
  <cfquery name="UPDATE_MAIL" datasource="#DSN#">
  	UPDATE MAILS SET IS_READ = 1 WHERE MAIL_ID	= #attributes.mail_id#
  </cfquery>
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
	<cfquery name="get_mail_new_count" dbtype="query">
		SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #select_mail.folder_id#
	</cfquery>
	<cfquery name="get_mail_new_count_read" dbtype="query">
		SELECT MAIL_ID FROM get_mail_counts WHERE FOLDER_ID = #select_mail.folder_id# AND (IS_READ = 0 OR IS_READ IS NULL)
	</cfquery>
	<cfoutput>
		<script type="text/javascript">
			<cfif (not isdefined("attributes.cpid")) or (not isdefined("attributes.cid"))>
				<cfif select_mail.folder_id lt 0>
					if(document.getElementById("static_#-1*select_mail.folder_id#") != undefined)
						document.getElementById("static_#-1*select_mail.folder_id#").innerHTML = '(#get_mail_new_count_read.recordcount#/#get_mail_new_count.recordcount#)';
				<cfelse>
					if(document.getElementById("dynamic_#select_mail.folder_id#") != undefined)
						document.getElementById("dynamic_#select_mail.folder_id#").innerHTML = '(#get_mail_new_count_read.recordcount#/#get_mail_new_count.recordcount#)';
				</cfif>
			</cfif>
		</script>
	</cfoutput>
</cfif>

