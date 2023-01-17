<!--- Sayfada yetkili ve katilimci kontrolleri yeniden duzenlendi FBS 20100707 --->
<cfif isDefined("session.agenda_userid")>
	<cfset session_userid_ = session.agenda_userid>
	<cfset session_usertype_ = session.agenda_user_type>
<cfelse>
	<cfset session_userid_ = session.ep.userid>
	<cfset session_usertype_ = "e">
</cfif>
<cfset Agenda_Power_User_ = "">
<cfif session_usertype_ eq "e"><!--- Ajanda employee ise sube departman yetkisine bakar --->
	<cfinclude template="get_all_agenda_department_branch.cfm">
	<cfquery name="Get_Power_User" datasource="#dsn#">
		SELECT POWER_USER,POWER_USER_LEVEL_ID FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = 1 AND EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_userid_#">
	</cfquery>
	<cfif Len(Get_Power_User.Power_User_Level_Id)><cfset Agenda_Power_User_ = ListGetAt(Get_Power_User.Power_User_Level_Id,6,',')></cfif>
</cfif>
<!--- Yetkili olunan şirketlere bakar--->
<cfquery name="GET_AGENDA_COMPANY" datasource="#DSN#">
    SELECT 
        SETUP_PERIOD.OUR_COMPANY_ID
    FROM
        EMPLOYEE_POSITION_PERIODS,
        EMPLOYEE_POSITIONS,
        SETUP_PERIOD
    WHERE
        EMPLOYEE_POSITIONS.POSITION_ID = EMPLOYEE_POSITION_PERIODS.POSITION_ID
        AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
        AND SETUP_PERIOD.PERIOD_ID = EMPLOYEE_POSITION_PERIODS.PERIOD_ID
</cfquery>
<cfset my_comp_list = VALUELIST(GET_AGENDA_COMPANY.OUR_COMPANY_ID)>
<!--- Ilgili sube ve departmana baglı calısanların katılımcı olarak secilmis oldugu ajanda kayıtlarını listelerken kullanilir --->
<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id) or isdefined('attributes.department') and isnumeric(attributes.department)>
	<cfquery name="get_related_emp_ids" datasource="#dsn#">
		SELECT 
			EP.EMPLOYEE_ID
		FROM
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT DEPT
		WHERE 
			EP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID AND
			EP.EMPLOYEE_ID > 0
			<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
				AND DEPT.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined('attributes.department') and isnumeric(attributes.department)>
				AND DEPT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
			</cfif>
	</cfquery>
	<cfset related_emp_ids = valuelist(get_related_emp_ids.employee_id)>
