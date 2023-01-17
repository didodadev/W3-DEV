<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.BRANCH_ID")>
	<cfset url_str = "#url_str#&BRANCH_ID=#attributes.BRANCH_ID#">
<cfelse>
	<cfset attributes.BRANCH_ID = "">
</cfif>
<cfif isdefined("attributes.POSITION_CAT_ID")>
	<cfset url_str = "#url_str#&POSITION_CAT_ID=#attributes.POSITION_CAT_ID#">
<cfelse>
	<cfset attributes.POSITION_CAT_ID = "">
</cfif>
<cfquery name="get_classes" datasource="#dsn#">
  SELECT
    TCGC.CLASS_ID
  FROM
    TRAINING_CLASS_GROUP_CLASSES TCGC,
	TRAINING_CLASS_GROUPS TCG
  WHERE
    TCGC.TRAIN_GROUP_ID = TCG.TRAIN_GROUP_ID
	AND TCG.TRAIN_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.train_group_id#">
</cfquery>
<cfset class_list = valuelist(get_classes.CLASS_ID)>

<cfif len(class_list)>
	<cfquery name="GET_CLASS_RESULTS" datasource="#dsn#">
		SELECT DISTINCT
			TCR.EMP_ID,
            TCR.CON_ID,
            TCR.PAR_ID,
            TCR.CLASS_ID,
            TC.CLASS_NAME
		FROM
			TRAINING_CLASS_RESULTS TCR,
            TRAINING_CLASS TC
		WHERE
			TCR.CLASS_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#class_list#">)
            AND TC.CLASS_ID = TCR.CLASS_ID
	</cfquery>
</cfif> 
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfif len(class_list)>
 <cfparam name="attributes.totalrecords" default=#GET_CLASS_RESULTS.recordcount#>
<cfelse>
  <cfparam name="attributes.totalrecords" default=0>
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.trail")>
<cfinclude template="view_class.cfm">
</cfif>
<cf_medium_list_search title="#getLang('training_management',179)#">
	<cf_medium_list_search_area>
		<table>
			<tr> 
				<!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'><!-- sil -->
			</tr>
		</table> 
	</cf_medium_list_search_area>
