<cf_xml_page_edit>
<cfinclude template="../query/get_price_cat.cfm">
<script type="text/javascript">	
	function input_control()
	{ 	
        if(search_product.spec.value==2 && (search_product.is_active.value==-1 || search_product.is_active.value==-2))
        {
            alert("<cf_get_lang dictionary_id='64099.Standart Alış ve Satış Stok Bazlı Düzenlenemez'> !");
            return false;
        }
        <cfif not session.ep.our_company_info.unconditional_list or (isdefined('xml_check_filter_options') and xml_check_filter_options eq 1)>
		bos = 6;
		if(search_product.product_cat.value.length == 0) search_product.product_catid.value = '';
		if(search_product.get_company.value.length == 0) search_product.get_company_id.value = '';
		if(search_product.employee.value.length == 0) search_product.pos_code.value = '';
		if(search_product.brand_name.value.length == 0) search_product.brand_id.value = '';
		
		if (search_product.get_company_id.value == '') bos--;
		if (search_product.product_catid.value == '') bos--;
		if (search_product.pos_code.value == '') bos--;
		if (search_product.brand_id.value == '') bos--;
		if (search_product.product_name.value == '') bos--;
		if (search_product.rec_date.value == '') bos--;
		if(bos < 1)
		{
			alert("<cf_get_lang dictionary_id='58950.En Az Bir arama Kriteri Girmelisiniz'>!");
			return false;
		}
		else
		{
			if(search_product.is_active.selectedIndex > 1)
			{
				search_product.price_rec_date.disabled = false;
				search_product.price_rec_date.value = '';
			}
			return true;
		}
        </cfif>
	}
	
	function disablePRecDate()
	{
		if (search_product.is_active.selectedIndex > 1)
		{
			search_product.price_rec_date.value = '';
			search_product.price_rec_date.disabled = true;
		}
		else
			search_product.price_rec_date.disabled = false;
	}
	function check_all(deger)
		{
			<cfif get_price_cat.recordcount gt 1>
				for(i=0; i<price_cat_list.length; i++)
					price_cat_list[i].checked = deger;
			<cfelseif get_price_cat.recordcount eq 1>
				price_cat_list.checked = deger;
			</cfif>
		}
</script>
<cfinclude template="../query/get_money.cfm">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_code" default="">
<cfparam name="attributes.manufact_code" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="0">
<cfparam name="attributes.get_company_id" default="">
<cfparam name="attributes.get_company" default="">
<cfparam name="attributes.is_active" default="-2">
<cfparam name="attributes.referans_price_list" default="">
<cfparam name="attributes.rec_date" default="">
<cfparam name="attributes.price_rec_date" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.spec" default=1>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> 
<cfif len(attributes.rec_date)><cf_date tarih='attributes.rec_date'></cfif>
<cfif len(attributes.price_rec_date)><cf_date tarih='attributes.price_rec_date'></cfif>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT COMPETITIVE_ID FROM PRODUCT_COMP_PERM WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset competitive_list = valuelist(get_competitive_list.competitive_id)>
<cf_catalystHeader>
<cf_box title="#getLang('','settings',58084)#">
	<cfform name="search_product" method="post" action="#request.self#?fuseaction=product.collacted_product_prices">
		<input type="hidden" name="form_varmi" id="form_varmi" value="1">
        <cf_box_elements>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                            <div class="form-group" id="item-employee">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="pos_code" id="pos_code"  value="<cfoutput>#attributes.pos_code#</cfoutput>">
                                        <input type="text" name="employee" id="employee" style="width:130px;" onfocus="AutoComplete_Create('employee','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','POSITION_CODE','pos_code','','3','135');" value="<cfoutput>#attributes.employee#</cfoutput>" maxlength="255" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=search_product.pos_code&field_name=search_product.employee&select_list=1,9&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.employee.value),'list');"></span>
                                    </div>
                                </div>
                            </div>                            
                            <div class="form-group" id="item-get_company">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="get_company_id" id="get_company_id" value="<cfoutput>#attributes.get_company_id#</cfoutput>">
                                        <input type="text" name="get_company" id="get_company" style="width:130px;" onfocus="AutoComplete_Create('get_company','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',0,0','COMPANY_ID','get_company_id','','3','250');"  value="<cfoutput>#attributes.get_company#</cfoutput>" autocomplete="off">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=search_product.get_company&field_comp_id=search_product.get_company_id&select_list=2&is_form_submitted=1&keyword='+encodeURIComponent(document.search_product.get_company.value),'list');"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_name">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <input type="text" name="product_name" id="product_name" style="width:120px;" value="<cfoutput>#attributes.product_name#</cfoutput>" maxlength="255">
                                </div>
                            </div>
                        <cfif show_product_stock>
                            <div class="form-group">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63619.Ürün - Stok Bazlı Fiyatlama'></label>
                                    <div class="col col-8 col-xs-12"> 
                                <select name="spec" id="spec">
                                <option value="1"<cfif isDefined("attributes.spec") and attributes.spec eq 1> selected</cfif>><cf_get_lang dictionary_id='34762.Ürün Bazında'></option>
                                <option value="2"<cfif isDefined("attributes.spec") and attributes.spec eq 2> selected</cfif>><cf_get_lang dictionary_id='45555.Stok Bazında'></option>
                                </select>
                            </div>
                            </div>
                        </cfif>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                            <div class="form-group" id="item-getProductBrand">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <cf_wrkproductbrand
                                        width="120"
                                        compenent_name="getProductBrand"               
                                        boxwidth="240"
                                        boxheight="150"
                                        brand_id="#attributes.brand_id#">
                                </div>
                            </div>
                            <div class="form-group" id="item-product_cat">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <input type="hidden" name="product_catid" id="product_catid" value="<cfoutput>#attributes.product_catid#</cfoutput>">
                                        <input type="text" name="product_cat" id="product_cat" onfocus="AutoComplete_Create('product_cat','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','PRODUCT_CATID','product_catid','','3','200');" value="<cfoutput>#attributes.product_cat#</cfoutput>" autocomplete="off" style="width:120px;">
                                        <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_id=search_product.product_catid&field_name=search_product.product_cat&keyword='+encodeURIComponent(document.search_product.product_cat.value)</cfoutput>);" title="<cf_get_lang dictionary_id ='37157.Ürün Kategorisi Seç'>!"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-manufact_code">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57634.Üretici Kodu'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <input type="text" name="manufact_code" id="manufact_code" style="width:120px;" value="<cfoutput>#attributes.manufact_code#</cfoutput>" maxlength="255">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                            <div class="form-group" id="item-is_active">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37015.Düzenleme Fiyat'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <select name="is_active" id="is_active" onchange="disablePRecDate();" style="width:220px;">
                                        <option value="-1"<cfif attributes.is_active eq -1> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                        <option value="-2"<cfif attributes.is_active eq -2> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                        <cfoutput query="get_price_cat"> 
                                            <option value="#price_catid#" <cfif (price_catid is attributes.is_active)> selected</cfif>>#price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-referans_price_list">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30108.Referans Fiyat'></label>
                                <div class="col col-8 col-xs-12"> 
                                     <select name="referans_price_list" id="referans_price_list" style="width:220px;">
                                        <option value="-3"<cfif attributes.referans_price_list eq -3 or not len(attributes.referans_price_list)> selected</cfif>><cf_get_lang dictionary_id='37829.Standart Alış İskontolu'> </option>
                                        <option value="-1"<cfif attributes.referans_price_list eq -1> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
                                        <option value="-2"<cfif attributes.referans_price_list eq -2> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                        <option value="-4"<cfif attributes.referans_price_list eq -4> selected</cfif>><cf_get_lang dictionary_id ='37050.Son Alış'></option>
                                        <option value="M" <cfif attributes.referans_price_list is 'm'> selected</cfif>><cf_get_lang dictionary_id='58258.Maliyet'></option>
                                        <cfoutput query="get_price_cat">
                                            <option value="#price_catid#" <cfif (price_catid is attributes.referans_price_list)> selected</cfif>>#price_cat#</option>
                                        </cfoutput>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group" id="item-product_code">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <input type="text" name="product_code" id="product_code" style="width:120px;" value="<cfoutput>#attributes.product_code#</cfoutput>" maxlength="255">
                                </div>
                            </div>
                        </div>
                        <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
                            <div class="form-group" id="item-price_rec_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37555.Fiyat Kayıt Tarihi'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37630.Fiyat kayıt tarihinde hata' >!</cfsavecontent>
                                       <cfoutput> <input type="text" name="price_rec_date" id="price_rec_date" value="#DateFormat(attributes.price_rec_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#"></cfoutput> 
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="price_rec_date"></span>
                                    </div>
                                </div>
                            </div>
                            <div class="form-group" id="item-rec_date">
                                <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37549.Ürün Kayıt Tarihi'></label>
                                <div class="col col-8 col-xs-12"> 
                                    <div class="input-group">
                                        <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37441.Ürün kayıt tarihinde hata'> !</cfsavecontent>
                                            <cfoutput>  <input type="text" name="rec_date" id="rec_date" value="#DateFormat(attributes.rec_date,dateformat_style)#" maxlength="10" validate="#validate_style#" style="width:65px;" message="#message#"></cfoutput> 
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="rec_date"></span>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group" id="item-product_code">
                                <div class="col col-11 col-xs-12"><cf_get_lang dictionary_id='64075.Fiyat Listesindeki Ürünler Gelsin'>
                                    <input type="checkbox" name="is_price_list_product" id="is_price_list_product" value="1" <cfif isdefined('attributes.is_price_list_product')>checked</cfif>>
                                </div>
                            </div>
                        </div>
                 
                    <div class="row formContentFooter">	
                        <div class="col col-12 text-right">
                                <cf_wrk_search_button button_type='1' search_function='input_control()' is_excel='0'>
                        </div> 
                    </div>
                </cf_box_elements>
   </cfform>
