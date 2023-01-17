<cf_get_lang_set module_name="invoice">
<cf_xml_page_edit fuseact="invoice.list_bill">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.location_id" default="">
<cfparam name="attributes.department_txt" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.record_date" default="">
<cfparam name="attributes.payment_type_id" default="">
<cfparam name="attributes.card_paymethod_id" default="">
<cfparam name="attributes.payment_type" default="">
<cfparam name="attributes.EMPO_ID" default="">
<cfparam name="attributes.PARTO_ID" default="">
<cfparam name="attributes.EMP_PARTNER_NAMEO" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.detail" default="">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.iptal_invoice" default="0">
<cfparam name="attributes.record_emp_id" default="">
<cfparam name="attributes.record_emp_name" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.budget_record" default="">
<cfparam name="attributes.efatura_type" default="">
<cfparam name="attributes.earchive_type" default="">
<cfparam name="attributes.output_type" default="">
<cfparam name="attributes.invoice_type" default="">
<cfparam name="attributes.product_cat_code" default="-2">
<cfparam name="attributes.product_cat_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_id2" default="">
<cfparam name="attributes.dept_id" default="">
<cfparam name="attributes.process_stage" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelseif not isdefined("form_varmi")>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.start_date = ''>
	<cfelse>
		<cfset attributes.start_date = date_add('d',-7,wrk_get_today())>
	</cfif>
<cfelse>
	<cfset attributes.start_date = ''>
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelseif not isdefined("form_varmi")>
	<cfif session.ep.our_company_info.unconditional_list>
		<cfset attributes.finish_date = ''>
	<cfelse>
		<cfset attributes.finish_date = date_add('d',7,attributes.start_date)>
	</cfif>
<cfelse>
	<cfset attributes.finish_date = ''>
</cfif>
<cfif isdefined("attributes.record_date") and isdate(attributes.record_date)>
	<cf_date tarih= "attributes.record_date">
</cfif>
<cfset islem_tipi = '48,49,50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,64,690,691,65,66,68,531,532,591,5311,651,661'>
<cfif session.ep.our_company_info.workcube_sector eq 'per'>
	<cfset islem_tipi = islem_tipi&',592'>
