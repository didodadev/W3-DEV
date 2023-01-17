<cf_xml_page_edit fuseact="training_management.form_upd_class">
<cfset cmp = createObject("component","V16.training_management.cfc.training_management")>
<cfinclude template="../query/get_class.cfm">
<cfinclude template="../query/get_class_results.cfm">
<cfinclude template="../query/get_class_attender_eval.cfm">
<cfinclude template="../query/get_class_cost.cfm">
<cfinclude template="../query/get_training_eval_quizs.cfm">
<cfinclude template="../query/get_class_sections.cfm">
<cfquery name="training_group_head" datasource="#DSN#">
	SELECT
		TCG.GROUP_HEAD,
        TCGC.CLASS_GROUP_ID,
        TCGC.TRAIN_GROUP_ID
	FROM
		TRAINING_CLASS_GROUPS TCG 
		LEFT JOIN TRAINING_CLASS_GROUP_CLASSES TCGC ON TCG.TRAIN_GROUP_ID = TCGC.TRAIN_GROUP_ID
		LEFT JOIN TRAINING_CLASS TC ON TC.CLASS_ID=TCGC.CLASS_ID
	WHERE
		TC.CLASS_ID = #attributes.class_id# 
</cfquery>
<cfquery name="GET_SITE_MENU" datasource="#DSN#">
	SELECT SITE_ID MENU_ID, DOMAIN SITE_DOMAIN from PROTEIN_SITES WHERE STATUS = 1
</cfquery>
<cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
	SELECT 
		MENU_ID 
	FROM 
		TRAINING_CLASS_SITE_DOMAIN 
	WHERE 
		TRAINING_CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> AND
		MENU_ID IS NOT NULL
</cfquery>
<cfset GET_COMPANIES = cmp.GET_COMPANIES_F()>
<!--- <cfquery name="GET_COMPANIES" datasource="#DSN#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1  ORDER BY COMPANY_NAME
</cfquery> --->
<cfset get_class_company = cmp.GET_COMPANIES_F(class_id:attributes.class_id)>
<!--- <cfquery name="get_class_company" datasource="#dsn#">
	SELECT COMPANY_ID FROM TRAINING_CLASS_COMPANY WHERE CLASS_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery> --->
<cfset comp_list = valuelist(get_class_company.COMP_ID)>
<!--- Yoklama iconu icin kullanildi --->
<cfset GET_CLASS_ATTENDER = cmp.GET_CLASS_ATTENDER_F(CLASS_ID:attributes.CLASS_ID)>
<!--- <cfquery name="GET_CLASS_ATTENDER" datasource="#DSN#">
	SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ID#">
</cfquery> --->
<cfset GET_LANGUAGE = cmp.GET_LANGUAGE_F()>
<!--- <cfquery name="GET_LANGUAGE" datasource="#DSN#">
	SELECT LANGUAGE_SHORT,LANGUAGE_SET FROM SETUP_LANGUAGE
</cfquery> --->
<cfset GET_MODULES = cmp.GET_MODULES_F()>
<!--- <cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT MODULE_ID,MODULE_SHORT_NAME FROM MODULES  WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_SHORT_NAME
</cfquery> --->
<cfset attributes.quiz_id = get_class.quiz_id>
<cfset GET_QUIZ_RESULT = cmp.GET_QUIZ_RESULT_F(
	class_id:attributes.class_id,
	quiz_id:iif(isdefined("attributes.quiz_id") and len(attributes.quiz_id),attributes.quiz_id,"")
)>
<!--- <cfquery name="GET_QUIZ_RESULT" datasource="#DSN#">
	SELECT	
		CLASS_EVAL_ID
	FROM
		TRAINING_CLASS_EVAL
	WHERE
		<cfif isdefined("attributes.quiz_id") and len(attributes.quiz_id)>
			QUIZ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quiz_id#"> AND
		</cfif>	
		CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery> --->	
<cfset attributes.training_id = ValueList(get_cl_sec.training_id)>
<cfif not len(attributes.training_id)><cfset attributes.training_id=0></cfif>
<cfif len(get_class.start_date)>
	<cfset start_date = date_add('h', session.ep.time_zone, get_class.start_date)>
<cfelse>
	<cfset start_date = "">
