<cfif len(Evaluate("invoice_id_#ListGetAt(attributes.line_id,1)#"))>
	<cfquery name="GET_INV_ROW" datasource="#DSN2#"><!--- ilk fatura depo v.s. almak için --->
		SELECT 
			I.DEPARTMENT_ID,
			I.DEPARTMENT_LOCATION,
			I.PROJECT_ID,
			D.DEPARTMENT_HEAD,
			D.BRANCH_ID
		FROM 
			INVOICE I,
			#dsn_alias#.DEPARTMENT D
		WHERE
			I.INVOICE_ID = #Evaluate("invoice_id_#ListGetAt(attributes.line_id,1)#")# AND
			I.DEPARTMENT_ID = D.DEPARTMENT_ID
	</cfquery>
</cfif>
<cfif len(attributes.company_id)>
	<cfquery name="GET_ADDR" datasource="#DSN#" maxrows="1">
		SELECT
			CB.COMPBRANCH_ADDRESS ADDRESS,
			CB.COMPBRANCH_POSTCODE POSTCODE,
			CB.COUNTY_ID COUNTY,
			CB.CITY_ID CITY,
			CB.COUNTRY_ID COUNTRY,
			CB.SEMT SEMT
		FROM	
			COMPANY_BRANCH CB,
			COMPANY C
		WHERE 
			CB.COMPANY_ID = C.COMPANY_ID AND
			CB.COMPBRANCH_STATUS = 1 AND
			CB.COMPANY_ID = #attributes.company_id#
	</cfquery>
	<cfif not get_addr.recordcount>
		<cfquery name="GET_ADDR" datasource="#DSN#">
			SELECT
				COMPANY_ADDRESS ADDRESS,
				COMPANY_POSTCODE POSTCODE,
				COUNTY COUNTY,
				CITY CITY,
				COUNTRY COUNTRY,
				SEMT SEMT
			FROM
				COMPANY
			WHERE
				COMPANY_STATUS = 1 AND
				COMPANY_ID = #attributes.company_id#
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="GET_ADDR" datasource="#DSN#" maxrows="1">
		SELECT
			TAX_ADRESS ADDRESS,
			TAX_POSTCODE POSTCODE,
			TAX_COUNTY_ID COUNTY,
			TAX_CITY_ID CITY,
			TAX_COUNTRY_ID COUNTRY,
			TAX_SEMT SEMT
		FROM	
			CONSUMER
		WHERE 
			CONSUMER_ID = #attributes.consumer_id#
	</cfquery>
</cfif>

<cfif get_addr.recordcount>
	<cfset addres='#get_addr.address# #get_addr.postcode#'>
	<cfif listlen(get_addr.county)>
		<cfquery name="GET_ADDR_COUNTY" datasource="#DSN#">
			SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_addr.county#
		</cfquery>
		<cfif get_addr_county.recordcount>
			<cfset addres='#addres# #get_addr_county.county_name#'>
		</cfif>
	</cfif>
	<cfif listlen(get_addr.city)>
		<cfquery name="GET_ADDR_CITY" datasource="#DSN#">
			SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_addr.city#
		</cfquery>
		<cfif get_addr_city.recordcount>
			<cfset addres='#addres# #get_addr_city.city_name#'>
		</cfif>
	</cfif>
	<cfif listlen(get_addr.country)>
		<cfquery name="GET_ADDR_COUNTRY" datasource="#DSN#">
			SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #get_addr.country#
		</cfquery>
		<cfif get_addr_country.recordcount>
			<cfset addres='#addres# #get_addr_country.country_name#'>
		</cfif>
	</cfif>
<cfelse>
	<cfset addres=''>
</cfif>
<cfif isdefined('get_inv_row') and len(get_inv_row.project_id)>
	<cfquery name="GET_PROJ" datasource="#DSN#">
		SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #get_inv_row.project_id#
	</cfquery>
	<cfif get_proj.recordcount>
		<cfset proj_name=get_proj.project_head>
	<cfelse>
		<cfset proj_name=''>
	</cfif>
<cfelse>
	<cfset proj_name=''>
</cfif>
<cfif len(attributes.company_id)>
	<cfquery name="GET_COMPANY_NAME" datasource="#DSN#">
		SELECT FULLNAME FROM COMPANY WHERE COMPANY_ID = #attributes.company_id#
	</cfquery>
	<cfquery name="GET_PARTNER_NAME" datasource="#DSN#">
		SELECT COMPANY_PARTNER_NAME, COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
	</cfquery>
<cfelse>
	<cfquery name="GET_CONSUMER_NAME" datasource="#DSN#">
		SELECT CONSUMER_NAME,CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
	</cfquery>
