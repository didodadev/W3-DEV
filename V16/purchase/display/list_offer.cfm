<cf_xml_page_edit fuseact ="purchase.list_offer">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.offer_number" default="">
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.offer_stage" default="">
<cfparam name="attributes.public_partner" default="">
<cfparam name="attributes.order_by_date" default="">
<cfparam name="attributes.assc_offers" default="1">
<cfparam name="attributes.offer_status" default="1">
<cfif isdefined("xml_employee") and xml_employee eq 1>
	<cfparam name="attributes.employee_id" default="#session.ep.userid#">
	<cfparam name="attributes.employee" default="#session.ep.name# #session.ep.surname#">
<cfelse>
	<cfparam name="attributes.employee_id" default="">
	<cfparam name="attributes.employee" default="">
</cfif>
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.listing_type" default="1">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.start_date=''>
	<cfelse>
		<cfset attributes.start_date = wrk_get_today()>
	</cfif>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
<cfelse>
	<cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
		<cfset attributes.finish_date=''>
	<cfelse>
		<cfset attributes.finish_date = date_add('ww',1,attributes.start_date)>
	</cfif>
</cfif>
<cfif isdefined("attributes.public_start_date") and isdate(attributes.public_start_date)>
	<cf_date tarih="attributes.public_start_date">
<cfelse>
	<cfset attributes.public_start_date = "">
</cfif>
<cfif isdefined("attributes.public_finish_date") and isdate(attributes.public_finish_date)>
	<cf_date tarih="attributes.public_finish_date">
<cfelse>
	<cfset attributes.public_finish_date = "">
</cfif>

<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'purchase.list_offer')>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
    <cfif isDefined("attributes.print_offer_id") and Listlen(attributes.print_offer_id) gt 0>
		<cfset totalValues = structNew()>
		<cfset totalValues = {
				total_offtime : 0
			}>
		<cfset print_offer_id = replace(attributes.print_offer_id,";",",","all")>
		<cf_workcube_general_process
			mode = "query"
			general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
			general_paper_no = "#attributes.general_paper_no#"
			general_paper_date = "#attributes.general_paper_date#"
			action_list_id = "#print_offer_id#"
			process_stage = "#attributes.process_stage#"
			general_paper_notice = "#attributes.general_paper_notice#"
			responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
			responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
			action_table = 'OFFER'
			action_column = 'OFFER_ID'
			action_page = '#request.self#?fuseaction=purchase.list_offer'
			total_values = '#totalValues#'
		>
		<cfset attributes.approve_submit = 0>
	</cfif>
</cfif>

<cfif isdefined("attributes.is_form_submit")>
	<cfscript>
        get_offer_list_action = createObject("component", "V16.purchase.cfc.get_offer_list");
        get_offer_list_action.dsn3 = dsn3;
        get_offer_list = get_offer_list_action.get_offer_list_fnc
            (	
				listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
				product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
				product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
				keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
				offer_number : '#IIf(IsDefined("attributes.offer_number"),"attributes.offer_number",DE(""))#',
				currency_id : '#IIf(IsDefined("attributes.currency_id"),"attributes.currency_id",DE(""))#',
				offer_stage : '#IIf(IsDefined("attributes.offer_stage"),"attributes.offer_stage",DE(""))#',
				public_partner : '#IIf(IsDefined("attributes.public_partner"),"attributes.public_partner",DE(""))#',
				offer_status : '#IIf(IsDefined("attributes.offer_status"),"attributes.offer_status",DE(""))#',
				employee : '#IIf(IsDefined("attributes.employee"),"attributes.employee",DE(""))#',
				employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
				company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
				company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
				consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
				public_start_date : '#IIf(IsDefined("attributes.public_start_date"),"attributes.public_start_date",DE(""))#',
				public_finish_date : '#IIf(IsDefined("attributes.public_finish_date"),"attributes.public_finish_date",DE(""))#',
				start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
				finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
				project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
                project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
                order_by_date : '#iIf(isDefined("attributes.order_by_date"),"attributes.order_by_date",DE(""))#',
                assc_offers : '#iIf(isDefined("attributes.assc_offers") and attributes.assc_offers eq 2,"attributes.assc_offers",DE(""))#'
			);
	</cfscript>
<cfelse>
	<cfset get_offer_list.recordcount = 0>
