<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_guaranties.cfm">
<cfelse>
	<cfset get_consumer_guaranties.query_count = 0 >
</cfif>
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.belge_no" default="">
<cfparam name="attributes.lot_no" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.totalrecords" default = "#get_consumer_guaranties.query_count#">
<cfparam name="attributes.oby" default=1>

<cfinclude template="../query/get_guaranty_cat.cfm">
<cf_box>
	<cfform name="form1" method="post" action="#request.self#?fuseaction=service.list_guaranty">
		<input type="hidden" name="form_submitted" id="form_submitted"  value="1">
		<cf_box_search plus="0">
			<div class="form-group">
				<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeholder="#getLang('main',48)#">
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfinput type="hidden" name="stock_id" id="stock_id" maxlength="50" value="#attributes.stock_id#">
					<cfinput type="text" name="product_name" id="product_name" maxlength="50" value="#attributes.product_name#" placeholder="#getLang('main',245)#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','200');">
					<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form1.stock_id&field_name=form1.product_name&keyword='+encodeURIComponent(document.form1.product_name.value));"></span>
				</div>
			</div>
			<div class="form-group">
				<select name="category" id="category">
					<option value="" selected><cf_get_lang no='102.Tüm Garantiler'></option>
					<cfoutput query="get_guaranty_cat">
						<option value="#guarantycat_id#" <cfif isDefined("attributes.category") and len(attributes.category) and (guarantycat_id eq attributes.category)>selected</cfif>>#guarantycat#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<select name="oby" id="oby">
					<option value="1" <cfif isDefined('attributes.oby') and attributes.oby eq 1>selected</cfif>><cf_get_lang dictionary_id='57926.Azalan Tarih'></option>
					<option value="2" <cfif isDefined('attributes.oby') and attributes.oby eq 2>selected</cfif>><cf_get_lang dictionary_id='57925.Artan Tarih'></option>
				</select>
			</div>
			<div class="form-group small">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group">
				<a class="ui-btn ui-btn-gray" href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_guaranty&event=add&take=1"><i class="fa fa-plus"></i></a>
			</div>
			<div class="form-group">
				<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
				<cf_wrk_search_button search_function="date_check(form1.start_date,form1.finish_date,'#message_date#')" button_type="4">
			</div>
		</cf_box_search>
		<cf_box_search_detail>
			<div class="col col-4 col-md-5 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-belge_no">
					<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
					<div class="col col-12 col-xs-12">
						<cfinput type="text" name="belge_no" id="belge_no" value="#attributes.belge_no#" maxlength="50" style="width:90px;">
					</div>
				</div>
				<div class="form-group" id="item-lot_no">
					<label class="col col-12 col-xs-12"><cf_get_lang no='59.Lot No'></label>
					<div class="col col-12 col-xs-12">
						<cfinput type="text" name="lot_no" id="lot_no" value="#attributes.lot_no#" maxlength="50" style="width:90px;">
					</div>
				</div>
				<div class="form-group" id="item-start_date">
					<label class="col col-12 col-xs-12"><cfoutput>#getLang('main',243)# / #getLang('main',288)#</cfoutput></label>
					<div class="col col-12 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="mesage"><cf_get_lang no ='293.Lütfen Başlangıç Tarihini Giriniz'></cfsavecontent>
							<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
								<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" style="width:70px;" validate="#validate_style#" message="#mesage#">
							<cfelse>
								<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="" style="width:70px;" validate="#validate_style#" message="#mesage#">
							</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="mesage"><cf_get_lang no ='294.Lütfen Bitiş Tarihi Giriniz'></cfsavecontent>
							<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
								<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#mesage#">
							<cfelse>
								<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="" style="width:65px;" validate="#validate_style#" message="#mesage#">
							</cfif>
							<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
						</div>
					</div>
				</div>
			</div>
		</cf_box_search_detail>
	</cfform>	
