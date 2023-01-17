<cf_xml_page_edit fuseact="objects.popup_list_multiuser_company">
<cfparam name="attributes.is_submitted" default="">
<cfparam name="attributes.hedefkodu" default="">
<cfparam name="attributes.fullname" default="">
<cfparam name="attributes.cp_name" default="">
<cfparam name="attributes.ims_code_id" default="">
<cfparam name="attributes.ims_code_name" default="">
<cfparam name="attributes.ekip" default="">
<cfparam name="attributes.vergi_no" default="">
<cfparam name="attributes.customer_type" default="">
<cfparam name="attributes.customer_type_id" default="">
<cfparam name="attributes.city" default="">
<cfparam name="attributes.citycode" default="">
<cfparam name="attributes.county" default="">
<cfparam name="attributes.county_id" default="">
<cfparam name="attributes.branch_state" default="3">
<cfparam name="attributes.pro_rows" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.carihesapkod" default="">
<cfparam name="attributes.companycat" default="">
<cfparam name="attributes.company_sector" default="">
<cfparam name="attributes.customer_value" default="">
<cfparam name="attributes.sales_county" default="">
<cfparam name="attributes.tc_kimlik_no" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="select_list" default="7,8">
<cfparam name="is_close" default="1">
<cfif isdefined('session.ep.userid')>
	<cfparam name="attributes.period_id" default="0;#session.ep.company_id#;#session.ep.period_id#">
<cfelseif isdefined('session.pp.our_company_id')>
	<cfparam name="attributes.period_id" default="1;#session.pp.our_company_id#;#session.pp.our_company_id#">
</cfif>
<cfif fusebox.use_period>
	<!--- FBS Yeniden Duzenlendi, bireysel-kurumsal popup gecislerinde kopukluk oluyor ve bazi durumlarda yanlis calisiyordu --->
	<cfquery name="get_period" datasource="#dsn#">
		SELECT
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			SP.PERIOD_ID,
			SP.PERIOD
		FROM
			SETUP_PERIOD SP WITH (NOLOCK),
			OUR_COMPANY WITH (NOLOCK),
			EMPLOYEE_POSITION_PERIODS EPP WITH (NOLOCK)
		WHERE 
			EPP.PERIOD_ID = SP.PERIOD_ID AND
			<cfif isdefined('session.ep.userid')>
				EPP.POSITION_ID = (SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> AND IS_MASTER = 1) AND
			</cfif>
			SP.OUR_COMPANY_ID = OUR_COMPANY.COMP_ID 
		ORDER BY 
			OUR_COMPANY.COMP_ID,
			OUR_COMPANY.COMPANY_NAME,
			SP.PERIOD_YEAR
	</cfquery>
	<cfset period_id_list = listsort(listdeleteduplicates(valueList(get_period.period_id,',')),'numeric','ASC',',')>
</cfif>
<cfif not len(attributes.customer_type)>
	<cfset attributes.customer_type_id = "">
</cfif>
<cfif len(attributes.customer_type_id)>
	<cfset cust_type_ = "">
	<cfloop from="1" to="#listlen(attributes.customer_type_id)#" index="i">
		<cfset cust_type_ = listappend(cust_type_, listgetat(attributes.customer_type_id, i, ','), ',')>
	</cfloop>
	<cfset attributes.customer_type_id = cust_type_>
</cfif>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID, CITY_NAME, PHONE_CODE, PLATE_CODE FROM SETUP_CITY ORDER BY CITY_NAME
</cfquery>
<cfquery name="GET_CUSTOM_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT_ID
</cfquery>
<cfquery name="GET_ZONE" datasource="#DSN#">
	SELECT ZONE_ID,ZONE_NAME FROM ZONE ORDER BY ZONE_NAME
</cfquery>
<cfquery name="GET_BRANCH_STATUS" datasource="#DSN#">
	SELECT TR_ID, TR_NAME FROM SETUP_MEMBERSHIP_STAGES ORDER BY TR_NAME
</cfquery>
<cfquery name="GET_PRO_TYPEROWS" datasource="#DSN#">
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
		<cfif not isdefined("attributes.is_sales")>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%crm.form_add_company%">
		<cfelse>
			PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%member.form_add_company%">
		</cfif>
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# ) ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="SZ" datasource="#DSN#">
	SELECT SZ_ID,SZ_NAME FROM SALES_ZONES ORDER BY SZ_NAME
