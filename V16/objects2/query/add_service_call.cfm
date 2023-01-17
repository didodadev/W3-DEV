<cfif not isdefined('attributes.process_stage') and attributes.is_callcenter_process eq 0>
    <cfquery name="GET_PROCESS" datasource="#DSN#" maxrows="1">
		SELECT TOP 1
			PTR.STAGE,
			PTR.PROCESS_ROW_ID 
		FROM
			PROCESS_TYPE_ROWS PTR,
			PROCESS_TYPE_OUR_COMPANY PTO,
			PROCESS_TYPE PT
		WHERE
			PT.IS_ACTIVE = 1 AND
			PT.PROCESS_ID = PTR.PROCESS_ID AND
			PT.PROCESS_ID = PTO.PROCESS_ID AND
			<cfif isdefined("session.pp")>
				PTR.IS_PARTNER = 1 AND
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			<cfelseif isdefined("session.ww")>
				PTR.IS_CONSUMER = 1 AND
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			<cfelse>
				PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
			</cfif>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.add_service%">
		ORDER BY 
			PTR.LINE_NUMBER
    </cfquery>
    <cfif not get_process.recordcount>
		<script type="text/javascript">
            alert("<cf_get_lang no ='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>
<cfelse>
	<cfif not len(attributes.process_stage)>
		<script type="text/javascript">
            alert("<cf_get_lang no ='33.İşlem Tipleri Tanımlı Değil! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
            history.back();
        </script>
        <cfabort>
    </cfif>
	<cfset get_process.process_row_id = attributes.process_stage>
</cfif>

<cflock timeout="20">
	<cftransaction>
		<cf_papers paper_type="G_SERVICE_APP">
		<cfset system_paper_no=paper_code & '-' & paper_number>
		<cfset system_paper_no_add=paper_number>
		<cfquery name="UPD_GEN_PAP" datasource="#DSN#">
			UPDATE
				GENERAL_PAPERS_MAIN
			SET
				G_SERVICE_APP_NUMBER = #system_paper_no_add#
			WHERE
				G_SERVICE_APP_NUMBER IS NOT NULL
		</cfquery>
	
		<cfquery name="ADD_SERVICE_CALL" datasource="#DSN#">
			INSERT INTO 
				G_SERVICE
				(
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
						SERVICE_COMPANY_ID,
						SERVICE_PARTNER_ID,
					<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
						SERVICE_CONSUMER_ID,
					<cfelseif isdefined("session.pp.userid") and len(session.pp.userid)>
						SERVICE_COMPANY_ID,
						SERVICE_PARTNER_ID,
					<cfelse>
						SERVICE_CONSUMER_ID,
					</cfif>
					<cfif isdefined("session.pp.userid") and len(session.pp.userid)>
						NOTIFY_PARTNER_ID,
					<cfelse>
						NOTIFY_CONSUMER_ID,
					</cfif>
                    SERVICE_BRANCH_ID,
					SUBSCRIPTION_ID,
					SERVICE_ACTIVE,
					ISREAD,
					APPLY_DATE,
					SERVICE_STATUS_ID,
					SERVICECAT_ID,
					SERVICE_HEAD,
					<cfif len(attributes.service_detail)>SERVICE_DETAIL,</cfif>
					APPLICATOR_NAME,
					SERVICE_NO,
					<cfif len(attributes.priority_id)>PRIORITY_ID,</cfif>
					COMMETHOD_ID,
					REF_NO,
					RECORD_DATE,
					<cfif isdefined("session.pp.userid") and len(session.pp.userid)>
						RECORD_PAR
					<cfelse>
						RECORD_CONS
					</cfif>,
                    OUR_COMPANY_ID
				)
			VALUES
				(
					<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
						#attributes.company_id#,
						<cfif isdefined('attributes.partner_id') and len(attributes.partner_id)>#attributes.partner_id#,<cfelse>NULL,</cfif>
					<cfelseif isdefined('attributes.consumer_id') and len(attributes.consumer_id)>
						#attributes.consumer_id#,
					<cfelseif isdefined("session.pp.userid") and len(session.pp.userid)>
						#session.pp.company_id#,
						#session.pp.userid#,
					<cfelse>
						#session.ww.userid#,
					</cfif>
					<cfif isdefined("session.pp.userid") and len(session.pp.userid)>
						#session.pp.userid#,
					<cfelse>
						#session.ww.userid#,
					</cfif>
                    <cfif isDefined('attributes.service_branch_id') and len(attributes.service_branch_id)>#attributes.service_branch_id#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>#attributes.subscription_id#,<cfelse>NULL,</cfif>
					1,
					0,
					#now()#,
					#get_process.process_row_id#,
					#attributes.appcat_id#,
					<cfif len(attributes.service_head)>'#attributes.service_head#'<cfelse>'#system_paper_no#'</cfif>,
					<cfif len(attributes.service_detail)>'#attributes.service_detail#',</cfif>
					<cfif isdefined("attributes.member_name")>'#member_name#',</cfif>
					'#system_paper_no#',
					<cfif len(attributes.priority_id)>#attributes.priority_id#,</cfif>
					<cfif isdefined('attributes.commethod_id') and len(attributes.commethod_id)>#attributes.commethod_id#<cfelse>NULL</cfif>,
					<cfif isdefined('attributes.ref_no') and len(attributes.ref_no)>'#attributes.ref_no#',<cfelse>NULL,</cfif>
					#now()#,
					<cfif isdefined("session.pp.userid") and len(session.pp.userid)>
						#session.pp.userid#
					<cfelse>
						#session.ww.userid#
					</cfif>,
                    <cfif isdefined('session.pp.our_company_id')>#session.pp.our_company_id#<cfelseif isdefined('session.ww.our_company_id')>#session.ww.our_company_id#</cfif>
				)
		</cfquery>
	
		<cfquery name="GET_MAX_ID" datasource="#DSN#">
			SELECT MAX(SERVICE_ID) AS SERVICE_ID FROM G_SERVICE
		</cfquery>
		<cfquery name="ADD_HISTORY" datasource="#DSN#">
			INSERT INTO
				G_SERVICE_HISTORY
			(
				SERVICE_ACTIVE,
				SERVICECAT_ID,
				SERVICE_STATUS_ID,
				PRIORITY_ID,
				COMMETHOD_ID,
				SERVICE_HEAD,
				SERVICE_DETAIL,
				SERVICE_CONSUMER_ID,
				RECORD_DATE,
				RECORD_MEMBER,
				APPLY_DATE,
				FINISH_DATE,
				START_DATE,
				UPDATE_DATE,
				UPDATE_MEMBER,
				RECORD_PAR,
				UPDATE_PAR,
				APPLICATOR_NAME,
				SERVICE_ID,
				RESP_EMP_ID
			)
			SELECT
				SERVICE_ACTIVE,
				SERVICECAT_ID,
				SERVICE_STATUS_ID,
				PRIORITY_ID,
				COMMETHOD_ID,
				SERVICE_HEAD,
				SERVICE_DETAIL,
				SERVICE_CONSUMER_ID,
				RECORD_DATE,
				RECORD_MEMBER,
				APPLY_DATE,
				FINISH_DATE,
				START_DATE,
				UPDATE_DATE,
				UPDATE_MEMBER,
				RECORD_PAR,
				UPDATE_PAR,
				APPLICATOR_NAME,
				SERVICE_ID,
				RESP_EMP_ID
			FROM
				G_SERVICE
			WHERE
				SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_max_id.service_id#">
		</cfquery>	
		
		<!--- alt kategorileri yaziyor --->
		<cfif attributes.is_alt_tree_cat eq 1 or attributes.is_alt_tree_cat eq 2>
			<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#DSN#">
				SELECT SERVICE_SUB_CAT_ID, SERVICE_SUB_CAT, SERVICECAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.appcat_id#">
			</cfquery>
			<cfset my_counter = 0>
			<cfoutput query="get_service_appcat_sub">
				<cfif isdefined("attributes.service_sub_cat_id_#get_service_appcat_sub.service_sub_cat_id#")>
					<cfset deger = evaluate("attributes.service_sub_cat_id_#get_service_appcat_sub.service_sub_cat_id#")>
                    <cfif len(deger)>
                        <cfset my_counter = 1>
                        <cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
                            INSERT INTO 
                                G_SERVICE_APP_ROWS
                                (
                                    SERVICE_ID,
                                    SERVICECAT_ID,
                                    SERVICE_SUB_CAT_ID,
                                    SERVICE_SUB_STATUS_ID
                                )
                                VALUES
                                (
                                    #get_max_id.service_id#,
                                    #attributes.appcat_id#,
                                    #get_service_appcat_sub.service_sub_cat_id#,
                                    #deger#
                                )
                        </cfquery>
                    </cfif>
				</cfif>		
			</cfoutput>
			<cfif my_counter eq 0>
				<cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
					INSERT INTO 
						G_SERVICE_APP_ROWS
						(
							SERVICE_ID,
							SERVICECAT_ID
						)
							VALUES
						(
							#get_max_id.service_id#,
							#attributes.appcat_id#
						)
				</cfquery>
			</cfif>
		</cfif>
        
        <!--- GEÇİCİ 
        <cfquery name="ADD_SERVICE_STATUS_ROW" datasource="#DSN#">
            INSERT INTO 
                G_SERVICE_APP_ROWS
                (
                    SERVICE_ID,
                    SERVICECAT_ID,
                    SERVICE_SUB_CAT_ID,
                    SERVICE_SUB_STATUS_ID
                )
                VALUES
                (
                    #get_max_id.service_id#,
                    #attributes.appcat_id#,
                    #attributes.appcat_sub_id#,
                    #attributes.appcat_sub_status_id#
                )
        </cfquery>--->
        <!--- GEÇİCİ --->        
	</cftransaction>
</cflock>

<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#get_process.process_row_id#' 
	record_member='#session_base.userid#'
	record_date='#now()#' 
	action_table='G_SERVICE'
	action_column='SERVICE_ID'
	action_id='#get_max_id.service_id#' 
	action_page='#request.self#?fuseaction=call.upd_service&service_id=#get_max_id.service_id#' 
	warning_description='Servis Id : #get_max_id.service_id#'>
<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cflocation url="#request.self#?fuseaction=objects2.add_service_callcenter_system&is_save=1" addtoken="no">
<cfelseif isdefined('attributes.servis_call_type') and attributes.servis_call_type eq 1>
	<script type="text/javascript">
		window.close();
	</script>
<cfelse>
	<cflocation url="#request.self#?fuseaction=objects2.upd_service_call_center&service_id=#get_max_id.service_id#" addtoken="no">
</cfif>