</cfif>
<!--- //Ilgili sube ve departmana baglı calısanların katılımcı olarak secilmis oldugu ajanda kayıtlarını listelerken kullanilir --->
<cfquery name="GET_EVENT_SEARCH" datasource="#dsn#">
	SELECT 
		E.EVENT_ID,
		E.STARTDATE,
		E.FINISHDATE,
		E.EVENT_HEAD,
		E.RECORD_DATE,
		E.RECORD_EMP,
		E.RECORD_PAR,
		E.EVENT_PLACE_ID,
		E.PROJECT_ID,
		EC.EVENTCAT,
		PTR.STAGE
	FROM
		EVENT E,
		EVENT_CAT EC,
		PROCESS_TYPE_ROWS PTR
	WHERE
		<!--- Super Kullanicinin Ajandaya yetkisi olmasi durumunda tum kayitlari gorebilir, asagidaki kontrollere girmez --->
		<cfif Agenda_Power_User_ neq 1>
		(	
			<cfif session_usertype_ eq "e"><!--- Ajanda employee ise --->
				E.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_userid_#"> OR 
				E.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_userid_#"> OR 
				E.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session_userid_#,%"> OR 
				E.EVENT_CC_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session_userid_#,%"> OR
			<cfelse><!--- Ajanda partner ise --->
				E.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_userid_#"> OR 
				E.UPDATE_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_userid_#"> OR 
				E.EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session_userid_#,%"> OR 
				E.EVENT_CC_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session_userid_#,%"> OR
				<cfloop list="#grps#" index="g"><!--- Bunun hala kullanildigindan emin degilim??? --->
					E.EVENT_TO_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#g#,%"> OR
					E.EVENT_CC_GRP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#g#,%"> OR
				</cfloop>
			</cfif>
			(
				<cfif session_usertype_ eq "e"><!--- Ajanda employee ise sube departman yetkisine bakar --->
					(
						(
                        	(
                                E.IS_WIEW_BRANCH IS NULL AND 
                                E.IS_WIEW_DEPARTMENT IS NULL AND 
                                E.IS_VIEW_COMPANY IS NULL
                            )
                            OR
                            (
                                E.IS_WIEW_BRANCH IS NULL AND 
                                E.IS_WIEW_DEPARTMENT IS NULL AND 
                                (
                                E.IS_VIEW_COMPANY = 1
                                <cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                                    AND E.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                                </cfif>
                                )
                            )
                        ) OR <!--- Herkes Gorsun --->
						(
                        	E.IS_WIEW_BRANCH IS NOT NULL AND 
                            E.IS_WIEW_BRANCH = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_agenda_department_branch.branch_id#"> AND
                            E.IS_VIEW_COMPANY IS NULL
                        ) OR <!--- Subemdekiler Gorsun --->
						(
                        	E.IS_WIEW_BRANCH IS NOT NULL AND 
                            E.IS_WIEW_DEPARTMENT IS NOT NULL AND 
                            E.IS_WIEW_DEPARTMENT = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_all_agenda_department_branch.department_id#"> AND
                            E.IS_VIEW_COMPANY IS NULL
                        ) <!--- Departmanimdakiler Gorsun --->
					) AND
				</cfif>
				E.VIEW_TO_ALL = 1
			)
		) AND
		</cfif>
		<!--- //Super Kullanici yetkisi olmasi durumunda tum kayitlari gorebilir, asagidaki kontrollere girmez --->
		
		<cfif isDefined("session.agenda_userid")><!--- (Toplanti) Baskasinda ise bu kosul ekleniyor??? --->
			EC.EVENTCAT_ID <> 1 AND
		</cfif>
		<cfif isDefined('attributes.keyword') and Len(attributes.keyword)>
			E.EVENT_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> AND
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
		 	E.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"> AND
		</cfif>
		<cfif isDefined('attributes.eventcat_id') and Len(attributes.eventcat_id)>
			E.EVENTCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#ListSort(ListDeleteDuplicates(attributes.eventcat_id),'numeric','asc',',')#">) AND
		</cfif>
		<cfif isDefined('attributes.startdate1') and Len(attributes.startdate1)>
			E.STARTDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate1#"> AND
		</cfif>
		<cfif isDefined('attributes.startdate2') and Len(attributes.startdate2)>
			E.STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate2#"> AND
		</cfif>
		<cfif isDefined('attributes.finishdate1') and Len(attributes.finishdate1)>
			E.FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate1#"> AND
		</cfif>
		<cfif isDefined('attributes.finishdate2') and Len(attributes.finishdate2)>
			E.FINISHDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate2#"> AND
		</cfif>
		<cfif isDefined('attributes.process_stage') and Len(attributes.process_stage)>
			E.EVENT_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#"> AND
		</cfif>
		<cfif isDefined('attributes.is_event_result') and attributes.is_event_result eq 1><!--- Tutanak Girilmis Mi --->
			E.EVENT_ID IN (SELECT EVENT_ID FROM EVENT_RESULT) AND
        <cfelseif isDefined('attributes.is_event_result') and attributes.is_event_result eq 0>
			E.EVENT_ID NOT IN (SELECT EVENT_ID FROM EVENT_RESULT) AND
		</cfif>
		<cfif isdefined("attributes.member_name") and len(attributes.member_name)><!--- Katilimcilar --->
			<cfif isdefined('attributes.emp_id') and len(attributes.emp_id) and attributes.member_type eq 'employee'>
				E.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.emp_id#,%"> AND
			</cfif>
			<cfif isdefined('attributes.par_id') and len(attributes.par_id) and attributes.member_type eq 'partner'>
				E.EVENT_TO_PAR LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.par_id#,%"> AND
			</cfif>
			<cfif isdefined('attributes.cons_id') and len(attributes.cons_id) and attributes.member_type eq 'consumer'>
				E.EVENT_TO_CON LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.cons_id#,%"> AND
			</cfif>
		</cfif>
		<!--- Ilgili sube ve departmana baglı calısanların katılımcı olarak secilmis oldugu ajanda kayıtlarını listeler --->
		<cfif isdefined('related_emp_ids') and ListLen(related_emp_ids)>
			(<cfloop list="#related_emp_ids#" index="emp_id">
				E.EVENT_TO_POS LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#emp_id#,%"> <cfif emp_id neq listlast(related_emp_ids,',')>OR</cfif>
			</cfloop>)
			AND
		</cfif>
		<!--- //Ilgili sube ve departmana baglı calısanların katılımcı olarak secilmis oldugu ajanda kayıtlarını listeler --->
		E.EVENTCAT_ID = EC.EVENTCAT_ID AND
		E.EVENT_STAGE = PTR.PROCESS_ROW_ID
	ORDER BY
		E.RECORD_DATE DESC
</cfquery>
