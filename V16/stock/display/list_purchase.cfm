<cfsetting showdebugoutput="yes">
 <cf_xml_page_edit fuseact="stock.list_purchase">
<cf_get_lang_set module_name="stock"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="is_show_detail_search" default="1">
<cfsetting showdebugoutput="yes">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.invoice_action" default=''>
<cfparam name="attributes.oby" default=1>
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.company_id_2" default="">
<cfparam name="attributes.consumer_id_2" default="">
<cfparam name="attributes.employee_id_2" default="">
<cfparam name="attributes.partner_id_2" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.EMPO_ID" default="">
<cfparam name="attributes.EMP_PARTNER_NAMEO" default="">
<cfparam name="attributes.product_cat_code" default="-2">
<cfparam name="attributes.product_cat_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.location_name" default="">
<cfparam name="attributes.department_out" default="">
<cfparam name="attributes.location_out" default="">
<cfparam name="attributes.location_out_name" default="">
<cfparam name="attributes.delivered" default=''>
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.project_id_in" default="">
<cfparam name="attributes.project_head_in" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.work_id" default="">
<cfparam name="attributes.work_head" default="">
<cfparam name="attributes.disp_ship_state" default="">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_name" default="">
<cfparam name="attributes.row_department_id" default="">
<cfparam name="attributes.row_location_name" default="">
<cfparam name="attributes.row_location_id" default="">
<cfparam name="attributes.row_project_id" default="">
<cfparam name="attributes.row_project_head" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.eshipment_type" default="">
<cfparam name="attributes.spect_var_id" default="">
<cfif xml_list_cancel_stock eq 1>
    <cfparam name="attributes.iptal_stocks" default="1">
<cfelseif xml_list_cancel_stock eq 0>
	 <cfparam name="attributes.iptal_stocks" default="0">
<cfelse>
	 <cfparam name="attributes.iptal_stocks" default="">
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.IS_STORE <>2 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	<cfif session.ep.isBranchAuthorization>
		AND B.BRANCH_ID = #listgetat(session.ep.user_location, 2, '-')#
	</cfif>
	<cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
		AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">
	</cfif>
	<cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
		AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
	</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD,
		COMMENT
</cfquery>
<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
	<cf_date tarih="attributes.date2">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.date2 = ''>
	<cfelse>
		<cfset attributes.date2 = wrk_get_today()>
	</cfif>
</cfif>
<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
	<cf_date tarih="attributes.date1">
<cfelse>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.date1 = ''>
		<cfelse>
	<cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
	</cfif>
</cfif>
<cfif isdate(attributes.record_date)>
	<cf_date tarih="attributes.record_date">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
        get_ship_fis_action = createObject("component", "V16.stock.cfc.get_purchases");
        get_ship_fis_action.dsn = dsn;
        get_ship_fis_action.dsn2 = dsn2;
        get_ship_fis_action.dsn_alias = dsn_alias;
        get_ship_fis_action.dsn1_alias = dsn1_alias;
        get_ship_fis_action.dsn3_alias = dsn3_alias;
        get_ship_fis = get_ship_fis_action.GET_SHIP_FIS_fnc
            (
                cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
                consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
                company : '#IIf(IsDefined("attributes.company") and len(attributes.company),"attributes.company",DE(""))#',
                company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
                invoice_action : '#IIf(IsDefined("attributes.invoice_action"),"attributes.invoice_action",DE(""))#',
                listing_type : '#IIf(IsDefined("attributes.listing_type"),"attributes.listing_type",DE(""))#',
                record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
                date1 : '#IIf(IsDefined("attributes.date1"),"attributes.date1",DE(""))#',
                date2 : '#IIf(IsDefined("attributes.date2"),"attributes.date2",DE(""))#',
                department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
				department_out : '#IIf(IsDefined("attributes.department_out"),"attributes.department_out",DE(""))#',
				location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
				location_out : '#IIf(IsDefined("attributes.location_out"),"attributes.location_out",DE(""))#',
                module_name : '#fusebox.circuit#',
                belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
                project_id : '#IIf(IsDefined("attributes.project_id") and len(attributes.project_head),"attributes.project_id",DE(""))#',
				project_id_in : '#IIf(IsDefined("attributes.project_id_in") and len(attributes.project_head_in),"attributes.project_id_in",DE(""))#',
                subscription_id : '#IIf(IsDefined("attributes.subscription_id"),"attributes.subscription_id",DE(""))#',
                subscription_no : '#IIf(IsDefined("attributes.subscription_no"),"attributes.subscription_no",DE(""))#',
                employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
                iptal_stocks : '#IIf(IsDefined("attributes.iptal_stocks"),"attributes.iptal_stocks",DE(""))#',
                stock_id : '#IIf(IsDefined("attributes.stock_id"),"attributes.stock_id",DE(""))#',
                product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
                product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
                product_cat_name : '#IIf(IsDefined("attributes.product_cat_name"),"attributes.product_cat_name",DE(""))#',
                delivered : '#IIf(IsDefined("attributes.delivered"),"attributes.delivered",DE(""))#',
                deliver_emp : '#IIf(IsDefined("attributes.deliver_emp"),"attributes.deliver_emp",DE(""))#',
                deliver_emp_id : '#IIf(IsDefined("attributes.deliver_emp_id"),"attributes.deliver_emp_id",DE(""))#',
                company_id_2 : '#IIf(IsDefined("attributes.company_id_2"),"attributes.company_id_2",DE(""))#',
                member_name : '#IIf(IsDefined("attributes.member_name"),"attributes.member_name",DE(""))#',
                consumer_id_2 : '#IIf(IsDefined("attributes.consumer_id_2"),"attributes.consumer_id_2",DE(""))#',
                employee_id_2 : '#IIf(IsDefined("attributes.employee_id_2"),"attributes.employee_id_2",DE(""))#',
				partner_id_2 : '#IIf(IsDefined("attributes.partner_id_2"),"attributes.partner_id_2",DE(""))#',
				lot_no : '#IIf(IsDefined("attributes.lot_no"),"attributes.lot_no",DE(""))#',
                oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
				work_id : '#IIf(len(attributes.work_head) and len("attributes.work_id"),"attributes.work_id",DE(""))#',
				startrow : '#IIf(len(attributes.startrow) and len("attributes.startrow"),"attributes.startrow",DE(""))#',
				maxrows :  '#IIf(len(attributes.maxrows) and len("attributes.maxrows"),"attributes.maxrows",DE(""))#',
         		disp_ship_state : '#IIf(IsDefined("attributes.disp_ship_state"),"attributes.disp_ship_state",DE(""))#',
				record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
				record_name : '#IIf(IsDefined("attributes.record_name"),"attributes.record_name",DE(""))#',
				row_department_id : '#IIf(IsDefined("attributes.row_department_id"),"attributes.row_department_id",DE(""))#',
				row_location_id : '#IIf(IsDefined("attributes.row_location_id"),"attributes.row_location_id",DE(""))#',
				xml_department_filter : '#IIf(IsDefined("xml_department_filter"),"xml_department_filter",DE(""))#',
				xml_project_filter : '#IIf(IsDefined("xml_project_filter"),"xml_project_filter",DE(""))#',
				row_project_id : '#IIf(IsDefined("attributes.row_project_id"),"attributes.row_project_id",DE(""))#',
                row_project_head : '#IIf(IsDefined("attributes.row_project_head"),"attributes.row_project_head",DE(""))#',
                EMPO_ID : '#IIf(IsDefined("attributes.EMPO_ID"),"attributes.EMPO_ID",DE(""))#',
                EMP_PARTNER_NAMEO : '#IIf(IsDefined("attributes.EMP_PARTNER_NAMEO"),"attributes.EMP_PARTNER_NAMEO",DE(""))#',
                process_stage : '#IIf(IsDefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
                eshipment_type: '#IIf(len(attributes.eshipment_type),"attributes.eshipment_type",DE(""))#',
                spect_var_id: '#IIf(len(attributes.spect_var_id),"attributes.spect_var_id",DE(""))#'
		 );
	</cfscript> 
