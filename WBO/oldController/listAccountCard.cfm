<cf_get_lang_set module_name="account">
<cf_xml_page_edit fuseact="account.list_account_card">
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_STATUS,
		BRANCH.HIERARCHY,
		BRANCH.HIERARCHY2,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMP_ID,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.NICK_NAME
	FROM
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID IS NOT NULL
		AND BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		AND BRANCH.BRANCH_STATUS = 1
	ORDER BY
		OUR_COMPANY.NICK_NAME,
		BRANCH.BRANCH_NAME
</cfquery>
<cfset yevmiye_borc=0>
<cfset yevmiye_alacak=0>
<cfset yevmiye_borc_dev=0>
<cfset yevmiye_alacak_dev=0>
<cfset row_counter=0>
<cfif not isdefined('attributes.date1') or not isdefined('attributes.date2')>
	<cfset date1 = "#day(now())#/#month(now())#/#session.ep.period_year#" >
	<cfset date2 = "#day(now())#/#month(now())#/#session.ep.period_year#">
<cfelse>
	<cf_date tarih="attributes.date1">
	<cf_date tarih="attributes.date2">
	<cfset date1 = dateformat(attributes.date1,'dd/mm/yyyy') >
	<cfset date2 = dateformat(attributes.date2,'dd/mm/yyyy') >
</cfif>
<cfparam name="attributes.form_is_submitted" default="0">
<cfparam name="attributes.is_detail" default="0">
<cfparam name="attributes.is_quantity" default="0">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.acc_card_type" default="">
<cfparam name="attributes.acc_code_type" default="0">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.is_sub_project" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.acc_code1_1" default="">
<cfparam name="attributes.acc_code2_1" default="">
<cfparam name="attributes.acc_code1_2" default="">
<cfparam name="attributes.acc_code2_2" default="">
<cfparam name="attributes.acc_code1_3" default="">
<cfparam name="attributes.acc_code2_3" default="">
<cfparam name="attributes.acc_code1_4" default="">
<cfparam name="attributes.acc_code2_4" default="">
<cfparam name="attributes.acc_code1_5" default="">
<cfparam name="attributes.acc_code2_5" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_acc_card_type" datasource="#dsn3#">
    SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (10,11,12,13,14,19) ORDER BY PROCESS_TYPE
</cfquery>
<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
    <cfquery name="GET_DEPARTMANT" datasource="#DSN#">
        SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> ORDER BY DEPARTMENT_HEAD
    </cfquery>
