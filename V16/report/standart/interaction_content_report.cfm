<!--- Etkileşim İçerik Raporu --->
<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.app_cat" default="">
<cfparam name="attributes.record_emp" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.is_excel" default="">
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
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
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.helpdesk%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_INTERCT_CAT" datasource="#DSN#">
	SELECT INTERACTIONCAT_ID,INTERACTIONCAT FROM SETUP_INTERACTION_CAT ORDER BY INTERACTIONCAT 
</cfquery>
<cfquery name="GET_COMMETHOD" datasource="#DSN#">
	SELECT COMMETHOD_ID, COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>	
<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="GET_CUSTOMERS" datasource="#DSN#">
		<cfif len(attributes.start_date)>
			<cf_date tarih = "attributes.start_date">
		</cfif>
		<cfif len(attributes.finish_date)>
			<cf_date tarih = "attributes.finish_date">
		</cfif>
		SELECT 
			C.COMPANY_VALUE_ID CUSTOMER_VALUE_ID,
			C.COMPANY_STATUS STATUS,
			C.ISPOTANTIAL,
			C.NICKNAME,
			(SELECT TOP 1 POSITION_CODE FROM WORKGROUP_EMP_PAR WEP WHERE IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND  WEP.COMPANY_ID = C.COMPANY_ID) POS_CODE,
			CH.SUBJECT,
			ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) UPDATE_DATE,
			C.MANAGER_PARTNER_ID,
			C.COMPANY_TELCODE TEL_CODE,
			C.COMPANY_TEL1 TEL,
			C.COMPANY_EMAIL EMAIL,
            CH.RECORD_EMP,
            CH.RECORD_PAR,
            CH.RECORD_CONS,
			CH.COMPANY_ID,
			CH.CONSUMER_ID,
			CH.PROCESS_STAGE,
			CH.SOLUTION_DETAIL,
			CH.INTERACTION_CAT,
			CH.CUS_HELP_ID
		FROM
			COMPANY C,
			CUSTOMER_HELP CH
		WHERE
			CH.COMPANY_ID=C.COMPANY_ID AND
			C.COMPANY_STATUS <> 0
			<cfif isdefined("attributes.last_interact")>
				AND 
					CH.CUS_HELP_ID = 
						(SELECT TOP 1 
							CC.CUS_HELP_ID 
						FROM 
							CUSTOMER_HELP CC 
						WHERE 
							CC.COMPANY_ID = CH.COMPANY_ID 
							<cfif len(attributes.app_cat)>
								AND CC.APP_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.app_cat#">)
							</cfif>
						ORDER BY 
							ISNULL(UPDATE_DATE,RECORD_DATE) DESC
						)
			</cfif>
			<cfif len(attributes.start_date)>
				AND ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				AND ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finish_date)#">
			</cfif>
			<cfif len(attributes.company) and len(attributes.company_id)>
				AND CH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif len(attributes.company) and len(attributes.consumer_id)>
				AND CH.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.app_cat)>
				AND CH.APP_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.app_cat#">)
			</cfif>
			<cfif isdefined("attributes.special_definition") and len(attributes.special_definition)>
				AND CH.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
			</cfif>
			<cfif isdefined('attributes.process_stage') and listlen(attributes.process_stage)>AND CH.PROCESS_STAGE IN (#attributes.process_stage#)</cfif>
            <cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>AND CH.INTERACTION_CAT IN (#attributes.interaction_cat#)</cfif>
			<cfif len(attributes.record_emp) and len(attributes.record_name)>
				AND CH.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp#">
			</cfif>
			<cfif isdefined('attributes.applicant_name') and len(attributes.applicant_name)>AND CH.APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.applicant_name#%"></cfif>
		UNION ALL
		SELECT
			C.CUSTOMER_VALUE_ID CUSTOMER_VALUE_ID,
			C.CONSUMER_STATUS STATUS,
			'' ISPOTANTIAL,
			C.CONSUMER_NAME+' '+CONSUMER_SURNAME NICKNAME,
			(SELECT TOP 1 POSITION_CODE FROM WORKGROUP_EMP_PAR WEP WHERE IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND WEP.CONSUMER_ID = C.CONSUMER_ID) POS_CODE,
			CH.SUBJECT,
			ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) UPDATE_DATE,
			'' MANAGER_PARTNER_ID,
			C.MOBIL_CODE TEL_CODE,
			C.MOBILTEL TEL,
			C.CONSUMER_EMAIL EMAIL,
            CH.RECORD_EMP,
            CH.RECORD_PAR,
            CH.RECORD_CONS,
			CH.COMPANY_ID,
			CH.CONSUMER_ID,
			CH.PROCESS_STAGE,
			CH.SOLUTION_DETAIL,
			CH.INTERACTION_CAT,
			CH.CUS_HELP_ID
		FROM
			CONSUMER C,
			CUSTOMER_HELP CH
		WHERE
			CH.CONSUMER_ID=C.CONSUMER_ID AND
			C.CONSUMER_STATUS <> 0
			<cfif isdefined("attributes.last_interact")>
				AND 
					CH.CUS_HELP_ID = 
						(SELECT TOP 1 
							CC.CUS_HELP_ID 
						FROM 
							CUSTOMER_HELP CC 
						WHERE 
							CC.CONSUMER_ID=CH.CONSUMER_ID 
							<cfif len(attributes.app_cat)>
								AND CC.APP_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.app_cat#">)
							</cfif>
						ORDER BY 
							ISNULL(UPDATE_DATE,RECORD_DATE) DESC
						)
			</cfif>
			<cfif len(attributes.start_date)>
				AND ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
			</cfif>
			<cfif len(attributes.finish_date)>
				AND ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.finish_date)#">
			</cfif>
			<cfif len(attributes.company) and len(attributes.company_id)>
				AND CH.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif len(attributes.company) and len(attributes.consumer_id)>
				AND CH.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
			</cfif>
			<cfif len(attributes.app_cat)>
				AND CH.APP_CAT IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.app_cat#">)
			</cfif>
			<cfif isdefined("attributes.special_definition") and len(attributes.special_definition)>
				AND CH.SPECIAL_DEFINITION_ID IN (#attributes.special_definition#)
			</cfif>
			<cfif isdefined('attributes.process_stage') and listlen(attributes.process_stage)>AND CH.PROCESS_STAGE IN (#attributes.process_stage#)</cfif>
            <cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>AND CH.INTERACTION_CAT IN (#attributes.interaction_cat#)</cfif>
			<cfif len(attributes.record_emp) and len(attributes.record_name)>
				AND CH.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp#">
			</cfif>
			<cfif isdefined('attributes.applicant_name') and len(attributes.applicant_name)>AND CH.APPLICANT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.applicant_name#%"></cfif>
		ORDER BY
			ISNULL(CH.UPDATE_DATE,CH.RECORD_DATE) DESC
	</cfquery>
<cfelse>
	<cfset get_customers.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_customers.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = ''>
<cfif isDefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
	<cfset url_str = '#url_str#&is_form_submitted=#attributes.is_form_submitted#'>
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset url_str = '#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = '#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
</cfif>
<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
	<cfset url_str = '#url_str#&company_id=#attributes.company_id#'>
</cfif>
<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
	<cfset url_str = '#url_str#&consumer_id=#attributes.consumer_id#'>
</cfif>
<cfif isDefined('attributes.company') and len(attributes.company)>
	<cfset url_str = '#url_str#&company=#attributes.company#'>
</cfif>
<cfif isDefined('attributes.process_stage') and len(attributes.process_stage)>
	<cfset url_str = '#url_str#&process_stage=#attributes.process_stage#'>
</cfif>
<cfif isDefined('attributes.interaction_cat') and len(attributes.interaction_cat)>
	<cfset url_str = '#url_str#&interaction_cat=#attributes.interaction_cat#'>
</cfif>
<cfif isDefined('attributes.app_cat') and len(attributes.app_cat)>
	<cfset url_str = '#url_str#&app_cat=#attributes.app_cat#'>
</cfif>
<cfif isDefined('attributes.record_emp') and len(attributes.record_emp)>
	<cfset url_str = '#url_str#&record_emp=#attributes.record_emp#'>
</cfif>
<cfif isDefined('attributes.record_name') and len(attributes.record_name)>
	<cfset url_str = '#url_str#&record_name=#attributes.record_name#'>
</cfif>
<cfif isDefined('attributes.applicant_name') and len(attributes.applicant_name)>
	<cfset url_str = '#url_str#&applicant_name=#attributes.applicant_name#'>
</cfif>
<cfif isdefined("attributes.is_answer")>
	<cfset url_str = "#url_str#&is_answer=1">
</cfif>
<cfif isdefined("attributes.last_interact")>
	<cfset last_interact = "#url_str#&last_interact=1">
</cfif>
<cfif get_customers.recordcount>
	<cfset customer_value_id_list = ''>
	<cfset pos_code_list = ''>
	<cfset manager_part_id_list = ''>
	<cfset interaction_cat_id_list =''>
	<cfset stage_list =''>
	<cfoutput query="get_customers">
		<cfif isdefined('customer_value_id') and len(customer_value_id) and not listfind(customer_value_id_list,customer_value_id)>
			<cfset customer_value_id_list=listappend(customer_value_id_list,customer_value_id)>
		</cfif>
		<cfif isdefined('pos_code') and len(pos_code) and not listfind(pos_code_list,pos_code)>
			<cfset pos_code_list=listappend(pos_code_list,pos_code)>
		</cfif>
		<cfif isdefined('manager_partner_id') and len(manager_partner_id) and not listfind(manager_part_id_list,manager_partner_id)>
			<cfset manager_part_id_list=listappend(manager_part_id_list,manager_partner_id)>
		</cfif>
		<cfif len(interaction_cat) and not listfind(interaction_cat_id_list,interaction_cat)>
			<cfset interaction_cat_id_list=listappend(interaction_cat_id_list,interaction_cat)>
		</cfif>	
		<cfif len(process_stage) and not listfind(stage_list,process_stage)>
			<cfset stage_list=listappend(stage_list,process_stage)>
		</cfif>
	</cfoutput>
	<cfif listlen(customer_value_id_list)>
		<cfset customer_value_id_list=listsort(customer_value_id_list,"numeric","ASC",",")>
		<cfquery name="GET_CUSTOM_VALUE" datasource="#DSN#">
			SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE WHERE CUSTOMER_VALUE_ID IN (#customer_value_id_list#) ORDER BY CUSTOMER_VALUE_ID
		</cfquery>
		<cfset customer_value_id_list = listsort(listdeleteduplicates(valuelist(get_custom_value.CUSTOMER_VALUE_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(pos_code_list)>
		<cfset pos_code_list=listsort(pos_code_list,"numeric","ASC",",")>
		<cfquery name="GET_POS_CODE" datasource="#DSN#">
			SELECT POSITION_CODE,EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME POS_CODE_TEXT FROM EMPLOYEE_POSITIONS WHERE IS_MASTER = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND POSITION_CODE IN (#pos_code_list#) ORDER BY POSITION_CODE
		</cfquery>
		<cfset pos_code_list = listsort(listdeleteduplicates(valuelist(get_pos_code.POSITION_CODE,',')),'numeric','ASC',',')>
	</cfif>
	<cfif listlen(manager_part_id_list)>
		<cfset manager_part_id_list=listsort(manager_part_id_list,"numeric","ASC",",")>
		<cfquery name="GET_MANAGER" datasource="#DSN#">
			SELECT PARTNER_ID,COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME MANAGER_PARTNER FROM COMPANY_PARTNER WHERE PARTNER_ID IN (#manager_part_id_list#) ORDER BY PARTNER_ID
		</cfquery>
		<cfset manager_part_id_list = listsort(listdeleteduplicates(valuelist(get_manager.PARTNER_ID,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(interaction_cat_id_list)>
		<cfset interaction_cat_id_list=listsort(interaction_cat_id_list,"numeric","ASC",",")>
		<cfquery name="GET_INTERACTIONCAT" datasource="#DSN#">
			SELECT INTERACTIONCAT_ID,INTERACTIONCAT FROM SETUP_INTERACTION_CAT WHERE INTERACTIONCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#interaction_cat_id_list#">)  ORDER BY INTERACTIONCAT_ID
		</cfquery>
		<cfset interaction_cat_id_list = listsort(listdeleteduplicates(valuelist(get_interactioncat.interactioncat_id,',')),'numeric','ASC',',')>
	</cfif>
	<cfif len(stage_list)>
		<cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
		<cfquery name="PROCESS_TYPE" datasource="#DSN#">
			SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#stage_list#">) ORDER BY PROCESS_ROW_ID
		</cfquery>
		<cfset stage_list = listsort(listdeleteduplicates(valuelist(process_type.process_row_id,',')),'numeric','ASC',',')>
	</cfif>
</cfif>
<cfform name="customer_service_report" action="#request.self#?fuseaction=report.interaction_content_report" method="post">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='40702.Etkileşim İçerik Raporu'></cfsavecontent>	
	<cf_report_list_search title="#title#" id="search">
		<cf_report_list_search_area>
			<div class="row">
				<div class="col col-12 col-xs-12">
					<div class="row formContent">
						<div class="row" type="row">
							<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group" id="item-process_stage">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<select name="process_stage" id="process_stage"  multiple="multiple">
												<cfloop query="get_process_stage">
													<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and listfindnocase(attributes.process_stage,PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
												</cfloop>
											</select>
										</cfoutput>	
									</div>
								</div>				
								<div class="form-group"  id="item-interaction_cat">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
									<div class="col col-12 col-xs-12">
										<cfoutput>
											<select name="interaction_cat" id="interaction_cat"  multiple="multiple">
												<cfloop query="get_interct_cat">
													<option value="#interactioncat_id#" <cfif isdefined("attributes.interaction_cat") and listfindnocase(attributes.interaction_cat,interactioncat_id)>selected</cfif>><cfoutput>#interactioncat#</cfoutput></option>
												</cfloop> 			  
											</select>
										</cfoutput>
									</div>
								</div>	
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group" id="item-app_cat">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></label>
									<div class="col col-12 col-xs-12">
										<select name="app_cat" id="app_cat"  multiple="multiple">
											<cfoutput query="get_commethod">
												<option value="#commethod_id#" <cfif isdefined("attributes.app_cat") and listfindnocase(attributes.app_cat,commethod_id)>selected</cfif>>#commethod#</option>
											</cfoutput>
										</select>
									</div>
								</div>	
								<div class="form-group" id="item-date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='40703.Etkileşim Tarihi'></label>
										<div class="col col-12 col-xs-12">
											<div class="col col-6">
												<div class="input-group">
													<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
													<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#" maxlength="10"   >
													<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
												</div>
											</div>
											<div class="col col-6">
												<div class="input-group">
													<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#"  message="#message#" maxlength="10" >
													<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
												</div>
											</div>
										</div>
									</div>
								<div class="form-group" id="item-company_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57658.Üye'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
											<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
											<input type="text" name="company" id="company" value="<cfif Len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>"  onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID','consumer_id,company_id','','3','147');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=customer_service_report.company_id&field_member_name=customer_service_report.company&field_consumer=customer_service_report.consumer_id&select_list=2,3')"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group" id="item-record_emp">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
									<div class="col col-12">
										<div class="input-group">
											<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#attributes.record_emp#</cfoutput>">
											<cfinput type="text" name="record_name" id="record_name"  value="#attributes.record_name#" maxlength="255" onFocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','customer_service_report','3','147');">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=customer_service_report.record_emp&field_name=customer_service_report.record_name&select_list=1');"></span>
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group" id="item-applicant_name">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="29514.Başvuru Yapan"></label>
									<div class="col col-12">
										<input type="text" name="applicant_name" id="applicant_name" value="<cfif isdefined("attributes.applicant_name") and len(attributes.applicant_name)><cfoutput>#attributes.applicant_name#</cfoutput></cfif>" maxlength="100" >
									</div>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
								<div class="form-group" id="item-is_answer">
									<label class="col col-12 col-xs-12"><input type="checkbox" name="is_answer" id="is_answer" <cfif isdefined("attributes.is_answer")>checked</cfif>><cf_get_lang dictionary_id="39748.Etkileşim Cevaplarını Göster"></label>
								</div>
								<div class="form-group"  id="item-last_interact">
									<label class="col col-12 col-xs-12"><input type="checkbox" name="last_interact" id="last_interact" <cfif isdefined("attributes.last_interact")>checked</cfif>><cf_get_lang dictionary_id="39749.Son Etkileşimleri Göster"></label>
								</div>
							</div>
						</div>
					</div>
					<div class="row ReportContentBorder">
						<div class="ReportContentFooter">
							<label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" >
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57911.Çalıştır'></cfsavecontent>
							<cf_wrk_report_search_button is_excel='1' button_type='1' insert_info='#message#' search_function='control()'> 
						</div>
					</div>
				</div>
			</div>
		</cf_report_list_search_area>
	</cf_report_list_search>
</cfform>	
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
	<cfset type_ = 1>
	<cfset attributes.startrow=1>
	<cfset attributes.maxrows = get_customers.recordcount>
<cfelse>
	<cfset type_ = 0>
</cfif>
<cf_report_list>
	<cf_wrk_html_table class="ajax_list" table_draw_type="#type_#" filename="interaction_content_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cf_wrk_html_thead>
		<cf_wrk_html_tr>
			<cf_wrk_html_th></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57487.No'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='58552.Müşteri Değeri'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57756.Status'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57658.Üye'></cf_wrk_html_th>
			<cf_wrk_html_th><cfoutput>#getLang('campaign',94)#</cfoutput></cf_wrk_html_th>
			<cf_wrk_html_th width="100"><cf_get_lang dictionary_id="43647.Üst Sektör"></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='58795.Müşteri Temsilcisi'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='40704.Etkileşim'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='40703.Etkileşim Tarihi'></cf_wrk_html_th>
			<cfif isdefined("attributes.is_answer")>
				<cf_wrk_html_th><cf_get_lang dictionary_id="39750.Etkileşim Cevabı"></cf_wrk_html_th>
			</cfif>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57486.Kategori'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57482.Aşama'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='29511.Yönetici'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57499.Telefon'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57428.E-Posta'></cf_wrk_html_th>
			<cf_wrk_html_th><cf_get_lang dictionary_id='57899.Kaydeden'></cf_wrk_html_th>
		</cf_wrk_html_tr>
		</cf_wrk_html_thead>
		<cf_wrk_html_tbody>
		<cfif isdefined("attributes.is_form_submitted") and get_customers.recordcount>
			<cfoutput query="get_customers" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cf_wrk_html_tr valign="top">
					<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
					<cf_wrk_html_td width="40"><cfif attributes.is_excel eq 1>#cus_help_id#<cfelse><a href="#request.self#?fuseaction=call.upd_helpdesk&cus_help_id=#cus_help_id#" class="tableyazi">#cus_help_id#</a></cfif></cf_wrk_html_td>
					<cf_wrk_html_td><cfif len(customer_value_id)>#get_custom_value.CUSTOMER_VALUE[listfind(customer_value_id_list,customer_value_id,',')]#</cfif></cf_wrk_html_td>
					<cf_wrk_html_td><cfif status eq 1><cf_get_lang dictionary_id="58061.Cari"><cfelseif ispotantial eq 1><cf_get_lang dictionary_id="57577.Potansiyel"></cfif></cf_wrk_html_td>
					<cf_wrk_html_td>#nickname#</cf_wrk_html_td>				
						<cfquery name="get_sector" datasource="#DSN#">
							SELECT 
								CSR.SECTOR_ID,
								CSR.COMPANY_ID,
								SSC.SECTOR_CAT,
								SCU.SECTOR_CAT AS SECTOR_UPPER
							FROM
								COMPANY_SECTOR_RELATION CSR
								LEFT JOIN SETUP_SECTOR_CATS SSC ON CSR.SECTOR_ID=SSC.SECTOR_CAT_ID
								LEFT JOIN SETUP_SECTOR_CAT_UPPER SCU ON SSC.SECTOR_UPPER_ID = SCU.SECTOR_UPPER_ID
							WHERE 
								CSR.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_id#">
							ORDER BY
								COMPANY_ID
						</cfquery>
						<cf_wrk_html_td>
							<cfloop query="get_sector">
								<cfif currentrow lt get_sector.recordcount>#SECTOR_CAT# - <cfelse>#SECTOR_CAT#</cfif>
							</cfloop>
						</cf_wrk_html_td>
						<cf_wrk_html_td>
							<cfloop query="get_sector">						
								#SECTOR_UPPER#				
							</cfloop>
						</cf_wrk_html_td>			
					<cf_wrk_html_td><cfif len(pos_code)>#get_pos_code.POS_CODE_TEXT[listfind(pos_code_list,pos_code,',')]#</cfif></cf_wrk_html_td>
					<cf_wrk_html_td>
						<cfset subject_ = replace(subject,'<p>','','all')>
						<cfset subject_ = replace(subject_,'</p>','','all')>
						#subject_#
					</cf_wrk_html_td>
					<cf_wrk_html_td>#DateFormat(update_date,dateformat_style)#</cf_wrk_html_td>
					<cfif isdefined("attributes.is_answer")>
						<cf_wrk_html_td>#solution_detail#</cf_wrk_html_td>
					</cfif>
					<cf_wrk_html_td><cfif len(interaction_cat)>#get_interactioncat.INTERACTIONCAT[listfind(interaction_cat_id_list,interaction_cat,',')]#</cfif></cf_wrk_html_td>
					<cf_wrk_html_td><cfif len(process_stage)>#process_type.STAGE[listfind(stage_list,process_stage,',')]#</cfif></cf_wrk_html_td>
					<cf_wrk_html_td><cfif len(manager_partner_id)>#get_manager.MANAGER_PARTNER[listfind(manager_part_id_list,manager_partner_id,',')]#</cfif></cf_wrk_html_td>
					<cf_wrk_html_td>#tel_code# #tel#</cf_wrk_html_td>
					<cf_wrk_html_td>#email#</cf_wrk_html_td>
					<cf_wrk_html_td>
						<cfif len(record_emp)>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#get_emp_info(record_emp,0,0)#
							<cfelse>
								#get_emp_info(record_emp,0,1)#
							</cfif>
						<cfelseif len(record_par)>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#get_par_info(record_par,0,0,0)#
							<cfelse>
								#get_par_info(record_par,0,0,1)#
							</cfif>                  	
						<cfelseif len(record_cons)>
							<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
								#get_cons_info(record_cons,0,0)#
							<cfelse>
								#get_cons_info(record_cons,0,1)#
							</cfif> 
						</cfif>
					</cf_wrk_html_td>
				</cf_wrk_html_tr>
			</cfoutput>
		<cfelse>
			<cfset colspan_ = 15>
			<cfif isdefined("attributes.is_answer")>
				<cfset colspan_ = colspan_ + 1>
			</cfif>
			<cf_wrk_html_tr>
				<cf_wrk_html_td colspan="#colspan_+1#"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></cf_wrk_html_td>
			</cf_wrk_html_tr>
		</cfif>
		</cf_wrk_html_tbody>
	</cf_wrk_html_table>
</cf_report_list>
<cfif isDefined('attributes.is_form_submitted') and attributes.totalrecords gt attributes.maxrows>
	<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="report.interaction_content_report#url_str#">
		
</cfif>
<script>
	function control(){
		if( customer_service_report.interaction_cat.value.length == 0 &&(customer_service_report.company_id.value.length == 0 || customer_service_report.consumer_id.value.length == 0) && (customer_service_report.record_emp.value.length == 0) )
			{
				alert("<cf_get_lang dictionary_id='57486.Kategori'>,<cf_get_lang dictionary_id='57658.Üye'>,<cf_get_lang dictionary_id='57899.Kaydeden'> <cf_get_lang dictionary_id='64959.Alanlarından birini Filtre Ediniz'>!");
					
				return false;
			}		
			else
				return true;
	}
</script>

