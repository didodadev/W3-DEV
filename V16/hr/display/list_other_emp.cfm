<cfif not isdefined("attributes.issubmit")>
	<!--- (PRACTICANT_TYPE) 1:DIGER CALISANLAR | 2:ÜYELER --->
	<cfquery name="GET_OTHER_EMPS" datasource="#dsn#">
		SELECT 
			USER_TYPE_ID,
			USER_ID 
		FROM 
			SENT_REPLIED_CONTENTS 
		WHERE 
			SEND_EMP = #attributes.emp_id#
	</cfquery>
	<cfquery name="GET_OTHER_MEMBERS_DETAIL1" datasource="#dsn#">
	SELECT 
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CP.PARTNER_ID,
		C.FULLNAME
	FROM 
		COMPANY_PARTNER CP,
		COMPANY C
	WHERE
		C.COMPANY_ID = CP.COMPANY_ID
		AND CP.PARTNER_ID IN (
		SELECT
			MANAGER_PARTNER_ID
		FROM
			COMPANY
		WHERE
			COMPANY_ID IN (
							SELECT 
								WORKGROUP_EMP_PAR.COMPANY_ID
							FROM 
								EMPLOYEE_POSITIONS,
								WORKGROUP_EMP_PAR
							WHERE 
								EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
								EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.emp_id# AND
								EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND
								WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL
						)
			)
	</cfquery>
	<cfquery name="GET_OTHER_MEMBERS_DETAIL2" datasource="#dsn#">
	SELECT 
		CP.COMPANY_PARTNER_NAME,
		CP.COMPANY_PARTNER_SURNAME,
		CP.PARTNER_ID,
		C.FULLNAME
	FROM 
		COMPANY_PARTNER CP,
		COMPANY C
	WHERE
		C.COMPANY_ID = CP.COMPANY_ID
		AND CP.PARTNER_ID IN (
		SELECT
			MANAGER_PARTNER_ID
		FROM
			COMPANY
		WHERE
			COMPANY_ID IN (
							SELECT 
								WORKGROUP_EMP_PAR.COMPANY_ID
							FROM 
								EMPLOYEE_POSITIONS,
								WORKGROUP_EMP_PAR
							WHERE 
								EMPLOYEE_POSITIONS.POSITION_STATUS = 1 AND
								EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.emp_id# AND
								EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE AND
								WORKGROUP_EMP_PAR.COMPANY_ID IS NOT NULL
							)
			)
	</cfquery>
	<cfquery name="GET_OTHER_MEMBERS_DETAIL" dbtype="query">
		SELECT * FROM GET_OTHER_MEMBERS_DETAIL1
		UNION
		SELECT * FROM GET_OTHER_MEMBERS_DETAIL2
		GROUP BY
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			PARTNER_ID,
			FULLNAME
	</cfquery>