</cfif>
<cfquery name="get_process_type" datasource="#dsn#">
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
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%purchase.list_offer%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cffunction name="total_price">
	<cfargument name="id_" type="numeric">
	<cfargument name="total_" type="numeric" default="1">
	<cfargument name="type_" type="numeric" default="1">
	<cfquery name="get_total_sum" datasource="#dsn3#">
		SELECT
			<cfif total_ eq 1>
				<cfif type_ eq 1>SUM(PRICE)<cfelse>PRICE</cfif> TOTAL_PRICE
			<cfelse>
				<cfif type_ eq 1>SUM(OTHER_MONEY_VALUE)<cfelse>PRICE_OTHER</cfif> TOTAL_PRICE
			</cfif>
		FROM
			<cfif type_ eq 1>OFFER<cfelse>OFFER_ROW</cfif>
		WHERE
			<cfif type_ eq 1>OFFER_ID<cfelse>OFFER_ROW_ID</cfif> = #id_#
	</cfquery>
	<cfif get_total_sum.recordcount>
		<cfreturn get_total_sum.total_price>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
<cfinclude template="../query/get_offer_currencies.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_offer_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

    <cfform name="form_filter" action="#request.self#?fuseaction=purchase.list_offer" method="post">
        <input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box id="list_offer_search">
                <cf_box_search>
                    <cfoutput>
                        <div class="form-group">
                            <input type="text" name="keyword" id="keyword" placeholder="<cf_get_lang dictionary_id='57460.Filtre'>" value="#attributes.keyword#">
                        </div>
                        <div class="form-group">
                            <input type="text" name="offer_number" placeholder="<cf_get_lang dictionary_id='58212.Teklif No'>" value="#attributes.offer_number#">
                        </div>
                        <div class="form-group">
                            <select name="order_by_date" id="order_by_date">
                                <option value=""><cf_get_lang dictionary_id='30588.Sıralama'></option>
                                <option value="1" <cfif attributes.order_by_date eq 1>selected</cfif>><cf_get_lang dictionary_id='40911.Teklif Tarihine Göre Azalan'></option>
                                <option value="2" <cfif attributes.order_by_date eq 2>selected</cfif>><cf_get_lang dictionary_id='40909.Teklif Tarihine Göre Artan'></option>
                                <option value="3" <cfif attributes.order_by_date eq 3>selected</cfif>><cf_get_lang dictionary_id='60219.Güncelleme Tarihine Göre Azalan'></option>
                                <option value="4" <cfif attributes.order_by_date eq 4>selected</cfif>><cf_get_lang dictionary_id='60218.Güncelleme Tarihine Göre Artan'></option>
                                <option value="5" <cfif attributes.order_by_date eq 5>selected</cfif>><cf_get_lang dictionary_id='60613.Belge Numarasına Göre Azalan'></option>
                                <option value="6" <cfif attributes.order_by_date eq 6>selected</cfif>><cf_get_lang dictionary_id='60612.Belge Numarasına Göre Artan'></option>
                            </select>
                        </div>
                        <div class="form-group">      
                            <select name="public_partner" id="public_partner">
                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif attributes.public_partner eq 1>selected</cfif>><cf_get_lang dictionary_id='58885.Partner'></option>
                                <option value="2" <cfif attributes.public_partner eq 2>selected</cfif>><cf_get_lang dictionary_id='38605.Public'></option>
                                <option value="3" <cfif attributes.public_partner eq 3>selected</cfif>><cf_get_lang dictionary_id='29659.Intranet'></option>
                            </select>			
                        </div>
                        <div class="form-group">           
                            <select name="offer_status" id="offer_status">
                                <option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif attributes.offer_status eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                                <option value="0" <cfif attributes.offer_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
                            </select>			
                        </div>
                        <div class="form-group small">
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                        </div>
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                        </div>
                    </cfoutput>
                </cf_box_search>
                <cf_box_search_detail>
                    <cfoutput>
                        <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="1">
                            <div class="form-group" id="item-project_id">			
                                <label class="col col-12"><cf_get_lang dictionary_id ='57416.Proje'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_id)>#attributes.project_id#</cfif>">
                                        <input type="text" name="project_head"  id="project_head" value="<cfif isdefined('attributes.project_head') and  len(attributes.project_head)>#attributes.project_head#</cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_projects&project_id=order_form.project_id&project_head=order_form.project_head');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-company">			
                                <label class="col col-12"><cf_get_lang dictionary_id ='57519.Cari Hesap'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.consumer_id) and len(attributes.company)>value="#attributes.consumer_id#"</cfif> />
                                        <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company_id) and Len(attributes.company)>value="#attributes.company_id#"</cfif>>
                                        <input type="text" name="company" id="company" <cfif (len(attributes.company_id) or len(attributes.consumer_id)) and len(attributes.company)>value="#attributes.company#"</cfif> onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0','COMPANY_ID,CONSUMER_ID','company_id,consumer_id','','3','200');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_name=form_filter.company&field_comp_id=form_filter.company_id&field_consumer=form_filter.consumer_id&select_list=7,8&keyword='+encodeURIComponent(document.form_filter.company.value));"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-">			
                                <label class="col col-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                <div class="col col-12">
                                    <select name="offer_stage" id="offer_stage">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <cfloop query="get_process_type">
                                            <option value="#process_row_id#"<cfif attributes.offer_stage eq process_row_id>selected</cfif>>#stage#</option>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="2">
                            <div class="form-group" id="item-employee_id">			
                                <label class="col col-12"><cf_get_lang dictionary_id='57576.Çalışan'>/<cf_get_lang dictionary_id='57899.Kaydeden'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <cfif isdefined("xml_change_by_position_id") and len(xml_change_by_position_id)>
                                            <cfquery name="get_pos_id" datasource="#dsn#">
                                                SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                                            </cfquery>
                                        </cfif>
                                        <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.employee_id)>value="#attributes.employee_id#"</cfif>>
                                        <input type="text" name="employee" id="employee" value="<cfif len(attributes.employee_id) and len(attributes.employee)>#attributes.employee#</cfif>" style="width:95px;" <cfif isdefined("xml_employee") and xml_employee neq 1 or (isdefined("xml_change_by_position_id") and len(xml_change_by_position_id) and  listfind(xml_change_by_position_id,get_pos_id.position_id))> onFocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','200');" autocomplete="off"<cfelse>readonly="yes"</cfif>>
                                        <cfif isdefined("xml_employee") and xml_employee neq 1 or (isdefined("xml_change_by_position_id") and len(xml_change_by_position_id) and  listfind(xml_change_by_position_id,get_pos_id.position_id))>
                                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form_filter.employee_id&field_name=form_filter.employee&select_list=1&branch_related')"></span>
                                        </cfif>                            
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_id">			
                                <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="product_id" id="product_id" <cfif len(attributes.product_name)>value="#attributes.product_id#"</cfif>>
                                        <input type="text" name="product_name" id="product_name" value="#attributes.product_name#" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','225');" autocomplete="off">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_product_names&product_id=form_filter.product_id&field_name=form_filter.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form_filter.product_name.value));"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-offers">			
                                <label class="col col-12"><cf_get_lang dictionary_id='32656.İlişkili Teklifler'></label>
                                <div class="col col-12">
                                    <select name="assc_offers" id="assc_offers">
                                        <option value="1"<cfif attributes.assc_offers eq 1>selected</cfif>><cf_get_lang dictionary_id='60625.Tüm Teklifler'></option>
                                        <option value="2"<cfif attributes.assc_offers eq 2>selected</cfif>><cf_get_lang dictionary_id='60626.Ana Teklifler'></option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="3">
                            <div class="form-group" id="currency_id">			
                                <label class="col col-12"><cf_get_lang dictionary_id ='38511.Özel Tanımlar'></label>
                                <div class="col col-12">
                                    <select name="currency_id" id="currency_id">
                                        <option value=""><cf_get_lang dictionary_id ='38511.Özel Tanımlar'></option>
                                        <cfloop query="get_offer_currencies">
                                            <option value="#offer_currency_id#" <cfif attributes.currency_id eq offer_currency_id>selected</cfif>>#offer_currency#</option>
                                        </cfloop>
                                    </select>                        
                                </div>
                            </div>
                            <div class="form-group" id="listing_type">			
                                <label class="col col-12"><cf_get_lang dictionary_id='57468.Belge Bazında'>/<cf_get_lang dictionary_id='29539.Satır Bazında'></label>
                                <div class="col col-12">
                                    <select name="listing_type" id="listing_type">
                                        <option value="1" <cfif len(attributes.listing_type) and attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                                        <option value="2" <cfif len(attributes.listing_type) and attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                                    </select>                    
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-8 col-sm-12" type="column" sort="true" index="4">
                            <div class="form-group" id="item-start_date">
                                <label class="col col-12"><cf_get_lang dictionary_id ='38655.Teklif Tarihi'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message_offer"><cf_get_lang dictionary_id='38656.Teklif Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                            <cfinput maxlength="10" type="text" name="start_date" validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
                                        <cfelse>
                                            <cfinput required="Yes" message="#message_offer#" maxlength="10" type="text" name="start_date"  validate="#validate_style#" value="#dateformat(attributes.start_date,dateformat_style)#">
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                                            <cfinput type="text" maxlength="10" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#">
                                        <cfelse>
                                            <cfinput required="Yes" message="#message_offer#" type="text" maxlength="10" name="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#"  validate="#validate_style#" style="width:65px;">
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-public_start_date">
                                <label class="col col-12"><cf_get_lang dictionary_id ='38512.Yayın Tarihi'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message_public"><cf_get_lang dictionary_id='38596.Yayın Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfinput type="text" name="public_start_date" value="#dateformat(attributes.public_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message_public#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="public_start_date"></span>
                                        <span class="input-group-addon no-bg"></span>
                                        <cfinput type="text" name="public_finish_date" value="#dateformat(attributes.public_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message_public#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="public_finish_date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfoutput>
                </cf_box_search_detail>
            </cf_box>
        </div>
    </cfform>
    <cfset url_str = "&is_form_submit=1">
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfif len(attributes.keyword)>
            <cfset url_str = url_str & "&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.offer_number)>
            <cfset url_str = url_str & "&offer_number=#attributes.offer_number#">
        </cfif>
        <cfif len(attributes.currency_id)>
            <cfset url_str = url_str & "&currency_id=#attributes.currency_id#">
        </cfif>
        <cfif len(attributes.offer_stage)>
            <cfset url_str = url_str & "&offer_stage=#attributes.offer_stage#">
        </cfif>
        <cfif len(attributes.public_partner)>
            <cfset url_str = url_str & "&public_partner=#attributes.public_partner#">
        </cfif>
        <cfif len(attributes.order_by_date)>
            <cfset url_str = url_str & "&order_by_date=#attributes.order_by_date#">
        </cfif>
        <cfif len(attributes.assc_offers)>
            <cfset url_str = url_str & "&assc_offers=#attributes.assc_offers#">
        </cfif>
        <cfif isdefined("attributes.offer_status")>
            <cfset url_str = url_str & "&offer_status=#attributes.offer_status#">
        </cfif>
        <cfif len(attributes.employee_id)>
            <cfset url_str = url_str & "&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
        </cfif>
        <cfif len(attributes.company_id) and len(attributes.company)>
            <cfset url_str = url_str & "&company_id=#attributes.company_id#&company=#attributes.company#">
        </cfif>
        <cfif len(attributes.consumer_id) and len(attributes.company)>
            <cfset url_str = url_str & "&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
        </cfif>
        <cfif len(attributes.listing_type)>
            <cfset url_str = url_str & "&listing_type=#attributes.listing_type#">
        </cfif>
        <cfif len(attributes.start_date)>
            <cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
        </cfif>
        <cfif len(attributes.finish_date)>
            <cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
        </cfif>
        <cfif len(attributes.public_start_date)>
            <cfset url_str = url_str & "&public_start_date=#dateformat(attributes.public_start_date,dateformat_style)#">
        </cfif>
        <cfif len(attributes.public_finish_date)>
            <cfset url_str = url_str & "&public_finish_date=#dateformat(attributes.public_finish_date,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
        <cfset url_str = "#url_str#&project_id=#attributes.project_id#">
        </cfif>
        <cfif isdefined("attributes.project_head") and len(attributes.project_head)>
        <cfset url_str = "#url_str#&project_head=#attributes.project_head#">
        </cfif>
    </cfif>
    <cfform name="listOffers" id="listOffers" method="post" action="">
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <cf_box hide_table_column="1" scroll="1" uidrop="1" id="list_offer_details" title="#getLang(33,'Satın Alma Teklifleri',38520)#" woc_setting = "#{ checkbox_name : 'print_offer_id', print_type : 90 }#">
                <cf_grid_list sort="1">
                    <thead>
                        <tr>
                            <cfif isDefined("attributes.assc_offers") and attributes.assc_offers eq 1>
                                <th><cf_get_lang dictionary_id ='58680.İlişki'><cf_get_lang dictionary_id='57487.No'></th>
                            </cfif>        
                            <th width="50"><cf_get_lang dictionary_id='57880.Belge no'></th>
                            <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                            <th><cf_get_lang dictionary_id='57416.Proje'></th>
                            <cfif xml_show_ref_no eq 1>
                                <th><cf_get_lang dictionary_id='58784.Referans'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                            <th>
                                <cfif len(attributes.listing_type) and attributes.listing_type eq 2>
                                    <cf_get_lang dictionary_id='57657.Ürün'>
                                <cfelse>
                                    <cf_get_lang dictionary_id='57480.Konu'>
                                </cfif>
                            </th>
                            <th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
                            <cfif len(attributes.listing_type) and attributes.listing_type eq 1>
                                <th><cf_get_lang dictionary_id='57645.Teslim Tarihi'></th>
                                <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                                <th><cf_get_lang dictionary_id='29500.Sevk Yöntemi'></th>
                                <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                            </cfif>
                            <cfif len(attributes.listing_type) and attributes.listing_type eq 1>
                                <th><cf_get_lang dictionary_id="39067.Kdv siz Toplam"></th>
                                <th><cf_get_lang dictionary_id ='58474.Para Br'></th>
                            </cfif>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th><cf_get_lang dictionary_id ='58474.Para Br'></th>
                            <th><cf_get_lang dictionary_id='57677.Döviz'><cf_get_lang dictionary_id='57673.Tutar'></th>
                            <th><cf_get_lang dictionary_id ='58474.Para Br'></th>
                            <!-- sil -->
                            <cfif len(attributes.listing_type) and attributes.listing_type eq 2>
                                <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                                <th><cf_get_lang dictionary_id='58444.Kalan'></th>
                            </cfif>
                            <th style="width:20px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.list_offer&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                                <cfif listfirst(attributes.fuseaction,'.') eq 'purchase' and len(attributes.offer_stage)>
                                    <th width="20"><input class="checkControl" type="checkbox" id="checkAll" name="checkAll" value="0"/></th>
                                </cfif>
                                <cfif  get_offer_list.recordcount>
                                    <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                                        <cfif get_offer_list.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a> </cfif> 
                                        <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_offer_id');">
                                    </th>
                                </cfif>
                            <!-- sil -->
                        </tr>
                    </thead>
                    <cfif get_offer_list.recordcount>
                        <cfset member_list = "">
                        <cfset consumer_list = "">
                        <cfset emp_list = "">
                        <cfset process_list = "">
                        <cfset shipmethod_list = "">
                        <cfset paymethod_list = "">
                        <cfset for_offer_list = "">
                        <cfoutput query="get_offer_list" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                            <cfif len(listdeleteduplicates(offer_to)) and not listfind(member_list,listdeleteduplicates(offer_to))>
                                <cfset member_list=listappend(member_list,listdeleteduplicates(offer_to))>
                            </cfif>
                            <cfif len(listdeleteduplicates(offer_to_consumer)) and not listfind(consumer_list,listdeleteduplicates(offer_to_consumer))>
                                <cfset consumer_list=listappend(consumer_list,listdeleteduplicates(offer_to_consumer))>
                            </cfif>
                            <cfif len(sales_emp_id) and not listfind(emp_list,sales_emp_id)>
                                <cfset emp_list=listappend(emp_list,sales_emp_id)>
                            </cfif>
                            <cfif len(offer_stage) and not listfind(process_list,offer_stage)>
                                <cfset process_list=listappend(process_list,offer_stage)>
                            </cfif>
                            <cfif len(ship_method) and not listfind(shipmethod_list,ship_method)>
                                <cfset shipmethod_list=listappend(shipmethod_list,ship_method)>
                            </cfif>
                            <cfif len(paymethod) and not listfind(paymethod_list,paymethod)>
                                <cfset paymethod_list=listappend(paymethod_list,paymethod)>
                            </cfif>
                            <cfif len(for_offer_id) and not listfind(for_offer_list,for_offer_id)>
                                <cfset for_offer_list=listappend(for_offer_list,for_offer_id)>
                            </cfif>
                        </cfoutput>
                        <cfif len(member_list)>
                            <cfquery name="get_member_name" datasource="#dsn#">
                                SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#member_list#) ORDER BY COMPANY_ID
                            </cfquery>
                            <cfset member_list = listsort(listdeleteduplicates(valuelist(get_member_name.company_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(consumer_list)>
                            <cfquery name="get_consumer_name" datasource="#dsn#">
                                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_list#) ORDER BY CONSUMER_ID
                            </cfquery>
                            <cfset consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer_name.consumer_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(emp_list)>
                            <cfquery name="get_emp_name" datasource="#dsn#">
                                SELECT EMPLOYEE_ID, EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_list#) ORDER BY EMPLOYEE_ID
                            </cfquery>
                            <cfset emp_list = listsort(listdeleteduplicates(valuelist(get_emp_name.employee_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(process_list)>
                            <cfquery name="get_process_name" datasource="#dsn#">
                                SELECT PROCESS_ROW_ID, STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) ORDER BY PROCESS_ROW_ID
                            </cfquery>
                            <cfset process_list = listsort(listdeleteduplicates(valuelist(get_process_name.process_row_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(shipmethod_list)>
                            <cfquery name="get_shipmethod_name" datasource="#dsn#">
                                SELECT SHIP_METHOD_ID, SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID IN (#shipmethod_list#) ORDER BY SHIP_METHOD_ID
                            </cfquery>
                            <cfset shipmethod_list = listsort(listdeleteduplicates(valuelist(get_shipmethod_name.ship_method_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(paymethod_list)>
                            <cfquery name="get_paymethod_name" datasource="#dsn#">
                                SELECT PAYMETHOD_ID, PAYMETHOD FROM SETUP_PAYMETHOD WHERE PAYMETHOD_ID IN (#paymethod_list#) ORDER BY PAYMETHOD_ID
                            </cfquery>
                            <cfset paymethod_list = listsort(listdeleteduplicates(valuelist(get_paymethod_name.paymethod_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif len(for_offer_list)>
                            <cfquery name="get_for_offer_name" datasource="#dsn3#">
                                SELECT OFFER_ID, OFFER_NUMBER,PROJECT_ID FROM OFFER WHERE OFFER_ID IN (#for_offer_list#) ORDER BY OFFER_ID
                            </cfquery>
                            <cfset for_offer_list = listsort(listdeleteduplicates(valuelist(get_for_offer_name.offer_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <tbody>
                        <cfoutput query="get_offer_list" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                            <tr>
                                <cfif isDefined("attributes.assc_offers") and attributes.assc_offers eq 1>
                                    <td><cfif len(for_offer_id)><a href="#request.self#?fuseaction=purchase.list_offer&event=det&offer_id=#for_offer_id#">#get_for_offer_name.offer_number[listfind(for_offer_list,for_offer_id,',')]#</a></cfif></td>
                                </cfif>
                                <td><a href="#request.self#?fuseaction=purchase.list_offer&event=det&offer_id=#offer_id#">#OFFER_NUMBER#</a></td>
                                <td><cfif len(offer_stage)><cf_workcube_process type="color-status" process_stage="#offer_stage#"></cfif></td>
                                <td><cfif len(PROJECT_ID)>#GET_PROJECT_NAME(PROJECT_ID)#</cfif></td>
                                <cfif xml_show_ref_no eq 1>
                                    <td title="#ref_no#">#left(ref_no,50)#</td>
                                </cfif>
                                <td >#dateformat(offer_date,dateformat_style)#</td>
                                <cfif len(attributes.listing_type) and attributes.listing_type eq 2>
                                    <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>','list');">#product_name#</a></td>
                                <cfelse>
                                    <cfset detay = replace(OFFER_HEAD,'"',"'",'all')>
                                    <td title="#detay#"><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#offer_id#">#left(OFFER_HEAD,20)#</a></td>
                                </cfif>
                                <td><cfif listlen(offer_to)>
                                        <cfloop list="#offer_to#" index="oc">
                                            #get_member_name.fullname[listfind(member_list,oc,',')]#
                                            <cfif listlast(offer_to) neq oc>,<br/></cfif>
                                        </cfloop>
                                    </cfif>
                                    <cfif listlen(offer_to)><br /></cfif>
                                    <cfif ListLen(offer_to_consumer)>
                                        <cfloop list="#offer_to_consumer#" index="oc">
                                            #get_consumer_name.consumer_name[listfind(consumer_list,oc,',')]# #get_consumer_name.consumer_surname[listfind(consumer_list,oc,',')]#
                                            <cfif listlast(offer_to_consumer) neq oc>,<br/></cfif>
                                        </cfloop>
                                    </cfif>
                                </td>
                                <cfif len(attributes.listing_type) and attributes.listing_type eq 1>
                                    <td>#dateformat(deliverdate,dateformat_style)#</td>
                                    <td><cfif len(sales_emp_id)>#get_emp_name.employee_name[listfind(emp_list,sales_emp_id,',')]# #get_emp_name.employee_surname[listfind(emp_list,sales_emp_id,',')]#</cfif></td>
                                    <td><cfif len(ship_method)>#get_shipmethod_name.ship_method[listfind(shipmethod_list,ship_method,',')]#</cfif></td>
                                    <td><cfif len(paymethod)>#get_paymethod_name.paymethod[listfind(paymethod_list,paymethod,',')]#</cfif></td>
                                </cfif>
                                <cfif len(attributes.listing_type) and attributes.listing_type eq 1>
                                    <cfset get_offer_kdvsiz = get_offer_list_action.get_offer_kdvsiz(offer_id : offer_id)>
                                    <td class="text-right">#TLFormat(get_offer_kdvsiz.KDVSIZ_TOPLAM)#</td>
                                    <td class="text-right">#session.ep.money#</td>
                                </cfif>
                                <td style="text-align:right;"><cfif attributes.listing_type eq 1>#TLFormat(total_price(offer_id,1,attributes.listing_type))#<cfelse>#TLFormat(total_price(offer_row_id,1,attributes.listing_type))#</cfif></td>
                                <td style="text-align:right;">#session.ep.money#</td>
                                <td style="text-align:right;"><cfif attributes.listing_type eq 1>#TLFormat(total_price(offer_id,2,attributes.listing_type))#<cfelse>#TLFormat(total_price(offer_row_id,2,attributes.listing_type))#</cfif></td>
                                <td style="text-align:right;">
                                    <cfif len(other_money_value)>
                                        <cfif session.ep.period_year gte 2009 and len(other_money) and other_money is 'YTL'>#session.ep.money#
                                        <cfelseif session.ep.period_year lt 2009 and len(other_money) and other_money is 'TL'>#session.ep.money#
                                        <cfelse>#other_money#</cfif>
                                    </cfif>
                                </td>
                                <!-- sil -->
                                <cfif len(attributes.listing_type) and attributes.listing_type eq 2>
                                    <cfquery name="get_used_amount" datasource="#dsn3#">
                                        SELECT
                                            SUM(QUANTITY) QUANTITY
                                        FROM
                                            ORDER_ROW
                                        WHERE
                                            WRK_ROW_RELATION_ID = '#wrk_row_id#' AND
                                            STOCK_ID = #stock_id# AND
                                            PRODUCT_ID = #product_id#
                                            <!---  AND
                                            RELATED_ACTION_TABLE = 'OFFER' AND
                                            RELATED_ACTION_ID = #offer_id# --->
                                    </cfquery>
                                    <cfif len(get_used_amount.quantity)>
                                        <cfset 'used_amount_#offer_id#_#wrk_row_id#' = get_used_amount.quantity>
                                    <cfelse>
                                        <cfset 'used_amount_#offer_id#_#wrk_row_id#' = 0>
                                    </cfif>
                                    <td style="text-align:right;">#quantity# #unit#</td>
                                    <input type="hidden" name="offer_amount_list" id="offer_amount_list" value="">
                                    <cfset 'offer_amount_#offer_id#_#wrk_row_id#' = get_offer_list.quantity>
                                    <cfset 'offer_amount_#offer_id#_#wrk_row_id#' = Evaluate('offer_amount_#offer_id#_#wrk_row_id#') - Evaluate('used_amount_#offer_id#_#wrk_row_id#')>
                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='38519.Miktarı Kontrol Ediniz'></cfsavecontent>
                                    <td><input type="text" name="offer_amount_#offer_id#_#wrk_row_id#" id="offer_amount_#offer_id#_#wrk_row_id#" onblur="if(filterNum(this.value,4)=='' || filterNum(this.value,4)==0)this.value=commaSplit(1);if(filterNum(this.value,4)> #evaluate('offer_amount_#offer_id#_#wrk_row_id#')#){alert('<cf_get_lang dictionary_id="58883.Maksimum Kalan Miktar"> : #evaluate('offer_amount_#offer_id#_#wrk_row_id#')#\ !');this.value=#TLFormat(evaluate('offer_amount_#offer_id#_#wrk_row_id#'))#;}" onkeyup="return(FormatCurrency(this,event,4));" validate="float" value="#TLFormat(evaluate('offer_amount_#offer_id#_#wrk_row_id#'),4)#" range="0,#evaluate('offer_amount_#offer_id#_#wrk_row_id#')#" style="width:100%" message="#message#" <cfif Evaluate('offer_amount_#offer_id#_#wrk_row_id#') lte 0>disabled</cfif>></td>
                                    <td><input type="checkbox" name="offer_row_check_info" id="offer_row_check_info" value="#offer_id#_#wrk_row_id#" <cfif Evaluate('offer_amount_#offer_id#_#wrk_row_id#') lte 0>disabled</cfif>></td>
                                <cfelse>
                                    <td><a href="#request.self#?fuseaction=purchase.list_offer&event=upd&offer_id=#offer_id#"><i class="fa fa-pencil"></i></a></td>			  
                                </cfif>
                                <td style="text-align:center"><input type="checkbox" class="checkControl" name="print_offer_id" id="print_offer_id" value="#offer_id#"></td>
                                <!-- sil -->
                            </tr>
                    </cfoutput>
                    </tbody>
                    </cfif>
                </cf_grid_list>
                <cfif not get_offer_list.recordcount>
                    <cfif isdefined("attributes.is_form_submit")>
                        <div class="ui-info-bottom">
                            <p><cf_get_lang dictionary_id ='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'></cfif>!</p>  
                        </div>
                    </cfif>
                <cf_paging 
                name="listOffers"
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="purchase.list_offer#url_str#"
                is_form="1">
            </cf_box>
            <cfif isdefined("attributes.is_form_submit") and len(attributes.is_form_submit) and get_offer_list.recordcount>
                <cf_box id="list_checked" collapsable="0" resize="0" closable="0" title="#getLang('','',46186)#" >
                    <cf_box_elements vertical="1">
                        <div class="col col-4 col-xs-12">
                            <cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
                            faction_list : 'purchase.list_offer',
                            filter_stage: '#attributes.offer_stage#')>
                            <cf_workcube_general_process print_type="90" select_value = '#get_process_f.process_row_id#'>						
                        </div>
                    </cf_box_elements>
                <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
                    <div class="ui-form-list-btn">
                        <input type="hidden" id="paper_submit" name="paper_submit" value="0">
                        <div>
                            <input type="submit" name="setOfftimeProcess" id="setOfftimeProcess" onclick="if(confirm('<cf_get_lang dictionary_id='57535.Kaydetmek istediğinize emin misiniz'>')) return setofftimesProcess(); else return false;" value="<cf_get_lang dictionary_id='63959.Seçili satırlar için Süreç- Aşama Düzenle'>">
                                <cfif len(attributes.listing_type) and attributes.listing_type eq 2>
                                    <cfsavecontent variable="insertmessage"><cf_get_lang dictionary_id ='63984.Seçili Teklif Satırları için Satın Alma Siparişi oluştur'></cfsavecontent>
                                    <cf_workcube_buttons is_upd='0' add_function="addOrder()" is_cancel='0' insert_info='#insertmessage#' insert_alert=''>
                                </cfif>
                            </div>
                        </div>
                    </div>
                </cf_box>
            <cfelse>
                <cfif len(attributes.listing_type) and attributes.listing_type eq 2>
                    <cf_box>
                        <div>
                            <cfsavecontent variable="insertmessage"><cf_get_lang dictionary_id ='63984.Seçili Teklif Satırları için Satın Alma Siparişi oluştur'></cfsavecontent>
                            <cf_workcube_buttons is_upd='0' add_function="addOrder()" is_cancel='0' insert_info='#insertmessage#' insert_alert=''>
                        </div>
                </cf_box>
                </cfif>
            </cfif>
        </div>
    </cfform>

<script type="text/javascript">
    document.getElementById('keyword').focus();
    $(function(){
            $('input[name=checkAll]').click(function(){
                if(this.checked){
                    $('.checkControl').each(function(){
                        $(this).prop("checked", true);
                    });
                }
                else{
                    $('.checkControl').each(function(){
                        $(this).prop("checked", false);
                    });
                }
            });
        });
    function addOrder(){
        
            var selected_prod = 0;
            var product_leng = document.getElementsByName('offer_row_check_info').length;
            for(Pind=0;Pind<product_leng;Pind=Pind+1){
                my_obj_prod = (product_leng == 1)?document.getElementById('offer_row_check_info'):document.listOffers.offer_row_check_info[Pind];
                if(my_obj_prod.checked == true){
                    selected_prod++;
                }
            }	
            if(selected_prod==0){
                alert("<cf_get_lang dictionary_id='54563.En az bir satır seçmelisiniz'>!");
                return false;
            }
            else{
                document.listOffers.action = '<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.list_order&event=add';
                document.listOffers.submit();
            }
            return true;
	}
    function setofftimesProcess(){
		var controlChc = 0;
		$('.checkControl').each(function(){
			if(this.checked){
				controlChc += 1;
			}
		});
		if(controlChc == 0){
			alert("<cf_get_lang dictionary_id='57545.Teklif'><cf_get_lang dictionary_id='57734.Seçiniz'>!");
			return false;
		}
		if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if( $.trim($('#general_paper_date').val()) == '' ){
			alert("<cf_get_lang dictionary_id='62954.Lütfen Belge Tarihi Giriniz'>!");
			return false;
		}
		if( $.trim($('#general_paper_notice').val()) == '' ){
			alert("<cf_get_lang dictionary_id='62955.Lütfen Ek Açıklama Giriniz'>!");
			return false;
		}
		document.getElementById("paper_submit").value = 1;
		$('#listOffers').submit();
		
	}
</script>
