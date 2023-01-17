  <script type="text/javascript">	
	function input_control()
	{
		is_ok = 0;
		if(search_product.product_cat.value.length == 0)
			search_product.product_catid.value = '';
		if(search_product.get_company.value.length == 0)
			search_product.get_company_id.value = '';
		if(search_product.employee.value.length == 0)
			search_product.pos_code.value = '';
		if(search_product.brand_name.value.length == 0)
			search_product.brand_id.value = '';
		if (search_product.product_catid.value != '')
			is_ok = 1;
		else if (search_product.get_company_id.value != '') 
			is_ok = 1;
		else if (search_product.brand_id.value != '')
			is_ok = 1;
		else if(search_product.pos_code.value != '')
			is_ok = 1;
		else if (search_product.product_name.value != '')
			is_ok = 1;
			
		if(is_ok != 1)
		{
			alert("<cf_get_lang dictionary_id='58950.En az bir Arama kriteri seçilmelisiniz'>!");
			return false;
		}
		else
		{
			if(search_product.is_active.selectedIndex > 1)
			{
				search_product.rec_date.disabled = false;				
			}
			return true;
		}
	}
	function disablePRecDate()
	{
		if (search_product.is_active.selectedIndex > 1)		{
			
			search_product.rec_date.disabled = true;
		}
		else
			search_product.rec_date.disabled = false;
	}
</script>

<cfif isdefined('attributes.get_company_id') and len(attributes.get_company_id)>
	<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.get_company_id#
	</cfquery>
	<cfset attributes.get_company = get_company_name.fullname>
</cfif>
<cfparam name="attributes.paymethod_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.hierarchy_code" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.price_cats_lists" default="">
<cfparam name="attributes.price_cats_list" default="">
<cfparam name="attributes.price_cat_list" default="">
<cfparam name="attributes.purchase_sales" default="2">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.rec_date" default="">
<cfparam name="attributes.brands" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.cond_company_id" default="">
<cfparam name="attributes.cond_company_name" default="">
<cfparam name="attributes.is_active" default="-2">
<cfparam name="attributes.price_cat" default="-2">
<cfparam name="attributes.company_id" default="">
<cfinclude template="../query/get_price_cats.cfm">
<cfif len(attributes.rec_date)>
	<cf_date tarih='attributes.rec_date'>
</cfif>
<cfquery name="GET_PAYMETHOD_TYPE" datasource="#DSN#">
	SELECT 
		SP.PAYMETHOD_ID,
		SP.PAYMETHOD 
	FROM 
		SETUP_PAYMETHOD SP,
		SETUP_PAYMETHOD_OUR_COMPANY SPOC
	WHERE 
		SP.PAYMETHOD_STATUS = 1
		AND SP.PAYMETHOD_ID = SPOC.PAYMETHOD_ID 
		AND SPOC.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
	ORDER BY 
		SP.PAYMETHOD
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_product" method="post" action="#request.self#?fuseaction=product.conditions">
			<cf_box_elements>
						<!-- sil -->	
						<input type="hidden" name="form_varmi" id="form_varmi" value="1">
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="form_ul_product_cat">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
										<input type="hidden" name="hierarchy_code" id="hierarchy_code" value="<cfoutput>#attributes.hierarchy_code#</cfoutput>">
										<input type="text" name="product_cat" id="product_cat" style="width:130px;" onFocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID,HIERARCHY','product_catid,hierarchy_code','','3','200');" value="<cfoutput>#attributes.product_cat#</cfoutput>" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product.hierarchy_code&field_id=search_product.product_catid&field_name=search_product.product_cat&keyword='+encodeURIComponent(document.search_product.product_cat.value)</cfoutput>);"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_brand">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
								<div class="col col-8 col-xs-12">
										<cf_wrkProductBrand width="130" compenent_name="getProductBrand" boxwidth="240" boxheight="150" brand_ID="#attributes.brand_id#" is_internet="1">
								</div>
							</div>
							<div class="form-group" id="form_ul_stock_id">	
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
										<input name="product_name" type="text" id="product_name"  style="width:130px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','','3','130');" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_product.stock_id&field_name=search_product.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.search_product.product_name.value),'list');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="form_ul_get_company_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
										<input name="get_company" type="text" id="get_company" style="width:130px;" onFocus="AutoComplete_Create('get_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','get_company_id','','3','250');" value="<cfif isdefined('attributes.get_company')><cfoutput>#attributes.get_company#</cfoutput></cfif>" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.get_company&field_comp_id=search_product.get_company_id&select_list=2&keyword='+encodeURIComponent(document.search_product.get_company.value),'list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_pos_code">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="pos_code" id="pos_code"  value="<cfoutput>#attributes.pos_code#</cfoutput>">
										<input name="employee" type="text" id="employee" style="width:130px;"  value="<cfoutput>#attributes.employee#</cfoutput>" maxlength="255">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_product.pos_code&field_code=search_product.pos_code&field_name=search_product.employee&select_list=1,9&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.employee.value),'list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="form_ul_rec_date">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37549.Ürün Kayıt Tarihi'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='37441.Ürün kayıt tarihinde hata'> !</cfsavecontent>
										<cfinput type="text" name="rec_date" value="#DateFormat(attributes.rec_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
										<span class="input-group-addon"><cf_wrk_date_image date_field="rec_date"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="form_ul_purchase_sales">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60498.Liste Tipi'></label>
								<div class="col col-8 col-xs-12">
									<select name="purchase_sales" id="purchase_sales" onChange="gizle_goster(mali);">
										<option value="1" <cfif attributes.purchase_sales eq 1>selected</cfif>><cf_get_lang dictionary_id='47199.Satınalma'></option>
										<option value="2" <cfif attributes.purchase_sales eq 2>selected</cfif>><cf_get_lang dictionary_id='57448.Satış'></option>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_price_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='35792.Kaynak'><cf_get_lang dictionary_id='30467.Liste'></label>
								<div class="col col-8 col-xs-12">
									<select name="is_active" id="is_active" onChange="disablePRecDate();">
										<option value="" selected><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></option>
										<option value="-1"<cfif attributes.is_active eq -1> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
										<option value="-2"<cfif attributes.is_active eq -2> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
										<cfoutput query="get_price_cats"> 
											<option value="#price_catid#" <cfif (price_catid is attributes.is_active)> selected</cfif>>#price_cat#</option>
										</cfoutput>
									</select>
								</div>
							</div>
							<div class="form-group" id="form_ul_price_catid">
								<label class="col col-4 col-xs-12"><cf_get_lang_main dictionary_id='57951.Hedef'><cf_get_lang dictionary_id='30467.Liste'></label>
								<div class="col col-8 col-xs-12">
									<div style="width:100%; z-index:1; position:relative;" id="mali" <cfif attributes.purchase_sales eq 1>style="display:none"</cfif>>
									<cf_multiselect_check 
										query_name="get_price_cats"  
										name="price_cat_list"
										option_text="#getLang('','Fiyat Listesi',58964)#" 
										width="175"
										option_name="price_cat" 
										value="#attributes.price_cat_list#"
										option_value="price_catid"> 
									</div>
								</div>
							</div>
						</div>
						<!--- <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
							<div class="form-group" id="form_ul_cond_company_name">
								<label class="col col-3 col-xs-12"><cf_get_lang_main no='107.Cari Hesap'></label>
								<div class="col col-9 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="cond_company_id" id="cond_company_id" value="<cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)><cfoutput>#attributes.cond_company_id#</cfoutput></cfif>">
										<input type="text" name="cond_company_name" id="cond_company_name" style="width:130px;" value="<cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)><cfoutput>#attributes.cond_company_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('cond_company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','cond_company_id','','3','250');" autocomplete="off">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=search_product.cond_company_name&field_comp_id=search_product.cond_company_id','list');"></span>
									</div>
								</div>
							</div>
						</div> --->
			</cf_box_elements>
			<div class="ui-form-list-btn">
				<span onClick="gizle_goster_ikili('mali','conditions_sepet');"></span>
				<cfsavecontent variable="button_head"><cf_get_lang dictionary_id='57565.Ara'></cfsavecontent>
				<cf_wrk_search_button button_name="#button_head#" button_type='5' float='right' search_function='input_control()' is_excel='0'>
			</div>
		</cfform>
	</cf_box>