<cfsavecontent variable="message"><cf_get_lang dictionary_id="55974.Ölçme-Değerlendirme Yapacaklar"></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform action="" method="post" name="user_group">
        <input type="hidden" name="issubmit" id="issubmit" value="0">
        <cfoutput><input type="hidden" name="quiz_id" id="quiz_id" value="#attributes.quiz_id#"></cfoutput>
    	<table>
            <tr>
            	<td class="txtbold" colspan="3" height="25">&nbsp;<cf_get_lang dictionary_id='57576.Çalışan'>: <cfoutput>#attributes.quiz_emp#</cfoutput></td>
            </tr>
         </table>
         <cf_area width="33%">
            <table>
                <tr>
                    <td colspan="2" class="txtbold"><cf_get_lang dictionary_id='55490.Amirler'></td>
                </tr>
                <cfloop list="#attributes.chief_url#" index="i" delimiters="-">
                <cfset user_name = listfirst(i,';')>
                <cfset user_id = listlast(i,';')>
                <tr>
                    <td width="10">
                        <cfoutput>
                        <input type="checkbox" name="amirids_#user_id#" id="amirids_#user_id#" value="#user_id#" <cfloop query="GET_OTHER_EMPS"><cfif GET_OTHER_EMPS.USER_TYPE_ID is 4 and GET_OTHER_EMPS.USER_ID is user_id> checked="true"</cfif></cfloop>>
                        </cfoutput>
                    </td>
                    <td><cfoutput>#user_name#</cfoutput></td>
                </tr>
                </cfloop>
            </table>
         </cf_area>
         <cf_area width="33%">
            <table width="100%">
                <tr>
                    <td colspan="2" class="txtbold"><cf_get_lang dictionary_id='57417.Üyeler'></td>
                </tr>
                <cfoutput query="GET_OTHER_MEMBERS_DETAIL">
                    <tr>
                        <td width="15"><input type="checkbox" name="partnerids" id="partnerids" value="#PARTNER_ID#" <cfloop query="GET_OTHER_EMPS"><cfif GET_OTHER_EMPS.USER_TYPE_ID is 3 and GET_OTHER_EMPS.USER_ID is GET_OTHER_MEMBERS_DETAIL.PARTNER_ID> checked="true"</cfif></cfloop>></td>
                        <td>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# (#FULLNAME#)</td>
                    </tr>
                </cfoutput>
            </table>
         </cf_area>
         <cf_area width="34%">
            <div id="calisan" style="position:absolute;width:100%;height:99%; z-index:88;overflow:auto;">
                <cf_workcube_to_cc 
                is_update = "1" 
                to_dsp_name = "Diğer Değerlendiren" 
                form_name = "user_group" 
                str_list_param = "1,2,3"
                action_dsn = "#DSN#"
                str_action_names = "USER_ID AS TO_EMP"
                action_table = "SENT_REPLIED_CONTENTS"
                action_id_name = "USER_TYPE_ID IN (1,2,3,4) AND USER_ID"
                action_id = "#attributes.emp_id#"
                data_type = "2"
                str_alias_names = "">
            </div>
         </cf_area>
		<cf_popup_box_footer style="text-align:right;">
            <cfsavecontent variable="message"><cf_get_lang dictionary_id='55410.Kaydet ve Mail Gönder'></cfsavecontent>
            <cf_workcube_buttons type_format="1" is_upd='0' insert_info='#message#' add_function='kayit_email()' is_cancel='0'>
            <cf_workcube_buttons type_format="1" is_upd='0' is_cancel='0' add_function='kayit(0)'>
        
        <!---<input type="button" value="Kaydet ve Email Gönder" onClick="kayit_email();">&nbsp;<input type="button" value="Kaydet" onClick="kayit();">--->
        </cf_popup_box_footer>
    </cfform>
</cf_popup_box>

	<script language="JavaScript" type="text/javascript">
		function kayit(){
			document.user_group.issubmit.value=1;
			document.user_group.submit();
		}
		function kayit_email(){
			document.user_group.issubmit.value=2;
			document.user_group.submit();
		}
	</script>
</cfif>

