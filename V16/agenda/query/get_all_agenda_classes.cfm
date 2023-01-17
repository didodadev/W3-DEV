<!--- 	FBS & EO 20090924
		Gundem ekraninda katilimci oldugum veya chexboxlara gore uygun olan dersler gelir,
		Ajandada herkes gorsun bolumunde herkes gorsun checkboxi secili olanlar gelir katilimcilar gelmez,
		Ajandada subem gorsun bolumunde subem gorsun checkboxi secili olanlar gelir katilimcilar gelmez,
		Ajandada deptim gorsun bolumunde deptim gorsun checkboxi secili olanlar gelir katilimcilar gelmez
		Bana ozel ajandada ise sadece katilimci oldugum dersler gelir, checkboxlar secili olsa da gelmez...
		
		FBS 20100207 Egitimler Gunluk, Haftalik ve Aylik Ajanda Queryleri Tek Sayfada Toplandi
 --->
<cfif isdefined("attributes.date_interval")>
	<cfset date_=attributes.date_interval>
<cfelse>
	<cfset date_=8>
</cfif>
<cfquery name="get_all_agenda_classes" datasource="#dsn#">
	SELECT 
		TRAINING_CLASS.TRAINING_SEC_ID,
		TRAINING_CLASS.TRAINING_ID,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.CLASS_OBJECTIVE,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.ONLINE,
		TRAINING_CLASS.IS_WIEW_DEPARTMENT,
		TRAINING_CLASS.IS_WIEW_BRANCH,
		TRAINING_CLASS.VIEW_TO_ALL,
        TRAINING_CLASS.IS_VIEW_COMPANY
	FROM 
		TRAINING_CLASS
	WHERE
		(
			(TRAINING_CLASS.START_DATE >= #attributes.to_day# AND START_DATE < #dateadd("#add_format_#",date_,attributes.to_day)#) OR
			(TRAINING_CLASS.FINISH_DATE >= #attributes.to_day# AND FINISH_DATE < #dateadd("#add_format_#",date_,attributes.to_day)#)
		) AND
        TRAINING_CLASS.IS_ACTIVE = 1
		<cfif not isDefined("event_calendar")>
		<cfif (isdefined("is_gundem")) or (not isdefined("is_gundem") and not isdefined('attributes.view_agenda'))>
			AND 
			(TRAINING_CLASS.CLASS_ID IN (	SELECT
													CLASS_ID
												FROM
													TRAINING_CLASS_ATTENDER
												WHERE
													CLASS_ID = TRAINING_CLASS_ATTENDER.CLASS_ID
													<cfif isDefined("session.agenda_userid")>
														<!--- baskasinda --->
														AND (
														<cfif session.agenda_user_type is "e">
															<!--- emp --->
															TRAINING_CLASS_ATTENDER.EMP_ID = #session.agenda_userid#
														<cfelseif session.agenda_user_type is "p">
															TRAINING_CLASS_ATTENDER.PAR_ID = #session.agenda_userid#
														<cfelseif session.agenda_user_type is "c">
															TRAINING_CLASS_ATTENDER.CON_ID = #session.agenda_userid#
														</cfif>
														<!--- kaydeden ve guncelleyen kisileri--->
														OR RECORD_EMP = #session.agenda_userid#
														OR UPDATE_EMP = #session.agenda_userid#
														)
													<cfelse>
														<!--- kendinde --->
														AND	(
																TRAINING_CLASS_ATTENDER.EMP_ID = #session.ep.userid#
																<!--- kaydeden ve guncelleyen kisileri--->
																OR RECORD_EMP =  #session.ep.userid#
																OR UPDATE_EMP =  #session.ep.userid#
															)
													</cfif>
													
												)
				 <cfif isdefined("is_gundem")> 
                        OR 
                        (
                            (
                                TRAINING_CLASS.VIEW_TO_ALL = 1 AND 
                                TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND 
                                TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND 
                                TRAINING_CLASS.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id#
                             )
                            OR	
                            (
                                TRAINING_CLASS.VIEW_TO_ALL = 1 AND 
                                TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND 
                                TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL AND 
                                TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id#
                             ) 
                            OR 
                            (
                                TRAINING_CLASS.IS_WIEW_BRANCH IS NULL AND 
                                TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND 
                                TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL AND 
                                TRAINING_CLASS.VIEW_TO_ALL = 1
                             )
                             OR
                             (
                                TRAINING_CLASS.IS_WIEW_BRANCH IS NULL AND 
                                (
                                TRAINING_CLASS.IS_VIEW_COMPANY IN (#my_comp_list#) 
									<cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        				AND TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                                    </cfif>
                                )
                                AND TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL
                                AND TRAINING_CLASS.VIEW_TO_ALL = 1
                             )
						)
				</cfif>
			)
		</cfif>
		</cfif>
		<cfif isdefined('attributes.view_agenda')>
			<cfif isdefined('attributes.view_agenda') and listfindnocase('1',attributes.view_agenda)><!--- departman gorsun --->
				AND	(TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND TRAINING_CLASS.VIEW_TO_ALL = 1 AND TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND TRAINING_CLASS.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
			</cfif>
			<cfif isdefined('attributes.view_agenda') and listfindnocase('2',attributes.view_agenda)><!--- şube görsün --->
				AND	(TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND TRAINING_CLASS.VIEW_TO_ALL = 1 AND TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL AND TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# )
			</cfif>
			<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3><!--- herkes gorsun --->
				AND	
                (
					(TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND TRAINING_CLASS.VIEW_TO_ALL = 1 AND TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# AND TRAINING_CLASS.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
					OR
					(TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND TRAINING_CLASS.VIEW_TO_ALL = 1 AND TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL AND TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# )
					OR	
                	(TRAINING_CLASS.IS_VIEW_COMPANY IS NULL AND TRAINING_CLASS.IS_WIEW_BRANCH IS NULL AND TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL AND TRAINING_CLASS.VIEW_TO_ALL = 1)
                	OR 
                 	(
                    	(TRAINING_CLASS.IS_VIEW_COMPANY IN (#my_comp_list#) 
							<cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        				AND TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                            </cfif>	
                        )
                        AND TRAINING_CLASS.IS_WIEW_BRANCH IS NULL AND TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL AND TRAINING_CLASS.VIEW_TO_ALL = 1)   
                )
			</cfif>
		</cfif>
		ORDER BY 
			TRAINING_CLASS.START_DATE
</cfquery>
<cfquery name="get_all_agenda_classes_inform" datasource="#dsn#">
	SELECT 
		TRAINING_CLASS.TRAINING_SEC_ID,
		TRAINING_CLASS.TRAINING_ID,
		TRAINING_CLASS.CLASS_ID,
		TRAINING_CLASS.CLASS_NAME,
		TRAINING_CLASS.CLASS_OBJECTIVE,
		TRAINING_CLASS.START_DATE,
		TRAINING_CLASS.FINISH_DATE,
		TRAINING_CLASS.ONLINE,
		TRAINING_CLASS_INFORM.CLASS_ID,
		TRAINING_CLASS_INFORM.EMP_ID,
		TRAINING_CLASS_INFORM.PAR_ID,
		TRAINING_CLASS_INFORM.CON_ID,
		TRAINING_CLASS_INFORM.GRP_ID,
		TRAINING_CLASS.IS_WIEW_DEPARTMENT,
		TRAINING_CLASS.IS_WIEW_BRANCH,
		TRAINING_CLASS.VIEW_TO_ALL
	FROM 
		TRAINING_CLASS LEFT JOIN TRAINING_CLASS_COMPANY ON 
        TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_COMPANY.CLASS_ID,
		TRAINING_CLASS_INFORM 
	WHERE
		TRAINING_CLASS.CLASS_ID = TRAINING_CLASS_INFORM.CLASS_ID AND
    	IS_ACTIVE = 1
		<cfif isDefined("session.agenda_userid")>
			<!--- baskasinda --->
			<cfif session.agenda_user_type is "e">
				<!--- emp --->
				AND TRAINING_CLASS_INFORM.EMP_ID = #session.agenda_userid#
			<cfelseif session.agenda_user_type is "p">
				AND TRAINING_CLASS_INFORM.PAR_ID = #session.agenda_userid#
			<cfelseif session.agenda_user_type is "c">
				AND TRAINING_CLASS_INFORM.CON_ID = #session.agenda_userid#
			</cfif>
		<cfelse>
			<!--- kendinde --->
			AND TRAINING_CLASS_INFORM.EMP_ID = #session.ep.userid#
		</cfif>
		<cfif isdefined('attributes.view_agenda') and listfindnocase('1,2,3',attributes.view_agenda)><!--- departman gorsun --->
			AND ( TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NOT NULL AND TRAINING_CLASS.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
		</cfif>
		<cfif isdefined('attributes.view_agenda') and listfindnocase('2,3',attributes.view_agenda)><!--- şube görsün --->
			AND ( TRAINING_CLASS.IS_WIEW_BRANCH IS NOT NULL AND TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# )
		</cfif>
		<cfif isdefined('attributes.view_agenda') and attributes.view_agenda eq 3><!--- herkes gorsun --->
<!---			AND TRAINING_CLASS.VIEW_TO_ALL = 1
--->            AND
                (
                    (
                    	TRAINING_CLASS.VIEW_TO_ALL = 1
                        AND TRAINING_CLASS.IS_VIEW_COMPANY IS NOT NULL 
                        AND 
                        	(TRAINING_CLASS.IS_VIEW_COMPANY IN (#my_comp_list#)
								<cfif isdefined("xml_multiple_comp") and xml_multiple_comp eq 1>
                        				AND TRAINING_CLASS.CLASS_ID IN (SELECT CLASS_ID FROM TRAINING_CLASS_COMPANY WHERE COMPANY_ID IN (#my_comp_list#)) 
                                </cfif>
                            )
                    )
                    OR 
                    (
                    TRAINING_CLASS.VIEW_TO_ALL = 1 AND
                    TRAINING_CLASS.IS_VIEW_COMPANY IS NULL 
					AND TRAINING_CLASS.IS_WIEW_BRANCH IS NULL
					AND TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NULL
                    )
					OR
					( TRAINING_CLASS.IS_WIEW_BRANCH IS NOT NULL AND TRAINING_CLASS.IS_WIEW_BRANCH = #get_all_agenda_department_branch.branch_id# )
					OR
					 ( TRAINING_CLASS.IS_WIEW_DEPARTMENT IS NOT NULL AND TRAINING_CLASS.IS_WIEW_DEPARTMENT = #get_all_agenda_department_branch.department_id# )
                )
		</cfif>
</cfquery>
