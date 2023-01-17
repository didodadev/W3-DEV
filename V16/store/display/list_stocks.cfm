<cfif not isdefined('send')>
	<cfset adres = 'store.stocks'>
<cfelse>
	<cfset adres = send>
</cfif>
<cfinclude template="../query/get_product_cat.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.barcod" default="">
<cfparam name="attributes.cat" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.is_stock_active" default="1">
<cfparam name="attributes.stock_code" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.search_product_catid" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.amount_flag" default="">
<cfif isdefined("attributes.is_form_submitted")>
	<cfinclude template="../query/get_product_stocks.cfm">
	<cfset arama_yapilmali=0>
<cfelse>
	<cfset get_product.recordcount=0>
	<cfset arama_yapilmali=1>
</cfif>
<cfinclude template="../query/get_stores.cfm">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT
		*
	FROM
		STOCKS_LOCATION
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_product.recordcount#'>
<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows)+1>
<cfform action="#request.self#?fuseaction=#adres#" method="post" name="stock_search">
	<cf_big_list_search title="#getLang('store',754)#"> 
		<cf_big_list_search_area>
			<table>
				<tr> 
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:70px;" value="#attributes.keyword#" maxlength="50"></td>
					<td><cf_get_lang_main no='106.Stok Kodu'></td>
					<td><cfinput type="text" name="stock_code" value="#attributes.stock_code#" maxlength="50" style="width:70px;"></td>
					<td><cf_get_lang_main no='221.Barkod'><cfinput type="text" name="barcod" style="width:70px;" value="#attributes.barcod#" maxlength="15"></td>
					<td>
						<select name="department_id" id="department_id">
							<option value=""><cf_get_lang_main no='1351.Depo'></option>
							<cfoutput query="stores">
								<option value="#department_id#"<cfif attributes.department_id eq department_id>selected</cfif>>#department_head#</option>
								<cfquery name="GET_LOCATION" dbtype="query">
									SELECT * FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #stores.department_id[currentrow]#
								</cfquery>		 
								<cfif get_location.recordcount>
									<cfloop from="1" to="#get_location.recordcount#" index="s">
										<option <cfif not get_location.status[s]>style="color:##FF0000"</cfif> value="#department_id#-#get_location.location_id[s]#" <cfif attributes.department_id eq '#department_id#-#get_location.location_id[s]#'>selected</cfif>>&nbsp;&nbsp;&nbsp;#get_location.comment[s]#<cfif not get_location.status[s]> - <cf_get_lang_main no='82.Pasif'></cfif></option>
									</cfloop>
								</cfif>	
							</cfoutput>
						</select>	
					</td>
					<td>
						<input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
						<select name="is_stock_active" id="is_stock_active">
							<option value="2" <cfif attributes.is_stock_active eq 2>selected</cfif>><cf_get_lang_main no='81.Aktif'>/<cf_get_lang_main no='82.Pasif'></option>
							<option value="1" <cfif attributes.is_stock_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
							<option value="0" <cfif attributes.is_stock_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
						</select>
					</td>
					<td>
						<select name="amount_flag" id="amount_flag">
							<option value="" <cfif not len(attributes.amount_flag)>selected</cfif>><cf_get_lang_main no='40.Stok'> <cf_get_lang_main no='2314.Durumu'></option>
							<option value="0" <cfif attributes.amount_flag eq 0 >selected</cfif>><cf_get_lang no='124.Negatif Stoklar'></option>
							<option value="1" <cfif attributes.amount_flag eq 1 >selected</cfif>><cf_get_lang no='123.Pozitif Stoklar'></option>
							<option value="2" <cfif attributes.amount_flag eq 2 >selected</cfif>><cf_get_lang no='5.Sıfır Stok'></option>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" style="width:25px;" maxlength="3" onKeyUp="isNumber(this)" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
					</td>
					<td style="text-align:right;"><cf_wrk_search_button search_function='input_control()'></td>
					<td>
						<cfif get_module_user(47)>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_barcod_search','medium');"><img src="/images/barcode.gif" title="<cf_get_lang_main no="221.Barkod">"></a>
						</cfif>
					</td>
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' extra_parameters='1'>  
				</tr>
			</table>
		</cf_big_list_search_area>
		<cf_big_list_search_detail_area>
			<table>
				<tr>
					<td><cf_get_lang_main no='132.Sorumlu'></td>
					<td>
						<input type="hidden" name="employee_id" id="employee_id"  value="<cfoutput>#attributes.employee_id#</cfoutput>">
						<input type="text" name="employee" id="employee" style="width:135px;" value="<cfif len(attributes.employee_id)><cfoutput>#attributes.employee#</cfoutput></cfif>" maxlength="255">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=stock_search.employee_id&field_name=stock_search.employee<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=1&keyword='+encodeURIComponent(document.stock_search.employee.value),'list','popup_list_positions');"><img src="/images/plus_thin.gif" align="absbottom"></a>
					</td>
					<td><cf_get_lang_main no='1736.Tedarikçi'></td>
					<td>
						<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
						<input type="text" name="company" id="company" style="width:135px;" value="<cfoutput>#attributes.company#</cfoutput>">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=stock_search.company&field_comp_id=stock_search.company_id<cfif fusebox.circuit is 'store'>&is_store_module=1</cfif>&select_list=2&keyword='+encodeURIComponent(document.stock_search.company.value),'list','popup_list_pars');"><img src="/images/plus_thin.gif" align="absbottom"></a>
					</td>
					<td><cf_get_lang_main no='74.Kategori'></td>
					<td>
						<input type="hidden" name="search_product_catid" id="search_product_catid" value="<cfoutput>#attributes.search_product_catid#</cfoutput>">
						<input type="text" name="product_cat" id="product_cat" style="width:135px;"  value="<cfoutput>#attributes.product_cat#</cfoutput>">
						<a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=3&field_code=stock_search.search_product_catid&field_name=stock_search.product_cat</cfoutput>&keyword='+encodeURIComponent(document.stock_search.product_cat.value));"><img src="/images/plus_thin.gif" align="absbottom" title="<cf_get_lang_main no='1684.Ürün Kategorisi Ekle'>"></a>
					</td>
				</tr>
			</table>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
