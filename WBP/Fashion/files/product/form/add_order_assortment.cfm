<style>
	.table, th, td {
		  border: 0px solid white;
		}
</style>
<cf_xml_page_edit fuseact="product.form_add_product">
	<cfparam name="attributes.property_color_id" default="">
	<cfparam name="attributes.property_size_id" default="">
	
	<cfparam name="attributes.beden_id" default="">
	<cfparam name="attributes.renk_id" default="">
	<cfparam name="attributes.all_properties" default="">
	<cfparam name="attributes.profile" default="">
	<!--- Urun Ozelliklerini Getirir  --->
	<!--- Guncellemede, kategoriye yeni bir ozellik eklendiginde buraya gelmiyordu, bu sekilde , olmayanlarin gelmesi seklinde unionli bir duzenleme yapilmis--->
	<cfquery name="get_property" datasource="#dsn1#">
		SELECT 
			PRODUCT_PROPERTY.PROPERTY_ID,
			PRODUCT_PROPERTY.PROPERTY,
			PRODUCT_PROPERTY.PROPERTY_SIZE,
			PRODUCT_PROPERTY.PROPERTY_COLOR,
			PRODUCT_PROPERTY.PROPERTY_LEN
		FROM 
			PRODUCT_CAT_PROPERTY,
			PRODUCT_PROPERTY,
			PRODUCT AS PRODUCT
		WHERE 
			PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
			PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID AND
			PRODUCT.PRODUCT_ID = #attributes.pid#
		UNION
		SELECT 
			PRODUCT_DT_PROPERTIES.PROPERTY_ID,
			PRODUCT_PROPERTY.PROPERTY,
			PRODUCT_PROPERTY.PROPERTY_SIZE,
			PRODUCT_PROPERTY.PROPERTY_COLOR,
			PRODUCT_PROPERTY.PROPERTY_LEN
		FROM 
			PRODUCT_DT_PROPERTIES,
			PRODUCT_PROPERTY
		WHERE
			PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
			PRODUCT_DT_PROPERTIES.PRODUCT_ID = #attributes.pid#
	</cfquery>
	 <cfquery name="get_property_id" datasource="#dsn1#">
		SELECT PROPERTY_ID FROM PRODUCT_DT_PROPERTIES WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery> 
	<cfset property_id_list = valuelist(get_property_id.property_id,',')>
	<cfquery dbtype="query" name="get_color_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property WHERE PROPERTY_COLOR = 1
	</cfquery>
	<cfquery dbtype="query" name="get_size_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property WHERE PROPERTY_SIZE = 1
	</cfquery>
	<cfquery dbtype="query" name="get_len_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property WHERE PROPERTY_LEN = 1
	</cfquery>
	
	<cfif not get_color_property.recordcount or not get_size_property.recordcount or not get_len_property.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='38016.Ürün Renk ve Beden Özelliklerini Giriniz'>");
			window.close();
		</script>
		<cfabort>
	</cfif>
	
	<cfquery name="get_color_property_dett" datasource="#dsn1#"> 
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_color_id') and len(attributes.property_color_id)>#attributes.property_color_id#<cfelse>#get_color_property.property_id#</cfif>
		
	</cfquery>
	<cfquery name="get_size_property_dett" datasource="#dsn1#">
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> 		
	</cfquery>
	<cfquery name="get_len_property_dett" datasource="#dsn1#">
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL,PRPT_ID FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property.property_id#"></cfif> 		
	</cfquery>
	
	<cfif len(attributes.profile)>
	<cfquery name="get_proifle_det" datasource="#dsn#">
	SELECT * FROM TEXTILE_SIZE_PROFILE WHERE PROFILEID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#attributes.profile#'>
	</cfquery>
	</cfif>
	
	<cfquery name="get_color_property_det" dbtype="query"> 
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_color_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_color_id') and len(attributes.property_color_id)>#attributes.property_color_id#<cfelse>#get_color_property.property_id#</cfif>
		<cfif len(attributes.renk_id)> AND PROPERTY_DETAIL_ID IN(#attributes.renk_id#)</cfif>
	</cfquery>

<cfquery name="get_size_property_det" dbtype="query">
	SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_size_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> 
		<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
</cfquery>
<cfquery name="get_len_property_det" dbtype="query">
	SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_len_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property.property_id#"></cfif> 
		<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
</cfquery>

<cfquery name="get_stock_property" datasource="#dsn3#">
	SELECT
			RENK.PROPERTY_DETAIL AS RENK_,
			RENK.PROPERTY_DETAIL_ID AS RENK_ID,
			BEDEN.PROPERTY_DETAIL AS BEDEN_,
			BEDEN.PROPERTY_DETAIL_ID AS BEDEN_ID,
			BEDEN.PROPERTY_DETAIL_CODE,
			BOY.PROPERTY_DETAIL AS BOY_,
			BOY.PROPERTY_DETAIL_ID AS BOY_ID,
			STOCKS.STOCK_ID,
			ASSORTMENT.ORDER_AMOUNT,
			ISNULL(ASSORTMENT.ASSORTMENT_AMOUNT,1) AS SUM_ASSORTMENT_AMOUNT,
			ISNULL(ASSORTMENT.STOCK_AMOUNT,1) AS ASSORTMENT_AMOUNT
		FROM 
			#dsn1#.STOCKS
			OUTER APPLY
			(
				SELECT 
					PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
					PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
					PPD.PRPT_ID,
					PPD.PROPERTY_DETAIL_CODE
				FROM
					#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
					#dsn1#.PRODUCT_PROPERTY PRP,
					STOCKS_PROPERTY SP
				WHERE
					PRP.PROPERTY_ID = PPD.PRPT_ID AND
					SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
					PRP.PROPERTY_COLOR = 1 AND 
					SP.STOCK_ID = STOCKS.STOCK_ID 
			) AS RENK
			OUTER APPLY
			(
				SELECT 
					PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
					PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
					PPD.PRPT_ID,
					PPD.PROPERTY_DETAIL_CODE
				FROM
					#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
					#dsn1#.PRODUCT_PROPERTY PRP,
					STOCKS_PROPERTY SP
				WHERE
					PRP.PROPERTY_ID = PPD.PRPT_ID AND
					SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
					PRP.PROPERTY_SIZE = 1 AND 
					SP.STOCK_ID = STOCKS.STOCK_ID 
			) AS BEDEN
			OUTER APPLY
			(
				SELECT 
					PRP.PROPERTY_ID,PRP.PROPERTY,PRP.PROPERTY_SIZE,PRP.PROPERTY_CODE,PRP.IS_ACTIVE,
					PPD.PROPERTY_DETAIL,PPD.PROPERTY_DETAIL_ID ,
					PPD.PRPT_ID,
					PPD.PROPERTY_DETAIL_CODE
				FROM
					#dsn1#.PRODUCT_PROPERTY_DETAIL PPD,
					#dsn1#.PRODUCT_PROPERTY PRP,
					STOCKS_PROPERTY SP
				WHERE
					PRP.PROPERTY_ID = PPD.PRPT_ID AND
					SP.PROPERTY_DETAIL_ID = PPD.PROPERTY_DETAIL_ID AND 
					PRP.PROPERTY_LEN = 1 AND 
					SP.STOCK_ID = STOCKS.STOCK_ID 
			) AS BOY
			OUTER APPLY
			(
				SELECT 
					ORDER_AMOUNT,
					ASSORTMENT_AMOUNT,
					STOCK_AMOUNT
					
				FROM
					#dsn3#.TEXTILE_ASSORTMENT
				WHERE
					STOCK_ID = STOCKS.STOCK_ID AND
					REQUEST_ID=#attributes.req_id#
			) AS ASSORTMENT
		WHERE 
			STOCKS.STOCK_STATUS = 1 AND
			STOCKS.PRODUCT_ID=#attributes.pid# AND
			RENK.PROPERTY_DETAIL_ID IS NOT NULL AND
			BEDEN.PROPERTY_DETAIL IS NOT NULL
		ORDER BY BEDEN.PROPERTY_DETAIL_CODE 
</cfquery>

<cfquery name="stokOzellikRenBoy" dbtype="query">
		select DISTINCT RENK_,RENK_ID,BOY_,BOY_ID,ORDER_AMOUNT,SUM_ASSORTMENT_AMOUNT from get_stock_property
</cfquery>
<cfquery name="stokOzellikBeden" dbtype="query">
		select DISTINCT BEDEN_,BEDEN_ID from get_stock_property order by BEDEN_
</cfquery>

			
		

<cfset pageHead = 'Asorti Order'>
<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box>
<cfform class="form-inline" name="add_part" id="add_part" method="post" action="#request.self#?fuseaction=textile.emtypopup_add_order_assortment&product_id=#attributes.pid#&pcode=#attributes.pcode#&size_detail_id=#get_size_property.property_id#&color_detail_id=#get_color_property.property_id#&len_detail_id=#get_len_property.property_id#&type_id=#attributes.type_id#">
			<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="table-responsive" >
					<table style="table-layout: fixed; width: 100%;">
						<tr>
							<td>
									<cf_grid_list class="table table-hover" >
										<input type="hidden" name="req_id" value="<cfoutput>#attributes.req_id#</cfoutput>">
										<input type="hidden" name="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
										<input type="hidden" name="partner_id" value="<cfoutput>#attributes.partner_id#</cfoutput>">
										<input type="hidden" name="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>">
										<input type="hidden" name="recordnum" id="recordnum" value="<cfoutput>#stokOzellikRenBoy.recordcount#</cfoutput>">
										<input type="hidden" name="recordnum_size" id="recordnum_size" value="<cfoutput>#stokOzellikBeden.recordcount#</cfoutput>">
									
										<thead>
											
											<th><cf_get_lang dictionary_id='35843.Renk'> </th>
											<th><cf_get_lang dictionary_id='39511.Boy'>/ <cf_get_lang dictionary_id='36589.Beden'></th>
											<cfoutput query="stokOzellikBeden">
												<th>#stokOzellikBeden.BEDEN_#</th>
											</cfoutput>
											<th><cf_get_lang dictionary_id='62907.Asorti Miktarı'></th>
											<th><cf_get_lang dictionary_id='38564.Sipariş Miktarı'></th>
										</thead>
										<tbody id="table">
										<cfif stokOzellikRenBoy.recordcount gt 0>
											<cfoutput query="stokOzellikRenBoy">
											
												<tr>
													
													<td>
														<!---<select name="color_id#stokOzellikRenBoy.currentrow#">
															<cfloop query="get_color_property_det">
																<option value="#get_color_property_det.PROPERTY_DETAIL_ID#" <cfif stokOzellikRenBoy.renk_id eq  get_color_property_det.PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
															</cfloop>
														</select>--->
														#renk_#
														<input type="hidden" name="color_id#stokOzellikRenBoy.currentrow#" value="#stokOzellikRenBoy.renk_id#">
													</td>
													</td>
													<td>
														<!---<select style="text-align:right;width:50px;" name="len_id#stokOzellikRenBoy.currentrow#">
															<cfloop query="get_len_property_det">
																<option value="#get_len_property_det.PROPERTY_DETAIL_ID#" <cfif stokOzellikRenBoy.boy_id eq  get_len_property_det.PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
															</cfloop>
														</select>--->
														#boy_#
														<input type="hidden" name="len_id#stokOzellikRenBoy.currentrow#" value="#stokOzellikRenBoy.boy_id#">
													</td>
													<cfset birasortimiktar=0>
													<cfloop query="stokOzellikBeden">
													<cfquery name="get_stock" dbtype="query">
														select *from get_stock_property
														WHERE 
															
															RENK_ID=#stokOzellikRenBoy.RENK_ID# AND
															BEDEN_ID=#stokOzellikBeden.BEDEN_ID#
													</cfquery>
														<td>
														<input type="hidden" style="text-align:right;width:60px;" class="box" readonly name="assortment_orj#stokOzellikRenBoy.currentrow#_#stokOzellikBeden.currentrow#" id="assortment_orj#stokOzellikRenBoy.currentrow#_#stokOzellikBeden.currentrow#"    value="#get_stock.ASSORTMENT_AMOUNT#">
														<input type="text" style="text-align:right;width:60px;" <cfif not len(get_stock.stock_id)>readonly class="box"</cfif>  name="assortment#stokOzellikRenBoy.currentrow#_#stokOzellikBeden.currentrow#" id="assortment#stokOzellikRenBoy.currentrow#_#stokOzellikBeden.currentrow#" onblur="asorti_hesapla('#stokOzellikRenBoy.currentrow#')"     value="#get_stock.ASSORTMENT_AMOUNT#">
														<input type="hidden" name="assortment_id#stokOzellikRenBoy.currentrow#_#stokOzellikBeden.currentrow#" value="#stokOzellikBeden.BEDEN_ID#">
														<input type="hidden" name="stock_id#stokOzellikRenBoy.currentrow#_#stokOzellikBeden.currentrow#" value="#get_stock.stock_id#">
														</td>
														<!---<cfset birasortimiktar=birasortimiktar+get_stock.ASSORTMENT_AMOUNT>--->
													</cfloop>
														<td>
															<input type="hidden" name="birasortimiktar#stokOzellikRenBoy.currentrow#"  id="birasortimiktar#stokOzellikRenBoy.currentrow#" value="#birasortimiktar#">
															<input type="text" style="text-align:right;width:60px;"  name="assortment_amount#stokOzellikRenBoy.currentrow#" id="assortment_amount#stokOzellikRenBoy.currentrow#" onblur="asorti_hesapla('#stokOzellikRenBoy.currentrow#')"    value="#SUM_ASSORTMENT_AMOUNT#">
														</td>
														<td>
															<input type="text" style="text-align:right;width:60px;" class="box" name="order_amount#stokOzellikRenBoy.currentrow#" id="order_amount#stokOzellikRenBoy.currentrow#" readonly  value="#ORDER_AMOUNT#">
														</td>
														
												</tr>
											</cfoutput>
											<cfelse>
												<tr><td colspan="4"><i class="fa fa-exclamation-triangle" aria-hidden="true"></i><cf_get_lang dictionary_id='62908.Sipariş oluşturulabilecek kayıtlı asorti stoğu bulunamadı'>! </td></tr>
											</cfif>
										
										</tbody>
									</cf_grid_list>
							</td>
						</tr>
					</table>
					 
				</div>
			</div>
			<cf_box_footer>
						<div class="col col-3" align="left">
    		           
							<!---<cf_workcube_buttons type_format='1' is_cancel='0' insert_info='#search#' insert_alert = '' add_function='control()'>
                           
							<button class="btn btn-primary" name="siparis_olustur" type="button" onclick="addsales(0);">Sipariş Oluştur</button>
							--->
						</div>
							<div class="col col-3" align="left">
							<!----<button class="btn btn-primary" name="teklif_olustur" type="button" onclick="addsales(1);">Teklif Oluştur</button>--->
                    	</div>
                    	<div class="col col-6" align="right">
    		           
							<!---<cf_workcube_buttons type_format='1' is_cancel='0' insert_info='#search#' insert_alert = '' add_function='control()'>--->
                           
						<!---	
						--->
							<cf_workcube_buttons is_upd='0'  add_function='kontrol()'>
                    	</div>
                    </cf_box_footer>
<cfif isdefined("attributes.req_id")>
	<cfquery name="get_related_order" datasource="#dsn3#">
		SELECT *FROM 
			ORDERS
		WHERE ORDER_ID 
				IN(
				SELECT ORDER_ID FROM ORDER_ROW
				WHERE RELATED_ACTION_ID=#attributes.req_id# AND RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST'
				)
	</cfquery>

</cfif>

				<!---	<cfdump var="#stokOzellikRenBoy#">
<cfdump var="#get_stock_size#">
			<cfabort>--->
</cfform>
</cf_box>
</div>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cf_box title="#getLang('','İlişkili siparişler','32837')#">
	<cf_flat_list>
		<thead><tr><th>&nbsp;</th></tr></thead>
		<tbody><tr>
		<cfif get_related_order.recordcount>
		<cfoutput query="get_related_order">
			<td><a href="#request.self#?fuseaction=sales.list_order&event=upd&order_id=#order_id#" class="tableyazi">#order_number#</a></td>
		</cfoutput>
		<cfelse>
			<td><cf_get_lang dictionary_id='57484.Kayıt Yok'></td>
		</cfif>
	</tr>
	</tbody>
	</cf_flat_list>
</cf_box>
</div>
	<script>
		<cfif isdefined("attributes.send_order")>
				addsales(0);
		</cfif>
function addsales(tip)
		{
			<!--- <cfif not isdefined("attributes.send_order")>
				add_part.submit();
			<cfelse> --->
				if(tip==0)
					add_part.action="<cfoutput>#request.self#?fuseaction=sales.list_order&event=add&order_id=&assorment=&req_id=#attributes.req_id#&ref_no=#attributes.req_id#&convert_products_id=1&convert_stocks_id=1&priority_id=#attributes.type_id#</cfoutput>";
				else
					add_part.action="<cfoutput>#request.self#?fuseaction=sales.list_offer&event=add&assorment=&req_id=#attributes.req_id#</cfoutput>";

					add_part.submit();
			<!--- </cfif> --->
		}
	
		function asorti_hesapla(no)
		{
		degisiklikvarmi=1;
		siparismiktar=0;
		birasortimiktar=document.getElementById('birasortimiktar'+no).value;
		asortimiktar=document.getElementById('assortment_amount'+no).value;
		/*for(var i=1;i<=document.getElementById('recordnum').value;i++)
			{*/
				for(var j=1;j<=document.getElementById('recordnum_size').value;j++)
				{
					var miktar=document.getElementById('assortment'+no+'_'+j).value;
					if(miktar=='' || miktar.lenght==0)
					miktar=0;
					siparismiktar=siparismiktar+(parseFloat(miktar)*parseFloat(asortimiktar));
				}
				document.getElementById('order_amount'+no).value=siparismiktar;											
			//}
		}
		asorti_hesapla_all();
		function asorti_hesapla_all()
		{
		
		for(var i=1;i<=document.getElementById('recordnum').value;i++)
			{
			asortimiktar=document.getElementById('assortment_amount'+i).value;
			if(asortimiktar.length==0)
			asortimiktar=1;
			siparismiktar=0;
				for(var j=1;j<=document.getElementById('recordnum_size').value;j++)
				{
					var miktar=document.getElementById('assortment'+i+'_'+j).value;
					if(miktar=='' || miktar.lenght==0)
					miktar=0;
					siparismiktar=siparismiktar+(parseFloat(miktar)*parseFloat(asortimiktar));
				}
				document.getElementById('order_amount'+i).value=siparismiktar;
															
			}
		}					
	</script>