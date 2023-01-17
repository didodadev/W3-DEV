<cfparam name="attributes.module_id_control" default="4">
<cfinclude template="report_authority_control.cfm">
<cf_xml_page_edit fuseact="report.etkilesim_rapor">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.about_company" default="">
<cfparam name="attributes.applicant_name" default="">
<cfparam name="attributes.cus_help_id" default="">
<cfparam name="attributes.interactioncat_id" default="">
<cfparam name="attributes.interaction_cat" default="">
<cfparam name="attributes.activity_type" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.app_cat" default="">
<cfparam name="attributes.special_definition" default="">
<cfparam name="attributes.is_excel" default="">
<cfparam name="attributes.group_type" default="">
<cfquery name="get_customer_value" datasource="#dsn#">
	SELECT CUSTOMER_VALUE_ID,CUSTOMER_VALUE FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="sz" datasource="#dsn#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="get_interaction_cat" datasource="#dsn#"> 
    SELECT INTERACTIONCAT_ID,INTERACTIONCAT FROM SETUP_INTERACTION_CAT <cfif len(attributes.interaction_cat)> WHERE INTERACTIONCAT_ID IN (#attributes.interaction_cat#) </cfif> ORDER BY INTERACTIONCAT
</cfquery>
<cfquery name="get_interct_cat" datasource="#dsn#">
	SELECT INTERACTIONCAT_ID,INTERACTIONCAT FROM SETUP_INTERACTION_CAT ORDER BY INTERACTIONCAT 
</cfquery>
<cfquery name="get_process_stage" datasource="#dsn#">
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
<cfquery name="get_prcess_stge" datasource="#dsn#">
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
		<cfif len(attributes.process_stage)>
			PTR.PROCESS_ROW_ID IN (#attributes.process_stage#) AND
		</cfif>
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%call.helpdesk%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="get_commethod" datasource="#dsn#">
	SELECT COMMETHOD_ID,COMMETHOD FROM SETUP_COMMETHOD ORDER BY COMMETHOD
</cfquery>
<cfquery name="get_commthd" datasource="#dsn#">
	SELECT COMMETHOD_ID,COMMETHOD FROM SETUP_COMMETHOD <cfif len(attributes.app_cat)>WHERE COMMETHOD_ID IN (#attributes.app_cat#) </cfif> ORDER BY COMMETHOD
</cfquery>
<cfquery name="get_special_definition" datasource="#dsn#"><!--- 5: Etkilesim Kategorisindeki Ozel Tanimlar --->
	SELECT 
    	SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION 
    WHERE 
        SPECIAL_DEFINITION_TYPE = 5
    ORDER BY SPECIAL_DEFINITION
</cfquery>
<cfif attributes.group_type eq 6>
    <cfquery name="get_special_def" datasource="#dsn#">
        SELECT 
            SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION 
        WHERE 
            SPECIAL_DEFINITION_TYPE = 5
            <cfif Len(attributes.special_definition)>
                AND SPECIAL_DEFINITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#" list="yes">)
            </cfif> 
        ORDER BY SPECIAL_DEFINITION
    </cfquery>
</cfif>
<cfif attributes.group_type eq 2>
	<cfquery name="getSubsList" datasource="#dsn3#">
    	SELECT 
        	SUBSCRIPTION_ID,SUBSCRIPTION_HEAD FROM SUBSCRIPTION_CONTRACT
        WHERE 
            1 = 1
            <cfif isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
            	AND SUBSCRIPTION_NO = '#attributes.subscription_no#'
           	</cfif>
            <cfif len(attributes.about_company) and len(attributes.company_id)>
            	AND COMPANY_ID = #attributes.company_id#
           	</cfif>
	</cfquery>
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = date_add('d',-7,createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#'))>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
</cfif>
<cfset toplam_sayi=0>
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="search1" datasource="#dsn#">
		SELECT
			<cfif attributes.group_type neq 3>
				CUS_HELP_ID,
                <cfif attributes.group_type eq 2>
                SUBSCRIPTION_ID,
                </cfif>
                <cfif attributes.group_type eq 6>
                SPECIAL_DEFINITION_ID,
                </cfif>
				PROCESS_STAGE,
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				APP_CAT,
				APPLICANT_NAME,
				IS_REPLY_MAIL,
                INTERACTION_CAT
			<cfelse>
				COUNT(CUS_HELP_ID) SAYI,
				'COMPANY' TYPE,
				COMPANY_ID MEMBER_ID
			</cfif>
		FROM
			CUSTOMER_HELP
		WHERE
			COMPANY_ID IS NOT NULL
			<cfif isdefined('attributes.konu') and len(attributes.konu)>AND SUBJECT LIKE '%#attributes.konu#%'</cfif>
			<cfif isdefined('attributes.app_cat') and listlen(attributes.app_cat)>AND APP_CAT IN (#attributes.app_cat#)</cfif>
			<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>AND SUBSCRIPTION_ID = #attributes.subscription_id#</cfif>
			<cfif len(attributes.applicant_name) and len(attributes.partner_id)>
				AND PARTNER_ID = #attributes.partner_id#
			</cfif>
			<cfif len(attributes.about_company) and len(attributes.company_id)>
				AND COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif len(attributes.about_company) and len(attributes.consumer_id)>
				AND CONSUMER_ID = #attributes.consumer_id#
			</cfif>
			<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
				AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY WHERE COMPANY.IMS_CODE_ID IN (#attributes.ims_code_id#) )
			</cfif>
			<cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>
				AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY WHERE COMPANY.SALES_COUNTY IN (#attributes.sales_county#) )
			</cfif>
			<cfif isdefined("attributes.resource") and len(attributes.resource)>
				AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY WHERE COMPANY.RESOURCE_ID IN (#attributes.resource#) )
			</cfif>
			<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
				AND COMPANY_ID IN ( SELECT COMPANY_ID FROM COMPANY WHERE COMPANY.COMPANY_VALUE_ID IN (#attributes.customer_value#) )
			</cfif>            
			<cfif isdefined('attributes.process_stage') and listlen(attributes.process_stage)>AND PROCESS_STAGE IN (#attributes.process_stage#)</cfif>
            <cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>AND INTERACTION_CAT IN (#attributes.interaction_cat#)</cfif>
			<cfif isdefined('attributes.start_date') and len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
			<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
			<cfif isdefined('attributes.record_emp_id') and len(attributes.record_emp_id) and isdefined('attributes.record_emp_name') and len(attributes.record_emp_name)>AND (RECORD_EMP=#attributes.record_emp_id# OR COMPANY_ID=#attributes.record_emp_id#)</cfif>
			<cfif isdefined('attributes.upd_emp_id') and len(attributes.upd_emp_id) and isdefined('attributes.upd_emp_name') and len(attributes.upd_emp_name)>AND UPDATE_EMP = #attributes.upd_emp_id#</cfif>
			<cfif Len(attributes.special_definition)>
				AND SPECIAL_DEFINITION_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.special_definition#" list="yes">)
			</cfif>
		<cfif attributes.group_type eq 3>
		GROUP BY
			COMPANY_ID
		</cfif>
	UNION ALL
		SELECT
			<cfif attributes.group_type neq 3>
				CUS_HELP_ID,
                <cfif attributes.group_type eq 2>
                SUBSCRIPTION_ID,
                </cfif>
                <cfif attributes.group_type eq 6>
                SPECIAL_DEFINITION_ID,
                </cfif>
				PROCESS_STAGE,
				PARTNER_ID,
				COMPANY_ID,
				CONSUMER_ID,
				APP_CAT,
				APPLICANT_NAME,
				IS_REPLY_MAIL,
                INTERACTION_CAT
			<cfelse>
				COUNT(CUS_HELP_ID) SAYI,
				'CONSUMER' TYPE,
				CONSUMER_ID MEMBER_ID
			</cfif>
		FROM
			CUSTOMER_HELP
		WHERE
			CONSUMER_ID IS NOT NULL
			<cfif isdefined('attributes.konu') and len(attributes.konu)>AND SUBJECT LIKE '%#attributes.konu#%'</cfif>
			<cfif isdefined('attributes.app_cat') and listlen(attributes.app_cat)>AND APP_CAT IN (#attributes.app_cat#)</cfif>
			<cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>AND SUBSCRIPTION_ID = #attributes.subscription_id#</cfif>
			<cfif len(attributes.applicant_name) and len(attributes.partner_id)>
				AND PARTNER_ID = #attributes.partner_id#
			</cfif>
			<cfif len(attributes.about_company) and len(attributes.company_id)>
				AND COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif len(attributes.about_company) and len(attributes.consumer_id)>
				AND CONSUMER_ID = #attributes.consumer_id#
			</cfif>
			<cfif isdefined("attributes.ims_code_id") and len(attributes.ims_code_id) and len(attributes.ims_code_name)>
				AND CONSUMER_ID IN ( SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER.IMS_CODE_ID IN(#attributes.ims_code_id#) )
			</cfif>
			<cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>
				AND CONSUMER_ID IN ( SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER.SALES_COUNTY IN(#attributes.sales_county#) )
			</cfif>
			<cfif isdefined("attributes.resource") and len(attributes.resource)>
				AND CONSUMER_ID IN ( SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER.RESOURCE_ID IN(#attributes.resource#) )
			</cfif>
			<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
				AND CONSUMER_ID IN ( SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER.CUSTOMER_VALUE_ID IN(#attributes.customer_value#) )
			</cfif>           
			<cfif isdefined('attributes.process_stage') and listlen(attributes.process_stage)>AND PROCESS_STAGE IN (#attributes.process_stage#)</cfif>
            <cfif isdefined('attributes.interaction_cat') and len(attributes.interaction_cat)>AND INTERACTION_CAT IN (#attributes.interaction_cat#)</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND RECORD_DATE >= #attributes.start_date#</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND RECORD_DATE < #date_add("d",1,attributes.finish_date)#</cfif>
			<cfif isdefined('attributes.record_emp_id') and len(attributes.record_emp_id) and isdefined('attributes.record_emp_name') and len(attributes.record_emp_name)>AND (RECORD_EMP=#attributes.record_emp_id# OR COMPANY_ID=#attributes.record_emp_id#)</cfif>
			<cfif isdefined('attributes.upd_emp_id') and len(attributes.upd_emp_id) and isdefined('attributes.upd_emp_name') and len(attributes.upd_emp_name)>AND UPDATE_EMP = #attributes.upd_emp_id#</cfif>
		<cfif attributes.group_type eq 3>
			GROUP BY
				CONSUMER_ID
			ORDER BY
				TYPE, SAYI DESC
		<cfelse>
			ORDER BY APPLICANT_NAME
		</cfif>
	</cfquery>
	<cfif search1.recordcount and attributes.group_type neq 3>
		<cfquery name="search" dbtype="query">
			SELECT DISTINCT APPLICANT_NAME FROM search1 ORDER BY APPLICANT_NAME
		</cfquery>
		
	<cfelseif attributes.group_type eq 3>
		<cfset search = search1>
	<cfelse>
		<cfset search.recordcount = 0>
	</cfif>
<cfelse>
	<cfset search.recordcount = 0>
</cfif>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default = "#search.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined('attributes.is_excel') and  attributes.is_excel eq 1>
	<cfset attributes.startrow=1>
    <cfif attributes.group_type neq 5 and attributes.group_type neq 4 and  attributes.group_type neq 2 and attributes.group_type neq 6>
	<cfset attributes.maxrows=search.recordcount>
    </cfif>
</cfif>
<!--- <table class="dph" width="98%">
	<tr>
		<td class="dpht"><a href="javascript:gizle_goster_ikili('gizle_','etkilesim_basket');">&raquo;<cf_get_lang dictionary_id='39436.Etkileşim Raporu'></a></td>
		<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' tag_module="etkilesim_basket" is_ajax="1">
	</tr>
</table> --->
<cf_box title="#getLang('','Etkileşim Raporu',39436)#">
	<cfform name="get_part" action="#request.self#?fuseaction=report.etkilesim_rapor" method="post">
		<input type="hidden" name="form_submitted" id="form_submitted" value="1">
		<cf_box_search>
				<cfoutput>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id ='57658.Üye'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" id="company_id" name="company_id" value="<cfif len(attributes.company_id)>#attributes.company_id#</cfif>">
									<input type="hidden" id="consumer_id" name="consumer_id" value="<cfif len(attributes.consumer_id)>#attributes.consumer_id#</cfif>">
									<input type="text" name="about_company" id="about_company" value="<cfif Len(attributes.about_company)>#attributes.about_company#</cfif>" onFocus="AutoComplete_Create('about_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'0\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID,PARTNER_ID,MEMBER_PARTNER_NAME','company_id,partner_id,applicant_name','get_part','3','225');"  autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=get_part.company_id&field_member_name=get_part.about_company&field_consumer=get_part.consumer_id&field_partner=get_part.partner_id&field_name=get_part.applicant_name&select_list=2,3')"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='58552.Müşteri Değeri'></label>
							<div class="col col-12 col-xs-12">
								<select name="customer_value" id="customer_value">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_customer_value">
										<option value="#customer_value_id#" <cfif isdefined("attributes.customer_value") and attributes.customer_value eq customer_value_id>selected</cfif>>#customer_value#</option>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
							<div class="col col-12 col-xs-12">
								<select name="process_stage" id="process_stage" multiple="multiple">
									<cfloop query="get_process_stage">
										<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and listfindnocase(attributes.process_stage,PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
									</cfloop>
								</select>	
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='40564.iletişim yöntemleri'></label>
							<div class="col col-12 col-xs-12">
								<select name="app_cat" id="app_cat" multiple="multiple">
									<cfloop query="get_commethod">
										<option value="#COMMETHOD_ID#" <cfif isdefined("attributes.app_cat") and listfindnocase(attributes.app_cat,commethod_id)>selected</cfif>>#COMMETHOD#</option>
									</cfloop>
								</select>	
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='59152.Gruplama Tipi'></label>
							<div class="col col-12 col-xs-12">
								<select name="group_type" id="group_type">
									<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
									<option value="1" <cfif attributes.group_type eq 1>selected</cfif>><cf_get_lang dictionary_id='39300.Müşteriye Göre'></option>
									<option value="2" <cfif attributes.group_type eq 2>selected</cfif>><cf_get_lang dictionary_id='59209.Abone Bazında Grupla'></option>
									<option value="3" <cfif attributes.group_type eq 3>selected</cfif>><cf_get_lang dictionary_id='39148.Müşteri Bazında Grupla'></option>
									<option value="4" <cfif attributes.group_type eq 4>selected</cfif>><cf_get_lang dictionary_id='39745.İletişim Yöntemi Bazında Gurupla'></option>
									<option value="5" <cfif attributes.group_type eq 5>selected</cfif>><cf_get_lang dictionary_id='39746.Kategori Bazında Grupla'></option>
									<cfif x_show_special_definition eq 1>
									<option value="6" <cfif attributes.group_type eq 6>selected</cfif>><cf_get_lang dictionary_id='39747.Özel Tanım Bazında Grupla'></option>
									</cfif>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id ='57578.Yetkili'></label>
							<div class="col col-12 col-xs-12">
								<input type="hidden" id="partner_id" name="partner_id" value="<cfif isdefined('attributes.partner_id')>#attributes.partner_id#</cfif>">
								<input type="text" id="applicant_name" name="applicant_name" value="<cfif isdefined("attributes.applicant_name")>#attributes.applicant_name#</cfif>">	
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></label>
							<div class="col col-12 col-xs-12">
								<select name="sales_county" id="sales_county">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="sz">
										<option value="#sz_id#" <cfif isdefined("attributes.sales_county") and attributes.sales_county eq sz_id>selected</cfif>>#sz_name#</option>
									</cfloop>
								</select>	
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='58832.abone'><cf_get_lang dictionary_id="57487.No"></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="member_name" id="member_name" value="">
									<input type="hidden" id="subscription_id" name="subscription_id" value="<cfif isdefined('attributes.subscription_id') and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>#attributes.subscription_id#</cfif>">
									<input type="text" id="subscription_no" name="subscription_no" value="<cfif isdefined('attributes.subscription_no') and len(attributes.subscription_no)>#attributes.subscription_no#</cfif>" onFocus="AutoComplete_Create('subscription_no','SUBSCRIPTION_HEAD,SUBSCRIPTION_NO','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','get_subscription','2','SUBSCRIPTION_ID,SUBSCRIPTION_HEAD','subscription_id','','3','135');" autocomplete="off">
									<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_subscription&field_id=get_part.subscription_id&field_no=get_part.subscription_no&field_member_name=get_part.member_name');"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='39224.İlişki Tipi'></label>
							<div class="col col-12 col-xs-12">
								<cf_wrk_combo
									name="resource"
									query_name="GET_PARTNER_RESOURCE"
									option_name="resource"
									option_value="resource_id"
									value="#iif(isdefined("attributes.resource"),'attributes.resource',DE(''))#"
									width="164">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='39080.Mikro Bölge'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="ims_code_id" id="ims_code_id" value="<cfif isdefined('attributes.ims_code_id') and len(attributes.ims_code_id) and isdefined('attributes.ims_code_name') and len(attributes.ims_code_name)>#ims_code_id#</cfif>">
									<input type="text" name="ims_code_name" id="ims_code_name" value="<cfif isdefined('attributes.ims_code_id') and len(attributes.ims_code_id) and isdefined('attributes.ims_code_name') and len(attributes.ims_code_name)>#ims_code_name#</cfif>" onFocus="AutoComplete_Create('ims_code_name','IMS_CODE,IMS_CODE_NAME','IMS_NAME','get_ims_code','','IMS_CODE_ID','ims_code_id','','3','200');">
									<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_ims_code&field_name=get_part.ims_code_name&field_id=get_part.ims_code_id&select_list=1','','ui-draggable-box-small');"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='58960.Rapor Tipi'></label>
							<div class="col col-12 col-xs-12">
								<select name="report_type" id="report_type">
									<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="1" <cfif isdefined("attributes.report_type") and attributes.report_type eq 1>selected</cfif>><cf_get_lang dictionary_id="39052.Kategori Bazında"></option>
									<option value="2" <cfif isdefined("attributes.report_type") and attributes.report_type eq 2>selected</cfif>><cf_get_lang dictionary_id="58090.İletişim Yöntemi"> <cf_get_lang dictionary_id="58601.Bazında"></option>
									<option value="3" <cfif isdefined("attributes.report_type") and attributes.report_type eq 3>selected</cfif>><cf_get_lang dictionary_id="57482.Aşama"> <cf_get_lang dictionary_id="58601.Bazında"></option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-12 col-xs-12">
								<select name="interaction_cat" id="interaction_cat" multiple="multiple">
									<cfloop query="get_interct_cat">
										<option value="#interactioncat_id#" <cfif isdefined("attributes.interaction_cat") and listfindnocase(attributes.interaction_cat,interactioncat_id)>selected</cfif>>#interactioncat#</option>
									</cfloop> 			  
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
						<cfif x_show_special_definition eq 1>
							<div class="form-group">
								<label class="col col-12"><cf_get_lang dictionary_id='39282.Özel Tanım'></label>
								<div class="col col-12 col-xs-12">
									<select name="special_definition" id="special_definition" multiple="multiple">
										<cfloop query="get_special_definition">
											<option value="#special_definition_id#" <cfif Len(attributes.special_definition) and ListFindNoCase(attributes.special_definition,special_definition_id)>selected</cfif>>#special_definition#</option>
										</cfloop>
									</select>
								</div>
							</div>
						</cfif>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57480.Konu'></label>
							<div class="col col-12 col-xs-12">
								<input type="text" name="konu" id="konu" value="<cfif isdefined("attributes.konu")>#attributes.konu#</cfif>">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
									<cfinput type="text" name="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
									<cfinput type="text" name="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#message#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
									<input type="text" name="record_emp_name" id="record_emp_name" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2,3\',\'0\',\'0\',\'0\',\'2\',\'0\'','CONSUMER_ID,PARTNER_ID,EMPLOYEE_ID,COMPANY_ID','record_emp_id,record_emp_id,record_emp_id','get_part','3','225');">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=get_part.record_emp_id&field_emp_id=get_part.record_emp_id&field_name=get_part.record_emp_name&select_list=1,2,3');"></span>							
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-12"><cf_get_lang dictionary_id='57891.Guncelleyen'></label>
							<div class="col col-12 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="upd_emp_id" id="upd_emp_id" value="<cfif isdefined("attributes.upd_emp_id")><cfoutput>#attributes.upd_emp_id#</cfoutput></cfif>">
									<input type="text" name="upd_emp_name" id="upd_emp_name" value="<cfif isdefined("attributes.upd_emp_id") and len(attributes.upd_emp_id)><cfoutput>#attributes.upd_emp_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('upd_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'3\',\'0\',\'0\',\'0\',\'2\',\'0\'','EMPLOYEE_ID','upd_emp_id','get_part','3','225');">
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=get_part.upd_emp_id&field_emp_id=get_part.upd_emp_id&field_name=get_part.upd_emp_name&select_list=1');"></span>
								</div>
							</div>
						</div>
					</div>	
				</cfoutput>
			</cf_box_search>
		<cf_box_footer>
			<input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3">
			<cfelse>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,250" message="#message#" maxlength="3">
			</cfif>
			<cf_workcube_buttons add_function='kontrol()' is_upd='0' is_cancel='0' insert_info='#getLang('','Çalıştır',57911)#' insert_alert=''>
		</cf_box_footer>
	</cfform>
</cf_box>
<cf_box id="etkilesim_basket" title="#getLang('','Sonuçlar',58135)#" uidrop="1" hide_table_column="1">
	<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
		<cfset filename = "#createuuid()#">
		<cfheader name="Expires" value="#Now()#">
		<cfcontent type="application/vnd.msexcel;charset=utf-8">
		<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
		<meta http-equiv="content-type" content="text/plain; charset=utf-8">
	</cfif>
	<cf_grid_list>
		<cfif attributes.group_type neq 3><cfset colspan_info = 1><cfelse><cfset colspan_info = 0></cfif>
		<thead>
			<cfif attributes.group_type neq 5 and attributes.group_type neq 4 and attributes.group_type neq 2 and attributes.group_type neq 6>
				<tr>
					<cfif attributes.group_type eq 1 or attributes.group_type eq 3><cfset colspan_info = colspan_info + 1>
						<th width="125" rowspan="2"><cf_get_lang dictionary_id='57457.Müşteri'></th>
					</cfif>
					<cfif attributes.group_type neq 3>
						<cfset colspan_info = colspan_info + 1>
						<cfif attributes.group_type neq 5 and attributes.group_type neq 2 and attributes.group_type neq 4 and attributes.group_type neq 6>
							<th rowspan="2" width="35"><cf_get_lang dictionary_id='57487.No'></th>
							<th rowspan="2"><cf_get_lang dictionary_id='29514.Başvuru Yapan'></th>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 1 and attributes.group_type neq 3><cfset colspan_info = colspan_info+get_interaction_cat.recordcount*2><cfoutput query="get_interaction_cat"><th colspan="2" class="text-center">#INTERACTIONCAT#</th></cfoutput></cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 2 and attributes.group_type neq 3><cfset colspan_info = colspan_info+get_commthd.recordcount*2><cfoutput query="get_commthd"><th colspan="2" class="text-center">#COMMETHOD#</th></cfoutput></cfif>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 3 and attributes.group_type neq 3><cfset colspan_info = colspan_info+get_prcess_stge.recordcount*2><cfoutput query="get_prcess_stge"><th colspan="2" class="text-center">#stage#</th></cfoutput></cfif>
					<cfif attributes.group_type eq 3 or attributes.group_type eq 5 or attributes.group_type eq 2 or attributes.group_type eq 4 or attributes.group_type eq 6><cfset colspan_info = colspan_info+1><th width="50" rowspan="2"><cf_get_lang dictionary_id='38803.Sayı'></th></cfif>
					<cfif isdefined("attributes.report_type") and listfind('1,2,3',attributes.report_type,',') and attributes.group_type neq 3><cfset colspan_info = colspan_info+1><th width="50" rowspan="2"><cf_get_lang dictionary_id="57492.Toplam"></th></cfif>
				</tr>
				<tr>
					<cfif isdefined("attributes.report_type") and attributes.report_type eq 1 and attributes.group_type neq 3>
						<cfoutput query="get_interaction_cat">
							<th><cf_get_lang dictionary_id='39494.Cevaplı'></th>
							<th><cf_get_lang dictionary_id='39501.Cevapsız'></th>
						</cfoutput>
					<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 2 and attributes.group_type neq 3>
						<cfoutput query="get_commthd">
							<th><cf_get_lang dictionary_id='39494.Cevaplı'></th>
							<th><cf_get_lang dictionary_id='39501.Cevapsız'></th>
						</cfoutput>	
					<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 3 and attributes.group_type neq 3>
						<cfoutput query="get_prcess_stge">
							<th><cf_get_lang dictionary_id='39494.Cevaplı'></th>
							<th><cf_get_lang dictionary_id='39501.Cevapsız'></th>
						</cfoutput>
					</cfif>
				</tr>
			</cfif>
			<cfif attributes.group_type eq 5 or attributes.group_type eq 4 or attributes.group_type eq 2 or attributes.group_type eq 6>
				<tr> 
					<cfif attributes.group_type eq 5><th><cf_get_lang dictionary_id='57486.Kategori'></th></cfif>
					<cfif attributes.group_type eq 2><th><cf_get_lang dictionary_id='58832.Abone'></th></cfif>
					<cfif attributes.group_type eq 4><th><cf_get_lang dictionary_id='58090.İletişim Yöntemi'></th></cfif>
					<cfif attributes.group_type eq 6><th><cf_get_lang dictionary_id="39282.Özel Tanım"></th></cfif>
					<th><cf_get_lang dictionary_id='38803.Sayı'></th>              
				</tr> 
			</cfif>
		</thead>
		<cfif search.recordcount and attributes.group_type neq 5 and attributes.group_type neq 4 and not isdefined("attributes.sistem_gruplama") and attributes.group_type neq 6>
			<tbody>
				<cfoutput query="search" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<cfif attributes.group_type neq 3>
							<cfset my_app = APPLICANT_NAME>
							<cfquery name="musteri_" dbtype="query">
								SELECT * FROM search1 WHERE APPLICANT_NAME = '#my_app#'
								</cfquery>
							<cfif attributes.group_type eq 1> 
								<cfif isdefined('musteri_.partner_id') and len(musteri_.partner_id)>
									<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#musteri_.partner_id#','medium');" class="tableyazi"> 
											#get_par_info(musteri_.partner_id,0,1,0)#
										</a>
									</td>
								<cfelseif isdefined('musteri_.consumer_id') and len(musteri_.consumer_id)>
									<td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#musteri_.consumer_id#','medium','popup_con_det');">
											#get_cons_info(musteri_.consumer_id,0,1,0)#
										</a>
									</td>
								<cfelse>
									<td>--</td>
								</cfif>
							</cfif>
							<cfif attributes.group_type neq 5 and  attributes.group_type neq 2 and not isdefined("attributes.iletisim_gruplama")  and attributes.group_type neq 6>
								<td><a href="#request.self#?fuseaction=call.upd_helpdesk&event=upd&cus_help_id=#musteri_.cus_help_id#" class="tableyazi">#musteri_.cus_help_id#</a></td> 
								<td>#APPLICANT_NAME#</td>
							</cfif>
							<cfif isdefined('attributes.sec_asama')> 
								<cfloop query="GET_PROCESS_STAGE">
									<cfquery name="get_1" dbtype="query">
										SELECT APPLICANT_NAME FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND PROCESS_STAGE = #PROCESS_ROW_ID#
									</cfquery>
								<td>#get_1.recordcount#</td>
								</cfloop>
							</cfif>
							<cfset app_name = filterSpecialChars(my_app)>
							<cfset toplam_= 0>
							<cfset toplam_1= 0>
							<cfset toplam_2= 0>
							<cfif isdefined("attributes.report_type") and attributes.report_type eq 1 and  attributes.group_type neq 3>
								<cfloop query="get_interaction_cat">
									<cfif not isdefined("top_cvpli#INTERACTIONCAT_ID#")>
										<cfset "top_cvpli#INTERACTIONCAT_ID#" = 0>
									</cfif>
									<cfif not isdefined("top_cvpsiz#INTERACTIONCAT_ID#")>
										<cfset "top_cvpsiz#INTERACTIONCAT_ID#" = 0>
									</cfif>
									<cfquery name="cevapli_" dbtype="query">SELECT COUNT(APPLICANT_NAME) AS CEVAPLI FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND IS_REPLY_MAIL = 1 AND INTERACTION_CAT IN (#INTERACTIONCAT_ID#)</cfquery>
									<cfquery name="cevapsiz_" dbtype="query">SELECT COUNT(APPLICANT_NAME) AS CEVAPSIZ FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND IS_REPLY_MAIL = 0 AND INTERACTION_CAT IN (#INTERACTIONCAT_ID#)</cfquery>
									<cfset 'cvpli_#app_name#_#INTERACTIONCAT_ID#' = cevapli_.CEVAPLI>
									<cfset 'cvpsiz_#app_name#_#INTERACTIONCAT_ID#' = cevapsiz_.CEVAPSIZ>
									<td class="text-right">
										<cfif isdefined("cvpli_#app_name#_#INTERACTIONCAT_ID#") and len(evaluate("cvpli_#app_name#_#INTERACTIONCAT_ID#"))>
											#evaluate("cvpli_#app_name#_#INTERACTIONCAT_ID#")#
											<cfset 'top_cvpli#INTERACTIONCAT_ID#' = evaluate("top_cvpli#INTERACTIONCAT_ID#") + evaluate("cvpli_#app_name#_#INTERACTIONCAT_ID#")>
											<cfset toplam_1 = evaluate("cvpli_#app_name#_#INTERACTIONCAT_ID#") + toplam_1>
										<cfelse>
											0
											<cfset 'top_cvpli#INTERACTIONCAT_ID#' = evaluate("top_cvpli#INTERACTIONCAT_ID#")>
											<cfset toplam_1 = toplam_1>
										</cfif>
									</td>
									<td class="text-right">
										<cfif isdefined("cvpsiz_#app_name#_#INTERACTIONCAT_ID#") and len(evaluate("cvpsiz_#app_name#_#INTERACTIONCAT_ID#"))>
											#evaluate("cvpsiz_#app_name#_#INTERACTIONCAT_ID#")#
											<cfset 'top_cvpsiz#INTERACTIONCAT_ID#' = evaluate("top_cvpsiz#INTERACTIONCAT_ID#") + evaluate("cvpsiz_#app_name#_#INTERACTIONCAT_ID#")>
											<cfset toplam_2 = evaluate("cvpsiz_#app_name#_#INTERACTIONCAT_ID#") + toplam_2>
										<cfelse>
											0
											<cfset 'top_cvpsiz#INTERACTIONCAT_ID#' = evaluate("top_cvpsiz#INTERACTIONCAT_ID#")>
											<cfset toplam_2 = toplam_2>
										</cfif>
									</td>
									<cfset toplam_ = toplam_1 + toplam_2>
								</cfloop>
							<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 2 and attributes.group_type neq 3>
								<cfloop query="get_commthd">
									<cfif not isdefined("top_cvpli#COMMETHOD_ID#")>
										<cfset "top_cvpli#COMMETHOD_ID#" = 0>
									</cfif>
									<cfif not isdefined("top_cvpsiz#COMMETHOD_ID#")>
										<cfset "top_cvpsiz#COMMETHOD_ID#" = 0>
									</cfif>
									<cfquery name="cevapli_" dbtype="query">SELECT COUNT(APPLICANT_NAME) AS CEVAPLI FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND IS_REPLY_MAIL = 1 AND APP_CAT IN (#COMMETHOD_ID#)</cfquery>
									<cfquery name="cevapsiz_" dbtype="query">SELECT COUNT(APPLICANT_NAME) AS CEVAPSIZ FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND IS_REPLY_MAIL = 0 AND APP_CAT IN (#COMMETHOD_ID#)</cfquery>
									<cfset 'cvpli_#app_name#_#COMMETHOD_ID#' = cevapli_.CEVAPLI>
									<cfset 'cvpsiz_#app_name#_#COMMETHOD_ID#' = cevapsiz_.CEVAPSIZ>
									<td class="text-right">
										<cfif isdefined("cvpli_#app_name#_#COMMETHOD_ID#") and len(evaluate("cvpli_#app_name#_#COMMETHOD_ID#"))>
											#evaluate("cvpli_#app_name#_#COMMETHOD_ID#")#


											<cfset 'top_cvpli#COMMETHOD_ID#' = evaluate("top_cvpli#COMMETHOD_ID#") + evaluate("cvpli_#app_name#_#COMMETHOD_ID#")>
											<cfset toplam_1 = evaluate("cvpli_#app_name#_#COMMETHOD_ID#") + toplam_1>
										<cfelse>
											0
											<cfset 'top_cvpli#COMMETHOD_ID#' = evaluate("top_cvpli#COMMETHOD_ID#")>
											<cfset toplam_1 = toplam_1>
										</cfif>
									</td>
									<td class="text-right">
										<cfif isdefined("cvpsiz_#app_name#_#COMMETHOD_ID#") and len(evaluate("cvpsiz_#app_name#_#COMMETHOD_ID#"))>
											#evaluate("cvpsiz_#app_name#_#COMMETHOD_ID#")#
											<cfset 'top_cvpsiz#COMMETHOD_ID#' = evaluate("top_cvpsiz#COMMETHOD_ID#") + evaluate("cvpsiz_#app_name#_#COMMETHOD_ID#")>
											<cfset toplam_2 = evaluate("cvpsiz_#app_name#_#COMMETHOD_ID#") + toplam_2>
										<cfelse>
											0
											<cfset 'top_cvpsiz#COMMETHOD_ID#' = evaluate("top_cvpsiz#COMMETHOD_ID#")>
											<cfset toplam_2 = toplam_2>
										</cfif>
									</td>
									<cfset toplam_ = toplam_1 + toplam_2>
								</cfloop>
							<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 3 and attributes.group_type neq 3>
								<cfloop query="get_prcess_stge">
									<cfif not isdefined("top_cvpli#PROCESS_ROW_ID#")>
										<cfset "top_cvpli#PROCESS_ROW_ID#" = 0>
									</cfif>
									<cfif not isdefined("top_cvpsiz#PROCESS_ROW_ID#")>
										<cfset "top_cvpsiz#PROCESS_ROW_ID#" = 0>
									</cfif>
									<cfquery name="cevapli_" dbtype="query">SELECT COUNT(APPLICANT_NAME) AS CEVAPLI FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND IS_REPLY_MAIL = 1 AND PROCESS_STAGE IN (#PROCESS_ROW_ID#)</cfquery>
									<cfquery name="cevapsiz_" dbtype="query">SELECT COUNT(APPLICANT_NAME) AS CEVAPSIZ FROM search1 WHERE APPLICANT_NAME = '#my_app#' AND IS_REPLY_MAIL = 0 AND PROCESS_STAGE IN (#PROCESS_ROW_ID#)</cfquery>
									<cfset 'cvpli_#app_name#_#PROCESS_ROW_ID#' = cevapli_.CEVAPLI>
									<cfset 'cvpsiz_#app_name#_#PROCESS_ROW_ID#' = cevapsiz_.CEVAPSIZ>
									<td class="text-right">
										<cfif isdefined("cvpli_#app_name#_#PROCESS_ROW_ID#") and len(evaluate("cvpli_#app_name#_#PROCESS_ROW_ID#"))>
											#evaluate("cvpli_#app_name#_#PROCESS_ROW_ID#")#
											<cfset 'top_cvpli#PROCESS_ROW_ID#' = evaluate("top_cvpli#PROCESS_ROW_ID#") + evaluate("cvpli_#app_name#_#PROCESS_ROW_ID#")>
											<cfset toplam_1 = evaluate("cvpli_#app_name#_#PROCESS_ROW_ID#") + toplam_1>
										<cfelse>
											0
											<cfset 'top_cvpli#PROCESS_ROW_ID#' = evaluate("top_cvpli#PROCESS_ROW_ID#")>
											<cfset toplam_1 = toplam_1>
										</cfif>
									</td>
									<td class="text-right">
										<cfif isdefined("cvpsiz_#app_name#_#PROCESS_ROW_ID#") and len(evaluate("cvpsiz_#app_name#_#PROCESS_ROW_ID#"))>
											#evaluate("cvpsiz_#app_name#_#PROCESS_ROW_ID#")#
											<cfset 'top_cvpsiz#PROCESS_ROW_ID#' = evaluate("top_cvpsiz#PROCESS_ROW_ID#") + evaluate("cvpsiz_#app_name#_#PROCESS_ROW_ID#")>
											<cfset toplam_2 = evaluate("cvpsiz_#app_name#_#PROCESS_ROW_ID#") + toplam_2>
										<cfelse>
											0
											<cfset 'top_cvpsiz#PROCESS_ROW_ID#' = evaluate("top_cvpsiz#PROCESS_ROW_ID#")>
											<cfset toplam_2 = toplam_2>
										</cfif>
									</td>
									<cfset toplam_ = toplam_1 + toplam_2>
								</cfloop>
							</cfif>
							<cfif isdefined("attributes.report_type") and listfind('1,2,3',attributes.report_type,',') and attributes.group_type neq 3>
								<td class="text-right">#toplam_#</td>
							</cfif>
						<cfelse>
							<cfset toplam_sayi=toplam_sayi+sayi>
							<td><cfif type eq 'company'>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#member_id#','medium');" class="tableyazi"> 
										#get_par_info(member_id,1,0,0)#
									</a>
								<cfelse>
									<a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#member_id#','medium','popup_con_det');">
										#get_cons_info(member_id,0,1,0)#
									</a>
								</cfif>
							</td>
							<td class="text-right">#sayi#</td>    
							<cfif isdefined("attributes.report_type") and listfind('1,2,3',attributes.report_type,',') and attributes.group_type neq 3><td></td></cfif>                
						</cfif>
					</tr>
				</cfoutput>
			</tbody>
			<tfoot>
				<tr>
					<td class="txtboldblue" style="text-align:left;" <cfif attributes.group_type eq 1>colspan="3"<cfelseif attributes.group_type eq 3>colspan="1"<cfelse>colspan="2"</cfif>>
						<cfif isdefined("attributes.report_type") and listfind('1,2,3',attributes.report_type,',')>
							<cf_get_lang dictionary_id='57492.Toplam'>
						</cfif>
					</td>
					<cfif attributes.group_type eq 3>
						<td class="text-right"><cfoutput>#toplam_sayi#</cfoutput></td>
					<cfelse>
					<cfset son_toplam = 0>
					<cfset son_toplam_1 = 0>
					<cfset son_toplam_2 = 0>
						<cfif isdefined("attributes.report_type") and attributes.report_type eq 1 and attributes.group_type neq 3>
							<cfloop query="get_interaction_cat">
								<cfoutput>


									<td class="txtbold" style="text-align:right;">
										<cfif isdefined("top_cvpli#INTERACTIONCAT_ID#")>
											#evaluate("top_cvpli#INTERACTIONCAT_ID#")#
											<cfset son_toplam_1 = son_toplam_1 + evaluate("top_cvpli#INTERACTIONCAT_ID#")>
										<cfelse>
											0
											<cfset son_toplam_1 = son_toplam_1>
										</cfif> 
									</td>
									<td class="txtbold" style="text-align:right;">
										<cfif isdefined("top_cvpsiz#INTERACTIONCAT_ID#")>
											#evaluate("top_cvpsiz#INTERACTIONCAT_ID#")#
											<cfset son_toplam_2 = son_toplam_2 + evaluate("top_cvpsiz#INTERACTIONCAT_ID#")>
										<cfelse>
											0
											<cfset son_toplam_2 = son_toplam_2>
										</cfif> 
									</td>
								</cfoutput>
								<cfset son_toplam = son_toplam_1 + son_toplam_2>
							</cfloop>
						<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 2 and attributes.group_type neq 3>
							<cfloop query="get_commthd">
								<cfoutput>
									<td class="txtbold" style="text-align:right;">
										<cfif isdefined("top_cvpli#COMMETHOD_ID#")>
											#evaluate("top_cvpli#COMMETHOD_ID#")#
											<cfset son_toplam_1 = son_toplam_1 + evaluate("top_cvpli#COMMETHOD_ID#")>
										<cfelse>
											0
											<cfset son_toplam_1 = son_toplam_1>
										</cfif> 
									</td>
									<td class="txtbold" style="text-align:right;">
										<cfif isdefined("top_cvpsiz#COMMETHOD_ID#")>
											#evaluate("top_cvpsiz#COMMETHOD_ID#")#
											<cfset son_toplam_2 = son_toplam_2 + evaluate("top_cvpsiz#COMMETHOD_ID#")>
										<cfelse>
											0
											<cfset son_toplam_2 = son_toplam_2>
										</cfif> 
									</td>
								</cfoutput>
								<cfset son_toplam = son_toplam_1 + son_toplam_2>
							</cfloop>
						<cfelseif isdefined("attributes.report_type") and attributes.report_type eq 3 and attributes.group_type neq 3>
							<cfloop query="get_prcess_stge">
								<cfoutput>
									<td class="txtbold" style="text-align:right;">
										<cfif isdefined("top_cvpli#PROCESS_ROW_ID#")>
											#evaluate("top_cvpli#PROCESS_ROW_ID#")#
											<cfset son_toplam_1 = son_toplam_1 + evaluate("top_cvpli#PROCESS_ROW_ID#")>
										<cfelse>
											0
											<cfset son_toplam_1 = son_toplam_1>
										</cfif> 
									</td>
									<td class="txtbold" style="text-align:right;">
										<cfif isdefined("top_cvpsiz#PROCESS_ROW_ID#")>
											#evaluate("top_cvpsiz#PROCESS_ROW_ID#")#
											<cfset son_toplam_2 = son_toplam_2 + evaluate("top_cvpsiz#PROCESS_ROW_ID#")>
										<cfelse>
											0
											<cfset son_toplam_2 = son_toplam_2>
										</cfif> 
									</td>
								</cfoutput>
								<cfset son_toplam = son_toplam_1 + son_toplam_2>
							</cfloop>
						</cfif>
					</cfif>
					<cfif isdefined("attributes.report_type") and listfind('1,2,3',attributes.report_type,',') and attributes.group_type neq 3><td class="txtbold" style="text-align:right;"><cfoutput>#son_toplam#</cfoutput></td></cfif>
				</tr>
			</tfoot>
		<cfelse>
			<cfif attributes.group_type neq 5 and not isdefined("attributes.sistem_gruplama") and attributes.group_type neq 4  and attributes.group_type neq 6>
				<tr>
					<td colspan="<cfoutput>#colspan_info#</cfoutput>" height="22"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id = '57701.Filtre Ediniz'></cfif>!</td>
				</tr>
			</cfif>
		</cfif>
		<cfif attributes.group_type eq 5>
				<cfset total_cat = 0>
				<cfset attributes.totalrecords = get_interaction_cat.recordcount>
				<cfloop query="get_interaction_cat" startrow="#attributes.startrow#" endrow="#Evaluate("#attributes.startrow#+#attributes.maxrows#-1")#">
					<cfquery dbtype="query" name="GetCount#interactioncat_id#">
						SELECT COUNT(CUS_HELP_ID) AS CAT_TOTAL FROM search1 WHERE INTERACTION_CAT = #interactioncat_id#
					</cfquery>
					<cfif len(Evaluate("GetCount#interactioncat_id#.cat_total"))><cfset cat_interaction = Evaluate("GetCount#interactioncat_id#.cat_total")><cfelse><cfset cat_interaction = 0></cfif>
					<cfset total_cat = total_cat + cat_interaction>                            
					<tbody>
					<cfoutput>
						<tr>
							<td>#interactioncat#</td>
							<td class="text-right">#cat_interaction#</td>
						</tr>
					</cfoutput>
					</tbody>
				</cfloop>
			</cfif>
			<cfif attributes.group_type eq 2>
			<cfset total_sis = 0>
			<cfset attributes.totalrecords = getSubsList.recordcount>
			<cfloop query="getSubsList" startrow="#attributes.startrow#" endrow="#Evaluate("#attributes.startrow#+#attributes.maxrows#-1")#">
				<cfquery dbtype="query" name="GetCount#subscription_id#">
					SELECT COUNT(CUS_HELP_ID) AS SIS_TOTAL FROM search1 WHERE SUBSCRIPTION_ID = #subscription_id#
				</cfquery>
				<cfif len(Evaluate("GetCount#subscription_id#.sis_total"))><cfset sis_interaction = Evaluate("GetCount#subscription_id#.sis_total")><cfelse><cfset sis_interaction = 0></cfif>
				<cfset total_sis = total_sis + sis_interaction>
				<tbody>                       
				<cfoutput>
					<tr>
						<td>#subscription_head#</td>
						<td class="text-right">#sis_interaction#</td>
					</tr>
				</cfoutput>
				</tbody>
			</cfloop>
			</cfif>
			<cfif attributes.group_type eq 4>
			<cfset total_ilet = 0>
			<cfset attributes.totalrecords = get_commthd.recordcount>
			<cfloop query="get_commthd" startrow="#attributes.startrow#" endrow="#Evaluate("#attributes.startrow#+#attributes.maxrows#-1")#">
				<cfquery dbtype="query" name="GetCount#commethod_id#">
					SELECT COUNT(CUS_HELP_ID) AS ILET_TOTAL FROM search1 WHERE APP_CAT = #commethod_id#
				</cfquery>
				<cfif len(Evaluate("GetCount#commethod_id#.ilet_total"))><cfset ilet_interaction = Evaluate("GetCount#commethod_id#.ilet_total")><cfelse><cfset ilet_interaction = 0></cfif>
			<cfset total_ilet = total_ilet + ilet_interaction>
			<tbody>
			<cfoutput>
				<tr>
					<td>#commethod#</td>
					<td class="text-right">#ilet_interaction#</td>
				</tr>
			</cfoutput>
			</tbody>
			</cfloop>
			</cfif>
		<cfif attributes.group_type eq 6>
			<cfset total_special = 0>
			<cfset attributes.totalrecords = get_special_def.recordcount>
			<cfloop query="get_special_def" startrow="#attributes.startrow#" endrow="#Evaluate("#attributes.startrow#+#attributes.maxrows#-1")#">
				<cfquery dbtype="query" name="GetCount#special_definition_id#">
					SELECT COUNT(CUS_HELP_ID) AS SPECIAL_TOTAL FROM search1 WHERE SPECIAL_DEFINITION_ID = #special_definition_id#
				</cfquery>
				<cfif len (Evaluate("GetCount#special_definition_id#.special_total"))><cfset special_interaction = Evaluate ("GetCount#special_definition_id#.special_total")><cfelse><cfset special_interaction = 0></cfif>
			<cfset total_special = total_special + special_interaction>
			<tbody>
			<cfoutput>
				<tr>
					<td>#special_definition#</td>
					<td class="text-right">#special_interaction#</td>
				</tr>
			</cfoutput> 
			</tbody>                       
			</cfloop>
		</cfif>
		<cfif attributes.group_type eq 5 or attributes.group_type eq 2 or attributes.group_type eq 4 or attributes.group_type eq 6>
		<tfoot>
			<tr>
				<td class="txtboldblue"><cf_get_lang dictionary_id='57492.Toplam'></td>
				<cfif attributes.group_type eq 5><td class="txtbold" style="text-align:right;"><cfoutput>#total_cat#</cfoutput></td></cfif>
				<cfif attributes.group_type eq 2><td class="txtbold" style="text-align:right;" ><cfoutput>#total_sis#</cfoutput></td></cfif>
				<cfif attributes.group_type eq 4><td class="txtbold" style="text-align:right;" ><cfoutput>#total_ilet#</cfoutput></td></cfif>
				<cfif attributes.group_type eq 6><td class="txtbold" style="text-align:right;"><cfoutput>#total_special#</cfoutput></td></cfif>
			</tr>
		</tfoot>
		</cfif>
	</cf_grid_list>
</cf_box>
	<cfif isdefined("attributes.form_submitted") and attributes.totalrecords gt attributes.maxrows>
		<cfset url_str = "">
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
			<cfset url_str = "#url_str#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
		</cfif>
		<cfif isdefined('attributes.applicant_name') and len(attributes.applicant_name)>
			<cfset url_str = "#url_str#&applicant_name=#attributes.applicant_name#">
		</cfif>
		<cfif isdefined('attributes.ims_code_id') and len(attributes.ims_code_id) and isdefined('attributes.ims_code_name') and len(attributes.ims_code_name)>
			<cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#&ims_code_name=#attributes.ims_code_name#">
		</cfif>
		<cfif isdefined('attributes.start_date') and len(attributes.start_date)>
			<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		</cfif>
		<cfif isdefined('attributes.finish_date') and len(attributes.finish_date)>
			<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		</cfif>
		<cfif isdefined("attributes.form_submitted")>
			<cfset url_str = "#url_str#&form_submitted=1">
		</cfif>
		<cfif isdefined("attributes.group_type")>
			<cfset url_str = "#url_str#&group_type=#attributes.group_type#">
		</cfif>
		<cfif isdefined("attributes.interaction_cat")>
			<cfset url_str = "#url_str#&interaction_cat=#attributes.interaction_cat#">
		</cfif>
		<cfif isdefined("attributes.konu") and len(attributes.konu)>
			<cfset url_str = "#url_str#&konu=#attributes.konu#">
		</cfif>
		<cfif isdefined("attributes.customer_value") and len(attributes.customer_value)>
			<cfset url_str = "#url_str#&customer_value=#attributes.customer_value#">
		</cfif>
		<cfif isdefined("attributes.sales_county") and len(attributes.sales_county)>
			<cfset url_str = "#url_str#&sales_county=#attributes.sales_county#">
		</cfif>
		<cfif isdefined("attributes.resource") and len(attributes.resource)>
			<cfset url_str = "#url_str#&resource=#attributes.resource#">
		</cfif>
		<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
			<cfset url_str = "#url_str#&process_stage=#attributes.process_stage#">
		</cfif>
		<cfif isdefined("attributes.app_cat") and len(attributes.app_cat)>
			<cfset url_str = "#url_str#&app_cat=#attributes.app_cat#">
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.report_type") and len(attributes.report_type)>
			<cfset url_str = "#url_str#&report_type=#attributes.report_type#">
		</cfif>
		<cfif Len(attributes.special_definition)><cfset url_str = "#url_str#&special_definition=#attributes.special_definition#"></cfif>
			<cf_paging 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="report.etkilesim_rapor#url_str#">
	</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.get_part.is_excel.checked==false)
		{
			document.get_part.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.etkilesim_rapor</cfoutput>";
			return true;
		}
		else
			document.get_part.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_etkilesim_rapor</cfoutput>";
	}
</script>
