<!---
    File: product_catalog.cfm
    Folder: V16\report\standart\
	Controller: 
    Author:
    Date:
    Description:
        
    History:
		2019-12-31 00:09:25 Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com
		Ürünler fiyat tablosu ile stock_id ye göre join yapıldı.
    To Do:

--->

<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.colnumber" default="4">
<cfparam name="attributes.rownumber" default="12">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.image_size" default="0">
<cfparam name="attributes.image_width" default="120">
<cfparam name="attributes.image_height" default="160">
<cfparam name="attributes.image_pay" default="0">
<cfparam name="attributes.area_width" default="200">
<cfparam name="attributes.area_height" default="300">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.price_catid" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.brand_name" default="">
<cfparam name="attributes.property_number" default="5">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset myImage = CreateObject("Component", "V16.report.cfc.iedit")>
<cfquery name="PRICE_CATS" datasource="#DSN3#">
	SELECT PRICE_CATID, PRICE_CAT FROM PRICE_CAT ORDER BY PRICE_CAT
</cfquery>
<cfquery name="GET_PROPERTY" datasource="#DSN1#">
	SELECT DISTINCT
		PP.PROPERTY,
		PP.PROPERTY_ID
	FROM 
		PRODUCT_PROPERTY PP,
		PRODUCT_PROPERTY_OUR_COMPANY PPO
	WHERE
		PP.PROPERTY_ID = PPO.PROPERTY_ID AND
		PPO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PP.IS_INTERNET = 1 AND
		PP.IS_ACTIVE = 1
</cfquery>
<cfif get_property.recordcount>
	<cfinclude template="../../objects/functions/barcode.cfm">
</cfif>
<cfquery name="GET_ALL_PROPERTY_DETAIL" datasource="#DSN1#">
	SELECT
		PRPT_ID,
		PROPERTY_DETAIL_ID,
		PROPERTY_DETAIL
	FROM
		PRODUCT_PROPERTY_DETAIL
</cfquery>

