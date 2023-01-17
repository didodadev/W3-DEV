<cf_xml_page_edit>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.work_cat" default="">
<cfparam name="attributes.workgroup_id" default="">
<cfparam name="attributes.related_service_id" default="">
<cfparam name="attributes.related_contract_id" default="">
<cfparam name="attributes.related_assetp_id" default="">
<cfparam name="attributes.related_product_sample_id" default="">
<cfparam name="attributes.related_opp_id" default="">
<cfparam name="attributes.related_g_service_id" default="">
<cfparam name="attributes.related_subscription_id" default="">
<cfparam name="attributes.related_project_id" default="">
<cfparam name="attributes.related_work_id" default="">
<cfparam name="attributes.related_reply_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.multiple_selection" default="">
<cfparam name="attributes.work_status" default="1">
<cfif len(attributes.start_date) and isdate(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif len(attributes.finish_date) and isdate(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cfquery name="GET_WORKGROUPS" datasource="#DSN#">
	SELECT WORKGROUP_ID,WORKGROUP_NAME FROM WORK_GROUP WHERE STATUS = 1 AND HIERARCHY IS NOT NULL ORDER BY WORKGROUP_NAME
</cfquery>
<cfquery name="GET_WORK_CAT" datasource="#DSN#">
	SELECT WORK_CAT_ID,WORK_CAT FROM PRO_WORK_CAT ORDER BY WORK_CAT
</cfquery>

<cfif attributes.multiple_selection eq 1 and isdefined("is_update") and len(is_update) and isdefined('attributes.related_contract_id') and Len(attributes.related_contract_id)>
	<cfquery name="getRelatedWorks" datasource="#dsn#">
		SELECT 
			PW.WORK_NO
		FROM 
			PRO_WORKS PW,
			#dsn3_alias#.RELATED_CONTRACT RC
		WHERE 
			(
				(RC.CONTRACT_TYPE = 1 AND RC.CONTRACT_ID = PW.PURCHASE_CONTRACT_ID AND PW.PURCHASE_CONTRACT_ID <> #attributes.related_contract_id#) OR
				(RC.CONTRACT_TYPE = 2 AND RC.CONTRACT_ID = PW.SALE_CONTRACT_ID AND PW.SALE_CONTRACT_ID <> #attributes.related_contract_id#)
			) AND
			PW.WORK_ID IN (#attributes.work_ids#) AND 
			RC.CONTRACT_TYPE = (SELECT R_CON.CONTRACT_TYPE FROM #dsn3_alias#.RELATED_CONTRACT R_CON WHERE R_CON.CONTRACT_ID = #attributes.related_contract_id#)
	</cfquery>
	<cfset work_no_list = valuelist(getRelatedWorks.WORK_NO,',')>
	<cfif getRelatedWorks.recordcount>
		<script type="text/javascript">
			alert('<cfoutput>#work_no_list#</cfoutput> nolu işler aynı tip sözleşmeler ile ilişkilidir. Bu sözleşme ile ilişkilendiremezsiniz!');
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="getContractType" datasource="#dsn3#">
		SELECT CONTRACT_TYPE FROM RELATED_CONTRACT WHERE CONTRACT_ID = #attributes.related_contract_id#
	</cfquery>
	<cfloop list="#attributes.work_ids#" index="w_id">
		<cfquery name="upd_work" datasource="#dsn#">
			UPDATE 
				PRO_WORKS 
			SET 
				<cfif getContractType.contract_type eq 1>
					PURCHASE_CONTRACT_ID = #attributes.related_contract_id# 
				<cfelse>
					SALE_CONTRACT_ID = #attributes.related_contract_id# 
				</cfif>
			WHERE 
				WORK_ID = #w_id#
		</cfquery>
	</cfloop>
	<script type="text/javascript">
		wrk_opener_reload();
		//window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_service_id') and len(attributes.related_service_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			SERVICE_ID = #attributes.related_service_id#,
			OUR_COMPANY_ID = #session.ep.company_id#
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_assetp_id') and len(attributes.related_assetp_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			ASSETP_ID = #attributes.related_assetp_id# 
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_product_sample_id') and len(attributes.related_product_sample_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			PRODUCT_SAMPLE_ID = #attributes.related_product_sample_id# 
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_g_service_id') and len(attributes.related_g_service_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			G_SERVICE_ID = #attributes.related_g_service_id# 
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_opp_id') and len(attributes.related_opp_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			OPPORTUNITY_ID = #attributes.related_opp_id# 
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_subscription_id') and len(attributes.related_subscription_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			SUBSCRIPTION_ID = #attributes.related_subscription_id# 
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_project_id') and len(attributes.related_project_id)>
	<cfquery name="upd_work" datasource="#dsn#">
		UPDATE 
			PRO_WORKS 
		SET 
			PROJECT_ID = #attributes.related_project_id# 
		WHERE 
			WORK_ID = #attributes.work_id#
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("is_update") and len(is_update) and isdefined('attributes.related_reply_id') and len(attributes.related_reply_id)>
	<cfquery name="UPD_WORK" datasource="#DSN#">
		UPDATE 
			PRO_WORKS 
		SET 
			FORUM_REPLY_ID = #attributes.related_reply_id# 
		WHERE 
			WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_id#">
	</cfquery>
	<script type="text/javascript">
		window.opener.loader_page(1);
		window.close();
	</script>
</cfif>
<cfif isdefined("attributes.form_submitted") or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfquery name="get_works" datasource="#dsn#">
		SELECT
			PRO_WORKS.WORK_ID,
			PRO_WORKS.WORK_NO,
			PRO_WORKS.SERVICE_ID,
			PRO_WORKS.WORK_HEAD,
			PRO_WORKS.ESTIMATED_TIME,
			PRO_WORKS.PROJECT_ID,
			PRO_WORKS.CONSUMER_ID,
			PRO_WORKS.COMPANY_ID,
			PRO_WORKS.COMPANY_PARTNER_ID,
			PRO_WORKS.TARGET_START,
			PRO_WORKS.TARGET_FINISH,
			PRO_WORKS.WORK_CURRENCY_ID,
			PRO_WORKS.WORK_PRIORITY_ID,
			PRO_WORKS.PROJECT_EMP_ID,
			<!--- PRO_WORKS.CC_EMP_ID, --->
			PRO_WORKS.RECORD_AUTHOR,
			PRO_WORKS.OUTSRC_PARTNER_ID,
			PRO_WORKS.TO_COMPLETE,
			PTR.PROCESS_ROW_ID,
			PTR.STAGE,
			PP.PROJECT_HEAD
		FROM 
			PRO_WORKS
			LEFT JOIN PRO_PROJECTS PP ON PP.PROJECT_ID = PRO_WORKS.PROJECT_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PRO_WORKS.WORK_CURRENCY_ID = PTR.PROCESS_ROW_ID
		WHERE 
			<!---PRO_WORKS.OUR_COMPANY_ID = #session.ep.company_id# AND --->
			1 = 1
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND 
			(
				PRO_WORKS.WORK_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				PRO_WORKS.WORK_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				PRO_WORKS.WORK_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				PRO_WORKS.PROJECT_EMP_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
			</cfif>
			<cfif attributes.work_status eq -1>
				AND PRO_WORKS.WORK_STATUS = 0
			<cfelseif attributes.work_status eq 1>
				AND PRO_WORKS.WORK_STATUS = 1
			</cfif>
			<cfif isdefined("attributes.project_id") and len (attributes.project_id) and attributes.project_id neq -1 and isdefined("attributes.project_head") and len (attributes.project_head)>
				AND PRO_WORKS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
			<cfelseif isdefined("attributes.project_id") and len (attributes.project_id) and attributes.project_id eq -1 and isdefined("attributes.project_head") and len (attributes.project_head)>
				AND PRO_WORKS.PROJECT_ID IS NULL
			<cfelseif xml_different_project_works neq 1 and len(attributes.related_work_id)>
				AND ISNULL(PRO_WORKS.PROJECT_ID,0) = 0
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date) and isdefined("attributes.finish_date") and len(attributes.finish_date)>
				AND PRO_WORKS.TARGET_FINISH <= #attributes.finish_date# 
				AND PRO_WORKS.TARGET_START >= #attributes.start_date#
			<cfelseif isdefined ("attributes.finish_date") and len(attributes.finish_date)>
				AND PRO_WORKS.TARGET_FINISH <= #attributes.finish_date#
			<cfelseif isdefined("attributes.start_date") and len(attributes.start_date)>
				AND PRO_WORKS.TARGET_START >= #attributes.start_date#            
			</cfif>
			<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
				AND PRO_WORKS.WORK_CURRENCY_ID = #attributes.process_stage#
			</cfif>
			<cfif len(attributes.workgroup_id)>
				AND PRO_WORKS.WORKGROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.workgroup_id#">
			</cfif>
			<cfif len(attributes.work_cat)>
				AND PRO_WORKS.WORK_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.work_cat# ">
			</cfif>
			<cfif len(attributes.employee_id) and len(attributes.employee)>
				AND PRO_WORKS.PROJECT_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
			</cfif>
			<cfif isdefined('attributes.related_service_id') and len(attributes.related_service_id)>
				AND PRO_WORKS.SERVICE_ID IS NULL
			</cfif>
		ORDER BY		
			TARGET_START DESC
	</cfquery>
<cfelse>
	<cfset get_works.recordcount = 0>
</cfif>
<cfquery name="get_process_types" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%project.works%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>

<cfscript>
	adres = "";
	if (isdefined('attributes.form_submitted') and len(attributes.form_submitted)) adres = '#adres#&form_submitted=#attributes.form_submitted#';
	if (isdefined('attributes.start_date') and len(attributes.start_date)) adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#';
	if (isdefined('attributes.finish_date') and len(attributes.finish_date)) adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#';
	if (isdefined('attributes.work_id') and len(attributes.work_id)) adres = '#adres#&work_id=#attributes.work_id#';
	if (isdefined('attributes.process_stage') and len(attributes.process_stage)) adres = '#adres#&process_stage=#attributes.process_stage#';
	if (isdefined('attributes.workgroup_id') and len(attributes.workgroup_id)) adres = '#adres#&workgroup_id=#attributes.workgroup_id#';
	if (isdefined('attributes.work_cat') and len(attributes.work_cat)) adres = '#adres#&work_cat=#attributes.work_cat#';
	if (isdefined('attributes.employee_id') and len(attributes.employee_id)) adres = '#adres#&employee_id=#attributes.employee_id#';
	if (isdefined('attributes.employee') and len(attributes.employee)) adres = '#adres#&employee=#attributes.employee#';
	if (isdefined('attributes.work_status') and len(attributes.work_status)) adres = '#adres#&work_status=#attributes.work_status#';
	if (isdefined('attributes.related_service_id') and len(attributes.related_service_id)) adres = '#adres#&related_service_id=#attributes.related_service_id#';
	if (isdefined('attributes.related_contract_id') and len(attributes.related_contract_id)) adres = '#adres#&related_contract_id=#attributes.related_contract_id#';
	if (isdefined('attributes.related_work_id')) adres = '#adres#&related_work_id=#attributes.related_work_id#';
	if (isdefined('attributes.related_reply_id') and len(attributes.related_reply_id)) adres = '#adres#&related_reply_id=#attributes.related_reply_id#';
	if (isdefined('attributes.related_assetp_id') and len(attributes.related_assetp_id)) adres = '#adres#&related_assetp_id=#attributes.related_assetp_id#';
	if (isdefined('attributes.related_product_sample_id') and len(attributes.related_product_sample_id)) adres = '#adres#&related_product_sample_id=#attributes.related_product_sample_id#';
	if (isdefined('attributes.related_g_service_id') and len(attributes.related_g_service_id)) adres = '#adres#&related_g_service_id=#attributes.related_g_service_id#';
	if (isdefined('attributes.related_opp_id') and len(attributes.related_opp_id)) adres = '#adres#&related_opp_id=#attributes.related_opp_id#';
	if (isdefined('attributes.related_subscription_id') and len(attributes.related_subscription_id)) adres = '#adres#&related_subscription_id=#attributes.related_subscription_id#';
	if (isdefined('attributes.related_project_id') and len(attributes.related_project_id)) adres = '#adres#&related_project_id=#attributes.related_project_id#';
	if (isdefined('attributes.relstartdate') and len(attributes.relstartdate)) adres = '#adres#&relstartdate=#attributes.relstartdate#';
	if (isdefined('attributes.relfinishdate') and len(attributes.relfinishdate)) adres = '#adres#&relfinishdate=#attributes.relfinishdate#';
	if (isdefined('attributes.rel_work_id') and len(attributes.rel_work_id)) adres = '#adres#&rel_work_id=#attributes.rel_work_id#';
	if (isdefined('attributes.rel_work') and len(attributes.rel_work)) adres = '#adres#&rel_work=#attributes.rel_work#';
	if (isdefined('attributes.relat_pro') and len(attributes.relat_pro)) adres = '#adres#&relat_pro=#attributes.relat_pro#';
	if (isdefined('attributes.multiple_selection') and len(attributes.multiple_selection)) adres = '#adres#&multiple_selection=#attributes.multiple_selection#';
	if (isdefined('attributes.project_id') and len(attributes.project_id)) adres = '#adres#&project_id=#attributes.project_id#';	
	if (isdefined('attributes.project_head') and len(attributes.project_head)) adres = '#adres#&project_head=#attributes.project_head#';
	if (isdefined('attributes.call_function')) adres = '#adres#&call_function=#attributes.call_function#';
</cfscript>


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_works.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.status" default="1">

<cf_box title="#getLang('','İşler',58020)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform id="works" name="works" method="post" action="#request.self#?fuseaction=objects.popup_add_related_work">
		<cf_box_search>
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cfif (isdefined('attributes.work_id') and len(attributes.work_id))><cfinput type="hidden" name="work_id" value="#attributes.work_id#"></cfif>
			<cfif (isdefined('attributes.related_service_id') and len(attributes.related_service_id))><cfinput type="hidden" name="related_service_id" value="#attributes.related_service_id#"></cfif>
			<cfif (isdefined('attributes.related_contract_id') and len(attributes.related_contract_id))><cfinput type="hidden" name="related_contract_id" value="#attributes.related_contract_id#"></cfif>
			<cfif (isdefined('attributes.related_work_id'))><cfinput type="hidden" name="related_work_id" value="#attributes.related_work_id#"></cfif>
			<cfif (isdefined('attributes.related_reply_id') and len(attributes.related_reply_id))><cfinput type="hidden" name="related_reply_id" value="#attributes.related_reply_id#"></cfif>
			<cfif (isdefined('attributes.related_assetp_id') and len(attributes.related_assetp_id))><cfinput type="hidden" name="related_assetp_id" value="#attributes.related_assetp_id#"></cfif>
			<cfif (isdefined('attributes.related_product_sample_id') and len(attributes.related_product_sample_id))><cfinput type="hidden" name="related_product_sample_id" value="#attributes.related_product_sample_id#"></cfif>
			<cfif (isdefined('attributes.related_g_service_id') and len(attributes.related_g_service_id))><cfinput type="hidden" name="related_g_service_id" value="#attributes.related_g_service_id#"></cfif>
			<cfif (isdefined('attributes.related_opp_id') and len(attributes.related_opp_id))><cfinput type="hidden" name="related_opp_id" value="#attributes.related_opp_id#"></cfif>
			<cfif (isdefined('attributes.related_subscription_id') and len(attributes.related_subscription_id))><cfinput type="hidden" name="related_subscription_id" value="#attributes.related_subscription_id#"></cfif>
			<cfif (isdefined('attributes.related_project_id') and len(attributes.related_project_id))><cfinput type="hidden" name="related_project_id" value="#attributes.related_project_id#"></cfif>
			<cfif (isdefined('attributes.relstartdate') and len(attributes.relstartdate))><cfinput type="hidden" name="relstartdate" value="#attributes.relstartdate#"></cfif>
			<cfif (isdefined('attributes.relfinishdate') and len(attributes.relfinishdate))><cfinput type="hidden" name="relfinishdate" value="#attributes.relfinishdate#"></cfif>
			<cfif (isdefined('attributes.rel_work_id') and len(attributes.rel_work_id))><cfinput type="hidden" name="rel_work_id" value="#attributes.rel_work_id#"></cfif>
			<cfif (isdefined('attributes.rel_work') and len(attributes.rel_work))><cfinput type="hidden" name="rel_work" value="#attributes.rel_work#"></cfif>
			<cfif (isdefined('attributes.relat_pro') and len(attributes.relat_pro))><cfinput type="hidden" name="relat_pro" value="#attributes.relat_pro#"></cfif>
			<cfif (isdefined('attributes.multiple_selection') and len(attributes.multiple_selection))><cfinput type="hidden" name="multiple_selection" value="#attributes.multiple_selection#"></cfif>
			<cfif (isdefined('attributes.call_function'))><cfinput type="hidden" name="call_function" value="#attributes.call_function#"></cfif>
			<div class="form-group">
				<cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group">
				<select name="work_cat" id="work_cat">
					<option value=""><cf_get_lang dictionary_id='57486.kategori'></option>
					<cfoutput query="get_work_cat">
						<option value="#get_work_cat.work_cat_id#" <cfif attributes.work_cat eq get_work_cat.work_cat_id>selected</cfif>>#get_work_cat.work_cat#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="process_stage" id="process_stage">
					<option value=""><cf_get_lang dictionary_id='57482.Asama'></option>
					<cfoutput query="get_process_types">
						<option value="#process_row_id#" <cfif attributes.process_stage eq process_row_id>selected</cfif>>#stage#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="workgroup_id" id="workgroup_id">				  
					<option value=""><cf_get_lang dictionary_id='58140.İş Grubu'></option>
					<cfoutput query="get_workgroups">
						<option value="#get_workgroups.workgroup_id#"<cfif attributes.workgroup_id eq workgroup_id>selected</cfif>>#get_workgroups.workgroup_name#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function='kontrol()'>
			</div>
		</cf_box_search>
		<cf_box_search_detail search_function='kontrol()'>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-employee_id">
					<label><cf_get_lang dictionary_id='57569.Görevli'></label>
					<input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
					<div class="input-group">
						<input type="text" name="employee" id="employee" value="<cfif len(attributes.employee_id) and len(attributes.employee)><cfoutput>#attributes.employee#</cfoutput></cfif>" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','125');">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=works.employee_id&field_name=works.employee&select_list=1','list');"></span>
					</div>
				</div>
				<div class="form-group" id="item-project_id">
					<label><cf_get_lang dictionary_id='57416.Proje'></label>
					<input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_id) and Len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
					<div class="input-group">
						<input type="text" <cfif xml_different_project_works eq 0>readonly</cfif> name="project_head" id="project_head" value="<cfif len(attributes.project_id) and Len(attributes.project_head)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>" <cfif xml_different_project_works neq 1 and len(attributes.related_work_id)>readonly</cfif> onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
						<cfif xml_different_project_works eq 1><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head');"></span></cfif>
					</div>
				</div>
				<div class="form-group" id="item-work_status">
					<label><cf_get_lang dictionary_id='57756.Durum'></label>
					<select name="work_status" id="work_status">
						<option value="1" <cfif attributes.work_status eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="-1" <cfif attributes.work_status eq -1>selected="selected"</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="0" <cfif attributes.work_status eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-start_date">
					<label><cf_get_lang dictionary_id='57655.Başlama Tarihi'></label>
					<div class="input-group">
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Tarih Değerini Kontrol Ediniz',57782)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group" id="item-finish_date">
					<label><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
					<div class="input-group">
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#getLang('','Tarih Değerini Kontrol Ediniz',57782)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th width="35"><cf_get_lang dictionary_id ='57487.No'></th>
				<th width="35"><cf_get_lang dictionary_id ='58445.İş'> <cf_get_lang dictionary_id='58527.ID'></th>
				<th width="35"><cf_get_lang dictionary_id ='58445.İş'><cf_get_lang dictionary_id ='57487.No'></th>
				<th><cf_get_lang dictionary_id ='58445.İş'></th>
				<th><cf_get_lang dictionary_id='57482.Aşama'></th>
				<th><cf_get_lang dictionary_id='57569.Görevli'></th>
				<th><cf_get_lang dictionary_id='57416.Proje'></th>
				<th><cf_get_lang dictionary_id ='58467.Başlama'></th>
				<th><cf_get_lang dictionary_id ='57502.Bitiş'></th>
				<cfif attributes.multiple_selection eq 1>
					<th width="20" class="text-center">
						<cfif attributes.totalrecords neq 0><input type="Checkbox" name="all" id="all" value="1" onclick="javascript: hepsi();"></cfif>
					</th>
				</cfif>
			</tr>
		</thead>
		
		<cfif get_works.recordcount>
		<tbody>
			<form name="form_name" method="post" action="">
				<input type="hidden" name="is_update" id="is_update" value="1" />
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<cfoutput>
					<input type="hidden" name="multiple_selection" id="multiple_selection" value="#attributes.multiple_selection#" />
					<input type="hidden" name="relstartdate" id="relstartdate" value="<cfif isDefined("attributes.relstartdate")>#attributes.relstartdate#</cfif>">
					<input type="hidden" name="relfinishdate" id="relfinishdate" value="<cfif isDefined("attributes.relfinishdate")>#attributes.relfinishdate#</cfif>">
					<input type="hidden" name="rel_work_id" id="rel_work_id" value="<cfif isDefined("attributes.rel_work_id")>#attributes.rel_work_id#</cfif>">
					<input type="hidden" name="rel_work" id="rel_work" value="<cfif isDefined("attributes.rel_work")>#attributes.rel_work#</cfif>">
					<input type="hidden" name="relat_pro" id="relat_pro" value="<cfif isDefined("attributes.relat_pro")>#attributes.relat_pro#</cfif>">
					<input type="hidden" name="related_work_id" id="related_work_id" value="<cfif isDefined("attributes.related_work_id")>#attributes.related_work_id#</cfif>">
					<input type="hidden" name="related_service_id" id="related_service_id" value="<cfif isDefined("attributes.related_service_id")>#attributes.related_service_id#</cfif>">
					<input type="hidden" name="related_contract_id" id="related_contract_id" value="<cfif isDefined("attributes.related_contract_id")>#attributes.related_contract_id#</cfif>">
				</cfoutput>
				<cfoutput query="get_works" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<div id="work_#work_id#">
					<tr>
						<td width="30">#currentrow#</td>
						<td width="30">#work_id#</td>
						<td width="50">#work_no#</td>
						<cfset work_head_ = Replace(work_head,"'","")>
						<td><cfif attributes.multiple_selection eq 1>
								#work_head#
							<cfelse>
								<cfset targetStart = dateformat(target_start,dateformat_style)>
								<cfset targetFinish = dateformat(target_finish,dateformat_style)>
								<a href="javascript://" onclick="add_user('#work_id#','#work_head_#','#targetStart#','#targetFinish#');" class="tableyazi">#work_head#</a>
							</cfif>
						</td>
						<td>#stage#</td>
						<td>#get_emp_info(project_emp_id,0,1)#</td>
						<td><cfif len(get_works.project_id)> 
								<a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#PROJECT_HEAD#</a></td>
							<cfelse>
								<cf_get_lang dictionary_id='58459.projesiz'>
							</cfif>
						</td>
						<td>#dateformat(target_start,dateformat_style)#</td>
						<td>#dateformat(target_finish,dateformat_style)#</td>
						<cfif attributes.multiple_selection eq 1>
							<td align="center"><input type="checkbox" value="#work_id#" name="work_ids" id="work_ids"></td>
						</cfif>
					</tr>
				</div>
				</cfoutput>
			</tbody>
			<cfif attributes.multiple_selection eq 1>
			<tfoot>
				<tr>
					<td colspan="10"  style="text-align:right;"><input type="submit" value="<cf_get_lang dictionary_id ='57461.Kaydet'>" onclick="return add_checked();"></td>
				</tr>
			</tfoot>
			</cfif>
			</form>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="10"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
				</tr>
			</tbody>
		</cfif>
	</cf_grid_list>
	<cfif attributes.totalrecords gt attributes.maxrows>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="objects.popup_add_related_work#adres#">
	</cfif>
</cf_box>

<script type="text/javascript">
	$(document).ready(function(){
		$( "#keyword" ).focus();
	});
function hepsi()
{
	if (document.getElementById('all').checked)
	{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.work_ids.length;i++) form_name.work_ids[i].checked = true;
		<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
			form_name.work_ids.checked = true;
		</cfif>
			}
		else
			{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.work_ids.length;i++) form_name.work_ids[i].checked = false;
		<cfelseif attributes.totalrecords eq 1>
			form_name.work_ids.checked = false;
		</cfif>
	}
}

function add_checked()
{
	var counter = 0;
	<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
		for (var i=0 ; i < form_name.work_ids.length ; i++) 
			if (form_name.work_ids[i].checked == true) 
			{
				counter = counter + 1;
			}
			if (counter == 0)
			{
				alert("<cf_get_lang dictionary_id='38692.İş Seçmelisiniz'> !");
				return false;
			}
	<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
		if (form_name.work_ids.checked == true) 
		{
			counter = counter + 1;
		}
		if (counter == 0)
		{
			alert("<cf_get_lang dictionary_id='38692.İş Seçmelisiniz'> !");
			return false;
		}
	</cfif>
}

function add_user(i,h,sdate,fdate)
{
	<cfif len(attributes.related_service_id)>
		<cfset related_ = "&related_service_id=#attributes.related_service_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif len(attributes.related_contract_id)>
		<cfset related_ = "&related_contract_id=#attributes.related_contract_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif isdefined("attributes.related_assetp_id") and len(attributes.related_assetp_id)>
		<cfset related_ = "&related_assetp_id=#attributes.related_assetp_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif isdefined("attributes.related_product_sample_id") and len(attributes.related_product_sample_id)>
		<cfset related_ = "&related_product_sample_id=#attributes.related_product_sample_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif isdefined("attributes.related_g_service_id") and len(attributes.related_g_service_id)>
		<cfset related_ = "&related_g_service_id=#attributes.related_g_service_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif isdefined("attributes.related_opp_id") and len(attributes.related_opp_id)>
		<cfset related_ = "&related_opp_id=#attributes.related_opp_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i;
	<cfelseif isdefined("attributes.related_subscription_id") and len(attributes.related_subscription_id)>
		<cfset related_ = "&related_subscription_id=#attributes.related_subscription_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i;
	<cfelseif isdefined("attributes.related_project_id") and len(attributes.related_project_id)>
		<cfset related_ = "&related_project_id=#attributes.related_project_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif isdefined("attributes.related_reply_id") and len(attributes.related_reply_id)>
		<cfset related_ = "&related_reply_id=#attributes.related_reply_id#">
		window.location = '<cfoutput>#request.self#?fuseaction=objects.popup_add_related_work#related_#</cfoutput>&is_update=1&work_id='+ i; 
	<cfelseif isDefined("attributes.related_work_id") and len(attributes.related_work_id)>
		<cfset related_ = "&related_work_id=#attributes.related_work_id#">
		<cfif isdefined("attributes.rel_work_id")>
			window.opener.document.<cfoutput>#rel_work_id#</cfoutput>.value = i;
		</cfif>
		<cfif isdefined("attributes.relstartdate")>
			window.opener.document.<cfoutput>#relstartdate#</cfoutput>.value = sdate;
		</cfif>
		<cfif isdefined("attributes.relfinishdate")>
			window.opener.document.<cfoutput>#relfinishdate#</cfoutput>.value = fdate;
		</cfif>
		<cfif isdefined("attributes.rel_work")>
			window.opener.document.<cfoutput>#rel_work#</cfoutput>.value = h;
		</cfif>
		self.close();
	</cfif>
}

function kontrol()
{
	if (works.start_date.value.length != 0 && works.finish_date.value.length != 0)
	return date_check(works.start_date,works.finish_date,"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Önce Olmalıdır'>");
	return true;
}
</script>