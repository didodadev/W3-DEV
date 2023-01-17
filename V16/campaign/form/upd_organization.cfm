<cf_xml_page_edit fuseact="campaign.add_organization" is_multi_page="1">
<cfquery name="GET_ORGANIZATIONS" datasource="#DSN#">
	SELECT 
    	IS_ACTIVE,
		ORGANIZATION_HEAD,
		ORGANIZATION_CAT_ID,
		ORGANIZER_EMP,
		ORGANIZER_CON,
		ORGANIZER_PAR,
		START_DATE,
		FINISH_DATE,
		MAX_PARTICIPANT,
		ADDITIONAL_PARTICIPANT,
		ORGANIZATION_DETAIL,
		ORGANIZATION_PLACE,
		ORGANIZATION_PLACE_ADDRESS,
		ORGANIZATION_PLACE_TEL,
		ORGANIZATION_PLACE_MANAGER,
		ORGANIZATION_ANNOUNCEMENT,
		ORGANIZATION_TARGET,
		ORGANIZATION_TOOLS,
		CAMPAIGN_ID,
		PROJECT_ID,
		VIEW_TO_ALL,
		INT_OR_EXT,
		IS_INTERNET,
		IS_VIEW_BRANCH,
		IS_VIEW_DEPARTMENT,
		TOTAL_DATE,
		TOTAL_HOUR,
		RECORD_DATE,
		RECORD_EMP,
		RECORD_IP,
		UPDATE_DATE,
		UPDATE_EMP,
		UPDATE_IP,
		ORG_STAGE,
		ONLINE,
		ORGANIZATION_LINK
	FROM 
 		ORGANIZATION
	WHERE 
		ORGANIZATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.org_id#">
</cfquery>
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT MENU_ID,SITE_DOMAIN,OUR_COMPANY_ID FROM MAIN_MENU_SETTINGS WHERE IS_ACTIVE = 1 AND SITE_DOMAIN IS NOT NULL
</cfquery>
<cfquery name="GET_SITE_DOMAINS" datasource="#DSN#">
	SELECT ORGANIZATION_ID,MENU_ID FROM ORGANIZATION_SITE_DOMAIN
</cfquery>
<cfquery name="FIND_DEPARTMENT_BRANCH" datasource="#DSN#">
	SELECT
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME,
		DEPARTMENT.DEPARTMENT_ID,
		DEPARTMENT.DEPARTMENT_HEAD
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH
	WHERE
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfif len(get_organizations.campaign_id)>
	<cfquery name="GET_CAMPAIGN" datasource="#DSN3#">
		SELECT CAMP_HEAD,CAMP_ID FROM CAMPAIGNS WHERE CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.campaign_id#">
	</cfquery>
</cfif>
<cfquery name="GET_RECORD_POSITIONS_CODE" datasource="#DSN#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.record_emp#">  AND IS_MASTER = 1
</cfquery>
<cfif len(get_organizations.project_id)>
	<cfquery name="GET_PROJECT" datasource="#DSN#">
		SELECT PROJECT_HEAD,PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.project_id#">
	</cfquery>
</cfif>

<cfif len(get_organizations.start_date)>
	 <cfset start_date = date_add('h',session.ep.time_zone,get_organizations.start_date)> 
<cfelse>
	<cfset start_date = "">
</cfif>
<cfif len(get_organizations.finish_date)>
	<cfset finish_date = date_add('h',session.ep.time_zone,get_organizations.finish_date)>
<cfelse>
	<cfset finish_date = "">
