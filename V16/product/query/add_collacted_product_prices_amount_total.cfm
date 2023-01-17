<cfif form.active_company neq session.ep.company_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='862.İşlemin Muhasebe Dönemi İle Aktif Muhasebe Döneminiz Farklı'>...<cf_get_lang no ='863.Muhasebe Döneminizi Kontrol Ediniz'>!");
		window.location.href='<cfoutput>#request.self#?fuseaction=product.collacted_product_prices</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfif isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
	<cfset attributes.start_date = date_add("h", attributes.start_clock, attributes.start_date)>
	<cfset attributes.start_date = date_add("n", attributes.start_min, attributes.start_date)>
</cfif>
<cfset product_id_list =''>
<cflock name="#createuuid()#" timeout="180">
	<cftransaction>
			<cfloop list="#attributes.price_cat_list#" index="p_cat_id"><!--- Fiyat listeleri dönüyor --->
				<cfif isdefined('attributes.price_cat_product_list_#p_cat_id#') and len(evaluate('attributes.price_cat_product_list_#p_cat_id#'))>
					<cfset product_id_list = listappend(product_id_list,evaluate('attributes.price_cat_product_list_#p_cat_id#'),',')>
					<cfloop list="#evaluate('attributes.price_cat_product_list_#p_cat_id#')#" index="product_id">
						<cfif filterNum(evaluate('attributes.ref_price_#product_id#'),session.ep.our_company_info.sales_price_round_num) gt 0>
						<!--- referans fiyat 0 dan büyük ise kayıt yapar--->
							<cfquery datasource="#dsn3#" name="new_price_add_method" timeout="600">
								exec add_price
										#product_id#,
										#Evaluate('attributes.unit_id_#product_id#')#,
										#p_cat_id#,
										#attributes.start_date#,
										#Evaluate('attributes.sales_price_list_#product_id#_#p_cat_id#')#,
										#Evaluate('attributes.sales_money_#product_id#')#,
										1,
										#Evaluate('attributes.sales_price_list_kdv_#product_id#_#p_cat_id#')#,
										-1,
										#session.ep.userid#,
										'#cgi.remote_addr#',
										0,
										0,
										0
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>	
	</cftransaction>
</cflock>
<!--- sürec icin fiyat eklenen urunlerden birazının ismi alındı uyarıd yazsın diye... --->
<cfquery name="get_prod_name" datasource="#dsn1#" maxrows="5">
	SELECT PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID IN (#product_id_list#)
</cfquery>
<cfset prod_name_list= ''>
<cfoutput query="get_prod_name">
	<cfset prod_name_list=prod_name_list&'#PRODUCT_NAME#,'>
</cfoutput>
<cf_workcube_process 
	is_upd='1' 
	process_stage='#attributes.process_stage#' 
	record_member='#session.ep.userid#'
	record_date='#now()#' 
	action_page='#request.self#?fuseaction=product.collacted_product_prices_total'
	action_id='#product_id_list#' 
	old_process_line='0'
	warning_description='Toplu Ürün Fiyat Ekleme : #prod_name_list#'>
<script type="text/javascript">
	window.location = '<cfoutput>#request.self#?fuseaction=product.collacted_product_prices&event=add-total</cfoutput>';
</script>
