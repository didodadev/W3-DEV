<cfset attributes.organization_id= attributes.action_id>
<cfquery name="get_emp_att" datasource="#dsn#">
	SELECT EMP_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND EMP_ID IS NOT NULL AND PAR_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_par_att" datasource="#dsn#">
	SELECT PAR_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND PAR_ID IS NOT NULL AND EMP_ID IS NULL AND CON_ID IS NULL
</cfquery>
<cfquery name="get_con_att" datasource="#dsn#">
	SELECT CON_ID FROM ORGANIZATION_ATTENDER WHERE ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#"> AND CON_ID IS NOT NULL AND PAR_ID IS NULL AND EMP_ID IS NULL
</cfquery>
<cfset att_list = ''>

<cfif get_emp_att.RECORDCOUNT>
	<cfloop query="get_emp_att">
		<cfset att_list = listappend(att_list,"emp-#get_emp_att.EMP_ID#",",")>
	</cfloop>
</cfif>
<cfif get_par_att.RECORDCOUNT>
	<cfloop query="get_par_att">
		<cfset att_list = listappend(att_list,"par-#get_par_att.PAR_ID#",",")>
	</cfloop>
</cfif>
<cfif get_con_att.RECORDCOUNT>
	<cfloop query="get_con_att">
		<cfset att_list = listappend(att_list,"con-#get_con_att.CON_ID#",",")>
	</cfloop>