</cf_medium_list_search>	
<cf_medium_list>
	<thead>
		<tr> 
			<th width="15"></th>
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<th><cf_get_lang no='173.Şirket/Şube/Departman'></th>
            <th><cf_get_lang_main no='7.Eğitim'></th>
			<th><cf_get_lang no='174.Yoklama'></th>
			<th><cf_get_lang no='175.Ön T'></th>
			<th><cf_get_lang no='176.Son T'></th>
            <th><cf_get_lang no='6. 3 Test'></th>
			<th><cf_get_lang no='177.D Oranı'></th>
		</tr>
	</thead>
	<tbody>
		<cfif LEN(CLASS_LIST)>
			<cfset my_list = "">
				<cfoutput query="GET_CLASS_RESULTS">
				<cfif len(EMP_ID)> 
					<cfset attributes.EMPLOYEE_ID = EMP_ID>
					<cfinclude template="../query/get_employee.cfm">
					<cfset attributes.DEPARTMENT_ID = GET_EMPLOYEE.DEPARTMENT_ID>
					<cfset name = get_employee.employee_name>
					<cfset surname = get_employee.employee_surname>
					<cfset url_link ='#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#attributes.employee_id#'>
					<cfset page_type = 'project'>
				</cfif>
				<cfif len(CON_ID)>
					<cfset attributes.CON_ID = CON_ID>
					<cfinclude template="../query/get_consumer.cfm">
					<cfset attributes.DEPARTMENT_ID = GET_CONSUMER.DEPARTMENT>
					<cfset name = get_consumer.consumer_name>
					<cfset surname = get_consumer.consumer_surname>
					<cfset url_link ='#request.self#?fuseaction=objects.popup_con_det&con_id=#attributes.con_id#'>
					<cfset page_type = 'medium'>
				</cfif>
				<cfif len(PAR_ID)>
					<cfset attributes.PARTNER_ID = PAR_ID>
					<cfinclude template="../query/get_partner.cfm">
					<cfset attributes.DEPARTMENT_ID = GET_PARTNER.DEPARTMENT>
					<cfset name = get_partner.company_partner_name>
					<cfset surname = get_partner.company_partner_surname>
					<cfset url_link ='#request.self#?fuseaction=objects.popup_par_det&par_id=#attributes.partner_id#'>
					<cfset page_type = 'medium'>
				</cfif>				  
				<cfif (isdefined("GET_EMPLOYEE") and GET_EMPLOYEE.RECORDCOUNT) or (isdefined("GET_CONSUMER") and GET_CONSUMER.recordcount) or (isdefined("GET_PARTNER") and GET_PARTNER.recordcount)>
					<cfif len(attributes.DEPARTMENT_ID)>
						<cfquery name="GET_LOCATION" datasource="#dsn#">
							SELECT 
								DEPARTMENT.DEPARTMENT_HEAD, 
								BRANCH.BRANCH_NAME,
								ZONE.ZONE_NAME,
								BRANCH.COMPANY_ID
							FROM 
								BRANCH,
								DEPARTMENT,
								ZONE 
							WHERE
								ZONE.ZONE_ID = BRANCH.ZONE_ID
							AND
								BRANCH.BRANCH_ID=DEPARTMENT.BRANCH_ID
							AND
								DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
						</cfquery>
						<cfquery name="get_company" datasource="#DSN#">
							SELECT COMPANY_NAME FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_location.company_id#">
						</cfquery>
					</cfif>
					<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_DT">
						SELECT
							TCADT.ATTENDANCE_MAIN,
							TCADT.IS_EXCUSE_MAIN,
							TCADT.EXCUSE_MAIN,
							TCA.START_DATE
						FROM
							TRAINING_CLASS_ATTENDANCE TCA,
							TRAINING_CLASS_ATTENDANCE_DT TCADT
						WHERE
							TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#"> AND
							TCADT.IS_TRAINER = 0
						<cfif len(EMP_ID)>
							AND TCADT.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
						</cfif>
						<cfif len(CON_ID)>
							AND TCADT.CON_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
						</cfif>
						<cfif len(PAR_ID)>
							AND TCADT.PAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
						</cfif> 
							AND TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
					</cfquery>
					<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_RESULTS">
						SELECT
							PRETEST_POINT,
							FINALTEST_POINT,
                            THIRDTEST_POINT,
							(FINALTEST_POINT-PRETEST_POINT)/PRETEST_POINT*100 AS ORAN
						FROM
							TRAINING_CLASS_RESULTS
						WHERE
							CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
						<cfif len(EMP_ID)>
							AND	EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id#">
						</cfif>
						<cfif len(CON_ID)>
							AND	CON_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#con_id#">
						</cfif>
						<cfif len(PAR_ID)>
							AND	PAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#par_id#">
						</cfif> 
					</cfquery>
				<cfset my_list = ListAppend(my_list,GET_TRAIN_CLASS_RESULTS.ORAN)>
				<tr>
				<td width="15">#currentrow#</td>
				<td nowrap>
					<a href="javascript://" onClick="windowopen('#url_link#','#page_type#');" class="tableyazi">
					#name#  #surname#</a>
				</td>
				<td>
				<cfif len(attributes.DEPARTMENT_ID)>#get_company.COMPANY_NAME#/#get_location.branch_name#/#get_location.department_head#</cfif>
				</td>
                <td>#class_name#</td>
				<td>
					<table width="98%" border="0"  cellspacing="0" cellpadding="0" align="center">
						<cfloop query="GET_TRAIN_CLASS_DT">
							<tr>
								<td>#DateFormat(START_DATE,dateformat_style)#-<cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>%#ATTENDANCE_MAIN#<cfelseif IS_EXCUSE_MAIN IS 1>#EXCUSE_MAIN#</cfif> </td>
							</tr>
						</cfloop>
					</table>
				</td>
					<td>#GET_TRAIN_CLASS_RESULTS.PRETEST_POINT#</td>
					<td>#GET_TRAIN_CLASS_RESULTS.FINALTEST_POINT#</td>
                    <td>#GET_TRAIN_CLASS_RESULTS.THIRDTEST_POINT#</td>
					<td><cfif LEN(GET_TRAIN_CLASS_RESULTS.ORAN)>%#Round(GET_TRAIN_CLASS_RESULTS.ORAN)#<cfelse></cfif></td>
				</tr>
				</cfif>				  
				</cfoutput>
			<tr>
				<td colspan="9">
					<cf_get_lang no='178.Grup Ortalaması'>: <cfoutput>%#Round(ArrayAvg(ListToArray(my_list)))#</cfoutput>
				</td> 
			</tr>
			<cfelse>
			<tr>
				<td colspan="9">
					<cf_get_lang_main no='72.Kayıt bulunamadı'>!
				</td> 
			</tr>
		</cfif> 
	</tbody>
</cf_medium_list>	  
	<!---<cfif GET_CLASS_RESULTS.recordcount and (attributes.totalrecords gt attributes.maxrows)>
      <table width="97%" border="0" cellspacing="0" cellpadding="0" class="label" align="center">
        <tr> 
          <td height="35">
		  <cf_pages 
			  page="#attributes.page#" 
			  maxrows="#attributes.maxrows#" 
			  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
			  adres="training_management.list_class#url_str#"> 
          </td>
          <!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
        </tr>
      </table>
	</cfif>--->

