<cf_xml_page_edit fuseact="member.consumer_list">
	<cfparam name="attributes.period_id" default="">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.search_potential" default="">
	<cfparam name="attributes.search_status" default=1>
	<cfparam name="attributes.related_status" default="">
	<cfparam name="attributes.sales_county" default="">
	<cfparam name="attributes.pos_code_text" default="">
	<cfparam name="attributes.pos_code" default="">
	<cfparam name="attributes.county_id" default="">
	<cfparam name="attributes.city_id" default="">
	<cfparam name="attributes.country_id" default="">
	<cfparam name="attributes.member_branch" default="">
	<cfparam name="attributes.mem_code" default="">
	<cfparam name="attributes.customer_value" default="">
	<cfparam name="attributes.tc_identy" default="">
	<cfparam name="attributes.card_no" default="">
	<cfparam name="attributes.ref_pos_code" default="">
	<cfparam name="attributes.ref_pos_code_name" default="">
	<cfparam name="attributes.record_emp" default="">
	<cfparam name="attributes.record_name" default="">
	<cfparam name="attributes.cons_cat" default="">
	<cfparam name="attributes.use_efatura" default="">
	<cfparam name="attributes.user_type" default="">
	
	<cfinclude template="../../../../V16/member/query/get_consumer_value.cfm">
	<cfinclude template="../../../../V16/member/query/get_consumer_cat.cfm">
	<cfinclude template="../../../../V16/member/query/get_resource.cfm">
	<cfinclude template="../../../../V16/member/query/get_customer.cfm">
	<cfif get_consumer_cat.recordcount>
		<cfset list_cons_cat_id = valuelist(get_consumer_cat.conscat_id,',')>
	<cfelse>
		<cfset list_cons_cat_id = 0>
	</cfif>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
	</cfquery>
	
	<cfquery name="GET_CONSUMER_STAGE" datasource="#DSN#">
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
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.consumer_list%">
		ORDER BY
			PTR.LINE_NUMBER
	</cfquery>
	<cfquery name="GET_BRANCH_ALL" datasource="#DSN#">
		SELECT 
			OUR_COMPANY.NICK_NAME, 
			BRANCH.BRANCH_NAME,
			BRANCH.BRANCH_ID,
			BRANCH.COMPANY_ID
		FROM 
			BRANCH, 
			OUR_COMPANY,
			EMPLOYEE_POSITION_BRANCHES
		WHERE
			EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
			EMPLOYEE_POSITION_BRANCHES.BRANCH_ID = BRANCH.BRANCH_ID AND
			EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID IS NULL AND  
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		ORDER BY 
			OUR_COMPANY.COMPANY_NAME,	
			BRANCH.BRANCH_NAME
	</cfquery>
	<cfquery name="GET_PERIOD" datasource="#DSN#">
		SELECT
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			SETUP_PERIOD.PERIOD_ID,
			SETUP_PERIOD.PERIOD
		FROM
			SETUP_PERIOD,
			OUR_COMPANY,
			EMPLOYEE_POSITION_PERIODS EPP
		WHERE 
			EPP.PERIOD_ID = SETUP_PERIOD.PERIOD_ID AND
			EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1) AND
			SETUP_PERIOD.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
		ORDER BY 
			OUR_COMPANY.COMPANY_NAME,
			SETUP_PERIOD.PERIOD_YEAR
	</cfquery>
	<cfquery name="GET_COMP" dbtype="query">
		SELECT DISTINCT COMP_ID,COMPANY_NAME FROM GET_PERIOD ORDER BY COMPANY_NAME
	</cfquery>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
	<cfif isdefined("attributes.form_submitted")>
		<cfquery name="GET_OURCMP_INFO" datasource="#DSN#">
			SELECT IS_STORE_FOLLOWUP FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfscript>
					get_consumer_list_action = CreateObject("component","wbp.retail.files.cfc.get_consumer");
				get_consumer_list_action.dsn = dsn;
				get_cons_ct = get_consumer_list_action.get_consumer_list_fnc(
					is_resource_id : '#iif(isdefined("is_resource_id"),"is_resource_id",DE(""))#' ,
					is_record_member :'#iif(isdefined("is_record_member"),"is_record_member",DE(""))#' ,
					is_customer_value : '#iif(isdefined("is_customer_value"),"is_customer_value",DE(""))#' ,
					is_ref_pos_code: '#iif(isdefined("is_ref_pos_code"),"is_ref_pos_code",DE(""))#' ,
					list_cons_cat_id: '#iif(isdefined("list_cons_cat_id"),"list_cons_cat_id",DE(""))#' ,
					period_id: '#iif(isdefined("attributes.period_id"),"attributes.period_id",DE(""))#' ,
					module_name : fusebox.circuit ,
					is_store_followup: '#iif(isdefined("get_ourcmp_info.is_store_followup"),"get_ourcmp_info.is_store_followup",DE(""))#' ,
					member_branch: '#iif(isdefined("attributes.member_branch"),"attributes.member_branch",DE(""))#' ,
					ref_pos_code: '#iif(isdefined("attributes.ref_pos_code"),"attributes.ref_pos_code",DE(""))#' ,
					record_emp: '#iif(isdefined("attributes.record_emp"),"attributes.record_emp",DE(""))#' ,
					customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
					resource: '#iif(isdefined("attributes.resource"),"attributes.resource",DE(""))#' ,
					process_stage_type: '#iif(isdefined("attributes.process_stage_type"),"attributes.process_stage_type",DE(""))#' ,
					search_potential: '#iif(isdefined("attributes.search_potential"),"attributes.search_potential",DE(""))#' ,
					search_status: '#iif(isdefined("attributes.search_status"),"attributes.search_status",DE(""))#' ,
					related_status: '#iif(isdefined("attributes.related_status"),"attributes.related_status",DE(""))#' ,
					cons_cat: '#iif(isdefined("attributes.cons_cat"),"attributes.cons_cat",DE(""))#' ,
					keyword: '#iif(isdefined("attributes.keyword"),"attributes.keyword",DE(""))#' ,
					database_type: database_type ,
					sales_county: '#iif(isdefined("attributes.sales_county"),"attributes.sales_county",DE(""))#' ,
					pos_code: '#iif(isdefined("attributes.pos_code"),"attributes.pos_code",DE(""))#' ,
					pos_code_text: '#iif(isdefined("attributes.pos_code_text"),"attributes.pos_code_text",DE(""))#',
					country_id: '#iif(isdefined("attributes.country_id"),"attributes.country_id",DE(""))#' ,
					city_id: '#iif(isdefined("attributes.city_id"),"attributes.city_id",DE(""))#' ,
					county_id: '#iif(isdefined("attributes.county_id"),"attributes.county_id",DE(""))#' ,
					customer_value: '#iif(isdefined("attributes.customer_value"),"attributes.customer_value",DE(""))#' ,
					is_code_filter: '#iif(isdefined("is_code_filter"),"is_code_filter",DE(""))#' ,
					mem_code: '#iif(isdefined("attributes.mem_code"),"attributes.mem_code",DE(""))#' ,
					tc_identy: '#iif(isdefined("attributes.tc_identy"),"attributes.tc_identy",DE(""))#' ,
					card_no: '#iif(isdefined("attributes.card_no"),"attributes.card_no",DE(""))#' ,
					row_block : '#iif((session.ep.our_company_info.sales_zone_followup eq 1),"500",DE(""))#',
					blacklist_status : '#iif(isdefined("attributes.blacklist_status"),"attributes.blacklist_status",DE(""))#' ,
					order_type : '#iif(isdefined("attributes.order_type"),"attributes.order_type",DE(""))#',
					startrow : '#iif(isdefined("attributes.startrow"),"attributes.startrow",DE(""))#',
					maxrows :'#iif(isdefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
					use_efatura : '#iif(isdefined("attributes.use_efatura"),"attributes.use_efatura",DE(""))#',
					user_type : '#iif(isdefined("attributes.user_type"),"attributes.user_type",DE(""))#'
				);
		</cfscript>
	<cfelse>
		<cfset get_cons_ct.recordcount = 0>
	</cfif>
	<cfif get_cons_ct.recordcount>
		<cfparam name="attributes.totalrecords" default='#get_cons_ct.query_count#'>
	<cfelse>
		<cfparam name="attributes.totalrecords" default='0'>
	</cfif>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box>
			<cfform name="search" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.consumer_list">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<cf_box_search>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#" message="Geçerli " maxlength="50" style="width:100px;">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="mem_code" placeholder="#getLang('','Üye No',57558)#" value="#attributes.mem_code#" size="5" style="width:70px;" maxlength="50">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="card_no" placeholder="#getLang('','Kart No',30233)#" value="#attributes.card_no#" onKeyUp="isNumber(this);" maxlength="16" style="width:125px;">
						</div>
					</div>
					<div class="form-group">
						<div class="input-group">
							<cfinput type="text" name="tc_identy" placeholder="#getLang('','TC Kimlik No',58025)#" value="#attributes.tc_identy#" onKeyUp="isNumber(this);" maxlength="11" style="width:80px;">
						</div>
					</div>
					<div class="form-group">
						<select name="related_status" id="related_status">			
							<option value="" <cfif isDefined('attributes.related_status') and not len(attributes.related_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1" <cfif isDefined('attributes.related_status') and attributes.related_status is 1>selected</cfif>><cf_get_lang dictionary_id='30724.Bagli Üyeler'></option>
							<option value="0" <cfif isDefined('attributes.related_status') and attributes.related_status is 0>selected</cfif>><cf_get_lang dictionary_id='30264.Bagli Olmayan Üyeler'></option>
						</select>	
					</div>
					<div class="form-group">
						<select name="user_type" id="user_type">
							<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1" <cfif attributes.user_type eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='35282.Bireysel'></option>
							<option value="2" <cfif attributes.user_type eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id='31100.Kurumsal'></option>
						</select>
					</div>
					<div class="form-group">
						<select name="use_efatura" id="use_efatura">
							<option value=""><cf_get_lang dictionary_id="29872.E-Fatura"></option>
							<option value="1" <cfif attributes.use_efatura eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='29492.Kullanıyor'></option>
							<option value="0" <cfif attributes.use_efatura eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='29493.Kullanmıyor'></option>
						</select>
					</div>
					<div class="form-group">
						<select name="search_status" id="search_status">			
							<option value="" <cfif isDefined('attributes.search_status') and not len(attributes.search_status)>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
							<option value="1" <cfif isDefined('attributes.search_status') and attributes.search_status is 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
							<option value="0" <cfif isDefined('attributes.search_status') and attributes.search_status is 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						</select>
					</div>
					<div class="form-group">
						<div class="input-group small">
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj',57537)#" onKeyUp="isNumber(this);" maxlength="3" style="width:25px;">
						</div>
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
						<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
					</div>
					<div class="form-group">
						<a href="javascript://" class="ui-btn ui-btn-gray" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=retail.consumer_list&event=upd</cfoutput>');"><i class="fa fa-exchange" title="<cf_get_lang dictionary_id='61531.Kart Müşterisini Değiştir'>"></i></a>
					</div>
				</cf_box_search>
				<cf_box_search_detail>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group">
							<div class="input-group">
								<input type="hidden" name="record_emp" id="record_emp" value="<cfoutput>#attributes.record_emp#</cfoutput>">
								<input type="text" name="record_name" id="record_name" value="<cfoutput>#attributes.record_name#</cfoutput>" onfocus="AutoComplete_Create('record_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp','','3','125');" autocomplete="off" placeholder="<cfoutput>#getLang("","Kaydeden",57899)#</cfoutput>">    
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search.record_emp&field_name=search.record_name&select_list=1&branch_related','list','popup_list_positions')"></span>	
							</div>	
						</div>
						<div class="form-group">
							<select id="cons_cat" name="cons_cat">
								<option value=""><cf_get_lang dictionary_id='58609.Üye Kategorisi'></option>
								<cfoutput query="GET_CONSUMER_CAT">
									<option value="#conscat_id#" <cfif attributes.cons_cat eq conscat_id></cfif>>#conscat#</option> 
								</cfoutput>
							</select>
						</div>
						<div class="form-group">
							<select name="county_id" id="county_id">
								<option value=""><cf_get_lang dictionary_id='58638.Ilçe'></option>
								<cfif isdefined('attributes.city_id') and len(attributes.city_id)>
									<cfquery name="get_county" datasource="#DSN#">
										SELECT COUNTY_ID,COUNTY_NAME FROM SETUP_COUNTY WHERE CITY = #attributes.city_id# ORDER BY COUNTY_NAME
									</cfquery>
									<cfoutput query="get_county">
										<option value="#county_id#" <cfif attributes.county_id eq county_id>selected</cfif>>#county_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
						<div class="form-group">
							<label class="col col-6"><cf_get_lang dictionary_id='30649.Kara Liste Üyeleri'></label>
							<input type="checkbox" name="blacklist_status" id="blacklist_status" value="1" <cfif isdefined("attributes.blacklist_status")>checked</cfif>>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group">
							<div class=	"input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57908.Temsilci'></cfsavecontent>
								<input type="hidden" name="pos_code"  id="pos_code" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
								<input name="pos_code_text" type="text" id="pos_code_text" style="width:100px;" onfocus="AutoComplete_Create('pos_code_text','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135')" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#get_emp_info(attributes.pos_code,1,0)#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput>#getLang("","Temsilci",57908)#</cfoutput>">
								<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search.pos_code&field_name=search.pos_code_text<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');return false"><img src="/images/plus_thin.gif" align="absbottom"></span>
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<cfsavecontent  variable="message"><cf_get_lang dictionary_id='58636.Referans Üye'></cfsavecontent>
									<input type="hidden" name="ref_pos_code" id="ref_pos_code" value="<cfif len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)><cfoutput>#attributes.ref_pos_code#</cfoutput></cfif>">
									<input name="ref_pos_code_name" type="text" id="ref_pos_code_name" style="width:100px;" onfocus="AutoComplete_Create('ref_pos_code_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','2,0,0,0','CONSUMER_ID','ref_pos_code','search','3','250');" value="<cfif len(attributes.ref_pos_code) and len(attributes.ref_pos_code_name)><cfoutput>#get_cons_info(attributes.ref_pos_code,0,0)#</cfoutput></cfif>" autocomplete="off" placeholder="<cfoutput>#getLang("","Referans Üye",58636)#</cfoutput>">
									<span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_cons&field_id=search.ref_pos_code&field_name=search.ref_pos_code_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=3'</cfoutput>,'list','popup_list_cons')"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang dictionary_id='57734.seçiniz'>"></span>
							</div>
						</div>
						<div class="form-group">
							<select name="customer_value" id="customer_value">
								<option value=""><cf_get_lang dictionary_id='58552.Müsteri Degeri'></option>
								<cfoutput query="get_customer_value">
									<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group">
							<select name="order_type" id="order_type">
								<option value=""<cfif isdefined('attributes.order_type') and not len(attributes.order_type)>selected</cfif>><cf_get_lang dictionary_id ='30588.Siralama Sekli'></option>
								<option value="1"<cfif isdefined('attributes.order_type') and (attributes.order_type is 1)>selected</cfif>><cf_get_lang dictionary_id ='30589.Isme Göre'></option>
								<option value="2"<cfif isdefined('attributes.order_type') and (attributes.order_type is 2)>selected</cfif>><cf_get_lang dictionary_id ='30590.Referans Koduna Göre'></option>
								<option value="3"<cfif isdefined('attributes.order_type') and (attributes.order_type is 3)>selected</cfif>><cf_get_lang dictionary_id ='30591.Kayit Tarihine Göre'></option>
							</select>
						</div>
					</div>
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group">
							<select name="search_potential" id="search_potential">
								<option value=""  <cfif not len(attributes.search_potential)>selected</cfif>><cf_get_lang dictionary_id='57708.Tumu'></option>
								<option value="1" <cfif attributes.search_potential is 1>selected</cfif>><cf_get_lang dictionary_id='57577.Potansiyel'></option>
								<option value="0" <cfif attributes.search_potential is 0>selected</cfif>><cf_get_lang dictionary_id='58061.Cari'></option>	
							</select>
						</div>
						<div class="form-group">
							<cf_wrk_combo 
								name="resource"
								query_name="GET_PARTNER_RESOURCE"
								value="#iif(isDefined("attributes.resource"),'attributes.resource',DE(''))#"
								option_name="resource"
								option_value="resource_id">
						</div>
						<div class="form-group">
							<select name="process_stage_type" id="process_stage_type">
								<option value="" selected><cf_get_lang dictionary_id='57482.Asama'></option>
								<cfoutput query="get_consumer_stage">
									<option value="#process_row_id#" <cfif isDefined('attributes.process_stage_type') and attributes.process_stage_type eq process_row_id>selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group">
							<select name="member_branch" id="member_branch">
								<option value=""><cf_get_lang dictionary_id='57895.Sube Iliskisi'></option>
								<cfoutput query="get_branch_all">
									<option value="#branch_id#" <cfif attributes.member_branch eq branch_id>selected</cfif>>#branch_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					
					<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
						<div class="form-group">
							<select name="period_id" id="period_id">
								<option value=""><cf_get_lang dictionary_id ='58472.Dönem'></option>
								<cfset totalvalue = 0>
								<cfoutput query="get_comp">
									<cfset totalvalue = totalvalue + 1>
									<cfquery name="GET_PERIODID" dbtype="query">
										SELECT * FROM GET_PERIOD WHERE COMP_ID = #comp_id#
									</cfquery>
									<option value="#totalvalue#,0,#comp_id#,0" <cfif len(attributes.period_id) and  listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>#company_name#</option>
									<cfloop query="get_periodid">
										<cfset totalvalue = totalvalue + 1>
										<option value="#totalvalue#,1,#comp_id#,#period_id#" <cfif len(attributes.period_id) and listgetat(attributes.period_id,1,',') eq totalvalue>selected</cfif>>&nbsp;&nbsp;&nbsp;#period#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
						<div class="form-group">
							<select name="city_id" id="city_id" onchange="LoadCounty(this.value,'county_id');">
								<option value=""><cf_get_lang dictionary_id='57971.Sehir'></option>
								<cfif isdefined('attributes.country_id') and len(attributes.country_id)>
									<cfquery name="get_city" datasource="#dsn#">
										SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#"> ORDER BY CITY_NAME 
									</cfquery>
									<cfoutput query="get_city">
										<option value="#city_id#" <cfif attributes.city_id eq city_id>selected</cfif>>#city_name#</option>
									</cfoutput>
								</cfif>
							</select>
						</div>
						<div class="form-group">
							<cfsavecontent variable="text"><cf_get_lang dictionary_id='57659.Satis Bölgesi'></cfsavecontent>
								<cf_wrk_saleszone
								  name="sales_county"
								  option_text="#text#"
								  value="#attributes.sales_county#">
						</div>
					</div>
				</cf_box_search_detail>
			</cfform>
		</cf_box>
		<cf_box title="#getLang('','Müşteri Kartları',45845)#" uidrop="1" hide_table_column="1">
			<cf_grid_list>
				<thead>
					<tr> 
						<th width="30" nowrap="nowrap"><cf_get_lang dictionary_id='58577.Sıra'></th>
						<th><cf_get_lang dictionary_id='57558.Üye No'></th>
						<th><cf_get_lang dictionary_id='30233.Kart No'></th>
						<cfif isdefined('is_tc_identy_no') and is_tc_identy_no eq 1>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
						</cfif>
							<th nowrap="nowrap"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<cfif isdefined('is_birth_date') and is_birth_date eq 1>
							<th><cf_get_lang dictionary_id='58727.Dogum Tarihi'></th>
						</cfif>
						<th nowrap="nowrap"><cf_get_lang dictionary_id='31097.Üye Tipi'></th>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<th><cf_get_lang dictionary_id ='58859.Süreç'></th>
						<cfif isdefined('is_reference_code') and is_reference_code eq 1>
							<th nowrap="nowrap"><cf_get_lang dictionary_id ='30593.Referans Kod'></th>
						</cfif>
						<cfif isdefined('is_record_date') and is_record_date eq 1>
							<th><cf_get_lang dictionary_id ='57627.Kayit Tarihi'></th>
						</cfif>
						<cfif isdefined('is_record_member') and is_record_member eq 1>
							<th><cf_get_lang dictionary_id ='57899.Kaydeden'></th>
						</cfif>
						<!-- sil -->
						<th class="header_icn_text"><cf_get_lang dictionary_id='58143.Iletisim'></th>
						<th width="20" class="header_icn_text" nowrap="nowrap"><cf_get_lang dictionary_id='58984.Puan'></th>
						<th width="20" ><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=retail.consumer_list&event=upd</cfoutput>');"><i class="fa fa-exchange" title="<cf_get_lang dictionary_id='61531.Kart Müşterisini Değiştir'>"></i></a></th>
						<!-- sil -->
					</tr>
				</thead>
				
				<tbody>
					<cfif get_cons_ct.recordcount>
						<cfoutput query="get_cons_ct">
							<tr>
								<td width="30">#rownum#</td>
								<td>#member_code#</td>
								<td>#LAST_CARD_NO#</td>
								<cfif isdefined('is_tc_identy_no') and is_tc_identy_no eq 1>
									<td>#tc_identy_no#</td>
								</cfif>
									<td>
									<cfif type eq 1>
										<a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#consumer_name# #consumer_surname#</a>
									<cfelse>
										<a href="#request.self#?fuseaction=member.form_list_company&event=det&cpid=#consumer_id#" class="tableyazi">#consumer_name# #consumer_surname#</a>
									</cfif>
									</td>
								<cfif isdefined('is_birth_date') and is_birth_date eq 1>
									<td>#dateformat(birthdate,'dd/mm/yyyy')#</td>
								</cfif>
									<td><cfif type eq 1><cf_get_lang dictionary_id='57586.Bireysel Üye'><cfelse><cf_get_lang dictionary_id='49909.Kurumsal Üye'></cfif></td>
									<td>#conscat#</td>
									<td>#stage#</td>
								<cfif isdefined('is_reference_code') and is_reference_code eq 1>
									<td>#consumer_reference_code#</td>
								</cfif>
									<cfif isdefined('is_record_date') and is_record_date eq 1>
										<td><cfif len(record_date)>#dateformat(dateadd('h',session.ep.time_zone,record_date),'dd/mm/yyyy')# #timeformat(dateadd('h',session.ep.time_zone,record_date),'HH:MM')#</cfif></td>
									</cfif>
								<cfif isdefined('is_record_member') and is_record_member eq 1>
									<td>#record_emp#</td>
								</cfif>
								<!-- sil -->
								<td width="40" style="text-align:center;" nowrap="nowrap">
									<ul class="ui-icon-list">
										<li><cfif len(consumer_email)><a href="mailto:#consumer_email#"><i class="fa fa-envelope" title="<cf_get_lang dictionary_id='32508.E-mail'>:#consumer_email#"></i></a></cfif></li>
										<li><cfif len(consumer_worktel)>&nbsp;<i class="fa fa-phone"  title="<cf_get_lang dictionary_id='30382.Kod/Is Telefonu'>:#consumer_worktelcode# - #consumer_worktel#"></i></cfif></li>
										<li><cfif len(consumer_fax)>&nbsp;<i class="fa fa-fax"  title="<cf_get_lang dictionary_id='57488.Fax'>:#consumer_faxcode# - #consumer_fax#"></i></cfif></li>
										<li><cfif len(mobiltel) and session.ep.our_company_info.sms eq 1><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_send_sms&member_type=consumer&member_id=#CONSUMER_ID#&sms_action=#fuseaction#','small','popup_form_send_sms');"><i class="fa fa-mobile-phone" title="<cf_get_lang dictionary_id ='58590 .SMS Gönder'><cf_get_lang dictionary_id ='58473.Mobil'>:#MOBIL_CODE# - #mobiltel#"></i></a></cfif></li>
									</ul>
								</td>
								<td width="20" style="text-align:center;" nowrap="nowrap">
									<cfif type eq 1>
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=retail.popup_add_bonus&consumer_id=#consumer_id#');"><i class="fa fa-money" title="<cf_get_lang dictionary_id='61530.Puan Bilgileri'>"></i></a>
									<cfelse>
										<a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=retail.popup_add_bonus&company_id=#consumer_id#');"><i class="fa fa-money" title="<cf_get_lang dictionary_id='61530.Puan Bilgileri'>"></i></a>
									</cfif>
								</td>
								<td width="20" style="text-align:center;" nowrap="nowrap">
									<a href="javascript://" onclick="openBoxDraggable('index.cfm?fuseaction=member.popup_detail_customer_cards&card_id=18&<cfif type eq 1>type=1<cfelse>type=2</cfif>');"><i class="fa fa-pencil" title=""></i></a>
								</td>
							<!-- sil -->
							</tr>
						</cfoutput> 
					<cfelse>
						<tr>
							<cfset colspan = 12>
							<cfif isdefined('is_ozel_code') and is_ozel_code eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_tc_identy_no') and is_tc_identy_no eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_birth_date') and is_birth_date eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_resource_id') and is_resource_id eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_customer_value') and is_customer_value eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_ref_pos_code') and is_ref_pos_code eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_reference_code') and is_reference_code eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_record_date') and is_record_date eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
							<cfif isdefined('is_record_member') and is_record_member eq 1>
								<cfset colspan = colspan + 1>
							</cfif>
								<td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='58486.Kayit Bulunamadi'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cf_box>
	</div>
	
	
	<cfset adres = attributes.fuseaction>
	<cfset adres = adres&"&search_status="&attributes.search_status>
	<cfset adres = adres&"&related_status="&attributes.related_status>
	<cfset adres = adres&"&search_potential="&attributes.search_potential>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)><cfset adres = adres&"&keyword="&attributes.keyword></cfif>
	<cfif isDefined('attributes.cons_cat') and len(attributes.cons_cat)><cfset adres = adres&"&cons_cat="&attributes.cons_cat></cfif>
	<cfif isDefined('attributes.sales_county') and len(attributes.sales_county)><cfset adres = adres&"&sales_county="&attributes.sales_county></cfif>
	<cfif isDefined('attributes.pos_code') and len(attributes.pos_code)><cfset adres = adres&"&pos_code="&attributes.pos_code></cfif>
	<cfif isdefined('attributes.pos_code_text') and len(attributes.pos_code_text)><cfset adres = adres&"&pos_code_text="&attributes.pos_code_text></cfif>
	<cfif isDefined('attributes.ref_pos_code') and len(attributes.ref_pos_code)><cfset adres = adres&"&ref_pos_code="&attributes.ref_pos_code></cfif>
	<cfif isdefined('attributes.ref_pos_code_name') and len(attributes.ref_pos_code_name)><cfset adres = adres&"&ref_pos_code_name="&attributes.ref_pos_code_name></cfif>
	<cfif isDefined("attributes.country_id") and len(attributes.country_id)><cfset adres = adres&"&country_id="&attributes.country_id></cfif>
	<cfif isDefined("attributes.city_id") and len(attributes.city_id)><cfset adres = adres&"&city_id="&attributes.city_id></cfif>
	<cfif isDefined("attributes.county_id") and len(attributes.county_id)><cfset adres = adres&"&county_id="&attributes.county_id></cfif>
	<cfif isDefined('attributes.mem_code') and len(attributes.mem_code)><cfset adres = adres&"&mem_code="&attributes.mem_code></cfif>
	<cfif isdefined("attributes.order_type") and len(attributes.order_type)><cfset adres = adres&"&order_type="&attributes.order_type></cfif>
	<cfif isDefined('attributes.tc_identy') and len(attributes.tc_identy)><cfset adres = adres&"&tc_identy="&attributes.tc_identy></cfif>
	<cfif isDefined('attributes.card_no') and len(attributes.card_no)><cfset adres = adres&"&card_no="&attributes.card_no></cfif>
	<cfif isDefined('attributes.customer_value') and len(attributes.customer_value)><cfset adres = adres&"&customer_value="&attributes.customer_value></cfif>
	<cfif isdefined("attributes.process_stage_type") and len(attributes.process_stage_type)><cfset adres = adres&"&process_stage_type="&attributes.process_stage_type></cfif>
	<cfif isdefined("attributes.blacklist_status") and len(attributes.blacklist_status)><cfset adres = adres&"&blacklist_status="&attributes.blacklist_status></cfif>
	<cfif isdefined("attributes.resource") and len(attributes.resource)><cfset adres = adres&"&resource="&attributes.resource></cfif>
	<cfif isDefined("attributes.record_emp") and len(attributes.record_emp)><cfset adres = adres&"&record_emp="&attributes.record_emp></cfif>
	<cfif isDefined("attributes.record_name") and len(attributes.record_name)><cfset adres = adres&"&record_name="&attributes.record_name></cfif>
	<cfif isDefined("attributes.user_type") and len(attributes.user_type)><cfset adres = adres&"&user_type="&attributes.user_type></cfif>
	<cfif isdefined('form_submitted')><cfset adres = adres&"&form_submitted=1"></cfif>
	<cf_paging 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#" 
		adres="#adres#">
	<script type="text/javascript">
		document.getElementById('card_no').focus();
	</script>