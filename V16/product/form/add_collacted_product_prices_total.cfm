<script type="text/javascript">
function input_control()
{
	var is_ok=0;
	var select_count=0;
	if(search_product.referans_price_list.value =='')
	{
		alert("<cf_get_lang dictionary_id ='37824.Referans Fiyat Listesi Seçiniz'>");
		return false;
	}
	if(search_product.price_cat_list.value =='')
	{
		alert("<cf_get_lang dictionary_id ='37825.Düzenlenecek Fiyat Listesi Seçiniz'>");
		return false;
	}
	if(document.search_product.price_cat_list.length)
	{
		for(var i=0;i<document.search_product.price_cat_list.length;i++)
		{
			if (document.search_product.price_cat_list.options[ i ].selected)
				select_count++;
			if(select_count == 6) break;
		}
		if(select_count>5)
		{
			alert("<cf_get_lang dictionary_id ='37827.Düzenlenecek Fiyat Listesi 5 den fazla olamaz'>!");
			return false;
		}
	}	
	if(search_product.product_cat.value.length != 0)
		is_ok++;
	if(search_product.company_id.value.length != 0 && search_product.company_name.value.length != '')	
		is_ok++;
	if(search_product.brand_name.value.length != 0 && search_product.brand_id.value.length != 0)	
		is_ok++;
	if(search_product.employee.value.length != 0 && search_product.pos_code.value.length != 0)
		is_ok++;
	if(search_product.product_name.value.length != 0)
		is_ok++;
	if (is_ok >= 2)
	{
		return true;
	}else
	{
		alert("<cf_get_lang dictionary_id ='37828.Arama kriteri olarak en az iki seçenek seçilmelidir'>!");
		return false;			
	}
}
</script>
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_price_cat.cfm">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.price_cat_list" default="">
<cfparam name="attributes.referans_price_list" default="">
<cfparam name="attributes.rec_date" default="">
<cfparam name="attributes.price_rec_date" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfif len(attributes.rec_date)>
	<cf_date tarih='attributes.rec_date'>
</cfif>
<cfif len(attributes.price_rec_date)>
	<cf_date tarih='attributes.price_rec_date'>
</cfif>
<cfset adres = url.fuseaction>
<cfif isDefined('attributes.form_submit') and len(attributes.form_submit)>
	<cfset adres = '#adres#&form_submit=#attributes.form_submit#'>
</cfif>
<cfif isDefined('attributes.price_cat_list') and len(attributes.price_cat_list)>
	<cfset adres = '#adres#&price_cat_list=#attributes.price_cat_list#'>
</cfif>
<cfif isDefined('attributes.referans_price_list') and len(attributes.referans_price_list)>
	<cfset adres = '#adres#&referans_price_list=#attributes.referans_price_list#'>
</cfif>
<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
	<cfset adres = '#adres#&company_id=#attributes.company_id#'>
</cfif>
<cfif isDefined('attributes.company_name') and len(attributes.company_name)>
	<cfset adres = '#adres#&company_name=#attributes.company_name#'>
</cfif>
<cfif isDefined('attributes.price_rec_date') and len(attributes.price_rec_date)>
	<cfset adres = "#adres#&price_rec_date=#dateformat(attributes.price_rec_date,dateformat_style)#">
</cfif>
<cfif isDefined('attributes.product_name') and len(attributes.product_name)>
	<cfset adres = "#adres#&product_name=#attributes.product_name#">
</cfif>
<cfif isDefined('attributes.product_catid') and len(attributes.product_catid)>
	<cfset adres = "#adres#&product_catid=#attributes.product_catid#">
</cfif>
<cfif isDefined('attributes.product_id') and len(attributes.product_id)>
	<cfset adres = "#adres#&product_id=#attributes.product_id#">
</cfif>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfset adres = "#adres#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isDefined('attributes.product_cat') and len(attributes.product_cat)>
	<cfset adres = "#adres#&product_cat=#attributes.product_cat#">
</cfif>
<cfif isDefined('attributes.rec_date') and len(attributes.rec_date)>
	<cfset adres = "#adres#&rec_date=#attributes.rec_date#">
</cfif>
<cfif isDefined('attributes.pos_code') and len(attributes.pos_code)>
	<cfset adres = "#adres#&pos_code=#attributes.pos_code#">
</cfif>
<cfif isDefined('attributes.employee') and len(attributes.employee)>
	<cfset adres = "#adres#&employee=#attributes.employee#">
</cfif>
<cfif isDefined('attributes.brand_id') and len(attributes.brand_id)>
	<cfset adres = "#adres#&brand_id=#attributes.brand_id#">
</cfif>
<cfif isDefined('attributes.brand_name') and len(attributes.brand_name)>
	<cfset adres = "#adres#&brand_name=#attributes.brand_name#">
</cfif>
<cfset pageHead = "#getLang('main',620)# #getLang('product',379)#">
<cf_catalystHeader>
    <cf_box title="#getLang('','settings',58084)#">
