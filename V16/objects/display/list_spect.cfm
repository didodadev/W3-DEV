<!---spec_cat eger spec urune degil kategoriye baglanacaksa--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.stock_id" default="">
<cfparam name="attributes.origin" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'> 
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

<cfif not len(attributes.stock_id) and isdefined('attributes.product_id')>
	<cfquery name="GET_STK" datasource="#DSN3#" maxrows="1">
		SELECT STOCK_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
	</cfquery>
	<cfset attributes.stock_id = get_stk.stock_id>
</cfif>
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date="">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date="">
</cfif>
<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT	RATE1,RATE2,MONEY FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND MONEY_STATUS = 1 AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.COMPANY_ID#">
</cfquery>
<cfset url_str = "">
<cfif isdefined("attributes.create_main_spect_and_add_new_spect_id")>
	<cfset url_str = "#url_str#&create_main_spect_and_add_new_spect_id=#attributes.create_main_spect_and_add_new_spect_id#">
</cfif>
<cfif isdefined("attributes.row_id")>
	<cfset url_str = "#url_str#&row_id=#attributes.row_id#">
</cfif>
<cfif isdefined("attributes.field_id")>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_main_id")>
	<cfset url_str = "#url_str#&field_main_id=#attributes.field_main_id#">
</cfif>
<cfif isdefined("attributes.field_name")>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif isdefined("attributes.basket_id")>
	<cfset url_str = "#url_str#&basket_id=#attributes.basket_id#">
</cfif>
<cfif isdefined("attributes.is_refresh")>
	<cfset url_str = "#url_str#&is_refresh=#attributes.is_refresh#">
</cfif>
<cfif isdefined("attributes.form_name")>
	<cfset url_str = "#url_str#&form_name=#attributes.form_name#">
</cfif>
<cfif isdefined("attributes.company_id")>
	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif isdefined("attributes.consumer_id")>
	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif isdefined("attributes.stock_id")>
	<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
</cfif>
<cfif isdefined("attributes.main_stock_amount")>
	<cfset url_str = "#url_str#&main_stock_amount=#attributes.main_stock_amount#">
</cfif>
<cfif isdefined("attributes.paper_department")>
	<cfset url_str = "#url_str#&paper_department=#attributes.paper_department#">
</cfif>
<cfif isdefined("attributes.paper_location")>
	<cfset url_str = "#url_str#&paper_location=#attributes.paper_location#">
</cfif>
<cfif isdefined("attributes.sepet_process_type")>
	<cfset url_str = "#url_str#&sepet_process_type=#attributes.sepet_process_type#">
</cfif>
<cfloop query="get_money">
	<cfif isdefined("attributes.#money#") >
		<cfset url_str = "#url_str#&#money#=#evaluate("attributes.#money#")#">
	</cfif>
</cfloop>
<cfif isdefined("attributes.search_process_date")>
	<cfset url_str = "#url_str#&search_process_date=#attributes.search_process_date#">
</cfif>
<cfif isdefined("attributes.only_list") and len(attributes.only_list)><!--- spec tiklandidinda detayina gidecekse yoksa baskete atar--->
	<cfset url_str="&only_list=#attributes.only_list#">
</cfif>
<cfparam name="attributes.select_spect_type" default="0">
<cfset url_str_2 = "">
<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
	<cfset url_str_2="&stock_id=#attributes.stock_id#">
</cfif>
<cfif len(attributes.stock_id)>
	<cfquery name="PRODUCT_NAMES" datasource="#DSN3#">
		SELECT
			STOCKS.STOCK_ID,
			STOCKS.PRODUCT_ID,
			STOCKS.PROPERTY,
			STOCKS.PRODUCT_NAME,
			STOCKS.IS_PROTOTYPE,
			STOCKS.IS_PRODUCTION
		FROM
			STOCKS
		WHERE
			STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	</cfquery>
	<cfset attributes.product_name = product_names.product_name>
</cfif>
<!--- <cfif  len(attributes.stock_id) and PRODUCT_NAMES.IS_PRODUCTION and PRODUCT_NAMES.IS_PROTOTYPE ><!--- and session.ep.our_company_info.product_config --->
	<cfset attributes.spect_type="objects.popup_add_spect"><!---fiyat farklı--->
<cfelseif (len(attributes.stock_id) and PRODUCT_NAMES.IS_PRODUCTION and PRODUCT_NAMES.IS_PROTOTYPE)>
	<cfset attributes.spect_type="objects.popup_add_spect_price"><!---fiyatlı--->
<cfelse>
	<cfset attributes.spect_type="objects.popup_add_spect_property">
