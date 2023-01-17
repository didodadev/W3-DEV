<cf_xml_page_edit fuseact="objects.popup_add_product_return">
<cfparam name="attributes.listing_type" default="2">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.product_process_type" default="">
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
	<cf_date tarih = "attributes.finish_date">
<cfelse>
	<cfset attributes.finish_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
	<cf_date tarih = "attributes.start_date">
<cfelse>
	<cfset attributes.start_date = dateadd('ww',-1,attributes.finish_date)>
</cfif>
<cfquery name="GET_RETURN_CATS" datasource="#DSN3#">
	SELECT RETURN_CAT_ID,RETURN_CAT FROM SETUP_PROD_RETURN_CATS ORDER BY RETURN_CAT
</cfquery>
<cfquery name="GET_RETURN_STAGES" datasource="#DSN#">
	SELECT
  		PTR.STAGE,
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PTR.PROCESS_ID = PT.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
        PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.add_return%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<cfif isdefined("attributes.form_submitted")>
	<cfinclude template="../query/get_return.cfm">
<cfelse>
	<cfset get_returns.recordcount = 0>
</cfif>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default = "#get_returns.recordcount#">
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=service.product_return">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group">
					<cfinput type="text" name="keyword" placeholder="#getLang('','Filtre',57460)#" maxlength="50" value="#attributes.keyword#">
				</div>
				<div class="form-group">
					<select name="product_process_type" id="product_process_type">
						<option value=""><cf_get_lang dictionary_id='57800.İşlem Tipi'></option>
						<option value="1" <cfif attributes.product_process_type eq 1>selected</cfif>><cf_get_lang dictionary_id='29418.İade'></option>
						<option value="2" <cfif attributes.product_process_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58016.Değişim'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="return_type" id="return_type">
						<option value=""><cf_get_lang dictionary_id='41858.İade Nedeni'></option>
						<cfoutput query="get_return_cats">
							<option value="#return_cat_id#" <cfif isdefined("attributes.return_type") and attributes.return_type eq return_cat_id> selected</cfif>>#return_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="listing_type" id="listing_type">
						<option value="1" <cfif attributes.listing_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57660.Belge Bazında'></option>
						<option value="2" <cfif attributes.listing_type eq 2>selected</cfif>><cf_get_lang dictionary_id='29539.Satır Bazında'></option>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
				</div>
			</cf_box_search>
			<cf_box_search_detail>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-member_name">
						<label class="col col-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
						<div class="col col-12">
							<div class="input-group">
								<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">	
								<input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
								<input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
								<input name="member_name" type="text" id="member_name" style="width:120px;" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
								<cfset str_linke_ait="&field_consumer=form1.consumer_id&field_comp_id=form1.company_id&field_member_name=form1.member_name&field_type=form1.member_type">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+document.form1.member_name.value);"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-is_irsaliye">
						<label class="col col-12"><cf_get_lang dictionary_id='57656.Servis'> <cf_get_lang dictionary_id='30111.Durumu'></label>
						<div class="col col-12"> 
							<select name="is_irsaliye" id="is_irsaliye">
								<option value=""><cf_get_lang dictionary_id='57656.Servis'> <cf_get_lang dictionary_id='30111.Durumu'></option>
								<option value="0" <cfif isdefined("attributes.is_irsaliye") and attributes.is_irsaliye eq 0>selected</cfif>><cf_get_lang dictionary_id='41856.Beklemede'></option>
								<option value="1" <cfif isdefined("attributes.is_irsaliye") and attributes.is_irsaliye eq 1>selected</cfif>><cf_get_lang dictionary_id='41857.Kabul'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-return_stage">
						<label class="col col-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
						<div class="col col-12"> 
							<select name="return_stage" id="return_stage">
								<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
								<cfoutput query="get_return_stages">
									<option value="#process_row_id#" <cfif isdefined("attributes.return_stage") and attributes.return_stage eq process_row_id> selected</cfif>>#stage#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-start_date">
						<label class="col col-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-12"> 
							<div class="input-group">
								<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
									<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#">
								<cfelse>
									<cfinput type="text" name="start_date" id="start_date" maxlength="10" value="" validate="#validate_style#" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finish_date">
						<label class="col col-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-12"> 
							<div class="input-group">
								<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#">
								<cfelse>
									<cfinput type="text" name="finish_date" id="finish_date" maxlength="10" value="" validate="#validate_style#" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#">
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_search_detail>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Ürün Servis İşlemleri',41680)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<cfset cols = 6>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
						<cfset cols = cols + 6>
						<th><cf_get_lang dictionary_id='57657.Ürün'></th>
						<th><cf_get_lang dictionary_id='41860.Satılan'></th>
						<th><cf_get_lang dictionary_id='41861.Dönen'></th>
						<th><cf_get_lang dictionary_id='57482.Aşama'></th>
						<th><cf_get_lang dictionary_id='41858.İade Nedeni'></th>
						<th><cf_get_lang dictionary_id='57800.Islem Tipi'></th>
					</cfif>
					<th><cf_get_lang dictionary_id='57880.Belge No'></th>
					<th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
					<th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
					<!-- sil --><th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=service.product_return&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th><!-- sil -->
					<cfif isdefined("attributes.member_type") and len(attributes.member_type) and len(attributes.member_name) and (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
						<th width="20" class="header_icn_none text-center"><input type="checkbox" name="check_all" id="check_all" onclick="check_all_return_rows()" value="1" /></th><cfset cols = cols +1>
					</cfif>
				</tr>
			</thead>
			<cfif isdefined("attributes.form_submitted") and get_returns.recordcount>
				<cfset stage_list = ''>
				<cfset return_type_list = ''>
				<cfoutput query="get_returns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
					<cfif len(get_returns.return_stage) and not listfind(stage_list,get_returns.return_stage)>
						<cfset stage_list = listappend(stage_list,get_returns.return_stage)>
					</cfif>
					<cfif len(get_returns.row_return_type) and not listfind(return_type_list,get_returns.row_return_type)>
						<cfset return_type_list = listappend(return_type_list,get_returns.row_return_type)>
					</cfif>
					</cfif>
				</cfoutput>
				<cfif len(stage_list)>
					<cfset stage_list=listsort(stage_list,"numeric","ASC",",")>
					<cfquery name="GET_STAGES" datasource="#DSN#">
						SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#stage_list#) ORDER BY PROCESS_ROW_ID
					</cfquery>
					<cfset stage_list = listsort(listdeleteduplicates(valuelist(get_stages.process_row_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif listlen(return_type_list)>
					<cfset return_type_list=listsort(return_type_list,"numeric","ASC",",")>
					<cfquery name="GET_RETURN_TYPES" datasource="#DSN3#">
						SELECT RETURN_CAT_ID,RETURN_CAT FROM SETUP_PROD_RETURN_CATS WHERE RETURN_CAT_ID IN (#return_type_list#) ORDER BY RETURN_CAT_ID
					</cfquery>
					<cfset return_type_list = listsort(listdeleteduplicates(valuelist(get_return_types.return_cat_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfif isdefined("attributes.member_type") and len(attributes.member_type) and len(attributes.member_name) and (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
					<cfoutput>
						<form action="#request.self#?fuseaction=stock.form_add_purchase" name="send_form_" id="send_form_" method="post">
						<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
						<input type="hidden" name="consumer_id" value="#attributes.consumer_id#">
						<input type="hidden" name="member_name" value="#attributes.member_name#">				
						<input type="hidden" name="member_type" value="#attributes.member_type#">
					</cfoutput>
				</cfif>
				<tbody>
					<cfoutput query="get_returns" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<cfif isdefined('attributes.listing_type') and attributes.listing_type eq 2><!--- Eğer satır bazında listeleme yapılıyorsa --->
								<cfquery name="GET_PERIOD_" datasource="#DSN#">
									SELECT PERIOD_YEAR,OUR_COMPANY_ID FROM SETUP_PERIOD <cfif len(return_period_id)>WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#return_period_id#"></cfif>
								</cfquery>
							<cfset my_source = '#dsn#_#get_period_.period_year#_#get_period_.our_company_id#'>
							<h2><cfquery name="GET_STOCK_INFO" datasource="#my_source#">
								SELECT IR.AMOUNT,I.INVOICE_CAT,PARTNER_ID FROM INVOICE_ROW IR,INVOICE I WHERE IR.INVOICE_ID = I.INVOICE_ID AND IR.INVOICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_id#"> AND IR.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#stock_id#"> AND IR.INVOICE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_row_id#">
							</cfquery></h2>
							<cfquery name="GET_STOCK_INFO" datasource="#my_source#">
							SELECT IR.AMOUNT,I.INVOICE_CAT FROM INVOICE_ROW IR,INVOICE I WHERE IR.INVOICE_ID = I.INVOICE_ID <!--- BK 90 gune kaldir 20100726 AND IR.INVOICE_ID = #INVOICE_ID# AND IR.STOCK_ID = #STOCK_ID#  ---> AND IR.INVOICE_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoice_row_id#">
							</cfquery>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#product_name##property#</a></td>
							<td style="text-align:center">#get_stock_info.amount#</td>
							<td style="text-align:center">
								<cfif is_return_control eq 1>
										<cfquery name="GET_RETURNS_ROW" dbtype="query">
											SELECT AMOUNT FROM GET_RETURNS WHERE RETURN_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_returns.return_row_id#"> AND RETURN_ACT_TYPE = 1
										</cfquery>
									<cfif get_returns_row.recordcount>
											#get_returns_row.amount#
										<cfelse>
											0
									</cfif>
									<cfelse>
										#get_returns.amount#
								</cfif>
							</td>
							<td>#get_stages.stage[listfind(stage_list,return_stage,',')]#</td>
							<td><cfif len(row_return_type)>#get_return_types.return_cat[listfind(return_type_list,row_return_type,',')]#</cfif></td>
							<td>
								<cfif row_return_act_type eq 1>
									<cf_get_lang dictionary_id ='29418.İade'>
								<cfelseif row_return_act_type eq 2>
									<cf_get_lang dictionary_id ='58016.Değişim'>
								<cfelse>
									<cf_get_lang dictionary_id ='41700.Fazla Ürün'>
								</cfif>
							</td>
								</cfif>
							<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_detail_invoice&iid=#invoice_id#','page');">#paper_no#</a></td>
							<td>
								<cfif len(service_company_id) and len(service_partner_id)>
									#get_par_info(service_company_id,1,-1,1)#-#get_par_info(service_partner_id,0,-1,1)#
								<cfelseif len(service_consumer_id)>
									#get_cons_info(service_consumer_id,0,1)#
								<cfelseif len(service_employee_id)>
									#get_emp_info(service_employee_id,0,1)#
								</cfif>
							</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<td>#dateformat(update_date,dateformat_style)#</td>
							<!-- sil --><td class="header_icn_none"><a href="#request.self#?fuseaction=service.product_return&event=upd&return_id=#return_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
								<cfif isdefined("attributes.member_type") and len(attributes.member_type) and len(attributes.member_name) and (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
							<td style="width:20px;">
								<cfif is_ship neq 1 and amount gt 0>
									<input type="hidden" name="return_partner_ids" id="return_partner_ids" value="#service_partner_id#">
									<input type="hidden" name="invoice_cat_#currentrow#" id="invoice_cat_#currentrow#" value="#get_stock_info.invoice_cat#">
									<input type="checkbox" name="return_row_ids" id="return_row_ids" value="#return_row_id#">
								<cfelse>
									<input type="hidden" name="return_partner_ids" id="return_partner_ids" value="#service_partner_id#">
									<input type="hidden" name="invoice_cat_#currentrow#" id="invoice_cat_#currentrow#" value="#get_stock_info.invoice_cat#">
									<input type="checkbox" name="return_row_ids" id="return_row_ids" value="#return_row_id#" style="display:none;">
								</cfif>	
							</td>
								</cfif>
						</tr>
					</cfoutput>
					<cfif isdefined("attributes.member_type") and len(attributes.member_type) and len(attributes.member_name) and (isdefined('attributes.listing_type') and attributes.listing_type eq 2)>
							<tr class="total">
								<td colspan="<cfoutput>#cols#</cfoutput>" style="text-align:right"><cf_workcube_buttons type_format='1' add_function='kontrol_et()' insert_info='#getLang('','İrsaliye Düzenle',45793)#' is_cancel='0'></td>
							</tr>
						</form>
					<cfelse>
					<!-- sil -->
						<tr class="total">
							<td colspan="<cfoutput>#cols#</cfoutput>" style="text-align:right" class="table_warning"><cf_get_lang dictionary_id ='41929.İrsaliye Düzenlemek İçin Cari Hesap Seçmelisiniz'>!</td>
						</tr>
					<!-- sil -->
					</cfif>
					<cfelse>
						<tr>
							<td colspan="<cfoutput>#cols#</cfoutput>"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.filtre ediniz'></cfif>!</td>
						</tr>
				</tbody>
			</cfif>
		</cf_grid_list>
		<script type="text/javascript">
			function kontrol_et()
			{
				kontrol_ = 0;
				if (document.send_form_.return_row_ids.length != undefined) /* n tane*/
				{
					for (i=0; i < document.send_form_.return_row_ids.length; i++)
					{
						if (document.send_form_.return_row_ids[i].checked)
							kontrol_ = 1;
					}
				}
				else
				{
					if (document.send_form_.return_row_ids.checked)
						kontrol_ = 1;	
				}
				
				if (document.send_form_.return_row_ids.length != undefined) /* n tane*/
				{
					perakende_kontrol_ = 0;
					diger_kontrol_ = 0;
					for (j=0; j < document.send_form_.return_row_ids.length; j++)
					{
						if (document.send_form_.return_row_ids[j].checked)
						{
							m = j + 1;
							if(eval('document.send_form_.invoice_cat_' + m).value==52)
								perakende_kontrol_ = 1;
							else
								diger_kontrol_ = 1;
						}
					}
					if(perakende_kontrol_==1 && diger_kontrol_==1)
					{
						alert("<cf_get_lang dictionary_id ='41930.Farklı İki (2) Tür Faturayı Aynı İrsaliyeye Çekemezsiniz'>!");
						return false;
					}
				}
				
				if(kontrol_ == 0)
				{
					alert("<cf_get_lang dictionary_id ='41868.Hiçbir İade İşlemi Seçmediniz'>!");
					return false;
				}
				document.getElementById('send_form_').submit();
				return true;
			}
		</script>
		<cfset adres = "service.product_return">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			<cfset adres = adres & "&keyword=#attributes.keyword#">
		</cfif>
		<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
			<cfset adres = adres & "&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif isdefined("attributes.return_type") and len(attributes.return_type)>
			<cfset adres = adres & "&return_type=#attributes.return_type#">
		</cfif>
		<cfif len(attributes.product_process_type)>
			<cfset adres = adres & "&product_process_type=#attributes.product_process_type#">
		</cfif>
		<cfif isdefined("attributes.return_stage") and len(attributes.return_stage)>
			<cfset adres = adres & "&return_stage=#attributes.return_stage#">
		</cfif>
		<cfif isdefined("attributes.member_name")>
			<cfset adres = adres & "&member_name=#attributes.member_name#">
		</cfif>
		<cfif isdefined("attributes.member_type")>
			<cfset adres = adres & "&member_type=#attributes.member_type#">
		</cfif>
		<cfif isdefined("attributes.consumer_id")>
			<cfset adres = adres & "&consumer_id=#attributes.consumer_id#">
		</cfif>
		<cfif isdefined("attributes.company_id")>
			<cfset adres = adres & "&company_id=#attributes.company_id#">
		</cfif>
		<cfif isdefined("attributes.is_irsaliye")>
			<cfset adres = adres & "&is_irsaliye=#attributes.is_irsaliye#">
		</cfif>
		<cfif isdefined("attributes.listing_type") and len(attributes.listing_type)>
			<cfset adres = "#adres#&listing_type=#attributes.listing_type#">
		</cfif>
		<cfset adres = adres & "&start_date=#dateformat(attributes.start_date,dateformat_style)#">
		<cfset adres = adres & "&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	if( !date_check(document.all.form1.start_date, document.all.form1.finish_date, "<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'>!") )
		return false;
	else
		return true;
}

function check_all_return_rows()
{
	if(document.getElementById('check_all').checked)
	{
		for (j=0; j < document.send_form_.return_row_ids.length; j++)
		{
			document.send_form_.return_row_ids[j].checked=true;
		}
	}
	else
	{
		for (j=0; j < document.send_form_.return_row_ids.length; j++)
		{
			document.send_form_.return_row_ids[j].checked=false;
		}
	}
}
</script>