<cfsavecontent variable="title2"><cf_get_lang dictionary_id='32084.Koşullar'></cfsavecontent>
<cfform method="post" name="add_p_s_discount" action="#request.self#?fuseaction=product.emptypopup_add_conditions">
	<cf_box title="#title2#" closable="0">
<div style="position:absolute;" id="open_process"></div>
<cf_grid_list>
		<cfquery name="GET_COMPANIES" datasource="#DSN1#">
			SELECT
				DISTINCT 
				POC.OUR_COMPANY_ID,
				OC.NICK_NAME
			FROM
				#dsn_alias#.OUR_COMPANY OC,
				PRODUCT_OUR_COMPANY POC,
				PRODUCT P
			WHERE
				POC.OUR_COMPANY_ID <> #session.ep.company_id# AND
				P.PRODUCT_STATUS = 1 AND
				P.PRODUCT_ID = POC.PRODUCT_ID AND
				POC.OUR_COMPANY_ID = OC.COMP_ID
				<cfif len(attributes.product_cat) and len(attributes.product_catid) and len(attributes.hierarchy_code)>AND P.PRODUCT_CODE LIKE '#attributes.hierarchy_code#.%'</cfif>
				<cfif len(attributes.employee) and len(attributes.pos_code)>AND P.PRODUCT_MANAGER = #attributes.pos_code#</cfif>
				<cfif len(attributes.get_company) and len(attributes.get_company_id)>AND P.COMPANY_ID = #attributes.get_company_id#</cfif>
				<cfif len(attributes.rec_date)>AND P.RECORD_DATE >= #attributes.rec_date#</cfif>
				<cfif len(attributes.product_name)>AND P.PRODUCT_NAME LIKE '<cfif len(attributes.product_name) gt 2>%</cfif>#attributes.product_name#%'</cfif>
			ORDER BY
				OC.NICK_NAME
		</cfquery>
          <thead>
			<tr>
				<th><input type="button" class="eklebuton" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row_product();"></th>
				<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
				<th width="130"><cf_get_lang dictionary_id='57657.Ürün'></th>
				<th width="85" style="text-align:right"><cfif attributes.purchase_sales eq 1><cf_get_lang dictionary_id='58722.Standart Alış'></th><cfelse><cf_get_lang dictionary_id='58721.Standart Satış'></cfif>
				<th width="45"><cf_get_lang dictionary_id='57489.Para Br'></th>
				<th width="35">i.1<cfinput type="text" name="disc1_all" class="box" style="width:75%;" onBlur="all_discount(1);" onkeyup="return(FormatCurrency(this,event));" value=""></th>
				<th width="35">i.2<cfinput type="text" name="disc2_all" class="box" style="width:75%;" onBlur="all_discount(2);" onkeyup="return(FormatCurrency(this,event));" value=""></th>
				<th width="35">i.3<cfinput type="text" name="disc3_all" class="box" style="width:75%;" onBlur="all_discount(3);" onkeyup="return(FormatCurrency(this,event));" value=""></th>
				<th width="35">i.4<cfinput type="text" name="disc4_all" class="box" style="width:75%;" onBlur="all_discount(4);" onkeyup="return(FormatCurrency(this,event));" value=""></th>
				<th width="35">i.5<cfinput type="text" name="disc5_all" class="box" style="width:75%;" onBlur="all_discount(5);" onkeyup="return(FormatCurrency(this,event));" value=""></th>
				<th width="75" style="text-align:right;"><cf_get_lang dictionary_id='37350.İsk Fiyat'></th>
				<th width="75" style="text-align:right;"><cf_get_lang dictionary_id='37380.İsk KDVli Fiyat'></th>
				<th width="150">
                <cf_get_lang dictionary_id='58516.Ödeme Yöntemi'>
                <!-- sil -->
                    <select name="paymethod_type_all" id="paymethod_type_all" onChange="all_paymethod(this.value)" class="box">
                        <cfloop query="get_paymethod_type">
                            <cfoutput><option value="#paymethod_id#" <cfif attributes.paymethod_id eq paymethod_id>selected</cfif>>#paymethod#</option></cfoutput>
                        </cfloop>
                    </select>
                <!-- sil -->
				</th>
				<th width="45"><cf_get_lang dictionary_id ='37754.Rebate Tutar-İSK'></th>
				<th width="60"><cf_get_lang dictionary_id ='37755.Back End Rebate'></th>
				<th width="60"><cf_get_lang dictionary_id ='37755.Back End Rebate'> %</th>
				<th width="60"><cf_get_lang dictionary_id ='37660.Mal Fazlası'></th>
				<th width="60"><cf_get_lang dictionary_id ='37662.İade Gün'> -<cf_get_lang dictionary_id ='58456.Oran'></th>
				<th width="45"><cf_get_lang dictionary_id ='37661.Fiyat Koruma Gün'></th>
				<!-- sil --><th width="10"><input type="checkbox" name="all_check" id="all_check" value="1" onClick="check_all(this.checked);"></th><!-- sil -->
			</tr>
		</thead>
		<tbody>
			<!-- sil -->
			<input type="hidden" name="employee" id="employee" value="<cfoutput>#attributes.employee#</cfoutput>">
			<input type="hidden" name="pos_code" id="pos_code" value="<cfoutput>#attributes.pos_code#</cfoutput>">
			<input type="hidden" name="product_cat" id="product_cat" value="<cfoutput>#attributes.product_cat#</cfoutput>">
			<input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
			<input type="hidden" name="purchase_sales" id="purchase_sales" value="<cfoutput>#attributes.purchase_sales#</cfoutput>">
			<input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
			<input type="hidden" name="get_company" id="get_company" value="<cfoutput>#attributes.get_company#</cfoutput>">
			<input type="hidden" name="price_cats_lists" id="price_cats_lists" value="<cfoutput>#attributes.price_cats_lists#</cfoutput>">
			<cfif isdefined("attributes.form_varmi")>
			<cfquery name="GET_PRODUCT" datasource="#DSN3#">
				SELECT 
					PRODUCT_NAME, 
					RECORD_DATE, 
					PRODUCT_CODE,
					PRODUCT_ID,
					TAX,
					TAX_PURCHASE
				FROM 
					PRODUCT 
					LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS ON PRODUCT.PRODUCT_MANAGER = EMPLOYEE_POSITIONS.POSITION_CODE
				WHERE 
					PRODUCT_STATUS = 1
					<cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)>
					<cfif attributes.purchase_sales eq 1>
					AND PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_PURCHASE_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#">)
					<cfelse>
					AND PRODUCT_ID IN (SELECT PRODUCT_ID FROM CONTRACT_SALES_PROD_DISCOUNT WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#">)
					</cfif>
					</cfif>
					<cfif isdefined('attributes.brand_id') and len(attributes.brand_name)>AND BRAND_ID = #attributes.brand_id#</cfif>
					<cfif len(attributes.product_cat) and len(attributes.product_catid) and len(attributes.hierarchy_code)>AND PRODUCT_CODE LIKE '#attributes.hierarchy_code#.%'</cfif>
					<cfif len(attributes.employee) and len(attributes.pos_code)>AND EMPLOYEE_ID = #attributes.pos_code#</cfif>
					<cfif len(attributes.get_company) and len(attributes.get_company_id)>AND COMPANY_ID = #attributes.get_company_id#</cfif>
					<cfif len(attributes.rec_date)>AND RECORD_DATE >= #attributes.rec_date#</cfif>
					<cfif len(attributes.product_name)>AND PRODUCT_NAME LIKE '<cfif len(attributes.product_name) gt 2>%</cfif>#attributes.product_name#%'</cfif>
			</cfquery>
			<!-- sil -->
			<cfif get_product.recordcount>
				<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
					<cfset attributes.startrow=1>
					<cfset attributes.maxrows = get_product.recordcount>
				</cfif>
				<cfset product_id_list=listsort(valuelist(get_product.product_id),"numeric","ASC",",")>
				<cfquery name="GET_DISCOUNT_PURCHASE_ALL" datasource="#DSN3#">
					SELECT 
						DISCOUNT1, 
						DISCOUNT2, 
						DISCOUNT3,
						DISCOUNT4,
						DISCOUNT5,
						PAYMETHOD_ID,
						RECORD_DATE,
						START_DATE,
						PRODUCT_ID,
						EXTRA_PRODUCT_1,
						EXTRA_PRODUCT_2,
						REBATE_CASH_1,
						REBATE_CASH_1_MONEY,
						RETURN_DAY,
						RETURN_RATE,
						PRICE_PROTECTION_DAY,
						REBATE_RATE,
						DISCOUNT_CASH,
						DISCOUNT_CASH_MONEY
					FROM 
						CONTRACT_PURCHASE_PROD_DISCOUNT 
					WHERE
						<cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)>
							COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#"> AND
						</cfif>
						PRODUCT_ID IN (#product_id_list#)
				</cfquery>
				<cfquery name="GET_DISCOUNT_SALES_ALL" datasource="#DSN3#">
					SELECT 
						CSPD.DISCOUNT1, 
						CSPD.DISCOUNT2, 
						CSPD.DISCOUNT3, 
						CSPD.DISCOUNT4,
						CSPD.DISCOUNT5, 
						CSPD.PAYMETHOD_ID,
						CSPD.RECORD_DATE,
						CSPD.START_DATE,
						CSPD.PRODUCT_ID,
						CSPD.EXTRA_PRODUCT_1,
						CSPD.EXTRA_PRODUCT_2,
						CSPD.REBATE_CASH_1,
						CSPD.REBATE_CASH_1_MONEY,
						CSPD.RETURN_DAY,
						CSPD.RETURN_RATE,
						CSPD.PRICE_PROTECTION_DAY,
						CSPD.REBATE_RATE,
						CSPD.DISCOUNT_CASH,
						CSPD.DISCOUNT_CASH_MONEY
					FROM 
						CONTRACT_SALES_PROD_DISCOUNT CSPD,
						CONTRACT_SALES_PROD_PRICE_LIST CSPP
					WHERE
						CSPD.C_S_PROD_DISCOUNT_ID = CSPP.C_S_PROD_DISCOUNT_ID AND
						<cfif Len(attributes.is_active) and Len(attributes.is_active)>
							CSPP.PRICE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_active#"> AND
						</cfif>
						<cfif Len(attributes.cond_company_id) and Len(attributes.cond_company_name)>
							CSPD.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cond_company_id#"> AND
						</cfif>
						CSPD.PRODUCT_ID IN (#product_id_list#)
				</cfquery>
				<cfquery name="GET_PRODUCT_PRICE_ALL" datasource="#DSN3#">
					SELECT
						MONEY,
						PRICE,
						PURCHASESALES,
						PRODUCT_ID
					FROM
						PRICE_STANDART
					WHERE
						PRODUCT_ID IN (#product_id_list#) AND
						PRICESTANDART_STATUS = 1
						<cfif attributes.purchase_sales eq 1>AND PURCHASESALES = 0
						<cfelseif attributes.purchase_sales eq 2>AND PURCHASESALES = 1</cfif>
					</cfquery>
				<cfoutput query="get_product">
					<cfif attributes.purchase_sales eq 1>
					<cfquery name="GET_PURCHASE_SALES_DISCOUNT" dbtype="query" maxrows="1">
						SELECT * FROM GET_DISCOUNT_PURCHASE_ALL WHERE PRODUCT_ID = #get_product.product_id# ORDER BY START_DATE DESC
					</cfquery>
					<cfelseif attributes.purchase_sales eq 2>
					<cfquery name="GET_PURCHASE_SALES_DISCOUNT" dbtype="query" maxrows="1">
						SELECT * FROM GET_DISCOUNT_SALES_ALL WHERE PRODUCT_ID = #get_product.product_id# ORDER BY RECORD_DATE DESC
					</cfquery>
					</cfif>
					<cfquery name="GET_PRODUCT_PRICE" dbtype="query">
					SELECT
						MONEY,
						PRICE
					FROM
						GET_PRODUCT_PRICE_ALL
					WHERE
						PRODUCT_ID = #get_product.product_id#
					<cfif attributes.purchase_sales eq 1>
						AND PURCHASESALES = 0
					<cfelseif attributes.purchase_sales eq 2>
						AND PURCHASESALES = 1
					</cfif>
					</cfquery>
					<cfscript>
					toplam_tutar_iskontolu = get_product_price.price;
					if(not len(toplam_tutar_iskontolu)) toplam_tutar_iskontolu=0;
					if (len(get_purchase_sales_discount.discount_cash))
						rebate = get_purchase_sales_discount.discount_cash;
					else
						rebate = 0;
					//toplam_tutar_iskontolu = toplam_tutar_iskontolu - rebate;
					
					if (len(get_purchase_sales_discount.discount1))
						alan_indirim_1 = get_purchase_sales_discount.discount1;
					else
						alan_indirim_1 = 0;
					if (len(get_purchase_sales_discount.discount2))
						alan_indirim_2 = get_purchase_sales_discount.discount2;
					else
						alan_indirim_2 = 0;
					if (len(get_purchase_sales_discount.discount3))
						alan_indirim_3 = get_purchase_sales_discount.discount3;
					else
						alan_indirim_3 = 0;
					if (len(get_purchase_sales_discount.discount4))
						alan_indirim_4 = get_purchase_sales_discount.discount4;
					else
						alan_indirim_4 = 0;
					if (len(get_purchase_sales_discount.discount5))
						alan_indirim_5 = get_purchase_sales_discount.discount5;
					else
						alan_indirim_5 = 0;

					toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_1)/100));
					toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_2)/100));
					toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_3)/100));
					toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_4)/100));
					toplam_tutar_iskontolu = toplam_tutar_iskontolu*(((100-alan_indirim_5)/100));
					
					toplam_tutat_iskontolu_kdvli = toplam_tutar_iskontolu;
					</cfscript>
				
					<cfif attributes.purchase_sales eq 1>
					<cfif tax_purchase neq 0>
						<cfset toplam_tutat_iskontolu_kdvli  = (toplam_tutat_iskontolu_kdvli*(100+tax_purchase)/100)>
					</cfif>
					<cfelseif attributes.purchase_sales eq 2>
					<cfif tax neq 0>
						<cfset toplam_tutat_iskontolu_kdvli  = (toplam_tutat_iskontolu_kdvli*(100+tax)/100)>
					</cfif>
					</cfif>
					<cfset toplam_tutar_iskontolu = wrk_round(toplam_tutar_iskontolu,4)>
					<cfset toplam_tutat_iskontolu_kdvli = wrk_round(toplam_tutat_iskontolu_kdvli,4)>
					<cfif not isdefined("attributes.is_excel")>
						<tr height="20" id="#product_id#">
						<td><a href="javascript://" onClick="sil(#product_id#)"><img src="images/delete_list.gif" border="0"></a></td>
						<td>#currentrow#</td>
						<td><!-- sil --><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#','list');" class="tableyazi"><!-- sil -->#product_name#<!-- sil --></a><!-- sil --></td>
						<td align="right" style="text-align:right;">
						<input type="hidden" name="form_purchase_sales" value="#attributes.purchase_sales#">
						<input type="hidden" class="box" name="old_price_amount#product_id#" value="#tlformat(get_product_price.price,session.ep.our_company_info.sales_price_round_num)#">	
						<cfinput type="text" class="box" name="price_amount#product_id#" style="width:85;" value="#tlformat(get_product_price.price,session.ep.our_company_info.sales_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));" onblur="hesap_kontrol(#product_id#)"></td>
						<td>#get_product_price.money#<input type="hidden" name="price_money_#product_id#" id="price_money_#product_id#" value='#get_product_price.money#'></td>
						<td><cfinput type="text" class="box" name="discount1#product_id#" style="width:60px;" value="#tlformat(get_purchase_sales_discount.discount1)#" onBlur="hesap_kontrol(#product_id#)" onkeyup="return(FormatCurrency(this,event));"></td>
						<td><cfinput type="text" class="box" name="discount2#product_id#" style="width:60px;" value="#tlformat(get_purchase_sales_discount.discount2)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td><cfinput type="text" class="box" name="discount3#product_id#" style="width:60px;" value="#tlformat(get_purchase_sales_discount.discount3)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td><cfinput type="text" class="box" name="discount4#product_id#" style="width:60px;" value="#tlformat(get_purchase_sales_discount.discount4)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td><cfinput type="text" class="box" name="discount5#product_id#" style="width:60px;" value="#tlformat(get_purchase_sales_discount.discount5)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td align="right" style="text-align:right;"><cfinput type="text" class="box" name="toplam_tutar_iskontolu#product_id#" style="width:90px;" value="#tlformat(toplam_tutar_iskontolu,session.ep.our_company_info.sales_price_round_num)#" readonly="yes"></td>
						<td align="right" style="text-align:right;"><cfinput type="text" class="box" name="toplam_tutat_iskontolu_kdvli#product_id#" style="width:90px;" value="#tlformat(toplam_tutat_iskontolu_kdvli,session.ep.our_company_info.sales_price_round_num)#" readonly="yes"></td>
						<td><select name="paymethod_type#product_id#" id="paymethod_type#product_id#" style="width:100%;" class="box">
							<cfloop query="get_paymethod_type">
								<option value="#paymethod_id#" <cfif get_purchase_sales_discount.paymethod_id eq paymethod_id>selected</cfif>>#paymethod#</option>
							</cfloop>
							</select>
						</td>
						<td><cfinput type="text" class="box" name="discount_cash#product_id#" style="width:100%;" value="#tlformat(get_purchase_sales_discount.DISCOUNT_CASH,session.ep.our_company_info.sales_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
							<td nowrap><cfinput type="text" class="box" name="rebate_cash_1_#product_id#" style="width:100%;" value="#tlformat(get_purchase_sales_discount.REBATE_CASH_1,session.ep.our_company_info.sales_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
							<td nowrap><cfinput type="text" class="box" name="rebate_rate_#product_id#" style="width:100%;" value="#tlformat(get_purchase_sales_discount.REBATE_RATE)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
							<td nowrap>
								<cfinput type="text" class="box" name="extra_product_1_#product_id#" style="width:48%;" value="#tlformat(get_purchase_sales_discount.extra_product_1)#" onkeyup="return(FormatCurrency(this,event));">
									<cfinput type="text" class="box" name="extra_product_2_#product_id#" style="width:48%;" value="#tlformat(get_purchase_sales_discount.extra_product_2)#" onkeyup="return(FormatCurrency(this,event));">								</td>
							<td nowrap>
								<cfinput type="text" class="box" name="return_day_#product_id#" style="width:45%;" value="#tlformat(get_purchase_sales_discount.RETURN_DAY)#" onkeyup="return(FormatCurrency(this,event));">
								- <cfinput type="text" class="box" name="return_rate_#product_id#" style="width:45%;" value="#tlformat(get_purchase_sales_discount.RETURN_RATE)#" onkeyup="return(FormatCurrency(this,event));">								</td>
							<td nowrap><cfinput type="text" class="box" name="price_protection_day_#product_id#" style="width:100%;" value="#tlformat(get_purchase_sales_discount.PRICE_PROTECTION_DAY)#" onkeyup="return(FormatCurrency(this,event));"></td>
						<!-- sil -->
						<td>
							<cfif attributes.purchase_sales eq 1>
								<input type="hidden" name="tax_deger#product_id#" id="tax_deger#product_id#" value="#tax_purchase#">
							<cfelseif attributes.purchase_sales eq 2>
								<input type="hidden" name="tax_deger#product_id#" id="tax_deger#product_id#" value="#tax#">
							</cfif>
							<input name="is_record_active" id="is_record_active" class="is_record_active" type="checkbox" value="#product_id#" checked>
							<input name="is_record_active_order" id="is_record_active_order" type="hidden" value="#product_id#">
						</td>
						<!-- sil -->
						</tr>
					<cfelse>
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" >
						<td></td>
						<td>#currentrow#</td>
						<td>#product_name#</td>
						<td align="right" style="text-align:right;">#tlformat(get_product_price.price,session.ep.our_company_info.sales_price_round_num)#</td>
						<td>#get_product_price.money#</td>
						<td>#tlformat(get_purchase_sales_discount.discount1)#</td>
						<td>#tlformat(get_purchase_sales_discount.discount2)#</td>
						<td><cfinput type="text" class="box" name="discount3#product_id#" style="width:70;" value="#tlformat(get_purchase_sales_discount.discount3)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td><cfinput type="text" class="box" name="discount4#product_id#" style="width:70;" value="#tlformat(get_purchase_sales_discount.discount4)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td><cfinput type="text" class="box" name="discount5#product_id#" style="width:70;" value="#tlformat(get_purchase_sales_discount.discount5)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
						<td align="right" style="text-align:right;"><cfinput type="text" class="box" name="toplam_tutar_iskontolu#product_id#" style="width:90;" value="#tlformat(toplam_tutar_iskontolu,session.ep.our_company_info.sales_price_round_num)#" readonly="yes"></td>
						<td align="right" style="text-align:right;"><cfinput type="text" class="box" name="toplam_tutat_iskontolu_kdvli#product_id#" style="width:90;" value="#tlformat(toplam_tutat_iskontolu_kdvli,session.ep.our_company_info.sales_price_round_num)#" readonly="yes"></td>
						<td>
							<select name="paymethod_type#product_id#" id="paymethod_type#product_id#" style="width:100%;" class="box">
								<cfloop query="get_paymethod_type">
									<option value="#paymethod_id#" <cfif get_purchase_sales_discount.paymethod_id eq paymethod_id>selected</cfif>>#paymethod#</option>
								</cfloop>
							</select>
						</td>
						<td><cfinput type="text" class="box" name="discount_cash#product_id#" style="width:50px;" value="#tlformat(get_purchase_sales_discount.DISCOUNT_CASH,session.ep.our_company_info.sales_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
							<td nowrap><cfinput type="text" class="box" name="rebate_cash_1_#product_id#" style="width:50;" value="#tlformat(get_purchase_sales_discount.REBATE_CASH_1,session.ep.our_company_info.sales_price_round_num)#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
							<td nowrap><cfinput type="text" class="box" name="rebate_rate_#product_id#" style="width:40;" value="#tlformat(get_purchase_sales_discount.REBATE_RATE)#" onBlur="hesap_kontrol(#product_id#);" onkeyup="return(FormatCurrency(this,event));"></td>
							<td nowrap>
								<cfinput type="text" class="box" name="extra_product_1_#product_id#" style="width:40;" value="#tlformat(get_purchase_sales_discount.extra_product_1)#" onkeyup="return(FormatCurrency(this,event));">
								<cfinput type="text" class="box" name="extra_product_2_#product_id#" style="width:40;" value="#tlformat(get_purchase_sales_discount.extra_product_2)#" onkeyup="return(FormatCurrency(this,event));">								</td>
							<td nowrap>
								<cfinput type="text" class="box" name="return_day_#product_id#" style="width:35;" value="#tlformat(get_purchase_sales_discount.RETURN_DAY)#" onkeyup="return(FormatCurrency(this,event));">
								-<cfinput type="text" class="box" name="return_rate_#product_id#" style="width:35;" value="#tlformat(get_purchase_sales_discount.RETURN_RATE)#" onkeyup="return(FormatCurrency(this,event));">								</td>
							<td nowrap><cfinput type="text" class="box" name="price_protection_day_#product_id#" style="width:40;" value="#tlformat(get_purchase_sales_discount.PRICE_PROTECTION_DAY)#" onkeyup="return(FormatCurrency(this,event));"></td>
						<!-- sil -->
						<td>
						<cfif attributes.purchase_sales eq 1>
							<input type="hidden" name="tax_deger#product_id#" id="tax_deger#product_id#" value="#tax_purchase#">
						<cfelseif attributes.purchase_sales eq 2>
							<input type="hidden" name="tax_deger#product_id#" id="tax_deger#product_id#" value="#tax#">
						</cfif>
							<input name="is_record_active" id="is_record_active" class="is_record_active" type="checkbox" value="#product_id#" checked>
							<input name="is_record_active_order" id="is_record_active_order" type="hidden" value="#product_id#">
						</td>
						<!-- sil -->
						</tr>
					</cfif>
				</cfoutput>
			</cfif>	
		</tbody>
				</cfif>	