</cfif> --->
<cfset attributes.spect_type="objects.popup_add_spect_list">

<cfif isdefined("attributes.form_submitted")>
    <cfinclude  template="../query/get_spect_var.cfm">
<cfelse>
	<cfset get_spect_var.recordcount=0>
</cfif>

<cfif isdefined("get_spect_var.query_count")>
	<cfparam name="attributes.totalrecords" default="#get_spect_var.query_count#">
<cfelse>
	<cfparam name="attributes.totalrecords" default="#get_spect_var.recordcount#">
</cfif>

	<cf_box title="#getLang('','Spekt',57647)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form_search_spect" action="#request.self#?fuseaction=objects.popup_list_spect#url_str#" method="post">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group" id="price_change">
					<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('','Filtre',57460)#" value="#attributes.keyword#">
				</div>
				<div class="form-group" id="select_spect_type">
					<cfset spect_type__ = url_str>
					<select name="select_spect_type" id="select_spect_type" onchange="go_page(this.value)">
						<option value=""><cf_get_lang dictionary_id='34004.Spec Tipi'></option>
						<option value="0" <cfif attributes.select_spect_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='57647.Spec'></option>
						<option value="<cfoutput>#spect_type__#</cfoutput>" <cfif attributes.select_spect_type eq spect_type__>selected</cfif>><cf_get_lang dictionary_id ='34006.Main Spect'></option>
					</select>
				</div>
				<div class="form-group" id="item-origin">
					<select name="origin">
						<option value=""><cf_get_lang dictionary_id='62469.Origin'></option>
						<option value="1" <cfoutput>#attributes.origin eq 1 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='36365.Ürün Ağacı'></option>
						<option value="2" <cfoutput>#attributes.origin eq 2 ? 'selected' : ''#</cfoutput>><cf_get_lang dictionary_id='34010.Karma Koli'></option>
					</select>
				</div>
				<div class="form-group" id="item-price_change">
						<label><input type="checkbox" name="price_change" id="price_change" value="1"><cf_get_lang dictionary_id ='33935.Fiyat Güncelle'></label> 
				</div>	
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("input_control() && loadPopupBox('form_search_spect' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<!--- <div class="form-group">
					<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
				</div> --->
			</cf_box_search>
			<cf_box_search_detail search_function="#iif(isdefined("attributes.draggable"),DE("input_control() && loadPopupBox('form_search_spect' , #attributes.modal_id#)"),DE(""))#">
				<div class="form-group col col-3 col-md-3 col-sm-6 col xs-12" id="stock_id">
					<div class="input-group">	
						<input type="hidden" name="stock_id" id="stock_id" <cfif len(attributes.product_name)> value="<cfoutput>#attributes.stock_id#</cfoutput>"</cfif>>
						<input type="text" name="product_name" id="product_name" placeholder="<cfoutput>#getLang('','Ürün',57657)#</cfoutput>" onfocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','PRODUCT_ID','product_id','','2','200');" autocomplete="off" value="<cfoutput>#attributes.product_name#</cfoutput>">
						<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_name=form_search_spect.product_name&field_id=form_search_spect.stock_id&keyword='+encodeURIComponent(document.form_search_spect.product_name.value));"></span>
					</div>
				</div>	
				<div class="form-group col col-3 col-md-3 col-sm-6 col xs-12" id="item-start_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='34005.Başlama Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#dateformat(attributes.start_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group col col-3 col-md-3 col-sm-6 col xs-12" id="item-finish_date">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57739.Bitiş Tarihi Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date, dateformat_style)#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id ='34006.Main Spec'> <cf_get_lang dictionary_id='58527.ID'></th>
					<th><cf_get_lang dictionary_id='58233.Tanım'></th>
					<th><cf_get_lang dictionary_id='62469.Origin'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<!-- sil -->
						<th width="20">
							<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>
								<a href="<cfoutput>#request.self#?fuseaction=#attributes.spect_type##url_str##url_str_2#</cfoutput>"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='34299.Spec'> <cf_get_lang dictionary_id ='44630.Ekle'>"></i></a>
							</cfif>
						</th>
					<!-- sil -->
				</tr>
			</thead>
			<tbody>
				<cfif get_spect_var.recordcount>
					<cfoutput query="get_spect_var">
						<tr>
							<td>#spect_var_id#</td>
							<td>#spect_main_id#</td>
							<td>
								<cfif isdefined('attributes.only_list') and only_list>
									<a href="#request.self#?fuseaction=objects.popup_upd_spect&id=#spect_var_id#&is_upd=0#url_str#" target="_blank">#spect_var_name#</a>
								<cfelse>
									<a href="##" onclick="gonder('#spect_var_id#'<cfif isdefined('attributes.field_main_id')>,'#spect_main_id#'</cfif>);">#spect_var_name#</a>
								</cfif>
							</td>
							<td><cfif len(is_mix_product) and is_mix_product eq 1><cf_get_lang dictionary_id='34010.Karma Koli'><cfelse><cf_get_lang dictionary_id='36365.Ürün Ağacı'></cfif></td>
							<td>
								<cfif len(record_emp)>
									#get_emp_info(record_emp,0,0)#
								<cfelseif len(record_par)>
									#get_par_info(record_par,0,0,0)#
								<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
									#get_cons_info(record_cons,0,0)# 
							</cfif>
							</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td><a href="#request.self#?fuseaction=objects.popup_upd_spect&id=#spect_var_id#&is_upd=0#url_str#" target="_blank"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
							<!-- sil -->
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="7"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif isdefined("attributes.stock_id")>
				<cfset url_str = "#url_str#&stock_id=#attributes.stock_id#">
			</cfif>
			<cfif isdefined("attributes.finish_date")>
				<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
			</cfif>
			<cfif isdefined("attributes.start_date")>
				<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
			</cfif>
			<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cfif isdefined("attributes.keyword")>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif isdefined("attributes.origin")>
				<cfset url_str = "#url_str#&origin=#attributes.origin#">
			</cfif>
			<cf_paging page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#attributes.fuseaction#&#url_str#" isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		</cfif>
	
	<form name="form_gonder_spect"  method="post" action="<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_js</cfoutput>">
		<input type="hidden" name="spect_id" id="spect_id">
		<input type="hidden" name="spect_main_id" id="spect_main_id">
		<input type="hidden" name="price_change" id="price_change">
		<cfif isdefined("attributes.row_id")>
			<input type="hidden" name="row_id" id="row_id" value="<cfoutput>#attributes.row_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.field_id")>
			<input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.field_main_id")>
			<input type="hidden" name="field_main_id" id="field_main_id" value="<cfoutput>#attributes.field_main_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.field_name")>
			<input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.basket_id")>
			<input type="hidden" name="basket_id" id="basket_id" value="<cfoutput>#attributes.basket_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.is_refresh")>
			<input type="hidden" name="is_refresh" id="is_refresh" value="<cfoutput>#attributes.is_refresh#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.form_name")>
			<input type="hidden" name="form_name" id="form_name" value="<cfoutput>#attributes.form_name#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
		</cfif>
		<cfoutput>
			<cfloop query="get_money">
				<cfif isdefined("attributes.#money#") >
					<input type="hidden" name="#money#" id="#money#" value="#evaluate('attributes.#money#')#">
				</cfif>
			</cfloop>
			<cfif isdefined("attributes.search_process_date")>
				<input type="hidden" name="search_process_date" id="search_process_date" value="<cfoutput>#attributes.search_process_date#</cfoutput>">
			</cfif>
		</cfoutput>
	</form>
