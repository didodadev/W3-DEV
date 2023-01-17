<cfquery name="TO_MAIL" datasource="#dsn#">
	SELECT 
		EMPLOYEE_EMAIL
	FROM
		EMPLOYEES
	WHERE 
		EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME = '#attributes.TASK_PERSON_NAME#'
</cfquery>
<cfquery name="FROM_MAIL" datasource="#dsn#">
	SELECT 
		EMPLOYEE_EMAIL
	FROM
		EMPLOYEES
	WHERE 
		EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME = '#SESSION.EP.NAME# #SESSION.EP.SURNAME#'
</cfquery>

<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#dsn3#">
	SELECT SERVICE_SUB_CAT_ID,SERVICE_SUB_CAT,SERVICECAT_ID FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #ATTRIBUTES.APPCAT_ID#
</cfquery>
<cfset position_list = "">
<cfset position_cat_list = "">
<cfset position_mails = "">

<cfquery name="GET_POSTS" datasource="#dsn3#">
	SELECT * FROM SERVICE_APPCAT_SUB_POSTS
</cfquery>

<cfset my_counter = 0>
<CFOUTPUT query="GET_SERVICE_APPCAT_SUB">		
	<cfset deger = evaluate("attributes.SERVICE_SUB_CAT_ID_#SERVICE_SUB_CAT_ID#")>	
	<cfif len(deger)>
		<cfset my_counter = 1>
			<cfquery name="GET_POSTS_SUB_CAT" dbtype="query">
				SELECT * FROM GET_POSTS WHERE SERVICE_SUB_CAT_ID = #SERVICE_SUB_CAT_ID#
			</cfquery>
			<cfloop query="GET_POSTS_SUB_CAT">				
					<cfif (not listfindnocase(position_list,GET_POSTS_SUB_CAT.POSITION_CODE,',')) and len(GET_POSTS_SUB_CAT.POSITION_CODE)>
						<cfset position_list = listappend(position_list,GET_POSTS_SUB_CAT.POSITION_CODE,',')>
					</cfif>
					
					<cfif not listfindnocase(position_cat_list,GET_POSTS_SUB_CAT.POSITION_CAT_ID,',') and len(GET_POSTS_SUB_CAT.POSITION_CAT_ID)>
						<cfset position_cat_list = listappend(position_cat_list,GET_POSTS_SUB_CAT.POSITION_CAT_ID,',')>
					</cfif>
			</cfloop>			
	</cfif>		
</CFOUTPUT>


<cfif my_counter neq 1>
	<cfquery name="get_all_sub_cats" datasource="#dsn3#">
		SELECT SERVICE_SUB_CAT_ID FROM SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = #ATTRIBUTES.APPCAT_ID#
	</cfquery>
	
	<cfif get_all_sub_cats.recordcount>
	<cfset alt_kategori_list = valuelist(get_all_sub_cats.SERVICE_SUB_CAT_ID,',')>
		<cfquery name="GET_POSTS_SUB_CAT" dbtype="query">
			SELECT * FROM GET_POSTS WHERE SERVICE_SUB_CAT_ID IN (#alt_kategori_list#)
		</cfquery>
		<cfloop query="GET_POSTS_SUB_CAT">				
			<cfif not listfindnocase(position_list,GET_POSTS_SUB_CAT.POSITION_CODE,',') and len(GET_POSTS_SUB_CAT.POSITION_CODE)>
				<cfset position_list = listappend(position_list,GET_POSTS_SUB_CAT.POSITION_CODE,',')>
			</cfif>			
			<cfif not listfindnocase(position_cat_list,GET_POSTS_SUB_CAT.POSITION_CAT_ID,',') and len(GET_POSTS_SUB_CAT.POSITION_CAT_ID)>
				<cfset position_cat_list = listappend(position_cat_list,GET_POSTS_SUB_CAT.POSITION_CAT_ID,',')>
			</cfif>
		</cfloop>
	</cfif>	
</cfif>



<cfif listlen(position_cat_list)>
	<cfquery name="get_position_cat_positions" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID IN (#position_cat_list#)
	</cfquery>
	<cfloop query="get_position_cat_positions">
		<cfif not listfindnocase(position_list,get_position_cat_positions.POSITION_CODE,',') and len(get_position_cat_positions.POSITION_CODE)>
			<cfset position_list = listappend(position_list,get_position_cat_positions.POSITION_CODE,',')>
		</cfif>
	</cfloop>
</cfif>


<cfif listlen(position_list)>
	<cfquery name="get_position_mails" datasource="#dsn#">
		SELECT 
			EP.EMPLOYEE_EMAIL FROM EMPLOYEE_POSITIONS EP,DEPARTMENT D
		WHERE 
			EP.POSITION_CODE IN (#position_list#) AND EP.EMPLOYEE_EMAIL IS NOT NULL AND EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND D.BRANCH_ID = #ATTRIBUTES.SERVICE_BRANCH_ID#
	</cfquery>
	<cfset position_mails = valuelist(get_position_mails.EMPLOYEE_EMAIL,';')>
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
	<!--- Objects ten logo ve bilgiler --->
	<cfif len(attributes.SERVICE_HEAD)>
	<cfset mail_subject = "#attributes.SERVICE_HEAD#">
	<cfelse>
	<cfset mail_subject = "#system_paper_no#">
	</cfif>
	<cfif len(TO_MAIL.EMPLOYEE_EMAIL)>
		<cfmail bcc="#position_mails#" from="#FROM_MAIL.EMPLOYEE_EMAIL#" to="#TO_MAIL.EMPLOYEE_EMAIL#" type="html" subject="#mail_subject#">
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
		<td>İyi Çalışmalar. Adınıza Yapılmış Yeni Bir Şikayet Başvurusu Var. İlgili Başvuruya Aşağıdaki Linki Tıklayarak Ulaşabilirsiniz!</td>
		</tr>
		<tr>
		<td><br/><b>İlgili Başvuru:</b> <a href='#employee_domain##request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service1.SERVICE_ID#' class="tableyazi">#mail_subject# - (#attributes.member_company# / #attributes.member_name#)</a></td>
		</tr>
		<tr>
		<td><br/><STRONG>WorkCube Servis Yöneticisi</STRONG></td>
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
		#alt#
		</cfmail>
	<cfelse>
		<cfmail from="#FROM_MAIL.EMPLOYEE_EMAIL#" to="#position_mails#" type="html" subject="#mail_subject#">
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
		<td>İyi Çalışmalar. Adınıza Yapılmış Yeni Bir Şikayet Başvurusu Var. İlgili Başvuruya Aşağıdaki Linki Tıklayarak Ulaşabilirsiniz!</td>
		</tr>
		<tr>
		<td><br/><b>İlgili Başvuru:</b> <a href='#employee_domain##request.self#?fuseaction=service.list_service&event=upd&service_id=#get_service1.SERVICE_ID#' class="tableyazi">#mail_subject# - (#attributes.member_company# / #attributes.member_name#)</a></td>
		</tr>
		<tr>
		<td><br/><STRONG>WorkCube Servis Yöneticisi</STRONG></td>
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
		#alt#
		</cfmail>
	</cfif>
 </cfif>