</cf_box>
<cf_box uidrop="1" title="#getLang('','	Garanti ve Ürün Takibi','47111')#">
	<cf_grid_list>	
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='58577.Sıra'></th>
				<th><cf_get_lang dictionary_id='57637.Seri No'></th>
				<th><cf_get_lang dictionary_id='57657.Ürün'></td>
				<th><cf_get_lang dictionary_id='41826.Alış Garantisi'></th>
				<th><cf_get_lang dictionary_id='41827.Alış Garanti Süresi'></th>
				<th style="text-align:right;"><cf_get_lang dictionary_id='41697.Zaman'></th>
				<th><cf_get_lang dictionary_id='41828.Satış Garantisi'></th>
				<th><cf_get_lang dictionary_id='41829.Satış Garanti Süresi'></th>
				<th style="text-align:right;"><cf_get_lang dictionary_id='41697.Zaman'></th>
				<!-- sil --><th class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.list_guaranty&event=add&take=1"><i class="fa fa-plus"></i></a></th><!-- sil -->
			</tr>
		</thead>
		<tbody>
			<cfset counter = 0>
			<cfif isdefined("attributes.form_submitted") and get_consumer_guaranties.recordcount>
				<cfset guaranty_cat_list = ''>
				<cfset stock_id_list = ''>
				<cfoutput query="get_consumer_guaranties">
					<cfif len(purchase_guaranty_catid)>
						<cfif not listfind(guaranty_cat_list,purchase_guaranty_catid)>
							<cfset guaranty_cat_list=listappend(guaranty_cat_list,purchase_guaranty_catid)>
						</cfif>
					</cfif>
					<cfif len(sale_guaranty_catid)>
						<cfif not listfind(guaranty_cat_list,sale_guaranty_catid)>
							<cfset guaranty_cat_list=listappend(guaranty_cat_list,sale_guaranty_catid)>
						</cfif>
					</cfif>
					<cfset stock_id_list = listappend(stock_id_list,get_consumer_guaranties.stock_id,',')>
				</cfoutput>
		
				<cfif len(guaranty_cat_list)>
					<cfset guaranty_cat_list=listsort(guaranty_cat_list,"numeric","ASC",",")>
					<cfquery name="GET_CAT_NAME" dbtype="query">
						SELECT GUARANTYCAT FROM GET_GUARANTY_CAT WHERE GUARANTYCAT_ID IN (#guaranty_cat_list#) ORDER BY GUARANTYCAT_ID
					</cfquery>
				</cfif>
		
				<cfset stock_id_list=listsort(stock_id_list,"numeric","ASC",",")>
				<cfif listlen(stock_id_list)>
					<cfquery name="GET_PRODUCTS" datasource="#DSN3#">
						SELECT
							S.PRODUCT_NAME,
							S.PRODUCT_ID,
							S.STOCK_ID,
							S.PROPERTY
						FROM
							STOCKS S WITH (NOLOCK)
						WHERE
							S.STOCK_ID IN (#stock_id_list#)
						ORDER BY
							S.STOCK_ID
					</cfquery>
					<cfset main_stock_id_list = listsort(listdeleteduplicates(valuelist(get_products.stock_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_consumer_guaranties">
				<cfset counter = counter + 1>
				<tr>
					<td>#rownum#</td>
					<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.serial_no&event=det&product_serial_no=#serial_no#','horizantal');" class="tableyazi">#serial_no#</a></td>
					<td><cfif len(stock_id)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_products.product_id[listfind(main_stock_id_list,stock_id,',')]#&sid=#stock_id#','list');" class="tableyazi">#get_products.product_name[listfind(main_stock_id_list,stock_id,',')]# #get_products.property[listfind(main_stock_id_list,stock_id,',')]#</a></cfif></td>
					<td><cfif in_out eq 1 and len(purchase_guaranty_catid)>#get_cat_name.guarantycat[listfind(guaranty_cat_list,get_consumer_guaranties.purchase_guaranty_catid,',')]#</cfif></td>
					<td><cfif in_out eq 1 and len(purchase_start_date)>#dateformat(purchase_start_date,dateformat_style)# -#dateformat(purchase_finish_date,dateformat_style)#</cfif></td>
					<td style="text-align:right;">
						<cfif in_out eq 1 and len(purchase_finish_date)>
							<cfset fark = datediff("d",now(),purchase_finish_date)>
							<cfif fark gt 0>#fark+1#<cf_get_lang dictionary_id='57490.Gün'></cfif>
						</cfif>
					</td>
					<td><cfif in_out eq 0 and len(sale_guaranty_catid)>#get_cat_name.guarantycat[listfind(guaranty_cat_list,get_consumer_guaranties.sale_guaranty_catid,',')]#</cfif></td>
					<td><cfif in_out eq 0 and len(sale_start_date)>#dateformat(sale_start_date,dateformat_style)# -#dateformat(sale_finish_date,dateformat_style)#</cfif></td>
					<td style="text-align:right;">
						<cfif in_out eq 0 and len(sale_finish_date)>
							<cfset fark2 = datediff("d",now(),sale_finish_date)>
							<cfif fark2 gt 0>#fark2+1#<cf_get_lang dictionary_id='57490.Gün'></cfif>
						</cfif>
					</td>
                    <!-- sil -->
					<td class="header_icn_none text-center">
						<cfif get_module_user(47)>
							<a href="#request.self#?fuseaction=service.list_guaranty&event=upd&id=#guaranty_id#" target="_blank"><i class="fa fa-pencil"></i></a>
						</cfif>
					</td>
                    <!-- sil -->
				</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="10"><cfif isdefined("attributes.form_submitted") ><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_grid_list>

<cfparam name="attributes.totalrecords" default="#counter#">
<cfset url_str = "service.list_guaranty">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
	<cfset url_str = "#url_str#&belge_no=#attributes.belge_no#">
</cfif>
<cfif isdefined("attributes.lot_no") and len(attributes.lot_no)>
	<cfset url_str = "#url_str#&lot_no=#attributes.lot_no#">
</cfif>
<cfif isdefined("attributes.category") and len(attributes.category)>
	<cfset url_str = "#url_str#&category=#attributes.category#">
</cfif>
<cfif isDefined('attributes.oby') and len(attributes.oby)>
	<cfset url_str = "#url_str#&oby=#attributes.oby#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.product_name") and len(attributes.product_name)>
	<cfset url_str = "#url_str#&product_name=#attributes.product_name#">
</cfif>
<cf_paging page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
</cf_box>