<cfif IsDefined("attributes.form_varmi")>
    <form id="form_add_product_property" name="form_add_product_property" method="post" >
            <cf_grid_list id="fiyat">
                <thead>
                    <tr>
                        <th width="10"><cf_get_lang dictionary_id='57487.No'></th>
                            <th><cf_get_lang dictionary_id='57518.stok kodu'></th>
                        <th width="300"><cf_get_lang dictionary_id='57657.Ürün'>- <cf_get_lang dictionary_id='57452.Stok'></th>
                        <th><cf_get_lang dictionary_id='57633.Barkod'></th>
                       
                        <th><cf_get_lang dictionary_id='57486.Kategori'></th>
                        <th width="40"><cf_get_lang dictionary_id='57636.Birim'></th>
                        <th width="25"><cf_get_lang dictionary_id='37375.Min. Marj'></th>
                        <th width="25"><cf_get_lang dictionary_id='37374.Min Marj'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='58722.Standart Alış'></th>
                        <th width="100" style="text-align:right;"><cf_get_lang dictionary_id='37391.İskontolu Alış KDVli'></th>
                        <th width="45"  style="text-align:right;"><cf_get_lang dictionary_id='57489.Para Br'></th>
                        <th width="100"  style="text-align:right;"><cf_get_lang dictionary_id='58721.Standart Satış'>  <cf_get_lang dictionary_id='58716.KDV li'></th>
                        <cfif len(attributes.referans_price_list)>
                        <th width="100" align="right" class="form-title" style="text-align:right;"><cfif attributes.referans_price_list is 'm'><cf_get_lang dictionary_id='58258.Maliyet'><cfelse><cf_get_lang dictionary_id='58784.Referans'> <cf_get_lang dictionary_id='58084.Fiyat'></cfif></th>
                        </cfif>
                        <th width="33" ><cf_get_lang dictionary_id='37045.Mrj'><input type="text" class="box" style="width:35px;" onblur="uygula_marj(filterNum(this.value));" value="<cfoutput>#Tlformat(0,00)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,2));"></th>
                        <th width="100" class="form-title" style="text-align:right;"><cf_get_lang dictionary_id='37015.Düzenleme Fiyat'></th>
                        <th width="25"><cf_get_lang dictionary_id='57639.KDV'></th>
                        <th width="100"><cf_get_lang dictionary_id='37016.Düzenleme Fiyat KDVli'></th>
                        <th width="25">
                            <cf_get_lang dictionary_id='57639.KDV'> D.
                            <input name="is_tax_included" id="is_tax_included" type="checkbox" value="1" onclick="all_is_tax_included();">
                        </th>  
                        <th width="45"><cf_get_lang dictionary_id='57489.Para Br'>
                            <cfoutput>
                                <select name="sales_money" id="sales_money" style="width:45px;" class="box" onchange="all_money_unit(this.value)">
                            <cfloop query="get_money">
                            <cfloop query="get_money">
                                <option value="#money#">#money#</option>
                            </cfloop>
                            </cfloop>
                                </select>
                            </cfoutput>
                        </th> 
                        <th width="15"><cf_get_lang dictionary_id='58693.Seç'></th>
                        <th width="11"><cf_get_lang dictionary_id='58084.Fiyat'></th>
                    </tr>
                </thead>
                <tbody>
                <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                    <cfquery name="GET_PRODUCT_CATS" datasource="#DSN3#">
                        SELECT 
                            PRODUCT_CATID, 
                            HIERARCHY
                        FROM 
                            PRODUCT_CAT 
                        WHERE 
                            PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#">
                        ORDER BY 
                            HIERARCHY
                    </cfquery>		  
                </cfif> 
                <cfquery name="check_table" datasource="#DSN3#">
                    IF EXISTS (select * from tempdb.sys.tables where name='####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#')
                    DROP TABLE ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#
                </cfquery>
                <cfquery name="INSERT_GET_PRODUCT" datasource="#DSN3#">
                    SELECT 
                        P.MANUFACT_CODE,
                        P.PRODUCT_NAME, 
                        P.RECORD_DATE, 
                        P.PRODUCT_CODE,
                        P.PRODUCT_ID,
                        P.BRAND_ID,
                        P.TAX,
                        P.TAX_PURCHASE,
                        P.MAX_MARGIN,
                        P.MIN_MARGIN,
                        P.PROD_COMPETITIVE,
                        PU.PRODUCT_UNIT_ID,
                        PU.MAIN_UNIT,
                        PRODUCT_CAT.PRODUCT_CAT,
                        S.BARCOD,
                        S.MAIN_SPEC,
		                S.PROPERTY,
                        S.STOCK_CODE,
                        S.STOCK_ID
                    INTO ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#
                    FROM 
                        PRODUCT P,
                        PRODUCT_UNIT PU,
                        PRODUCT_CAT
                        <cfif isdefined('attributes.is_price_list_product') and attributes.is_active gt 0>
							,PRICE
						</cfif>
                        ,
                        (	
                        SELECT 
                        *,
                        (SELECT TOP 1 SPECT_MAIN_ID FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID AND SM.IS_TREE = 1 ORDER BY SM.RECORD_DATE DESC,SM.UPDATE_DATE DESC) MAIN_SPEC
                        FROM
                        STOCKS S) S	
                    WHERE 
                    
						<cfif isdefined('attributes.is_price_list_product') and attributes.is_active gt 0>
							PRICE.PRODUCT_ID = P.PRODUCT_ID AND
							PRICE.PRICE_CATID=#attributes.is_active# AND
						</cfif>
                        P.PRODUCT_ID = PU.PRODUCT_ID AND
                        P.PRODUCT_STATUS = 1 AND
                        PU.IS_MAIN = 1 AND
                        PU.PRODUCT_UNIT_STATUS = 1 AND
                        PRODUCT_CAT.PRODUCT_CATID = P.PRODUCT_CATID AND
                        S.PRODUCT_ID = P.PRODUCT_ID 
                        <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                            AND P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#get_product_cats.hierarchy#.%">
                        </cfif>
                        <cfif len(attributes.employee) and len(attributes.pos_code)>
                            AND P.PRODUCT_MANAGER = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pos_code#">
                        </cfif>
                        <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                            AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.get_company_id#">
                        </cfif>
                        <cfif len(attributes.brand_id)>
                            AND P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
                        </cfif>
                        <cfif len(attributes.rec_date)>
                            AND P.RECORD_DATE >= #attributes.rec_date#
                        </cfif>
                        <cfif len(attributes.product_name)>
                            AND (P.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%"> OR  P.BARCOD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%"> OR P.PRODUCT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_name#%">)
                        </cfif>
                        <cfif len(attributes.product_code)>
                            AND (P.PRODUCT_CODE_2 LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.product_code#%">)
                        </cfif>
                        <cfif len(attributes.manufact_code)>
                            AND (P.MANUFACT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.manufact_code#%">)
                        </cfif>
                        <cfif attributes.is_active eq -1>
                            AND P.IS_PURCHASE = 1
                        </cfif> 
                        <cfif isDefined('attributes.spec') and attributes.spec eq 1>
                            AND S.STOCK_CODE = P.PRODUCT_CODE
	                    </cfif>
                    ORDER BY 
                        P.PRODUCT_NAME
                </cfquery>
                <cfquery name="GET_PRODUCT" datasource="#DSN3#">
                         WITH CTE1 AS (SELECT * FROM ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3# ),
                               CTE2 AS (
                                    SELECT
                                        CTE1.*,
                                        ROW_NUMBER() OVER (	ORDER BY  PRODUCT_NAME
                                                        ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                                    FROM
                                        CTE1
                                )
                                SELECT
                                    CTE2.*
                                FROM
                                    CTE2
                                WHERE
                                    RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1) 
                </cfquery>
                <cfparam name="attributes.totalrecords" default="#GET_PRODUCT.query_count#">
                <cfset product_id_list =ValueList(get_product.stock_id,',')>
                <cfset newrecordcount = 0>
                <cfif get_product.recordcount>
                    <!---GET_PRODUCT_P_DISCOUNT_ALL--->
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
                            AND PR.PRODUCT_MANAGER = #attributes.pos_code#
                        </cfif>
                        <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                            AND PR.COMPANY_ID = #attributes.get_company_id#
                        </cfif>
                        <cfif len(attributes.brand_id)>
                            AND PR.BRAND_ID = #attributes.brand_id#
                        </cfif>
                        <cfif len(attributes.rec_date)>
                            AND PR.RECORD_DATE >= #attributes.rec_date#
                        </cfif>
                        <cfif len(attributes.product_name)>
                            AND (PR.PRODUCT_NAME LIKE '%#attributes.product_name#%' OR  PR.BARCOD LIKE '%#attributes.product_name#%' OR PR.PRODUCT_CODE LIKE '%#attributes.product_name#%')
                        </cfif>
                        <cfif len(attributes.product_code)>
                            AND (PR.PRODUCT_CODE_2 LIKE '%#attributes.product_code#%')
                        </cfif>
                        <cfif attributes.is_active eq -1>
                            AND PR.IS_PURCHASE = 1
                        </cfif>
                
                        ORDER BY 
                            CPPD.START_DATE DESC
                    </cfquery>
                    <!---GET_PRICE_STANDART_ALL--->
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
                            AND PR.PRODUCT_MANAGER = #attributes.pos_code#
                        </cfif>
                        <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                            AND PR.COMPANY_ID = #attributes.get_company_id#
                        </cfif>	
                        <cfif len(attributes.brand_id)>
                            AND PR.BRAND_ID = #attributes.brand_id#
                        </cfif>
                        <cfif len(attributes.rec_date)>
                            AND PR.RECORD_DATE >= #attributes.rec_date#
                        </cfif>
                        <cfif len(attributes.product_name)>
                            AND (PR.PRODUCT_NAME LIKE '%#attributes.product_name#%' OR  PR.BARCOD LIKE '%#attributes.product_name#%' OR PR.PRODUCT_CODE LIKE '%#attributes.product_name#%')
                        </cfif>
                        <cfif len(attributes.product_code)>
                            AND (PR.PRODUCT_CODE_2 LIKE '%#attributes.product_code#%')
                        </cfif>
                        <cfif attributes.is_active eq -1>
                            AND PR.IS_PURCHASE = 1
                        </cfif>
                    </cfquery>
                    
                    <cfif attributes.is_active neq -2>
                        <!---GET_PRICE_STANDART_SALES_ALL--->
                        <cfquery name="GET_PRICE_STANDART_SALES_ALL" datasource="#DSN3#">
                            SELECT
                                P.MONEY,
                                P.PRICE,
                                P.PRICE_KDV,
                                P.IS_KDV,
                                P.PRODUCT_ID,
                                P.PRICE_CATID,
                                P.UNIT,
                                P.CATALOG_ID,
                                S.STOCK_ID
                            FROM
                                PRICE P,
                                PRODUCT PR,
                                PRODUCT_UNIT PU,
                                STOCKS S
                            WHERE
                                S.STOCK_ID = P.STOCK_ID AND
                                P.PRODUCT_ID = PR.PRODUCT_ID AND
                                PR.PRODUCT_ID = PU.PRODUCT_ID AND
                                <!---ISNULL(P.STOCK_ID,0)=0 AND fiyat kaydederken stok id atılması sağlandığı için kapatıldı.--->
                                ISNULL(P.SPECT_VAR_ID,0)=0 AND
                                P.STARTDATE <= #now()# AND
                                (P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
                                PR.PRODUCT_STATUS = 1 AND
                                PU.IS_MAIN = 1
                            <cfif len(attributes.product_cat) and len(attributes.product_catid)>
                                AND PR.PRODUCT_CODE LIKE '#get_product_cats.hierarchy#.%'
                            </cfif>
                            <cfif len(attributes.employee) and len(attributes.pos_code)>
                                AND PR.PRODUCT_MANAGER = #attributes.pos_code#
                            </cfif>
                            <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                                AND PR.COMPANY_ID = #attributes.get_company_id#
                            </cfif>
                                AND P.PRICE_CATID = #attributes.is_active#
                            <cfif len(attributes.brand_id)>
                                AND PR.BRAND_ID = #attributes.brand_id#
                            </cfif>
                            <cfif len(attributes.rec_date)>
                                AND PR.RECORD_DATE >= #attributes.rec_date#
                            </cfif>
                            <cfif len(attributes.product_name)>
                                AND (PR.PRODUCT_NAME LIKE '%#attributes.product_name#%' OR  PR.BARCOD LIKE '%#attributes.product_name#%' OR PR.PRODUCT_CODE LIKE '%#attributes.product_name#%')
                            </cfif>
                            <cfif len(attributes.product_code)>
                                AND (PR.PRODUCT_CODE_2 LIKE '%#attributes.product_code#%')
                            </cfif>
                            <cfif attributes.is_active eq -1>
                                AND PR.IS_PURCHASE = 1
                            </cfif>
                        </cfquery>
                    </cfif>
                    <cfif len(attributes.referans_price_list)><!--- Referans Fiyat Listesi Seçilmiş ise öncelikle burda bu fiyat listesine ait tüm fiyatları seçiyoruz. --->
                        <cfif not len(product_id_list)> <cfset product_id_list = 0></cfif>
                        <cfif attributes.referans_price_list is 'm'><!--- Maliyet seçilmiş ise maliyetten fiyatları getirsin. --->
                            <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN1#">
                                SELECT
                                   PRODUCT_COST. PRODUCT_ID,
                                    -1 PRICE_CATID,
                                    PRODUCT_COST.PRODUCT_COST AS PRICE,
                                    PRODUCT_COST.MONEY
                                FROM
                                    PRODUCT_COST JOIN ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3# TEMP  ON 	TEMP.PRODUCT_ID = PRODUCT_COST.PRODUCT_ID
                                WHERE
                                    PRODUCT_COST_STATUS = 1 
                                ORDER BY
                                    START_DATE DESC
                                    <cfif isdefined("rec_date") and len(rec_date)>,
                                    RECORD_DATE DESC
                                    </cfif>
                            </cfquery>
                          
                        <cfelseif attributes.referans_price_list eq -4><!--- Son Alışlar ise --->
                            <cfquery name="GET_PRICE_REFERANS_SALES_ALL" datasource="#DSN1#">
                                SELECT
                                    PU.PRODUCT_UNIT_ID,
                                    PU.PRODUCT_ID,
                                    -4 PRICE_CATID,
                                    ISNULL((SELECT TOP 1 IR.PRICE_OTHER FROM #dsn2_alias#.INVOICE_ROW AS IR,#dsn2_alias#.INVOICE AS I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = 0 AND PU.PRODUCT_UNIT_ID = IR.UNIT_ID AND IR.PRODUCT_ID = P.PRODUCT_ID ORDER BY I.INVOICE_DATE DESC ),0) AS PRICE,
                                    (SELECT TOP 1 IR.OTHER_MONEY FROM #dsn2_alias#.INVOICE_ROW AS IR,#dsn2_alias#.INVOICE AS I WHERE I.INVOICE_ID = IR.INVOICE_ID AND I.PURCHASE_SALES = 0 AND PU.PRODUCT_UNIT_ID = IR.UNIT_ID AND IR.PRODUCT_ID = P.PRODUCT_ID ORDER BY I.INVOICE_DATE DESC ) as MONEY
                                FROM 
                                    PRODUCT_UNIT PU JOIN ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3# TEMP  ON TEMP.PRODUCT_ID = PU.PRODUCT_ID ,
                                    PRODUCT P 
                                WHERE
                                    P.PRODUCT_ID = PU.PRODUCT_ID 
                            </cfquery>
                        <cfelse>
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
                                    AND PR.PRODUCT_MANAGER = #attributes.pos_code#
                                </cfif>
                                <cfif len(attributes.get_company) and len(attributes.get_company_id)>
                                    AND PR.COMPANY_ID = #attributes.get_company_id#
                                </cfif>
                                    AND P.PRICE_CATID = #attributes.referans_price_list#
                                    AND P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM ####GET_PRODUCT_collacted_#session.ep.userid#_#DSN3#)
                                </cfquery>
                            </cfif>	
                        </cfif>
                        
                        
                        <cfoutput query="get_product">
                            <cfquery name="GET_PRODUCT_P_DISCOUNT" dbtype="query" maxrows="1">
                                SELECT
                                    *
                                FROM
                                    GET_PRODUCT_P_DISCOUNT_ALL
                                WHERE
                                    PRODUCT_ID = #get_product.product_id#
                                ORDER BY 
                                    RECORD_DATE DESC
                            </cfquery>
                            <cfquery name="GET_PRICE_STANDART_PURCHASE" dbtype="query" maxrows="1">
                                SELECT
                                    MONEY,
                                    PRICE,
                                    PRICE_KDV
                                FROM
                                    GET_PRICE_STANDART_ALL
                                WHERE
                                    <cfif len(attributes.price_rec_date)>
                                    START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                                    START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
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
                                    START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                                    START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
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
                            <cfif attributes.is_active eq -2>
                                <cfquery name="GET_PRICE_STANDART_SALES" dbtype="query" maxrows="1">
                                    SELECT
                                        MONEY,
                                        PRICE,
                                        PRICE_KDV,
                                        IS_KDV,
                                        '' AS CATALOG_ID
                                    FROM
                                        GET_PRICE_STANDART_ALL
                                    WHERE
                                        <cfif len(attributes.price_rec_date)>
                                        START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                                        START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
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
                                <cfelseif attributes.is_active neq -2 and attributes.is_active neq -1>
                                   <!--- Standart alış ve satışın dışında ise --->
                                   <cfquery name="GET_PRICE_STANDART_SALES" dbtype="query">
                                    SELECT
                                        MONEY,
                                        PRICE,
                                        PRICE_KDV,
                                        IS_KDV,
                                        CATALOG_ID
                                    FROM
                                        GET_PRICE_STANDART_SALES_ALL
                                    WHERE
                                        PRODUCT_ID = #PRODUCT_ID# AND 
                                        PRICE_CATID = #attributes.is_active# AND
                                        UNIT = #PRODUCT_UNIT_ID# AND
                                        STOCK_ID = #STOCK_ID#
                                </cfquery>
                                <cfelse>
                                    <!--- Secilen Fiyat Listesine Ait Ürün Fiyatları --->
                                    <cfquery name="GET_PRICE_STANDART_SALES" dbtype="query">
                                        SELECT
                                            MONEY,
                                            PRICE,
                                            PRICE_KDV,
                                            IS_KDV,
                                            CATALOG_ID
                                        FROM
                                            GET_PRICE_STANDART_SALES_ALL
                                        WHERE
                                            PRODUCT_ID = #PRODUCT_ID# AND 
                                            PRICE_CATID = #attributes.is_active# AND
                                            UNIT = #PRODUCT_UNIT_ID#
                                    </cfquery>
                                </cfif>
                                <cfif len(attributes.referans_price_list)><!--- Referans Fiyat Listesi seçilmiş ise --->
                                    <cfquery name="GET_PRICE_REFERANS_LIST_SALES" dbtype="query" maxrows="1">
                                        SELECT
                                            MONEY,
                                            PRICE
                                        FROM
                                            GET_PRICE_REFERANS_SALES_ALL
                                        WHERE
                                            PRODUCT_ID = #PRODUCT_ID# 
                                        <cfif (attributes.referans_price_list neq 'm') and (attributes.referans_price_list neq -4)>
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
                                    
                                    tax_satis_toplam = 0;
                                    if ( len(get_price_standart_sales.price) AND len(get_price_standart_sales.price_kdv) and get_price_standart_sales.is_kdv )
                                    tax_satis_toplam = wrk_round(get_price_standart_sales.price_kdv,session.ep.our_company_info.sales_price_round_num);
                                    else if (len(get_price_standart_sales.price))
                                    tax_satis_toplam = wrk_round(get_price_standart_sales.price*((tax+100)/100),session.ep.our_company_info.sales_price_round_num);
                                </cfscript>
                                <cfif not len(attributes.price_rec_date) or (len(attributes.price_rec_date) and attributes.is_active eq -1 and get_price_standart_purchase.recordcount) or (len(attributes.price_rec_date) and attributes.is_active eq -2 and GET_PRICE_STANDART_SALES_COLUMN.recordcount)>
                                    <!--- Standart alış ve satışın dışında ise--->
                                    <cfset newrecordcount = newrecordcount + 1>
                                    <input type="hidden" name="discount_1_val#stock_id#" id="discount_1_val#stock_id#" value="#get_product_p_discount.discount1#"><!---  onBlur="hesapla_fiyat(#stock_id#);" --->
                                    <input type="hidden" name="discount_2_val#stock_id#" id="discount_2_val#stock_id#" value="#get_product_p_discount.discount2#">
                                    <input type="hidden" name="discount_3_val#stock_id#" id="discount_3_val#stock_id#" value="#get_product_p_discount.discount3#">
                                    <input type="hidden" name="discount_4_val#stock_id#" id="discount_4_val#stock_id#" value="#get_product_p_discount.discount4#">
                                    <input type="hidden" name="discount_5_val#stock_id#" id="discount_5_val#stock_id#" value="#get_product_p_discount.discount5#">
                            		<tr>
                                        <td>#rownum#</td>
                                        <td>#STOCK_CODE#</td>
                                        <td><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.stock_id#');">#product_name# #PROPERTY#</a></td>
                                        <td>#BARCOD#</td>
                                        <td>#PRODUCT_CAT#</td>
                                        <td><input type="hidden" name="unit_id#stock_id#" id="unit_id#stock_id#" value="#product_unit_id#">#main_unit#</td>
                                        <input type="hidden" name="max_margin#stock_id#" id="max_margin#stock_id#" value="#max_margin#">
                                        <input type="hidden" name="min_margin#stock_id#" id="min_margin#stock_id#" value="#min_margin#"> 
                                        <td align="right" style="text-align:right;">#max_margin#</td>
                                        <td align="right" style="text-align:right;">#min_margin#</td>
                                        <td>
                                            <!--- Standart Alis --->
                                            <input type="text" id="purchase_price#stock_id#" name="purchase_price#stock_id#" value="#tlformat(get_price_standart_purchase.price,session.ep.our_company_info.purchase_price_round_num)#" class="box" style="width:100px;" onBlur="hesapla_fiyat(#stock_id#,1);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                                        </td>
                                        <input type="hidden" name="purchase_price_old#stock_id#" id="purchase_price_old#stock_id#" value="#get_price_standart_purchase.price#">
                                        <input type="hidden" name="tax_purchase_val#stock_id#" id="tax_purchase_val#stock_id#" value="#tax_purchase#">
                                        <td><input type="text" id="purchase_price_with_tax#stock_id#" name="purchase_price_with_tax#stock_id#" value="#tlformat(tax_alis_toplam,session.ep.our_company_info.purchase_price_round_num)#" class="box" style="width:100px;" readonly="yes"></td>
                                        <td align="right" style="text-align:right;">
                                            #get_price_standart_purchase.money#
                                            <input type="hidden" name="purchase_money#stock_id#" id="purchase_money#stock_id#" value="#get_price_standart_purchase.money#">
                                        </td>
                                        <td align="right" style="text-align:right;">#tlformat(tax_satis_column,session.ep.our_company_info.sales_price_round_num)# #get_price_standart_sales_column.money#</td>
										<cfif len(attributes.referans_price_list)>
                                            <td align="right" style="text-align:right;">
                                                <cfif attributes.referans_price_list eq -1><!--- Standart alis fiyati referans fiyat oluyor --->
                                                    #tlformat(get_price_standart_purchase.price,session.ep.our_company_info.purchase_price_round_num)# #get_price_standart_purchase.money#
                                                    <input type="hidden" id="_ref_price_#stock_id#" name="_ref_price_#stock_id#" value="#tlformat(get_price_standart_purchase.price,session.ep.our_company_info.purchase_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));">
                                                <cfelseif attributes.referans_price_list eq -2><!--- Standart satis fiyatı referance fiyat oluyor. --->
                                                    <input type="hidden" id="_ref_price_#stock_id#" name="_ref_price_#stock_id#" value="#tlformat(tax_satis_column_kdvsiz,session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
                                                    #tlformat(tax_satis_column_kdvsiz,session.ep.our_company_info.sales_price_round_num)# #get_price_standart_sales_column.money#<!--- tax_satis_column_kdvsiz --->
                                                <cfelseif attributes.referans_price_list eq -3><!--- Standart Alış Iskantolu KDV'siz --->
                                                    <input type="hidden" id="_ref_price_#stock_id#" name="_ref_price_#stock_id#" value="#tlformat(tax_alis_toplam_kdvsiz,session.ep.our_company_info.purchase_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));"><!--- Standart alış iskantolu ve KDV'siz fiyat olmasına rağmen input'un içinde alış fiyatını tutuyoruz sebebi ise burdaki fiyatın aşağıda bir daha hesaplamadan geçmesi. --->
                                                    #tlformat(tax_alis_toplam_kdvsiz,session.ep.our_company_info.purchase_price_round_num)# #get_price_standart_purchase.money#
                                                <cfelse><!--- Maliyet veya diğer fiyat listelerinden 1 tanesi seçilmiş ise --->
                                                    #tlformat(get_price_referans_list_sales.price,session.ep.our_company_info.sales_price_round_num)# #get_price_referans_list_sales.money#
                                                    <input type="hidden" id="_ref_price_#stock_id#" name="_ref_price_#stock_id#" value="#tlformat(get_price_referans_list_sales.price,session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:100px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));">
                                                </cfif>
                                            </td>
                                        </cfif>
                                            <cfset red = "red">
                                            <cfset black = "black">
                                            <cfset blue = "blue">
                                            <td align="right" style="text-align:right;"><input type="text" id="kar_marj_degeri#stock_id#" name="kar_marj_degeri#stock_id#" value="#TLFormat(kar_marj_deger)#" class="box" style="width:33px;color:#iif(kar_marj_deger gte 0,iif((kar_marj_deger gt max_margin) or (kar_marj_deger lt min_margin),'red','black'),'blue')#;" onBlur="hesapla_fiyat(#stock_id#,5);" onkeyup="return(FormatCurrency(this,event));"></td>
                                            <td><input type="text" id="sales_price#stock_id#" name="sales_price#stock_id#" value="#tlformat(get_price_standart_sales.price,session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:100px;" onBlur="hesapla_fiyat(#stock_id#,3);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
                                            <td><input type="text" name="tax_sales_val#stock_id#" id="tax_sales_val#stock_id#" value="#tax#" readonly=yes class="box" style="width:25px;"></td>
                                            <td><input type="text" id="sales_price_with_tax#stock_id#" name="sales_price_with_tax#stock_id#" value="#tlformat(tax_satis_toplam,session.ep.our_company_info.sales_price_round_num)#" class="box" style="width:100px;" onBlur="hesapla_fiyat(#stock_id#,4);" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"></td>
                                            <td><input name="is_tax_included#stock_id#" id="is_tax_included#stock_id#" type="checkbox" value="#stock_id#"  /></td>
                                            <td>
                                                <select name="sales_money#stock_id#" id="sales_money#stock_id#" style="width:45px;" class="box">
                                                <cfloop query="get_money">
                                                    <option value="#money#" <cfif money eq get_price_standart_sales.money> selected</cfif>>#money#</option>
                                                </cfloop>
                                                </select>
                                            </td>
                                            <td>
                                            <input name="is_record_active" id="is_record_active"  type="checkbox" value="#stock_id#"></td>
                                            <input type="hidden" name="product_id" id="product_id" value="#stock_id#">
                                            <input type="hidden" name="product_id#stock_id#" id="product_id#stock_id#" value="#product_id#">
                                            <input type="hidden" name="stock_id#stock_id#" id="stock_id#stock_id#" value="#stock_id#">
                                            <input type="hidden" name="sales_price_old#stock_id#" id="sales_price_old#stock_id#" value="#get_price_standart_sales.price#">
                                            <input type="hidden" name="sales_price_with_tax_old#stock_id#" id="sales_price_with_tax_old#stock_id#" value="#tax_satis_toplam#"> 
                                            <td width="30" nowrap="nowrap">
                                                    <!--- <cfset str_url_open="product.popup_form_add_product_price&pid=#get_product.product_id[currentrow]#&price_catid=#attributes.is_active#&collected=1"> --->
                                                    <cfset str_url_open="product.popup_form_add_product_price&pid=#get_product.product_id[currentrow]#&collected=1">
                                                    <a href="javascript://" title="<cf_get_lang dictionary_id='37124.Fiyat Ekle'>" onclick="openBoxDraggable('#request.self#?fuseaction=#str_url_open#');"><i class="fa fa-plus"></i></a>
                                                <cfif len(get_price_standart_sales.catalog_id)>
                                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=product.popup_product_contract&pid=#get_product.product_id[currentrow]#','page');"><img src="/images/plus_thin_p.gif" align="absbottom" border="0" title="Ürün aksiyonda !"></a>
                                                </cfif>
                                            </td>	
                            		</tr>
                                    <!--- /stok bazında --->
								</cfif>
                  </cfoutput>   
                  
                  
                  <cfif len(attributes.price_rec_date) and (attributes.is_active eq -1  or attributes.is_active eq -2 )>
					  <cfset totalrecords =  0>
					  <cfoutput query="get_product">
                     	    <cfquery name="GET_PRICE_STANDART_PURCHASE" dbtype="query" maxrows="1">
                                SELECT
                                    MONEY,
                                    PRICE,
                                    PRICE_KDV
                                FROM
                                    GET_PRICE_STANDART_ALL
                                WHERE
                                    <cfif len(attributes.price_rec_date)>
                                    START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                                    START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
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
                                    START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.price_rec_date#"> AND
                                    START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,attributes.price_rec_date)#"> AND
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
                      		<cfif not len(attributes.price_rec_date) or (len(attributes.price_rec_date) and attributes.is_active eq -1 and get_price_standart_purchase.recordcount) or (len(attributes.price_rec_date) and attributes.is_active eq -2 and GET_PRICE_STANDART_SALES_COLUMN.recordcount)>
								<cfset totalrecords =  totalrecords +  1>
							</cfif>
                      </cfoutput>
                  <cfelse>
                  		<cfset  totalrecords =  get_product.query_count>
				  </cfif>
                          
                 </cfif> 
             </tbody>      
             <cfoutput>
                <input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#"> 
                <input type="hidden" name="employee" id="employee" value="#attributes.employee#">
                <input type="hidden" name="pos_code" id="pos_code" value="#attributes.pos_code#">
                <input type="hidden" name="product_cat" id="product_cat" value="#attributes.product_cat#">
                <input type="hidden" name="product_catid" id="product_catid" value="#attributes.product_catid#">
                <input type="hidden" name="get_company_id" id="get_company_id" value="#attributes.get_company_id#">
                <input type="hidden" name="get_company" id="get_company" value="#attributes.get_company#">
                <input type="hidden" name="is_active" id="is_active" value="#attributes.is_active#">
                <input type="hidden" name="window_status" id="window_status" value="0" />
            </cfoutput>
            </cf_grid_list>
    </form>
    <cfset url_str = "">
    <cfif isdefined("attributes.pos_code") and len(attributes.pos_code)>
        <cfset url_str = "#url_str#&pos_code=#attributes.pos_code#">
    </cfif>
    <cfif isdefined("attributes.employee") and len(attributes.employee)>
        <cfset url_str = "#url_str#&employee=#attributes.employee#">
    </cfif>
    <cfif len(attributes.brand_id)>
        <cfset url_str = "#url_str#&brand_id=#attributes.brand_id#">
    </cfif>
    <cfif isdefined("attributes.is_active") and len(attributes.is_active)>
        <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
    </cfif>
    <cfif isdefined("attributes.price_rec_date") and len(attributes.price_rec_date)>
        <cfset url_str = "#url_str#&price_rec_date=#attributes.price_rec_date#">
    </cfif>
    <cfif isdefined("attributes.product_name") and len(attributes.product_name)>
        <cfset url_str = "#url_str#&product_name=#attributes.product_name#">
    </cfif>
    <cfif isdefined("attributes.manufact_code") and len(attributes.manufact_code)>
        <cfset url_str = "#url_str#&manufact_code=#attributes.manufact_code#">
    </cfif>
    <cfif isdefined("attributes.get_company_id") and len(attributes.get_company_id)>
        <cfset url_str = "#url_str#&get_company_id=#attributes.get_company_id#">
    </cfif>
    <cfif isdefined("attributes.get_company") and len(attributes.get_company)>
        <cfset url_str = "#url_str#&get_company=#attributes.get_company#">
    </cfif>
    <cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
        <cfset url_str = "#url_str#&product_catid=#attributes.product_catid#">
    </cfif>
    <cfif isdefined("attributes.product_cat") and len(attributes.product_cat)>
        <cfset url_str = "#url_str#&product_cat=#attributes.product_cat#">
    </cfif>
    <cfif isdefined("attributes.referans_price_list") and len(attributes.referans_price_list)>
        <cfset url_str = "#url_str#&referans_price_list=#attributes.referans_price_list#">
    </cfif>
    <cfif isdefined("attributes.rec_date") and len(attributes.rec_date)>
        <cfset url_str = "#url_str#&rec_date=#attributes.rec_date#">
    </cfif>
    <cfif isdefined("attributes.spec") and len(attributes.spec)>
        <cfset url_str = "#url_str#&spec=#attributes.spec#">
    </cfif>
    <cfif isdefined("attributes.product_code") and len(attributes.product_code)>
        <cfset url_str = "#url_str#&product_code=#attributes.product_code#">
    </cfif>
    <cfif isdefined("attributes.is_price_list_product") and len(attributes.is_price_list_product)>
        <cfset url_str = "#url_str#&is_price_list_product=#attributes.is_price_list_product#">
    </cfif>
    <cfset url_str = "#url_str#&form_varmi=1">
    <cf_paging 
    name="deneme"
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.TOTALRECORDS#"
    startrow="#attributes.startrow#"
    adres="product.collacted_product_prices#url_str#">
</cfif>
</cf_box>
<cfif IsDefined("attributes.form_varmi") and get_product.recordcount gt 0>
<cf_box>    
    <cf_box_elements>        
    <cfif attributes.is_active neq -1 and attributes.is_active neq -2>
       <div class="form-group">
            <div class="input-group"><a href="javascript://" onclick="gizle_goster(allcat);" ><img src="/images/find.gif" border="0" align="absmiddle" style="display:;"></a>
            </div>
        </div>
    </cfif>
<div class="form-group" style="width:120;margin-top:5px;">
    <div class="input-group">
        <input type="text" name="start_date" id="start_date" placeholder="<cfoutput><cf_get_lang dictionary_id='57655.Başlama Tarihi'></cfoutput>" value="<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cfoutput>#attributes.start_date#</cfoutput></cfif>" maxlength="10" style="width:65px;"<cfif isdefined("attributes.start_date")and len (attributes.start_date)> onChange="change_date();"</cfif>><!--- required="yes"  validate="#validate_style#" message="#message#" --->
        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
        </div>
    </div>
            &nbsp;&nbsp;
            <div class="form-group">
        <cfoutput>
            <cfif isdefined("attributes.start_clock") and len(attributes.start_clock)>
                <cf_wrkTimeFormat process_cat_width='120;margin-top:5px;' name="start_clock" value="#attributes.start_clock#">
            <cfelse>
                <cf_wrkTimeFormat process_cat_width='120;margin-top:5px;' name="start_clock" value=""> 
            </cfif>
            &nbsp;&nbsp;
        </div><div class="form-group">
            <select style="width:120;margin-top:5px;" name="start_min" id="start_min" onchange="set_min(this.value);">
                <cfloop from="0" to="60" index="i" step="5">
                    <option value="#i#" <cfif isdefined("attributes.start_min") and len(attributes.start_min) and attributes.start_min eq i>selected</cfif>>#i#</option>
                </cfloop>
            </select>
        </cfoutput>
        &nbsp;&nbsp;
    </div><div class="form-group small">
          <!--- <cf_get_lang_main no="1447.Süreç"> surec var ancak burda sureci kaydetmiyoruz hic bir yere sadece surec dosyaları ile diger sirketlere v.s. fiyat kopyalama gibi islemler icin kullanılacak --->
    <cf_workcube_process 
    is_upd='0'
    process_cat_width='120;margin-top:5px;' 
    is_detail='0'>
</div>
    <cfif get_product.recordcount gt 1>
        <div class="form-group">
        <a  class=" ui-wrk-btn ui-wrk-btn-extra" onclick="select_all();"><i class="fa fa-check"></i> <cf_get_lang dictionary_id ='37814.Hepsini Seç'></a>
        </div> <div class="form-group">
            <a class=" ui-wrk-btn ui-wrk-btn-red" onclick="not_select_all();"><i class="fa fa-remove"></i> <cf_get_lang dictionary_id ='63620.Hepsini Boşalt'></a>
        </div> 
        </cfif>
    <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='58718.Düzenle'></cfsavecontent>
    <cfif xml_move_criterion eq 1>
        <div class="form-group">
        <a class="ui-btn ui-btn-update" style="width:120;margin-top:5px;margin-left:5px;cursor:pointer;"  onclick='gonder1(0)'><i class="fa fa-mail-forward"></i> <cf_get_lang dictionary_id ='63622.Düzenle ve Taşı'></a>
        </div>
        </cfif> 
    <div class="form-group">
    <a class="ui-wrk-btn ui-wrk-btn-success" onclick='gonder1(0)'><i class="fa fa-pencil"></i> <cfoutput>#alert#</cfoutput></a>
    </div> 
<cfif attributes.is_active neq -1 or attributes.is_active neq -2>
<table id="allcat" style="display:none;">
<cfparam name="attributes.mode" default="6">
<cfparam name="attributes.page" default=1>		
<cfset attributes.startrow=1>
<cfif get_price_cat.recordcount>
    <cfset attributes.maxrows_ = get_price_cat.recordcount>
    <cfoutput query="get_price_cat" startrow="#attributes.STARTROW#" maxrows="#attributes.MAXROWS_#">
        <cfif ((currentrow mod attributes.mode is 1)) or (currentrow eq 1)>
            <tr height="22">
        </cfif>
                <td><input name="price_cat_list" id="price_cat_list" type="checkbox" value="#price_catid#" <cfif (price_catid is attributes.is_active)>checked</cfif>>#price_cat#</td>
        <cfif ((currentrow mod attributes.mode is 0)) or (currentrow eq recordcount)>
            </tr>
        </cfif>
    </cfoutput>
    <tr>
        <td colspan="<cfoutput>#attributes.mode-1#</cfoutput>">&nbsp;</td>
        <td><input name="hepsi" id="hepsi" type="checkbox" value="1" onclick="check_all(this.checked);"><cf_get_lang dictionary_id='58081.Hepsi'></td>
    </tr>
    </tr>
<cfelse>
    <tr><td></td>
    </tr>
</cfif>
</table>
</cfif>

</cf_box_elements></cf_box>
</cfif>
<cfif isdefined("get_product")>
	<script type="text/javascript">
	function check_all(deger)
		{
			<cfif get_price_cat.recordcount gt 1>
				for(i=0; i<price_cat_list.length; i++)
					price_cat_list[i].checked = deger;
			<cfelseif get_price_cat.recordcount eq 1>
				price_cat_list.checked = deger;
			</cfif>
		}
		function hesapla_fiyat(k,deger,price_type)//price type güncellenek olan fiyatını nerden alacağını bulmak için eklendi,eğer price_type tanımlı geliyorsa referans fiyat listesindeki fiyat üzerinden hesaplama yapılacak.
		{
			purchase_price = eval('_ref_price_'+k);  
			tax_purchase_val = eval('tax_purchase_val'+k);
			purchase_price_with_tax = eval('purchase_price_with_tax'+k);
			sales_price = eval('sales_price'+k);
			tax_sales_val = eval('tax_sales_val'+k);
			sales_price_with_tax = eval('sales_price_with_tax'+k);
			kar_marj_degeri = eval('kar_marj_degeri'+k);
			
			sales_price_old = filterNum( eval('sales_price_old'+k).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			sales_price_with_tax_old = filterNum( eval('sales_price_with_tax_old'+k).value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			
			//Alanlar F1'den geçirilerek Javascript'in anlayacağı hale getiriliyor
			purchase_price.value = filterNum(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			tax_purchase_val.value = filterNum(tax_purchase_val.value);
			purchase_price_with_tax.value = filterNum(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			sales_price.value = filterNum(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			tax_sales_val.value = filterNum(tax_sales_val.value,0);
			sales_price_with_tax.value = filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
			kar_marj_degeri.value = filterNum(kar_marj_degeri.value);
				
			//Default Değerler Burada Yapılıyor
			sales_price_hesap_deger = sales_price.value;
			purchase_price_with_tax_hesap_deger = sales_price_with_tax.value;
			kar_m_deger = kar_marj_degeri.value;
			//Alanların 0'dan Farklılıkları Kontrol Ediliyor
			if(!purchase_price.value.length) purchase_price.value = 0;
			if(!tax_purchase_val.value.length) tax_purchase_val.value = 0;
			if(!purchase_price_with_tax.value.length) purchase_price_with_tax.value = 0;
			if(!sales_price.value.length) sales_price.value = 0;
			if(!tax_sales_val.value.length) tax_sales_val.value = 0;
			if(!sales_price_with_tax.value.length) sales_price_with_tax.value = 0; 
			if(!kar_marj_degeri.value.length) kar_marj_degeri.value = 0; 
			
			if(!sales_price_old.length) sales_price_old = 0; 
			if(!sales_price_with_tax_old.length) sales_price_with_tax_old = 0; 
			
			//İndirimlerin Eval İle k. Değerleri Hesaplanıyor
			discount_1_val = eval('discount_1_val'+k).value;
			discount_2_val = eval('discount_2_val'+k).value;
			discount_3_val = eval('discount_3_val'+k).value;
			discount_4_val = eval('discount_4_val'+k).value;
			discount_5_val = eval('discount_5_val'+k).value;
			
			//İndirimlerin 0'dan Farklılıkları Kontrol Ediliyor
			if(!discount_1_val.length) discount_1_val = 0;
			if(!discount_2_val.length) discount_2_val = 0;
			if(!discount_3_val.length) discount_3_val = 0;
			if(!discount_4_val.length) discount_4_val = 0;
			if(!discount_5_val.length) discount_5_val = 0;
			purchase_price_hesap_deger = parseFloat(purchase_price.value);
			purchase_price_hesap_deger = wrk_round(purchase_price_hesap_deger,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
			kdvsiz_net_alis = purchase_price_hesap_deger;//(purchase_price_hesap_deger*100)/(100+parseFloat(tax_purchase_val.value));
			//Alış Fiyatı Üzerinden İskontolu KDV'li Satış Fiyatı Hesaplanıyor
			if (deger==1)
			{ 					
				if (sales_price.value != 0 && purchase_price_with_tax.value != 0)
					{
						kar_m_deger = (((parseFloat(sales_price.value) - kdvsiz_net_alis )) / kdvsiz_net_alis)*100; //(sales_price.value / purchase_price_hesap_deger); 
						kar_m_deger = wrk_round(kar_m_deger);
					}
			}
				
			//Satış Fiyatı Üzerinden KDV'li Satış Fiyatı Hesaplanıyor
			if (deger==3)
			{ 
				if (sales_price_old.value != sales_price.value)
				{
					purchase_price_with_tax_hesap_deger = (parseFloat(sales_price.value) * (100 + parseFloat(tax_sales_val.value)))/100;
					purchase_price_with_tax_hesap_deger = wrk_round(purchase_price_with_tax_hesap_deger,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
					if (sales_price.value != 0 && purchase_price_with_tax.value != 0)
						{
							kar_m_deger = ((sales_price_hesap_deger - kdvsiz_net_alis) * 100) / kdvsiz_net_alis; //(sales_price.value / purchase_price_with_tax.value);
							kar_m_deger = wrk_round(kar_m_deger);
						}
				}
			}
			
			//KDV'li Satış Fiyatı Üzerinden Satış Fiyatı Hesaplanlıyor
			if(deger==4)
			{ 
				if (sales_price_with_tax_old.value != sales_price_with_tax.value)
				{
					sales_price_hesap_deger = (parseFloat(sales_price_with_tax.value)*100)/(100 + parseFloat(tax_sales_val.value)); 
					sales_price_hesap_deger = wrk_round(sales_price_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
					if (sales_price.value != 0 && purchase_price_with_tax.value != 0)
						{
						kar_m_deger = ((sales_price_hesap_deger - kdvsiz_net_alis) * 100) / kdvsiz_net_alis;
						kar_m_deger = wrk_round(kar_m_deger);
						}
				}
			}
			
			//Marj Üzerinden Satış Fiyatı Hesaplanlıyor
			if(deger==5)
			{
				sales_price_kdvsiz = (((kar_m_deger * kdvsiz_net_alis) / 100) + kdvsiz_net_alis);
				sales_price_hesap_deger = wrk_round(sales_price_kdvsiz*(100 + parseFloat(tax_sales_val.value))/100,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>); 

				purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				tax_purchase_val.value = commaSplit(tax_purchase_val.value);
				purchase_price_with_tax.value = commaSplit(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				sales_price.value = commaSplit(sales_price_kdvsiz,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				tax_sales_val.value = commaSplit(tax_sales_val.value,0);
				sales_price_with_tax.value = commaSplit(sales_price_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				kar_marj_degeri.value = commaSplit(kar_m_deger);
			}
			
			//Değerler F2 ve Commasplitten geçiriliyor
			if (deger==1){
				purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				tax_purchase_val.value = commaSplit(tax_purchase_val.value);
				purchase_price_with_tax.value = commaSplit(purchase_price_hesap_deger,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				sales_price.value = commaSplit(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				tax_sales_val.value = commaSplit(tax_sales_val.value,0);
				sales_price_with_tax.value = commaSplit(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				kar_marj_degeri.value = commaSplit(kar_m_deger);
			}
			
			//Degerler F2 ve CommaSplitten Geçiriliyor
			if (deger==3){
				purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				tax_purchase_val.value = commaSplit(tax_purchase_val.value);
				purchase_price_with_tax.value = commaSplit(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				sales_price.value = commaSplit(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				tax_sales_val.value = commaSplit(tax_sales_val.value,0);
				sales_price_with_tax.value = commaSplit(purchase_price_with_tax_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				kar_marj_degeri.value = commaSplit(kar_m_deger);
			}
							
			//Degerler F2 ve CommaSplitten Geçiriliyor
			if (deger==4){
				purchase_price.value = commaSplit(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				tax_purchase_val.value = commaSplit(tax_purchase_val.value);
				purchase_price_with_tax.value = commaSplit(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				sales_price.value = commaSplit(sales_price_hesap_deger,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				tax_sales_val.value = commaSplit(tax_sales_val.value,0);
				sales_price_with_tax.value = commaSplit(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				kar_marj_degeri.value = commaSplit(kar_m_deger);
			}
			//kar marjı sınırlarla ilişkisi anlaşılır
			min_margin = eval('min_margin'+k);
			max_margin = eval('max_margin'+k);
			//sayfa bozuk kontrol satiri <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
			if (kar_m_deger < 0)
				{
				kar_marj_degeri.style.color = 'Blue';
				//alert('Zarar Oranlı İşlem Yaptınız!');
				}
			else
				{
				if (kar_m_deger < min_margin.value)
					kar_marj_degeri.style.color = 'Red';
				else if (kar_m_deger > max_margin.value)
					kar_marj_degeri.style.color = 'Red';
				else
					kar_marj_degeri.style.color = 'Black';
				}
		}
		//Gonderme Esnasında Filter Num İle Temizlemeler Yapılıyor
		function gonder2()
		{
			<cfif newrecordcount gt 1>//get_product.recordcount
			for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)//get_product.recordcount
				{
					m = h - 1;
					if (eval('is_record_active['+m+'].checked') == true)
						{
						n = product_id[m].value;
						purchase_price=eval('purchase_price'+n);
						tax_purchase_val=eval('tax_purchase_val'+n);
						purchase_price_with_tax=eval('purchase_price_with_tax'+n);
						sales_price=eval('sales_price'+n);
						tax_sales_val=eval('tax_sales_val'+n);
						sales_price_with_tax=eval('sales_price_with_tax'+n);
						
						purchase_price.value = filterNum(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
						tax_purchase_val.value = filterNum(tax_purchase_val.value);
						purchase_price_with_tax.value = filterNum(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
						sales_price.value = filterNum(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
						tax_sales_val.value = filterNum(tax_sales_val.value,0);
						sales_price_with_tax.value = filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
						}
				}
			<cfelse>
			if (is_record_active.checked == true)
				{
				n = product_id.value;
				purchase_price=eval('purchase_price'+n);
				tax_purchase_val=eval('tax_purchase_val'+n);
				purchase_price_with_tax=eval('purchase_price_with_tax'+n);
				sales_price=eval('sales_price'+n);
				tax_sales_val=eval('tax_sales_val'+n);
				sales_price_with_tax=eval('sales_price_with_tax'+n);
				
				purchase_price.value = filterNum(purchase_price.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				tax_purchase_val.value = filterNum(tax_purchase_val.value);
				purchase_price_with_tax.value = filterNum(purchase_price_with_tax.value,<cfoutput>#session.ep.our_company_info.purchase_price_round_num#</cfoutput>);
				sales_price.value = filterNum(sales_price.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				tax_sales_val.value = filterNum(tax_sales_val.value,0);
				sales_price_with_tax.value = filterNum(sales_price_with_tax.value,<cfoutput>#session.ep.our_company_info.sales_price_round_num#</cfoutput>);
				}
			</cfif>
            var list_price='';
            $('input[name="price_cat_list"]').each(function() {    
                if ($(this).is(':checked')){list_price+=$(this).val()+','}    
            });
            if(list_price!=''){list_price=list_price.substring(0, list_price.length - 1);}
            form_add_product_property.action="<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopupflush_add_collacted_product_prices_amount&start_date="+start_date.value+"&start_clock="+start_clock.value+"&start_min="+start_min.value+"&process_stage="+process_stage.value+"&price_cat_list="+list_price+"&spec="+search_product.spec.value;
           $("#form_add_product_property").submit();
		}
		function select_all()
		{
		for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)
			{
				m = h - 1;
				var check = eval('is_record_active['+m+']');
				
				check.checked = true;
			
			}
		}
		function not_select_all()
		{
		for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)
			{
				m = h - 1;
				var check = eval('is_record_active['+m+']');
				
				check.checked = false;
			
			}
		}
		function uygula_marj(deger)
		{
			<cfloop list="#product_id_list#" index="pid">
				eval('kar_marj_degeri'+<cfoutput>#pid#</cfoutput>).value = commaSplit(deger);
				hesapla_fiyat(<cfoutput>#pid#</cfoutput>,5,'ref_price');//5'in anlamı marj üzerinden fiyatlama yapıldığını gösteriyor.3.cü gönderilen değerde fiyatın referans fiyat listesi üzerinden hesaplanacağını gösteriyor.
			</cfloop>
		}
		function gonder1(no)
		{
		  document.getElementById('window_status').value=no;
			if(process_cat_control()==false)
				return false;
			flag = 0;
			<cfif newrecordcount gt 1>//get_product.recordcount
			for (h=1; h <= <cfoutput>#newrecordcount#</cfoutput>; h++)//get_product.recordcount
				{
					m = h - 1;
					if (eval('is_record_active['+m+'].checked') == true)
					{
						flag = 1;
						break;
					}
				}
			<cfelse>
				if (is_record_active.checked == true)
					flag = 1;
			</cfif>
			if (flag == 0)
				{
				alert("<cf_get_lang dictionary_id ='37815.En az 1 ürün seçmelisiniz'> !");
				return false;
				}
			<cfif attributes.is_active neq -1 and attributes.is_active neq -2> 
			else if
			(
			<cfif get_price_cat.recordcount gt 1>
				<cfoutput query="get_price_cat">
				price_cat_list[#currentrow-1#].checked == false
				<cfif get_price_cat.currentrow neq get_price_cat.recordcount>&&</cfif>
				</cfoutput>
			<cfelseif get_price_cat.recordcount eq 1>
				price_cat_list.checked == false
			</cfif>
			)
			{
				window.alert("<cf_get_lang dictionary_id='37346.En az bir liste seçmelisiniz'>!");
				return false;		
			}
			</cfif>
			else
				{
					if(!CheckEurodate(start_date.value,"<cf_get_lang dictionary_id ='57655.Başlama Tarihi'>") || !start_date.value.length) 
						{
							alert("<cf_get_lang dictionary_id ='58745.Başlama Tarihi girmelisiniz'> !");
							return false;
						}
					return gonder2();
				}
		}
		disablePRecDate();
	</script>
	<script type="text/javascript">
		function all_money_unit(money_unit)
		{	
			<cfif get_product.recordcount>
				<cfoutput query="get_product">
				document.getElementById('sales_money#stock_id#').value = money_unit;
				 </cfoutput>
			</cfif>
		}  
	
		function all_is_tax_included()
		{	
			<cfif get_product.recordcount>
				<cfoutput query="get_product">
				if(is_tax_included.checked==true)
					document.getElementById('is_tax_included#stock_id#').checked=true;
				else
					document.getElementById('is_tax_included#stock_id#').checked=false;					
				</cfoutput>
			</cfif>
		}  
	</script>
</cfif>
<cfsetting showdebugoutput="yes">
