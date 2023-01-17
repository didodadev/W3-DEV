<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cf_date tarih='attributes.startdate'>
<cf_date tarih='attributes.finishdate'>
<cfparam name="attributes.price_type" default="all_list">
<cfinclude template="../query/get_price_cats.cfm">
<cfinclude template="../query/get_std_sale.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_PRODUCT_PRICE.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37264.Fiyat Değişimi'></cfsavecontent>
<cf_box title="#message#:#get_product_name(product_id:attributes.pid)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="search" id="search" action="#request.self#?fuseaction=product.popup_std_sale&pid=#attributes.pid#" method="post">
<cf_box_search> 
			<div class="form-group" id="item-select">
				<select name="price_type" id="price_type">
					<option value="all_list"<cfif attributes.price_type eq "all_list"> selected</cfif>><cf_get_lang dictionary_id='37305.Tüm Listeler'></option>
					<option value="sale"<cfif attributes.price_type eq "sale"> selected</cfif>><cf_get_lang dictionary_id='58721.Standart Satış'></option>
					<option value="purc"<cfif attributes.price_type eq "purc"> selected</cfif>><cf_get_lang dictionary_id='58722.Standart Alış'></option>
					<option value="daily"<cfif attributes.price_type eq "daily"> selected</cfif>><cf_get_lang dictionary_id='63005.Günlük fiyat değişim listesi'></option>
					<cfif isdefined('attributes.pricecatid') >
						<cfoutput query="get_price_cats">
							<option value="#PRICE_CATID#"<cfif attributes.pricecatid eq PRICE_CATID> selected</cfif>>#price_cat#</option>
						</cfoutput>
					<cfelse>
						<cfoutput query="get_price_cats">
							<option value="#PRICE_CATID#"<cfif attributes.price_type eq PRICE_CATID> selected</cfif>>#price_cat#</option>
						</cfoutput>
					</cfif>
				</select>
			</div>
			<div class="form-group col-2" id="item-date">
				<div class="input-group">
				<input type="text" name="startdate" id="startdate" value="<cfif isdate(attributes.startdate)><cfoutput>#dateformat(attributes.startdate,dateformat_style)#</cfoutput></cfif>">
				<span class="input-group-addon btnPointer">
				<cf_wrk_date_image date_field="startdate">
				</span>
			</div></div>
			<div class="form-group col-2" id="item-date">
				<div class="input-group">
				<input type="text" name="finishdate" id="finishdate"  value="<cfif isdate(attributes.finishdate)><cfoutput>#dateformat(attributes.finishdate,dateformat_style)#</cfoutput></cfif>">
				<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
			</div>
		</div>
			<div class="form-group small" id="item-date">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
			</div>
			<div class="form-group" id="item-date">
			<cfsavecontent variable="message_date"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
				<cf_wrk_search_button button_type="4"  search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#"><!--- date_check(startdate,finishdate,'#message_date#') --->
				</div>	
		</cf_box_search> 