</cfif>
<cf_catalystHeader>
<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
    <cf_box>
		<cfform name="upd_organization" method="post" action="#request.self#?fuseaction=campaign.emptypopup_upd_organization&org_id=#attributes.org_id#">
			<cfif isdefined("attributes.prj_id")>
				<input type="hidden" name="caller_project_id" id="caller_project_id" value="<cfoutput>#attributes.prj_id#</cfoutput>" />
			</cfif>
			<cfif isdefined("attributes.cmp_id")><input type="hidden" name="caller_campaign_id" id="caller_campaign_id" value="<cfoutput>#attributes.cmp_id#</cfoutput>" /></cfif>
			<input type="hidden" name="xml_project_date_control" id="xml_project_date_control" value="<cfoutput>#xml_project_date_control#</cfoutput>">
			<input type="hidden" name="org_id" id="org_id" value="<cfoutput>#attributes.org_id#</cfoutput>">
			<cf_tab defaultOpen="sayfa_2" divId="sayfa_2,sayfa_1" divLang="#getLang('','Etkinlik Bilgileri','51624')#;#getLang('','Etkinlik İçeriği','49341')#">
                <div id="unique_sayfa_2" class="ui-info-text uniqueBox">
					<cf_box_elements vertical="1">
						<div class="col col-2 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-is_active">
								<label ><input type="checkbox" name="online" id="online" onclick="gizle_goster(url_organization_);" value="1"<cfif get_organizations.online eq 1> checked</cfif>><cf_get_lang dictionary_id='30015.online'></label>
								<label><input type="checkbox" name="int_or_ext" id="int_or_ext" value="1" <cfif get_organizations.int_or_ext eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='58562.Dış'><cf_get_lang dictionary_id='29465.Etkinlik'></label>
								<label><input type="checkbox" name="is_net_display" id="is_net_display" value="1" onClick="gizle_goster(is_site_display);" <cfif get_organizations.is_internet eq 1>checked="checked"</cfif> ><cf_get_lang dictionary_id='47667.Internette Görünsün'></label>
								<label><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_organizations.is_active eq 1>checked="checked"</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
								<label><input type="checkbox" name="view_to_all" id="view_to_all" <cfif get_organizations.view_to_all eq 1 and not len(get_organizations.is_view_branch) and not len(get_organizations.is_view_department) >checked</cfif> value="1"  onClick="view_control(1);"><cf_get_lang dictionary_id='49348.Bu olayı herkes görsün'></label>
								<label><input type="checkbox" name="is_view_branch" id="is_view_branch" <cfif len(get_organizations.is_view_branch) and not len(get_organizations.is_view_department)>checked</cfif> value="#find_department_branch.BRANCH_ID#" onClick="view_control(2);"><cf_get_lang dictionary_id='57914.Şubemdeki Herkes Görsün'></label>
								<input type="hidden" name="is_view_branch_" id="is_view_branch_" value="#find_department_branch.BRANCH_ID#">
								<label><input type="checkbox" name="is_view_department" id="is_view_department" <cfif len(get_organizations.is_view_department)>checked</cfif> value="#find_department_branch.DEPARTMENT_ID#" onClick="view_control(3);"><cf_get_lang dictionary_id='57915.Departmanımdaki Herkes Görsün'></label>							
							</div>
							<div class="form-group scrollContent scroll-x2" id="is_site_display" <cfif get_organizations.is_internet eq 0>style="display:none;"</cfif>>
								<label class="col col-12 col-xs-12 formbold"><cf_get_lang dictionary_id='49342.Yayınlanacak Site'></label> 
								<cfset my_organization_list = valuelist(get_site_domains.menu_id)>
								<cfoutput query="get_site_menu">
									<div class="col col-12">
										<input type="checkbox" name="menu_#menu_id#" id="menu_#menu_id#" value="#menu_id#" <cfif len(my_organization_list) and ListFindNoCase(my_organization_list,menu_id,',')>checked</cfif>>#site_domain#
									</div>
								</cfoutput> 
							</div>
						</div>
						<div class="col col-5 col-md-6 col-sm-12 col-xs-12" type="column" index="2" sort="true"> 
							<cfscript>
									local = {};
									local.start = timeformat(get_organizations.start_date,timeformat_style);
									local.end = timeformat(get_organizations.finish_date,timeformat_style);
									local.today = timeformat(now(),timeformat_style);
									local.valid = false;
									if ( (dateDiff("h", local.start, local.today) >= 0) 
											AND (dateDiff("h", local.today, local.end) >= 0) ){
										local.valid = true;
									}
								</cfscript>
								<div class="form-group" id="url_organization_" <cfif get_organizations.online eq 0> style="display:none;" </cfif>>
									<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29761.url'></label>
									<div class="col col-8 col-xs-12">									
										<cfoutput>
										<div class="input-group">	
											<cfinput type="text" name="url_organization" id="url_organization" value="#get_organizations.ORGANIZATION_LINK#">
											<a class="input-group-addon btnPointer" target="_blank" href="#get_organizations.ORGANIZATION_LINK#" <cfif local.valid eq false> onclick="return false;" </cfif>>
											<i class="icon-link"></i></a>
										</cfoutput>
										</div>
									</div>
								</div>
							<div class="form-group" id="item-organization_cat_id"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.kategori'></label>
								<div class="col col-8 col-xs-12">
									<cf_wrk_combo 
										query_name="GET_ORGANIZATION_CAT" 
										name="organization_cat_id" 
										option_value="organization_cat_id" 
										option_name="organization_cat_name"
										value="#get_organizations.organization_cat_id#"
										width=275>
								</div>
							</div>
							<div class="form-group" id="item-organization_head"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51770.Etkinlik Adı'>*</label>
								<div class="col col-8 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58820.başlık'></cfsavecontent>
									<cfinput type="text" name="organization_head" value="#get_organizations.organization_head#" required="Yes" maxlength="100" message="#message#">
								</div>
							</div>
							<div class="form-group" id="item-form_ul_process_stage">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="old_invoice_process_value" id="old_invoice_process_value" value="<cfoutput>#get_organizations.org_stage#</cfoutput>">
									<cf_workcube_process is_upd='0' select_value='#get_organizations.org_stage#' is_detail='1'>
								</div>
							</div>
							<div class="form-group" id="item-company_name"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49714.Etkinlik Yetkilisi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfoutput query="get_organizations">
											<input type="hidden" name="emp_id" id="emp_id" value="<cfif len(organizer_emp)>#organizer_emp#</cfif>">
											<input type="hidden" name="par_id" id="par_id" value="<cfif len(organizer_par)>#organizer_par#</cfif>">
											<input type="hidden" name="con_id" id="con_id" value="<cfif len(organizer_con)>#organizer_con#</cfif>">
											<cfif len(get_organizations.organizer_emp)>
												<cfquery name="get_emp_name" datasource="#dsn#">
													SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.organizer_emp#">
												</cfquery>
												<cfset member_type = 'employee'>
												<input type="text" name="company_name" id="company_name" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','emp_id,par_id,con_id,member_type','','3','250');" value="#get_emp_name.EMPLOYEE_NAME# #get_emp_name.EMPLOYEE_SURNAME#">
											<cfelseif len(get_organizations.organizer_par)>
												<cfquery name="get_par_name" datasource="#dsn#">
													SELECT COMPANY_PARTNER_NAME , COMPANY_PARTNER_SURNAME, COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.organizer_par#">
												</cfquery>
												<cfquery name = "get_comp_name" datasource = "#dsn#">
													SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_par_name.company_id#">
												</cfquery>
												<cfset member_type = 'partner'>
												<!---
												<input type="text" name="company_name" id="company_name" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','emp_id,par_id,con_id,member_type','','3','250');" value="<cfoutput>#get_par_name.COMPANY_PARTNER_NAME# #get_par_name.COMPANY_PARTNER_SURNAME#</cfoutput>" >
												--->
												<input type="text" name="company_name" id="company_name" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME2,MEMBER_PARTNER_NAME2','get_member_autocomplete','\'1,2,3\'','PARTNER_ID2,MEMBER_TYPE,MEMBER_PARTNER_NAME2,EMPLOYEE_ID,CONSUMER_ID','par_id,member_type,emp_par_name,emp_id,con_id','','3','250');" value="<cfoutput>#get_comp_name.FULLNAME#</cfoutput>" >
											<cfelseif len(get_organizations.organizer_con)>
												<cfquery name="get_cons_name" datasource="#dsn#">
													SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_organizations.organizer_con#">
												</cfquery>
												<cfset member_type = 'consumer'>
												<input type="text" name="company_name" id="company_name" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','emp_id,par_id,con_id,member_type','','3','250');" value="#get_cons_name.CONSUMER_NAME# #get_cons_name.CONSUMER_SURNAME#">
											<cfelse>
												<input type="text" name="company_name" id="company_name" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\',0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID,MEMBER_TYPE','emp_id,par_id,con_id,member_type','','3','250');" value="">
												<cfset member_type = ''>
											</cfif>
											<input type="hidden" name="member_type" id="member_type" value="#member_type#">
										</cfoutput> 
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_organization.emp_id&field_name=upd_organization.company_name&field_comp_name=upd_organization.company_name&field_type=upd_organization.member_type&field_partner=upd_organization.par_id&field_consumer=upd_organization.con_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>');" title="<cfoutput>#getLang('','Etkinlik Yetkilisi',49714)#</cfoutput>"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-start_date"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.başlama'></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="start_date" value="#dateformat(start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									</div>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_wrkTimeFormat name="event_start_clock" value="#timeformat(start_date,'HH')#">
								</div>
								<div class="col col-2 col-xs-12">
									<cfoutput query="get_organizations">
										<select name="event_start_minute" id="event_start_minute">
											<option value="00">00</option>
											<option value="05"<cfif timeformat(start_date,'MM') eq 05> selected</cfif>>05</option>
											<option value="10"<cfif timeformat(start_date,'MM') eq 10> selected</cfif>>10</option>
											<option value="15"<cfif timeformat(start_date,'MM') eq 15> selected</cfif>>15</option>
											<option value="20"<cfif timeformat(start_date,'MM') eq 20> selected</cfif>>20</option>
											<option value="25"<cfif timeformat(start_date,'MM') eq 25> selected</cfif>>25</option>
											<option value="30"<cfif timeformat(start_date,'MM') eq 30> selected</cfif>>30</option>
											<option value="35"<cfif timeformat(start_date,'MM') eq 35> selected</cfif>>35</option>
											<option value="40"<cfif timeformat(start_date,'MM') eq 40> selected</cfif>>40</option>
											<option value="45"<cfif timeformat(start_date,'MM') eq 45> selected</cfif>>45</option>
											<option value="50"<cfif timeformat(start_date,'MM') eq 50> selected</cfif>>50</option>
											<option value="55"<cfif timeformat(start_date,'MM') eq 55> selected</cfif>>55</option>
										</select>
									</cfoutput>
								</div> 
							</div>                        
							<div class="form-group" id="item-finish_date"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitis'></label>
								<div class="col col-4 col-xs-12">
									<div class="input-group">
										<cfinput value="#dateformat(finish_date,dateformat_style)#" type="text" name="finish_date" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
								<div class="col col-2 col-xs-12">
									<cf_wrkTimeFormat name="event_finish_clock" value="#timeformat(finish_date,'HH')#">
								</div>
								<div class="col col-2 col-xs-12">
									<cfoutput query="get_organizations">
									<select name="event_finish_minute" id="event_finish_minute">
										<option value="00">00</option>
										<option value="05"<cfif timeformat(finish_date,'MM') eq 05> selected</cfif>>05</option>
										<option value="10"<cfif timeformat(finish_date,'MM') eq 10> selected</cfif>>10</option>
										<option value="15"<cfif timeformat(finish_date,'MM') eq 15> selected</cfif>>15</option>
										<option value="20"<cfif timeformat(finish_date,'MM') eq 20> selected</cfif>>20</option>
										<option value="25"<cfif timeformat(finish_date,'MM') eq 25> selected</cfif>>25</option>
										<option value="30"<cfif timeformat(finish_date,'MM') eq 30> selected</cfif>>30</option>
										<option value="35"<cfif timeformat(finish_date,'MM') eq 35> selected</cfif>>35</option>
										<option value="40"<cfif timeformat(finish_date,'MM') eq 40> selected</cfif>>40</option>
										<option value="45"<cfif timeformat(finish_date,'MM') eq 45> selected</cfif>>45</option>
										<option value="50"<cfif timeformat(finish_date,'MM') eq 50> selected</cfif>>50</option>
										<option value="55"<cfif timeformat(finish_date,'MM') eq 55> selected</cfif>>55</option>
									</select>
									</cfoutput> 
								</div>
							</div> 
							<div class="form-group" id="item-total_date"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'></label>
								<div class="col col-4 col-xs-12">
									<cfinput type="text" name="total_date" id="total_date" value="#get_organizations.total_date#" onKeyup='return(FormatCurrency(this,event));'  maxlength="100">
								</div>
								<div class="col col-4 col-xs-12">
									<cfinput type="text" name="total_hour" id="total_hour" value="#get_organizations.total_hour#" onKeyup='return(FormatCurrency(this,event));' maxlength="100">
								</div>
							</div>  
							<div class="form-group" id="item-organization_target"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55474.Amaç'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="organization_target" id="organization_target"><cfoutput>#get_organizations.organization_target#</cfoutput></textarea> 
								</div>
							</div>
							<div class="form-group" id="item-organization_announcement"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49340.Etkinlik Duyurusu'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="organization_announcement" id="organization_announcement"><cfoutput query="get_organizations">#organization_announcement#</cfoutput></textarea>
								</div>
							</div> 
						</div>
						<div class="col col-5 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true"> 
							<div class="form-group" id="item-max_participant"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49343.Maksimum Katılımcı'></label>
								<div class="col col-8 col-xs-12">
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.tam sayı'></cfsavecontent>
										<cfinput type="text" name="max_participant" placeholder="#getlang('','Maksimum Katılımcı','49343')#" value="#get_organizations.max_participant#" validate="integer" message="#message#"> 
									</div>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='57477.hatalı veri'>:<cf_get_lang dictionary_id='58195.tam sayı'></cfsavecontent>
										<cfinput type="text" name="additional_participant" placeholder="#getlang('','Ek Kontenjan','49345')#" value="#get_organizations.additional_participant#" validate="integer" message="#message#">
									</div>
								</div>
							</div>
							<div class="form-group" id="item-organization_place"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49712.Etkinlik Yeri'></label>
								<div class="col col-8 col-xs-12">
									<cfinput type="text" name="organization_place" value="#get_organizations.organization_place#" maxlength="100">							 
								</div>
							</div>                   
							<div class="form-group" id="item-organization_place_manager"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49712.Etkinlik Yeri'><cf_get_lang dictionary_id='57544.Sorumlu'></label>
								<div class="col col-8 col-xs-12">
									<cfinput type="text" name="organization_place_manager" value="#get_organizations.organization_place_manager#" maxlength="100">							 
								</div>
							</div>                        
							<div class="form-group" id="item-organization_place_address"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49712.Etkinlik Yeri'><cf_get_lang dictionary_id='58723.Adres'></label>
								<div class="col col-8 col-xs-12">
									<cfinput type="text" value="#get_organizations.organization_place_address#" name="organization_place_address" maxlength="100">							 
								</div>
							</div>                      
							<div class="form-group" id="item-organization_place_tel"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='49712.Etkinlik Yeri'><cf_get_lang dictionary_id='57499.Telefon'></label>
								<div class="col col-8 col-xs-12">
									<cfinput type="text" name="organization_place_tel" value="#get_organizations.organization_place_tel#" maxlength="100">							 
								</div>
							</div>            
							<div class="form-group" id="item-camp_name"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57446.Kampanya'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group"> 
										<input type="hidden" name="camp_id" id="camp_id" value="<cfif len(get_organizations.campaign_id)><cfoutput query="get_campaign">#get_campaign.camp_id#</cfoutput></cfif>">
										<input type="text" name="camp_name" id="camp_name" value="<cfif len(get_organizations.campaign_id)><cfoutput query="get_campaign">#get_campaign.camp_head#</cfoutput></cfif>">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_campaigns</cfoutput>&field_id=upd_organization.camp_id&field_name=upd_organization.camp_name&is_next_day');" title="<cf_get_lang dictionary_id='57446.Kampanya'>"></span>
									</div>
								</div>
							</div>          
							<div class="form-group" id="item-project_head"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.proje'> <cfif xml_project_required eq 1>*</cfif></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group"> 
										<input type="hidden" name="project_id" id="project_id" value="<cfif len(get_organizations.project_id)><cfoutput query="get_project">#get_project.project_id#</cfoutput></cfif>">
										<input type="text" name="project_head" id="project_head"  value="<cfif len(get_organizations.project_id)><cfoutput query="get_project">#get_project.project_id# - #get_project.project_head#</cfoutput></cfif>">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=upd_organization.project_id&project_head=upd_organization.project_head');" title="<cfoutput>#getLang('','Proje',57416)#</cfoutput>"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-organization_tools"> 
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57414.Araçlar'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="organization_tools" id="organization_tools" style="width:250px;height:50px;"><cfoutput query="get_organizations">#organization_tools#</cfoutput></textarea>							 
								</div>
							</div>
							<cfquery name="find_department_branch" datasource="#DSN#">
								SELECT
									EMPLOYEE_POSITIONS.EMPLOYEE_ID,
									EMPLOYEE_POSITIONS.POSITION_ID,
									EMPLOYEE_POSITIONS.POSITION_CODE,
									BRANCH.BRANCH_ID,
									BRANCH.BRANCH_NAME,
									DEPARTMENT.DEPARTMENT_ID,
									DEPARTMENT.DEPARTMENT_HEAD
								FROM
									EMPLOYEE_POSITIONS,
									DEPARTMENT,
									BRANCH
								WHERE
									EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
									DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
									<cfif get_record_positions_code.recordcount>
										AND EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_record_positions_code.position_code#">
									</cfif>
							</cfquery>												
						</div>
					</cf_box_elements>
				</div>
				<div id="unique_sayfa_1" class="ui-info-text uniqueBox">
					<cf_box_elements vertical="1">
						<div class="col col-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-editor">
								<label style="display:none!important;"><cf_get_lang dictionary_id='57653.İçerik'></label>
								<cfoutput query="get_organizations">
									<cfmodule
										template="/fckeditor/fckeditor.cfm"
										toolbarSet="Basic"
										basePath="/fckeditor/"
										instanceName="organization_detail"
										value="#organization_detail#"
										valign="top"
										width="675"
										height="180"
										label="Etkinlik İçeriği">
								</cfoutput>
							</div>
						</div>
					</cf_box_elements>
				</div>
			</cf_tab>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>  
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_record_info query_name="get_organizations" is_consumer="0">
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=campaign.emptypopup_del_organization&org_id=#attributes.org_id#' add_function='kontrol()'>
					</div>
				</cf_box_footer>
			</div>				
		</cfform>
	</cf_box>
	<!--- Takipler --->
	<cfinclude template="../query/get_organization_plus.cfm">
	<cf_box id="Takipler_box" title="#getLang('','Takipler','57325')#" collapsed="1" closable="0" add_href="javascript:openBoxDraggable('#request.self#?fuseaction=campaign.popup_add_organization_plus&organization_id=#attributes.org_id#&plus_type=organization')">
		
		<cfoutput query="get_organization_plus">
			<div class="ui-card">
				<div class="ui-card-item">
					<div class="ui-info-text padding-left-10">
						#replace(plus_content,"<p>","<br>","all")#
					</div>
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<cf_box_footer>
							<div class="col col-10 col-md-10 col-sm-10 col-xs-12">  
								<p>
									<cfif len(record_emp) or len(record_par)>
										<b><cf_get_lang dictionary_id='57483.Kayıt'></b>: 
									</cfif>
									<cfif len(record_emp)>#get_emp_info(record_emp,0,0)#<cfelseif len(record_par)>#get_par_info(record_par,0,0,0)#</cfif>
									<cfif len(record_date)> - #Dateformat(record_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,record_date),timeformat_style)#</cfif>
								</p>
								<cfif len(MAIL_SENDER)>
									<p><b><cf_get_lang dictionary_id='30883.Bildirimler'></b>: #mail_sender#</p>
								</cfif>
								<cfif len(update_emp)>
									<p>
										<b><cf_get_lang dictionary_id='57703.Güncelleme'></b>: #get_emp_info(update_emp,0,0)#
										<cfif len(update_date)> - #Dateformat(update_date,dateformat_style)# #TimeFormat(date_add('h',session.ep.time_zone,update_date),timeformat_style)#</cfif>
									</p>
								</cfif>
							</div>
							<cfif not listfindnocase(denied_pages,'campaign.popup_upd_organization_plus')>
								<div class="col col-2 col-xs-12">  <a href="javascript://" class="pull-right ui-wrk-btn ui-wrk-btn-success" onClick="openBoxDraggable('#request.self#?fuseaction=campaign.popup_upd_organization_plus&organization_id=#attributes.org_id#&organization_plus_id=#organization_plus_id#&plus_type=organization','','ui-draggable-medium');"><cf_get_lang dictionary_id='57464.Güncelle'></a></div>
							</cfif>
						</cf_box_footer>
					</div>
				</div>
            </div>
    	</cfoutput>
	</cf_box>
	<!--- Değerlendirme Formları --->
	<cf_get_workcube_form_generator action_type='16' related_type='16' action_type_id='#url.org_id#' design='1'>
	<!--- İş Akış Tasarımcısı --->
	<cfset action_section = "ORGANIZATION">
	<cfset relative_id = attributes.org_id>
	<cfinclude template="../../process/display/list_designer.cfm"> 