</cf_grid_list>
<cf_box_elements>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<div class="form-group">
			<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='37442.Kopyalanacak Firma'></label>	
			<div class="col col-12">
				<select name="compid" id="compid">
					<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
					<cfoutput query="get_companies">
						<option value="#our_company_id#">#nick_name#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		<div class="form-group">
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
				<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
					SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
				</cfquery>
			</cfif>
			<label class="col col-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
			<div class="col col-12">	
				<div class="input-group">
					<input type="hidden" name="company_id" id="company_id" value="<cfif Len(attributes.company_id) and Len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
					<input type="text" name="company_name" id="company_name" style="width:120px;" value="<cfif isdefined("GET_COMPANY_NAME.FULLNAME") and Len(GET_COMPANY_NAME.FULLNAME)><cfoutput>#GET_COMPANY_NAME.FULLNAME#</cfoutput></cfif>" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','company_id','','3','250');" autocomplete="off">
					<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=add_p_s_discount.company_name&field_comp_id=add_p_s_discount.company_id','list');"></span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
			<div class="col col-12">
				<div class="input-group">
					<input type="text" name="start_date"  id="start_date"value="" maxlength="10" style="width:65px;">
					<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					<span class="input-group-addon no-bg"></span>
					<input type="text" name="finish_date" id="finish_date" value="" maxlength="10" style="width:65px;">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
				</div>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-12"><cf_get_lang dictionary_id='57651.Anlaşma'></label>
			<div class="col col-12">	
				<div class="input-group">
					<cfif isdefined("attributes.contract_id") and len(attributes.contract_id)>
						<cfquery name="getRelatedContract" datasource="#dsn3#">
							SELECT CONTRACT_HEAD, CONTRACT_ID FROM RELATED_CONTRACT WHERE CONTRACT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.contract_id#">
						</cfquery>
						<cfset contract_id = getRelatedContract.CONTRACT_ID>
						<cfset contract_no = getRelatedContract.CONTRACT_HEAD>
					<cfelse>
						<cfset contract_id = "">
						<cfset contract_no = "">
					</cfif>
					<input type="hidden" name="contract_id" id="contract_id" value="<cfoutput>#contract_id#</cfoutput>"> 
					<input type="text" name="contract_no" id="contract_no" value="<cfoutput>#contract_no#</cfoutput>">
					<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_contract&event=list&field_id=add_p_s_discount.contract_id&field_name=add_p_s_discount.contract_no'</cfoutput>,'large')"></span>
				</div>
			</div>
		</div>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
		<cf_workcube_general_process is_template_view="false">
	</div>