</cfform>
<cf_grid_list>
	<!-- sil -->
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='57636.Birim'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='58084.Fiyat'></th>
			<th style="text-align:right;"><cf_get_lang dictionary_id='50983.KDV li Fiyat'></th>
			<th><cf_get_lang dictionary_id='37210.Aksiyon'></th>
			<th width="65"><cf_get_lang dictionary_id='57501.Baslangic'></th>
			<th width="65"><cf_get_lang dictionary_id='57502.Bitiş'></th>  
			<th width="95"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
			<th width="100"><cf_get_lang dictionary_id='57899.Kaydeden'></th>
		</tr>
	</thead>
	<tbody>
        <cfif GET_PRODUCT_PRICE.recordcount>
		<cfset employee_id_list=''>
		<cfoutput query="GET_PRODUCT_PRICE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(RECORD_EMP) and not listfind(employee_id_list,RECORD_EMP)>
				<cfset employee_id_list=listappend(employee_id_list,RECORD_EMP)>
			</cfif>
		</cfoutput>
		<cfif len(employee_id_list)>
			<cfquery name="get_record_emp_detail" datasource="#dsn#">
				SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_id_list#)
			</cfquery>
		</cfif>
		<cfoutput query="GET_PRODUCT_PRICE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
          <cfif len(RECORD_EMP)>
			  <cfquery name="get_record_emp_name" dbtype="query">
			  	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME,EMPLOYEE_ID FROM get_record_emp_detail WHERE EMPLOYEE_ID=#RECORD_EMP#
			  </cfquery>
		  </cfif>
		  <tr>
            <td>#ADD_UNIT#</td>
            <cfif not isDefined("attributes.price_type") or attributes.price_type is "all_list" or attributes.price_type is "daily" or attributes.price_type is "sale" or isNumeric(attributes.price_type)>
			<td style="text-align:right;">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#</td>
            <td style="text-align:right;">
				<cfif IsDefined("GET_PRODUCT_PRICE.IS_KDV") AND GET_PRODUCT_PRICE.IS_KDV neq 1>
					#TLFormat(PRICE*(1+(TAX/100)),session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#
				<cfelse>
					#TLFormat(PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#
				</cfif>
			</td>
			</cfif>
			<cfif attributes.price_type is "purc">
			<td style="text-align:right;">#TLFormat(PRICE,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#money#</td>
            <td style="text-align:right;">
				<cfif IsDefined("GET_PRODUCT_PRICE.IS_KDV") AND GET_PRODUCT_PRICE.IS_KDV neq 1>
					#TLFormat(PRICE*(1+(TAX/100)),session.ep.our_company_info.purchase_price_round_num)#&nbsp;#money#
				<cfelse>
					#TLFormat(PRICE_KDV,session.ep.our_company_info.purchase_price_round_num)#&nbsp;#money#
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
			<cfset temp_date = date_add('h',session.ep.time_zone,RECORD_DATE)>
			<cfif isDefined('GET_PRODUCT_PRICE.STARTDATE') and isdate(GET_PRODUCT_PRICE.STARTDATE) and timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style) eq '00:00'>
				<cfset st_date = "#dateformat(GET_PRODUCT_PRICE.STARTDATE,dateformat_style)# (#timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style)#)">
				<!--- <cfset st_date = "#dateformat(date_add('h',session.ep.time_zone,GET_PRODUCT_PRICE.STARTDATE),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_PRODUCT_PRICE.STARTDATE),timeformat_style)#)"> --->
				<cfset st_date = "#dateformat(GET_PRODUCT_PRICE.STARTDATE,dateformat_style)# (#timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style)#)">
			<cfelse>
				<cfset st_date = "">
			</cfif>
            <td nowrap>#st_date#</td>
			<td nowrap><cfif isDefined('GET_PRODUCT_PRICE.FINISHDATE') and isdate(GET_PRODUCT_PRICE.FINISHDATE)>#dateformat(GET_PRODUCT_PRICE.FINISHDATE,dateformat_style)# (#timeformat(GET_PRODUCT_PRICE.FINISHDATE,timeformat_style)#)</cfif></td>
            <td>#dateformat(temp_date,dateformat_style)# (#TimeFormat(temp_date,timeformat_style)#)</td>
            <td><cfif len(RECORD_EMP)><a href="javascript://"onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#RECORD_EMP#','medium');">#get_record_emp_name.EMPLOYEE_NAME# #get_record_emp_name.EMPLOYEE_SURNAME#</a></cfif></td>
          </tr>
        </cfoutput>
		</cfif>
	</tbody>
</cf_grid_list>
<cf_box_footer>
	<cfif attributes.maxrows lt attributes.totalrecords>
		<table cellpadding="0" cellspacing="0" border="0" width="99%" height="35" align="center">
			<tr>
				<td>
					<cfset adres = "product.popup_std_sale&pid=#attributes.pid#">
					<cfset adres = '#adres#&price_type=#attributes.price_type#'>
					<cfif isdate(attributes.startdate)>
						<cfset adres = '#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
					</cfif>
					<cfif isdate(attributes.finishdate)>
						<cfset adres = '#adres#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#'>
					</cfif>
					<cfif isDefined("attributes.draggable") and len(attributes.draggable)>
						<cfset adres = '#adres#&draggable=#attributes.draggable#'>
					</cfif>
						<cf_paging page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#"
						adres="#adres#"
						isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
					</td>
				<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td><!-- sil -->
			</tr>
		</table>
	</cfif>
</cf_box_footer>
</cf_box>
