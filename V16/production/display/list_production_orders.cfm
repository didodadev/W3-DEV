<!--- Üretim Emirleri --->
<cfsetting showdebugoutput="yes">
<cf_xml_page_edit fuseact="production.list_production_orders">
<cfset fuseaction_ = ListGetAt(attributes.fuseaction,2,'.')>
<cfset fuseaction_ = replace(fuseaction_,'emptypopup_','')>
<cfparam name="authority_station_id_list" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.p_order_no" default="">
<cfparam name="attributes.order_number" default="">
<cfparam name="attributes.serial_no" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.station_id" default="">
<cfparam name="attributes.product_code_2" default="">
<cfparam name="attributes.order_type" default="">
<cfparam name="attributes.spect" default="">
<cfif len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
</cfif>
<cfquery name="GET_W" datasource="#dsn#">
	SELECT 
		STATION_ID,
        STATION_NAME
	FROM 
		#dsn3_alias#.WORKSTATIONS W
	WHERE 
		W.ACTIVE = 1 AND
		W.EMP_ID LIKE '%,#session.ep.userid#,%' AND
		DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
	ORDER BY 
		STATION_NAME
</cfquery>
<cfset authority_station_id_list = ValueList(get_w.station_id,',')>
<cfif isdefined("attributes.is_form_submitted")>
	<cfscript>
		get_production_orders_action = createObject("component", "V16.production.cfc.get_production_orders");
        get_production_orders_action.dsn3 = dsn3;
		get_production_orders_action.dsn_alias = dsn_alias;
        GET_PO = get_production_orders_action.get_production_orders_fnc(
			keyword : '#IIf(IsDefined("attributes.keyword"),"attributes.keyword",DE(""))#',
			p_order_no : '#IIf(IsDefined("attributes.p_order_no"),"attributes.p_order_no",DE(""))#',
			order_number : '#IIf(IsDefined("attributes.order_number"),"attributes.order_number",DE(""))#',
			order_number : '#IIf(IsDefined("attributes.order_number"),"attributes.order_number",DE(""))#',
		    serial_no : '#IIf(IsDefined("attributes.serial_no"),"attributes.serial_no",DE(""))#',
			station_id : '#IIf(IsDefined("attributes.station_id"),"attributes.station_id",DE(""))#',
			production_stage : '#IIf(IsDefined("attributes.production_stage"),"attributes.production_stage",DE(""))#',
			product_code_2 : '#IIf(IsDefined("attributes.product_code_2"),"attributes.product_code_2",DE(""))#',
			spect : '#IIf(IsDefined("attributes.spect"),"attributes.spect",DE(""))#',
			xml_show_related_p_order_state : '#IIf(IsDefined("xml_show_related_p_order_state") and xml_show_related_p_order_state eq 1,1,DE(0))#'
		);
		GET_PO_DET = get_production_orders_action.get_production_orders_fnc2(
			authority_station_id_list : '#IIf(IsDefined("authority_station_id_list"),"authority_station_id_list",DE(""))#',
			start_date : '#IIf(IsDefined("attributes.start_date"),"attributes.start_date",DE(""))#',
			finish_date : '#IIf(IsDefined("attributes.finish_date"),"attributes.finish_date",DE(""))#',
			nullstation : '#IIf(IsDefined("nullstation") and nullstation eq 1,1,DE(0))#',
			order_type : '#IIf(IsDefined("attributes.order_type"),"attributes.order_type",DE(""))#',
			xml_show_related_p_order_state : '#IIf(IsDefined("xml_show_related_p_order_state") and xml_show_related_p_order_state eq 1,1,DE(0))#'
		);
	</cfscript>
<cfelse>
	<cfset GET_PO_DET.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif get_po_det.recordcount>
	<cfparam name="attributes.totalrecords" default='#get_po_det.recordcount#'>
<cfelse>
	<cfparam name="attributes.totalrecords" default='0'>
</cfif>
<cfscript>wrkUrlStrings('url_str','is_form_submitted','keyword');</cfscript>
<cfif isdate(attributes.start_date)>
	<cfset url_str = url_str & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = url_str & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