</cf_box_elements>
	
	<cf_box_footer>
		<cf_workcube_buttons is_upd='0' add_function='gonder()' type_format="1">
	</cf_box_footer>
		

</cf_box>
	<input type="hidden" name="totalcount" id="totalcount" value="<cfif isdefined("GET_PRODUCT.recordCount") and len(GET_PRODUCT.recordCount)><cfoutput>#GET_PRODUCT.recordCount#</cfoutput><cfelse>0</cfif>">
	<cfinput type="hidden" name="product_ids">
	<cfinput type="hidden" name="product_names">
	<cfinput type="hidden" name="tax_purchases">
	<cfinput type="hidden" name="taxs">
</cfform>



<script type="text/javascript">

	function add_row_product(){
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&product_id=add_p_s_discount.product_ids&field_name=add_p_s_discount.product_names&field_tax_purchase=add_p_s_discount.tax_purchases&field_tax=add_p_s_discount.taxs&call_function=add_row','list');
	}
	totalcount = parseInt($("#totalcount").val())+1;
	function add_row(){
		product_id = $("input[name=product_ids]").val();
		taxs = $("input[name=taxs]").val();
		taxs_purchases = $("input[name=tax_purchases]").val();
		purchase_sales = $("select[name=purchase_sales]").val();

		var listParam = product_id + "*" + purchase_sales;
		var get_product_row = wrk_safe_query('get_product_price_row','dsn3',0,listParam+"*_");
		var money = get_product_row.MONEY;
		var price = get_product_row.PRICE;
		
			content = "";
			content +='<tr height="20" class="color-row" id="'+product_id+'">';
			content +='<td><a href="javascript://" onClick="sil('+product_id+')"><img  src="images/delete_list.gif" border="0"></a></td>';
			content +='<td>'+totalcount+'</td>';
			content +='<td><a href="javascript://" onClick="windowopen("<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_detail_product&pid='+$("input[name=product_ids]").val()+',"list");" class="tableyazi">'+$("input[name='product_names']").val()+'</a></td>';
			content +='<td align="right" style="text-align:right;"><input type="hidden" name="form_purchase_sales" value="'+purchase_sales+'"><input type="hidden" class="box" name="old_price_amount'+product_id+'" value="'+commaSplit(price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'"><input type="text" class="box" name="price_amount'+product_id+'" style="width:85;" value="'+commaSplit(price,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>)+'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));" onblur="hesap_kontrol('+product_id+')"></td>';
			content	+='<td>'+money+'<input type="hidden" name="price_money_'+product_id+'" id="price_money_'+product_id+'" value="'+money+'"></td>';
			content +='<td><input type="text" class="box" name="discount1'+product_id+'" style="width:60px;" value="" onBlur="hesap_kontrol('+product_id+')" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td><input type="text" class="box" name="discount2'+product_id+'" style="width:60px;" value="" onBlur="hesap_kontrol('+product_id+');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td><input type="text" class="box" name="discount3'+product_id+'" style="width:60px;" value="" onBlur="hesap_kontrol('+product_id+');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td><input type="text" class="box" name="discount4'+product_id+'" style="width:60px;" value="" onBlur="hesap_kontrol('+product_id+');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td><input type="text" class="box" name="discount5'+product_id+'" style="width:60px;" value="" onBlur="hesap_kontrol('+product_id+');" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td align="right" style="text-align:right;"><input type="text" class="box" name="toplam_tutar_iskontolu'+product_id+'" style="width:90px;" value="" readonly="yes"></td>';
			content +='<td align="right" style="text-align:right;"><input type="text" class="box" name="toplam_tutat_iskontolu_kdvli'+product_id+'" style="width:90px;" value="" readonly="yes"></td>';
			content +='<td><select name="paymethod_type'+product_id+'" id="paymethod_type'+product_id+'" style="width:100%;" class="box"><cfloop query="get_paymethod_type"><option value="<cfoutput>#paymethod_id#</cfoutput>"><cfoutput>#paymethod#</cfoutput></option></cfloop></select></td>';
			content +='<td><input type="text" class="box" name="discount_cash'+product_id+'" style="width:100%;" value="" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td nowrap><input type="text" class="box" name="rebate_cash_1_'+product_id+'" style="width:100%;" value="" onkeyup="return(FormatCurrency(this,event,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>));"></td>';
			content +='<td nowrap><input type="text" class="box" name="rebate_rate_'+product_id+'" style="width:100%;" value="" onBlur="hesap_kontrol('+product_id+');" onkeyup="return(FormatCurrency(this,event));"></td>';
			content +='<td nowrap><input type="text" class="box" name="extra_product_1_'+product_id+'" style="width:48%;" value="" onkeyup="return(FormatCurrency(this,event));"> <input type="text" class="box" name="extra_product_2_'+product_id+'" style="width:48%;" value="" onkeyup="return(FormatCurrency(this,event));"></td>';
			content +='<td nowrap><input type="text" class="box" name="return_day_'+product_id+'" style="width:45%;" value="" onkeyup="return(FormatCurrency(this,event));"> - <input type="text" class="box" name="return_rate_'+product_id+'" style="width:45%;" onkeyup="return(FormatCurrency(this,event));"></td>';
			content +='<td nowrap><input type="text" class="box" name="price_protection_day_'+product_id+'" style="width:100%;" onkeyup="return(FormatCurrency(this,event));"></td>';
			content +='<td><cfif attributes.purchase_sales eq 1><input type="hidden" name="tax_deger'+product_id+'" id="tax_deger'+product_id+'" value="'+taxs_purchases+'"><cfelseif attributes.purchase_sales eq 2><input type="hidden" name="tax_deger'+product_id+'" id="tax_deger'+product_id+'" value="'+taxs+'"></cfif><input name="is_record_active" id="is_record_active" class="is_record_active" type="checkbox" value="'+product_id+'" checked><input name="is_record_active_order" id="is_record_active_order" type="hidden" value="'+product_id+'"></td>';
			content +='</tr>';
			$("table.ui-table-list tbody").append(content);
			totalcount++;
			hesap_kontrol(product_id);		
	}

	function sil(id){
		$("tr[id="+id+"]").remove();
	}
	
	function hesap_kontrol(j)
	{ 
		alan1 = eval('add_p_s_discount.discount1'+j);
		alan2 = eval('add_p_s_discount.discount2'+j);
		alan3 = eval('add_p_s_discount.discount3'+j);
		alan4 = eval('add_p_s_discount.discount4'+j);
		alan5 = eval('add_p_s_discount.discount5'+j);
		
		price_amount = eval('add_p_s_discount.price_amount'+j);
		iskontolu = eval('add_p_s_discount.toplam_tutar_iskontolu'+j);
		kdvli = eval('add_p_s_discount.tax_deger'+j);
		kdvli2 = eval('add_p_s_discount.toplam_tutat_iskontolu_kdvli'+j);

		alan1_value = filterNum(alan1.value);
		alan2_value = filterNum(alan2.value);
		alan3_value = filterNum(alan3.value);
		alan4_value = filterNum(alan4.value);
		alan5_value = filterNum(alan5.value);

		if (alan1_value > 100) {alert("<cf_get_lang dictionary_id='37947.İskonto 1 1 ile 100 Arasında Olmalıdır'> !");alan1.value=0; return false;}
		if (alan2_value > 100) {alert("<cf_get_lang dictionary_id='37948.İskonto 2 1 ile 100 Arasında Olmalıdır'> !");alan2.value=0; return false;}
		if (alan3_value > 100) {alert("<cf_get_lang dictionary_id='37950.İskonto 3 1 ile 100 Arasında Olmalıdır'> !");alan3.value=0; return false;}
		if (alan4_value > 100) {alert("<cf_get_lang dictionary_id='37951.İskonto 4 1 ile 100 Arasında Olmalıdır'> !");alan4.value=0; return false;}
		if (alan5_value > 100) {alert("<cf_get_lang dictionary_id='37952.İskonto 5 1 ile 100 Arasında Olmalıdır'> !");alan5.value=0; return false;}
		deger_toplanmasi_gereken = filterNum(price_amount.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		if (alan1_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan1_value))/100);
		if (alan2_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan2_value))/100);
		if (alan3_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan3_value))/100);
		if (alan4_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan4_value))/100);
		if (alan5_value) deger_toplanmasi_gereken = parseFloat(deger_toplanmasi_gereken) * ((100-parseFloat(alan5_value))/100);	
		iskontolu.value = commaSplit(deger_toplanmasi_gereken,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		kdvli2.value = commaSplit(parseFloat(deger_toplanmasi_gereken) * ((100+parseFloat(kdvli.value))/100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
		
		if (filterNum(eval('add_p_s_discount.rebate_rate_'+j).value) > 100 || filterNum(eval('add_p_s_discount.rebate_rate_'+j).value) < 0) {alert("<cf_get_lang dictionary_id='58884.Back End Rabete Oranı 1 ile 100 Arasında Olmalıdır'> !");eval('add_p_s_discount.rebate_rate_'+j).value=0; return false;}

	}
	
	function check_all(deger)
	{
		<cfif isdefined("get_product.recordcount") and get_product.recordcount gt 1>
		for(i=0; i<add_p_s_discount.is_record_active.length; i++)
			add_p_s_discount.is_record_active[i].checked = deger;
		<cfelseif isdefined("get_product.recordcount") and get_product.recordcount eq 1>
			add_p_s_discount.is_record_active.checked = deger;
		</cfif>
	}
	function all_paymethod(paymethod)
	{
		<cfif isdefined("get_product.recordcount") and get_product.recordcount>
			<cfoutput query="get_product">
				document.getElementById('paymethod_type#product_id#').value =paymethod;
			</cfoutput>
		</cfif>
	}
	function all_discount(disc_no)
	{	
		if (eval('document.add_p_s_discount.disc' + disc_no + '_all').value == "")
			eval('document.add_p_s_discount.disc' + disc_no + '_all').value = 0;
			discount_yeni= eval('document.add_p_s_discount.disc' + disc_no + '_all').value;
		if ((filterNum(discount_yeni) < 0) || (filterNum(discount_yeni)> 100))
			{
				alert("<cf_get_lang dictionary_id='37945.İskonto 1 ile 100 Arasında Olmalıdır'>!");
				return false;
			}
		<cfif isdefined("get_product.recordcount") and get_product.recordcount>
		else
			<cfoutput query="get_product">
				{ 
				eval('document.add_p_s_discount.discount' + disc_no + #product_id#).value = eval('document.add_p_s_discount.disc' + disc_no + '_all').value;
				hesap_kontrol('#PRODUCT_ID#');
				}
				</cfoutput>
		</cfif>
	}
	
	function gonder()
	{ 
		if(!CheckEurodate(add_p_s_discount.start_date.value,'Başlama Tarihi') || !add_p_s_discount.start_date.value.length) 
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik veri'> : <cf_get_lang dictionary_id='57655.Başlama Tarihi'>");
			return false;
		}
		var toplam_checked=0;
		$('.is_record_active').each(function(){
			if(this.checked){
				toplam_checked += 1;
			}
		});
		if(toplam_checked==0)
		{
			alert("<cf_get_lang dictionary_id='37946.Lütfen En Az Bir Ürün Seçiniz'> !");
			return false;
		}

		k = 1;
		$('.is_record_active').each(function(){
			k++;
			m = k - 1;
			if (this.checked){
				n = this.value;
				alan1 = eval('add_p_s_discount.discount1'+n);
				alan2 = eval('add_p_s_discount.discount2'+n);
				alan3 = eval('add_p_s_discount.discount3'+n);
				alan4 = eval('add_p_s_discount.discount4'+n);
				alan5 = eval('add_p_s_discount.discount5'+n);
				
				alan1.value = filterNum(alan1.value);
				alan2.value = filterNum(alan2.value);
				alan3.value = filterNum(alan3.value);
				alan4.value = filterNum(alan4.value);
				alan5.value = filterNum(alan5.value);
				eval('add_p_s_discount.discount_cash'+n).value = filterNum(eval('add_p_s_discount.discount_cash'+n).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				eval('add_p_s_discount.extra_product_1_'+n).value = filterNum(eval('add_p_s_discount.extra_product_1_'+n).value);
				eval('add_p_s_discount.extra_product_2_'+n).value = filterNum(eval('add_p_s_discount.extra_product_2_'+n).value);
				eval('add_p_s_discount.price_protection_day_'+n).value = filterNum(eval('add_p_s_discount.price_protection_day_'+n).value);
				eval('add_p_s_discount.rebate_cash_1_'+n).value = filterNum(eval('add_p_s_discount.rebate_cash_1_'+n).value);
				eval('add_p_s_discount.return_day_'+n).value = filterNum(eval('add_p_s_discount.return_day_'+n).value);
				eval('add_p_s_discount.return_rate_'+n).value = filterNum(eval('add_p_s_discount.return_rate_'+n).value);
				eval('add_p_s_discount.rebate_rate_'+n).value = filterNum(eval('add_p_s_discount.rebate_rate_'+n).value);

			}
		});

		var price_list='';
		for(kk=0;kk<document.search_product.price_cat_list.length; kk++)
		{
			if(search_product.price_cat_list[kk].selected && search_product.price_cat_list.options[kk].value.length!='')
			price_list = price_list + ',' + search_product.price_cat_list.options[kk].value;
		}
		if(price_list != '' && document.add_p_s_discount.company_id.value != '' && document.add_p_s_discount.company_name.value != '')
		{
			alert("<cf_get_lang dictionary_id='37743.Aynı Anda Hem Cari Hemde Fiyat Listesi Seçili Olamaz'> !");
			return false;
		}
		document.add_p_s_discount.price_cats_lists.value = price_list;
		<cfif isdefined("get_product.recordcount") and not get_paymethod_type.recordcount>
			alert("<cf_get_lang dictionary_id='54516.Ödeme Yöntemi Tanımlamalısınız'> !");
			return false;
		</cfif>
		return process_cat_control();
	}
</script> 