</cfif>
<!--- son --->
<cfset attributes.partner_ids="">
<cfset attributes.employee_ids="">
<cfset attributes.consumer_ids="">
<cfloop list="#evaluate("att_list")#" index="i" delimiters=",">
	<cfif i contains "par">
		<cfset attributes.partner_ids = LISTAPPEND(attributes.partner_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "emp">
		<cfset attributes.employee_ids = LISTAPPEND(attributes.employee_ids,LISTGETAT(I,2,"-"))>
	</cfif>
	<cfif i contains "con">
		<cfset attributes.consumer_ids = LISTAPPEND(attributes.consumer_ids,LISTGETAT(I,2,"-"))>
	</cfif>
</cfloop>


<!--- attenders --->
<cfif not len(listsort(attributes.employee_ids,"numeric"))>
	<cfset attributes.employee_ids = 0>
</cfif>
<cfif not len(LISTSORT(attributes.partner_ids,"NUMERIC"))>
	<cfset attributes.partner_ids = 0> 
</cfif>
<cfif not len(LISTSORT(attributes.consumer_ids,"NUMERIC"))>
	<cfset attributes.consumer_ids = 0>
</cfif>

<cfquery name="get_organization_attender" datasource="#DSN#">
	SELECT
		'employee' AS TYPE,
		ORGANIZATION_ATTENDER.ORGANIZATION_ID,
		ORGANIZATION_ATTENDER.EMP_ID AS K_ID,
        ORGANIZATION_ATTENDER.STATUS,
        ORGANIZATION_ATTENDER.ORGANIZATION_ATTENDER_ID,
        ORGANIZATION_ATTENDER.PARTICIPATION_RATE,
		EMPLOYEES.EMPLOYEE_NAME AS AD,
		EMPLOYEES.EMPLOYEE_SURNAME AS SOYAD,
		EMPLOYEES.EMPLOYEE_ID AS IDS,
		EMPLOYEE_POSITIONS.POSITION_NAME AS POSITION,
		DEPARTMENT.DEPARTMENT_HEAD AS DEPARTMAN,
		C.NICK_NAME AS NICK_NAME,
		BRANCH.BRANCH_NAME AS BRANCH_NAME,
        C.ADDRESS WORK_ADDRESS,
		C.POSTAL_CODE WORK_POSCODE,
		C.COUNTY_ID,
        WORK_COUNTY=(SELECT SC.COUNTY_NAME FROM SETUP_COUNTY SC WHERE C.COUNTY_ID= SC.COUNTY_ID),
        C.COUNTRY_ID AS WORK_COUNTRY,
		C.CITY_ID  AS WORK_CITY,
		C.TEL_CODE WORK_TELCODE,
		C.TEL WORK_TEL
	FROM
		ORGANIZATION_ATTENDER INNER JOIN EMPLOYEES ON ORGANIZATION_ATTENDER.EMP_ID = EMPLOYEES.EMPLOYEE_ID 
		LEFT JOIN EMPLOYEE_POSITIONS ON EMPLOYEE_POSITIONS.EMPLOYEE_ID = ORGANIZATION_ATTENDER.EMP_ID
		LEFT JOIN DEPARTMENT ON EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
		LEFT JOIN BRANCH ON DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
		LEFT JOIN OUR_COMPANY C ON C.COMP_ID=BRANCH.COMPANY_ID
	WHERE
		EMP_ID IS NOT NULL
		AND ORGANIZATION_ATTENDER.EMP_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listsort(attributes.employee_ids,'numeric')#">)
		AND ORGANIZATION_ATTENDER.EMP_ID IS NOT NULL
		<cfif isdefined("attributes.ORGANIZATION_ID") and len(attributes.ORGANIZATION_ID)>
			AND ORGANIZATION_ATTENDER.ORGANIZATION_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#">
		</cfif>
UNION
	SELECT 
		'partner' AS TYPE,
		ORGANIZATION_ATTENDER.ORGANIZATION_ID,
		ORGANIZATION_ATTENDER.PAR_ID K_ID,
        ORGANIZATION_ATTENDER.STATUS,
        ORGANIZATION_ATTENDER.ORGANIZATION_ATTENDER_ID,
        ORGANIZATION_ATTENDER.PARTICIPATION_RATE,
		COMPANY_PARTNER.COMPANY_PARTNER_NAME AS AD,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME AS SOYAD,
		COMPANY_PARTNER.PARTNER_ID AS IDS,
		COMPANY_PARTNER.TITLE AS POSITION,
		' ' AS DEPARTMAN, 	
		COMPANY.NICKNAME AS NICK_NAME,
		' ' AS BRANCH_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_ADDRESS WORK_ADDRESS,
		COMPANY_PARTNER.COMPANY_PARTNER_POSTCODE AS WORK_POSCODE,
		COMPANY_PARTNER.COUNTY,
        WORK_COUNTY=(SELECT SC.COUNTY_NAME FROM SETUP_COUNTY SC WHERE COMPANY_PARTNER.COUNTY= SC.COUNTY_ID),
		COMPANY_PARTNER.CITY  AS WORK_CITY,
		COMPANY_PARTNER.COUNTRY AS WORK_COUNTRY,
		COMPANY_PARTNER.COMPANY_PARTNER_TELCODE WORK_TELCODE,
		COMPANY_PARTNER.COMPANY_PARTNER_TEL WORK_TEL
		
	FROM
		ORGANIZATION_ATTENDER,
		COMPANY_PARTNER,
		COMPANY
	WHERE
		ORGANIZATION_ATTENDER.ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#">
		AND ORGANIZATION_ATTENDER.PAR_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listsort(attributes.partner_ids,'numeric')#">)
		AND COMPANY_PARTNER.PARTNER_ID = ORGANIZATION_ATTENDER.PAR_ID
		AND COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
UNION
	SELECT
		'consumer' AS TYPE,
		ORGANIZATION_ATTENDER.ORGANIZATION_ID,
		ORGANIZATION_ATTENDER.CON_ID AS K_ID,
        ORGANIZATION_ATTENDER.STATUS,
        ORGANIZATION_ATTENDER.ORGANIZATION_ATTENDER_ID,
        ORGANIZATION_ATTENDER.PARTICIPATION_RATE,
		CONSUMER.CONSUMER_NAME AS AD,
		CONSUMER.CONSUMER_SURNAME AS SOYAD,
		CONSUMER.CONSUMER_ID AS IDS,
		CONSUMER.TITLE AS POSITION,
		' ' AS DEPARTMAN,
		CONSUMER.COMPANY AS NICK_NAME,
		' ' AS BRANCH_NAME,
		CONSUMER.WORKADDRESS WORK_ADDRESS,
		CONSUMER.WORKPOSTCODE WORK_POSCODE,
		CONSUMER.WORK_COUNTY_ID,
        WORK_COUNTY=(SELECT SC.COUNTY_NAME FROM SETUP_COUNTY SC WHERE CONSUMER.WORK_COUNTY_ID= SC.COUNTY_ID),
		CONSUMER.WORK_CITY_ID AS WORK_CITY,
		CONSUMER.WORK_COUNTRY_ID WORK_COUNTRY,
		CONSUMER.CONSUMER_WORKTELCODE WORK_TELCODE,
		CONSUMER.CONSUMER_WORKTEL WORK_TEL
	FROM
		ORGANIZATION_ATTENDER,
		CONSUMER
	WHERE
		ORGANIZATION_ATTENDER.ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ORGANIZATION_ID#">
		AND ORGANIZATION_ATTENDER.CON_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#listsort(attributes.consumer_ids,'numeric')#">)
		AND CONSUMER.CONSUMER_ID = ORGANIZATION_ATTENDER.CON_ID
		AND ORGANIZATION_ATTENDER.CON_ID IS NOT NULL
</cfquery>
<!--- son --->

<cfif isdefined("get_organization_attender") and get_organization_attender.recordcount>
	<cfscript>
		work_city_list=listdeleteduplicates(valuelist(get_organization_attender.WORK_CITY,','));
	</cfscript>
	<cfif listlen(work_city_list,',')>
		<cfquery name="get_city_all" datasource="#dsn#">
			SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#work_city_list#)
		</cfquery>
	</cfif>
</cfif>

<cfset xxx = 0>
<cfoutput query="get_organization_attender">
	<cfif xxx lte recordcount>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" id="parent">
			<cfloop from="1" to="6" index="rw"><!--- row number --->
				<tr valign="top" align="left">
					<cfloop from="1" to="2" index="cl"><!--- column number --->
						<cfset xxx = xxx + 1>
						<td valign="top" align="left" width="120">
							<table border="0" cellpadding="0" cellspacing="0" align="left" height="100%" id="child">
								<tr valign="top">
									<td class="bold">#AD[xxx]# #SOYAD[xxx]#</td>
								</tr>
								<tr valign="top">
									<td>#NICK_NAME[xxx]#</td>
								</tr>
								<tr valign="top">
									<td>
										<cfif len(WORK_ADDRESS[xxx])>#WORK_ADDRESS[xxx]#</cfif>
										<cfif len(WORK_COUNTY[xxx])>#WORK_COUNTY[xxx]#</cfif>
										<cfif len(WORK_CITY[xxx])>
											<cfquery name="get_city" dbtype="query">
												SELECT CITY_NAME FROM GET_CITY_ALL WHERE CITY_ID=<cfqueryparam value="#WORK_CITY[xxx]#" cfsqltype="cf_sql_integer"> 
											</cfquery>
											#get_city.CITY_NAME#
										</cfif>
									</td>
								</tr>
								<cfif len(WORK_TELCODE[xxx]) and len(WORK_TEL[xxx])>
									<tr valign="top">
										<td>#WORK_TELCODE[xxx]#- #WORK_TEL[xxx]#</td>
									</tr>
								</cfif>
								<tr style="height:20mm;">
									<td colspan="3"></td>
								</tr>
							</table>
						</td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
		<div style="page-break-after:always"></div>
	</cfif>
	<!--- <div class="child" style="width:50%;height:100px">
		<table>
			<tr>
				<td class="bold">#AD# #SOYAD#</td>
			</tr>
			<tr>
				<td>#NICK_NAME#</td>
			</tr>
			<tr>
				<td>#WORK_ADDRESS#</td>
			</tr>
			<tr>
				<td>#WORK_COUNTY#</td>
			</tr>
			<tr>
				<cfif len(WORK_CITY)>
					<td>
						<cfquery name="get_city" datasource="#dsn#">
							SELECT SETUP_CITY.CITY_NAME FROM SETUP_CITY WHERE SETUP_CITY.CITY_ID= #WORK_CITY#
						</cfquery>
						#get_city.CITY_NAME#
					</td>
				</cfif>
			</tr>
			<tr>
				<td>#WORK_TELCODE#- #WORK_TEL#</td>
			</tr>
		</table>
	</div> --->
</cfoutput>
    
<script>
    $('.parent').css( {
    "display": "grid",
    "grid-template-columns":"repeat(4, 200px)",
    "grid-template-rows": "repeat(6, 200px)",
    "grid-column-gap": "10px",
    "grid-row-gap": "10px",
    })
   
    
   
</script>