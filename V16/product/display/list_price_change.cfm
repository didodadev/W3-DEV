<cfif fuseaction contains "popup">
  <cfset is_popup=1>
  <cfelse>
  <cfset is_popup=0>
</cfif>
<cfif not isDefined("attributes.pc_status")>
  <cfset attributes.pc_status=2>
</cfif>
<cfif not isDefined("attributes.price_catid")>
  <cfset attributes.price_catid = "">
</cfif>
<cfinclude template="../query/get_product_cat.cfm">
<cfinclude template="../query/get_price_cat.cfm">
<cfif isdefined("attributes.filtered")>		
	<cfinclude template="../query/get_price_change.cfm">
	<!--- <cfdump var="#get_price_change#"> --->
<cfelse>
	<cfset get_price_change.recordcount = 0>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_price_change.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform name="search_product" action="#request.self#?fuseaction=product.list_price_change&filtered=1" method="post">
			<cf_box_search more="0">
				<div class="form-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group">
					<select name="price_catid" id="price_catid">
						<option value="" selected><cf_get_lang dictionary_id='58964.Fiyat Listesi'></option>
						<option value="-1"<cfif attributes.price_catid eq "-1"> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
						<option value="-2"<cfif attributes.price_catid eq "-2"> Selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
						<cfoutput query="get_price_cat">
							<option value="#price_catid#"<cfif price_catid eq attributes.price_catid> selected</cfif>>#price_cat#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<select name="pc_status" id="pc_status">
						<option value="1"<cfif attributes.pc_status eq 1> selected</cfif>><cf_get_lang dictionary_id='37231.Kabul Edilen'></option>
						<option value="0"<cfif attributes.pc_status eq 0> selected</cfif>><cf_get_lang dictionary_id='37232.Red Edilen'></option>
						<option value="2"<cfif attributes.pc_status eq 2> selected</cfif>><cf_get_lang dictionary_id='37233.Onay Bekleyen'></option>
						<option value=""<cfif isDefined("attributes.pc_status") and not len(attributes.pc_status)> selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="spec" id="spec">
					<option value="1"<cfif isDefined("attributes.spec") and attributes.spec eq 1> selected</cfif>><cf_get_lang dictionary_id='34762.Ürün Bazında'></option>
					<option value="2"<cfif isDefined("attributes.spec") and attributes.spec eq 2> selected</cfif>><cf_get_lang dictionary_id='45555.Stok Bazında'></option>
					</select>
				</div>
				<div class="form-group x-3_5">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#"  onKeyUp="isNumber(this)"maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37230.Fiyat Önerileri'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
					<th><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th><cf_get_lang dictionary_id='37042.Satış Fiyatı'></th>
					<th  class="form-title"><cf_get_lang dictionary_id='37127.Önerilen Fiyat'></th>
					<th><cf_get_lang dictionary_id='58964.Fiyat Listesi'></th>
					<th><cf_get_lang dictionary_id='37234.Öneri Yapan'></th>
					<th><cf_get_lang dictionary_id='37235.Geçerlilik'></th>
					<!--- <td class="form-title" width="60">Aşama</td> --->
					<th width="20" class="text-center"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_price_change.recordcount>
				<cfset employee_id_list=''>
				<cfset product_id_list =''>
				<cfset unit_price_list =''>
				<cfset secand_product_id_list =''>
				<cfoutput query="get_price_change" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
					<cfset employee_id_list=listappend(employee_id_list,record_emp)>
					</cfif>
					<cfif len(product_id) and not listfind(product_id_list,product_id)>
						<cfset product_id_list=listappend(product_id_list,product_id)>
					</cfif>
					<cfif len(PRODUCT_UNIT_ID) and not listfind(unit_price_list,PRODUCT_UNIT_ID)>
						<cfset unit_price_list=listappend(unit_price_list,PRODUCT_UNIT_ID)>
					</cfif>
					<cfif len(product_id_list) and not listfind(secand_product_id_list,product_id_list)>
						<cfset secand_product_id_list=listappend(secand_product_id_list,product_id_list)>
					</cfif>
				</cfoutput>
				<cfif len(employee_id_list)>
					<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
					<cfquery name="get_emp_detail" datasource="#dsn#">
						SELECT
							EMPLOYEE_NAME,
							EMPLOYEE_SURNAME
						FROM
							EMPLOYEES
						WHERE
							EMPLOYEE_ID IN (#employee_id_list#)
						ORDER BY
							EMPLOYEE_ID
					</cfquery>
				</cfif>
				<cfif len(product_id_list)>
				<cfset product_id_list=listsort(product_id_list,"numeric","ASC",",")>
				<cfset unit_price_list=listsort(unit_price_list,"numeric","ASC",",")>
						<cfquery name="GET_PR" datasource="#DSN3#">
							SELECT 
								PRICE,
								MONEY,
								PRODUCT_ID
							FROM
								PRICE_STANDART 
							WHERE
								PRICESTANDART_STATUS = 1 AND
								PRODUCT_ID IN(#product_id_list#) AND
								PURCHASESALES = 1  AND 
								UNIT_ID IN (#unit_price_list#)  
								ORDER BY 
								PRODUCT_ID
						</cfquery>
						<cfset product_id_list =valuelist(GET_PR.PRODUCT_ID,',')>
				</cfif> 
					<cfoutput query="get_price_change" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<!--- alttaki query product_stock_remainder deðiþkeni ile ürün stok bakiyesi döndürür --->
						<tr>
							<td width="40">#currentrow#</td>
							<td> <a href="#request.self#?fuseaction=stock.list_stock&event=det&pid=#get_price_change.product_id[currentrow]#" class="tableyazi"> #STOCK_CODE# </a> </td>
							<td>#BARCOD#</td>
							<td> <a href="#request.self#?fuseaction=product.list_product&event=det&pid=#get_price_change.product_id[currentrow]#" class="tableyazi"> #PRODUCT_NAME# #PROPERTY#</a> </td>
							<td align="right" style="text-align:right;">
								<a href="#request.self#?fuseaction=product.list_price_change&event=det&pid=#get_price_change.product_id[currentrow]#" class="tableyazi"> 
								#TLFormat(GET_PR.PRICE[listfind(product_id_list,get_price_change.PRODUCT_ID,',')])#  #GET_PR.MONEY[listfind(product_id_list,get_price_change.PRODUCT_ID,',')]#
								</a>
							</td>
							<td width="100" align="right" style="text-align:right;">#TLFormat(PRICE)#&nbsp;#MONEY#</td>
							<td>
								<cfswitch expression="#get_price_change.PRICE_CATID[currentrow]#">
									<cfcase value="-1">
										<cf_get_lang dictionary_id='58722.Standart Alış'>
									</cfcase>
									<cfcase value="-2">
										<cf_get_lang dictionary_id='58721.Standart Satış'>
									</cfcase>
								</cfswitch>
								#get_price_change.PRICE_CAT[currentrow]# 
							</td>
							<td>#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]# &nbsp; #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</td>
							<td>#dateformat(STARTDATE,dateformat_style)#</td>
							<td width="15">
								<a href="javascript://"  onClick="openBoxDraggable('#request.self#?fuseaction=product.list_price_change&event=upd&id=#PRICE_CHANGE_ID#&pid=#product_id#','page');">
									<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
								</a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="12"><cfif not isdefined("attributes.filtered")><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>

		<cfset adres = "product.list_price_change&filtered=1">
		<cfif isDefined('attributes.cat') and len(attributes.cat)>
		<cfset adres = adres&"&cat="&attributes.cat>
		</cfif>
		<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		<cfset adres = adres&"&keyword="&attributes.keyword>
		</cfif>
		<cfif isDefined('attributes.price_catid') and len(attributes.price_catid)>
		<cfset adres = adres&"&price_catid="&attributes.price_catid>
		</cfif>
		<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	//document.getElementById('keyword').focus();
</script>
