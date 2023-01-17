<cfif isdefined("attributes.task_person_name")>
	<cfquery name="TO_MAIL" datasource="#DSN#">
		SELECT 
			EMPLOYEE_EMAIL
		FROM
			EMPLOYEES
		WHERE 
		  <cfif database_type is "MSSQL">
			EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.task_person_name#"> AND
		  <cfelseif database_type is "DB2">
			EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.task_person_name#"> AND
		  </cfif>
			EMPLOYEE_EMAIL IS NOT NULL
	</cfquery>
</cfif>
<cfquery name="FROM_MAIL" datasource="#DSN#">
	SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND EMPLOYEE_EMAIL IS NOT NULL
</cfquery>
<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
	SELECT SERVICE_SUB_CAT_ID, SERVICE_SUB_CAT, SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_id#">
</cfquery>
<cfset position_list = "">
<cfset position_cat_list = "">
<cfset position_mails = "">
	<cfquery name="GET_POSTS" datasource="#DSN#">
		SELECT POSITION_CAT_ID, POSITION_CODE, SERVICE_CONS_ID, SERVICE_PAR_ID, SERVICE_SUB_CAT_ID FROM G_SERVICE_APPCAT_SUB_POSTS
	</cfquery>
<cfset my_counter = 0>
<cfoutput query="get_service_appcat_sub">	
	<cfif isdefined("attributes.service_sub_cat_id_#service_sub_cat_id#") and  len(evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#"))>
		<cfset deger = listlast(evaluate("attributes.service_sub_cat_id_#service_sub_cat_id#"))><!---liste halinde veri geliyordu listlast ekledim py --->	
		<cfif len(deger)>
			<cfset my_counter = 1>
			<cfif x_is_mail_send_tree_list eq 1>
				<cfquery name="GET_POSTS_SUB_CAT" dbtype="query">
					SELECT * FROM GET_POSTS WHERE SERVICE_SUB_STATUS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#deger#">
				</cfquery>
			<cfelse>
				<cfquery name="GET_POSTS_SUB_CAT" dbtype="query">
					SELECT * FROM GET_POSTS WHERE SERVICE_SUB_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_sub_cat_id#">
				</cfquery>
			</cfif>
			<cfloop query="get_posts_sub_cat">				
				<cfif (not listfindnocase(position_list,position_code,',')) and len(position_code)>
					<cfset position_list = listappend(position_list,position_code,',')>
				</cfif>	
				<cfif not listfindnocase(position_cat_list,position_cat_id,',') and len(position_cat_id)>
					<cfset position_cat_list = listappend(position_cat_list,position_cat_id,',')>
				</cfif>
			</cfloop>			
		</cfif>	
	</cfif>	
</cfoutput>
<cfif listlen(position_cat_list)>
	<cfquery name="GET_POSITION_CAT_POSITIONS" datasource="#DSN#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID IN (#position_cat_list#)
	</cfquery>
	<cfloop query="get_position_cat_positions">
		<cfif not listfindnocase(position_list,position_code,',') and len(position_code)>
			<cfset position_list = listappend(position_list,position_code,',')>
		</cfif>
	</cfloop>
</cfif>
<cfif listlen(position_list)>
	<cfquery name="GET_POSITION_MAILS" datasource="#DSN#">
		SELECT 
			EP.EMPLOYEE_EMAIL
		FROM
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D
		WHERE 
			EP.POSITION_CODE IN (#position_list#) AND
			EP.EMPLOYEE_EMAIL IS NOT NULL AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
	</cfquery>
	<cfset position_mails = valuelist(get_position_mails.employee_email,';')>
	<cfset position_mails = listsort(position_mails,'text','desc',';')>	
</cfif>

<cfif listlen(position_mails)>
	<!--- Objects ten logo ve bilgiler --->
	<cfset file_web_path = "documents/">
	<cfsavecontent variable="ust"><cfinclude template="../../objects/display/view_company_logo.cfm"></cfsavecontent>
	<cfsavecontent variable="alt"><cfinclude template="../../objects/display/view_company_info.cfm"></cfsavecontent>
	<cfset alt = ReplaceList(alt,'#chr(39)#','')>
	<cfset alt = ReplaceList(alt,'#chr(10)#','')>
	<cfset alt = ReplaceList(alt,'#chr(13)#','')>
	<cfset ust = ReplaceList(ust,'#chr(39)#','')>
	<cfset ust = ReplaceList(ust,'#chr(10)#','')>
	<cfset ust = ReplaceList(ust,'#chr(13)#','')>
	<cfif len(attributes.service_head)>
		<cfset mail_subject = "#attributes.service_head#">
	<cfelse>
		<cfset mail_subject = "#system_paper_no#">
	</cfif>
	<cfif len(position_mails) and len(from_mail.employee_email) and isdefined("to_mail.employee_email") and len(to_mail.employee_email)>
		<cfmail from="#from_mail.employee_email#" bcc="#position_mails#" to="#to_mail.employee_email#" type="html" subject="#mail_subject#">
				<style type="text/css">
					.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
					.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}          
					a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;} 
					a.tableyazi:active {text-decoration: none;}
					a.tableyazi:hover {text-decoration: underline; color:##339900;}  
					a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
					.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
				</style>
				#ust# 
				<br/>		
				<table width="590" border="0" align="center" class="label">
					<tr>
						<td>İyi Çalışmalar. Adınıza Yapılmış Yeni Bir Başvuru Var. İlgili Başvuruya Aşağıdaki Linki Tıklayarak Ulaşabilirsiniz!</td>
					</tr>
					<tr>
						<td><b>Başvuru Adı : </b>#get_service1.service_head#</td>
					</tr>
					<tr>
						<td><b>Açıklama : </b>#get_service1.service_detail#</td>
					</tr>
					<tr>
						<td>#get_service1.service_detail#</td>
					</tr>
					<tr>
						<td><br/><b>İlgili Başvuru:</b>
							<a href='#user_domain##request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service1.service_id#' class="tableyazi">#mail_subject# - (#attributes.member_company# / #attributes.member_name#)</a>
						</td>
					</tr>
					<tr>
						<td><br/><strong>WorkCube Servis Yöneticisi</strong></td>
					</tr>
				</table> 
				<table width="590" align="center" class="label">
					<tr>
						<td class="label">
							<br/><br/><br/>
							<i><strong>Gönderi Listesi</strong> : #position_mails#</i>
						</td>
					</tr>
				</table>
				<br/>
				<table width="100%">
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table>
				<table width="100%">
					<tr align="left">
						<td>#alt#</td>
					</tr>
				</table>
			</cfmail>
	<cfelseif len(position_mails) and len(from_mail.employee_email)>
		<cfmail from="#from_mail.employee_email#" to="#position_mails#" type="html" subject="#mail_subject#">
			<style type="text/css">
				.label {font-size:11px;font-family:Geneva, tahoma, arial,  Helvetica, sans-serif;color : ##333333;padding-left: 4px;}
				.tableyazi {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;	}          
				a.tableyazi:visited {font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;} 
				a.tableyazi:active {text-decoration: none;}
				a.tableyazi:hover {text-decoration: underline; color:##339900;}  
				a.tableyazi:link {	font-family: Geneva, Tahoma,Verdana, Arial, sans-serif;	text-decoration: none;font-size:11px;padding-right: 2px;	padding-left: 2px;color : ##0033CC;}
				.headbold {  font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 14px; font-weight: bold; padding-right: 2px; padding-left: 2px}
			</style>
			#ust# 
			<br/>		
			<table width="590" border="0" align="center" class="label">
				<tr>
					<td>İyi Çalışmalar. Adınıza Yapılmış Yeni Bir Başvuru Var. İlgili Başvuruya Aşağıdaki Linki Tıklayarak Ulaşabilirsiniz!</td>
				</tr>
				<tr>
					<td><b>Başvuru Adı : </b>#get_service1.SERVICE_HEAD#</td>
				</tr>
				<tr>
					<td><b>Açıklama : </b>#get_service1.SERVICE_DETAIL#</td>
				</tr>
				<tr>
					<td><br/><b>İlgili Başvuru:</b>
						<a href='#user_domain##request.self#?fuseaction=call.list_service&event=upd&service_id=#get_service1.service_id#' class="tableyazi">#mail_subject# - (#attributes.member_company# / #attributes.member_name#)</a>
					</td>
				</tr>
				<tr>
					<td><br/><strong>WorkCube Servis Yöneticisi</strong></td>
				</tr>
			</table> 
			<table width="590" align="center" class="label">
				<tr>
					<td class="label">
						<br/><br/><br/>
						<i><strong>Gönderi Listesi</strong> : #position_mails#</i>
					</td>
				</tr>
			</table>
			<br/>
			<table width="100%">
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table width="100%">
				<tr align="left">
					<td>#alt#</td>
				</tr>
			</table>
		</cfmail>
	</cfif>
</cfif>