</div>
<div class="col col-3 col-sm-3 col-xs-12">
	<!--- Katılımcılar --->
	<cf_box 
	id="attender"
	closable="0"
	box_page="#request.self#?fuseaction=campaign.emptypopup_upd_class_attender_ajax&organization_id=#attributes.org_id#"
	title="#getLang('','Katılımcılar',57590)#"></cf_box>
	
	<!--- Varlıklar --->
	<cf_get_workcube_asset asset_cat_id="-15" module_id='15' action_section='ORGANIZATION_ID' action_id='#url.org_id#'>

	<!--- Notlar --->
	<cf_get_workcube_note action_section='ORGANIZATION_ID' action_id='#url.org_id#'>

	<!---Fiziki Varlık ve Rezervasyon---->	
	<cf_box 
	id="assetp"
	closable="0"
	add_href="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_assets&organization_id=#attributes.org_id#')"
	box_page="#request.self#?fuseaction=campaign.emptypopup_upd_class_resarvation_ajax&organization_id=#url.org_id#"
	title="#getLang('','Fiziki Varlık ve Rezervasyon','46687')#"></cf_box>
</div>
<script type="text/javascript">
	var temp = upd_organization.organization_id;
	
	function redirect(x)
	{
		for (m=temp.options.length-1;m>0;m--)
			temp.options[m] = null;
		for (i=0;i<group[x].length;i++)
			temp.options[i]=new Option(group[x][i].text,group[x][i].value);
	
		temp.options[0].selected=true;
	}
	function check()
	{
		if (document.upd_organization.organization_cat_id.value =='' || document.upd_organization.organization_cat_id.value == 0)
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57486.Kategori'>");
				return false;
			}
		
		if ( (upd_organization.start_date.value != "") && (upd_organization.finish_date.value != "") ) {
			return time_check(upd_organization.start_date, upd_organization.event_start_clock, upd_organization.event_start_minute, upd_organization.finish_date,  upd_organization.event_finish_clock, upd_organization.event_finish_minute, "<cf_get_lang dictionary_id='54749.Ders Başlama Tarihi Bitiş Tarihinden önce olmalıdır'>!");
		}
		return true;
                                
	}
	function kontrol()
	{
		if(!$("#start_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='57501.Zorunlu Alan'>:<cf_get_lang dictionary_id ='58053.başlangıç tarihi'></cfoutput>"}) 
			return false;
		}
		if(!$("#finish_date").val().length)
		{
			alertObject({message: "<cfoutput><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.bitis tarihi'></cfoutput>"}) 
			return false;
		}
		if(document.getElementById('organization_announcement').value.length > 1500)
		{
			alert("<cf_get_lang dictionary_id='54754.Etkinlik Duyurusu Karakter Sayısı Maksimum'>: 1500 !");
			return false;
		}
		if(document.getElementById('organization_target').value.length > 4000)
		{
			alert("<cf_get_lang dictionary_id='52642.Etkinlik İçeriğinin Karakter sayısı 4000 den fazla olamaz'>!");
			return false;
		}
		if(document.getElementById("organization_cat_id").value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57486.Kategori'>");
			return false;
		}
		if(document.getElementById("emp_par_name").value == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='49714.Etkinlik Yetkilisi'>");
			return false;
		}
		<cfif xml_project_required eq 1>
			if(document.getElementById("project_id").value == "" || document.getElementById("project_head").value == "")
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57416.Proje'>");
				return false;
			}
		</cfif>		
		return check();
		
	}
	
	function view_control(type)
	{
		if(type==1)
		{
			document.upd_organization.is_view_branch.checked=false;
			document.upd_organization.is_view_department.checked=false;
		}
		if(type==2)
		{
			document.upd_organization.view_to_all.checked=false;
			document.upd_organization.is_view_department.checked=false;
		}
		if(type==3)
		{
			document.upd_organization.view_to_all.checked=false;
			document.upd_organization.is_view_branch.checked=false;
		}
	}
</script>

<script type="text/javascript">
	//BURASI "OLAY TAKVİMİ" İLE İLGİLİ
	try{ // Eğer ilk satır hata verirse ki olay takviminden gelirse hata vermez. o zaman çalışmaz
		var scheduler = window.opener.scheduler;
		var d1 = document.getElementById('start_date').value.split('/');
		var d2 = document.getElementById('finish_date').value.split('/');
		
		var tmpobj = scheduler.getEvent(scheduler.pre_obj.id);
		
		tmpobj.text = document.getElementById('organization_head').value;
			
		start_clock = document.getElementById('event_start_clock').value;
		start_minute = document.getElementById('event_start_minute').value;
		tmpobj.start_date = d1[0]+'-'+d1[1]+'-'+d1[2]+' '+start_clock+':'+start_minute;
		
		finish_clock = document.getElementById('event_finish_clock').value;
		finish_minute = document.getElementById('event_finish_minute').value;
		tmpobj.end_date = d2[0]+'-'+d2[1]+'-'+d2[2]+' '+finish_clock+':'+finish_minute;	
		
		scheduler.addEvent(tmpobj);
	}catch(err){}
</script>