</cfform>
<cf_big_list>
	<thead>
		<tr>
        	<th width="35"><cf_get_lang_main no="1165.Sıra"></th>
			<th width="100"><cf_get_lang_main no='106.Stok Kodu'></th>
			<th width="90"><cf_get_lang_main no='221.Barkod'></th>
			<th><cf_get_lang_main no='217.Açıklama'></th>
			<th width="50" style="text-align:right;"><cf_get_lang_main no='223.Miktar'></th>
			<th width="50" nowrap><cf_get_lang_main no='224.Birim'></th>
			<th class="header_icn_none">&nbsp;</th>
			
		</tr>
	</thead>
	<tbody>
		<cfif get_product.recordcount>
		<cfset depo_list = ''>
		<cfoutput query="get_product" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
			<cfif len(STORE) and not listfind(depo_list,STORE)>
				<cfset depo_list = listappend(depo_list,STORE)>
			</cfif>
		</cfoutput>
			<cfset depo_list=listsort(depo_list,"numeric","ASC",",")>
			<cfif len(depo_list)>
				<cfquery name="get_all_dep" datasource="#dsn#">
					SELECT
						DEPARTMENT_HEAD
					FROM
						DEPARTMENT
					WHERE
						DEPARTMENT_ID IN (#depo_list#)
					ORDER BY
						DEPARTMENT_ID
				</cfquery>
			<cfelse>
				<cfset get_all_dep.recordcount = 0>
			</cfif>
			<cfset sayac = 0>
			<cfoutput query="get_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset sayac = sayac + 1>
				<tr>
                	<td>#currentrow#</td>
					<td>#STOCK_CODE#</td>
					<td>#BARCOD#</td>
					<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#get_product.product_id#&sid=#get_product.stock_id#','list');" class="tableyazi">#product_name# #property#</a></td>
					<td style="text-align:right;">
						<cfif PRODUCT_STOCK lt 0><font color="##FF0000">#TLFormat(PRODUCT_STOCK)#</font><cfelse>#TLFormat(PRODUCT_STOCK)#</cfif>
					</td>
					<td>#main_unit#</td>
					<!-- sil -->
					<td align="center" nowrap>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=stock.popup_list_departments_stock_strategy&sid=#get_product.stock_id#&pid=#get_product.product_id#','horizantal');"><img src="/images/stockstrategy.gif" title="<cf_get_lang no='174.depo bazında Strateji'>"></a>					
                        <cfif len(depo_list) and product_stock neq 0>
                        	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=store.detail_stock_popup&pid=#get_product.product_id#&department_id=#STORE#','list')"><img src="/images/action.gif" title="#get_all_dep.department_head[listfind(depo_list,STORE,',')]#"></a>
                        </cfif>
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_self_barcode&barcod=#BARCOD#','small');"><img src="/images/barcode.gif" title="<cf_get_lang_main no="221.Barkod">"></a></td>	  		  
					<!-- sil -->
				</tr>
			</cfoutput>
			<cfif sayac eq 0>
				<tr><td colspan="7"><cf_get_lang_main no='72.Kayıt Yok'> !</td></tr>
			</cfif>
		<cfelse>
			<tr><td colspan="7"><cfif arama_yapilmali ><cf_get_lang_main no='289.Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayıt Yok'> !</cfif></td></tr>
		</cfif>
    </tbody>
</cf_big_list>
<cfif isDefined('attributes.is_form_submitted') and len(attributes.is_form_submitted)>
	<cfset adres = '#adres#&is_form_submitted=#attributes.is_form_submitted#'>
</cfif>
<cfif isDefined('attributes.cat') and len(attributes.cat)>
	<cfset adres = '#adres#&cat=#attributes.cat#'>
</cfif>
<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
	<cfset adres = '#adres#&keyword=#attributes.keyword#'>
</cfif>		
<cfif len(attributes.employee)>
	<cfset adres="#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
</cfif>
<cfif len(attributes.search_product_catid)>
	<cfset adres="#adres#&search_product_catid=#attributes.search_product_catid#&product_cat=#attributes.product_cat#">		
</cfif>
<cfif len(attributes.company_id)>
	<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#" >
</cfif>
<cfif len(attributes.amount_flag)>
	<cfset adres = "#adres#&amount_flag=#attributes.amount_flag#">
</cfif>
<cfif isDefined('attributes.department_id') and len(attributes.department_id) >
  <cfset adres = "#adres#&department_id=#attributes.department_id#">
</cfif> 
<cfif isDefined('attributes.stock_code') and len(attributes.stock_code) >
  <cfset adres = "#adres#&stock_code=#attributes.stock_code#">
</cfif>
<cf_paging 
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();	
	function input_control()
	{
		<cfif not session.ep.our_company_info.UNCONDITIONAL_LIST>
			is_ok = 0;
			if(stock_search.product_cat.value.length == 0)
				stock_search.search_product_catid.value = '';
			if(stock_search.employee.value.length == 0)
				stock_search.employee_id.value = '';
			if(stock_search.company.value.length == 0)
				stock_search.company_id.value = '';
			if(stock_search.department_id.value.length == 0)
				stock_search.department_id.value = '';
		if (stock_search.keyword.value.length == 0 && stock_search.barcod.value.length < 7
				&& (stock_search.product_cat.value.length == 0 || stock_search.search_product_catid.value.length == 0)
				&& (stock_search.employee_id.value.length == 0 || stock_search.employee.value.length == 0)
				&& (stock_search.company_id.value.length == 0 || stock_search.company.value.length == 0)
				&& (stock_search.department_id.value.length == 0) )
			{
				alert("<cf_get_lang_main no ='114.En az bir alanda filtre etmelisiniz '>!");
				document.getElementById('keyword').focus();
				return false;
			}
		else return true;
		
		<cfelse>
		 return true;
		</cfif>
	}
</script>