</cfif>
<cfif len(get_class.finish_date)>
	<cfset finish_date = date_add('h', session.ep.time_zone, get_class.finish_date)>
<cfelse>
	<cfset finish_date = "">
</cfif>
<cfset CONTROL = cmp.CONTROL_F(class_id:attributes.class_id)>
<!--- <cfquery name="CONTROL" datasource="#DSN#">
	SELECT 
		RESULT_HEAD,
		RESULT_DETAIL 
	FROM 
		TRAINING_CLASS_RESULT_REPORT 
	WHERE 
		CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery> --->
<cfif len(get_class.record_emp)>
	<cfset GET_RECORD_POSITIONS_CODE = cmp.GET_RECORD_POSITIONS_CODE_F(record_emp:get_class.record_emp)>
	<!--- <cfquery name="GET_RECORD_POSITIONS_CODE" datasource="#DSN#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.record_emp#">  AND IS_MASTER = 1
	</cfquery> --->
</cfif>
<cfset GET_TRAINER = cmp.GET_TRAINER_F(class_id:attributes.class_id)>
<!--- <cfquery name="GET_TRAINER" datasource="#DSN#" maxrows="1">
	SELECT EMP_ID,PAR_ID,CONS_ID FROM TRAINING_CLASS_TRAINERS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#">
</cfquery> --->
<cfif get_site_domain.recordcount>
	<cfset my_training_list = valuelist(get_site_domain.menu_id)>