</cfif>
<cfif attributes.form_is_submitted>
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	</cfif>
     <cfsavecontent variable="excel_icerik">
		<cfquery name="GET_CARD_ID" datasource="#dsn2#" cachedwithin="#fusebox.general_cached_time#">
			<cfif isdefined('attributes.is_detail') and attributes.is_detail eq 1>
				SELECT 
					CARD_ID, 
					ACTION_DATE,
					BILL_NO,
					CARD_TYPE,
					CARD_TYPE_NO,		
					PAPER_NO,
					ACTION_TYPE,
					CARD_DETAIL,
					COMPANY.FULLNAME AS CARI_HESAP,
					COMPANY.TAXOFFICE AS VERGI_DAIRESI,
					COMPANY.TAXNO AS VERGI_NO,
					COMPANY.IS_RELATED_COMPANY AS BAGLI_UYE
				FROM
					ACCOUNT_CARD,
					#dsn_alias#.COMPANY COMPANY
				WHERE 
					ACC_COMPANY_ID = COMPANY.COMPANY_ID AND 
					ACC_COMPANY_ID IS NOT NULL
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>				
					<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
						AND ACTION_DATE <= #attributes.date2# 
						AND ACTION_DATE>=#attributes.date1#
					</cfif>
					<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
						AND CARD_ID IN 
						(SELECT 
							ACR.CARD_ID
						FROM 
							#dsn_alias#.PRO_PROJECTS,
							ACCOUNT_CARD_ROWS ACR
						WHERE 
							PROJECT_ID = ACR.ACC_PROJECT_ID 
							<cfif attributes.is_sub_project	eq 1>
								AND (RELATED_PROJECT_ID = #attributes.project_id# OR ACR.ACC_PROJECT_ID = #attributes.project_id#)
							<cfelse>
								AND ACR.ACC_PROJECT_ID = #attributes.project_id#
							</cfif>
						)
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_BRANCH_ID = #attributes.branch_id#)
					</cfif>
					<cfif isdefined("attributes.department") and len(attributes.department)>
						AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_DEPARTMENT_ID = #attributes.department#)
					</cfif>	
					<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
						AND CARD_ID IN
							(SELECT
								ACR.CARD_ID	
							FROM 
								ACCOUNT_CARD_ROWS ACR
							WHERE 
								1=1
								AND 
								(
									<cfloop from="1" to="5" index="kk">
										<cfif kk neq 1>OR</cfif>
										(
											1 = 0
											<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
												OR
												(
													1 = 1
													<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
														<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
															AND ACR.IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
														<cfelse>
															AND ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
														</cfif>
													</cfif>
													<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
														<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
															AND ACR.IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
														<cfelse>
															AND ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
														</cfif>
													</cfif>
												)
											</cfif>
										)
									</cfloop>
								)
							)
					</cfif>							
				UNION 
				SELECT 
					CARD_ID, 
					ACTION_DATE,
					BILL_NO,
					CARD_TYPE,
					CARD_TYPE_NO,		
					PAPER_NO,
					ACTION_TYPE,
					CARD_DETAIL,
					(CONSUMER.CONSUMER_NAME + CONSUMER.CONSUMER_SURNAME) AS CARI_HESAP,
					CONSUMER.TAX_OFFICE AS VERGI_DAIRESI,
					TAX_POSTCODE AS VERGI_NO,
					CONSUMER.IS_RELATED_CONSUMER AS BAGLI_UYE
				FROM
					ACCOUNT_CARD,	
					#dsn_alias#.CONSUMER CONSUMER
				WHERE 	
					ACC_CONSUMER_ID = CONSUMER.CONSUMER_ID AND 
					ACC_CONSUMER_ID IS NOT NULL
					<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
						AND (
						<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
							(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
							<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
						</cfloop>  
							)
					</cfif>				
					<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
						AND ACTION_DATE <= #attributes.date2# 
						AND ACTION_DATE>=#attributes.date1#
					</cfif>
					<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
						AND CARD_ID IN 
						(SELECT 
							ACR.CARD_ID
						FROM 
							#dsn_alias#.PRO_PROJECTS,
							ACCOUNT_CARD_ROWS ACR
						WHERE 
							PROJECT_ID = ACR.ACC_PROJECT_ID 
							<cfif attributes.is_sub_project	eq 1>
								AND (RELATED_PROJECT_ID = #attributes.project_id# OR ACR.ACC_PROJECT_ID = #attributes.project_id#)
							<cfelse>
								AND ACR.ACC_PROJECT_ID = #attributes.project_id#
							</cfif>
						)
					</cfif>
					<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
						AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_BRANCH_ID = #attributes.branch_id#)
					</cfif>
					<cfif isdefined("attributes.department") and len(attributes.department)>
						AND CARD_ID IN(SELECT ACR.CARD_ID FROM ACCOUNT_CARD_ROWS ACR WHERE ACR.ACC_DEPARTMENT_ID = #attributes.department#)
					</cfif>	
					<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
						AND CARD_ID IN
							(SELECT
								ACR.CARD_ID	
							FROM 
								ACCOUNT_CARD_ROWS ACR
							WHERE 
								1=1
								AND 
								(
									<cfloop from="1" to="5" index="kk">
										<cfif kk neq 1>OR</cfif>
										(
											1 = 0
											<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
												OR
												(
													1 = 1
													<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
														<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
															AND ACR.IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
														<cfelse>
															AND ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
														</cfif>
													</cfif>
													<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
														<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
															AND ACR.IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
														<cfelse>
															AND ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
														</cfif>
													</cfif>
												)
											</cfif>
										)
									</cfloop>
								)
							)
					</cfif>
				UNION 
			</cfif>
			SELECT 
				CARD_ID, 
				ACTION_DATE,
				BILL_NO,
				CARD_TYPE,
				CARD_TYPE_NO,
				PAPER_NO,
				ACTION_TYPE,
				CARD_DETAIL,
				'' AS CARI_HESAP,
				'' AS VERGI_DAIRESI,
				'' AS VERGI_NO,
				2 AS BAGLI_UYE
			FROM
				ACCOUNT_CARD 
			WHERE 
				CARD_ID IS NOT NULL
				<cfif isdefined('attributes.acc_card_type') and len(attributes.acc_card_type)>
					AND (
					<cfloop list="#attributes.acc_card_type#" delimiters="," index="type_ii">
						(ACCOUNT_CARD.CARD_TYPE = #listfirst(type_ii,'-')# AND ACCOUNT_CARD.CARD_CAT_ID = #listlast(type_ii,'-')#)
						<cfif type_ii neq listlast(attributes.acc_card_type,',') and listlen(attributes.acc_card_type,',') gte 1> OR</cfif>
					</cfloop>  
						)
				</cfif>				
				<cfif isdefined('attributes.is_detail') and attributes.is_detail eq 1>
					AND ACC_CONSUMER_ID IS NULL
					AND ACC_COMPANY_ID IS NULL 
				</cfif>
				<cfif isDefined("attributes.date1") and isDefined("attributes.date2")>
					AND ACTION_DATE <= #attributes.date2# 
					AND ACTION_DATE> = #attributes.date1#
				</cfif>
				<cfif isdefined('attributes.project_head') and len(attributes.project_head) and len(attributes.project_id)>
					AND CARD_ID IN 
					(SELECT 
						ACR.CARD_ID
					FROM 
						#dsn_alias#.PRO_PROJECTS,
						ACCOUNT_CARD_ROWS ACR
					WHERE 
						PROJECT_ID = ACR.ACC_PROJECT_ID 
						<cfif attributes.is_sub_project	eq 1>
							AND (RELATED_PROJECT_ID = #attributes.project_id# OR ACR.ACC_PROJECT_ID = #attributes.project_id#)
						<cfelse>
							AND ACR.ACC_PROJECT_ID = #attributes.project_id#
						</cfif>
					)
				</cfif>
				<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
					AND CARD_ID IN(SELECT ACR_1.CARD_ID FROM ACCOUNT_CARD_ROWS ACR_1 WHERE ACR_1.ACC_BRANCH_ID = #attributes.branch_id#)
				</cfif>
				<cfif isdefined("attributes.department") and len(attributes.department)>
					AND CARD_ID IN(SELECT ACR_2.CARD_ID FROM ACCOUNT_CARD_ROWS ACR_2 WHERE ACR_2.ACC_DEPARTMENT_ID = #attributes.department#)
				</cfif>	
				<cfif (isDefined("attributes.acc_code1_1") and len(evaluate("attributes.acc_code1_1"))) or (isDefined("attributes.acc_code1_2") and len(evaluate("attributes.acc_code1_2"))) or (isDefined("attributes.acc_code1_3") and len(evaluate("attributes.acc_code1_3"))) or (isDefined("attributes.acc_code1_4") and len(evaluate("attributes.acc_code1_4"))) or (isDefined("attributes.acc_code1_5") and len(evaluate("attributes.acc_code1_5")))>
					AND CARD_ID IN
						(SELECT
							ACR.CARD_ID	
						FROM 
							ACCOUNT_CARD_ROWS ACR
						WHERE 
							1=1
							AND 
							(
								<cfloop from="1" to="5" index="kk">
									<cfif kk neq 1>OR</cfif>
									(
										1 = 0
										<cfif (isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))) or (isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#")))>
											OR
											(
												1 = 1
												<cfif isDefined("attributes.acc_code1_#kk#") and len(evaluate("attributes.acc_code1_#kk#"))>
													<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
														AND ACR.IFRS_CODE >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
													<cfelse>
														AND ACR.ACCOUNT_ID >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code1_#kk#")#">
													</cfif>
												</cfif>
												<cfif isDefined("attributes.acc_code2_#kk#") and len(evaluate("attributes.acc_code2_#kk#"))>
													<cfif isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1>
														AND ACR.IFRS_CODE <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
													<cfelse>
														AND ACR.ACCOUNT_ID <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate("attributes.acc_code2_#kk#")#">
													</cfif>
												</cfif>
											)
										</cfif>
									)
								</cfloop>
							)
						)
				</cfif>
			ORDER BY
				ACTION_DATE,
				BILL_NO
		</cfquery>
		<!--- <cfdump var="#GET_CARD_ID#"> --->
		<cfparam name="attributes.totalrecords" default="#get_card_id.recordcount#">
		<cfset endrow=attributes.maxrows+attributes.startrow-1>
		<cfif attributes.totalrecords lt endrow>
			<cfset endrow=attributes.totalrecords>
		</cfif>
		<cfif isdefined('get_card_id.recordcount')>
			<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
				<cfset endrow=get_card_id.recordcount>
			</cfif>
		</cfif>
        <cfif get_card_id.recordcount>
				<!---  devreden  --->
			<cfif attributes.page gt 1 >
                <cfset our_ls=attributes.startrow-1>
                <cfset yevmiye_borc_dev=0>
                <cfset yevmiye_alacak_dev=0>
                <cfloop from="1" to="#our_ls#" index="I">
                    <cfquery name="GET_CARD_ROWS" datasource="#DSN2#">
                        SELECT 
                            ACR.AMOUNT,
                            ACR.BA,
                            ACR.DETAIL,
                            <cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
                                AP.IFRS_CODE AS ACC_ACCOUNT_ID,
                                AP.IFRS_NAME AS ACCOUNT_NAME
                            <cfelse>
                                ACR.ACCOUNT_ID AS ACC_ACCOUNT_ID,
                                AP.ACCOUNT_NAME
                            </cfif>
                        FROM 
                            ACCOUNT_CARD_ROWS ACR,
                            ACCOUNT_PLAN AP 
                        WHERE 
                            CARD_ID=#GET_CARD_ID.CARD_ID[I]# AND 
                            AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
                        ORDER BY BA ASC,AMOUNT DESC
                    </cfquery>
                    <cfoutput query="GET_CARD_ROWS">
                        <cfif BA EQ 0>
                            <cfset yevmiye_borc_dev=yevmiye_borc_dev+AMOUNT>
                        <cfelse>
                            <cfset yevmiye_alacak_dev=yevmiye_alacak_dev+AMOUNT>
                        </cfif>
                    </cfoutput>
                </cfloop>
             </cfif>
             <cfloop from="#attributes.startrow#" to="#endrow#" index="I">
				<cfset A_toplam=0>
                <cfset B_toplam=0>
                <cfquery name="GET_CARD_ROWS" datasource="#DSN2#">
                    SELECT 
                        ACR.*,
                        PRO_PROJECTS.PROJECT_HEAD,
                        DEPARTMENT.DEPARTMENT_HEAD,							
                        BRANCH.BRANCH_NAME,
                        <cfif (isdefined('attributes.acc_code_type') and attributes.acc_code_type eq 1)>
                            AP.IFRS_CODE AS ACC_ACCOUNT_ID,
                            AP.IFRS_NAME AS ACCOUNT_NAME
                        <cfelse>
                            ACR.ACCOUNT_ID AS ACC_ACCOUNT_ID,
                            AP.ACCOUNT_NAME
                        </cfif>
                    FROM 
                        ACCOUNT_CARD_ROWS ACR
                            LEFT JOIN #dsn_alias#.PRO_PROJECTS ON ACR.ACC_PROJECT_ID = PRO_PROJECTS.PROJECT_ID
                            LEFT JOIN #dsn_alias#.DEPARTMENT ON ACR.ACC_DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
                            LEFT JOIN #dsn_alias#.BRANCH ON ACR.ACC_BRANCH_ID = BRANCH.BRANCH_ID,
                        ACCOUNT_PLAN AP 
                    WHERE 
                        CARD_ID=#GET_CARD_ID.CARD_ID[I]# AND 
                        AP.ACCOUNT_CODE=ACR.ACCOUNT_ID
                    ORDER BY BA ASC,AMOUNT DESC
                </cfquery>
            </cfloop>
         </cfif>
         
     </cfsavecontent>
</cfif>
<script type="text/javascript">
	function kontrol_tarih()
	{
		if(list_acc_card.date1.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_acc_card.date1.value, 'Başlangıç Tarihi'))
				return false;
		}
		if(list_acc_card.date2.value.length){
			if (!global_date_check_value("01/01/<cfoutput>#SESSION.EP.PERIOD_YEAR#</cfoutput>",list_acc_card.date2.value, 'Bitiş Tarihi'))
				return false;
		}
		if(document.list_acc_card.is_excel.checked==false)
		{
			document.list_acc_card.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.list_account_card</cfoutput>";
			return true;
		}
		else
		{	
			document.list_acc_card.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_list_account_card</cfoutput>";
		}
	}
	function pencere_ac()
	{
		if((document.list_acc_card.date1.value=='') || (document.list_acc_card.date2.value==''))
			{
			alert("<cf_get_lang no ='197.Önce Tarihleri Seçiniz'>!");
			return false;
			}
			date1 = document.list_acc_card.date1.value;
			date2 = document.list_acc_card.date2.value;
			if(document.list_acc_card.is_detail.checked==true)
				is_detail = 1;
			else
				is_detail = 0;
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=report.popup_rapor_yevmiye&date1='+date1+'&date2='+date2+'&is_detail='+is_detail,'norm_horizontal');
	}
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById("branch_id").value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popupajax_list_departments&branch_id="+branch_id;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,'İlişkili Departmanlar');
		}
		else
		{
			var myList = document.getElementById("department");
			myList.options.length = 0;
			var txtFld = document.createElement("option");
			txtFld.value='';
			txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
			myList.appendChild(txtFld);
		}
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_card';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_account_card.cfm';
</cfscript>