</cf_box>

<script type="text/javascript">
	document.getElementById('keyword').focus();
	function input_control()
	{
		if(trim(document.getElementById('keyword').value).length < 3)
		{
			alert('Filtre alanına en az üç karakter giriniz');
			document.getElementById('keyword').focus();
			return false;
		}
		if(trim(document.getElementById('product_name').value)=='')
			document.getElementById('stock_id').value='';
		return true;
	}
	function gonder(id,main_id,name_,price,other_price,money_type,prod_cost)
	{
		if(document.form_search_spect.price_change.checked==true)
			document.form_gonder_spect.price_change.value = 1;
		document.form_gonder_spect.spect_id.value = id;
		document.form_gonder_spect.spect_main_id.value = main_id;//spect main id
		document.form_gonder_spect.submit();
		<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	}
	function go_page(url_address)
	{
		if(url_address!=0)
		{
			if(document.form_search_spect.price_change.checked==true) var url_address = url_address+'&price_change=1';
			<cfif isdefined("attributes.draggable")>
				openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_main&field_name=#attributes.field_name#&field_main_id=#attributes.field_main_id#&main_to_add_spect=1<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>&stock_id=#attributes.stock_id#</cfif></cfoutput>&is_form_submitted=1' + url_address + ' ' , <cfoutput>#attributes.modal_id#</cfoutput>);
			<cfelse>
				window.location.href='<cfoutput>#request.self#?fuseaction=objects.popup_list_spect_main&main_to_add_spect=1<cfif isdefined("attributes.stock_id") and len(attributes.stock_id)>&stock_id=#attributes.stock_id#</cfif></cfoutput>&is_form_submitted=1' + url_address + ' ';
			</cfif>
		}
	}
</script>