</cfif>
<cfquery name="GET_PROCESS_CAT" datasource="#DSN3#">
	SELECT 
        PROCESS_TYPE,
        CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE PROCESS_CAT 
        END AS PROCESS_CAT,
            PROCESS_CAT_ID
        FROM 
            SETUP_PROCESS_CAT 
            LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_PROCESS_CAT.PROCESS_CAT_ID
            AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PROCESS_CAT">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_PROCESS_CAT">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
        WHERE 
            PROCESS_TYPE IN (#islem_tipi#) ORDER BY PROCESS_TYPE
</cfquery>
<cfinclude template="../../member/query/get_company_cat.cfm">
<cfinclude template="../../member/query/get_consumer_cat.cfm">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
<!--- cfc dosyasında date_add fonksiyonu için fbx_workcube_funcs dosyasını çağırmamak için dateadd işlemini burada yapıyorum py--->
<cfif isdefined("attributes.record_date2") and len(attributes.record_date2)>
	<cfset rec_date1 = date_add('d',1,attributes.record_date2)>
<cfelse>
	<cfset rec_date1 = ''>
</cfif>
<cfif isdefined("attributes.record_date") and len(attributes.record_date)>
	<cfset rec_date2 = date_add('d',1,attributes.record_date)>
<cfelse>
	<cfset rec_date2 = ''>
</cfif>

<cfif isdefined("attributes.form_varmi")>
<cfscript>
	get_bill_action = createObject("component", "V16.invoice.cfc.get_bill");
	get_bill_action.dsn2 = dsn2;
	get_bill_action.dsn_alias = dsn_alias;
	get_bill_action.dsn3_alias = dsn3_alias;
	get_bill = get_bill_action.get_bill_fnc
		(
			listing_type : attributes.listing_type,
			control : '#IIf(IsDefined("attributes.control"),"attributes.control",DE(""))#',
			project_id : '#IIf(IsDefined("attributes.project_id"),"attributes.project_id",DE(""))#',
			project_head : '#IIf(IsDefined("attributes.project_head"),"attributes.project_head",DE(""))#',
			budget_record : '#IIf(IsDefined("attributes.budget_record"),"attributes.budget_record",DE(""))#',
			module_name : '#IIf(IsDefined("fusebox.circuit"),"fusebox.circuit",DE(""))#',
			company : '#IIf(IsDefined("attributes.company"),"attributes.company",DE(""))#',
			company_id : '#IIf(IsDefined("attributes.company_id"),"attributes.company_id",DE(""))#',
			member_type : '#IIf(IsDefined("attributes.member_type"),"attributes.member_type",DE(""))#',
			consumer_id : '#IIf(IsDefined("attributes.consumer_id"),"attributes.consumer_id",DE(""))#',
			employee_id : '#IIf(IsDefined("attributes.employee_id"),"attributes.employee_id",DE(""))#',
			empo_id : '#IIf(IsDefined("attributes.empo_id"),"attributes.empo_id",DE(""))#',
			parto_id : '#IIf(IsDefined("attributes.parto_id"),"attributes.parto_id",DE(""))#',
			detail : '#IIf(IsDefined("attributes.detail"),"attributes.detail",DE(""))#',
			cat : '#IIf(IsDefined("attributes.cat"),"attributes.cat",DE(""))#',
			card_paymethod_id : '#IIf(IsDefined("attributes.card_paymethod_id"),"attributes.card_paymethod_id",DE(""))#',
			payment_type_id : '#IIf(IsDefined("attributes.payment_type_id"),"attributes.payment_type_id",DE(""))#',
			payment_type : '#IIf(IsDefined("attributes.payment_type"),"attributes.payment_type",DE(""))#',
			belge_no : '#IIf(IsDefined("attributes.belge_no"),"attributes.belge_no",DE(""))#',
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			department_txt : '#IIf(IsDefined("attributes.department_txt"),"attributes.department_txt",DE(""))#',
			department_id : '#IIf(IsDefined("attributes.department_id"),"attributes.department_id",DE(""))#',
			location_id : '#IIf(IsDefined("attributes.location_id"),"attributes.location_id",DE(""))#',
			record_emp_id : '#IIf(IsDefined("attributes.record_emp_id"),"attributes.record_emp_id",DE(""))#',
			record_emp_name : '#IIf(IsDefined("attributes.record_emp_name"),"attributes.record_emp_name",DE(""))#',
			record_date : '#IIf(IsDefined("attributes.record_date"),"attributes.record_date",DE(""))#',
			rec_date1 : '#rec_date1#',
			rec_date2 : '#rec_date2#',
            product_cat_code : '#IIf(IsDefined("attributes.product_cat_code"),"attributes.product_cat_code",DE(""))#',
            product_cat_name : '#IIf(IsDefined("attributes.product_cat_name"),"attributes.product_cat_name",DE(""))#',
			record_date2 : '#IIf(IsDefined("attributes.record_date2"),"attributes.record_date2",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			iptal_invoice : '#IIf(IsDefined("attributes.iptal_invoice"),"attributes.iptal_invoice",DE(""))#',
			product_id : '#IIf(IsDefined("attributes.product_id"),"attributes.product_id",DE(""))#',
			product_name : '#IIf(IsDefined("attributes.product_name"),"attributes.product_name",DE(""))#',
			member_cat_type : '#IIf(IsDefined("attributes.member_cat_type"),"attributes.member_cat_type",DE(""))#',
			is_tevkifat : '#IIf(IsDefined("attributes.is_tevkifat"),"attributes.is_tevkifat",DE(""))#',
			turned_to_total_inv : '#IIf(IsDefined("attributes.turned_to_total_inv"),"attributes.turned_to_total_inv",DE(""))#',
			acc_type_id : '#IIf(IsDefined("attributes.acc_type_id"),"attributes.acc_type_id",DE(""))#',
			oby : '#IIf(IsDefined("attributes.oby"),"attributes.oby",DE(""))#',
			EMP_PARTNER_NAMEO : '#IIf(IsDefined("attributes.EMP_PARTNER_NAMEO"),"attributes.EMP_PARTNER_NAMEO",DE(""))#',
			startrow:'#IIf(IsDefined("attributes.startrow"),"attributes.startrow",DE(""))#',
			maxrows: '#IIf(IsDefined("attributes.maxrows"),"attributes.maxrows",DE(""))#',
			efatura_type: '#IIf(len(attributes.efatura_type),"attributes.efatura_type",DE(""))#',
			earchive_type: '#IIf(len(attributes.earchive_type),"attributes.earchive_type",DE(""))#',
			output_type: '#IIf(len(attributes.output_type),"attributes.output_type",DE(""))#',
			invoice_type: '#IIf(len(attributes.invoice_type),"attributes.invoice_type",DE(""))#',
            authorized_emp: '#IIf(xml_is_authorized eq 0,"session.ep.userid",DE(""))#',
            branch_id : '#IIf(len(attributes.branch_id2),"attributes.branch_id2",DE(""))#',
            dept_id : '#IIf(len(attributes.dept_id),"attributes.dept_id",DE(""))#',
            process_stage : '#IIf(IsDefined("attributes.process_stage"),"attributes.process_stage",DE(""))#',
            from_report : '#IIf(IsDefined("attributes.from_report"),"attributes.from_report",DE(""))#'
			);
	</cfscript>
	<cfif get_bill.recordcount>
		<cfparam name="attributes.totalrecords" default="#get_bill.query_count#">
	<cfelse>
		<cfparam name="attributes.totalrecords" default="0">
	</cfif>
<cfelse>
	<cfparam name="attributes.totalrecords" default="0">	
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box> 
        <cfform name="form" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bill">
            <input name="form_varmi" id="form_varmi" value="1" type="hidden">
                <cf_box_search>
                    <div class="form-group" id="form_ul_keyword">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57460.Filtre"></cfsavecontent>
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#message#">
                    </div>
                    <div class="form-group" id="form_ul_belge_no">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="57487.No"></cfsavecontent>
                        <cfinput type="text" name="belge_no" value="#attributes.belge_no#" placeholder="#message#">
                    </div>
                    <div class="form-group" id="form_ul_oby">
                        <select name="oby" id="oby" style="width:100px;">
                            <option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
                            <option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
                            <option value="3" <cfif isDefined('attributes.oby') and attributes.oby eq 3>selected</cfif>><cf_get_lang dictionary_id='57215.Artan Fatura No'></option>
                            <option value="4" <cfif isDefined('attributes.oby') and attributes.oby eq 4>selected</cfif>><cf_get_lang dictionary_id='57216.Azalan Fatura No'></option>
                        </select>
                    </div>
                    <div class="form-group" id="form_ul_listing_type">
                        <select name="listing_type" id="listing_type" style="width:100px;">
                            <option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
                            <option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
                        </select>
                    </div>
                    <div class="form-group small">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,1250" required="yes" message="#message#">
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button search_function='input_control()' button_type="4">
                    </div>
                </cf_box_search>
                <cf_box_search_detail> 
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <cfif xml_show_process_stage eq 1>
                                <div class="form-group" id="item-process_stage">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
                                    <div class="col col-12 col-xs-12">
                                        <cf_workcube_process is_upd='0' select_value='#attributes.process_stage#' is_select_text='1' process_cat_width='150' is_detail='0'>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="form_ul_detail">
                                <label class="col col-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                                <div class="col col-12">
                                        <cfinput type="text" name="detail" value="#attributes.detail#" maxlength="500">
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_EMP_PARTNER_NAMEO">
                                <label class="col col-12"><cf_get_lang dictionary_id='57021.Satışı Yapan'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="EMPO_ID" id="EMPO_ID" value="<cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)><cfoutput>#attributes.EMPO_ID#</cfoutput></cfif>">
                                        <input type="hidden" name="PARTO_ID" id="PARTO_ID" value="<cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)><cfoutput>#attributes.PARTO_ID#</cfoutput></cfif>" >
                                        <input type="text" name="EMP_PARTNER_NAMEO" id="EMP_PARTNER_NAMEO" value="<cfif isdefined("attributes.EMP_PARTNER_NAMEO") and len(attributes.EMP_PARTNER_NAMEO)><cfoutput>#attributes.EMP_PARTNER_NAMEO#</cfoutput></cfif>" onfocus="AutoComplete_Create('EMP_PARTNER_NAMEO','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID,PARTNER_CODE','EMPO_ID,PARTO_ID','','3','250');">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1,2&field_name=form.EMP_PARTNER_NAMEO&field_partner=form.PARTO_ID&field_EMP_id=form.EMPO_ID</cfoutput>','list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_record_emp_id">
                                <label class="col col-12"><cf_get_lang dictionary_id='57899.Kaydeden'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <input type="hidden" name="record_emp_id" id="record_emp_id" value="<cfif len(attributes.record_emp_id)><cfoutput>#attributes.record_emp_id#</cfoutput></cfif>">
                                    <input type="text" name="record_emp_name" id="record_emp_name" style="width:120px;" onfocus="AutoComplete_Create('record_emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','record_emp_id','form','3','135')" value="<cfif len(attributes.record_emp_name)><cfoutput>#attributes.record_emp_name#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_name=form.record_emp_name&field_emp_id=form.record_emp_id<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1,9','list');return false"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_department_txt">
                                <label class="col col-12"><cf_get_lang dictionary_id='58763.Depo'></label>
                                <div class="col col-12">
                                                <cf_wrkdepartmentlocation 
                                                    returninputvalue="location_id,department_txt,department_id"
                                                    returnqueryvalue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
                                                    fieldname="department_txt"
                                                    fieldid="location_id"
                                                    department_fldid="department_id"
                                                    department_id="#attributes.department_id#"
                                                    location_id="#attributes.location_id#"
                                                    location_name="#attributes.department_txt#"
                                                    user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
                                                    user_location = "0"
                                                    width="140">
                                </div>
                            </div>
                            <div class="form-group" id="item-branch_id">
                                <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                                <div class="col col-12">
                                    <cf_wrkdepartmentbranch fieldid='branch_id2' is_branch='1' width='135' is_default='0' is_deny_control='1' selected_value='#attributes.branch_id2#'>
                                </div>
                            </div> 
                            <div class="form-group" id="item-dept_id">
                                <label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
                                <div class="col col-12">
                                    <cf_wrkdepartmentbranch fieldid='dept_id' is_department='1' width='135' is_deny_control='0' selected_value='#attributes.dept_id#'>
                                </div>
                            </div>    
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <cfif session.ep.our_company_info.is_efatura>
                                <div class="form-group" id="form_ul_efatura_type">
                                <label class="col col-12"><cf_get_lang dictionary_id="29872.E-Fatura"></label>
                                    <div class="col col-12">
                                        <select name="efatura_type" id="efatura_type">
                                            <option value=""><cf_get_lang dictionary_id="29872.E-Fatura"></option>
                                            <option value="1" <cfif attributes.efatura_type eq 1>selected</cfif>><cf_get_lang dictionary_id="59329.Gönderilecekler">(<cf_get_lang dictionary_id="57448.Satış">)</option>
                                            <option value="2" <cfif attributes.efatura_type eq 2>selected</cfif>><cf_get_lang dictionary_id="59776.E-Fatura Kesilenler">(<cf_get_lang dictionary_id="44640.Alış-Satış">)</option>
                                            <option value="3" <cfif attributes.efatura_type eq 3>selected</cfif>><cf_get_lang dictionary_id="57500.Onay">(<cf_get_lang dictionary_id="57448.Satış">)</option>
                                            <option value="4" <cfif attributes.efatura_type eq 4>selected</cfif>><cf_get_lang dictionary_id="29537.Red">(<cf_get_lang dictionary_id="57448.Satış">)</option>
                                            <option value="6" <cfif attributes.efatura_type eq 6>selected</cfif>><cf_get_lang dictionary_id="59332.Gönderilemeyenler"></option>
                                            <option value="7" <cfif attributes.efatura_type eq 7>selected</cfif>><cf_get_lang dictionary_id="59337.Onay Bekleyenler"></option>
                                            <option value="5" <cfif attributes.efatura_type eq 5>selected</cfif>><cf_get_lang dictionary_id="59338.E-Fatura Olmayanlar"></option>
                                        </select>
                                    </div>
                                </div>
                            </cfif>
                            <div class="form-group" id="form_ul_product_name">
                                <label class="col col-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                                        <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                                        <input type="text"   name="product_name"  id="product_name" style="width:140px;"  value="<cfoutput>#attributes.product_name#</cfoutput>" passthrough="readonly=yes" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','PRODUCT_ID,STOCK_ID','product_id,stock_id','','3','225');" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form.stock_id&product_id=form.product_id&field_name=form.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.form.product_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_record_date">
                                <label class="col col-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lütfen Tarih giriniz'></cfsavecontent>
                                        <cfinput type="text" name="record_date" value="#dateformat(attributes.record_date,dateformat_style)#" validate="#validate_style#" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="record_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_start_date">
                                <label class="col col-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                <div class="col col-12">
                                    <div class="col col-6 pl-0">
                                        <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                        <cfif session.ep.our_company_info.unconditional_list>
                                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                        <cfelse>
                                            <cfif isdefined("url.cat")>
                                                <cfinput type="text" name="start_date" value="" style="width:65px;" validate="#validate_style#" required="no" maxlength="10" message="#message#">
                                            <cfelse>
                                            <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#"  style="width:65px;" validate="#validate_style#" required="yes" maxlength="10" message="#message#">
                                            </cfif>
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6 pr-0">  
                                        <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.bitiş tarihi girmelisiniz'></cfsavecontent>
                                        <cfif session.ep.our_company_info.unconditional_list> 
                                            <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
                                        <cfelse>
                                            <cfif isdefined("url.cat") >
                                                <cfinput type="text" name="finish_date" value="" style="width:65px;" validate="#validate_style#" maxlength="10" required="no" message="#message#">			
                                            <cfelse>
                                                <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" required="yes" message="#message#">			
                                            </cfif>
                                        </cfif>
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_project_id">
                                <label class="col col-12"><cf_get_lang dictionary_id='57416.Proje'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <cfif isdefined ("url.pro_id") and  len(url.pro_id)><cfset attributes.project_id=url.pro_id></cfif><!--- Proje icmal raporundan baska bir yerde kullanilmiyorsa pro_id kontrolu kaldirilabilir FBS 20110607 --->
                                    <cfif Len(attributes.project_id) and Len(attributes.project_head)><cfset attributes.project_head = get_project_name(attributes.project_id)></cfif><!--- Buraya baska sayfalardan da erisiliyor, kaldirmayin FBS 20110607 --->
                                    <input type="hidden" name="project_id" id="project_id" value="<cfif len (attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
                                    <input type="text" name="project_head" id="project_head" value="<cfoutput>#attributes.project_head#</cfoutput>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','150');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form.project_id&project_head=form.project_head&allproject=1');"></span>
                                </div>
                                </div>
                            </div>
                            <cfif session.ep.our_company_info.is_earchive>
                                <cfquery name="GET_OUR_COMPANY" datasource="#DSN#">
                                    SELECT
                                        EARCHIVE_INTEGRATION_TYPE
                                    FROM
                                        EARCHIVE_INTEGRATION_INFO
                                    WHERE
                                        COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
                                </cfquery>
                                <div class="form-group" id="form_ul_earchive_type">
                                    <label class="col col-12"><cf_get_lang dictionary_id="57145.E-Arşiv"></label>
                                    <div class="col col-12">
                                        <select name="earchive_type" id="earchive_type">
                                            <option value=""><cf_get_lang dictionary_id="57145.E-Arşiv"></option>
                                            <option value="1" <cfif attributes.earchive_type eq 1>selected</cfif>><cf_get_lang dictionary_id='59329.Gönderilecekler'></option>
                                            <option value="2" <cfif attributes.earchive_type eq 2>selected</cfif>><cf_get_lang dictionary_id='59330.Gönderilenler(KAĞIT)'></option>
                                            <option value="4" <cfif attributes.earchive_type eq 4>selected</cfif>><cf_get_lang dictionary_id='59331.Gönderilenler(ELEKTRONİK)'></option>
                                            <option value="3" <cfif attributes.earchive_type eq 3>selected</cfif>><cf_get_lang dictionary_id='59332.Gönderilemeyenler'></option>
                                            <option value="5" <cfif attributes.earchive_type eq 5>selected</cfif>><cf_get_lang dictionary_id='64100.Alınanlar (ELEKTRONİK)'></option>
                                        </select>
                                    </div>
                                </div>
                                <cfif get_our_company.earchive_integration_type eq 1><!--- ing ise --->
                                    <div class="form-group" id="form_ul_output_type">
                                    <label class="col col-12"><cf_get_lang dictionary_id="57143.Gönderim Tipi"></label>
                                        <div class="col col-12">
                                            <select name="output_type" id="output_type" style="width:90px;">
                                                <option value=""><cf_get_lang dictionary_id="57143.Gönderim Tipi"></option>
                                                <option value="0000" <cfif attributes.output_type eq 0000>selected</cfif>>000-<cf_get_lang dictionary_id="30941.Boş"></option>
                                                <option value="0001" <cfif attributes.output_type eq 0001>selected</cfif>>001-<cf_get_lang dictionary_id="29766.XML"></option>
                                                <option value="0010" <cfif attributes.output_type eq 0010>selected</cfif>>010-<cf_get_lang dictionary_id="29733.PDF"></option>
                                                <option value="0011" <cfif attributes.output_type eq 0011>selected</cfif>>011-<cf_get_lang dictionary_id="29733.PDF"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="29766.XML"></option>
                                                <option value="0100" <cfif attributes.output_type eq 0100>selected</cfif>>100-<cf_get_lang dictionary_id="33152.Email"></option>
                                                <option value="0101" <cfif attributes.output_type eq 0101>selected</cfif>>101-<cf_get_lang dictionary_id="29766.XML"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="33152.Email"></option>
                                                <option value="0110" <cfif attributes.output_type eq 0110>selected</cfif>>110-<cf_get_lang dictionary_id="29733.PDF"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="33152.Email"></option>
                                                <option value="0111" <cfif attributes.output_type eq 0111>selected</cfif>>111-<cf_get_lang dictionary_id="29766.XML">,<cf_get_lang dictionary_id="29733.PDF"> <cf_get_lang dictionary_id="57989.ve"> <cf_get_lang dictionary_id="33152.Email"></option>
                                                <option value="0001,0011,0101,0111" <cfif attributes.output_type eq '0001,0011,0101,0111'>selected</cfif>><cf_get_lang dictionary_id="29766.XML"></option>
                                                <option value="0100,0101,0110,0111" <cfif attributes.output_type eq '0100,0101,0110,0111'>selected</cfif>><cf_get_lang dictionary_id="33152.Email"></option>
                                                <option value="0010,0011,0110,0111" <cfif attributes.output_type eq '0010,0011,0110,0111'>selected</cfif>><cf_get_lang dictionary_id="29733.PDF"></option>
                                            </select>
                                        </div>
                                    </div>
                                </cfif>
                            </cfif>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="form_ul_budget_record">
                                <label class="col col-12"><cf_get_lang dictionary_id ='57559.Bütçe'></label>
                                <cfsavecontent variable="header_"><cf_get_lang dictionary_id="57169.Bütçe Kaydı Olanlar/Bütçe Kaydı Olmayanlar"></cfsavecontent>                    
                                <div class="col col-12">
                                    <select name="budget_record" id="budget_record" style="width:90px;">
                                        <option value=""><cf_get_lang dictionary_id ='57559.Bütçe'> <cf_get_lang dictionary_id ='57075.Kaydı'></option>
                                        <option value="1" <cfif attributes.budget_record eq 1>selected</cfif>><cf_get_lang dictionary_id="57170.Bütçe Kaydı Olanlar"></option>
                                        <option value="0" <cfif attributes.budget_record eq 0>selected</cfif>><cf_get_lang dictionary_id="57171.Bütçe Kaydı Olmayanlar"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_invoice_type">
                                <label class="col col-12"><cf_get_lang dictionary_id='57441.Fatura'></label>
                                <div class="col col-12">
                                    <select name="invoice_type" id="invoice_type">
                                        <option value=""><cf_get_lang dictionary_id="57288.Fatura Tipi"></option>
                                        <option value="1" <cfif attributes.invoice_type eq 1>selected</cfif>><cf_get_lang dictionary_id="57274.Toplu Fatura"></option>
                                        <option value="2" <cfif attributes.invoice_type eq 2>selected</cfif>><cf_get_lang dictionary_id="57172.Grup Fatura"></option>
                                        <option value="3" <cfif attributes.invoice_type eq 3>selected</cfif>><cf_get_lang dictionary_id="41378.Manuel Fatura"></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_company">
                                <label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.consumer_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="company_id" id="company_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.company_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="employee_id" id="employee_id" <cfif len(attributes.company)> value="<cfoutput>#attributes.employee_id#</cfoutput>"</cfif>>
                                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type") and len(attributes.member_type)><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                        <input name="company" type="text" id="company" style="width:100px;" onfocus="AutoComplete_Create('company','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company)><cfoutput>#attributes.company#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&is_cari_action=1&field_comp_name=form.company&field_comp_id=form.company_id&field_consumer=form.consumer_id&field_member_name=form.company&field_emp_id=form.employee_id&field_name=form.company&field_type=form.member_type<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2,3,1,9</cfoutput>&keyword='+encodeURIComponent(document.form.company.value),'list')"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_control">
                                <label class="col col-12"><cf_get_lang dictionary_id='57441.Fatura'> <cf_get_lang dictionary_id='57038.Kontrolü'></label>
                                <div class="col col-12">
                                    <select name="control" id="control">
                                        <option value=""><cf_get_lang dictionary_id='57441.Fatura'> <cf_get_lang dictionary_id='57038.Kontrolü'></option>
                                        <option value="0" <cfif isDefined('attributes.control') and attributes.control eq 0>selected</cfif>><cf_get_lang dictionary_id='57314.Kontrol Edilmiş'></option>
                                        <option value="1" <cfif isDefined('attributes.control') and attributes.control eq 1>selected</cfif>><cf_get_lang dictionary_id='57315.Kontrol Edilmemiş'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_is_tevkifat">
                                <label class="col col-12"><cf_get_lang dictionary_id='57390.Tevkifatlı Faturalar Gelsin'></label>
                                <div class="col col-12">
                                    <label><input type="checkbox" name="is_tevkifat" id="is_tevkifat" value="1" <cfif isdefined("attributes.is_tevkifat") and attributes.is_tevkifat eq 1>checked</cfif>></label>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="form_ul_cat">
                                <label class="col col-12"><cf_get_lang dictionary_id='57124.İşlem Kategorisi'></label>
                                <div class="col col-12">
                                    <select name="cat" id="cat" style="width:200px;">
                                        <option value=""><cf_get_lang dictionary_id='57124.İşlem Kategorisi'></option>
                                        <option value="0" <cfif attributes.cat eq "0">selected</cfif>><cf_get_lang dictionary_id='57107.Alış Faturaları'></option>
                                        <option value="1" <cfif attributes.cat eq "1">selected</cfif>><cf_get_lang dictionary_id='57118.Satış Faturaları'></option>
                                        <cfoutput query="get_process_cat" group="process_type">
                                        <option value="#process_type#" <cfif '#process_type#' is attributes.cat>selected</cfif>>#get_process_name(process_type)#</option>										
                                        <cfoutput>
                                            <option value="#process_type#-#process_cat_id#" <cfif attributes.cat is '#process_type#-#process_cat_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#process_cat#</option>
                                        </cfoutput>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_member_cat_type">
                                <label class="col col-12"><cf_get_lang dictionary_id='58609.Üye Kategorisi'></label>
                                <div class="col col-12">
                                    <select name="member_cat_type" id="member_cat_type" style="width:150px;">
                                        <option value="" selected><cf_get_lang dictionary_id='57004.Üye Kategorisi Seçiniz'></option>
                                        <option value="1" <cfif attributes.member_cat_type eq 1>selected</cfif>><cf_get_lang dictionary_id='58039.Kurumsal Üye Kategorileri'></option>
                                        <cfoutput query="get_companycat">
                                            <option value="1-#COMPANYCAT_ID#" <cfif attributes.member_cat_type is '1-#COMPANYCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#COMPANYCAT#</option>
                                        </cfoutput>
                                        <option value="2" <cfif attributes.member_cat_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58040.Bireysel Üye Kategorileri'></option>
                                        <cfoutput query="get_consumer_cat">
                                            <option value="2-#CONSCAT_ID#" <cfif attributes.member_cat_type is '2-#CONSCAT_ID#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#CONSCAT#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_payment_type">
                                <label class="col col-12"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></label>
                                <div class="col col-12">
                                    <div class="input-group">
                                    <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="<cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)><cfoutput>#attributes.card_paymethod_id#</cfoutput></cfif>">
                                    <input type="hidden" name="payment_type_id" id="payment_type_id" value="<cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)><cfoutput>#attributes.payment_type_id#</cfoutput></cfif>">
                                    <input type="text" name="payment_type" id="payment_type" value="<cfif isdefined("attributes.payment_type") and len(attributes.payment_type)><cfoutput>#attributes.payment_type#</cfoutput></cfif>" style="width:140px;" onfocus="AutoComplete_Create('payment_type','PAYMETHOD','PAYMETHOD','get_paymethod','\'1,2\'','PAYMETHOD_ID,PAYMENT_TYPE_ID','payment_type_id,card_paymethod_id','','3','200');" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_paymethods&field_id=form.payment_type_id&field_name=form.payment_type&field_card_payment_id=form.card_paymethod_id&field_card_payment_name=form.payment_type','medium');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_iptal_invoice">
                                <label class="col col-12"><cf_get_lang dictionary_id='58816.İptal Edilenler'></label>
                                <div class="col col-12">
                                    <select name="iptal_invoice" id="iptal_invoice">
                                        <option value=""><cf_get_lang dictionary_id ='57708.Tümü'></option>
                                        <option value="1" <cfif attributes.iptal_invoice eq 1>selected</cfif>><cf_get_lang dictionary_id='58816.İptal Edilenler'></option>
                                        <option value="0" <cfif attributes.iptal_invoice eq 0>selected</cfif>><cf_get_lang dictionary_id='58817.İptal Edilmeyenler'></option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="form_ul_product_cat_code">
                                <label class="col col-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-12">
                                <div class="input-group">
                                <input type="hidden" name="product_cat_code" id="product_cat_code" value="<cfif len(attributes.product_cat_code) and len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_code#</cfoutput></cfif>">
                                    <input name="product_cat_name" type="text" id="product_cat_name" onfocus="AutoComplete_Create('product_cat_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','product_cat_code','','3','200');" value="<cfif len(attributes.product_cat_name)><cfoutput>#attributes.product_cat_name#</cfoutput></cfif>" autocomplete="off">
                                    <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=form.product_cat_code&field_name=form.product_cat_name</cfoutput>');"></span>
                                </div>
                                </div>
                            </div>           
                        </div>
            </cf_box_search_detail> 
        </cfform>
    </cf_box>

    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58917.Faturalar"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1" responsive_table="1" woc_setting = "#{ checkbox_name : 'print_invoice_id', print_type : 10 }#">
        <form name="form_print_reset">
            <cf_grid_list sort="1">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='31257.Kayıt No'></th>
                        <th><cf_get_lang dictionary_id='29412.Seri'></th>
                        <cfif xml_show_process_stage eq 1>
                            <th width="70"><cf_get_lang dictionary_id='58859.Süreç'></th>
                        </cfif> 
                        <th><cf_get_lang dictionary_id='58133.Fatura No'></th>
                         <cfif isdefined("xml_show_subscription_no") and xml_show_subscription_no eq 1>
                            <th><cf_get_lang dictionary_id='29502.Abone No'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57630.Tip'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                        <cfif xml_company_no eq 1>
                            <th nowrap="nowrap"><cf_get_lang dictionary_id='58061.Cari'><cf_get_lang dictionary_id='57487.No'></th>
                        </cfif>
                        <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                            <th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
                            <th><cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57638.Birim Fiyat'></th>
                        </cfif>
                        <th><cf_get_lang dictionary_id='57519.cari hesap'></th>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                        <th><cf_get_lang dictionary_id='57416.Proje'></th>  
                        <cfif is_show_due_date eq 1>
                            <th><cf_get_lang dictionary_id='57881.Vade Tarihi'></th>
                        </cfif>
                        <cfif is_show_amount eq 1>
                            <th style="text-align:right;"><cf_get_lang dictionary_id='57212.KDV siz Toplam'></th>
                            <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                            <th style="text-align:right;"><cf_get_lang dictionary_id='57642.Net Toplam'></th>
                            <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                        </cfif>
                        <cfif is_other_value_show eq 1 and is_show_amount eq 1>
                            <th style="text-align:right;"><cf_get_lang dictionary_id ='57386.Döviz Net Toplam'></th>
                            <th><cf_get_lang dictionary_id ='57489.Para Br'></th>
                        </cfif>
                        <cfif xml_tevkifat_show eq 1>
                            <th><cf_get_lang dictionary_id ='57391.Tevkifat Oranı'></th>
                        </cfif>
                        <cfif xml_paymethod_show eq 1> 
                            <th><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></th>
                        </cfif> 
                        <cfif attributes.iptal_invoice neq 0><th><cf_get_lang dictionary_id='57144.İ'></th></cfif>
                        <th nowrap="nowrap"><cf_get_lang dictionary_id='36199.Açıklama'></th>
                        <!-- sil -->
                        <th class="header_icn_none"><cfif session.ep.isBranchAuthorization>&nbsp;<cfelse><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.popup_collected_print','wide');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></cfif></th>
                        <cfif session.ep.our_company_info.is_efatura>
                        <th class="header_icn_none text-center"><i class="fa fa-etsy" alt="<cf_get_lang dictionary_id='29872.E-Fatura'>" title="<cf_get_lang dictionary_id='29872.E-Fatura'>"/></i></th>
                        </cfif>
                        <th class="header_icn_none text-center">(P)</th>
                        <!--- <cfif xml_print_update eq 1> --->
                        <th width="20" nowrap="nowrap" class="text-center header_icn_none">
                            <cfif isdefined("attributes.form_varmi") and get_bill.recordcount>
                                <cfif xml_print_update eq 1><a href="javascript://" onclick="send_print_reset();"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>" title="<cf_get_lang dictionary_id='57389.Print Sayisi Sifirla'>"></i></a></cfif>
                                <input type="checkbox" name="allSelectDemand" id="allSelectDemand" onclick="wrk_select_all('allSelectDemand','print_invoice_id');">
                            </cfif>
                        </th>
                        <!--- </cfif> --->
                        <!-- sil -->
                    </tr>
                </thead>
                <tbody>
                    <cfif isdefined("attributes.form_varmi") and get_bill.recordcount>
                        <cfoutput query="get_bill">
                            <tr>
                            <td>
                                <cfif listfind("50,51,52,53,54,55,56,561,57,58,59,60,601,61,62,63,65,66,67,531,533,591,592,48,49,532,5311,651,661,640,680",get_bill.invoice_cat,",")>
                                    <cfif get_bill.purchase_sales>
                                        <cfif listfind("65,651",get_bill.invoice_cat,",")>
                                            <a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                            <cfset link_str="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#get_bill.invoice_id#" >
                                        <cfelseif listfind("66,661",get_bill.invoice_cat,",")>
                                            <a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                            <cfset link_str="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#get_bill.invoice_id#" >
                                        <cfelseif get_bill.invoice_cat eq 52>
                                            <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                            <cfset link_str="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.add_bill_retail&event=upd&iid=#get_bill.invoice_id#">
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                            <cfset link_str="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill&event=upd&iid=#get_bill.invoice_id#">
                                        </cfif>
                                    <cfelseif not get_bill.purchase_sales>
                                        <cfif invoice_cat eq 592>
                                            <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                            <cfset link_str="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.marketplace_commands&event=upd&iid=#get_bill.invoice_id#">
                                        <cfelse>
                                            <cfif listfind("65,651",get_bill.invoice_cat,",")>
                                                <a href="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                                <cfset link_str="#request.self#?fuseaction=invent.add_invent_purchase&event=upd&invoice_id=#get_bill.invoice_id#" >
                                            <cfelseif listfind("66,661",get_bill.invoice_cat,",")>
                                                <a href="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                                <cfset link_str="#request.self#?fuseaction=invent.add_invent_sale&event=upd&invoice_id=#get_bill.invoice_id#" >
                                            <cfelse>
                                                <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                                <cfset link_str="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_purchase&event=upd&iid=#get_bill.invoice_id#">
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                <cfelse>
                                    <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#get_bill.invoice_id#" class="tableyazi">#get_bill.invoice_id#</a>
                                    <cfset link_str="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.form_add_bill_other&event=upd&iid=#get_bill.invoice_id#">
                                </cfif>
                            </td>
                            <td>#get_bill.serial_number#</td>
                            <cfif xml_show_process_stage eq 1>
                                <td>#STAGE#</td>
                            </cfif>
                            <td><a href="#link_str#" class="tableyazi"><cfif len(get_bill.serial_no)>#get_bill.serial_no#<cfelse>#get_bill.invoice_number#</cfif></a></td>
                            <cfif isdefined("xml_show_subscription_no") and xml_show_subscription_no eq 1>
                                <td>
                                    <cfif len(subscription_id)>
                                        <cfset subscription_no = get_subscription_no(subscription_id)>
                                    <cfelse>
                                        <cfset subscription_no = "">
                                    </cfif>
                                    #subscription_no#
                                </td>
                            </cfif>
                            <td><cfif is_iptal eq 1><font color="red"></cfif>
                                <!--- <cfif x_show_process_cat eq 1>#get_process_cat_row.process_cat[listfind(process_cat_id_list,process_cat,',')]#<cfelse>#get_process_name(invoice_cat)#</cfif> --->
                                #process_cat#
                                <cfif is_iptal eq 1></font></cfif>
                            </td>
                            <td>#dateformat(invoice_date,dateformat_style)#</td>
                            <td>#dateformat(record_date,dateformat_style)#</td>
                                <cfif xml_company_no eq 1>
                                    <td>#Member_Code#</td>
                                </cfif>
                                <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
                                    <td>#stock_code#</td>
                                    <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#name_product#</a></td>
                                    <td style="mso-number-format:0\.00;">#TLFormat(amount)#</td>
                                    <td style="text-align:right;">#TLFormat(price)#</td>
                                </cfif>
                            <td width="200">
                                <cfif len(get_bill.company_id)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_bill.company_id#','medium');">#fullname#</a>
                                <cfelseif len(get_bill.con_id)>
                                    <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#get_bill.con_id#','medium');">#consumer_name# #consumer_surname#</a>
                                <cfelse>
                                    #get_emp_info(get_bill.employee_id,0,1)#
                                </cfif>
                            </td>
                            <td><cfif len(get_bill.department_id) and LEN(branch_name)>#branch_name#</cfif></td>
                            <td>
                                <cfif isdefined("get_bill.project_id") and len(get_bill.project_id) and get_bill.project_id neq -1> 
                                    <a href="#request.self#?fuseaction=project.projects&event=det&id=#project_id#" class="tableyazi">#get_bill.project_head#</a></td>
                                <cfelseif get_bill.project_id eq -1>
                                    <cf_get_lang dictionary_id='58459.projesiz'>
                                </cfif>
                            </td>
                            <cfif is_show_due_date eq 1>
                                <td>#dateformat(due_date,dateformat_style)#</td>
                            </cfif>		
                            <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2 and is_show_amount eq 1>
                                <td style="text-align:right; mso-number-format:'##\,####0\.00'">#TLFormat(get_bill.nettotal + get_bill.otvtotal)# </td>
                                <td>&nbsp;#session.ep.money#</td>
                                <td style="text-align:right; mso-number-format:'##\,####0\.00'">#TLFormat(get_bill.nettotal + get_bill.taxtotal + get_bill.otvtotal + get_bill.bsmv_total + get_bill.oiv_total)# </td>
                                <td>&nbsp;#session.ep.money#</td>
                            <cfelseif is_show_amount eq 1>
                                <td style="text-align:right; mso-number-format:'##\,####0\.00'">#TLFormat(get_bill.nettotal - get_bill.taxtotal - get_bill.bsmv_total - get_bill.oiv_total)# </td><!--- bu deger kdvsiz fatura tutaridir --->
                                <td>&nbsp;#session.ep.money#</td>
                                <td style="text-align:right; mso-number-format:'##\,####0\.00'">#TLFormat(get_bill.nettotal)#</td><!--- bu deger kdv dahil fatura tutaridir --->
                                <td>&nbsp;#session.ep.money#</td>
                            </cfif>
                            <cfif is_other_value_show eq 1 and is_show_amount eq 1>
                                <td style="text-align:right; mso-number-format:'##\,####0\.00'"><cfif attributes.listing_type eq 2>#TLFormat(get_bill.row_other_value)#<cfelse>#TLFormat(get_bill.other_money_value)#</cfif></td>
                                <td style="text-align:left;">&nbsp;<cfif attributes.listing_type eq 2>#row_money#<cfelse>#other_money#</cfif></td>
                            </cfif>
                            <cfif xml_tevkifat_show eq 1>
                                <td style="text-align:right; mso-number-format:'##\,####0\.00'">#TLFormat(get_bill.tevkifat_oran)#</td>
                            </cfif>   
                            <cfif xml_paymethod_show eq 1> 
                                <td><cfif len(paymethod)>#paymethod#<cfelseif len(card_no)>#card_no#</cfif></td>
                            </cfif> 
                            <cfif attributes.iptal_invoice neq 0>
                                <cfif is_iptal eq 1><td style="text-align:center;"><img src="/images/caution_small.gif" title="<cf_get_lang dictionary_id ='58506.İptal'>"></td><cfelse><td></td></cfif>
                            </cfif>
                            <td title="#get_bill.note#">#Left(get_bill.note,50)#</td>
                            <!-- sil -->
                            <td style="text-align:center;"><a href="javascript://" target="" onclick="window.open('#request.self#?fuseaction=objects.popup_print_files&action=#attributes.fuseaction#&action_type=#get_bill.invoice_cat#&iid=#GET_BILL.INVOICE_ID#&print_type=10','WOC');"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></i></a></td>
                            <cfif session.ep.our_company_info.is_efatura>
                                <td style="text-align:center;">
                                    <cfif ((len(use_efatura) and use_efatura and len(invoice_type_code)) or einvoice_control gt 0) and (not listfind('640,680',get_bill.invoice_cat,',')) and not (isdefined("earchive_control") and earchive_control gt 0)>
                                        <cfif listfind('110,80,60,50',get_bill.status_code) and sender_type eq 5>
                                            <a title="#profile_id# <cf_get_lang dictionary_id='61159.Tekrar Gönderilecek'>"><img src="images/icons/efatura_purple.gif" align="absmiddle"/></a>
                                        <cfelseif get_bill.status_code eq 40 and sender_type eq 7>
                                            <a title="#profile_id# <cf_get_lang dictionary_id='61159.Tekrar Gönderilecek'>"><img src="images/icons/efatura_purple.gif" align="absmiddle"/></a>
                                        <cfelseif status eq 1>
                                            <a title="#profile_id# <cf_get_lang dictionary_id='58699.Onaylandı'>"><img src="images/icons/efatura_green.gif" /></a>
                                        <cfelseif len(efatura_count) and efatura_count gt 0>
                                            <a title="<cf_get_lang dictionary_id='61160.E-Fatura Kesildi'>"><img src="images/icons/efatura_green.gif" /></a>
                                        <cfelseif status eq 0>
                                            <a title="<cf_get_lang dictionary_id='29537.Red'>"><img src="images/icons/efatura_red.gif" /></a>
                                        <cfelseif einvoice_count gt 0 and len(path)>
                                            <a title="<cf_get_lang dictionary_id='57615.Onay Bekliyor'>"><img src="images/icons/efatura_yellow.gif" /></a>
                                        <cfelseif datediff('d',createodbcdatetime('#year(session.ep.our_company_info.efatura_date)#-#month(session.ep.our_company_info.efatura_date)#-#day(session.ep.our_company_info.efatura_date)#'),invoice_date) gt 0>
                                            <a title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>"><img title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" alt="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" src="images/icons/efatura_blue.gif" /></a>
                                        </cfif>
                                    <cfelseif session.ep.our_company_info.is_earchive>
                                        <cfif len(invoice_type_code) and (not listfind('640,680',get_bill.invoice_cat,','))>
                                            <cfif is_cancel eq 1>
                                                <a title="<cf_get_lang dictionary_id='58506.İptal'>"><img src="images/icons/earchive_red.gif" /></a>
                                            <cfelseif status_einvoice eq 1>
                                                <a title="<cf_get_lang dictionary_id='61158.E-Arşiv gönderildi'>"><img src="images/icons/earchive_green.gif" /></a>
                                            <cfelseif status_einvoice eq 0>
                                                <a title="<cf_get_lang dictionary_id='61157.E-Arşiv gönderilemedi'>"><img src="images/icons/earchive_purple.gif" /></a>
                                            <cfelseif not len(status_einvoice) and len(path_einvoice)>
                                                <a title="<cf_get_lang dictionary_id='61156.E-Arşiv gönderiliyor'>"><img src="images/icons/earchive_yellow.gif" /></a>
                                            <cfelseif datediff('d',createodbcdatetime('#year(session.ep.our_company_info.earchive_date)#-#month(session.ep.our_company_info.earchive_date)#-#day(session.ep.our_company_info.earchive_date)#'),invoice_date) gte 0>
                                                <a title="Gönderilmedi"><img title="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" alt="<cf_get_lang dictionary_id='40103.Gönderilmedi'>" src="images/icons/earchive_blue.gif" /></a>
                                            </cfif>
                                        </cfif>
                                    </cfif>
                                </td>
                            </cfif>
                            <td align="center"><font color="red">#print_count#</font></td>
                            <!--- <cfif xml_print_update eq 1> --->
                            <td style="text-align:center"><input type="checkbox" name="print_invoice_id" id="print_invoice_id" data-action-type = "#get_bill.invoice_cat#" value="#invoice_id#"></td>
                            <!--- </cfif> --->
                            
                            <!-- sil -->
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <cfset colspan = 15>		
                            <cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2>
                                <cfset colspan = colspan + 4>
                            </cfif>
                            <cfif is_show_amount eq 1>	
                                <cfset colspan = colspan + 4>
                            </cfif>
                            <cfif is_other_value_show eq 1 and is_show_amount eq 1>		
                                <cfset colspan = colspan + 2>
                            </cfif>
                            <cfif xml_tevkifat_show eq 1>	
                                <cfset colspan = colspan + 1>
                            </cfif>	
                            <cfif xml_paymethod_show eq 1>	
                                <cfset colspan = colspan + 1>
                            </cfif>
                            <cfif attributes.iptal_invoice neq 0>
                                <cfset colspan = colspan + 1>
                            </cfif>	
                            <!--- <cfif xml_print_update eq 1> --->
                                <cfset colspan = colspan + 1>
                            <!--- </cfif> --->		
                            <cfif is_show_due_date eq 1>
                                <cfset colspan = colspan + 1>
                            </cfif>		
                            <td colspan="<cfoutput>#colspan#</cfoutput>"><cfif isdefined("attributes.form_varmi")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </form>
        <cfif attributes.totalrecords gt attributes.maxrows>    
            <cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_bill">
            <cfif isDefined('attributes.cat') and len(attributes.cat)>
                <cfset adres = "#adres#&cat=#attributes.cat#">
            </cfif>
            <cfif len(attributes.keyword)>
                <cfset adres = "#adres#&keyword=#attributes.keyword#">
            </cfif>
            <cfif len(attributes.belge_no)>
                <cfset adres = "#adres#&belge_no=#attributes.belge_no#">
            </cfif>
            <cfif isDefined('attributes.oby') and len(attributes.oby)>
                <cfset adres = "#adres#&oby=#attributes.oby#">
            </cfif>
            <cfif isDefined('attributes.control') and len(attributes.control)>
                <cfset adres = "#adres#&control=#attributes.control#">
            </cfif>
            <cfif isdate(attributes.record_date)>
                <cfset adres = "#adres#&record_date=#dateformat(attributes.record_date,dateformat_style)#">
            </cfif>
            <cfif isdate(attributes.start_date)>
                <cfset adres = "#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
            </cfif>
            <cfif isdate(attributes.finish_date)>
                <cfset adres = "#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
            </cfif>
            <cfif len(attributes.company_id)>
                <cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#&member_type=#attributes.member_type#">
            </cfif>
            <cfif len(attributes.consumer_id)>
                <cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#&member_type=#attributes.member_type#">
            </cfif>
            <cfif len(attributes.employee_id)>
                <cfset adres = "#adres#&employee_id=#attributes.employee_id#&company=#attributes.company#&member_type=#attributes.member_type#">
            </cfif>
            <cfif len(attributes.iptal_invoice)>
                 <cfset adres = "#adres#&iptal_invoice=#attributes.iptal_invoice#">
            </cfif>
            <cfif isdefined("attributes.form_varmi")>
                <cfset adres = "#adres#&form_varmi=#attributes.form_varmi#">
            </cfif>
            <cfif isdefined("attributes.pro_id")>
                <cfset adres = "#adres#&pro_id=#attributes.pro_id#">
            </cfif>
            <cfif isdefined("attributes.department_id") and len(attributes.department_id)>
                <cfset adres = "#adres#&department_id=#attributes.department_id#" >
            </cfif>
            <cfif isdefined("attributes.department_txt") and len(attributes.department_txt)>
                <cfset adres = "#adres#&department_txt=#attributes.department_txt#">
            </cfif>
            <cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
                <cfset adres = "#adres#&stock_id=#attributes.stock_id#">
            </cfif>
            <cfif isdefined("attributes.product_id") and len(attributes.product_id)>
                <cfset adres = "#adres#&product_id=#attributes.product_id#">
            </cfif>
            <cfif isdefined("attributes.product_name") and len(attributes.product_name)>
                <cfset adres = "#adres#&product_name=#attributes.product_name#">
            </cfif>
            <cfif isdefined("attributes.payment_type_id") and len(attributes.payment_type_id)>
                <cfset adres = "#adres#&payment_type_id=#attributes.payment_type_id#">
            </cfif>
            <cfif isdefined("attributes.card_paymethod_id") and len(attributes.card_paymethod_id)>
                <cfset adres = "#adres#&card_paymethod_id=#attributes.card_paymethod_id#">
            </cfif>
            <cfif isdefined("attributes.payment_type") and len(attributes.payment_type)>
                <cfset adres = "#adres#&payment_type=#attributes.payment_type#">
            </cfif>
            <cfif isdefined("attributes.EMPO_ID") and len(attributes.EMPO_ID)>
                <cfset adres = "#adres#&EMPO_ID=#attributes.EMPO_ID#">
            </cfif>
            <cfif isdefined("attributes.PARTO_ID") and len(attributes.PARTO_ID)>
                <cfset adres = "#adres#&PARTO_ID=#attributes.PARTO_ID#">
            </cfif>
            <cfif isdefined("attributes.project_id") and len(attributes.project_id)>
                <cfset adres = "#adres#&project_id=#attributes.project_id#">
            </cfif>
            <cfif isdefined("attributes.project_head") and len(attributes.project_head)>
                <cfset adres = "#adres#&project_head=#attributes.project_head#">
            </cfif>
            <cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id)>
                <cfset adres = "#adres#&record_emp_id=#attributes.record_emp_id#">
            </cfif>
            <cfif isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
                <cfset adres = "#adres#&record_emp_name=#attributes.record_emp_name#">
            </cfif>
            <cfif isdefined("attributes.detail") and len(attributes.detail)>
                <cfset adres = "#adres#&detail=#attributes.detail#">
            </cfif>
            <cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>
                <cfset adres = "#adres#&listing_type=#attributes.listing_type#">
            </cfif>
            <cfif isdefined("attributes.is_tevkifat") and len(attributes.is_tevkifat)>
                <cfset adres = "#adres#&is_tevkifat=#attributes.is_tevkifat#">
            </cfif>
            <cfif isdefined("attributes.budget_record") and len(attributes.budget_record)>
                <cfset adres = "#adres#&budget_record=#attributes.budget_record#">
            </cfif>
            <cfif isdefined("attributes.product_cat_code") and len(attributes.product_cat_name)>
                <cfset adres = "#adres#&product_cat_code=#attributes.product_cat_code#">
                <cfset adres = "#adres#&product_cat_name=#attributes.product_cat_name#">
            </cfif>
            <cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
                <cfset adres = "#adres#&process_stage=#attributes.process_stage#">
            </cfif>
            <cfif len(attributes.efatura_type)>
                <cfset adres = "#adres#&efatura_type=#attributes.efatura_type#">
            </cfif>
            <cfif len(attributes.earchive_type)>
                <cfset adres = "#adres#&earchive_type=#attributes.earchive_type#">
            </cfif>
            
            <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="#adres#">
        </cfif>
    </cf_box>