</cfquery>
<cfquery name="GET_COMPANYCAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CUSTOMER_VALUE" datasource="#DSN#">
	SELECT CUSTOMER_VALUE_ID, CUSTOMER_VALUE  FROM SETUP_CUSTOMER_VALUE ORDER BY CUSTOMER_VALUE
</cfquery>
<cfquery name="GET_COMPANY_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT_ID,SECTOR_CAT FROM SETUP_SECTOR_CATS ORDER BY SECTOR_CAT
</cfquery>
<cfif len(attributes.is_submitted) or (isdefined("attributes.keyword") and len(attributes.keyword))>
	<cfinclude template="../query/get_companies_crm.cfm">
<cfelse>
	<cfset get_company.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name='attributes.totalrecords' default='#get_company.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfscript>
	url_str = "";
	if (isdefined("attributes.record_num_") and len(attributes.record_num_))
	url_str = "#url_str#&record_num_=#attributes.record_num_#";
	if (isdefined("attributes.is_activity") and len(attributes.is_activity))
	url_str = "#url_str#&is_activity=#attributes.is_activity#";
	if (isdefined("attributes.startdate") and len(attributes.startdate))
	url_str = "#url_str#&startdate=#attributes.startdate#";
	if (isdefined("attributes.kontrol_startdate") and len(attributes.kontrol_startdate))
	url_str = "#url_str#&kontrol_startdate=#attributes.kontrol_startdate#";
	if (isdefined("attributes.kontrol_finishdate") and len(attributes.kontrol_finishdate))
	url_str = "#url_str#&kontrol_finishdate=#attributes.kontrol_finishdate#";
	if (isdefined("attributes.is_single") and len(attributes.is_single))
	url_str = "#url_str#&is_single=#attributes.is_single#";
	if (isdefined("attributes.field_comp_id") and len(attributes.field_comp_id))
	url_str = "#url_str#&field_comp_id=#attributes.field_comp_id#";
	if (isdefined("attributes.field_comp_name") and len(attributes.field_comp_name))
	url_str = "#url_str#&field_comp_name=#attributes.field_comp_name#";
	if (isdefined("attributes.field_id") and len(attributes.field_id))
	url_str = "#url_str#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_name") and len(attributes.field_name))
	url_str = "#url_str#&field_name=#attributes.field_name#";
	if (isdefined("attributes.is_sales") and len(attributes.is_sales))
	url_str = "#url_str#&is_sales=#attributes.is_sales#";
	if (isdefined("attributes.is_active") and len(attributes.is_active))
	url_str = "#url_str#&is_active=#attributes.is_active#";
	if (isdefined("attributes.is_close") and len(attributes.is_close))
	url_str = "#url_str#&is_close=#attributes.is_close#";
	if(isdefined("attributes.is_choose_project") and len(attributes.is_choose_project))
	url_str = "#url_str#&is_choose_project=#attributes.is_choose_project#";
	if (isdefined("attributes.companycat")) url_str = "#url_str#&companycat=#attributes.companycat#";
	if (isdefined("attributes.company_sector")) url_str = "#url_str#&company_sector=#attributes.company_sector#";
	if (isdefined("attributes.customer_value")) url_str = "#url_str#&customer_value=#attributes.customer_value#";
	if (isdefined("attributes.sales_county")) url_str = "#url_str#&sales_county=#attributes.sales_county#";
	if (isdefined("attributes.period_id")) url_str = "#url_str#&period_id=#attributes.period_id#";