<!-- sil --> <cfsavecontent variable="title"><cf_get_lang dictionary_id='38946.Ürün Kataloğu'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#title#">
		<cfform name="search_product_property" method="post" action="#request.self#?fuseaction=report.product_catalog">	
			<input type="hidden" name="form_varmi" id="form_varmi" value="1">
			<cf_box_search>
				<div class="col col-3 col-md-3 col-sm-3 col-xs-12" index="1" type="column" sort="true">
					<cf_box_elements vertical="1">
						<div class="form-group">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="cat" id="cat" value="<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)><cfoutput>#attributes.cat#</cfoutput></cfif>">
									<input type="text" name="category_name" id="category_name" style="width:150px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','cat','','3','200');" value="<cfif isdefined("attributes.cat") and len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=search_product_property.cat&field_name=search_product_property.category_name</cfoutput>');"></span>
								</div>
							</div>	
						</div>
						<div class="form-group">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_wrkproductbrand
										width="150"
										compenent_name="getProductBrand"               
										boxwidth="240"
										boxheight="150"
										brand_id="#attributes.brand_id#">
							</div>		
						</div>		
						<div class="form-group">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57460.Filtre'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:150px;">
							</div>		
						</div>		
						<div class="form-group">
							<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="price_catid" id="price_catid" style="width:150px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="price_cats">
										<cfoutput><option value="#price_catid#" <cfif price_cats.price_catid is attributes.price_catid> selected</cfif>>#price_cat#</option></cfoutput>
									</cfloop>
								</select>
							</div>		
						</div>
					</cf_box_elements>	
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="2" type="column" sort="true">
					<cf_seperator title="#getlang('','Elementler',875)#" id="detail_seperator">
						<div id="detail_seperator">	
					<cf_box_elements >
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" >
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_name" id="is_product_name" value="1" <cfif isdefined("attributes.is_product_name")>checked</cfif>><cf_get_lang dictionary_id='58221.Ürün Adı'>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_cat" id="is_product_cat" value="1" <cfif isdefined("attributes.is_product_cat") and len("attributes.is_product_cat")>checked</cfif>><cf_get_lang dictionary_id='29401.Ürün Kategorisi'>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_detail" id="is_product_detail" value="1" <cfif isdefined("attributes.is_product_detail")>checked</cfif>><cf_get_lang dictionary_id='34281.Ürün Açıklaması'>
							</label>
						</div>
							<div class="form-group">
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_detail2" id="is_product_detail2" value="1" <cfif isdefined("attributes.is_product_detail2")>checked</cfif>><cf_get_lang dictionary_id='39084.Ürün Açıklaması 2'>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_price" id="is_product_price" value="1" <cfif isdefined("attributes.is_product_price")>checked</cfif>><cf_get_lang dictionary_id='58778.Ürün Fiyatı'>
							</label>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" >
							<div class="form-group">
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_property" id="is_product_property" value="1" <cfif isdefined("attributes.is_product_property")>checked</cfif>><cf_get_lang dictionary_id='40146.Ürün Özellikleri'>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_image" id="is_product_image"  onClick="gizle_goster(is_excel_show)"; value="1" <cfif isdefined("attributes.is_product_image")>checked</cfif>><cf_get_lang dictionary_id='39090.Ürün İmajı'>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_product_barcod" id="is_product_barcod" value="1" <cfif isdefined("attributes.is_product_barcod")>checked</cfif>><cf_get_lang dictionary_id='39093.Ürün Barkodu'>
							</label>
						</div>
						<div class="form-group">
							<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_real_stock" id="is_real_stock" value="1" <cfif isdefined("attributes.is_real_stock")>checked</cfif>><cf_get_lang dictionary_id='40223.Sıfır Stok Getirme'>
							</label>
						</div>
							<div class="form-group">
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12">
								<input type="checkbox" name="is_session_money" id="is_session_money" value="1" <cfif isdefined("attributes.is_session_money")>checked</cfif>><cfoutput>#session.ep.money#&nbsp;</cfoutput><cf_get_lang dictionary_id='58084.Fiyat'>
							</label>
						</div>
					</div>
				</div>
					</cf_box_elements>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12"  index="3" type="column" sort="true">
					<cf_seperator title="#getlang('','Ölçü ve Tasarım',62394)#" id="detail_seperator">
					<cf_box_elements >
						<div id="detail_seperator">	
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<div class="form-group" id="item-rownumber">
									<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='58508.Satır'></label>
									<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
										<select name="rownumber" id="rownumber" >
											<option value="1" <cfif attributes.rownumber eq 1>selected </cfif>>1</option>
											<option value="2" <cfif attributes.rownumber eq 2>selected </cfif>>2</option>
											<option value="3" <cfif attributes.rownumber eq 3>selected </cfif>>3</option>
											<option value="4" <cfif attributes.rownumber eq 4>selected </cfif>>4</option>
											<option value="5" <cfif attributes.rownumber eq 5>selected </cfif>>5</option>
											<option value="6" <cfif attributes.rownumber eq 6>selected </cfif>>6</option>
											<option value="8" <cfif attributes.rownumber eq 8>selected </cfif>>8</option>
											<option value="9" <cfif attributes.rownumber eq 9>selected </cfif>>9</option>
											<option value="10" <cfif attributes.rownumber eq 10>selected </cfif>>10</option>
											<option value="12" <cfif attributes.rownumber eq 12>selected</cfif>>12</option>
											<option value="15" <cfif attributes.rownumber eq 15>selected</cfif>>15</option>
										</select>	
									</div>
								</div>
								<div class="form-group" id="item-colnumber">
									<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id='57695.KOLON'></label>
									<div class="col col-7 col-md-7 col-sm-7 col-xs-12">									
										<select name="colnumber" id="colnumber">
											<option value="1" <cfif attributes.colnumber eq 1>selected</cfif>>1</option>
											<option value="2" <cfif attributes.colnumber eq 2>selected</cfif>>2</option>
											<option value="3" <cfif attributes.colnumber eq 3>selected</cfif>>3</option>
											<option value="4" <cfif attributes.colnumber eq 4>selected</cfif>>4</option>
											<option value="5" <cfif attributes.colnumber eq 5>selected</cfif>>5</option>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-image_size">
									<label class="col col-5 col-md-5 col-sm-5 col-xs-12"><cf_get_lang dictionary_id="29762.İmaj"></label>
									<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
										<select name="image_size" id="image_size" style="width:80px;">
											<option value="0" <cfif attributes.image_size eq 0>selected</cfif>><cf_get_lang dictionary_id ='57927.Küçük'></option>
											<option value="1" <cfif attributes.image_size eq 1>selected</cfif>><cf_get_lang dictionary_id ='57928.Orta'></option>
											<option value="2" <cfif attributes.image_size eq 2>selected</cfif>><cf_get_lang dictionary_id ='57929.Büyük'></option>
										</select>
									</div>
								</div>
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
								<div class="form-group" id="item-area_width">
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfsavecontent variable="genislik"><cf_get_lang dictionary_id ='40532.Genişlik Sayısal Olmalıdır'></cfsavecontent>
										<cfinput type="text" name="area_width" id="area_width" message="#genislik#" value="#attributes.area_width#" validate="integer" >
									</div>
									<label class="col col-2 col-xs-2">&nbsp;px.</label>
								</div>
								<div class="form-group" id="item-area_height" >
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<cfsavecontent variable="yukseklik"><cf_get_lang dictionary_id ='48583.Yükseklik Sayısal Olmalıdır'></cfsavecontent>
										<td width="80"><cfinput type="text" name="area_height" id="area_height" message="#yukseklik#" value="#attributes.area_height#" validate="integer" ></td>
									</div>
									<label class="col col-2 col-xs-2">&nbsp;px.</label>
								</div>
								<div class="form-group"id="item-image_pay" >
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12" >
										<cfsavecontent variable="duzenleme"><cf_get_lang dictionary_id='60008.Düzenleme Rakamı Girmelisiniz'> !</cfsavecontent>
										<cfinput type="text" name="image_pay" id="image_pay" message="#duzenleme#" value="#attributes.image_pay#" required="yes" validate="integer" style="width:35px;">
									</div>
									<label class="col col-2 col-xs-2">&nbsp;px.</label>
								</div>
							</div>
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" >
								<div class="form-group"id="item-image_width">
									<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='57695.Genişlik'></label>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<cfsavecontent variable="genislik"><cf_get_lang dictionary_id ='40532.Genişlik Sayısal Olmalıdır'></cfsavecontent>
										<cfinput type="text" name="image_width" id="image_width" message="#genislik#" value="#attributes.image_width#" validate="integer" >
									</div>	
									<label class="col col-1 col-xs-1">&nbsp;px.</label>
								</div>
								<div class="form-group" id="item-image_height">
									<label class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id ='57696.Yükseklik'></label>
									<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
										<cfsavecontent variable="yukseklik"><cf_get_lang dictionary_id ='48583.Yükseklik Sayısal Olmalıdır'></cfsavecontent>
										<cfinput type="text" name="image_height" id="image_height" message="#yukseklik#" value="#attributes.image_height#" validate="integer" >
									</div>
									<label class="col col-1 col-xs-1">&nbsp;px.</label>
								</div>
							</div>
						</div>
					</cf_box_elements>
				</div>
				<div class="row ReportContentBorder">
					<div class="ReportContentFooter">
						<label id="is_excel_show"><input type="checkbox" name="is_excel" id="is_excel" value="1" s<cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58938.Ürün Özellik Sayısı Boş Olmalıdır!'></cfsavecontent>
						<!--- <cfinput type="text" name="property_number" id="property_number" value="#attributes.property_number#"  style="display:none;width:25px;" onkeyup="isNumber(this);" message="#message#" required="yes"> ---> <!--- burdaki maxrow ürün özelliklerini etkilediği için gerek olmadığından dolayı kaldırıldı. ---> 
						<cf_wrk_report_search_button search_function='control()' button_type='1' is_excel='1'>					
					</div>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