</cfif>
<cf_catalystHeader>
<!--- Sayfa ana kısım  --->
<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
    <cf_box>
		<cfform name="add_class" method="post" action="#request.self#?fuseaction=training_management.emptypopup_upd_class">
			<input type="hidden" name="class_id" id="class_id" value="<cfoutput>#class_id#</cfoutput>">
			<input type="hidden" name="emp_par_name" id="emp_par_name" value="<cfoutput><cfif get_trainer.recordcount><cfif len(get_trainer.emp_id)>#get_emp_info(get_trainer.EMP_ID,0,0)#<cfelseif len(get_trainer.par_id)>#get_par_info(get_trainer.par_id,0,-1,0)#<cfelseif len(get_trainer.cons_id)>#get_cons_info(get_trainer.cons_id,0,0)#</cfif></cfif></cfoutput>">
			<cf_tab defaultOpen="sayfa_1" divId="sayfa_1,sayfa_2" divLang="#getLang('','Temel Bilgiler',58131)#;#getLang('','Detay',57771)#">
				<div id="unique_sayfa_1" class="ui-info-text uniqueBox">
					<cf_box_elements vertical="1">
						<div class="col col-5 col-sm-12 col-xs-12" type="column" index="1" sort="true">
							<cfscript>
								local = {};
								local.start = timeformat(get_class.start_date,timeformat_style);
								local.end = timeformat(get_class.finish_date,timeformat_style);
								local.today = timeformat(now(),timeformat_style);
								local.valid = false;
								if ( (dateDiff("h", local.start, local.today) >= 0) 
										AND (dateDiff("h", local.today, local.end) >= 0) ){
									local.valid = true;
								}
							</cfscript>
							<div class="form-group" id="url_training_" <cfif get_class.online eq 0> style="display:none;" </cfif>>
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='30015.Online'></label>
								<div class="col col-9 col-sm-6 col-xs-12">									
									<cfoutput>
									<div class="input-group">	
										<cfinput type="text" name="url_training" id="url_training" value="#get_class.TRAINING_LINK#">
										<a class="input-group-addon btnPointer" target="_blank" href="#get_class.TRAINING_LINK#" <cfif local.valid eq false> onclick="return false;" </cfif>>
										<i class="fa fa-coffee"></i></a>
									</cfoutput>
									</div>
								</div>
							</div>	
							<div class="form-group" id="item-train_style" >
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang no ='29.Eğitim Şekli'></label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<cf_wrk_selectlang
										name="training_style"
										option_name="TRAINING_STYLE"
										option_value="training_style_id"
										width="250"
										table_name="SETUP_TRAINING_STYLE"
										value="#get_class.training_style#">
								</div>
							</div>
							<div class="form-group" id="item-training_cat_id">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no='74.kategori'> *</label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<cf_wrk_selectlang
										name="training_cat_id"
										option_name="training_cat"
										option_value="training_cat_id"
										table_name="TRAINING_CAT"
										onchange="showSection(this.value);"
										width="250"
										value="#get_class.training_cat_id#">
								</div>
							</div>
							<div class="form-group" id="item-section_place">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no='583.bölüm'></label>
								<div class="col col-9 col-sm-6 col-xs-12"><cfsavecontent variable="text"><cf_get_lang_main no='583.bölüm'></cfsavecontent>
									<div id="section_place" >
									<cf_wrk_selectlang
										name="training_sec_id"
										option_name="SECTION_NAME"
										option_value="TRAINING_SEC_ID"
										table_name="TRAINING_SEC"
										option_text="#text#"
										value="#get_class.TRAINING_SEC_ID#"
										width="250">
									</div>
								</div>
							</div>
							<div class="form-group" id="item-class_name">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='46015.Ders'> *</label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<!--- <cfsavecontent variable="message"><cf_get_lang no='293.Eğitim Adı Girmelisiniz'></cfsavecontent>  --->
									<div class="input-group">
										<cfinput type="text" name="class_name" id="class_name" value="#get_class.class_name#" maxlength="100"><!--- required="Yes" message="#message#" --->
							
										<span class="input-group-addon">
											<cf_language_info
											table_name="TRAINING_CLASS"
											column_name="CLASS_NAME"
											column_id_value="#attributes.class_id#"
											maxlength="500"
											datasource="#dsn#" 
											column_id="CLASS_ID" 
											control_type="0">
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-train_id">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='46049.Müfredat'></label>										
									<cfset train_head = "">
									<cfif len(get_class.training_id)>
										<cfset GET_TRAINING = cmp.GET_TRAINING_F(training_id:get_class.training_id)>
										<!--- <cfquery name="GET_TRAINING" datasource="#DSN#">
											SELECT TRAIN_HEAD FROM TRAINING WHERE TRAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.training_id#">
										</cfquery> --->
										<cfset train_head = get_training.train_head>
									</cfif>
								<div class="col col-9 col-sm-6 col-xs-12">
									<div class="input-group">
										<cfinput type="hidden" name="train_id" id="train_id" value="#get_class.training_id#">
										<cfinput type="text" name="train_head" id="train_head" value="#train_head#">
										<span class="input-group-addon icon-ellipsis btnPointer"  onclick="windowopen('<cfoutput>#request.self#?fuseaction=training.popup_list_training_subjects&field_id=add_class.train_id&field_name=add_class.train_head&field_cat_id=add_class.training_cat_id&field_sec_id=add_class.training_sec_id&field_training_style=add_class.training_style</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-class_place">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang no='187.Eğitim Yeri'></label>
								<div class="col col-9 col-sm-6 col-xs-12"><cfinput type="text" name="class_place" id="class_place" value="#get_class.class_place#" ></div>
							</div>
							<div class="form-group" id="item-class_place_address">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang no='30.Eğitim Yeri Adresi'></label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<cfinput type="text" name="class_place_address" id="class_place_address" value="#get_class.class_place_address#" maxlength="100">
								</div>
							</div>								
							<div class="form-group" id="item-class_place_tel" >
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang no='34.Eğitim Yeri Telefonu'></label>
								<div class="col col-9 col-sm-6 col-xs-12"><cfinput type="text" name="class_place_tel" id="class_place_tel" value="#get_class.class_place_tel#" validate="integer" onKeyUp="isNumber(this);"maxlength="100"></div>
							</div>
							<div class="form-group" id="item-class_place_manager">
								<label class="col col-3 col-sm-6 col-xs-12"style="line-height:12px !important;"><cf_get_lang no='35.Eğitim Yeri Sorumlusu'></label>
								<div class="col col-9 col-sm-6 col-xs-12"><cfinput type="text" name="class_place_manager" id="class_place_manager" value="#get_class.class_place_manager#" maxlength="100"></div>
							</div>							
							<div class="form-group" id="item-class_announcement">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='46211.Eğitim Duyurusu'></label><!---20131104--->
									<div class="col col-9 col-sm-6 col-xs-12">
										<div class="input-group">
										<cfinput type="text" name="class_announcement" id="class_announcement" value="#get_class.class_announcement_detail#" maxlength="600"><!--- required="Yes" message="#message#" --->
							
										<span class="input-group-addon">
											<cf_language_info
											table_name="TRAINING_CLASS"
											column_name="CLASS_ANNOUNCEMENT_DETAIL"
											column_id_value="#attributes.class_id#"
											maxlength="600"
											datasource="#dsn#" 
											column_id="CLASS_ID" 
											control_type="0">
										</span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-5 col-sm-12 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-user_friendly_url">								
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='50659.Kullanıcı Dostu Url Adres'></label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<cf_publishing_settings fuseaction="training_management.list_class" event="det" action_type="CLASS_ID" action_id="#attributes.class_id#">									                                           
								</div>
							</div>
							<div class="form-group" id="item-language_id">
								<label class="col col-3 col-sm-6 col-xs-12">
									<cf_get_lang_main no='1584.Dil'> *
								</label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<select name="language_id" id="language_id" >
											<cfoutput query="get_language">
												<option value="#language_short#"<cfif language_short is get_class.language>selected</cfif>>#language_set#</option>
											</cfoutput>
									</select>	
								</div>								
							</div>
							<div class="form-group" id="item-process" >
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no="1447.Süreç"></label>
								<div class="col col-9 col-sm-6 col-xs-12"><cf_workcube_process is_upd='0' select_value='#get_class.process_stage#' process_cat_width='200' is_detail='1'></div>
							</div>
							<div class="form-group" id="item-start_date">
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no='89.başlama'> *</label>
								<div class="col col-3 col-sm-6 col-xs-12">
									<div class="input-group">
										<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.Girilmesi Zorunlu Alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>  --->
										<cfinput name="start_date" id="start_date" value="#dateformat(start_date,dateformat_style)#" validate="#validate_style#" type="text"maxlength="10"><!--- message="#message#" --->
										<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									</div>
								</div>
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='119.saatdakika'> *</label>
								<div class="col col-2 col-xs-3">
									<cf_wrkTimeFormat  name="event_start_clock" id="event_start_clock" value="#timeformat(start_date,'HH')#">	
								</div>
								<div class="col col-2 col-xs-3">
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
								</div>
							</div>
							<div class="form-group" id="item-finish_date" >
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no='90.bitis'> *</label>
								<div class="col col-3 col-sm-6 col-xs-12">
									<div class="input-group">
										<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent> --->
										<cfinput name="finish_date" id="finish_date" value="#dateformat(finish_date,dateformat_style)#"type="text"validate="#validate_style#" maxlength="10"><!--- message="#message#" --->
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
								<label class="col col-2 col-sm-6 col-xs-12"><cf_get_lang no='119.saatdakika'> *</label>
								<div class="col col-2 col-xs-3 ">
									<cf_wrkTimeFormat  name="event_finish_clock" id="event_finish_clock" value="#timeformat(finish_date,'HH')#">
								</div>
								<div class="col col-2 col-xs-3">
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
								</div>
							</div>
							<div class="form-group" id="item-max_participation">
								<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang no='445.Maksimum Katılımcı'></label>
								<div class="col col-2 col-sm-6 col-xs-12"><cfinput type="text" name="max_participation" id="max_participation" value="#get_class.max_participation#" validate="integer" onKeyUp="isNumber(this);"></div>
								<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='62065.Online Maksimum Başvuru'></label>
								<div class="col col-2 col-sm-6 col-xs-12"><cfinput type="text" name="max_self_service" id="max_self_service" value="#get_class.max_self_service#" validate="integer" onKeyUp="isNumber(this);"></div>
							</div>
							<div class="form-group" id="item-date_no">
								<label class="col col-4 col-sm-6 col-xs-12"><cf_get_lang no='169.Toplam Gün'>*</label>
								<div class="col col-2 col-sm-6 col-xs-12">
									<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='169.toplam Gün'></cfsavecontent> --->
									<cfinput type="text" value="#get_class.date_no#" name="date_no" id="date_no" maxlength="100"><!--- required="Yes" message="#message#" --->
								</div>
								<label class="col col-4 col-sm-6 col-xs-12">	
									<cf_get_lang_main no='80.toplam'><cf_get_lang_main no='79.Saat'>* 
									<!--- <cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='170.toplam saat'>*</cfsavecontent> --->
								</label>
								<div class="col col-2 col-sm-6 col-xs-12">	<cfinput type="text" value="#Replace(get_class.hour_no, ".", ",", "all")#" name="hour_no" id="hour_no" maxlength="100"></div><!--- required="Yes" message="#message#" --->
							</div>
							<cfif len(get_class.stock_id)>
								<cfset GET_PRODUCT = cmp.GET_PRODUCT_F(stock_id:get_class.stock_id)>
								<!--- <cfquery name="GET_PRODUCT" datasource="#DSN3#">
									SELECT 
										P.PRODUCT_NAME,
										S.PROPERTY
									FROM 
										PRODUCT P, 
										STOCKS S
									WHERE 
										S.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.stock_id#"> 
										AND S.PRODUCT_ID = P.PRODUCT_ID
								</cfquery> --->
								<cfset attributes.stock_id = get_class.stock_id>
								<cfset attributes.product_name = get_product.product_name>
							<cfelse>
								<cfset attributes.stock_id = "">
								<cfset attributes.product_name = "">
							</cfif>
							<div class="form-group" id="item-stock_id" > 
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no='245.Ürün'></label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<div class="input-group">	
										<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
										<input type="text" name="product_name" id="product_name" value="<cfoutput>#attributes.product_name#</cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id,','','3','200');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis btnPointer"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=add_class.stock_id&field_name=add_class.product_name','list');"></span>			
									</div>
								</div>
							</div>
							<div class="form-group" id="item-class_tools" >
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang_main no='2.Araçlar'></label>
								<div class="col col-9 col-sm-6 col-xs-12"><textarea name="class_tools" id="class_tools"><cfoutput>#get_class.class_tools#</cfoutput></textarea></div>
							</div>								
							<div class="form-group" id="item-class_target">	
								<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang no='32.Amaç'></label>
								<div class="col col-9 col-sm-6 col-xs-12">
									<textarea name="class_target" id="class_target"><cfoutput>#get_class.class_target#</cfoutput></textarea>
								</div>        
							</div>	
							<div class="form-group" id="item-modules">
								<cfif isDefined('xml_is_module') and xml_is_module eq 1>
									<label class="col col-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='55060.Modül'></label>
										<div class="col col-9 col-sm-6 col-xs-12">
											<cf_multiselect_check 
												name="modules"
												option_name="module_short_name"
												option_value="module_id"
												query_name="get_modules"
												value="#get_class.module_ids#">                                        
									</div>
								</cfif>	
							</div>
							<div class="form-group"  id="item-is_site_display">
								<div id="is_site_display" <cfif get_class.is_internet eq 0> style="display:none;" </cfif>valign="top">
									<label class="col col-12 col-sm-6 col-xs-12 formbold"><cf_get_lang no='24.Yayınlanacak Site'></label>
									<cfoutput query="get_site_menu">
										<div class="col col-12 col-sm-6 col-xs-12"><input name="menu_#menu_id#" id="menu_#menu_id#" type="checkbox" value="#menu_id#"<cfif get_site_domain.recordcount and (isDefined('my_training_list') and ListFindNoCase(my_training_list,menu_id,','))>checked</cfif>>#site_domain#&nbsp;</div>	
									</cfoutput>
								</div>
							</div>
						</div>
						<div class="col col-2 col-sm-12 col-xs-12" type="column" index="3" sort="true">	
							<div class="form-group">
								<label><input type="checkbox" name="online" id="online" value="1" onclick="gizle_goster(url_training_);" <cfif get_class.online eq 1>checked="checked"</cfif>><cf_get_lang_main no='2218.online'></label>
								<label><input type="checkbox" name="is_net_display" id="is_net_display" value="1" onclick="gizle_goster(is_site_display);" <cfif get_class.is_internet eq 1>checked="checked"</cfif>><cf_get_lang no='40.İnternette Gözüksün'></label>
								<label><input type="checkbox" name="is_active" id="is_active" value="1" checked="checked"><cf_get_lang_main no='81.Aktif'> &nbsp;</label>

								<cfset FIND_DEPARTMENT_BRANCH = cmp.FIND_DEPARTMENT_BRANCH_F(iif(isdefined("get_record_positions_code") and get_record_positions_code.recordcount,get_record_positions_code.position_code,""))>

								<cfoutput>
									<label>
										<input type="checkbox" name="view_to_all" id="view_to_all" <cfif get_class.view_to_all eq 1 and not len(get_class.is_wiew_branch) and not len(get_class.is_wiew_department) and not len(get_class.is_view_company)>checked</cfif> value="1"  onclick="wiew_control(1);"><cf_get_lang no='44.Bu olayı herkes görsün'>
									</label>
									<label>
										<input type="checkbox" name="is_wiew_branch" id="is_wiew_branch" <cfif len(get_class.is_wiew_branch) and not len(get_class.is_wiew_department)>checked</cfif> value="#find_department_branch.branch_id#" onclick="wiew_control(2);">
										<cf_get_lang_main no='502.Şubemdeki Herkes Görsün'>
									</label>
									<label>
										<input type="checkbox" name="is_view_department" id="is_view_department" <cfif len(get_class.is_wiew_department)>checked</cfif> value="#find_department_branch.department_id#" onclick="wiew_control(3);">
										<cf_get_lang_main no='503.Departmanımdaki Herkes Görsün'>
									</label>
									<label>
										<input type="checkbox" name="is_view_comp" id="is_view_comp" <cfif len(get_class.is_view_company)>checked</cfif> value="#session.ep.company_id#" onclick="wiew_control(4);">
										<cf_get_lang dictionary_id='33481.Sadece Şirket Çalışanları Görsün'>
									</label>
								</cfoutput>

								<div class="form-group col col-12 col-xs-12" id="agenda_companies" style="display:none;">
									<cfif xml_multiple_comp>
										<select name="agenda_company" multiple="multiple">
											<cfoutput query="get_companies">
													<div id="agenda_companies" style="display:none;">
														<option value="#COMP_ID#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#NICK_NAME#</option>
													</div>
											</cfoutput>
										</select>
									</cfif>
								</div>
							</div>
						</div>
					</cf_box_elements>
				</div>
				<div id="unique_sayfa_2" class="ui-info-text uniqueBox">
					<cf_box_elements vertical="1">
						<div class="col col-12 col-sm-12 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="item-editor">
								<label style="display:none!important;"><cf_get_lang_main no='241.İçerik'></label>	
								<cfmodule template="/fckeditor/fckeditor.cfm"
								toolbarset="WRKContent"
								basepath="/fckeditor/"
								instancename="class_objective"
								value="#iif( isDefined( "get_class" ), "get_class.class_objective", de( "" ) )#"
								width="100%"
								maxCharCount="4000"
								valign="top">
							</div>
						</div>
					</cf_box_elements>
				</div>
			</cf_tab>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>  
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_record_info query_name="get_class" record_emp="record_emp" update_emp="update_emp">
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=training_management.emptypopup_del_class&class_id=#attributes.class_id#&class_name=#get_class.class_name#' add_function='kontrol()'>
					</div>
				</cf_box_footer>
			</div>		
		</cfform>
		</cf_box>
		<cf_get_workcube_content action_type ='CLASS_ID' action_type_id ='#attributes.class_id#' style='1' design='1'><!--- içerikler --->
			<cf_get_workcube_asset asset_cat_id="-6" module_id='34' action_section='CLASS_ID' action_id='#url.class_id#'><!--- Belgeler --->
				<cfinclude  template="../scorm_engine/courses.cfm"><!--- scorm uyumlu içerik --->
			</div>