<cf_basket_form id="prices_total_">
    <cfform name="search_product" method="post" action="#request.self#?fuseaction=product.collacted_product_prices&event=add-total">
    <cf_box_elements>
        <input type="hidden" name="form_varmi" id="form_varmi" value="1">
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-price_cat_list">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37547.Düzenleme'> <cf_get_lang dictionary_id='58084.Fiyat'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <input type="hidden" name="form_submit" id="form_submit" value="1">
                                    <select name="price_cat_list" id="price_cat_list" style="width:152px;height:75px;" multiple>
                                        <cfoutput query="get_price_cat"> 
                                            <option value="#price_catid#" <cfif ListFind(attributes.price_cat_list,price_catid,',')>selected</cfif>>#price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-referans_price_list">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58784.Referans'> <cf_get_lang dictionary_id='58084.Fiyat'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <select name="referans_price_list" id="referans_price_list" style="width:150px;">
                                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                        <option value="-3"<cfif attributes.referans_price_list eq -3 or not len(attributes.referans_price_list)> selected</cfif>><cf_get_lang dictionary_id='37829.Standart Alış İskontolu'> </option>
                                        <option value="-1"<cfif attributes.referans_price_list eq -1> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                        <option value="-2"<cfif attributes.referans_price_list eq -2> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                        <option value="M" <cfif attributes.referans_price_list is 'm'>selected</cfif>><cf_get_lang dictionary_id='58258.Maliyet'></option>
                                        <cfoutput query="get_price_cat">
                                            <option value="#price_catid#" <cfif (price_catid is attributes.referans_price_list)>selected</cfif>>#price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_name">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.stock_id) and len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
                                        <input name="product_name" type="text" id="product_name"  style="width:150px;" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID','stock_id','','3','130');" value="<cfif len(attributes.stock_id) and len(attributes.product_name)><cfoutput>#attributes.product_name#</cfoutput></cfif>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer"  onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=search_product.stock_id&field_name=search_product.product_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&keyword='+encodeURIComponent(document.search_product.product_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-employee">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cf_wrk_employee_positions form_name='search_product' pos_code='pos_code' emp_name='employee'>
                                        <input type="hidden" name="pos_code" id="pos_code"  value="<cfoutput>#attributes.pos_code#</cfoutput>">
                                        <input type="text" name="employee" id="employee" style="width:150px;" value="<cfoutput>#attributes.employee#</cfoutput>" maxlength="255"  onKeyUp="get_emp_pos_1();">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=search_product.pos_code&field_code=search_product.pos_code&field_name=search_product.employee&select_list=1,9&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.employee.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-company_name">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
                                        <input name="company_name" type="text" id="company_name" style="width:140px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE','get_member_autocomplete','','COMPANY_ID','company_id','search_product','3');" value="<cfoutput>#attributes.company_name#</cfoutput>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.company_name&field_comp_id=search_product.company_id&select_list=2&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.company_name.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_cat">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                                        <input type="text" name="product_cat" id="product_cat" style="width:140px;" value="<cfoutput>#attributes.product_cat#</cfoutput>">
                                        <a href="javascript://" align="absmiddle"></a>
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_id=search_product.product_catid&field_name=search_product.product_cat&keyword='+encodeURIComponent(document.search_product.product_cat.value)</cfoutput>);" title="<cf_get_lang dictionary_id ='58730.Ürün Kategorisi Seç'>"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-brand_name">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cf_wrk_brands form_name='search_product' brand_id='brand_id' brand_name='brand_name'>
                                        <input type="hidden" name="brand_id" id="brand_id" value="<cfif isdefined("attributes.brand_id")><cfoutput>#attributes.brand_id#</cfoutput></cfif>">
                                        <input type="text" name="brand_name" id="brand_name" value="<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)><cfoutput>#attributes.brand_name#</cfoutput></cfif>" onKeyUp="get_brand();" style="width:140px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_brands&brand_id=search_product.brand_id&brand_name=search_product.brand_name&keyword='+encodeURIComponent(document.search_product.brand_name.value)</cfoutput>,'small');"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-price_rec_date">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id ='37555.Fiyat Kayıt Tarihi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='37630.Fiyat kayıt tarihinde hata'> !</cfsavecontent>
                                        <cfinput type="text" name="price_rec_date" value="#DateFormat(attributes.price_rec_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="price_rec_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-rec_date">
                                <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37549.Ürün Kayıt Tarihi'></label>
                                <div class="col col-9 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37441.Ürün kayıt tarihinde hata'> !</cfsavecontent>
                                        <cfinput type="text" name="rec_date" value="#DateFormat(attributes.rec_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="rec_date"></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    <div class="row formContentFooter">	
                        <div class="col col-12 text-right">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,100" required="yes" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_search_button button_type='1' search_function='input_control()' is_excel='0'>
                        </div> 
                    </div>
                </cf_box_elements>
    </cfform>
</cf_basket_form>
<cfif isdefined('attributes.form_submit')>
	<cfif len(attributes.product_cat) and len(attributes.product_catid)>
		<cfquery name="GET_PRODUCT_CATS" datasource="#dsn3#">
			SELECT
				PRODUCT_CATID, 
				HIERARCHY
			FROM 
				PRODUCT_CAT 
			WHERE 
				PRODUCT_CATID = #attributes.product_catid#
			ORDER BY 
				HIERARCHY
		</cfquery>		  
	</cfif>  
	<cfquery name="GET_PRODUCT" datasource="#DSN3#">
		SELECT 
			PRODUCT.PRODUCT_NAME, 
			PRODUCT.RECORD_DATE, 
			PRODUCT.PRODUCT_CODE,
			PRODUCT.PRODUCT_ID,
			PRODUCT.BRAND_ID,
			PRODUCT.TAX,
			PRODUCT.TAX_PURCHASE,
			PRODUCT.MAX_MARGIN,
			PRODUCT.MIN_MARGIN,
			PRODUCT.PROD_COMPETITIVE,
			PRODUCT_UNIT.PRODUCT_UNIT_ID,
			PRODUCT_UNIT.MAIN_UNIT
		FROM 
			PRODUCT,
			PRODUCT_UNIT
		WHERE 
			PRODUCT.PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID AND
			PRODUCT.PRODUCT_STATUS = 1 AND
			PRODUCT_UNIT.IS_MAIN = 1 AND
			PRODUCT_UNIT.PRODUCT_UNIT_STATUS = 1
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
			AND PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
			AND PRODUCT_MANAGER=#attributes.pos_code#
			</cfif>
			<cfif len(attributes.company_name) and len(attributes.company_id)>
			AND COMPANY_ID = #attributes.company_id#
			</cfif>
			<cfif len(attributes.brand_id) and len(attributes.brand_name)>
			AND BRAND_ID = #attributes.brand_id#
			</cfif>
			<cfif len(attributes.rec_date)>
			AND PRODUCT.RECORD_DATE >= #attributes.rec_date#
			</cfif>
			<cfif len(attributes.product_name)>
			AND PRODUCT.PRODUCT_NAME LIKE '%#attributes.product_name#%'
			</cfif>
	</cfquery>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.totalrecords" default='#get_product.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfif get_product.recordcount>
		<!--- Ürüne ait indirimler çekiliyor. --->
		<cfquery name="GET_PRODUCT_P_DISCOUNT_ALL" datasource="#DSN3#">
			SELECT
				CPPD.DISCOUNT1,
				CPPD.DISCOUNT2,
				CPPD.DISCOUNT3,
				CPPD.DISCOUNT4,
				CPPD.DISCOUNT5,
				CPPD.PRODUCT_ID,
				CPPD.RECORD_DATE
			FROM
				CONTRACT_PURCHASE_PROD_DISCOUNT CPPD,
				PRODUCT PR
			WHERE
				CPPD.PRODUCT_ID = PR.PRODUCT_ID AND
				PR.PRODUCT_STATUS = 1
				<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
				</cfif>
				<cfif len(attributes.employee) and len(attributes.pos_code)>
				AND PR.PRODUCT_MANAGER=#attributes.pos_code#
				</cfif>
				<cfif len(attributes.company_name) and len(attributes.company_id)>
				AND PR.COMPANY_ID = #attributes.company_id#
				</cfif>
			ORDER BY 
				CPPD.START_DATE DESC
		</cfquery>
		<!--- Ürünlerin standart alış ve satış fiyatları çekiliyor. --->
		<cfquery name="GET_PRICE_STANDART_ALL" datasource="#DSN3#">
		SELECT
			PS.MONEY,
			PS.PRICE,
			PS.PRICE_KDV,
			PS.IS_KDV,
			PS.PRODUCT_ID,
			PS.PURCHASESALES,
			PS.PRICESTANDART_STATUS,
			PS.UNIT_ID,
			PS.START_DATE,
			PS.RECORD_DATE
		FROM
			PRICE_STANDART PS,
			PRODUCT PR,
			PRODUCT_UNIT PU
		WHERE
			PS.PRODUCT_ID = PR.PRODUCT_ID AND
			PR.PRODUCT_ID = PU.PRODUCT_ID AND
			PR.PRODUCT_STATUS = 1 AND
			PU.IS_MAIN = 1
			<cfif len(attributes.price_rec_date)>
			AND PS.START_DATE <= #attributes.price_rec_date#
			<cfelse>
			AND PS.PRICESTANDART_STATUS = 1
			</cfif>
			<cfif len(attributes.product_cat) and len(attributes.product_catid)>
			AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
			</cfif>
			<cfif len(attributes.employee) and len(attributes.pos_code)>
			AND PR.PRODUCT_MANAGER=#attributes.pos_code#
			</cfif>
			<cfif len(attributes.company_name) and len(attributes.company_id)>
			AND PR.COMPANY_ID = #attributes.company_id#
			</cfif>				
		</cfquery>
		<!--- Seçilen Liste Fiyatları Geliyor--->
		<cfquery name="GET_PRICE_LIST_SALES_ALL" datasource="#DSN3#">
			SELECT
				P.MONEY,
				P.PRICE,
				P.PRICE_KDV,
				P.IS_KDV,
				P.PRODUCT_ID,
				P.PRICE_CATID,
				P.UNIT,
				P.CATALOG_ID
			FROM
				PRICE P,
				PRODUCT PR,
				PRODUCT_UNIT PU
			WHERE
				P.PRODUCT_ID = PR.PRODUCT_ID AND
				PR.PRODUCT_ID = PU.PRODUCT_ID AND
				<!---ISNULL(P.STOCK_ID,0)=0 AND--->
				ISNULL(P.SPECT_VAR_ID,0)=0 AND
				P.STARTDATE <= #now()# AND
				(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
				PR.PRODUCT_STATUS = 1 AND
				PU.IS_MAIN = 1
				<cfif len(attributes.product_cat) and len(attributes.product_catid)>
				AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
				</cfif>
				<cfif len(attributes.employee) and len(attributes.pos_code)>
				AND PR.PRODUCT_MANAGER=#attributes.pos_code#
				</cfif>
				<cfif len(attributes.company_name) and len(attributes.company_id)>
				AND PR.COMPANY_ID = #attributes.company_id#
				</cfif>
				<!--- AND P.PRICE_CATID = #attributes.price_cat_list# --->
				AND P.PRICE_CATID IN (#attributes.price_cat_list#)
		</cfquery>
		<!--- Referanssssssssssss --->
		<cfif len(attributes.referans_price_list)><!--- Referans Fiyat Listesi Seçilmiş ise öncelikle burda bu fiyat listesine ait tüm fiyatları seçiyoruz. --->
			<cfif attributes.referans_price_list is 'm'><!--- Maliyet seçilmiş ise maliyetten fiyatları getirsin. --->
				<cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#dsn1#">
				SELECT
					PRODUCT_ID,
					-1 PRICE_CATID,
					PRODUCT_COST AS PRICE,
					MONEY
				FROM
					PRODUCT_COST	
				WHERE
					PRODUCT_COST_STATUS = 1
				ORDER BY 
					START_DATE DESC,RECORD_DATE DESC
				</cfquery>
			<cfelse><!--- Maliyet değil ise seçilen fiyat listeine göre fiyatlar geliyor. --->
				<cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN3#">
					SELECT
						P.MONEY,
						P.PRICE,
						P.PRICE_KDV,
						P.IS_KDV,
						P.PRODUCT_ID,
						P.PRICE_CATID,
						P.UNIT,
						P.CATALOG_ID
					FROM
						PRICE P,
						PRODUCT PR,
						PRODUCT_UNIT PU
					WHERE
						P.PRODUCT_ID = PR.PRODUCT_ID AND
						PR.PRODUCT_ID = PU.PRODUCT_ID AND
						<!---ISNULL(P.STOCK_ID,0)=0 AND--->
						ISNULL(P.SPECT_VAR_ID,0)=0 AND
						P.STARTDATE <= #now()# AND
						(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
						PR.PRODUCT_STATUS = 1 AND
						PU.IS_MAIN = 1
						<cfif len(attributes.product_cat) and len(attributes.product_catid)>
						AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
						</cfif>
						<cfif len(attributes.employee) and len(attributes.pos_code)>
						AND PR.PRODUCT_MANAGER=#attributes.pos_code#
						</cfif>
						<cfif len(attributes.company_name) and len(attributes.company_id)>
						AND PR.COMPANY_ID = #attributes.company_id#
						</cfif>
						AND P.PRICE_CATID = #attributes.referans_price_list#
				</cfquery>
			</cfif>	
		</cfif>
	</cfif>
	<cfform name="form_add_price" method="post" action="#request.self#?fuseaction=product.emptypopupflush_add_collacted_product_prices_amount_total">
		<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.ep.company_id#</cfoutput>">
		<input type="hidden" name="price_cat_list" id="price_cat_list" value="<cfoutput>#attributes.price_cat_list#</cfoutput>">
        <cf_basket id="prices_total_bask_">
          <cf_grid_list>
            	<thead>
                    <tr>
                        <th width="20" nowrap><cf_get_lang dictionary_id='57487.No'></th>
                        <th width="150" nowrap ><cf_get_lang dictionary_id ='57518.Stok Kodu'></th>
                        <th width="300" nowrap><cf_get_lang dictionary_id='57657.Ürün'></th>
                        <th width="40" nowrap><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th width="50" nowrap><cf_get_lang dictionary_id='37374.Min'></th>
                        <th width="50" nowrap ><cf_get_lang dictionary_id='37375.Max'></th>
                    </tr>
                </thead>
                <tbody>
					<cfoutput query="GET_PRODUCT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr title="#product_name#" id="tr_left_#currentrow#">
                                <td width="20" nowrap>#currentrow#</td>
                                <td width="150" nowrap>#PRODUCT_CODE#</td>
                                <td width="300" nowrap title="#product_name#"><div name="a"  style="position:inherit;width:300"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#','list');" class="tableyazi">#left(product_name,27)#</a></div></td>
                                <td width="40" nowrap><!-- sil --><input type="hidden" name="unit_id_#product_id#" id="unit_id_#product_id#" value="#product_unit_id#"><!-- sil --> #MAIN_UNIT#</td>
                                <td width="50" nowrap style="text-align:right;">#min_margin#</td>
                                <td width="50" nowrap style="text-align:right;">#max_margin#</td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_grid_list>
           <div class="row text-right"> 
                <div class="col col-12 form-inline">
                    <div class="form-group">
                    <div class="input-group">
                    <input type="text" placeholder="<cf_get_lang dictionary_id='57655.Başlama Tarihi'>" name="start_date" id="start_date" value="" maxlength="10" style="width:65px;"><!--- required="yes"  validate="#validate_style#" message="#message#" --->
                        <span class="input-group-addon">
                        <cf_wrk_date_image date_field="start_date">
                        </span>
                    </div>
                    </div>
                    <cfoutput>
                        <div class="form-group">
                       <cfif isdefined("attributes.start_clock") and len(attributes.start_clock)>
                                <cf_wrkTimeFormat name="start_clock" value="#attributes.start_clock#">
                            <cfelse>
                                <cf_wrkTimeFormat name="start_clock" value=""> 
                            </cfif>
                        </div>  <div class="form-group">
                        <select name="start_min" id="start_min">
                            <cfloop from="0" to="60" index="i" step="5">
                            <option value="#i#">#i#</option>
                            </cfloop>
                        </select>
                    </div>
                    </cfoutput>
                    <!--- <cf_get_lang dictionary_id="58859.Süreç"> ---> <!--- süreç var ancak burda sureci kaydetmiyoruz hiç bir yere sadece surec dosyaları ile diger şirketlere v.s. fiyat kopyalama gibi işlemler için kullanılacak --->
                        <div class="form-group">
                        <cf_workcube_process 
                            is_upd='0'
                            process_cat_width='140' 
                            is_detail='0'>
                        </div> <div class="form-group">
                        <cf_workcube_buttons is_upd='0' insert_info="#getLang('main',1306)#" add_function='gonder()'>
                        </div>
                    </div> 
                </div>
  		  <cf_grid_list>
          	<thead>
                <tr>
                    <th width="100" rowspan="2" nowrap style="text-align:right;"><cf_get_lang dictionary_id='58722.Standart Alış'></th>
                    <th width="100" rowspan="2" nowrap style="text-align:right;"><cf_get_lang dictionary_id='37391.İskontolu Alış KDVli'></th>
                    <th width="45" rowspan="2"  nowrap style="text-align:right;"><cf_get_lang dictionary_id='57489.Para Br'></th>
                    <th width="30" nowrap rowspan="2"><cf_get_lang dictionary_id='57639.KDV'></th>						
                    <th width="100" rowspan="2" nowrap style="text-align:right;"><cf_get_lang dictionary_id='58721.Standart Satış'> <cf_get_lang dictionary_id='58716.KDV li'></th>
                    <cfif len(attributes.referans_price_list)>
                    <th width="100" rowspan="2" nowrap style="text-align:right;"><cfif attributes.referans_price_list is 'm'><cf_get_lang dictionary_id='58258.Maliyet'><cfelse><cf_get_lang dictionary_id='58784.Referans'> <cf_get_lang dictionary_id='58084.Fiyat'></cfif></th>
                    </cfif>
                    <cfif listlen(attributes.price_cat_list)>
                        <cfoutput>
                        <cfloop query="get_price_cat"> 
                            <cfif ListFind(attributes.price_cat_list,PRICE_CATID,',')>
                                    <th class="txtbold" nowrap width="270" colspan="4" align="center"><font color="FF6666">#PRICE_CAT#</font> <cf_get_lang dictionary_id="30027.Ort Vade">:#AVG_DUE_DAY#</th>
                            </cfif>
                        </cfloop>
                        </cfoutput>
                    </cfif>
                </tr>
                <cfif listlen(attributes.price_cat_list)>
                    <tr>
                        <cfloop query="get_price_cat"> 
                            <cfif ListFind(attributes.price_cat_list,PRICE_CATID,',')>
                                <cfoutput>
                                <cfif len(MARGIN)>
                                    <cfset 'PRICE_CAT_MARGIN_#PRICE_CATID#' = MARGIN >
                                <cfelse>
                                    <cfset 'PRICE_CAT_MARGIN_#PRICE_CATID#' = 0 >
                                </cfif>
                            <th width="50" nowrap style="text-align:right;"><cf_get_lang dictionary_id="37045.Mrj"></th>
                            <th width="100" nowrap style="text-align:right;"><cf_get_lang dictionary_id='37440.KDV H.'></th>
                            <th width="100" nowrap style="text-align:right;"><cf_get_lang dictionary_id='37439.KDV D.'></th>
                            <th width="20" nowrap style="text-align:right;"><input type="checkbox" name="price_cat_#PRICE_CATID#" id="price_cat_#PRICE_CATID#" value="#PRICE_CATID#" onclick="select_price_cat(this);"></th>
                                </cfoutput>
                            </cfif>
                        </cfloop>
                    </tr>
                </cfif>
              </thead>
                <cfif get_product.recordcount>
                <cfoutput query="GET_PRODUCT" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <!--- Her Ürün İçin İndirimler Çekiliyor. --->
                    <cfquery name="GET_PRODUCT_P_DISCOUNT" dbtype="query" maxrows="1">
                    SELECT
                        *
                    FROM
                        GET_PRODUCT_P_DISCOUNT_ALL
                    WHERE
                        PRODUCT_ID = #GET_PRODUCT.PRODUCT_ID#
                    ORDER BY 
                        RECORD_DATE DESC
                    </cfquery>
                    <!--- Ürünün Alış Fiyatı çekiliyor her satırda --->
                    <cfquery name="GET_PRICE_STANDART_PURCHASE" dbtype="query" maxrows="1">
                    SELECT
                        MONEY,
                        PRICE,
                        PRICE_KDV
                    FROM
                        GET_PRICE_STANDART_ALL
                    WHERE
                        <cfif len(attributes.price_rec_date)>
                        START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.price_rec_date#"> AND
                        START_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
                        <cfelse>
                        PRICESTANDART_STATUS = 1 AND
                        </cfif>
                        PRODUCT_ID = #PRODUCT_ID# AND
                        PURCHASESALES = 0 AND
                        UNIT_ID = #PRODUCT_UNIT_ID#
                        <cfif len(attributes.price_rec_date)>
                        ORDER BY 
                            START_DATE DESC,
                            RECORD_DATE DESC
                        </cfif>
                    </cfquery>
                    <!--- Ürünün Satış Fiyatı Çekiliyor Her Satırda --->
                    <cfquery name="GET_PRICE_STANDART_SALES_COLUMN" dbtype="query" maxrows="1">
                        SELECT
                            MONEY,
                            PRICE,
                            PRICE_KDV,
                            IS_KDV
                        FROM
                            GET_PRICE_STANDART_ALL
                        WHERE
                            <cfif len(attributes.price_rec_date)>
                            START_DATE >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.price_rec_date#"> AND
                            START_DATE < <cfqueryparam cfsqltype="cf_sql_date" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
                            <cfelse>
                            PRICESTANDART_STATUS = 1 AND
                            </cfif>
                            PRODUCT_ID = #PRODUCT_ID# AND
                            PURCHASESALES = 1 AND
                            UNIT_ID = #PRODUCT_UNIT_ID#
                            <cfif len(attributes.price_rec_date)>
                            ORDER BY 
                                START_DATE DESC,
                                RECORD_DATE DESC
                            </cfif>
                    </cfquery>
                    <!--- Seçilen Fiyat Listesine Ait Ürün Fiyatları --->
                    <cfquery name="GET_PRICE_STANDART_SALES" dbtype="query">
                        SELECT
                            MONEY,
                            PRICE,
                            PRICE_KDV,
                            IS_KDV,
                            CATALOG_ID,
                            PRICE_CATID
                        FROM
                            GET_PRICE_LIST_SALES_ALL
                        WHERE
                            PRODUCT_ID = #PRODUCT_ID# AND 
                            <!--- PRICE_CATID = #attributes.price_cat_list# AND --->
                            PRICE_CATID IN (#attributes.price_cat_list#) AND
                            UNIT = #PRODUCT_UNIT_ID#
                        ORDER BY 
                            PRICE_CATID	
                    </cfquery>
                    <!--- Referans Fiyat Listesi seçilmiş ise Ona göre Satış fiyatı--->
                    <cfif len(attributes.referans_price_list)>  
                        <cfquery name="GET_PRICE_REFERANS_LIST_SALES" dbtype="query" maxrows="1">
                        SELECT
                            MONEY,
                            PRICE
                        FROM
                            GET_PRICE_REFERANS_SALES_ALL
                        WHERE
                            PRODUCT_ID = #PRODUCT_ID# 
                            <cfif attributes.referans_price_list neq 'm'>
                            AND PRICE_CATID = #attributes.referans_price_list#
                            AND UNIT = #PRODUCT_UNIT_ID#
                            </cfif>
                        </cfquery>
                    </cfif>
                    <cfscript>		  
                        tax_alis_toplam = 0;
                        tax_alis_toplam_kdvsiz = 0;
                        kar_marj_deger = 0;
                        
                        if (len(get_product_p_discount.discount1))
                            indirim_1_values = get_product_p_discount.discount1;
                        else
                            indirim_1_values = 0;
                        if (len(get_product_p_discount.discount2))
                            indirim_2_values = get_product_p_discount.discount2;
                        else
                            indirim_2_values = 0;
                        if (len(get_product_p_discount.discount3))
                            indirim_3_values = get_product_p_discount.discount3;
                        else
                            indirim_3_values = 0;
                        if (len(get_product_p_discount.discount4))
                            indirim_4_values = get_product_p_discount.discount4;
                        else
                            indirim_4_values = 0;
                        if (len(get_product_p_discount.discount5))
                            indirim_5_values = get_product_p_discount.discount5;
                        else
                            indirim_5_values = 0;
                        
                        if (not len(get_price_standart_purchase.price))
                            tax_alis_toplam = 0;
                        else
                            tax_alis_toplam = get_price_standart_purchase.price;
                        
                        tax_alis_toplam = tax_alis_toplam * ((100 - indirim_1_values)/100);
                        tax_alis_toplam = tax_alis_toplam * ((100 - indirim_2_values)/100);
                        tax_alis_toplam = tax_alis_toplam * ((100 - indirim_3_values)/100);
                        tax_alis_toplam = tax_alis_toplam * ((100 - indirim_4_values)/100);
                        tax_alis_toplam = tax_alis_toplam * ((100 - indirim_5_values)/100);
                        tax_alis_toplam = wrk_round(tax_alis_toplam);
                        if ( (tax_alis_toplam neq 0) and len(get_price_standart_sales.price) and (get_price_standart_sales.price neq 0) )
                            kar_marj_deger = wrk_round(((get_price_standart_sales.price-tax_alis_toplam)*100)/tax_alis_toplam);
                        
                        tax_alis_toplam_kdvsiz = tax_alis_toplam;//aşağıda kdv hesabına girdiği için burada set ediyoruz kdv'siz olarak.
                        if (len(tax_purchase))
                            tax_alis_toplam = tax_alis_toplam*((tax_purchase+100)/100);
                        
                        tax_alis_toplam = wrk_round(tax_alis_toplam,session.ep.our_company_info.purchase_price_round_num);
                        tax_alis_toplam_kdvsiz = wrk_round(tax_alis_toplam_kdvsiz,session.ep.our_company_info.purchase_price_round_num);
                        
                        tax_satis_column = 0;
                        tax_satis_column_kdvsiz = 0;
                        if ( len(GET_PRICE_STANDART_SALES_COLUMN.price) AND len(GET_PRICE_STANDART_SALES_COLUMN.price_kdv) and GET_PRICE_STANDART_SALES_COLUMN.is_kdv )
                            tax_satis_column = wrk_round(GET_PRICE_STANDART_SALES_COLUMN.price_kdv,session.ep.our_company_info.sales_price_round_num);
                        else if (len(GET_PRICE_STANDART_SALES_COLUMN.price))
                            tax_satis_column = wrk_round(GET_PRICE_STANDART_SALES_COLUMN.price*((tax+100)/100),session.ep.our_company_info.sales_price_round_num);
                        tax_satis_column_kdvsiz = wrk_round(GET_PRICE_STANDART_SALES_COLUMN.price,session.ep.our_company_info.sales_price_round_num);	
                        
                        for (i=1;i lte ListLen(attributes.price_cat_list,','); i=i+1)//Önce seçilen her fiyat listesi için her bir ürünün fiyatları en başta 0 olarak set ediliyor,Aşağıda yapmamızın sebebi bazı fiyat listelerine ait fiyatlar gelmiyor onun için burda set ediyoruz hepsini.
                        {
                            'liste_fiyat_kdvsiz_#PRODUCT_ID#_#ListGetAt(attributes.price_cat_list,i,',')#' = 0;
                            'liste_fiyat_kdvli_#PRODUCT_ID#_#ListGetAt(attributes.price_cat_list,i,',')#' = 0;
                        }
                        for (i=1;i lte GET_PRICE_STANDART_SALES.RECORDCOUNT;i=i+1)//Burada yukarıda dönen   GET_PRICE_STANDART_SALES query'sinden gelen  ürünün seçilen fiyat listelerinden eşleşmeler yapılıyor.
                        {
                            'liste_fiyat_kdvsiz_#PRODUCT_ID#_#GET_PRICE_STANDART_SALES.PRICE_CATID[i]#' = wrk_round(GET_PRICE_STANDART_SALES.PRICE[i],session.ep.our_company_info.sales_price_round_num);
                            if ( len(GET_PRICE_STANDART_SALES.PRICE[i]) and len(GET_PRICE_STANDART_SALES.PRICE_KDV[i]) and GET_PRICE_STANDART_SALES.IS_KDV[i])
                                'liste_fiyat_kdvli_#PRODUCT_ID#_#GET_PRICE_STANDART_SALES.PRICE_CATID[i]#' = wrk_round(GET_PRICE_STANDART_SALES.PRICE_KDV[i],session.ep.our_company_info.sales_price_round_num);
                            else if ( len(GET_PRICE_STANDART_SALES.PRICE[i]) )
                                'liste_fiyat_kdvli_#PRODUCT_ID#_#GET_PRICE_STANDART_SALES.PRICE_CATID[i]#' = wrk_round(GET_PRICE_STANDART_SALES.PRICE[i]*((tax+100)/100),session.ep.our_company_info.sales_price_round_num);
                        }
                    </cfscript>
                    <tbody>
                        <tr title="#product_name#" id="tr_#currentrow#">
                            <!--- Standart Alış --->
                            <td width="100" nowrap style="text-align:right;">#tlformat(get_price_standart_purchase.price,session.ep.our_company_info.purchase_price_round_num)#</td>
                            <!--- İskontolu Alış --->
                            <td width="100" nowrap style="text-align:right;">#tlformat(tax_alis_toplam,session.ep.our_company_info.purchase_price_round_num)#</td>
                            <!--- Para Birimi --->
                            <td width="45" nowrap style="text-align:right;">
                                #get_price_standart_purchase.money#
                                <!-- sil --><input type="hidden" name="purchase_money_#product_id#" id="purchase_money_#product_id#" value="#get_price_standart_purchase.money#"><!-- sil -->							</td>
                            <td width="30" nowrap style="text-align:right;">#TAX#</td>
                            <!--- Standart Satış KDV'li --->
                            <td width="100" nowrap style="text-align:right;">
                                #tlformat(tax_satis_column,session.ep.our_company_info.sales_price_round_num)# #GET_PRICE_STANDART_SALES_COLUMN.money# 
                                <input type="hidden" name="sales_money_#product_id#" id="sales_money_#product_id#" value="#GET_PRICE_STANDART_SALES_COLUMN.money#">
                            </td>
                            <!--- Referans Fiyat Listesi --->
                            <cfif len(attributes.referans_price_list)>
                            <td width="100" nowrap style="text-align:right;">
                                <cfif attributes.referans_price_list eq -1><!--- Standart alış fiyatı referans fiyat oluyor --->
                                    #tlformat(get_price_standart_purchase.price,session.ep.our_company_info.purchase_price_round_num)# #get_price_standart_purchase.money#
                                    <cfinput type="hidden" name="ref_price_#product_id#" id="ref_price_#product_id#" value="#tlformat(get_price_standart_purchase.price,session.ep.our_company_info.purchase_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                                <cfelseif attributes.referans_price_list eq -2><!--- Standar satış fiyatı referance fiyat oluyor. --->
                                    <cfinput type="hidden" name="ref_price_#product_id#" id="ref_price_#product_id#" value="#tlformat(tax_satis_column_kdvsiz,session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
                                    #tlformat(tax_satis_column_kdvsiz,session.ep.our_company_info.sales_price_round_num)# #GET_PRICE_STANDART_SALES_COLUMN.money#<!--- tax_satis_column_kdvsiz --->
                                <cfelseif attributes.referans_price_list eq -3><!--- Standar Alış İskantolu KDV'siz --->
                                    <cfinput type="hidden" name="ref_price_#product_id#" id="ref_price_#product_id#" value="#tlformat(tax_alis_toplam_kdvsiz,session.ep.our_company_info.purchase_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));"><!--- Standart alış iskantolu ve KDV'siz fiyat olmasına rağmen input'un içinde alış fiyatını tutuyoruz sebebi ise burdaki fiyatın aşağıda bir daha hesaplamadan geçmesi. --->
                                    #tlformat(tax_alis_toplam_kdvsiz,session.ep.our_company_info.purchase_price_round_num)# #get_price_standart_purchase.money#
                                <cfelse><!--- Maliyet veya diğer fiyat listelerinden 1 tanesi seçilmiş ise --->
                                    #tlformat(GET_PRICE_REFERANS_LIST_SALES.price,session.ep.our_company_info.sales_price_round_num)# #GET_PRICE_REFERANS_LIST_SALES.MONEY#
                                    <cfinput type="hidden" name="ref_price_#product_id#" id="ref_price_#product_id#" value="#tlformat(GET_PRICE_REFERANS_LIST_SALES.price,session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
                                </cfif>							</td>
                            </cfif>
                            <!--- Liste Satış KDV'siz Fiyatlar --->
                            <cfif listlen(attributes.price_cat_list)>
                                <cfloop list="#attributes.price_cat_list#" index="p_cat_id">
                                    <td width="50" nowrap><input type="text" name="price_cat_margin_#product_id#_#p_cat_id#" id="price_cat_margin_#product_id#_#p_cat_id#" style="width:45px;" value="#Evaluate('PRICE_CAT_MARGIN_#p_cat_id#')#" onBlur="hesapla_fiyat(1,#PRODUCT_ID#,#p_cat_id#,#TAX#)"  class="box" onkeyup="return(FormatCurrency(this,event));"></td>
                                    <td width="100" nowrap><cfinput type="text" name="sales_price_list_#product_id#_#p_cat_id#" id="sales_price_list_#product_id#_#p_cat_id#" value="#tlformat(Evaluate('liste_fiyat_kdvsiz_#PRODUCT_ID#_#p_cat_id#'),session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:90px;" onBlur="hesapla_fiyat(2,#PRODUCT_ID#,#p_cat_id#,#TAX#);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
                                    <td width="100" nowrap><cfinput type="text" name="sales_price_list_kdv_#product_id#_#p_cat_id#" id="sales_price_list_kdv_#product_id#_#p_cat_id#" value="#tlformat(Evaluate('liste_fiyat_kdvli_#PRODUCT_ID#_#p_cat_id#'),session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:90px;" onBlur="hesapla_fiyat(3,#PRODUCT_ID#,#p_cat_id#,#TAX#);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
                                    <td width="20" nowrap style="text-align:right;"><input type="checkbox" name="price_cat_product_list_#p_cat_id#" id="price_cat_product_list_#p_cat_id#" value="#product_id#"></td>
                                </cfloop>
                            </cfif>
                        </tr>
                    </tbody>
                </cfoutput> 
                </cfif>
            </cf_grid_list>
            <div class="row text-right"> 
                <div class="col col-12 form-inline">
                <div class="form-group">
                        <cf_workcube_buttons is_upd='0' insert_info='Düzenle' add_function='gonder()'>
                </div></div></div>
        </cf_basket>
	</cfform>
<cfif isdefined('get_product') and get_product.recordcount gt attributes.maxrows>
    <table>	
        <tr>
            <td>
            <cf_pages page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres#&is_form_submitted=1">
            </td>
        </tr>
    </table>
</cfif>
</cfif>
</cf_box>
<cfif isdefined("get_product")>
	<script type="text/javascript">
		function set_div_position()
		{
			document.getElementById('price_detail_head').style.top=document.getElementById('price_detail').scrollTop+"px";
			document.getElementById('price_detail_head_left').style.top=document.getElementById('price_detail').scrollTop+"px";
			document.getElementById('price_detail_row_left').style.left=document.getElementById('price_detail').scrollLeft+"px";
			document.getElementById('price_detail_head_left').style.left=document.getElementById('price_detail').scrollLeft+"px";
		}
		function select_price_cat(element)
		{
			if(element.checked==true)
				var check=true;
			else
				var check=false;
			
			if(eval("document.getElementById('price_cat_product_list_" + element.value + "')").length>0)
			{
				for(var i=0;i<eval("document.getElementById('price_cat_product_list_"+element.value+"')").length;i++)
				{
					eval("document.getElementById('price_cat_product_list_"+element.value+"')")[i].checked=check;
				}
			}else
			{
				document.getElementById('price_cat_product_list_'+element.value).checked=check;
			}
		}

		
		function hesapla_fiyat(type,product_id,p_cat_id,tax)//price type güncellenek olan fiyatını nerden alacağını bulmak için eklendi,eğer price_type tanımlı geliyorsa referans fiyat listesindeki fiyat üzerinden hesaplama yapılacak.
		{
			//Type == 1 ise Marjın üzerine tıklanmıştır 2 ise Listenin KDV'siz Fiyatının üzerine tıklanmıştır 3 ise KDV'li fiyata tıklanmıştır.
			var row_referance_price = filterNum(document.getElementById('ref_price_'+product_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki referans fiyatı teşkil ediyor
			var row_price_list_margin = filterNum(document.getElementById('price_cat_margin_'+product_id+'_'+p_cat_id).value);//Satırdaki liste fiyatlarına ait marjı tutuyor
			var row_sales_price_list = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
			var row_sales_price_list_kdv = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı
			//Tıklanınca gelen liste fiyatının value'sine değer atmak için...
			if (type==1 && row_referance_price > 0)//Marj'ın üzerine tıklanmışsa ona göre liste fiyatını değiştir.
			{
				//Kdv'siz fiyatı hesapla
				document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value = commaSplit((row_referance_price + ((row_referance_price/100)*row_price_list_margin)),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				//Kdv'li fiyatı hesapla
				var row_sales_price_list = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı tekrar tanımlanıyor değiştiri 
				document.getElementById('sales_price_list_kdv_'+product_id+'_'+p_cat_id).value = commaSplit(( row_sales_price_list + (row_sales_price_list/100)*tax),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			}
			else if (type==2 && row_referance_price > 0)//Eğer liste fiyatına tıklanmış ise ona göre marjı düzenliyoruz.
			{
				document.getElementById('price_cat_margin_'+product_id+'_'+p_cat_id).value = commaSplit((row_sales_price_list-row_referance_price) / (row_referance_price/100),2);
				document.getElementById('sales_price_list_kdv_'+product_id+'_'+p_cat_id).value = commaSplit(row_sales_price_list +((row_sales_price_list/100)*tax),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			}
			else if (type==3 && row_referance_price > 0)
			{
				document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value = commaSplit(((row_sales_price_list_kdv)/(100 + tax))*(100),<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı yenilendi
				//burada satırdaki liste fiyatını tekrar tanımladım çünkü kdv'li fiyatın değişmesinden sonra fiyat yenileniyor.
				var row_sales_price_list = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+p_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı tekrar tanımlandı
				document.getElementById('price_cat_margin_'+product_id+'_'+p_cat_id).value =  commaSplit((row_sales_price_list-row_referance_price) / (row_referance_price/100),2);
			}
		
		}	
		function gonder()
		{
			if(document.all.process_stage.value == '')
			{
				alert("<cf_get_lang dictionary_id ='37830.Ürün Fiyat Süreci ne Yetkiniz Yok'>");
				return false;
			}
			if(document.form_add_price.start_date.value == '')
			{
			alert("<cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'>");
			return false;
			}

			for(var p_cat_i=1;p_cat_i <= list_len('<cfoutput>#attributes.price_cat_list#</cfoutput>',',');p_cat_i++)
			{
				var price_cat_id=list_getat('<cfoutput>#attributes.price_cat_list#</cfoutput>',p_cat_i,',');
				if(eval('document.form_add_price.price_cat_product_list_'+price_cat_id).length>0)
				{
					for(var i=0;i<eval('document.form_add_price.price_cat_product_list_'+price_cat_id).length;i++)
					{
						if(eval('document.form_add_price.price_cat_product_list_'+price_cat_id)[i].checked==true)
						{
							var product_id=eval('document.form_add_price.price_cat_product_list_'+price_cat_id)[i].value;
							document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
							document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı		
						}
					}
				}else
				{
					if(eval('document.form_add_price.price_cat_product_list_'+price_cat_id).checked==true)
					{
						var product_id=eval('document.form_add_price.price_cat_product_list_'+price_cat_id).value;
						document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
						document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı		
					}
				
				}
			}
			
			/*for(var p_cat_i=1;p_cat_i <= list_len('<cfoutput>#attributes.price_cat_list#</cfoutput>',',');p_cat_i++)
			{
				var price_cat_id=list_getat('<cfoutput>#attributes.price_cat_list#</cfoutput>',p_cat_i,',');
				//document.getElementById('ref_price_'+price_cat_id).value=filterNum(document.getElementById('ref_price_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				for(var prod_id_i=1;prod_id_i <= list_len(document.getElementById('price_cat_product_list_'+price_cat_id).value); prod_id_i++)
				{
					var product_id=list_getat(document.getElementById('price_cat_product_list_'+price_cat_id).value,prod_id_i,',');
					document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'siz liste fiyatı
					document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value = filterNum(document.getElementById('sales_price_list_kdv_'+product_id+'_'+price_cat_id).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);//Satırdaki kdv'li liste fiyatı
				}
			}*/
			return true;
		}
	</script>
</cfif>
