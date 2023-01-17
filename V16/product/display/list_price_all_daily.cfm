<cfparam name="attributes.startdate" default="">
<cf_date tarih='attributes.startdate'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="0">
<cfform name="search" action="#request.self#?fuseaction=product.popup_price_all_daily&pid=#attributes.pid#" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='37264.Fiyat Değişimi'></cfsavecontent>
	<cf_medium_list_search title="#message#:#get_product_name(product_id:attributes.pid)#">
		<cf_medium_list_search_area>
				<table>
						<tr>
							<td>
								<cfif isdate(attributes.startdate)>
									<cfset st_date = dateformat(attributes.startdate,dateformat_style)>
								<cfelse>
									<cfset st_date = "">
								</cfif>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz'> !</cfsavecontent>
								<cfinput type="text" name="startdate" style="width:80px;" value="#st_date#" required="yes" message="#message#" validate="#validate_style#">
								<cf_wrk_date_image date_field="startdate">
							</td>
							<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
							<td><cf_wrk_search_button></td>
						</tr>
				</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<cfif isDefined("attributes.is_submitted")>
		<cfset attributes.finishdate = date_add('d',1,attributes.startdate)>
		<cfinclude template="../query/get_price_cats.cfm">
		<cfinclude template="../query/get_price_all_daily.cfm">
		<cfset attributes.totalrecords = GET_PRODUCT_PRICE.recordcount>
		<thead>
			<tr>
				<th><cf_get_lang dictionary_id='37748.Mağaza'></th>
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
			<cfoutput query="GET_PRODUCT_PRICE" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfquery dbtype="query" name="GET_DEPO">
					SELECT PRICE_CAT FROM GET_PRICE_CATS WHERE PRICE_CATID = #PRICE_CATID#
				</cfquery>
				<tr>
					<td>#GET_DEPO.PRICE_CAT#</td>
					<td>#ADD_UNIT#</td>
					<td style="text-align:right;">#TLFormat(PRICE,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#</td>
					<td style="text-align:right;">
					<cfif IsDefined("GET_PRODUCT_PRICE.IS_KDV") AND GET_PRODUCT_PRICE.IS_KDV neq 1>
						#TLFormat(PRICE*(1+(TAX/100)),session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#
					<cfelse>
						#TLFormat(PRICE_KDV,session.ep.our_company_info.sales_price_round_num)#&nbsp;#money#
					</cfif>
					</td>
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
						<cfelseif isDefined('GET_PRODUCT_PRICE.STARTDATE') and isdate(GET_PRODUCT_PRICE.STARTDATE) and timeformat(GET_PRODUCT_PRICE.STARTDATE,timeformat_style) neq '00:00'>
							<cfset st_date = "#dateformat(date_add('h',session.ep.time_zone,GET_PRODUCT_PRICE.STARTDATE),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_PRODUCT_PRICE.STARTDATE),timeformat_style)#)">
						<cfelse>
							<cfset st_date = "">
						</cfif>
					<td nowrap>#st_date#</td>
					<td nowrap><cfif isDefined('GET_PRODUCT_PRICE.FINISHDATE') and isdate(GET_PRODUCT_PRICE.FINISHDATE)>#dateformat(GET_PRODUCT_PRICE.FINISHDATE,dateformat_style)# (#timeformat(GET_PRODUCT_PRICE.FINISHDATE,timeformat_style)#)</cfif></td>
					<td>#dateformat(temp_date,dateformat_style)# (#TimeFormat(temp_date,timeformat_style)#)</td>
					<td><cfif len(RECORD_EMP)>#get_emp_info(RECORD_EMP,0,1)#</cfif></td>
				</tr>
			</cfoutput>
		</tbody>
	</cfif>
</cf_medium_list>
<cf_popup_box_footer>
	<cfset adres = "product.popup_std_sale&pid=#attributes.pid#">
	<cfif isdate(attributes.startdate)>
		<cfset adres = '#adres#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
	</cfif>
		<cf_paging page="#attributes.page#" 
		maxrows="#attributes.maxrows#"
		totalrecords="#attributes.totalrecords#"
		startrow="#attributes.startrow#"
		adres="#adres#">
</cf_popup_box_footer>