<cfelse>
	<cfset get_ship_fis.recordcount = 0>
</cfif>
<cfset islem_tipi = '78,81,82,83,87,112,113,114,811,761,70,71,72,73,74,75,76,77,79,80,84,85,86,88,110,111,115,116,118,1182,119,140,141,811,1131'>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT,DESPATCH_ADVICE_TYPE FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfset stock_fis_ = 0>
       

<cfif get_ship_fis.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_ship_fis.query_count#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="frm_search" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_purchase">
            <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
            <cfif IsDefined("attributes.spect_var_id") and len(attributes.spect_var_id)>
                <cfinput type="hidden" name="spect_var_id" id="spect_var_id" value="#attributes.spect_var_id#">
            </cfif>
            <cf_box_search>
                <div class="form-group">
                    <cfinput type="text" name="belge_no" id="belge_no" value="#attributes.belge_no#" maxlength="50" placeholder=" #getLang(468,'Belge no',57880)#">
                </div>
                <div class="form-group">
                    <cfif xml_show_lot_no eq 1>
                        <cfinput type="text" name="lot_no" id="lot_no" value="#attributes.lot_no#" placeholder=" #getLang(321,'Lot no',45498)#">
                    </cfif>
                </div>
                <div class="form-group">
                    <select name="oby" id="oby">
                        <option value="1"<cfif attributes.oby eq 1> selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                        <option value="2"<cfif attributes.oby eq 2> selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                        <option value="3"<cfif attributes.oby eq 3> selected</cfif>><cf_get_lang dictionary_id='29459.Artan No'></option>
                        <option value="4"<cfif attributes.oby eq 4> selected</cfif>><cf_get_lang dictionary_id='29458.Azalan No'></option>
                        <cfif attributes.listing_type neq 1>
                            <option id="stock_asc" value="5"<cfif attributes.oby eq 5> selected</cfif>><cf_get_lang dictionary_id='61104.Stok Kodu Bazında Artan'></option>
                            <option id="stock_desc" value="6"<cfif attributes.oby eq 6> selected</cfif>><cf_get_lang dictionary_id='61105.Stok Kodu Bazında Azalan'></option>
                        </cfif>
                    </select>
                </div>
                <div class="form-group">
                    <select name="listing_type" id="listing_type" onchange="cat_control();">
                        <option value="1" <cfif attributes.listing_type eq 1> selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                        <option value="2" <cfif attributes.listing_type eq 2> selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#getLang('','Kayıt Sayısı Hatalı',57537)#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button search_function='input_control()' button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12 column" type="column" index="1" id="column-1" sort="true">
                    <div class="form-group" id="item-iptal_stocks">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57452.Stok'> <cf_get_lang dictionary_id ='30111.Durumu'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="iptal_stocks" id="iptal_stocks">
                                <option value=""><cf_get_lang dictionary_id ='57452.Stok'> <cf_get_lang dictionary_id ='30111.Durumu'></option>
                                <option value="1" <cfif attributes.iptal_stocks eq 1> selected</cfif>><cf_get_lang dictionary_id='58816.İptal Edilenler'></option>
                                <option value="0" <cfif attributes.iptal_stocks eq 0> selected</cfif>><cf_get_lang dictionary_id='58817.İptal Edilmeyenler'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item_product_cat_code">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                <input name="product_cat_name" type="text" id="product_cat_name" onfocus="AutoComplete_Create('product_cat_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_cat_code','','3','200');" value="<cfif len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_name#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=frm_search.product_cat_code&field_name=frm_search.product_cat_name</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>  
                    <cfif session.ep.our_company_info.subscription_contract eq 1>
                        <div class="form-group" id="item_subscription_id">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58832.Abone'></label>
                            <div class="col col-12 col-xs-12">
                                <cf_wrk_subscriptions subscription_id='#attributes.subscription_id#' subscription_no='#attributes.subscription_no#' width_info='125' fieldid='subscription_id' fieldname='subscription_no' form_name='frm_search' img_info='plus_thin'>
                            </div>
                        </div>
                    </cfif>
                    <cfif isdefined("xml_is_record_emp") and xml_is_record_emp eq 1>
                        <div class="form-group" id="item_record_emp_id">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                            <div class="col col-12 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif isdefined("attributes.record_emp_id")><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                    <input name="record_name" type="text" id="record_name" onfocus="AutoComplete_Create('record_name','FULLNAME','FULLNAME','get_emp_pos','','EMPLOYEE_ID','record_emp_id','','3','130');" value="<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)><cfoutput>#attributes.record_name#</cfoutput></cfif>" maxlength="255" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=frm_search.record_emp_id&field_name=frm_search.record_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=1&is_form_submitted=1&keyword='+encodeURIComponent(document.frm_search.record_name.value));"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="form_ul_EMP_PARTNER_NAMEO">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57021.Satış Yapan'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)><cfoutput>#attributes.EMPO_ID#</cfoutput></cfif>">
                                <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="<cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)><cfoutput>#attributes.PARTO_ID#</cfoutput></cfif>" >
                                <input type="text" name="EMP_PARTNER_NAMEO" id="EMP_PARTNER_NAMEO" value="<cfif isdefined("attributes.EMP_PARTNER_NAMEO") and len(attributes.EMP_PARTNER_NAMEO)><cfoutput>#attributes.EMP_PARTNER_NAMEO#</cfoutput></cfif>" onfocus="AutoComplete_Create('EMP_PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=frm_search.EMP_PARTNER_NAMEO&field_partner=frm_search.PARTO_ID&field_EMP_id=frm_search.EMPO_ID</cfoutput>')"></span>
                            </div>
                        </div>
                    </div>      
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12 column" type="column" index="2" id="column-2" sort="true">
                    <div class="form-group" id="item-invoice_action">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='45442.Fatura Hareketleri'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="invoice_action" id="invoice_action">
                                <option value=""><cf_get_lang dictionary_id='45442.Fatura Hareketleri'></option>
                                <option value="1"<cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 1> selected</cfif>><cf_get_lang dictionary_id='45443.Faturalanmış'></option>
                                <option value="2"<cfif isDefined('attributes.invoice_action') and attributes.invoice_action eq 2> selected</cfif>><cf_get_lang dictionary_id='45444.Faturalanmamış'></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item_stock_id">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                                <input name="product_name" type="text" id="product_name"  onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','','3','130');" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=frm_search.stock_id&field_name=frm_search.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.frm_search.product_name.value));"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_company">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(attributes.company) and isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">				
                                <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company) and isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                <input type="hidden" name="employee_id" id="employee_id" value="<cfif len(attributes.company) and isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                <input type="text" name="company" id="company" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','consumer_id,company_id,employee_id','','3','250');" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_name=frm_search.company&field_emp_id=frm_search.employee_id&field_consumer=frm_search.consumer_id&field_member_name=frm_search.company&field_comp_name=frm_search.company&field_comp_id=frm_search.company_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3,1,9&keyword='+encodeURIComponent(document.frm_search.company.value));"></span>
                            </div>
                        </div>        
                    </div>
                    <cfif isdefined("xml_is_deliver_emp") and xml_is_deliver_emp eq 1>
                        <div class="form-group" id="item_member_type">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57775.Teslim Alan'></label>
                            <div class="col col-12 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id_2" id="company_id_2" value="<cfif len(attributes.member_name) and isdefined("attributes.company_id_2")><cfoutput>#attributes.company_id_2#</cfoutput></cfif>">
                                    <input type="hidden" name="partner_id_2" id="partner_id_2" value="<cfif len(attributes.member_name) and isdefined("attributes.partner_id_2")><cfoutput>#attributes.partner_id_2#</cfoutput></cfif>">
                                    <input type="hidden" name="consumer_id_2" id="consumer_id_2" value="<cfif len(attributes.member_name) and isdefined("attributes.consumer_id_2")><cfoutput>#attributes.consumer_id_2#</cfoutput></cfif>">
                                    <input type="hidden" name="employee_id_2" id="employee_id_2" value="<cfif len(attributes.member_name) and isdefined("attributes.employee_id_2")><cfoutput>#attributes.employee_id_2#</cfoutput></cfif>">
                                    <input type="hidden" name="member_type" id="member_type" value="<cfif len(attributes.member_name) and isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                    <cfif isdefined("attributes.member_type")>
                                        <cfinput type="text" name="member_name" id="member_name" value="#attributes.member_name#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','consumer_id_2,company_id_2,employee_id_2','','3','250');">
                                    <cfelse>
                                        <cfinput type="text" name="member_name" id="member_name" value="" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','CONSUMER_ID,COMPANY_ID,EMPLOYEE_ID','consumer_id_2,company_id_2,employee_id_2','','3','250');">
                                    </cfif>                
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_partner=frm_search.partner_id_2&field_consumer=frm_search.consumer_id_2&field_comp_id=frm_search.company_id_2&field_emp_id=frm_search.employee_id_2&field_name=frm_search.member_name&field_type=frm_search.member_type&select_list=1,7,8');"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item_process_cat_id">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='57800.İşlem Tipi'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="cat" id="cat" onchange="cat_control();">
                                <option value=""><cf_get_lang dictionary_id ='57800.İşlem Tipi'></option>
                                <cfoutput query="get_process_cat" group="process_type">
                                    <option value="#process_type#-0" <cfif '#process_type#-0' is attributes.cat> selected</cfif>>#get_process_name(process_type)#</option>										
                                    <cfoutput>
                                        <option value="#process_type#-#process_cat_id#" <cfif attributes.cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
                                    </cfoutput>
                                </cfoutput>
                            </select>
                        </div>
                    </div> 
                </div>        
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12 column" type="column" index="3" id="column-3" sort="true">
                    <div class="form-group" id="item-delivered">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id ='34575.Teslim Durumu'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="delivered" id="delivered">
                                <option selected value=""><cf_get_lang dictionary_id ='34575.Teslim Durumu'></option>
                                <option value="1" <cfif isDefined('attributes.delivered') and attributes.delivered eq 1> selected</cfif>><cf_get_lang dictionary_id ='45616.Teslim Alındı'></option>
                                <option value="0" <cfif isDefined('attributes.delivered') and attributes.delivered eq 0> selected</cfif>><cf_get_lang dictionary_id ='45617.Teslim Alınmadı'></option>
                            </select>
                        </div>
                    </div> 
                    <cfif xml_department_filter eq 1>
                        <div class="form-group" id="item-department_id">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="45273.Giriş Depo"></label>
                            <div class="col col-12 col-xs-12">
                                <cf_wrkdepartmentlocation 
                                    returninputvalue="location_id,location_name,department_id"
                                    returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                    fieldname="location_name"
                                    fieldid="location_id"
                                    status="0"
                                    is_department="1"
                                    line_info="2"
                                    department_fldid="department_id"
                                    department_id="#attributes.department_id#"
                                    location_id="#attributes.location_id#"
                                    location_name="#attributes.location_name#"
                                    user_level_control="1"
                                    user_location = "0"
                                    width="125"
                                    >
                            </div>
                        </div>                    
                    </cfif>                
                    <cfif xml_project_filter eq 1>
                        <div class="form-group" id="item_project_head_in">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29757.Giris Proje'></label>
                            <div class="col col-12 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id_in" id="project_id_in" value="<cfif len(attributes.project_head_in)><cfoutput>#attributes.project_id_in#</cfoutput></cfif>">
                                    <input type="text" name="project_head_in" id="project_head_in" onfocus="AutoComplete_Create('project_head_in','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id_in','','3','125');" value="<cfoutput>#attributes.project_head_in#</cfoutput>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head_in&project_id=frm_search.project_id_in</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="row_project" <cfif attributes.listing_type neq 2>style="display:none"</cfif>>
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58508.Satır"> <cf_get_lang dictionary_id="57416.Proje"></label>
                        <div class="col col-12 col-xs-12">   
                            <div class="input-group">
                                <input type="hidden" name="row_project_id" id="row_project_id" value="<cfif len(attributes.row_project_head)><cfoutput>#attributes.row_project_id#</cfoutput></cfif>">
                                <input type="text" name="row_project_head" id="row_project_head" onfocus="AutoComplete_Create('row_project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','row_project_id','','3','125');" value="<cfoutput>#attributes.row_project_head#</cfoutput>" autocomplete="off">
                                <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.row_project_head&project_id=frm_search.row_project_id</cfoutput>');"></span>
                            </div>
                        </div>
                    </div>                
                    <div class="form-group" id="item_date2">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput type="text" maxlength="10" name="date1" value="#dateformat(attributes.date1,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>            
                                <span class="input-group-addon no-bg"></span>
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput type="text" maxlength="10" name="date2" value="#dateformat(attributes.date2,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item_record_date">
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                        <div class="col col-12 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'></cfsavecontent>
                                <cfinput type="text" maxlength="10" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>            
                            </div>
                        </div>
                    </div>   
                    <cfif session.ep.our_company_info.is_eshipment eq 1>
                        <div class="form-group" id="item_eshipment_type">
                            <label class="col col-12"><cf_get_lang dictionary_id ='60911.E-İrsaliye'></label>
                            <div class="col col-12">
                                <select name="eshipment_type" id="eshipment_type">
                                    <option value=""><cf_get_lang dictionary_id ='60911.E-İrsaliye'></option>
                                    <option value="1" <cfif attributes.eshipment_type eq 1>selected</cfif>><cf_get_lang dictionary_id='59329.Gönderilecekler'></option>
                                    <option value="2" <cfif attributes.eshipment_type eq 2>selected</cfif>><cf_get_lang dictionary_id="59337.Onay Bekleyenler"></option>
                                    <option value="3" <cfif attributes.eshipment_type eq 3>selected</cfif>><cf_get_lang dictionary_id='31752.Gönderilenler'></option>
                                </select>
                            </div>
                        </div>
                    </cfif>  
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12 column" type="column" index="4" id="column-4" sort="true">
                    <cfif xml_show_process_stage eq 1>
                        <div class="form-group" id="item-process_stage">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                            <div class="col col-12 col-xs-12">
                                <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' is_select_text='1' process_cat_width='150' is_detail='0'>
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_is_work_list eq 1>  
                        <div class="form-group" id="item_work_id">
                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58445.İş'></label>
                            <div class="col col-12 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="work_id" id="work_id" value="<cfoutput>#attributes.work_id#</cfoutput>">
                                    <input type="text" name="work_head" id="work_head" onfocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','0','WORK_ID','work_id','','3','130');" value="<cfoutput>#attributes.work_head#</cfoutput>">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=work_id&field_name=work_head');"></span>
                                </div>
                            </div>
                        </div>  
                    </cfif>
                    <div class="form-group" id="disp_ship_state_" <cfif attributes.listing_type neq 2>style="display:none"</cfif>>
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='61106.Dağıtım'></label>
                        <div class="col col-12 col-xs-12">
                            <select name="disp_ship_state" id="disp_ship_state"><!--- alım irsaliyelerinde dağıtım irsaliye filtresi hgul --->
                                <option selected value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
                                <option value="1" <cfif isDefined('attributes.disp_ship_state') and attributes.disp_ship_state eq 1> selected</cfif>><cf_get_lang dictionary_id='45330.Dağıtım Görmemiş'></option>
                                <option value="2" <cfif isDefined('attributes.disp_ship_state') and attributes.disp_ship_state eq 2> selected</cfif>><cf_get_lang dictionary_id='45332.Dağıtım Tamamlanmamış'></option>
                                <option value="3" <cfif isDefined('attributes.disp_ship_state') and attributes.disp_ship_state eq 3> selected</cfif>><cf_get_lang dictionary_id='45340.Dağıtım Tamamlanmış'></option>
                            </select>
                        </div>
                    </div> 
                    <cfif xml_department_filter neq 0>
                        <div class="form-group" id="item-department_out">
                            <label class="col col-12 col-xs-12"><cfif xml_department_filter eq 1><cf_get_lang dictionary_id="29428.Çıkış Depo"><cfelse><cf_get_lang dictionary_id="58763.Depo"></cfif></label>
                            <div class="col col-12 col-xs-12">
                                <cf_wrkdepartmentlocation 
                                    returninputvalue="location_out,location_out_name,department_out"
                                    returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                    fieldname="location_out_name"
                                    fieldid="location_out"
                                    status="0"
                                    line_info = "3"
                                    is_department="1"
                                    department_fldid="department_out"
                                    department_id="#attributes.department_out#"
                                    location_id="#attributes.location_out#"
                                    location_name="#attributes.location_out_name#"
                                    user_level_control="1"
                                    user_location = "0"
                                    width="125">
                            </div>
                        </div>
                    </cfif>
                    <cfif xml_project_filter neq 0>
                        <div class="form-group" id="item_project_head">
                            <label class="col col-12 col-xs-12"><cfif xml_project_filter eq 1><cf_get_lang dictionary_id='29523.Cikis Proje'><cfelse><cf_get_lang dictionary_id='57416.Proje'></cfif></label>
                            <div class="col col-12 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif len(attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','125');" value="<cfoutput>#attributes.project_head#</cfoutput>" autocomplete="off">
                                    <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_projects&project_head=frm_search.project_head&project_id=frm_search.project_id</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                    </cfif> 
                    <div class="form-group" id="row_dept" <cfif attributes.listing_type neq 2>style="display:none"</cfif>>
                        <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58508.Satır"> <cf_get_lang dictionary_id="58763.Depo"></label>
                        <div class="col col-12 col-xs-12">
                            <cf_wrkdepartmentlocation 
                                returninputvalue="row_location_id,row_location_name,row_department_id"
                                returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                fieldname="row_location_name"
                                fieldid="row_location_id"
                                status="0"
                                is_department="1"
                                department_fldid="row_department_id"
                                line_info = "1"
                                department_id="#attributes.row_department_id#"
                                location_id="#attributes.row_location_id#"
                                location_name="#attributes.row_location_name#"
                                user_level_control="1"
                                user_location = "0"
                                width="125">
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(2267,'Stok İşlemleri',30064)#" uidrop="1" hide_table_column="1" resize="1" collapsable="1" woc_setting = "#{ checkbox_name : 'print_islem_id', print_type : 30 }#">
        <form name="form_send_print" id="form_send_print">
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id='58577.Sira'></th>
                        <th><cf_get_lang dictionary_id='45178.belge tarihi'></th>
                        <cfif xml_show_process_stage eq 1>
                            <th><cf_get_lang dictionary_id='58859.Süreç'></th>
                        </cfif>        
                        <cfif isdefined("xml_is_deliver_date") and xml_is_deliver_date eq 1><th><cf_get_lang dictionary_id='45304.fiili sevk tarihi'></th></cfif>
                        <th><cf_get_lang dictionary_id='57880.belge no'></th>
                        <cfif xml_show_invoice eq 1>
                        <th><cf_get_lang dictionary_id='57441.Fatura'></th>
                        </cfif>
                        <cfif is_show_reference_no eq 1>
                        <th><cf_get_lang dictionary_id='58794.Referans No'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='58533.belge tipi'></th>
                        <!--- Eger satir bazinda listeleme yapiliyorsa --->
                        <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                        <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                        <cfif xml_show_lot_no eq 1><th class="form-title"><cf_get_lang dictionary_id='45498.Lot No'></th></cfif>
                        <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                        <cfif isdefined('x_is_rows_per_amount') and x_is_rows_per_amount eq 1>
                            <cfquery name="authorty" datasource="#dsn#">
                                SELECT COST_DISPLAY_VALID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
                            </cfquery>
                            <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                        </cfif>
                            <cfif xml_show_price eq 1>
                                <th><cf_get_lang dictionary_id='58083.Net'> <cf_get_lang dictionary_id="57638.Birim Fiyat"></th>
                            </cfif>
                        </cfif>            
                        <th><cf_get_lang dictionary_id='57519.cari hesap'></th>
                        <cfif xml_is_project_list eq 1>
                            <th><cf_get_lang dictionary_id='57554.Giris'><cf_get_lang dictionary_id='57416.Proje'></th>
                            <th><cf_get_lang dictionary_id='29523.Cikis Proje'></th>
                        </cfif>
                        <cfif xml_is_work_list eq 1>
                            <th><cf_get_lang dictionary_id='58445.Is'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                        <cfif isdefined("xml_is_record_emp") and xml_is_record_emp eq 1>
                            <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                        </cfif>
                        <cfif isdefined("xml_is_deliver_emp") and xml_is_deliver_emp eq 1>
                            <th><cf_get_lang dictionary_id='57775.Teslim Alan'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='45273.depo giriş'></th>
                        <th><cf_get_lang dictionary_id='29428.depo çıkış'></th>
                        <!-- sil -->
                        <!--- <cfif x_check_row_print eq 1 and attributes.listing_type eq 1 and get_ship_fis.recordcount>
                            <th class="header_icn_none" width="20">                            
                                <a href="javascript://" onclick="send_print();"><i class="fa fa-print" title="<cf_get_lang dictionary_id='50111.Toplu Yazdır'>"></i></a>                           
                            </th>
                        </cfif>
                        <th width="20" class="text-center"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdir'>" alt="<cf_get_lang dictionary_id='57474.Yazdir'>"></i></th> --->
                        <cfif get_ship_fis.recordcount>
                            <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                                <cfif get_ship_fis.recordcount eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a> </cfif> 
                                <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_islem_id');">
                               
                            </th>
                        </cfif>
                        <cfif session.ep.our_company_info.is_eshipment eq 1>
                            <th width="20" class="text-center"><img src="images/icons/efatura_black.gif" title="<cf_get_lang dictionary_id='60911.E-İrsaliye'>" /></th>
                        </cfif>
                        <!-- sil -->
                    </tr>
                </thead>
                <tbody>
                    <cfif get_ship_fis.recordcount>
                        <cfset employee_id_list=''>
                        <cfset company_id_list=''>
                        <cfset consumer_id_list=''>
                        <cfset dept_id_list=''>
                        <cfset process_cat_id_list=''>
                        <cfset ship_id_list=''>
                        <cfset ship_id2_list=''>
                        <cfset record_emp_list=''>
                        <cfoutput query="get_ship_fis" >
                            <cfif len(employee_id) and (employee_id neq 0) and not listfind(employee_id_list,employee_id)>
                                <cfset employee_id_list=listappend(employee_id_list,employee_id)>
                            </cfif>
                            <cfif len(get_ship_fis.deliver_emp_id) and (get_ship_fis.deliver_emp_id neq 0) and not listfind(employee_id_list,get_ship_fis.deliver_emp_id) and isnumeric(get_ship_fis.deliver_emp_id)>
                                <cfset employee_id_list=listappend(employee_id_list,get_ship_fis.deliver_emp_id)>
                            </cfif>
                            <cfif len(company_id) and (company_id neq 0) and not listfind(company_id_list,company_id)>
                                <cfset company_id_list=listappend(company_id_list,company_id)>
                            <cfelseif len(consumer_id) and (consumer_id neq 0) and not listfind(consumer_id_list,consumer_id)>
                                <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                            </cfif>
                            <cfif len(department_id) and (department_id neq 0) or len(department_id_2)>
                                <cfif not listfind(dept_id_list,department_id)>
                                    <cfset dept_id_list=listappend(dept_id_list,department_id)>
                                </cfif>
                                <cfif not listfind(dept_id_list,department_id_2)>
                                    <cfset dept_id_list=listappend(dept_id_list,department_id_2)>
                                </cfif>
                            </cfif>
                            <!--- xml de Belge Tipinde Islem Kategorileri Gorüntulenebilsin Evet ise --->
                            <cfif x_show_process_cat and len(get_ship_fis.process_cat) and not listfind(process_cat_id_list,get_ship_fis.process_cat)>
                                <cfset process_cat_id_list=listappend(process_cat_id_list,get_ship_fis.process_cat)>
                            </cfif>
                            <!--- xml de Fatura iliskisi Gorüntulenebilsin Evet ise --->
                            <cfif xml_show_invoice and get_ship_fis.islem_tipi neq 811 and get_ship_fis.table_type eq 1 and len(get_ship_fis.islem_id) and not listfind(ship_id_list,get_ship_fis.islem_id)>
                                <cfset ship_id_list=listappend(ship_id_list,get_ship_fis.islem_id)>
                            <cfelseif xml_show_invoice and get_ship_fis.islem_tipi eq 811 and get_ship_fis.table_type eq 1 and len(get_ship_fis.islem_id) and not listfind(ship_id2_list,get_ship_fis.islem_id)>
                                <!--- Ithal Mal Girisi kayitlari icin --->
                                <cfset ship_id2_list=listappend(ship_id2_list,get_ship_fis.islem_id)>
                            </cfif>
                            <cfif isdefined('record_emp') and len(record_emp) and not listfind(record_emp_list,record_emp)>
                                <cfset record_emp_list=listappend(record_emp_list,record_emp)>
                            </cfif>
                        </cfoutput>
                        <cfif listlen(employee_id_list)>
                            <cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_EMPLOYEE_DETAIL" datasource="#DSN#">
                                SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#) ORDER BY EMPLOYEE_ID
                            </cfquery>
                            <cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_employee_detail.employee_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif listlen(company_id_list)>
                            <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
                                SELECT COMPANY_ID, NICKNAME, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                            </cfquery>
                            <cfset company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif listlen(consumer_id_list)>
                            <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                                SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
                            </cfquery>
                            <cfset consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfif listlen(dept_id_list)>
                            <cfset dept_id_list=listsort(dept_id_list,"numeric","ASC",",")>
                            <cfquery name="GET_DEP_DETAIL" datasource="#DSN#">
                                SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
                            </cfquery>
                            <cfset dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <!--- xml de Belge Tipinde Islem Kategorileri Gorüntulenebilsin Evet ise --->
                        <cfif x_show_process_cat and len(process_cat_id_list)>					
                            <cfquery name="GET_PROCESS_CAT_ROW" dbtype="query">
                                SELECT PROCESS_CAT_ID,PROCESS_CAT FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID IN (#process_cat_id_list#) ORDER BY	PROCESS_CAT_ID
                            </cfquery>
                            <cfset process_cat_id_list = listsort(listdeleteduplicates(valuelist(get_process_cat_row.process_cat_id,',')),'numeric','ASC',',')>
                        </cfif>
                        <!--- xml de Fatura iliskisi Gorüntulenebilsin Evet ise --->
                        <cfif xml_show_invoice and len(ship_id_list)>
                            <cfset ship_id_list=listsort(ship_id_list,"numeric","ASC",",")>		
                            <cfquery name="GET_INVOICE_SHIP" datasource="#DSN2#">
                                SELECT INVOICE_NUMBER,SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#ship_id_list#) AND SHIP_PERIOD_ID = #session.ep.period_id# ORDER BY SHIP_ID
                            </cfquery>
                        </cfif>
                        
                        <!--- Ithal Mal Girisi kayitlari icin --->
                        <cfif xml_show_invoice and len(ship_id2_list)>
                            <cfset ship_id2_list=listsort(ship_id2_list,"numeric","ASC",",")>		
                            <cfquery name="GET_INVOICE_SHIP2" datasource="#DSN2#">
                                SELECT IMPORT_INVOICE_ID,SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_ID IN (#ship_id2_list#) AND IMPORT_PERIOD_ID = #session.ep.period_id# AND IMPORT_INVOICE_ID IS NOT NULL ORDER BY SHIP_ID
                            </cfquery>
                            <cfif get_invoice_ship2.recordcount>
                                <cfquery name="GET_INV_DETAIL" datasource="#DSN2#">
                                    SELECT INVOICE_NUMBER, INVOICE_ID FROM  INVOICE WHERE  INVOICE_ID IN (#valuelist(get_invoice_ship2.import_invoice_id)#)
                                </cfquery>
                            </cfif>
                        </cfif>
                        <!--- Kaydeden --->
                        <cfif xml_is_record_emp and Listlen(record_emp_list)>
                            <cfset record_emp_list=listsort(record_emp_list,"numeric","ASC",",")>
                            <cfquery name="get_record_emp" datasource="#dsn#">
                                SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME RECORD_EMPLOYEE,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#record_emp_list#) ORDER BY EMPLOYEE_ID
                            </cfquery>
                            <cfset record_emp_list=listsort(listdeleteduplicates(valuelist(get_record_emp.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                        </cfif>
                        <cfoutput query="get_ship_fis" >
                            <tr>
                                <td>#rownum#</td>
                                <td>#dateformat(islem_tarihi,dateformat_style)#</td>
                                <cfif xml_show_process_stage eq 1>
                                    <td>#STAGE#</td>
                                </cfif> 
                                <cfif isdefined("xml_is_deliver_date") and xml_is_deliver_date eq 1><td>#dateformat(sevk_tarihi,dateformat_style)#</td></cfif>
                                <td>
                                    <cfif purchase_sales eq 0>
                                        <cfswitch expression="#islem_tipi#">
                                            <cfcase value="761">
                                                <cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_marketplace_ship&event=upd&ship_id=">
                                            </cfcase>
                                            <cfcase value="82">
                                                <cfset url_param = "#request.self#?fuseaction=invent.add_invent_purchase&event=upd&ship_id=">
                                            </cfcase>
                                            <cfcase value="811">
                                                <cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=">
                                            </cfcase>
                                            <cfcase value="72">
                                                <cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=">
                                            </cfcase>
                                            <cfdefaultcase>
                                                <cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_purchase&event=upd&ship_id=">
                                            </cfdefaultcase>
                                        </cfswitch>
                                    <cfelseif purchase_sales eq 1>
                                        <cfswitch expression="#islem_tipi#">
                                            <cfcase value="81">
                                                <cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_ship_dispatch&event=upd&ship_id=">
                                            </cfcase>
                                            <cfcase value="811">
                                                <cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_stock_in_from_customs&event=upd&ship_id=">
                                            </cfcase>
                                            <cfcase value="83">
                                                <cfset url_param = "#request.self#?fuseaction=invent.add_invent_sale&event=upd&ship_id=">
                                            </cfcase>
                                            <cfdefaultcase>
                                                <cfset url_param = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_sale&event=upd&ship_id=">
                                            </cfdefaultcase>
                                        </cfswitch>				
                                    <cfelse>
                                        <cfswitch expression="#islem_tipi#">
                                            <cfcase value="114">
                                                <cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_ship_open_fis&event=upd&upd_id=">
                                            </cfcase>
                                            <cfcase value="118">
                                                <cfset url_param="#request.self#?fuseaction=invent.add_invent_stock_fis&event=upd&fis_id=">
                                            </cfcase>
                                            <cfcase value="1182">
                                                <cfset url_param="#request.self#?fuseaction=invent.add_invent_stock_fis_return&event=upd&fis_id=">
                                            </cfcase>
                                            <cfcase value="116">
                                                <cfif stock_exchange_type eq 0>
                                                    <cfset url_param="#request.self#?fuseaction=stock.form_add_stock_exchange&event=upd&exchange_id=">
                                                <cfelse>
                                                    <cfset url_param="#request.self#?fuseaction=stock.form_add_spec_exchange&event=upd&exchange_id=">
                                                </cfif>
                                            </cfcase>
                                            <cfdefaultcase>
                                                <cfset url_param="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_fis&event=upd&upd_id=">
                                            </cfdefaultcase>
                                        </cfswitch>
                                    </cfif>
                                    <!--- xml de detay bilgisi goruntulensin secilmezse ayarlar stok devirden yapılan işlemlerin detayına girilmez --->						
                                    <cfif is_stock_transfer neq 1 or (isdefined('is_show_stock_transfer_detail') and is_show_stock_transfer_detail eq 1)>
                                        <a href="#url_param##islem_id#"class="tableyazi">#belge_no#</a>
                                    <cfelse>
                                        #belge_no#
                                    </cfif>
                                </td>
                            <cfif xml_show_invoice eq 1>
                                <td>
                                    <cfif get_ship_fis.table_type eq 1 and len(ship_id_list) and get_ship_fis.islem_tipi neq 811>				
                                        <cfquery name="GET_INVOICE_SHIP_ROW" dbtype="query">
                                            SELECT * FROM GET_INVOICE_SHIP WHERE SHIP_ID = #islem_id#
                                        </cfquery>
                                        <cfset invoiceNumberList = valuelist(get_invoice_ship_row.invoice_number,',')>
                                        <div title="#invoiceNumberList#">
                                            <cfif get_invoice_ship_row.recordcount>
                                                <cfloop from="1" to="2" index="f">
                                                    #get_invoice_ship_row.invoice_number[f]#<cfif get_invoice_ship_row.recordcount neq 1>,</cfif>
                                                </cfloop>
                                                <cfif get_invoice_ship_row.recordcount gt 2>...</cfif>
                                            </cfif>
                                        </div>
                                    <cfelseif get_ship_fis.table_type eq 1 and len(ship_id2_list) and get_ship_fis.islem_tipi eq 811>
                                        <cfquery name="GET_INVOICE_SHIP_" dbtype="query">
                                            SELECT * FROM GET_INVOICE_SHIP2 WHERE SHIP_ID = #islem_id#
                                        </cfquery>
                                        <cfif get_invoice_ship_.recordcount>
                                            <cfquery name="GET_INVOICE_SHIP_ROW2" dbtype="query">
                                                SELECT * FROM GET_INV_DETAIL WHERE INVOICE_ID IN (#valuelist(get_invoice_ship_.import_invoice_id)#)
                                            </cfquery>
                                            <cfset invoiceNumberList2 = valuelist(get_invoice_ship_row2.invoice_number,',')>
                                            <div title="#invoiceNumberList2#">
                                                <cfif get_invoice_ship_row2.recordcount>
                                                    <cfloop from="1" to="2" index="f">
                                                        #get_invoice_ship_row2.invoice_number[f]#<cfif get_invoice_ship_row2.recordcount neq 1>,</cfif>
                                                    </cfloop>
                                                    <cfif get_invoice_ship_row2.recordcount gt 2>...</cfif>
                                                </cfif>
                                            </div>
                                        </cfif>					
                                    </cfif>				
                                </td>
                            </cfif>
                            <cfif is_show_reference_no eq 1>
                            <td>#left(referans,20)#</td>
                            </cfif>
                                <!--- xml de Belge Tipinde Islem Kategorileri Goruntulenebilsin Evet ise --->
                                <td>#get_process_name(islem_tipi)#<cfif x_show_process_cat eq 1 and len(get_ship_fis.process_cat)>- #get_process_cat_row.process_cat[listfind(process_cat_id_list,get_ship_fis.process_cat,',')]#</cfif></td>
                                <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                    <td>#stock_code#</td>
                                    <cfif xml_show_lot_no eq 1><td>#lot_no#</td></cfif>
                                        <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#name_product#</a></td>
                                        <td>#TLFormat(amount)#</td>
                                    <cfif isdefined('x_is_rows_per_amount') and x_is_rows_per_amount eq 1>
                                        <td><cfif islem_tipi neq 116>#TLFormat(price)#</cfif></td>
                                    </cfif>
                                    <cfif xml_show_price eq 1>
                                        <td><cfif islem_tipi neq 116>#TLFormat(NETTOTAL/AMOUNT)#</cfif></td>
                                    </cfif>
                                </cfif>
                                
                                <td>
                                    <cfif len(get_ship_fis.employee_id) and get_ship_fis.employee_id neq 0 and islem_tipi neq 81>
                                        #get_employee_detail.employee_name[listfind(employee_id_list,get_ship_fis.employee_id,',')]#
                                        #get_employee_detail.employee_surname[listfind(employee_id_list,get_ship_fis.employee_id,',')]#
                                    <cfelseif islem_tipi neq 81>
                                        <cfif len(get_ship_fis.company_id) and isdefined("get_company_detail")>
                                            #get_company_detail.fullname[listfind(company_id_list,company_id,',')]#
                                        <cfelseif len(get_ship_fis.consumer_id) and isdefined("get_consumer_detail")>
                                            #get_consumer_detail.consumer_name[listfind(consumer_id_list,consumer_id,',')]#
                                            #get_consumer_detail.consumer_surname[listfind(consumer_id_list,consumer_id,',')]#
                                        <cfelseif len(get_ship_fis.deliver_emp_id) and isnumeric(get_ship_fis.deliver_emp_id) and isdefined("get_employee_detail")>
                                            #get_employee_detail.employee_name[listfind(employee_id_list,deliver_emp_id,',')]#
                                            #get_employee_detail.employee_surname[listfind(employee_id_list,deliver_emp_id,',')]#
                                        </cfif>
                                    </cfif>
                                    <cfif islem_tipi eq 81>
                                        <cfif len(get_ship_fis.deliver_emp)>#get_ship_fis.deliver_emp#</cfif>
                                    </cfif>
                                </td>
                                    <cfif xml_is_project_list eq 1>
                                    <cfif purchase_sales gt -1>
                                        <td><cfif purchase_sales eq 0 and len(PROJECT_HEAD)>#PROJECT_HEAD#<cfelse>#PROJECT_HEAD_IN#</cfif></td>
                                        <td><cfif purchase_sales eq 1>#PROJECT_HEAD#</cfif></td>
                                    <cfelse>
                                        <td>#PROJECT_HEAD_IN#</td>
                                        <td>#PROJECT_HEAD#</td>
                                    </cfif>
                                </cfif>
                                <cfif xml_is_work_list eq 1>
                                    <td>#work_head#</td>
                                </cfif>
                                <td>#dateformat(DATEADD('h',-session.ep.time_zone,record_date),dateformat_style)#</td>
                                <cfif isdefined("xml_is_record_emp") and xml_is_record_emp eq 1>
                                    <td><cfif len(record_emp)>#get_record_emp.record_employee[listfind(record_emp_list,record_emp,',')]#</cfif></td>
                                </cfif>
                                <cfif isdefined("xml_is_deliver_emp") and xml_is_deliver_emp eq 1>
                                    <td>
                                        <cfif len(get_ship_fis.deliver_emp_id) and isnumeric(get_ship_fis.deliver_emp_id) and isdefined("get_employee_detail")>
                                            #get_employee_detail.employee_name[listfind(employee_id_list,deliver_emp_id,',')]#
                                            #get_employee_detail.employee_surname[listfind(employee_id_list,deliver_emp_id,',')]#
                                        <cfelse>
                                            #get_ship_fis.deliver_emp#                       
                                        </cfif>
                                    </td>
                                </cfif>
                                <td>
                                    <cfif len(department_id) and (department_id neq 0)>
                                        #DEPT_IN#<cfif x_is_location_info and Len(location)> - #LOC_IN#</cfif>
                                    </cfif>
                                </td>
                                <td>
                                    <cfif len(department_id_2) and (department_id_2 neq 0)>
                                        #DEPT_OUT# <cfif x_is_location_info and Len(location_2)> - #LOC_OUT#</cfif>
                                    </cfif>
                                </td>
                                <!-- sil -->
                                <!--- <td>			  	
                                        <cfif listfind("110,111,112,113,114,115,116",get_ship_fis.islem_tipi,",")>
                                            <cfset stock_fis_ = 1>
                                            <a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#ISLEM_ID#&print_type=31''WOC');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdir'>"></i></a>
                                        <cfelse>
                                            <a href="javascript://" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_id=#ISLEM_ID#&print_type=30','WOC');"><i class="fa fa-print" title="<cf_get_lang dictionary_id='57474.Yazdir'>"></i></a>
                                        </cfif>
                                </td> --->
                                <cfif get_ship_fis.RecordCount >
                                    <td class="text-center header_icn_none"><input type="checkbox" name="print_islem_id" id="print_islem_id" value="#islem_id#"></td>
                                </cfif>
                                <cfif session.ep.our_company_info.is_eshipment eq 1>
                                    <cfquery name="Get_Ship_Period" datasource="#dsn#">
                                        SELECT OUR_COMPANY_ID,PERIOD_YEAR FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_YEAR >= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_year#"> ORDER BY PERIOD_YEAR ASC
                                    </cfquery>
                                    <cfif Get_Ship_Period.RecordCount>
                                        <cfquery name="get_inv" datasource="#dsn2#">
                                            <cfloop query="Get_Ship_Period">
                                                <cfset new_period_dsn = '#dsn#_#Get_Ship_Period.Period_Year#_#Get_Ship_Period.Our_Company_Id#'>
                                                    SELECT INVOICE_NUMBER,SHIP_NUMBER,IS_WITH_SHIP FROM #new_period_dsn#.INVOICE_SHIPS WHERE SHIP_ID = #get_ship_fis.ISLEM_ID# AND SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                                                <cfif Get_Ship_Period.currentrow neq Get_Ship_Period.recordcount>UNION ALL</cfif>
                                            </cfloop>
                                        </cfquery>
                                    </cfif>
                                    <td class="text-center">
                                        <cfif len(IS_WITH_SHIP) and IS_WITH_SHIP eq 1 and get_inv.recordcount>
                                        <cfelse>
                                            <cfif session.ep.our_company_info.is_eshipment>
                                                <!--- <cfif len(company_id)>
                                                    <cfquery name="get_use" datasource="#dsn#">
                                                        SELECT USE_ESHIPMENT FROM COMPANY WHERE COMPANY_ID = #company_id# AND USE_ESHIPMENT = 1   
                                                    </cfquery>
                                                <cfelseif len(consumer_id)>
                                                    <cfquery name="get_use" datasource="#dsn#">
                                                        SELECT USE_ESHIPMENT FROM CONSUMER WHERE CONSUMER_ID = #consumer_id# AND USE_ESHIPMENT = 1 
                                                    </cfquery>
                                                </cfif> --->
                                                <cfquery name="GET_PROCESS_CAT_TYPE" dbtype="query">
                                                    SELECT PROCESS_TYPE,DESPATCH_ADVICE_TYPE FROM GET_PROCESS_CAT WHERE PROCESS_CAT_ID = #PROCESS_CAT#
                                                </cfquery>
                                                    <cfquery name="CHK_SEND_SHIP" datasource="#dsn2#">
                                                        SELECT COUNT(*) COUNT FROM ESHIPMENT_SENDING_DETAIL WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#"> AND STATUS_CODE = 1	    
                                                    </cfquery>
                                                    <cfquery name="CHK_SHIP_REL" datasource="#dsn2#">
                                                        SELECT STATUS_CODE FROM ESHIPMENT_RELATION WHERE ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#islem_id#">
                                                    </cfquery>
                                                    <cfquery name="CHK_SHIP_SEVK" datasource="#dsn2#">
                                                        SELECT STATUS FROM ESHIPMENT_RECEIVING_DETAIL WHERE ESHIPMENT_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#belge_no#">
                                                    </cfquery>
                                                    <cfif listfind('70,71,72,78,79,81,82,83,85,88,141,761',GET_PROCESS_CAT_TYPE.PROCESS_TYPE)>
                                                        <cfif (CHK_SHIP_REL.recordcount and CHK_SHIP_REL.status_code eq 1) or ( CHK_SHIP_SEVK.recordcount and CHK_SHIP_SEVK.status eq 1)>
                                                            <img src="images/icons/efatura_green.gif" height="17" align="absmiddle" title="E-irsaliye Kesildi"/>                 
                                                        <cfelseif CHK_SHIP_REL.recordcount and CHK_SHIP_REL.status_code eq 0>
                                                            <img src="images/icons/efatura_red.gif" height="17" align="absmiddle" title="E-irsaliye red"/>
                                                        <cfelseif CHK_SEND_SHIP.count gt 0>
                                                            <img src="images/icons/efatura_yellow.gif" height="17" align="absmiddle" title="Onay Bekliyor"/>
                                                        <cfelse>
                                                            <img src="images/icons/efatura_blue.gif" height="17" align="absmiddle" title="Gonderilmedi"/>
                                                        </cfif>
                                                    </cfif>
                                            </cfif>
                                        </cfif>
                                    </td>
                                </cfif>
                                <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr class="color-row">
                            <cfset colspan = "12">
                            <cfif xml_show_invoice eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif is_show_reference_no eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                                <cfset colspan = colspan + 3>
                                <cfif xml_show_lot_no eq 1><cfset colspan = colspan + 1></cfif>
                                <cfif isdefined('x_is_rows_per_amount') and x_is_rows_per_amount eq 1>
                                    <cfif authorty.COST_DISPLAY_VALID eq 0>
                                        <cfset colspan = colspan + 2>
                                    </cfif>
                                <cfelse> 
                                    <cfset colspan = colspan + 1>
                                </cfif>
                            </cfif>
                            <cfif xml_is_project_list eq 1>
                                <cfset colspan = colspan + 2>
                            </cfif>
                            <cfif xml_is_work_list eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif x_check_row_print eq 1 and attributes.listing_type eq 1 and get_ship_fis.recordcount>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif xml_is_record_emp eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif xml_is_deliver_emp eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <td colspan="<cfoutput>#colspan#</cfoutput>" height="20"><cfif not isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57701.Filtre Ediniz'><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'></cfif> !</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </form>
        <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_purchase&consumer_id=#attributes.consumer_id#&company_id=#attributes.company_id#&company=#attributes.company#">
        <cfif isDefined('attributes.cat') and len(attributes.cat)>
            <cfset adres = "#adres#&cat=#attributes.cat#">
        </cfif>
        <cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
            <cfset adres = "#adres#&belge_no=#attributes.belge_no#">
        </cfif>
        <cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>
            <cfset adres = "#adres#&lot_no=#attributes.lot_no#">
        </cfif>
        <cfif isdefined("attributes.referans") and len(attributes.referans)>
            <cfset adres = "#adres#&referans=#attributes.referans#">
        </cfif>
        <cfif isdefined("attributes.project_id") and len(attributes.project_id) and isdefined("attributes.project_head") and len(attributes.project_head)>
            <cfset adres = "#adres#&project_id=#attributes.project_id#">
            <cfset adres = "#adres#&project_head=#attributes.project_head#">
        </cfif>
        <cfif isdefined("attributes.project_id_in") and len(attributes.project_id_in) and isdefined("attributes.project_head_in") and len(attributes.project_head_in)>
            <cfset adres = "#adres#&project_id_in=#attributes.project_id_in#">
            <cfset adres = "#adres#&project_head_in=#attributes.project_head_in#">
        </cfif>
        <cfif isdefined('attributes.subscription_id') and len(attributes.subscription_id) and isdefined('attributes.subscription_no') and len(attributes.subscription_no)>
            <cfset adres = "#adres#&subscription_id=#attributes.subscription_id#&subscription_no=#attributes.subscription_no#">
        </cfif>
        <cfif isDefined('attributes.oby') and len(attributes.oby)>
            <cfset adres = "#adres#&oby=#attributes.oby#">
        </cfif>
        <cfif len(attributes.iptal_stocks)>
            <cfset adres = "#adres#&iptal_stocks=#attributes.iptal_stocks#">
        </cfif>
        <cfif isDefined('attributes.invoice_action') and len(attributes.invoice_action)>
            <cfset adres = "#adres#&invoice_action=#attributes.invoice_action#">
        </cfif> 
        <cfif isDefined('attributes.department_id') and len(attributes.department_id)>
            <cfset adres = "#adres#&department_id=#attributes.department_id#">
        </cfif>
        <cfif isDefined('attributes.location_id') and len(attributes.location_id)>
            <cfset adres = "#adres#&location_id=#attributes.location_id#">
        </cfif>
        <cfif isDefined('attributes.location_out') and len(attributes.location_out)>
            <cfset adres = "#adres#&location_out=#attributes.location_out#">
        </cfif>
        <cfif isDefined('attributes.department_out') and len(attributes.department_out)>
            <cfset adres = "#adres#&department_out=#attributes.department_out#">
        </cfif>
        <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
            <cfset adres = "#adres#&stock_id=#attributes.stock_id#">
        </cfif>
        <cfif isdefined("attributes.product_name") and len(attributes.product_name)>
            <cfset adres = "#adres#&product_name=#attributes.product_name#">
        </cfif>
        <cfif isdefined("attributes.product_cat_code") and len(attributes.product_cat_name)>
            <cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
            <cfset adres = "#adres#&product_cat_name=#attributes.product_cat_name#">
        </cfif>
        <cfif isdefined("attributes.record_date") and len(attributes.record_date)>
            <cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
        </cfif>
        <cfif isdate(attributes.date1)>
            <cfset adres = "#adres#&date1=#dateformat(attributes.date1,dateformat_style)#">
        </cfif>
        <cfif isdate(attributes.date2)>
            <cfset adres = "#adres#&date2=#dateformat(attributes.date2,dateformat_style)#">
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name)>
            <cfset adres = "#adres#&member_name=#attributes.member_name#">
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.member_type") and len(attributes.member_type)>
            <cfset adres = "#adres#&member_type=#attributes.member_type#">
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.employee_id_2") and len(attributes.employee_id_2)>
            <cfset adres = "#adres#&employee_id_2=#attributes.employee_id_2#">
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.consumer_id_2") and len(attributes.consumer_id_2)>
            <cfset adres = "#adres#&consumer_id_2=#attributes.consumer_id_2#">
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.partner_id_2") and len(attributes.partner_id_2)>
            <cfset adres = "#adres#&partner_id_2=#attributes.partner_id_2#">
        </cfif>
        <cfif isdefined("attributes.member_name") and len(attributes.member_name) and isdefined("attributes.company_id_2") and len(attributes.company_id_2)>
            <cfset adres = "#adres#&company_id_2=#attributes.company_id_2#">
        </cfif>                                                
        <cfif isDefined('attributes.delivered') and len(attributes.delivered) >
            <cfset adres = "#adres#&delivered=#attributes.delivered#" >
        </cfif>
        <cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>
            <cfset adres = "#adres#&listing_type=#attributes.listing_type#">
        </cfif>
        <cfif isdefined("attributes.delivered_status") and len(attributes.delivered_status)>
            <cfset adres = "#adres#&delivered_status=#attributes.delivered_status#">
        </cfif>
        <cfif isdefined("attributes.work_id") and len(attributes.work_id) and len(attributes.work_head)>
            <cfset adres = "#adres#&work_id=#attributes.work_id#&work_head=#attributes.work_head#">
        </cfif>
        <cfif isdefined("attributes.disp_ship_state") and len(attributes.disp_ship_state)>
            <cfset adres = "#adres#&disp_ship_state=#attributes.disp_ship_state#">
        </cfif>
        <cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
            <cfset adres = "#adres#&is_form_submitted=#attributes.is_form_submitted#">
        </cfif>
        <cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
            <cfset adres = "#adres#&record_emp_id=#attributes.record_emp_id#">
        </cfif>
        <cfif isdefined("attributes.record_name") and len(attributes.record_name)>
            <cfset adres = "#adres#&record_name=#attributes.record_name#">
        </cfif>
        <cfif isDefined('attributes.row_department_id') and len(attributes.row_department_id)>
            <cfset adres = "#adres#&row_department_id=#attributes.row_department_id#">
        </cfif>
        <cfif isDefined('attributes.row_location_id') and len(attributes.row_location_id)>
            <cfset adres = "#adres#&row_location_id=#attributes.row_location_id#">
        </cfif>
        <cfif isDefined('attributes.row_project_id') and len(attributes.row_project_id)>
            <cfset adres = "#adres#&row_project_id=#attributes.row_project_id#">
        </cfif>
        <cfif isDefined('attributes.row_project_head') and len(attributes.row_project_head)>
            <cfset adres = "#adres#&row_project_head=#attributes.row_project_head#">
        </cfif>
        <cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
            <cfset adres = "#adres#&EMPO_ID=#attributes.EMPO_ID#">
        </cfif>
        <cfif isdefined("attributes.EMP_PARTNER_NAMEO") and len(attributes.EMP_PARTNER_NAMEO)>
            <cfset adres = "#adres#&EMP_PARTNER_NAMEO=#attributes.EMP_PARTNER_NAMEO#">
        </cfif>
        <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
            <cfset adres = "#adres#&process_stage=#attributes.process_stage#">
        </cfif>

        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="#adres#">
    </cf_box>
</div>
<script type="text/javascript">
document.getElementById('belge_no').focus();
function send_print()
{
	<cfif not get_ship_fis.recordcount>
		alert("<cf_get_lang dictionary_id='35382.Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız'>!");
		return false;
	<cfelseif get_ship_fis.recordcount eq 1>
		if(document.form_send_print.print_islem_id.checked == false)
		{
			alert("<cf_get_lang dictionary_id='35382.Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız'>!");
			return false;
		}
		else
		{
			ship_list_ = document.form_send_print.print_islem_id.value;
		}
	<cfelseif get_ship_fis.recordcount gt 1>
		ship_list_ = "";
		for (i=0; i < document.form_send_print.print_islem_id.length; i++)
		{
			if(document.form_send_print.print_islem_id[i].checked == true)
				{
				ship_list_ = ship_list_ + document.form_send_print.print_islem_id[i].value + ',';
				}	
		}
		if(ship_list_.length == 0)
			{
			alert("<cf_get_lang dictionary_id='35382.Yazdırılacak İşlem Bulunamadı! Toplu Print Yapamazsınız'>!");
			return false;
			}
	</cfif>
	<cfif stock_fis_ eq 1>
		alert("<cf_get_lang dictionary_id='61107.Bu İşlemde Fişleri Basamazsınız'> !");
		return false;
	<cfelse>
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_print_files&print_type=30&action_row_id='+ship_list_,'page');
	</cfif>
}
function input_control()
{
	<cfif not session.ep.our_company_info.unconditional_list>
		if(frm_search.date1.value.length == 0 && frm_search.date2.value.length == 0 && frm_search.belge_no.value.length == 0 && frm_search.cat.value.length == 0 && frm_search.department_id.value.length == 0 &&
		  (frm_search.stock_id.value.length == 0 || frm_search.product_name.value.length == 0) && (frm_search.company_id.value.length == 0 || frm_search.company.value.length == 0) )
		{
			alert("<cf_get_lang dictionary_id='58950.En Az Bir Alanda Filtre Etmelisiniz'> !");
			return false;
		}
		else
			return true;
	<cfelse>
		/*if(document.frm_search.member_name.value.length==0)
			document.frm_search.deliver_emp_id.value=='';	*/
		return true;
	</cfif>	
}
function cat_control()
{//mal alım irsaliyeleri ve satır bazında çekildiğinde filtre görülür.
	if (list_getat(document.getElementById("cat").value,1,'-') == 76 && document.getElementById('listing_type').value == 2)
	{
		disp_ship_state_.style.display = '';
	}
	else
	{
		disp_ship_state_.style.display = 'none';
	}
	if (document.getElementById('listing_type').value == 2)
	{
		row_dept.style.display = '';
		row_project.style.display = '';
		var x=document.getElementById("oby");
		var option=document.createElement("option");
		option.text="Stok Kodu Bazında Artan";
		option.value="5";
		try
		  {
		  // for IE earlier than version 8
		  x.add(option,x.options[null]);
		  }
		catch (e)
		  {
		  x.add(option,null);
		  }
		var x=document.getElementById("oby");
		var option=document.createElement("option");
		option.text="Stok Kodu Bazında Azalan";
		option.value="6";
		try
		  {
		  // for IE earlier than version 8
		  x.add(option,x.options[null]);
		  }
		catch (e)
		  {
		  x.add(option,null);
		  }
	}
	else
	{
		row_dept.style.display = 'none';
		row_project.style.display = 'none';
		if (document.getElementById('stock_asc') != undefined)
			document.getElementById('oby').removeChild(document.getElementById('stock_asc'));
		if (document.getElementById('stock_desc') != undefined)
			document.getElementById('oby').removeChild(document.getElementById('stock_desc'));
	}
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