</cfif>
<cfif len(attributes.order_type)>
	<cfset url_str = url_str & "&order_type=#attributes.order_type#">
</cfif>
<cfif len(attributes.p_order_no)>
	<cfset url_str = url_str & "&p_order_no=#attributes.p_order_no#">
</cfif>
<cfif len(attributes.order_number)>
	<cfset url_str = url_str & "&order_number=#attributes.order_number#">
</cfif>
<cfif len(attributes.serial_no)>
	<cfset url_str = url_str & "&serial_no=#attributes.serial_no#">
</cfif>
<cfif len(attributes.product_code_2)>
	<cfset url_str = url_str & "&product_code_2=#attributes.product_code_2#">
</cfif>
<cfif len(attributes.station_id)>
	<cfset url_str = url_str & "&station_id=#attributes.station_id#">
</cfif>
<cfif isdefined("attributes.production_stage") and len(attributes.production_stage)>
	<cfset url_str = url_str & "&production_stage=#attributes.production_stage#">
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_list" action="#request.self#?fuseaction=production.#fuseaction_#" method="post">
			<cf_box_search more="0">
				<div class="form-group" id="item-p_order_no">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='29474.Emir No'></cfsavecontent>
					<cfinput type="text" tabindex="1" name="p_order_no" placeholder="#message#" value="#attributes.p_order_no#" maxlength="255" style="width:130px;">
				</div>      
				<div class="form-group" id="item-order_number">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58211.Sipariş No'></cfsavecontent>
					<cfinput type="text" tabindex="1" name="order_number" placeholder="#message#" value="#attributes.order_number#" maxlength="255" style="width:130px;">
				</div>
				<div class="form-group" id="item-order_number">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57637.Seri No'></cfsavecontent>
					<cfinput type="text" tabindex="1" name="serial_no" placeholder="#message#" value="#attributes.serial_no#" maxlength="255" style="width:130px;">
					<div style="position:absolute;" id="open_order_"></div>
				</div>      
				<div class="form-group" id="item-start_date">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" id="start_date" maxlength="10" placeholder="#place#" validate="#validate_style#" style="width:65px;" value="#dateformat(attributes.start_date,dateformat_style)#">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>   
				<div class="form-group" id="item-finish_date">
					<div class="input-group">
						<cfsavecontent variable="place"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
						<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" placeholder="#place#" validate="#validate_style#" style="width:65px;">
						<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
					</div>
				</div>     
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,255" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">       
					<cf_wrk_search_button button_type="4" is_excel='0' search_function='kontrol()'>
				</div>
				<div class="form-group">
					<a class="ui-btn ui-btn-gray2" href="javascript:history.go(-1);"><i class="fa fa-arrow-left"></i></a>
				</div>
				<!---<div class="form-group">
					<a href="javascript://" onclick="goster(open_order_);open_order();"><img src="/images/action.gif" border="0" title="<cf_get_lang dictionary_id='38091.Üretim Emirleri'>"></a>
				</div>--->         
				<div class="form-group" id="item-product_code_2">
					<cfif xml_show_production_code_2>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57789.Özel Kod'></cfsavecontent>
						<cfinput type="text" tabindex="2" name="product_code_2" placeholder="#message#" value="#attributes.product_code_2#" maxlength="255" style="width:130px;">
					</cfif>
				</div>     
				<div class="form-group" id="item-spect">
					<cfif xml_show_spect>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57647.Spekt'></cfsavecontent>
						<cfinput type="text" tabindex="3" name="spect" placeholder="#message#" value="#attributes.spect#" maxlength="255" style="width:130px;">
					</cfif>
				</div>
				<div class="form-group" id="item-station_id">
					<cfif xml_show_station>
						<select name="station_id" id="station_id" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="0" <cfif attributes.station_id eq 0>selected</cfif>><cf_get_lang dictionary_id='38098.İstasyonu Boş Olanlar'></option>
							<cfoutput query="get_w">
								<option value="#station_id#"<cfif attributes.station_id eq station_id>selected</cfif>>#station_name#</option>
							</cfoutput>
						</select>
					</cfif>
				</div>
				<div class="form-group" id="item-order_type">
					<cfif xml_show_order_type>
						<select name="order_type" style="width:150px;">
							<option value="1" <cfif attributes.order_type eq 1>selected</cfif>><cf_get_lang dictionary_id="38118.Emir Tarihine Göre"> <cf_get_lang dictionary_id="29826.Artan"> </option>  
							<option value="2" <cfif attributes.order_type eq 2>selected</cfif>><cf_get_lang dictionary_id="38118.Emir Tarihine Göre"> <cf_get_lang dictionary_id="29827.Azalan"> </option>  
							<option value="3" <cfif attributes.order_type eq 3>selected</cfif>><cf_get_lang dictionary_id="38119.İstasyona Göre"> <cf_get_lang dictionary_id="29826.Artan"> </option> 
							<option value="4" <cfif attributes.order_type eq 4>selected</cfif>><cf_get_lang dictionary_id="38119.İstasyona Göre"> <cf_get_lang dictionary_id="29827.Azalan"></option>  
							<option value="5" <cfif attributes.order_type eq 5>selected</cfif>><cf_get_lang dictionary_id="38120.Müşteri Adına Göre"> <cf_get_lang dictionary_id="29826.Artan"></option>  
							<option value="6" <cfif attributes.order_type eq 6>selected</cfif>><cf_get_lang dictionary_id="38120.Müşteri Adına Göre"> <cf_get_lang dictionary_id="29827.Azalan"></option>                        
						</select>
					</cfif>
				</div>
				<div class="form-group" id="item-order_type">
					<cfif xml_show_production_stage>
						<select name="production_stage" id="production_stage" style="width:125px;height:65px" multiple="multiple">
							<option value="4" style="background-color:#00CCFF;font-size:12px;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'4')>selected</cfif>><cf_get_lang dictionary_id ='38034.Başlamadı'></option>
							<option value="0" style="background-color:#FFCC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'0')>selected</cfif>><cf_get_lang dictionary_id ='38036.Operatöre Gönderildi'></option>
							<option value="1" style="background-color:#00CC33;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'1')>selected</cfif>><cf_get_lang dictionary_id ='38037.Başladı'></option>
							<option value="3" style="background-color:#CCCCCC;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'3')>selected</cfif>><cf_get_lang dictionary_id ='38117.Üretim Durdu(Arıza)'></option>
							<option value="2" style="background-color:#FF0000;"<cfif isdefined("attributes.production_stage") and listfind(attributes.production_stage,'2')>selected</cfif>><cf_get_lang dictionary_id ='38038.Bitti'></option>
						</select>  
					</cfif>
				</div>
			</cf_box_search>     
			<input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
		</cfform>
	</cf_box>
	<cfsavecontent variable="box_header"><cf_get_lang dictionary_id='38091.Üretim Emirleri'></cfsavecontent>
	<cf_box title="#box_header#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='38093.Emir Tarihi'></th>
					<th><cf_get_lang dictionary_id='29474.Emir No'></th>
					<th><cf_get_lang dictionary_id='38094.Mamül Uretim Emri'></th>
					<th><cf_get_lang dictionary_id='58211.Sipariş No'></th>
					<th><cf_get_lang dictionary_id='57457.Müşteri'></th>
					<th><cf_get_lang dictionary_id='58834.İstasyon'></th>
					<cfif isdefined('xml_show_special_code') and xml_show_special_code eq 1>
					<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='38089.Mamül Adı'></th>
					<!---<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>--->
					<th><cf_get_lang dictionary_id='57647.Spec'></th>
					<th><cf_get_lang dictionary_id='58467.Başlama'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='57635.Miktar'></th>
					<th><cf_get_lang dictionary_id='58444.Kalan'></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-print" alt="<cf_get_lang dictionary_id='57474.Yazdır'>" title="<cf_get_lang dictionary_id='57474.Yazdır'>"></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_po_det.recordcount>
					<cfoutput query="get_po_det" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr height="30" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
							<td>&nbsp;#currentrow#</td>
							<td>&nbsp;#DateFormat(record_date,dateformat_style)#</td>
							<td>
								<cfif isdefined("xml_is_link") and xml_is_link eq 1>
									<a href="#request.self#?fuseaction=production.form_add_production_order&upd=#p_order_id#" style="font-size:14px" class="tableyazi">&nbsp;#P_ORDER_NO#</a>
								<cfelse>
									<cfif currentrow eq 1 or STATION_ID eq 11><a href="#request.self#?fuseaction=production.form_add_production_order&upd=#p_order_id#" style="font-size:14px" class="tableyazi">&nbsp;#P_ORDER_NO#</a><cfelse>&nbsp;#P_ORDER_NO#</cfif>
								</cfif>
							</td>
							<td>&nbsp;<cfif len(po_related_id)><cfif isdefined("po_related_list_#po_related_id#")>#evaluate("po_related_list_#po_related_id#")#</cfif></cfif> #PO_RELATED_NO#</td>
							<td>&nbsp;#ORDER_NUMBER#</td>
							<td>&nbsp;#company_name#</td>
							<td>&nbsp;#STATION_NAME#</td>
							<cfif isdefined('xml_show_special_code') and xml_show_special_code eq 1>
							<td>&nbsp;#STOCK_CODE_2#</td>
							</cfif>
							<td>&nbsp;<cfif xml_is_product_link><a href="#request.self#?fuseaction=product.list_product&event=det&pid=#PRODUCT_ID#" target="_new" class="tableyazi">#PRODUCT_NAME#</a><cfelse>#PRODUCT_NAME#</cfif></td>
							<!---<td>&nbsp;#PRODUCT_code_2#</td>--->
							<td>&nbsp;#SPECT_VAR_NAME#</td>
							<td>&nbsp;#DateFormat(start_date,dateformat_style)#</td>
							<td>&nbsp;#DETAIL#</td>
							<td style="text-align:center">&nbsp;
								<cfif not len(IS_STAGE)>
									<img src="/images/blue_glob.gif" title="<cf_get_lang dictionary_id='38034.Başlamadı'>!">
								<cfelseif IS_STAGE eq 0>
									<img src="/images/yellow_glob.gif" title="<cf_get_lang dictionary_id='38036.Operatöre Gönderildi'>!">
								<cfelseif IS_STAGE eq 1>
									<img src="/images/green_glob.gif" title="<cf_get_lang dictionary_id='38037.Başladı'>!">
								<cfelseif IS_STAGE eq 2>
									<img src="/images/red_glob.gif" title="<cf_get_lang dictionary_id ='38038.Bitti'>">
								<cfelseif IS_STAGE eq 3>
									<img src="/images/grey_glob.gif" title="<cf_get_lang dictionary_id='38034.Başlamadı'>!">
								<cfelseif IS_STAGE eq 4>
									<img src="/images/blue_glob.gif" title="<cf_get_lang dictionary_id='38034.Başlamadı'>!">	
								</cfif>
							</td>
							<td style="text-align:center">#QUANTITY#</td>
							<td style="text-align:center">#QUANTITY-ROW_RESULT_AMOUNT#</td>
							<td>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#p_order_id#&print_type=281','page');"><img src="../images/print.gif" border="0"></a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr height="30" class="color-row"><td colspan="16"><cfif isdefined("attributes.is_form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td></tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0" height="35">
				<tr>
					<td style="font-size:14px;">
						<cf_paging 
							page="#attributes.page#" 
							maxrows="#attributes.maxrows#" 
							totalrecords="#get_po_det.recordcount#" 
							startrow="#attributes.startrow#" 
							adres="production.#fuseaction_##url_str#">
					</td>
					<!-- sil -->
					<td align="right" style="text-align:right;font-size:14px"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords# &nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
					<!-- sil -->
				</tr>
			</table>
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function open_order()
	{  
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=production.popup_production_orders_list','open_order_',1);
	}
	function kontrol()
	{
	
		if(datediff(document.getElementById('start_date').value,document.getElementById('finish_date').value,0)<0)
		{
			alert("<cf_get_lang dictionary_id='57806.Tarih Aralığını kontrol Ediniz'>!");
			return false;
		}
		else
		return true;
	}
</script>