<div class="col col-3 col-sm-6 col-xs-12">
	<cfinclude template="upd_class_sag.cfm">
</div>
<script type="text/javascript">
	function gizle(id1)
	{
		if(id1.style.display=='')
			id1.style.display='none';
		else
			id1.style.display='';
	} 
	function kontrol()
	{
		if (!process_cat_control()) return false;
		/* if(document.getElementById('online').checked == true && document.getElementById('emp_par_name').value == "")
        {
            alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='23.Eğitimci'>");
            return false;
        } Ders kopyalama ve güncellemede sorun çıkardığı için kaldırıldı. */
		if(document.getElementById('online').checked == true && document.getElementById('url_training').value == "")
        {
            alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang dictionary_id='30015.Online'>");
			document.getElementById("url_training").focus();
            return false;
        }
		if (document.getElementById('training_cat_id').value =='' || document.getElementById('training_cat_id').value ==0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='74.Kategori'>");
			return false;
		}
		if(document.getElementById('class_name').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='7.Eğitim'>");
			return false;
		}
		if(document.getElementById('class_announcement').value.length > 1500)
		{		
			alert("<cf_get_lang no='537.Ders Duyurusunun Karakter sayısı 1500 den fazla olamaz'>!");
			return false;
		}
		/* if(document.getElementById('class_objective').value.length > 4000)
		{
			alert("<cf_get_lang no='103.Ders İçeriğinin Karakter sayısı 4000 den fazla olamaz'>!");
			return false;
		} */
		if(document.getElementById('language_id').value == '')
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang_main no='1584.Dil'>");
			return false;
		}
		if(document.getElementById('start_date').value == "")
		{
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang no='447.Başlangıç Bitiş Tarihi '>");
			return false;
		}
		if(document.getElementById('finish_date').value == "")
		{
			alert ("<cf_get_lang_main no='782.girilmesi zorunlu alan'> : <cf_get_lang no='447.Başlangıç Bitiş Tarihi '>");
			return false;
		}
		if (document.add_class.event_start_clock.value =='' || document.add_class.event_start_clock.value == 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Başlangıç <cf_get_lang no='119.saat / dk'>");
			return false;
		}
		if (document.add_class.event_finish_clock.value =='' || document.add_class.event_finish_clock.value == 0)
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : Bitiş <cf_get_lang no='119.saat / dk'>");
			return false;
		}
		if(document.getElementById('date_no').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='169.toplam Gün'>");
			return false;
		}
		else
		{
			document.getElementById('date_no').value = filterNum(document.getElementById('date_no').value);
		}
		if (document.getElementById('hour_no').value == "")
		{
			alert("<cf_get_lang_main no='782.Zorunlu Alan'> : <cf_get_lang no='170.toplam saat'>");
			return false;
		}
		else
		{
			document.getElementById('hour_no').value = filterNum(document.getElementById('hour_no').value);
		}
		if ( (document.getElementById('start_date').value != "") && (document.getElementById('finish_date').value != "") && (document.getElementById('event_start_clock').value != "") && (document.getElementById('event_finish_clock').value != "") )
			return time_check(add_class.start_date, add_class.event_start_clock, add_class.event_start_minute, add_class.finish_date,add_class.event_finish_clock,add_class.event_finish_minute, "Ders Başlama Tarihi Bitiş Tarihinden önce olmalıdır!");
		return true;
	}
	function wiew_control(type)
	{
		if(type==1)
		{
			$("input[name=is_wiew_branch]").prop('checked',false);
			$("input[name=is_view_department]").prop('checked',false);
			$("input[name=is_view_comp]").prop('checked',false);

		}
		if(type==2)
		{	
			$("input[name=view_to_all]").prop('checked',false);
			$("input[name=is_view_department]").prop('checked',false);
			$("input[name=is_view_comp]").prop('checked',false);
		}
		if(type==3)
		{
			$("input[name=view_to_all]").prop('checked',false);
			$("input[name=is_wiew_branch]").prop('checked',false);
			$("input[name=is_view_comp]").prop('checked',false);
		}
		if(type==4)
		{
			$("input[name=view_to_all]").prop('checked',false);
			$("input[name=is_wiew_branch]").prop('checked',false);
			$("input[name=is_view_department]").prop('checked',false);

			<cfif xml_multiple_comp eq 1>
				if(document.getElementById('is_view_comp').checked ==false)
					document.getElementById('agenda_companies').style.display = 'none';
				else
					document.getElementById('agenda_companies').style.display = '';
			</cfif>
		}
	}
	function showSection(cat_id)	
	{
		var cat_id = document.getElementById('training_cat_id').value;
		if (cat_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.popup_ajax_list_section&cat_id="+cat_id;
			AjaxPageLoad(send_address,'section_place',1,'İlişkili Bölümler');
			
		}
	}
	/*function get_class_name(id)
	{
		var get_class_name_ = wrk_safe_query('trn_get_class_name','dsn',0,id);
		document.add_class.related_class_name.value = get_class_name_.CLASS_NAME;
	}*/	
</script>