<!--- KAYIT VE EMAIL ISLEMLERI --->
<cfif isdefined("attributes.issubmit")>
	<!--- KAYIT ISLEMLERI --->
	<cfif isdefined("attributes.TO_EMP_IDS") and trim(len(attributes.TO_EMP_IDS))>
		<cfloop list="#attributes.TO_EMP_IDS#" index="i">
			<!--- EMAIL ISLEMLERI --->
			<cfif attributes.issubmit is 2>
				<cfquery name="EMAIL_DETAIL" datasource="#dsn#">
					SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #i#
				</cfquery>
				<cfif EMAIL_DETAIL.recordcount gt 0><cfset attributes.email = EMAIL_DETAIL.EMPLOYEE_EMAIL><cfelse><cfset attributes.email = ""></cfif>
				<cf_sent_replied_contents action="add" content_id="#attributes.quiz_id#" content_type_id="5"
					email="#attributes.email#" send_emp="#attributes.emp_id#" user_id="#i#" user_type_id="1" dsn="#dsn#">
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.TO_PAR_IDS") and trim(len(attributes.TO_PAR_IDS))>
		<cfloop list="#attributes.TO_PAR_IDS#" index="i">
			<!--- EMAIL ISLEMLERI --->
			<cfif attributes.issubmit is 2>
				<cfquery name="EMAIL_DETAIL" datasource="#dsn#">
					SELECT COMPANY_PARTNER_EMAIL AS EMPLOYEE_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = #i#
				</cfquery>
				<cfif EMAIL_DETAIL.recordcount gt 0><cfset attributes.email = EMAIL_DETAIL.EMPLOYEE_EMAIL><cfelse><cfset attributes.email = ""></cfif>
				<cf_sent_replied_contents action="add" content_id="#attributes.quiz_id#" content_type_id="5"
					email="#attributes.email#" send_emp="#attributes.emp_id#" user_id="#i#" user_type_id="1" dsn="#dsn#">
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.TO_CONS_IDS") and trim(len(attributes.TO_CONS_IDS))>
		<cfloop list="#attributes.TO_CONS_IDS#" index="i">
			<!--- EMAIL ISLEMLERI --->
			<cfif attributes.issubmit is 2>
				<cfquery name="EMAIL_DETAIL" datasource="#dsn#">
					SELECT CONSUMER_EMAIL AS EMPLOYEE_EMAIL  FROM CONSUMER WHERE CONSUMER_ID = #i#
				</cfquery>
				<cfif EMAIL_DETAIL.recordcount gt 0><cfset attributes.email = EMAIL_DETAIL.EMPLOYEE_EMAIL><cfelse><cfset attributes.email = ""></cfif>
				<cf_sent_replied_contents action="add" content_id="#attributes.quiz_id#" content_type_id="5"
					email="#attributes.email#" send_emp="#attributes.emp_id#" user_id="#i#" user_type_id="1" dsn="#dsn#">
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.amirids") and trim(len(attributes.amirids))>
		<cfloop list="#attributes.amirids#" index="i">
			<!--- EMAIL ISLEMLERI --->
			<cfif attributes.issubmit is 2>
				<cfquery name="EMAIL_DETAIL" datasource="#dsn#">
					SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #i#
				</cfquery>
				<cfif EMAIL_DETAIL.recordcount gt 0><cfset attributes.email = EMAIL_DETAIL.EMPLOYEE_EMAIL><cfelse><cfset attributes.email = ""></cfif>
				<cf_sent_replied_contents action="add" content_id="#attributes.quiz_id#" content_type_id="5"
					email="#attributes.email#" send_emp="#attributes.emp_id#" user_id="#i#" user_type_id="1" dsn="#dsn#">
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.yedekids") and trim(len(attributes.yedekids))>
		<cfloop list="#attributes.yedekids#" index="i">
			<!--- EMAIL ISLEMLERI --->
			<cfif attributes.issubmit is 2>
				<cfquery name="EMAIL_DETAIL" datasource="#dsn#">
					SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #i#
				</cfquery>
				<cfif EMAIL_DETAIL.recordcount gt 0><cfset attributes.email = EMAIL_DETAIL.EMPLOYEE_EMAIL><cfelse><cfset attributes.email = ""></cfif>
				<cf_sent_replied_contents action="add" content_id="#attributes.quiz_id#" content_type_id="5"
					email="#attributes.email#" send_emp="#attributes.emp_id#" user_id="#i#" user_type_id="1" dsn="#dsn#">
			</cfif>
		</cfloop>
	</cfif>
	<cfif isdefined("attributes.partnerids") and trim(len(attributes.partnerids))>
		<cfloop list="#attributes.partnerids#" index="i">
			<!--- EMAIL ISLEMLERI --->
			<cfif attributes.issubmit is 2>
				<cfquery name="EMAIL_DETAIL" datasource="#dsn#">
					SELECT COMPANY_PARTNER_EMAIL AS EMPLOYEE_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = #i#
				</cfquery>
				<cfif EMAIL_DETAIL.recordcount gt 0><cfset attributes.email = EMAIL_DETAIL.EMPLOYEE_EMAIL><cfelse><cfset attributes.email = ""></cfif>
				<cf_sent_replied_contents action="add" content_id="#attributes.quiz_id#" content_type_id="5"
					email="#attributes.email#" send_emp="#attributes.emp_id#" user_id="#i#" user_type_id="1" dsn="#dsn#">
			</cfif>
		</cfloop>
	</cfif>
	<cfif attributes.issubmit is 2>
		<!--- sent_replied_contents custom tag içinde kaydedilenlere mail atiliyor--->
		<cfquery name="GET_MAILFROM" datasource="#dsn#">
			SELECT
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_NAME NAME_,EMPLOYEE_SURNAME SURNAME_,EMPLOYEE_EMAIL EMAIL_<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER_NAME NAME_,COMPANY_PARTNER_SURNAME NAME_,COMPANY_PARTNER_EMAIL EMAIL_</cfif>
			FROM		
				<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_POSITIONS<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>COMPANY_PARTNER</cfif>		
			WHERE
				<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>EMPLOYEE_ID=#session.ep.USERID#
				<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>PARTNER_ID=#session.pp.USERID#</cfif>
		</cfquery>
		 <cfif GET_MAILFROM.RECORDCOUNT>
            <cfset sender = "#GET_MAILFROM.NAME_# #GET_MAILFROM.SURNAME_#<#GET_MAILFROM.EMAIL_#>">
        </cfif>
		<cfset cheif_list = ''>
		<cfset amir_list = ''>
		<cfset cheif_lista = ''>	
		<cfset cheif_list = attributes.chief_url>
		<cfloop from="1" to="#listlen(cheif_list,'-')#" index="i">
			<cfset amir_list = ListGetAt(ListGetAt(cheif_list,i,'-'),2,';')>
			<cfif isdefined('attributes.amirids_#amir_list#')>
				<cfset cheif_lista = listappend(cheif_lista,amir_list,',')>
			</cfif>
		</cfloop>
		<cfif len(cheif_lista)>
			<cfquery name="get_quiz_mails" datasource="#dsn#">
				SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#cheif_lista#)
			</cfquery>
			<cfsavecontent variable="attributes.subject">Performans Değerlendirmeniz Bekleniyor</cfsavecontent>
			<cfset sent_list = ''>
			<cfif len(sender)>
			  <cfoutput query="get_quiz_mails">
				<cftry>
					<cfquery name="get_form_head" datasource="#dsn#">
						SELECT 
							EQ.QUIZ_ID,
							EQ.QUIZ_HEAD
						FROM 
							EMPLOYEE_QUIZ EQ
						WHERE
							EQ.QUIZ_ID IS NOT NULL 
							AND EQ.QUIZ_ID = #attributes.quiz_id#
					</cfquery>
					<cfmail from="#sender#" to="#get_quiz_mails.EMPLOYEE_EMAIL#" subject="#attributes.subject#" type="HTML">
						#get_emp_info(attributes.emp_id,0,0)# için '#get_form_head.QUIZ_HEAD#' formunu doldurmanız bekleniyor...
						<br/>
						<a href="#employee_domain##request.self#?fuseaction=myhome.form_add_perf_emp_info&employee_id=#attributes.emp_id#&period_year=#session.ep.period_year#&QUIZ_ID=#attributes.quiz_id#">İlgili Forma Buradan Ulaşabilirsiniz...</a><br/>
						Gönderen : #session.ep.name# #session.ep.surname#
					</cfmail>
					<cfcatch type="any"><cf_get_lang_main no='130.mail_server_yok'></cfcatch>
				</cftry>
			  </cfoutput>
			<cfelse>
			  <script language="JavaScript">
				  alert("<cf_get_lang dictionary_id='34243.Mail Adresiniz Tanımlı Değil Mail Gönderemezsiniz'>!");
				  history.back();
			  </script>
			  <cfabort>
			</cfif>
		</cfif>
	</cfif>
	<script language="JavaScript" type="text/javascript">window.close();</script>
</cfif>