</div>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
	SELECT 
		S.PRODUCT_ID,
		S.BARCOD,
		S.PRODUCT_NAME,
		S.PRODUCT_DETAIL,
		S.PRODUCT_DETAIL2,
		PC.PRODUCT_CAT,
		PI.PATH,
		PI.PATH_SERVER_ID,
		PP.PRODUCT_ID,
		<cfif isdefined("attributes.is_session_money") and attributes.is_session_money eq 1>
			ISNULL((SELECT TOP 1 (RATE2*PRICE_KDV) FROM #dsn_alias#.MONEY_HISTORY WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_HISTORY.MONEY = PP.MONEY ORDER BY VALIDATE_DATE DESC),PRICE_KDV) LIST_PRICE,
			'#session.ep.money#' LIST_MONEY
		<cfelse>
			PP.PRICE_KDV AS LIST_PRICE,
			PP.MONEY AS LIST_MONEY
		</cfif>
	FROM 
		STOCKS S
		<cfif len(attributes.price_catid)>
			LEFT JOIN PRICE PP ON S.STOCK_ID = PP.STOCK_ID
		<cfelse>
			LEFT JOIN PRICE_STANDART PP ON S.PRODUCT_ID = PP.PRODUCT_ID
		</cfif>
		LEFT JOIN PRODUCT_IMAGES PI ON S.PRODUCT_ID = PI.PRODUCT_ID,
		PRODUCT_CAT PC
	WHERE
		<cfif len(attributes.price_catid)>
			((ISNULL(PP.STOCK_ID,0) = S.STOCK_ID AND PP.STOCK_ID IS NOT NULL) OR (ISNULL(PP.STOCK_ID,0) = 0 AND PP.STOCK_ID IS NULL))
			AND ISNULL(SPECT_VAR_ID,0)=0
			AND PP.PRICE_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.price_catid#"> 
			AND PP.STARTDATE <= #now()# 
			AND (PP.FINISHDATE >= #now()# OR PP.FINISHDATE IS NULL) AND
		<cfelse>
			PP.PRICESTANDART_STATUS = 1
			AND PP.PURCHASESALES = 1 AND
		</cfif>
		<cfif isdefined("is_real_stock")>
			S.PRODUCT_ID NOT IN 
			(
				SELECT
					GPS.PRODUCT_ID PRODUCT_ID
				FROM
					#dsn2_alias#.GET_PRODUCT_STOCK GPS
				WHERE
					GPS.PRODUCT_TOTAL_STOCK <= 0 AND
					GPS.PRODUCT_ID = PP.PRODUCT_ID
					
			) AND
		</cfif>
		<cfif isdefined("attributes.list_property_id") and len(attributes.list_property_id)>
			S.PRODUCT_ID IN
			(
				SELECT
					PRODUCT_ID
				FROM
					#dsn1_alias#.PRODUCT_DT_PROPERTIES PRODUCT_DT_PROPERTIES
				WHERE
					(
						<cfloop from="1" to="#listlen(attributes.list_property_id,',')#" index="pro_ind">
						(PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_property_id,pro_ind,",")#"> AND VARIATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.list_variation_id,pro_ind,",")#">)
						<cfif pro_ind lt listlen(attributes.list_property_id,',')>OR</cfif>
						</cfloop>
					)
				GROUP BY
					PRODUCT_ID
				HAVING
					COUNT(PRODUCT_ID)> = #listlen(attributes.list_property_id,',')#
			) AND
		</cfif>
		<cfif isdefined("attributes.cat") and len(attributes.cat) and len(attributes.category_name)>
			(PC.HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#.%"> OR PC.HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.cat#">) AND
		</cfif>
		<cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and len(attributes.brand_name)>
			S.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
		</cfif>
		S.PRODUCT_STATUS = 1 AND
		<cfif isdefined("attributes.is_product_image") and len(attributes.is_product_image)>
			PI.IMAGE_SIZE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.image_size#"> AND
		</cfif>
		S.PRODUCT_CATID = PC.PRODUCT_CATID
		<cfif len(attributes.keyword)>
			AND S.PRODUCT_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
		</cfif>
		<cfif isdefined("attributes.is_product_image") and len(attributes.is_product_image)>
			GROUP BY 
				S.PRODUCT_ID
				,S.BARCOD
				,S.PRODUCT_NAME
				,S.PRODUCT_DETAIL
				,S.PRODUCT_DETAIL2
				,PC.PRODUCT_CAT
				,PI.PATH
				,PI.PATH_SERVER_ID
				,PI.IMAGE_SIZE
				,PP.PRODUCT_ID
				,PP.PRICE_KDV
				,PP.MONEY 
		</cfif>
	ORDER BY
		S.PRODUCT_NAME
</cfquery>
<cfif get_products.recordcount>			
	<cfif len(attributes.image_width) and isnumeric(attributes.image_width)>
		<cfset image_width_ = attributes.image_width>
	<cfelse>
		<cfset image_width_ = 220>
	</cfif>
	<cfif len(attributes.image_height) and isnumeric(attributes.image_height)>
		<cfset image_height_ = attributes.image_height>
	<cfelse>
		<cfset image_height_ = 160>
	</cfif>
	<cfset page_height = 275>
	<cfset page_width = 250>
	<cfif isdefined("get_products") and get_products.recordcount>
		<cfloop query="get_products">
			<cfscript>
				'list_price_#product_id#' = '#list_price#,#list_money#';
			</cfscript>
		</cfloop>
	</cfif>
<cfoutput query="get_products">
	<cfif isdefined("is_product_property")>
		
				<cfquery name="GET_PROPERTY_ROW" datasource="#DSN1#">
					SELECT 
						PRODUCT_DT_PROPERTIES.VARIATION_ID,
						PRODUCT_DT_PROPERTIES.DETAIL,
						PRODUCT_DT_PROPERTIES.LINE_VALUE,
						PRODUCT_DT_PROPERTIES.TOTAL_MIN,
						PRODUCT_DT_PROPERTIES.TOTAL_MAX,
						PRODUCT_DT_PROPERTIES.AMOUNT,
						PRODUCT_DT_PROPERTIES.IS_OPTIONAL,
						PRODUCT_DT_PROPERTIES.IS_EXIT,
						PRODUCT_DT_PROPERTIES.IS_INTERNET,
						PRODUCT_DT_PROPERTIES.RECORD_DATE,
						PRODUCT_DT_PROPERTIES.RECORD_EMP,
						PRODUCT_PROPERTY.PROPERTY,
						PRODUCT_PROPERTY.PROPERTY_ID,
						PRODUCT_DT_PROPERTIES.PRODUCT_ID
					FROM 
						PRODUCT_DT_PROPERTIES,
						PRODUCT_PROPERTY
					WHERE 
						PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#product_id#"> AND
						PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID
					ORDER BY
						PRODUCT_DT_PROPERTIES.PRODUCT_ID
				</cfquery>
		
		
	</cfif>
</cfoutput>
		<!--- <cfif currentrow eq 1 or (currentrow mod attributes.rownumber is 1)>
			<table border="0" cellspacing="0" cellpadding="2" align="center" style="height:#page_height#mm;width:#page_width#mm;" id="ilk_table">
		</cfif> --->
		<!--- <cfif currentrow eq 1 or (currentrow mod attributes.colnumber eq 1)><tr height="#100/(attributes.rownumber/attributes.colnumber)#%"></cfif>
			<td width="#100/attributes.colnumber#%" valign="top" id="alan_#currentrow#" height="#100/(attributes.rownumber/attributes.colnumber)#%">
				<cfsavecontent variable="ic_icerik"> --->
				<!--- <table border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td style="width:#image_width_#px;height:#image_height_#px;">
							<cfif isdefined("attributes.is_product_image")>
								<cfif len(path) and listlen(path,'.') gt 1 and listfindnocase('png,jpg,jpeg,bmp,gif',listlast(path,'.'))>
									<cftry>
										<cfset myImage.SelectImage("#upload_folder#product#dir_seperator##path#")>
										<cfset rg = myImage.getWidth()>
										<cfset ry = myImage.getHeight()>
										<cfcatch type="any">
											<cfset rg = image_width_>
											<cfset ry = image_height_>
										</cfcatch>
									</cftry>
									<cfset ag = image_width_>
									<cfset ay = image_height_>
									<cfif ry lte ay and rg lte ag>
										<cfset x_ = 0>
										<cfset y_ = 0>
									<cfelseif ry lte ay and rg gt ag>
										<cfset x_ = (rg-ag) / 2>
										<cfset y_ = 0>
									<cfelseif ry gt ay and rg lte ag>
										<cfset x_ = 0>
										<cfset y_ = (ry-ay) / 2>
									<cfelseif ry gt ay and rg gt ag>
										<cfset x_ = (rg-ag) / 2>
										<cfset y_ = (ry-ay) / 2>
									</cfif>
									
									<cfif x_ eq 0>
										<cfif ag gt rg>
											<cfset x_ = -1 * (ag - rg) / 2>
										</cfif>
									</cfif>
									<cfif attributes.image_pay neq 0>
										<cfset y_ = y_  - attributes.image_pay>
									</cfif>
								
										<table cellpadding="0" cellspacing="0">
											<tr>
												<td style="height:#image_height_#px;width:#image_width_#px;">&nbsp;</td>
											</tr>
										</table>
									</div>
								</cfif>
							</cfif>
						</td>
					</tr>
				</table>
				<br/> --->
				
						<!--- <table border="0" cellspacing="0" cellpadding="0" align="center">
							<tr class="property">
								<td> --->
	<!--- <cfquery name="GET_VARIATION_ROW" datasource="#DSN1#">
	SELECT PROPERTY_DETAIL_ID, PROPERTY_DETAIL,PRODUCT_DT_PROPERTIES.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL ,PRODUCT_DT_PROPERTIES WHERE PRPT_ID = PRODUCT_DT_PROPERTIES.PROPERTY_ID
</cfquery> --->
<cfsavecontent variable="title"><cf_get_lang dictionary_id='38946.Ürün Kataloğu'></cfsavecontent>					
<div id="item_2" class="col col-12 col-md-12 col-sm-12 col-xs-12 ">
	<cf_box  title="#title#"uidrop="1" scroll="1"   <!--- woc_setting = "#{ checkbox_name : 'print_product_id', print_type : 399 }#"  --->>
		<cfif isdefined("attributes.form_varmi")>	
			<cfloop query="get_products">
				<cfoutput>
					<div  class="col col-3 col-md-3 col-sm-3 col-xs-12 padding-10">
						<div class="ui-cards">
							<div class="ui-cards-img" style=";width:100%;" >
								<td style="width:120px;height:200px;">
									<cfif isDefined("attributes.is_product_image") and   len("attributes.is_product_image")>
										<cfif len(path) and listlen(path,'.') gt 1 and listfindnocase('png,jpg,jpeg,bmp,gif',listlast(path,'.'))>
											<cftry>
												<cfset myImage.SelectImage("#upload_folder#product#dir_seperator##path#")>
												<cfset rg = myImage.getWidth()>
												<cfset ry = myImage.getHeight()>
												<cfcatch type="any">
													<cfset rg = image_width_>
													<cfset ry = image_height_>
												</cfcatch>
											</cftry>
											<cfset ag = image_width_>
											<cfset ay = image_height_>
											<cfif ry lte ay and rg lte ag>
												<cfset x_ = 0>
												<cfset y_ = 0>
											<cfelseif ry lte ay and rg gt ag>
												<cfset x_ = (rg-ag) / 2>
												<cfset y_ = 0>
											<cfelseif ry gt ay and rg lte ag>
												<cfset x_ = 0>
												<cfset y_ = (ry-ay) / 2>
											<cfelseif ry gt ay and rg gt ag>
												<cfset x_ = (rg-ag) / 2>
												<cfset y_ = (ry-ay) / 2>
											</cfif>
											
											<cfif x_ eq 0>
												<cfif ag gt rg>
													<cfset x_ = -1 * (ag - rg) / 2>
												</cfif>
											</cfif>
											<cfif attributes.image_pay neq 0>
												<cfset y_ = y_  - attributes.image_pay>
											</cfif>
											<!--- <div id="image_#product_id#" style="z-index:9999;overflow:hidden;background-position:center;/* height:200px;width:225px;; */background-image:url(http://#cgi.http_host#/documents/product/#path#);">
												<table cellpadding="0" cellspacing="0">
													<tr>
														<td style="height:200px;width:#image_width_#px;">&nbsp;</td>
													</tr>
												</table>
											</div> --->
											<img src="#file_web_path#product/#path#">
										</cfif>
									</cfif>
								</td>
								<cfset attributes.barcod = get_products.barcod>
									<cfset GraphicFile = "#upload_folder#barcode#dir_seperator##attributes.barcod#.jpg">
									<cftry>
									<cfif not FileExists(GraphicFile)>
										<cfif get_product_unit.add_unit neq "kg">
											<cfif (len(attributes.barcod) eq 13) or (len(attributes.barcod) eq 12)>
												<cf_workcube_barcode type="ean13" show="1" value="#attributes.barcod#">
											<cfelseif (len(attributes.barcod) eq 8) or (len(attributes.barcod) eq 7)>
												<cf_workcube_barcode type="ean8" show="1" value="#attributes.barcod#">
											<cfelseif (len(attributes.barcod) eq 9)>
												<cfset attributes.barcod = attributes.barcod & '000'>
												<cf_workcube_barcode type="ean13" show="1" value="#attributes.barcod#">
											<cfelseif (len(attributes.barcod) eq 10)>
												<cfset attributes.barcod = attributes.barcod & '00'>
												<cf_workcube_barcode type="ean13" show="1" value="#attributes.barcod#">
											<cfelseif (len(attributes.barcod) eq 11)>
												<cfset attributes.barcod = attributes.barcod & '0'>
												<cf_workcube_barcode type="ean13" show="1" value="#attributes.barcod#">
											</cfif>
										<cfelseif len(get_products.barcod) eq 7>
											<cfset attributes.barcod = attributes.barcod & '010000'>
											<cf_workcube_barcode type="ean13" show="1" value="#attributes.barcod#">
										</cfif>
									</cfif>	
									
									<cfif FileExists(GraphicFile)><img src="/documents/barcode/#replace(GraphicFile,'#upload_folder#barcode#dir_seperator#','','all')#"></cfif>
									<cfcatch type="any"></cfcatch>
									</cftry>
							</div>
							<div class="ui-cards-text" style="height:220px" >
								<cfif isdefined("attributes.is_product_name") and len("attributes.is_product_name")  >
									
									<p class="headbold">#get_products.product_name#</p>
								</cfif>
								<cfif isdefined("attributes.is_product_cat")>
									<p>#get_products.product_cat#</p>
								
								</cfif>
								<cfif isdefined("attributes.is_product_detail") and len("attributes.is_product_detail")  >
										<p>#get_products.product_detail#</p>
								
								</cfif>
								<cfif isdefined("attributes.is_product_detail2") and len("attributes.is_product_detail2") >
										<p>#get_products.product_detail2#</p>
								
									</cfif>
								<cfif isdefined("attributes.is_product_barcod") and len("attributes.is_product_barcod")  >
									<p>#get_products.barcod#</p>
							
								</cfif>
								<cfquery name="GET_PROPERTY" datasource="#DSN1#">
									SELECT
										PDP.VARIATION_ID,
										PDP.DETAIL,
										PDP.IS_EXIT,
										PDP.TOTAL_MIN,
										PDP.TOTAL_MAX,
										PDP.AMOUNT,
										PDP.RECORD_DATE,
										PDP.RECORD_EMP,
										PDP.UPDATE_EMP,
										PDP.UPDATE_DATE,
										PDP.IS_OPTIONAL,
										PDP.IS_INTERNET,
										PDP.LINE_VALUE,
										PDP.PROPERTY_ID,
										PP.PROPERTY,
										PR.PRODUCT_ID,
										PP.PROPERTY,
										PPD.PRPT_ID,
										PPD.PROPERTY_DETAIL_ID, 
										PPD.PROPERTY_DETAIL
									FROM
										PRODUCT_DT_PROPERTIES PDP
										LEFT JOIN PRODUCT_PROPERTY PP ON PP.PROPERTY_ID =PDP.PROPERTY_ID 
										LEFT JOIN PRODUCT PR ON  PR.PRODUCT_ID= PDP.PRODUCT_ID
										LEFT JOIN PRODUCT_PROPERTY_DETAIL PPD ON PPD.PROPERTY_DETAIL_ID = PDP.VARIATION_ID 
									WHERE 
									PDP.PRODUCT_ID = #get_products.product_id#	
								</cfquery>
								<cfif isdefined("attributes.is_product_property") >
									<p>#GET_PROPERTY.PROPERTY#
										<cfif len("GET_PROPERTY.PROPERTY_DETAIL")>
											#GET_PROPERTY.PROPERTY_DETAIL#
										</cfif>
									</p>
								</cfif>
								<cfif isdefined("is_product_price") and isdefined('list_price_#product_id#')>
									<p>
										#TLFormat(listgetat(Evaluate('list_price_#product_id#'),1,','),2)#&nbsp;
										#listgetat(Evaluate('list_price_#product_id#'),2,',')#
									</p>
								</cfif>
								<!--- <td class="text-center"><input type="checkbox" name="print_product_id" id="print_product_id" value="#product_id#"></td> ---> 
							</div>
						</div>
					</div>
				</cfoutput>
			</cfloop>
		<cfelse>
		<cf_get_lang dictionary_id='57484.Kayıt Yok'>!
		</cfif>
	</div>
	</cf_box>
</cfif>				
</div>			

<script type="text/javascript">
	row_count=<cfoutput>#get_property.recordcount#</cfoutput>;
	function control()
    {  
		if(document.getElementById('is_product_name').checked==false && document.getElementById('is_product_cat').checked==false && document.getElementById('is_product_detail').checked==false && document.getElementById('is_product_detail2').checked==false && document.getElementById('is_product_price').checked== false && document.getElementById('is_product_property').checked==false && document.getElementById('is_product_image').checked==false && document.getElementById('is_product_barcod').checked==false && document.getElementById('is_real_stock').checked==false && document.getElementById('is_session_money').checked==false)
		{
			alert("<cf_get_lang dictionary_id='44680.En az bir ürün kategorisi seçiniz'>! ");
			return false;
        }    

        if(document.search_product_property.is_excel.checked==false)
		{
			document.search_product_property.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else
			document.search_product_property.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_product_catalog</cfoutput>";


		document.getElementById('list_property_id').value= '';
		document.getElementById('list_variation_id').value= '';
		for(r=1;r<=row_count;r++)
		{
			deger_property_id = eval("document.getElementById('property_id" + r + "')");
			deger_variation_id = eval("document.getElementById('variation_id" + r + "')");
			if(deger_variation_id.value != "")
			{
				if(document.search_product_property.list_property_id.value.length==0) ayirac=''; else ayirac=',';
				document.getElementById("list_property_id").value = document.getElementById("list_property_id").value+ayirac+deger_property_id.value;
				document.getElementById("list_variation_id").value = document.getElementById('list_variation_id').value+ayirac+deger_variation_id.value;
			}
		}
		return true;
    }
</script>