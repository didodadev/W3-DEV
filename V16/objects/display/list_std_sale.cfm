<cf_xml_page_edit fuseact="objects.popup_product_price_history_js,objects.popup_product_price_history_public_js">

<cfif isdefined("x_control_ims") and x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="../../member/query/get_ims_control.cfm">
</cfif>
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfset attributes.product_id = attributes.pid>
<cfparam name="attributes.price_type" default="sale">
<cfinclude template="../query/get_price_cats2.cfm">
<cfinclude template="../query/get_std_sale.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#GET_PRODUCT_PRICE.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','Ürün',57657)# : #get_product_name(product_id:attributes.pid)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="search_std_sale" action="#request.self#?fuseaction=objects.popup_std_sale&pid=#attributes.pid#" method="post">
		<cf_box_search more="0">
			<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>"></cfif>
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
			<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>"></cfif>

			<div class="form-group" id="item-price_type">
				<select name="price_type" id="price_type">
					<option value="sale"<cfif attributes.price_type eq "sale"> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
					<option value="purc"<cfif attributes.price_type eq "purc"> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
					<cfoutput query="get_price_cats">
						<option value="#PRICE_CATID#"<cfif attributes.price_type eq PRICE_CATID> selected</cfif>>#price_cat#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group" id="item-startdate">
				<div class="input-group">		
					<input type="text" name="startdate" id="startdate" value="<cfif isdate(attributes.startdate)><cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput></cfif>">
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
				</div>
			</div>		
			<div class="form-group" id="item-finishdate">
				<div class="input-group">		
					<input type="text" name="finishdate" id="finishdate" value="<cfif isdate(attributes.finishdate)><cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput></cfif>">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
				</div>
			</div>
			<div class="form-group small">	
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_std_sale' , #attributes.modal_id#)"),DE(""))#">
			</div>
		</cf_box_search>
	</cfform>
	<cf_grid_list>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='57636.Birim'></th>
				<th><cf_get_lang dictionary_id='58084.Fiyat'></th>
				<th><cf_get_lang dictionary_id='58716.Kdv li'>&nbsp;<cf_get_lang dictionary_id='58084.Fiyat'></th>
				<th><cf_get_lang dictionary_id='33119.Aksiyon'></th>
				<th><cf_get_lang dictionary_id='57501.Başlangıç'></th>
				<th><cf_get_lang dictionary_id='57502.Bitiş'></th>  
				<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
			</tr>
		</thead>
		<tbody>
			<cfif get_product_price.recordcount>
				<cfset employee_id_list=''>
				<cfoutput query="get_product_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
						<cfset employee_id_list=listappend(employee_id_list,record_emp)>
					</cfif>
				</cfoutput>
				<cfif len(employee_id_list)>
					<cfquery name="get_record_emp_detail" datasource="#dsn#">
						SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#)
					</cfquery>
					<cfset employee_id_list = listsort(listdeleteduplicates(valuelist(get_record_emp_detail.employee_id,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_product_price" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#ADD_UNIT#</td>
						<cfif attributes.price_type is "purc">
							<td style="text-align:right;">#TLFormat(PRICE,4)#&nbsp;#money#</td>
							<td style="text-align:right;">
								<cfif IsDefined("GET_PRODUCT_PRICE.IS_KDV") AND GET_PRODUCT_PRICE.IS_KDV neq 1>
									#TLFormat(PRICE*(1+(TAX/100)),4)#&nbsp;#money#
								<cfelse>
									#TLFormat(PRICE_KDV,4)#&nbsp;#money#
								</cfif>
							</td>
						<cfelse>
							<td style="text-align:right;">#TLFormat(PRICE)#&nbsp;#money#</td>
							<td style="text-align:right;">
								<cfif IsDefined("GET_PRODUCT_PRICE.IS_KDV") AND GET_PRODUCT_PRICE.IS_KDV neq 1>
									#TLFormat(PRICE*(1+(TAX/100)))#&nbsp;#money#
								<cfelse>
									#TLFormat(PRICE_KDV)#&nbsp;#money#
								</cfif>
							</td>
						</cfif>
						<td>
							<cfif IsDefined('CATALOG_ID') and IsNumeric(CATALOG_ID)>
								<cfquery datasource="#dsn3#" name="get_cat_prom">
									SELECT CATALOG_HEAD FROM CATALOG_PROMOTION WHERE CATALOG_ID = #CATALOG_ID#
								</cfquery>
							</cfif>
							<cfif IsDefined('get_cat_prom') and IsDefined('CATALOG_ID') and IsNumeric(CATALOG_ID)>
								<a href="javascript://" onClick="window.opener.location='#request.self#?fuseaction=product.form_upd_catalog_promotion&id=#CATALOG_ID#'; window.close();">#get_cat_prom.CATALOG_HEAD#</a>
							</cfif>
						</td>
									
						<cfif isDefined('GET_PRODUCT_PRICE.STARTDATE') and isdate(GET_PRODUCT_PRICE.STARTDATE) and timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style) eq '00:00'>
							<cfset st_date = "#dateformat(GET_PRODUCT_PRICE.STARTDATE,dateformat_style)# (#timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style)#)">
						<cfelseif isDefined('GET_PRODUCT_PRICE.STARTDATE') and isdate(GET_PRODUCT_PRICE.STARTDATE) and timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style) neq '00:00'>
							<cfset st_date = "#dateformat(date_add('h',session.ep.time_zone,GET_PRODUCT_PRICE.STARTDATE),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_PRODUCT_PRICE.STARTDATE),timeformat_style)#)">
						<cfelse>
							<cfset st_date = "">
						</cfif>
						<td nowrap>#st_date#</td>
						<td nowrap><cfif isDefined('GET_PRODUCT_PRICE.FINISHDATE') and isdate(GET_PRODUCT_PRICE.FINISHDATE)>#dateformat(GET_PRODUCT_PRICE.FINISHDATE,dateformat_style)# (#timeformat(GET_PRODUCT_PRICE.FINISHDATE,timeformat_style)#)</cfif></td>
						<td><cfif len(RECORD_DATE)><cfset temp_date = date_add('h',session.ep.time_zone,RECORD_DATE)>#dateformat(temp_date,dateformat_style)# (#TimeFormat(temp_date,timeformat_style)#)</cfif></td>
						<td><cfif len(RECORD_EMP)><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#RECORD_EMP#','medium');">#get_record_emp_detail.employee_name[listfind(employee_id_list,record_emp,',')]# #get_record_emp_detail.employee_surname[listfind(employee_id_list,record_emp,',')]#</a></cfif></td>
					</tr>
				</cfoutput>
			</cfif>
		</tbody>
	</cf_grid_list>
	<!--- Satış Fiyatları --->
	<cfif attributes.maxrows lt attributes.totalrecords>
		<cfset adres = "objects.popup_std_sale&pid=#attributes.pid#">
		<cfset adres = '#adres#&price_type=#attributes.price_type#'>
		<cfif isdate(attributes.startdate)>
			<cfset adres = '#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
		</cfif>
		<cfif isdate(attributes.finishdate)>
			<cfset adres = '#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
		</cfif>
		<cf_paging 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#"
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			adres="#adres#"
			isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
	</cfif>
	<cfscript>
		get_product_list_action = createObject("component", "V16.product.cfc.get_product");
		get_product_list_action.dsn1 = dsn1;
		get_product_list_action.dsn_alias = dsn_alias;
		GET_PRODUCT = get_product_list_action.get_product_
		(
			module_name : fusebox.circuit,
			pid : attributes.pid
		);
	</cfscript>
	<cfset alis_kdv = GET_PRODUCT.TAX_PURCHASE>
	<cfset satis_kdv = GET_PRODUCT.TAX>
	<!--- son alis fiyatlari --->
	<cfsavecontent variable="Son_Aliş_Fiyatlari"><cf_get_lang dictionary_id="37122.Son Alış Fiyatları"></cfsavecontent>
	<cf_seperator id="son_alis_fiyatlari" header="#Son_Aliş_Fiyatlari#">
	<cf_grid_list id="son_alis_fiyatlari">
		<thead>	
		<tr> 
			<th><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
			<th width="45"><cf_get_lang dictionary_id='57636.Birim'></th>
			<th width="100"><cf_get_lang dictionary_id='58084.Fiyat'></th>
			<th width="100"><cf_get_lang dictionary_id='33366.Dövizli Fiyat'></th>
			<th width="100"><cf_get_lang dictionary_id='37350.İskontolu Fiyat'></th>
			<th width="120"><cf_get_lang dictionary_id='58716.KDV li'> <cf_get_lang dictionary_id='37350.İskontolu Fiyat'></th>
			<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
		</tr>
		</thead>
			<cfinclude template="../../product/query/get_purchase_cost.cfm">
		<tbody>
			<cfoutput query="get_purchase_cost">
				<tr>
					<td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(consumer_id:CONSUMER_ID,with_company:1,with_link:1)#</cfif></td>
					<td>#GET_PURCHASE_COST.UNIT#</td>
					<td class="moneybox">#TLFormat(PRICE,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
					<td class="moneybox">
					<cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
						#TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
					</cfif>
					</td>
					<cfscript>
						indirimli_alis_fiyat = PRICE;
						if(len(DISCOUNT_COST))
							indirimli_alis_fiyat =(indirimli_alis_fiyat-DISCOUNT_COST); 
						indirim1 = DISCOUNT1;
						indirim2 = DISCOUNT2;
						indirim3 = DISCOUNT3;
						indirim4 = DISCOUNT4;
						indirim5 = DISCOUNT5;
						if (not len(indirim1)){indirim1 = 0;}
						if (not len(indirim2)){indirim2 = 0;}
						if (not len(indirim3)){indirim3 = 0;}
						if (not len(indirim4)){indirim4 = 0;}
						if (not len(indirim5)){indirim5 = 0;}
						indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim1)/100;
						indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim2)/100;
						indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim3)/100;
						indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim4)/100;
						indirimli_alis_fiyat = indirimli_alis_fiyat*(100-indirim5)/100;
					</cfscript>
				<td class="moneybox">#TLFormat(indirimli_alis_fiyat,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
					<td class="moneybox">
					<cfset kdvli_indirim = ((indirimli_alis_fiyat * alis_kdv) / 100) + indirimli_alis_fiyat>
					#TLFormat(kdvli_indirim,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
					<td>#dateformat(INVOICE_DATE,dateformat_style)#</td>                
				</tr>
			</cfoutput>
			</tbody>
	</cf_grid_list>
	<!--- // son alis fiyatları --->
	<!--- son satis fiyatlari --->
	<cfsavecontent variable="son_satis_fiyatlari"><cf_get_lang dictionary_id='37053.Son Satış Fiyatları'></cfsavecontent>
	<cf_seperator id="son_satis_fiyatlari" header="#son_satis_fiyatlari#">
	<cf_grid_list id="son_satis_fiyatlari">
		<thead>
		<tr> 
			<th><cf_get_lang dictionary_id='57457.müşteri'></th>
			<th width="45"><cf_get_lang dictionary_id='57636.Birim'></th>
			<th width="100"><cf_get_lang dictionary_id='58084.Fiyat'></th>
			<th width="100"><cf_get_lang dictionary_id='33366.Dövizli Fiyat'></th>
			<th width="100"><cf_get_lang dictionary_id='37350.İskontolu Fiyat'></th>
			<th width="120"><cf_get_lang dictionary_id='58716.KDV li'> <cf_get_lang dictionary_id='37350.İskontolu Fiyat'></th>
			<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
		</tr>
		</thead>
		<tbody>
			<cfinclude template="../query/get_sale_cost.cfm">
			<cfoutput query="get_sale_cost">
				<tr>
					<td><cfif len(COMPANY_ID)>#get_par_info(member_id:COMPANY_ID,company_or_partner:1,with_link:1,with_company_partner:1)#<cfelse>#get_cons_info(consumer_id:CONSUMER_ID,with_company:1,with_link:1)#</cfif></td>					
					<td>#UNIT#</td>
					<td class="moneybox">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
					<td class="moneybox">
					<cfif len(OTHER_MONEY) and len(PRICE_OTHER)>
						#TLFormat(PRICE_OTHER,session.ep.our_company_info.sales_price_round_num)#&nbsp;#OTHER_MONEY#
					</cfif>
					</td>
					<cfscript>
						indirimli_satis_fiyat = PRICE;
						indirim1 = DISCOUNT1;
						indirim2 = DISCOUNT2;
						indirim3 = DISCOUNT3;
						indirim4 = DISCOUNT4;
						indirim5 = DISCOUNT5;
						if (not len(indirim1)){indirim1 = 0;}
						if (not len(indirim2)){indirim2 = 0;}
						if (not len(indirim3)){indirim3 = 0;}
						if (not len(indirim4)){indirim4 = 0;}
						if (not len(indirim5)){indirim5 = 0;}
						indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim1)/100;
						indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim2)/100;
						indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim3)/100;
						indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim4)/100;
						indirimli_satis_fiyat = indirimli_satis_fiyat*(100-indirim5)/100;
					</cfscript>
					<td class="moneybox">#TLFormat(indirimli_satis_fiyat,session.ep.our_company_info.sales_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
					<td class="moneybox">
					<cfset kdvli_indirimsatis = ((indirimli_satis_fiyat * satis_kdv) / 100) + indirimli_satis_fiyat>
					#TLFormat(kdvli_indirimsatis,session.ep.our_company_info.sales_price_round_num)#&nbsp;#SESSION.EP.MONEY#</td>
					<td>#dateformat(INVOICE_DATE,dateformat_style)#</td>                
				</tr>
			</cfoutput>
		</tbody>
	</cf_grid_list>
	<!--- // son satis fiyatları --->
	<cfinclude template="list_product_contract.cfm">
</cf_box>