</cfif>
<cfform action="#request.self#?fuseaction=invoice.emptypopup_add_contract_product_to_invoice" name="add_invoice_control" method="post">
<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined('get_inv_row')><cfoutput>#get_inv_row.department_id#</cfoutput></cfif>">
<input type="hidden" name="department_location" id="department_location" value="<cfif isdefined('get_inv_row')><cfoutput>#get_inv_row.department_location#</cfoutput></cfif>">
<input type="hidden" name="department_head" id="department_head" value="<cfif isdefined('get_inv_row')><cfoutput>#get_inv_row.department_head#</cfoutput></cfif>">
<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined('get_inv_row')><cfoutput>#get_inv_row.branch_id#</cfoutput></cfif>">
<input type="hidden" name="adres" id="adres" value="<cfoutput>#addres#</cfoutput>">
<input type="hidden" name="county_id" id="county_id" value="<cfif listlen(get_addr.county)><cfoutput>#get_addr.county#</cfoutput></cfif>">
<input type="hidden" name="city_id" id="city_id" value="<cfif listlen(get_addr.city)><cfoutput>#get_addr.city#</cfoutput></cfif>">
<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#attributes.consumer_id#</cfoutput>">
<input type="hidden" name="company_name" id="company_name" value="<cfoutput><cfif len(attributes.company_id)>#get_company_name.fullname#</cfif></cfoutput>">	
<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
<input type="hidden" name="partner_name" id="partner_name" value="<cfoutput><cfif len(attributes.company_id)>#get_partner_name.company_partner_name# #get_partner_name.company_partner_surname#<cfelse>#get_consumer_name.consumer_name# #get_consumer_name.consumer_surname#</cfif></cfoutput>">
<input type="hidden" name="proj_id" id="proj_id" value="<cfif isdefined('get_inv_row')><cfoutput>#get_inv_row.project_id#</cfoutput></cfif>">
<input type="hidden" name="proj_head" id="proj_head" value="<cfoutput>#proj_name#</cfoutput>">
<input type="hidden" name="inv_type" id="inv_type" value="<cfoutput>#attributes.inv_type#</cfoutput>"><!--- kur farkı fiyat farkı --->
<input type="hidden" name="invoice_type" id="invoice_type" value="<cfoutput>#Evaluate('invoice_type_#ListGetAt(attributes.line_id,1)#')#</cfoutput>"><!--- alınan mı verilen mi?--->
<table cellspacing="0" cellpadding="0" border="0" width="98%">
	<tr>
		<td height="35" class="headbold">&nbsp;<cf_get_lang dictionary_id='57158.Fatura Kontrol'>:<cfoutput><cfif len(attributes.company_id)>#get_company_name.fullname#<cfelse>#get_consumer_name.consumer_name# #get_consumer_name.consumer_surname#</cfif></cfoutput></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr class="color-border">
	<td>
	<table width="100%" border="0" align="center" cellpadding="2" cellspacing="1">
		<tr class="color-header" height="22">
			<td class="form-title"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td class="form-title"><cf_get_lang dictionary_id='57657.Ürün'></td>
			<td class="form-title"><cf_get_lang dictionary_id="57636.Birim"> <cf_get_lang dictionary_id="58583.Fark"></td>
			<td class="form-title" width="30"><cf_get_lang dictionary_id="57639.KDV"></td>
			<td class="form-title"><cf_get_lang dictionary_id="57635.Miktar"></td>
			<td class="form-title"><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="58583.Fark"></td>
			<td class="form-title"><cf_get_lang dictionary_id="57492.Toplam"> <cf_get_lang dictionary_id="57677.Döviz"> <cf_get_lang dictionary_id="58583.Fark"></td>
		</tr>				
	<cfloop from="1" to="#listlen(attributes.line_id)#" index="i">
		<cfset pro_name = get_product_name(Evaluate("product_id_#ListGetAt(attributes.line_id,i)#"))>
		<cfset prod_amount=Evaluate("amount_#ListGetAt(attributes.line_id,i)#")>
		
		<cfif not len(prod_amount)>
			<cfquery name="GET_INV_ROW" datasource="#DSN2#">
				SELECT AMOUNT FROM INVOICE_ROW WHERE INVOICE_ID = #Evaluate("invoice_id_#ListGetAt(attributes.line_id,i)#")# AND STOCK_ID=#Evaluate("stock_id_#ListGetAt(attributes.line_id,i)#")#
			</cfquery>
			<cfif get_inv_row.recordcount>
				<cfset prod_amount=get_inv_row.amount>
			</cfif>
		</cfif>
		<cfoutput>
			<tr class="color-row">
				<cfif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 9>
					<cfset row_detail ="#Evaluate('invoice_date_#ListGetAt(attributes.line_id,i)#')# - #pro_name# Prim Hakedişi"> 
				<cfelseif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 10>
					<cfset row_detail ="#Evaluate('invoice_date_#ListGetAt(attributes.line_id,i)#')# - #pro_name# Mal Fazlası Hakedişi"> 
				</cfif> 
				<td width="150"><input name="product_detail_#ListGetAt(attributes.line_id,i)#" id="product_detail_#ListGetAt(attributes.line_id,i)#" type="text"  value="<cfif isdefined("row_detail")>#row_detail#<cfelse><cfif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) neq 6>FT NO:#Evaluate('invoice_number_#ListGetAt(attributes.line_id,i)#')# -</cfif> #Evaluate('invoice_date_#ListGetAt(attributes.line_id,i)#')# - #pro_name# <cfif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) neq 6><cfif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 1><cf_get_lang dictionary_id='50718.Koşul'><cfelseif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 2><cf_get_lang dictionary_id='33119.Aksiyon'><cfelseif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 3><cf_get_lang dictionary_id="57611.Sipariş"><cfelseif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 4><cf_get_lang dictionary_id="58084.Fiyat"><cfelseif Evaluate("diff_type_"&ListGetAt(attributes.line_id,i)) eq 5><cf_get_lang dictionary_id='57648.Kur'></cfif> <cf_get_lang dictionary_id='56964.Farkı'><cfelse> <cf_get_lang dictionary_id='57335.Fiyat Koruma'></cfif></cfif>" style="width:220px;"></td>
				<td width="165" nowrap>
					<input name="stock_id_#ListGetAt(attributes.line_id,i)#" id="stock_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("stock_id_"&ListGetAt(attributes.line_id,i))#'>
					<input name="product_id_#ListGetAt(attributes.line_id,i)#" id="product_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("product_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="product_name#ListGetAt(attributes.line_id,i)#" id="product_name#ListGetAt(attributes.line_id,i)#" type="text"  value="#pro_name#" style="width:150px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names&product_id=add_invoice_control.product_id_#ListGetAt(attributes.line_id,i)#&field_id=add_invoice_control.stock_id_#ListGetAt(attributes.line_id,i)#&field_name=add_invoice_control.product_name#ListGetAt(attributes.line_id,i)#&is_hizmet=1&non_envanter=1</cfoutput>','medium');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> 
				</td>
				<td  nowrap style="text-align:right;"><cfif isdefined('prod_amount')>#TLFormat(Evaluate("invoice_amount_#ListGetAt(attributes.line_id,i)#")/prod_amount)# #session.ep.money#</cfif></td>
				<td style="text-align:right;">#Evaluate("tax_#ListGetAt(attributes.line_id,i)#")#</td>
				<td style="text-align:right;"><cfif isdefined('prod_amount')>#prod_amount#</cfif></td>
				<td nowrap style="text-align:right;">
					#TLFormat(Evaluate("invoice_amount_#ListGetAt(attributes.line_id,i)#"))# #session.ep.money#
					<input name="tax_#ListGetAt(attributes.line_id,i)#" id="tax_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("tax_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="project_id_#ListGetAt(attributes.line_id,i)#" id="project_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("project_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="project_name_#ListGetAt(attributes.line_id,i)#" id="project_name_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("project_name_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="line_id" id="line_id" type="hidden" value='#ListGetAt(attributes.line_id,i)#'>
					<input name="contract_row_id_#ListGetAt(attributes.line_id,i)#" id="contract_row_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("contract_row_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="invoice_id_#ListGetAt(attributes.line_id,i)#" id="invoice_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("invoice_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="is_diff_price_#ListGetAt(attributes.line_id,i)#" id="is_diff_price_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("is_diff_price_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="is_diff_discount_#ListGetAt(attributes.line_id,i)#" id="is_diff_discount_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("is_diff_discount_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="diff_type_#ListGetAt(attributes.line_id,i)#" id="diff_type_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("diff_type_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="invoice_number_#ListGetAt(attributes.line_id,i)#" id="invoice_number_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("invoice_number_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="invoice_amount_#ListGetAt(attributes.line_id,i)#" id="invoice_amount_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#wrk_round(Evaluate("invoice_amount_#ListGetAt(attributes.line_id,i)#"))#'>
					<input name="invoice_amount_other_#ListGetAt(attributes.line_id,i)#" id="invoice_amount_other_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#wrk_round(Evaluate("invoice_amount_other_#ListGetAt(attributes.line_id,i)#"))#'>
					<input name="invoice_row_id_#ListGetAt(attributes.line_id,i)#" id="invoice_row_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("invoice_row_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="invoice_date_#ListGetAt(attributes.line_id,i)#" id="invoice_date_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("invoice_date_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="other_money_#ListGetAt(attributes.line_id,i)#" id="other_money_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("other_money_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="cost_id_#ListGetAt(attributes.line_id,i)#" id="cost_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("cost_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="due_diff_id_#ListGetAt(attributes.line_id,i)#" id="due_diff_id_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("due_diff_id_#ListGetAt(attributes.line_id,i)#")#'>
					<input name="amount_#ListGetAt(attributes.line_id,i)#" id="amount_#ListGetAt(attributes.line_id,i)#" type="hidden" value='#Evaluate("amount_#ListGetAt(attributes.line_id,i)#")#'>
				</td>
				<td nowrap style="text-align:right;">#TLFormat(Evaluate("invoice_amount_other_#ListGetAt(attributes.line_id,i)#"))# #Evaluate("other_money_#ListGetAt(attributes.line_id,i)#")#</td>
			</tr>
		</cfoutput>
	</cfloop>
			<tr class="color-list">
				<td colspan="7" class="form-title" style="text-align:right;"><cf_workcube_buttons is_upd="0"></td>
			</tr>
	</table>			
	</td>
</tr>
</table>
</cfform>
