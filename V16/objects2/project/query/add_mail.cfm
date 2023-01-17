<!---katılımcılar, izleyiciler ve işlerin görevli kişileri alınacak--->
<!---A)EMPLOYEES--->
<!---1)PROJE LİDERİ--->
<!--- WORKGROUP_EMP_PAR --->
<cfset emps = ""> 
<cfset pars = "">
<cfquery name="GET_EMPS1" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,PRO_PROJECTS.PROJECT_HEAD
	FROM
		PRO_PROJECTS,
		EMPLOYEE_POSITIONS
	WHERE
		PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = PRO_PROJECTS.PROJECT_EMP_ID AND
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1 
</cfquery>

<cfset project_name = get_emps1.project_head>
<cfset emps = listappend(emps,valuelist(get_emps1.employee_id))>

<!---2)PROJE grubunda bulunanlar--->
<cfquery name="GET_EMPS2" datasource="#DSN#">
	SELECT	
		DISTINCT EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		WORKGROUP_EMP_PAR.POSITION_CODE
	FROM
		WORK_GROUP,
		WORKGROUP_EMP_PAR,
		EMPLOYEE_POSITIONS
	WHERE
		WORK_GROUP.WORKGROUP_ID = WORKGROUP_EMP_PAR.WORKGROUP_ID AND
		WORK_GROUP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = WORKGROUP_EMP_PAR.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.IS_MASTER = 1 AND
		WORKGROUP_EMP_PAR.EMPLOYEE_ID IS NOT NULL
</cfquery>
<cfset emps = listappend(emps,valuelist(get_emps2.employee_id))>

<!---A)EMPLOYEES/bitti--->

<!---B)PARTNERS--->

<!---1)PROJE LİDERİ--->
<cfquery name="GET_PARS1" datasource="#DSN#">
	SELECT
		DISTINCT COMPANY_PARTNER.PARTNER_ID
	FROM
		PRO_PROJECTS,
		COMPANY_PARTNER
	WHERE
		PRO_PROJECTS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
		COMPANY_PARTNER.PARTNER_ID = PRO_PROJECTS.OUTSRC_PARTNER_ID AND
		COMPANY_PARTNER.PARTNER_ID IS NOT NULL
</cfquery>
<cfif get_pars1.recordcount>
	<cfset pars = listappend(pars,valuelist(get_pars1.partner_id))>
</cfif>
<cfquery name="GET_PARS2" datasource="#DSN#">
	SELECT
		WORKGROUP_EMP_PAR.PARTNER_ID
	FROM
		WORKGROUP_EMP_PAR,
		WORK_GROUP
	WHERE
		WORK_GROUP.WORKGROUP_ID = WORKGROUP_EMP_PAR.WORKGROUP_ID AND
		WORK_GROUP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#"> AND
		WORKGROUP_EMP_PAR.PARTNER_ID IS NOT NULL
</cfquery>
<cfif get_pars2.recordcount>
	<cfset pars = listappend(pars,valuelist(get_pars2.partner_id))>
</cfif>
<!---B)PARTNERS/bitti--->

<cfset emps_="">
<cfset pars_="">														

<!---emps distinct ediliyor--->
<cfloop list="#emps#" index="i">
	<cfif not listfind(emps_,i)>
		<cfset emps_=listappend(emps_,i)>
	</cfif>
</cfloop>
<!---/emps distinct ediliyor--->

<!---pars distinct ediliyor--->
<cfloop list="#pars#" index="i">
	<cfif not listfind(pars_,i)>
		<cfset pars_=listappend(pars_,i)>
	</cfif>
</cfloop>
<!---/pars distinct ediliyor--->

<cfquery name="GET_SENDER" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER_EMAIL,
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER
	WHERE
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#">
</cfquery>

<!--- Objects ten logo ve bilgiler --->
<cfsavecontent variable="ust"><cfinclude template="../../../objects/display/view_company_logo.cfm"></cfsavecontent>
<cfsavecontent variable="alt"><cfinclude template="../../../objects/display/view_company_info.cfm"></cfsavecontent>
<cfset alt = ReplaceList(alt,'#chr(39)#','')>
<cfset alt = ReplaceList(alt,'#chr(10)#','')>
<cfset alt = ReplaceList(alt,'#chr(13)#','')>
<cfset ust = ReplaceList(ust,'#chr(39)#','')>
<cfset ust = ReplaceList(ust,'#chr(10)#','')>
<cfset ust = ReplaceList(ust,'#chr(13)#','')>
<!--- Objects ten logo ve bilgiler --->

<cfset sender = get_sender.company_partner_name&' '&get_sender.company_partner_surname&'<'&get_sender.company_partner_email&'>'>

<!---mail to employees--->
<cfloop list="#emps_#" index="i">
	<cfquery name="GET_EMP_MAIL" datasource="#DSN#">
		SELECT 
			EMPLOYEE_EMAIL
		FROM
			EMPLOYEES
		WHERE
			EMPLOYEE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
	</cfquery>
	<cfset tomail=get_emp_mail.employee_email>
	<cfif len(tomail)>
        <cfmail from="#sender#" to="#tomail#" type="HTML" subject="WorkCube Proje Yöneticisi - #project_name# Projesi İle İlgili Genel Duyuru Yapıldı!">
            <cfinclude template="add_mail_view.cfm">
            <table align="center" style="width:590px;">
            	<tr>
            		<td>
            			<a href="#employee_domain##request.self#?fuseaction=project.projects&event=det&ID=#url.id#" class="tableyazi">#project_name#</a><br/><br/>
            			<span class="label"><strong>#sender#</strong></span><br/>
            		</td>
            	</tr>
            </table>
            #alt#
        </cfmail>
	</cfif>
</cfloop>
<!---/mail to employees--->

<!---mail to partners--->
<cfloop list="#pars_#" index="i">
	<cfquery name="GET_PAR_MAIL" datasource="#DSN#">
		SELECT 
			COMPANY_PARTNER_EMAIL
		FROM
			COMPANY_PARTNER
		WHERE
			PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
	</cfquery>
	<cfset tomail=get_par_mail.company_partner_email>
	<cfif len(tomail)>
		<cfmail from="#sender#" to="#tomail#" type="HTML" subject="#project_name# Projesi ile İlgili Genel Duyuru Yapıldı!">
			<cfinclude template="add_mail_view.cfm">
			<a href="#partner_domain##request.self#?fuseaction=project.projects&event=det&id=#url.id#" class="tableyazi">#project_name#</a><br/><br/>
			<span class="label"><strong>#sender#</strong></span><br/>
			#alt#
		</cfmail>
	</cfif>
</cfloop>
<!---/mail to partners--->

<script type="text/javascript">
	window.close();
</script>