</cfscript>
<cfsavecontent variable="head_">
	<div class="ui-form-list flex-list">
		<div class="form-group">
			<cfoutput>
				<cfif isdefined("attributes.is_sales")>
					<cfoutput>
						<select name="categories" id="categories" onChange="<cfif isdefined("attributes.draggable")>openBoxDraggable(this.value,#attributes.modal_id#);<cfelse>location.href=this.value;</cfif>">
							<cfif listcontainsnocase(select_list,7)>
								<option value="#request.self#?fuseaction=objects.popup_list_multiuser_company#url_str#" <cfif fusebox.fuseaction is "popup_list_all_pars"> selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></option>
							</cfif>
							<cfif listcontainsnocase(select_list,8)>
								<option value="#request.self#?fuseaction=objects.popup_list_multiuser_consumer#url_str#"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></option>
							</cfif>
						</select>
					</cfoutput>
				<cfelse>
					<cf_get_lang dictionary_id='33182.Müşteri Ara'>
				</cfif>
			</cfoutput>
		</div>
	</div>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Kurumsal Üyeler',29408)#" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_str" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search_company" method="post" action="#request.self#?fuseaction=objects.popup_list_multiuser_company">
			<cfoutput>
				<cfif isdefined("attributes.record_num_")><input type="hidden" name="record_num_" id="record_num_" value="#attributes.record_num_#"></cfif>
				<cfif isdefined("attributes.is_activity")><input type="hidden" name="is_activity" id="is_activity" value="#attributes.is_activity#"></cfif>
				<cfif isdefined("attributes.is_single")><input type="hidden" name="is_single" id="is_single" value="#attributes.is_single#"></cfif>
				<cfif isdefined("attributes.field_comp_id")><input type="hidden" name="field_comp_id" id="field_comp_id" value="#attributes.field_comp_id#"></cfif>
				<cfif isdefined("attributes.field_comp_name")><input type="hidden" name="field_comp_name" id="field_comp_name" value="#attributes.field_comp_name#"></cfif>
				<cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="#attributes.field_id#"></cfif>
				<cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="#attributes.field_name#"></cfif>
				<cfif isdefined("attributes.is_sales")><input type="hidden" name="is_sales" id="is_sales" value="#attributes.is_sales#"></cfif>
				<cfif isdefined("attributes.is_close")><input type="hidden" name="is_close" id="is_close" value="#attributes.is_close#"></cfif>
				<cfif isdefined("attributes.is_position")><input type="hidden" name="is_position" id="is_position" value="#attributes.is_position#"></cfif>
				<cfif isdefined("attributes.startdate")><input type="hidden" name="startdate" id="startdate" value="#attributes.startdate#"></cfif>
				<cfif isdefined("attributes.is_choose_project")><input type="hidden" name="is_choose_project" id="is_choose_project" value="#attributes.is_choose_project#"></cfif>
				<input type="hidden" name="kontrol_startdate" id="kontrol_startdate" value="<cfif isdefined("attributes.kontrol_startdate")>#attributes.kontrol_startdate#</cfif>">
				<input type="hidden" name="kontrol_finishdate" id="kontrol_finishdate" value="<cfif isdefined("attributes.kontrol_finishdate")>#attributes.kontrol_finishdate#</cfif>">
				<input type="hidden" name="click_count" id="click_count" value="0">
				<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			</cfoutput>
			<cf_box_search>
				<div class="form-group" id="fullname">
					<cfinput type="text" name="fullname" id="fullname" style="width:50px;" placeholder="#getLang('','İşyeri Adı',57750)#" value="#attributes.keyword#" maxlength="255">
				</div>         
				<div class="form-group" id="cp_name">
					<cfinput type="text" name="cp_name" value="#attributes.cp_name#" placeholder="#getLang('','Ad Soyad',57570)#" maxlength="255" style="width:50px;">
				</div>            
				<cfif not isdefined("attributes.is_sales")>
					<div class="form-group" id="cp_name">
						<cfinput type="text" name="vergi_no" id="vergi_no" style="width:75px"  placeholder="#getLang('','Vergi no',57752)#" value="#attributes.vergi_no#">
					</div>
					<div class="form-group" id="customer_type">
						<div class="input-group">
							<cfif len(attributes.customer_type_id)>
								<cfquery name="GET_CUSTCAT" datasource="#DSN#">
									SELECT COMPANYCAT_ID, COMPANYCAT FROM COMPANY_CAT WHERE COMPANYCAT_ID IN (#attributes.customer_type_id#)
								</cfquery>
								<input type="hidden" name="customer_type_id" id="customer_type_id" value="<cfoutput>#attributes.customer_type_id#</cfoutput>">
								<input type="text" name="customer_type" id="customer_type" placeholder="<cfoutput>#getLang('','Tam Sayı',58195)#</cfoutput>"  value="<cfoutput query="get_custcat">#companycat#,</cfoutput>" style="width:100px;">
							<cfelse>
								<input type="hidden" name="customer_type_id" id="customer_type_id" value="">
								<input type="text" name="customer_type" id="customer_type" value="" style="width:100px;">
							</cfif>
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_partner_cats_search&field_name=search_company.customer_type&field_id=search_company.customer_type_id&click_count=search_company.click_count&customer_type=1','small');"></span>
						</div>
					</div>    
					<div class="form-group" id="branch_state">
						<select name="branch_state" id="branch_state" style="width:80px;">
							<option value=""><cf_get_lang dictionary_id='57894.Statü'></option>
							<cfoutput query="get_branch_status">
								<option value="#tr_id#" <cfif attributes.branch_state eq tr_id> selected</cfif>>#tr_name#</option>
							</cfoutput>
						</select>
					</div> 
				<cfelse>
					<div class="form-group" id="company_sector">
						<select name="company_sector" id="company_sector" tabindex="25" style="width:70px;">
							<option value=""><cf_get_lang dictionary_id='51253.Sektör Seçiniz'></option>             
							<cfoutput query="get_company_sector">
								<option value="#sector_cat_id#" <cfif attributes.company_sector eq sector_cat_id> selected</cfif>>#sector_cat#</option>
							</cfoutput>
						</select>
					</div>  
					<div class="form-group" id="customer_value">
						<select name="customer_value" id="customer_value" style="width:95px;">
							<option value=""><cf_get_lang dictionary_id='58552.Müşteri Değeri'></option>
							<cfoutput query="get_customer_value">
								<option value="#customer_value_id#" <cfif customer_value_id eq attributes.customer_value> selected</cfif>>#customer_value#</option>
							</cfoutput>
						</select>
					</div>   
				</cfif>
				<div class="form-group" id="is_active">
					<select name="is_active" id="is_active" style="width:50px;">
						<option value="0" <cfif attributes.is_active eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
						<option value="1" <cfif attributes.is_active eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
					</select>
				</div>   
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("hepsini_sec() && loadPopupBox('search_company' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<div class="form-group">
					<cfif not isdefined("attributes.is_crm_module")>
						<cfif isDefined('session.ep.userid') and (get_module_user(4) or get_module_user(32))>
							<a class="ui-btn ui-btn-gray" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=member.form_list_company&event=openPopup#url_str#&isPopup=1</cfoutput>','wide','popup_form_add_company');"><i class="fa fa-plus"></i></a>
						</cfif>
					</cfif>
				</div>
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_company' , #attributes.modal_id#)"),DE(""))#">
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif fusebox.use_period>
						<div class="form-group" id="period_id">
							<select name="period_id" id="period_id" style="width:175px;" tabindex="4">
								<option value=""><cf_get_lang dictionary_id ='58472.Dönem'></option>
								<cfoutput query="get_period" group="comp_id">
									<option value="0;#comp_id#;#period_id#" <cfif isDefined("attributes.period_id") and Len(attributes.period_id) and attributes.period_id eq '0;#comp_id#;#period_id#'>selected</cfif>>#Company_Name#</option>
									<cfoutput>
									<option value="1;#comp_id#;#period_id#" <cfif isDefined("attributes.period_id") and Len(attributes.period_id) and attributes.period_id eq '1;#comp_id#;#period_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;#Period#</option>
									</cfoutput>
								</cfoutput>
							</select>
						</div>   
					</cfif>
					<cfif not isdefined("attributes.is_sales")>
						<div class="form-group" id="hedefkodu">
							<cfinput type="text" name="hedefkodu" id="hedefkodu" placeholder="#getLang('','Hedef Kodu',33823)#" value="#attributes.hedefkodu#" onKeyUp="isNumber(this);" style="width:60px;">
						</div>    
						<div class="form-group" id="carihesapkod">
							<input type="text" name="carihesapkod" id="carihesapkod" maxlength="10" placeholder="<cfoutput>#getLang('','Cari Hesap Kodu',34241)#</cfoutput>" value="<cfoutput>#attributes.carihesapkod#</cfoutput>" style="width:70px;">
						</div>   
					</cfif>
					<div class="form-group" id="city">
						<select name="city" id="city" onChange="county_id_clear()" style="width:110px;">
							<option value=""><cf_get_lang dictionary_id='33176.İl Seçiniz'></option>
							<cfoutput query="get_city">
								<option value="#city_id#" <cfif city_id eq attributes.city> selected</cfif>>#city_name#</option>
							</cfoutput>
						</select>
					</div> 
				</div> 
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="county_id">
						<div class="input-group">      
							<input type="hidden" name="county_id" id="county_id" readonly=""  value=<cfoutput>"#attributes.county_id#"</cfoutput>>
							<cfinput type="text" name="county" id="county" placeholder="#getLang('','İlçe',58638)#" value="#attributes.county#" maxlength="30" style="width:100px;">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac2();"></span>
						</div>
					</div>   
					<div class="form-group" id="pro_rows">
						<select name="pro_rows" id="pro_rows" style="width:130px;">
							<option value=""><cf_get_lang dictionary_id='52009.Süreç Aşaması'></option>
							<cfoutput query="get_pro_typerows">
								<option value="#process_row_id#" <cfif attributes.pro_rows eq process_row_id> selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group" id="ims_code_id">
						<div class="input-group">
							<input type="hidden" name="ims_code_id" id="ims_code_id"   value="<cfoutput>#attributes.ims_code_id#</cfoutput>">
							<cfinput type="text" name="ims_code_name" id="ims_code_name" placeholder="#getLang('','Mikro Bölge Kodu',58134)#" value="#attributes.ims_code_name#" style="width:100px;">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="pencere_ac();"></span>
						</div>
					</div>  
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif not isdefined("attributes.is_sales")>
						<div class="form-group" id="tc_kimlik_no">
							<input type="text" name="tc_kimlik_no" id="tc_kimlik_no" placeholder="<cfoutput>#getLang('','TC Kimlik No',58025)#</cfoutput>" value="<cfoutput>#attributes.tc_kimlik_no#</cfoutput>">
						</div> 
						<div class="form-group" id="branch_id">
							<select name="branch_id" id="branch_id" style="width:250px;">
								<option value=""><cf_get_lang dictionary_id='29434.Şubeler'></option>
								<cfoutput query="get_branch">
									<option value="#branch_id#" <cfif branch_id eq attributes.branch_id> selected</cfif>>#branch_name#</option>
								</cfoutput>
							</select>
						</div>  
					<cfelse>
						<div class="form-group" id="pos_code">
							<div class="input-group">
								<input type="hidden" name="pos_code" id="pos_code"  value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code#</cfoutput></cfif>">
								<input type="text" name="pos_code_text" id="pos_code_text" placeholder="<cfoutput>#getLang('','Temsilci',57908)#</cfoutput>" value="<cfif len(attributes.pos_code_text) and len(attributes.pos_code)><cfoutput>#attributes.pos_code_text#</cfoutput></cfif>" style="width:100px;">
								<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_company.pos_code&field_name=search_company.pos_code_text<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1');return false"></span>
							</div>
						</div>   	  
						<div class="form-group" id="companycat">
							<select name="companycat" id="companycat" style="width:120px;" tabindex="23">
								<option value=""><cf_get_lang dictionary_id='57486.Kategori'></option>
								<cfoutput query="get_companycat">
									<option value="#companycat_id#" <cfif attributes.companycat eq companycat_id> selected</cfif>>#companycat#</option>
								</cfoutput>
							</select>
						</div>  
						<div class="form-group" id="sales_county">
							<select name="sales_county" id="sales_county" style="width:120px;" tabindex="27">
								<option value=""><cf_get_lang dictionary_id='57659.Satis Bölgesi'></option>
								<cfoutput query="sz">
									<option value="#sz_id#" <cfif sz_id eq attributes.sales_county> selected</cfif>>#sz_name#</option>
								</cfoutput>
							</select>
						</div>   
					</cfif>
				</div>
			</cf_box_search_detail>
		</cfform>
		<tbody><cfoutput>#head_#</cfoutput></tbody>
		<cfform name="form_name" id="form_name" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_visit_row">
			<cf_grid_list>
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
						<th width="140"><cf_get_lang dictionary_id='57750.İşyeri Adı'></th>
						<th width="120"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
						<cfif xml_city_id eq 1>
							<th width="120"><cf_get_lang dictionary_id ='57971.Şehir'></th>
						</cfif>
						<cfif xml_county_id eq 1>
							<th width="120"><cf_get_lang dictionary_id ='58638.İlçe'></th>
						</cfif>
						<cfif xml_semt eq 1>
							<th width="120"><cf_get_lang dictionary_id ='58132.Semt'></th>
						</cfif>
						<cfif isdefined("attributes.is_sales")>
							<th width="100"><cf_get_lang dictionary_id='57486.Kategori'></th>
							<th><cf_get_lang dictionary_id='57571.Ünvan'></th>
							<th width="20" class="text-center"><i class="fa fa-bar-chart"></i></th>
						<cfelse>
							<th width="65"><cf_get_lang dictionary_id='57499.Telefon'></th>
							<th><cf_get_lang dictionary_id='57752.Vergi No'></th>
							<th><cf_get_lang dictionary_id='33823.Hedef Kodu'></th>
							<th width="55"><cf_get_lang dictionary_id='52400.IMS Kodu'></th>
							<th><cf_get_lang dictionary_id='58638.İlçe'></th>
							<th width="85"><cf_get_lang dictionary_id='58608.İl'></th>
							<th><cf_get_lang dictionary_id='57453.Şube'></th>
						</cfif>
						<cfif not isdefined("attributes.is_single")>
							<th width="20" class="text-center"><cfif attributes.totalrecords neq 0><input type="Checkbox" name="all" id="all" value="1" onClick="javascript: hepsi();"></cfif></th>
						</cfif>
					</tr>
				</thead>
				<cfif get_company.recordcount>
					<tbody>
						<cfoutput>
							<cfif isdefined("attributes.is_close")><input type="hidden" name="is_close" id="is_close" value="#attributes.is_close#"></cfif>
							<cfif isdefined("attributes.is_sales")><input type="hidden" name="is_sales" id="is_sales" value="#attributes.is_sales#"></cfif>
							<cfif isdefined("attributes.is_single")><input type="hidden" name="is_single" id="is_single" value="#attributes.is_single#"></cfif>
							<cfif isdefined("attributes.record_num_")><input type="hidden" name="record_num_" id="record_num_" value="#attributes.record_num_#"></cfif>
							<cfif isdefined("attributes.is_activity")><input type="hidden" name="is_activity" id="is_activity" value="#attributes.is_activity#"></cfif>
							<cfif isdefined("attributes.is_position")><input type="hidden" name="is_position" id="is_position" value="#attributes.is_position#"></cfif>
							<input type="hidden" name="fuseaction_name" id="fuseaction_name" value="#attributes.fuseaction#" />
							<cfif isdefined("attributes.startdate")><input type="hidden" name="startdate" id="startdate" value="#attributes.startdate#"></cfif>
							<input type="hidden" name="kontrol_startdate" id="kontrol_startdate" value="<cfif isdefined("attributes.kontrol_startdate")>#attributes.kontrol_startdate#</cfif>">
							<input type="hidden" name="kontrol_finishdate" id="kontrol_finishdate" value="<cfif isdefined("attributes.kontrol_finishdate")>#attributes.kontrol_finishdate#</cfif>">
							<cfif isdefined("attributes.is_choose_project")><input type="hidden" name="is_choose_project" id="is_choose_project" value="#attributes.is_choose_project#"></cfif>
						</cfoutput>
						<cfset city_list = ''>
						<cfset county_list = ''>
						<cfoutput query="get_company">
							<cfif len(partner_city) and not listfind(city_list,partner_city)>
								<cfset city_list = listappend(city_list,partner_city)>
							</cfif>
							<cfif len(partner_county) and not listfind(county_list,partner_county)>
								<cfset county_list = listappend(county_list,partner_county)>
							</cfif>
						</cfoutput>
						<cfif len(city_list) and xml_city_id eq 1>
							<cfquery name="GET_COMPANY_CITY" datasource="#DSN#">
								SELECT
									CITY_ID,
									CITY_NAME
								FROM
									SETUP_CITY
								WHERE
									CITY_ID IN (#city_list#)
								ORDER BY
									CITY_ID
							</cfquery>
							<cfset city_list=listsort(valuelist(get_company_city.city_id,','),"numeric","ASC",",")>
						</cfif>
						<cfif len(county_list) and xml_county_id eq 1>
							<cfquery name="GET_COMPANY_COUNTY" datasource="#DSN#">
								SELECT
									COUNTY_ID,
									COUNTY_NAME
								FROM
									SETUP_COUNTY
								WHERE
									COUNTY_ID IN (#county_list#)
								ORDER BY
									COUNTY_ID
							</cfquery>
							<cfset county_list=listsort(valuelist(get_company_county.county_id,','),"numeric","ASC",",")>
						</cfif>
						<cfoutput query="get_company" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif not isdefined("attributes.is_sales")>
								<cfquery name="get_comp_info" dbtype="query">
									SELECT TR_NAME, BRANCH_NAME, CARIHESAPKOD, IS_SELECT FROM GET_COMPANY_ACCOUNT WHERE COMPANY_ID = #get_company.company_id#
								</cfquery>
							</cfif>
							<tr>
								<td width="30">#currentrow#</td>
								<td><cfif isdefined("attributes.is_single")><a href="javascript://" onClick="gonder('#company_id#','#fullname#','#partner_id#','#company_partner_name# #company_partner_surname#');" class="tableyazi">#fullname#</a><cfelse>#fullname#</cfif></td>
								<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id#','medium');" class="tableyazi">#company_partner_name# #company_partner_surname#</a></td>
								<cfif xml_city_id eq 1><td><cfif len(city_list)>#get_company_city.city_name[listfind(city_list,partner_city,',')]#</cfif></td></cfif>
								<cfif xml_county_id eq 1><td><cfif len(county_list)>#get_company_county.county_name[listfind(county_list,partner_county,',')]#</cfif></td></cfif>
								<cfif xml_semt eq 1><td><cfif len(partner_semt)>#partner_semt#</cfif></td></cfif>
								<cfif not isdefined("attributes.is_sales")>
									<td>#company_telcode# #company_tel1#</td>
									<td>#taxno#</td>
									<td>#company_id#</td>
									<td title="#ims_code_name#">#ims_code#</td>
									<td>#county_name#</td>
									<td>#city_name#</td>
									<td><cfloop query="get_comp_info">#get_comp_info.branch_name# <cfif len(get_comp_info.carihesapkod)>/ #get_comp_info.carihesapkod#</cfif> <cfif len(get_comp_info.tr_name)>/ #get_comp_info.tr_name#</cfif><br/></cfloop></td>
								<cfelse>
									<td>#companycat#</td>
									<td>#title#</td>
									<td width="35">
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_form_add_partner&compid=#company_id##url_str#','medium')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='32938.Şirkete Çalışan Ekle'>"></i></a>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#partner_id##url_str#','medium')"><i class="fa fa-bar-chart"></i></a>
									</td>
								</cfif>
								<cfif not isdefined("attributes.is_single")>
									<td class="text-center"><input type="checkbox" value="#partner_id#" name="par_ids" id="par_ids"></td>
								</cfif>
							</tr>
						</cfoutput>
					</tbody>
					<cfif not isdefined("attributes.is_single")>
						<tfoot>
							<tr>
								<td colspan="16" style="text-align:right;">
									<cf_workcube_buttons is_upd="0" add_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('form_name' , #attributes.modal_id#)"),DE(""))#">
								</td>
							</tr>
						</tfoot>
					</cfif>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="16"><cfif len(attributes.is_submitted)><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
						</tr>
					</tbody>
				</cfif>
			</cf_grid_list>
		</cfform>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.hedefkodu)>
				<cfset url_str = "#url_str#&hedefkodu=#attributes.hedefkodu#">
			</cfif>
			<cfif len(attributes.branch_state)>
				<cfset url_str = "#url_str#&branch_state=#attributes.branch_state#">
			</cfif>
			<cfif len(attributes.fullname)>
				<cfset url_str = "#url_str#&fullname=#attributes.fullname#">
			</cfif>
			<cfif len(attributes.cp_name)>
				<cfset url_str = "#url_str#&cp_name=#attributes.cp_name#">
			</cfif>
			<cfif len(attributes.is_submitted)>
				<cfset url_str = "#url_str#&is_submitted=#attributes.is_submitted#">
			</cfif>
			<cfif isdefined("attributes.zone_director") and len(attributes.zone_director)>
				<cfset url_str = "#url_str#&zone_director=#attributes.zone_director#">
			</cfif>
			<cfif len(attributes.ims_code_id)>
				<cfset url_str = "#url_str#&ims_code_id=#attributes.ims_code_id#">
			</cfif>
			<cfif len(attributes.ims_code_name)>
				<cfset url_str = "#url_str#&ims_code_name=#attributes.ims_code_name#">
			</cfif>
			<cfif len(attributes.ekip)>
				<cfset url_str = "#url_str#&ekip=#attributes.ekip#">
			</cfif>
			<cfif len(attributes.vergi_no)>
				<cfset url_str = "#url_str#&vergi_no=#attributes.vergi_no#">
			</cfif>
			<cfif len(attributes.city)>
				<cfset url_str = "#url_str#&city=#attributes.city#">
			</cfif>
			<cfif len(attributes.county)>
				<cfset url_str = "#url_str#&county=#attributes.county#">
			</cfif>
			<cfif len(attributes.county_id)>
				<cfset url_str = "#url_str#&county_id=#attributes.county_id#">
			</cfif>
			<cfif len(attributes.pro_rows)>
				<cfset url_str = "#url_str#&pro_rows=#attributes.pro_rows#">
			</cfif>
			<cfif len(attributes.customer_type)>
				<cfset url_str = "#url_str#&customer_type=#attributes.customer_type#">
			</cfif>
			<cfif len(attributes.customer_type_id)>
				<cfset url_str = "#url_str#&customer_type_id=#attributes.customer_type_id#">
			</cfif>
			<cfif isdefined("attributes.click_count") and len(attributes.click_count)>
				<cfset url_str = "#url_str#&click_count=#attributes.click_count#">
			</cfif>
			<cfif len(attributes.branch_id)>
				<cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
			</cfif>
			<cfif len(attributes.pos_code) and len(attributes.pos_code_text)>
				<cfset url_str = "#url_str#&pos_code=#attributes.pos_code#&pos_code_text=#attributes.pos_code_text#">
			</cfif>
			<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
				<cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
			</cfif>
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="objects.#fusebox.fuseaction##url_str#"
				isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>  
	</cf_box>
</div>
<script type="text/javascript">
search_company.fullname.focus();
function remove_field(field_option_name)
{
	field_option_name_value = eval('document.search_company.' + field_option_name);
	for (i=field_option_name_value.options.length-1;i>-1;i--)
	{
		if (field_option_name_value.options[i].selected==true)
			field_option_name_value.options.remove(i);
	}
}
function county_id_clear()
{	
	document.search_company.county.value = '';
	document.search_company.county_id.value = '';
	document.search_company.ims_code_id.value = '';
	document.search_company.ims_code_name.value = '';
}

function pencere_ac2(no)
{
	x = document.search_company.city.selectedIndex;
	if (document.search_company.city[x].value == "")
		alert("<cf_get_lang dictionary_id='33180.İlk Olarak İl Seçiniz'> !");
	else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_dsp_county&field_id=search_company.county_id&field_name=search_company.county&city_id=' + document.search_company.city.value);
}
function select_all(selected_field)
{
	var m = eval("document.search_company."+selected_field+".length");
	for(var i=0;i<m;i++)
	{
		eval("document.search_company."+selected_field+"["+i+"].selected=true")
	}
	return true;
}
function hepsini_sec()
{
	<cfif isdefined("attributes.is_sales")>
		return true;
	<cfelse>
		return select_all('customer_type');
	</cfif>
}
function hepsi()
{
	if (document.getElementById('all').checked)
	{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.par_ids.length;i++) form_name.par_ids[i].checked = true;
		<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
			form_name.par_ids.checked = true;
		</cfif>
			}
		else
			{
		<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
			for(var i=0;i<form_name.par_ids.length;i++) form_name.par_ids[i].checked = false;
		<cfelseif attributes.totalrecords eq 1>
			form_name.par_ids.checked = false;
		</cfif>
	}
}
function add_checked()
{
	var counter = 0;
	<cfif attributes.totalrecords gt 1 and attributes.maxrows gt 1>	
		for (var i=0 ; i < form_name.par_ids.length ; i++) 
			if (form_name.par_ids[i].checked == true) 
			{
				counter = counter + 1;
			}
			if (counter == 0)
			{
				alert("<cf_get_lang dictionary_id='33181.Kişi seçmelisiniz'> !");
				return false;
			}
	<cfelseif attributes.totalrecords eq 1 or attributes.maxrows eq 1>
		if (form_name.par_ids.checked == true) 
		{
			counter = counter + 1;
		}
		if (counter == 0)
		{
			alert("<cf_get_lang dictionary_id='33181.Kişi seçmelisiniz'> !");
			return false;
		}
	</cfif>
}
function gonder(id1,id2,id3,id4)
{
	<cfoutput>
		<cfif isdefined("field_comp_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_comp_id#.value = id1;
		</cfif>
		<cfif isdefined("field_comp_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_comp_name#.value = id2;
		</cfif>
		<cfif isdefined("field_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_id#.value = id3;
		</cfif>
		<cfif isdefined("field_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener</cfif>.#field_name#.value = id4;
		</cfif>
	</cfoutput>
	<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
}
</script>