</div>

<script type="text/javascript">
document.getElementById('belge_no').focus();
function send_print_reset()
{
	invioce_id_list_ = "";
	for (i=0; i < document.form_print_reset.print_invoice_id.length; i++)
	{
		if(document.form_print_reset.print_invoice_id[i].checked == true)
		{
			invioce_id_list_ = invioce_id_list_ + document.form_print_reset.print_invoice_id[i].value + ',';
		}	
	}
	if(invioce_id_list_.length == 0)
	{
		alert("<cf_get_lang dictionary_id='57392.Güncellenecek Kayıt Bulunamadı ! Print Sıfırlama Yapamazsınız'> !");
		return false;
	}
	
	if(confirm("<cf_get_lang dictionary_id='57409.Şeçtiğiniz Faturaların Print Sayısı Sıfırlanacaktır Onaylıyormusunuz'> ?"))
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=invoice.emptypopup_collected_print_reset&print_invoice_id='+invioce_id_list_,'page');
	else 
		return false;
}

function input_control()
{
	<cfif not session.ep.our_company_info.unconditional_list and (isdefined("url.cat") and (url.cat eq 561 or url.cat eq 601 or url.cat eq 56 or url.cat eq 1 or url.cat eq 60 or url.cat eq 0))>
		if (form.start_date.value.length == 0 && form.finish_date.value.length == 0 &&form.belge_no.value.length == 0 && (form.department_id.value.length == 0 || form.department_txt.value.length == 0) && form.cat.value.length == 0 && (form.product_name.value.length == 0 || form.product_id.value.length == 0) && (form.company_id.value.length == 0 || form.company.value.length == 0) )
		{
			alert("<cf_get_lang dictionary_id='57526.En Az Bir Alanda Filtre Ediniz!'> !");
			return false;
		}
		else 
			return true;
	<cfelse>
		return true;
	</cfif>
}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">