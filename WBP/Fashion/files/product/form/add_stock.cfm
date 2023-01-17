
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
			alert("Ürün Renk,Boy ve Beden Özelliklerini Giriniz ! !");
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

<cfquery name="get_size_property_det_selecotor" dbtype="query">
	SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_size_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> 
	ORDER BY PROPERTY_DETAIL 
		<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
		
</cfquery>
<cfquery name="get_len_property_det_selecotor" dbtype="query">
	SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_len_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property.property_id#"></cfif> 
		<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
		ORDER BY PROPERTY_DETAIL 
</cfquery>
<cfquery name="get_size_property_det" dbtype="query">
	SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_size_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> 
		<cfif len(attributes.profile) and get_proifle_det.recordCount>
			AND PROPERTY_DETAIL_ID IN (#get_proifle_det.WEIGHTS#)
		</cfif>
	ORDER BY PROPERTY_DETAIL 
		<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
</cfquery>
<cfquery name="get_len_property_det" dbtype="query">
	SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM get_len_property_dett WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_len_property.property_id#"></cfif> 
		<cfif len(attributes.beden_id)> AND PROPERTY_DETAIL_ID IN(#attributes.beden_id#)</cfif>
		<cfif len(attributes.profile) and get_proifle_det.recordCount>
			AND PROPERTY_DETAIL_ID IN (#get_proifle_det.LENGTHS#)
		</cfif>
		ORDER BY PROPERTY_DETAIL 
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
	
	ISNULL(STOCKS.ASSORTMENT_AMOUNT,0) ASSORTMENT_AMOUNT
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
WHERE 
	STOCKS.STOCK_STATUS = 1 AND
	STOCKS.PRODUCT_ID=#attributes.pid# AND
	RENK.PROPERTY_DETAIL_ID IS NOT NULL AND
	BEDEN.PROPERTY_DETAIL IS NOT NULL
	ORDER BY BEDEN.PROPERTY_DETAIL_CODE 
</cfquery>
		
		<cfquery name="stokOzellikRenBoy" dbtype="query">
				select DISTINCT RENK_,RENK_ID,BOY_,BOY_ID from get_stock_property 
		</cfquery>
<cfset pageHead = 'Toplu Stok'>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="frmProfile" id="frmProfile" method="post" action="#request.self#?fuseaction=textile.list_sample_request&event=add_profile" style="width: 100%;">
			<cfinput type="hidden" name="pid" value="#attributes.pid#">
			<cfinput type="hidden" name="pcode" value="#attributes.pcode#">
			<cfinput type="hidden" name="req_id" value="#attributes.req_id#">
			<cfinput type="hidden" name="profileid" value="#attributes.profile#">
			<cf_box_elements>
			<!--- <div class="col col-12">
				<b>Profil Oluştur</b>
			</div> --->
			<div class="col col-3" type="column" index="" sort="true">
				<div class="form-group" id="item-txt_head">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58233.Tanım'></label>
					<div class="col col-8 col-xs-12">
						<cfinput type="text" name="txt_head" id="txt_head" value="#iIf(len(attributes.profile), "get_proifle_det.HEAD", de(""))#" />
					</div>
				</div>
			</div>
			<div class="col col-3" type="column" index="" sort="true">			
				<div class="form-group" id="item-chk_sizes">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36589.Beden'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check
						name="chk_sizes"
						query_name="get_size_property_det_selecotor"
						option_name="PROPERTY_DETAIL"
						option_value="PROPERTY_DETAIL_ID"
						option_text="#getLang('','','36589')#"
						value="#iIf(len(attributes.profile), "get_proifle_det.WEIGHTS", de(""))#"
						>
					</div>
				</div>
			</div>
			<div class="col col-3" type="column" index="" sort="true">			
				<div class="form-group" id="item-chk_lens">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='39511.Boy'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check
						name="chk_lens"
						query_name="get_len_property_det_selecotor"
						option_name="PROPERTY_DETAIL"
						option_value="PROPERTY_DETAIL_ID"
						option_text="#getLang('','','39511')#"
						value="#iIf(len(attributes.profile), "get_proifle_det.LENGTHS", de(""))#"
						>
					</div>
				</div>
			</div>
		</cf_box_elements>		
		<cf_box id="buttonsbar" >
				<div class="ui-form-list-btn" id="item-">
					<div>
						<cfif len(attributes.profile)>
							<cfinput type="submit" name="opr" class="ui-btn ui-btn-success" value="#getLang('','Güncelle','57464')#">
						<cfelse>
								<cfinput type="submit" name="opr" class="ui-btn ui-btn-success" value="#getLang('','Kaydet','57461')#">
						</cfif>
					</div>
					<div>
						<cfif len(attributes.profile)><cfinput type="submit" class="ui-btn ui-btn-success" value="#getLang('','Sil','57463')#" name="opr"></cfif>
					</div>
					<div>
					<a class="ui-btn ui-btn-delete" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_property&event=add-sub-property&prpt_id=3','page')"><font color="white"><cf_get_lang dictionary_id='36557.Renk Ekle'></font></a></div>
					</div>
				</div>
		</cf_box>
	</cfform>
		<!--- <cfform class="form-inline">
			<div class="row" type="row">
			   <div class="col col-4 col-md-4 col-sm-6 col-xs-6">
				  <div class="form-group">
					<div class="input-group">
					  <input type="text" class="form-control" style="width:10mm;" id="parcasayisi" value="0" placeholder="miktar">
					  <div class="input-group-addon">Satir Ekle</div>
					</div>
				  </div>
				</div>
				<div class="col col-8 col-md-4 col-sm-6 col-xs-6">
					 <div class="form-group">
						<div class="input-group">
						<a class="btn btn-primary " href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=product.list_property&event=add-sub-property&prpt_id=3','page')"><font color="white">Renk Ekle</font></a></div>
					</div>
				  </div>
				</div>
			</div>
		</cfform> --->
	</cf_box>	
</div>
<cfsavecontent  variable="message"><cf_get_lang dictionary_id='62909.Kayıtlı Profiller'>
</cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#">	
		<cfquery name="get_profile_list" datasource="#dsn#">
		SELECT * FROM TEXTILE_SIZE_PROFILE
		</cfquery>
		<cf_flat_list>
			<tr><th style="text-align:left;"><!--- <cf_get_lang dictionary_id='62909.Kayıtlı Profiller'> --->&nbsp;</th></tr>
			<cfoutput query="get_profile_list">
				<tr><td><a href="index.cfm?fuseaction=textile.list_sample_request&event=add_stock&pid=#attributes.pid#&pcode=#attributes.pcode#&req_id=#attributes.req_id#&profile=#PROFILEID#">#len(HEAD)?HEAD:'isimsiz'#</a></td></tr>
			</cfoutput>
		</cf_flat_list>
	</cf_box>
</div>
	<cfsavecontent  variable="message"><cf_get_lang dictionary_id='62905.Asorti Stoğu'>
	</cfsavecontent>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#message#">

	<cfform class="form-inline" name="add_part" id="add_part" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_sub_stock_code&product_id=#attributes.pid#&pcode=#attributes.pcode#&size_detail_id=#get_size_property.property_id#&color_detail_id=#get_color_property.property_id#&len_detail_id=#get_len_property.property_id#">
			<div class="col-md-12 col-sm-12 col-xs-12">
				<div class="table-responsive" >
					<table style="table-layout: fixed; width: 100%;">
						<tr>
							<td>
								<div class="fixed-table-wrapper">
								<div class="fixed-table">
									<cf_grid_list class="table table-hover" >
										<input type="hidden" name="recordnum" id="recordnum" value="<cfoutput>#stokOzellikRenBoy.recordcount#</cfoutput>">
										<input type="hidden" name="recordnum_size" value="<cfoutput>#get_size_property_det.recordcount#</cfoutput>">
										
										<thead>
											<tr>
												<th width="100"><cf_get_lang dictionary_id='35843.Renk'> </th>
												<th width="200"><cf_get_lang dictionary_id='39511.Boy'>/<cf_get_lang dictionary_id='36589.Beden'></th>
												<cfoutput query="get_size_property_det">
													<th style="text-align: center;">#get_size_property_det.PROPERTY_DETAIL#</th>
												</cfoutput>
												<th width="20"><a href="javascript://" onclick="add_assortment();"><i class="fa fa-plus"></i></a></th>
											</tr>
										</thead>
										<tbody id="table">
										<cfif stokOzellikRenBoy.recordcount gt 0>
											<cfoutput query="stokOzellikRenBoy">
												<tr>
													<td>
														<select name="color_id#stokOzellikRenBoy.currentrow#">
															<cfloop query="get_color_property_det">
																<option value="#get_color_property_det.PROPERTY_DETAIL_ID#" <cfif stokOzellikRenBoy.renk_id eq  get_color_property_det.PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
															</cfloop>
														</select>
													</td>
													
													<td>
														<select  name="len_id#stokOzellikRenBoy.currentrow#">
															<cfloop query="get_len_property_det">
																<option value="#get_len_property_det.PROPERTY_DETAIL_ID#" <cfif stokOzellikRenBoy.boy_id eq  get_len_property_det.PROPERTY_DETAIL_ID>selected</cfif>>#PROPERTY_DETAIL#</option>
															</cfloop>
														</select>
													</td>
													<cfloop query="get_size_property_det">
														<cfquery name="get_stock" dbtype="query">
															select * from get_stock_property
															WHERE 
																RENK_ID=#stokOzellikRenBoy.RENK_ID# AND
																BEDEN_ID=#get_size_property_det.PROPERTY_DETAIL_ID#
														</cfquery>
														<td>
														<input type="checkbox" <cfif len(get_stock.stock_id)>checked disabled</cfif> style="text-align:right;width:30px;" name="assortment#stokOzellikRenBoy.currentrow#_#get_size_property_det.currentrow#"   value="">
														<input type="hidden" name="assortment_id#stokOzellikRenBoy.currentrow#_#get_size_property_det.currentrow#" value="#get_size_property_det.property_detail_id#">
														<input type="hidden" name="stock_id#stokOzellikRenBoy.currentrow#_#get_size_property_det.currentrow#" value="#get_stock.stock_id#">
														</td>
													</cfloop>
														<td></td>
												</tr>
											</cfoutput>
											<cfelse>
												<tr><td colspan="<cfoutput>#get_size_property_det.recordcount+3#</cfoutput>"><cf_get_lang dictionary_id='62911.Kayıtlı asorti stoğu bulunamadı!'> </td></tr>
											</cfif>
										</tbody>
									
									</cf_grid_list>
								</div>
								</div>
								
							</td>
						</tr>
					</table>
				</div>
			</div>
			<div class="row formContentFooter">
				<div class="col col-12" align="right">
					<!---<cf_workcube_buttons type_format='1' is_cancel='0' insert_info='#search#' insert_alert = '' add_function='control()'>--->
					<cf_workcube_buttons is_upd='0'  add_function='kontrol()'>
				</div>
			</div>
				<!---	<cfdump var="#stokOzellikRenBoy#">	<cfdump var="#get_stock_size#">	<cfabort>--->
	</div>
</cfform>
</cf_box>
</div>
	<script>
	var startrow='<cfoutput>#stokOzellikRenBoy.recordcount#</cfoutput>';
		$(document).ready(function(){
			$("#parcasayisi").change(function(){
				var amount=$('#parcasayisi').val();
			
			
			<cfif stokOzellikRenBoy.recordcount eq 0>
				if($('#table tr').length>0)
				$('#table tr').remove();
				startrow=0;
			<cfelse>
				startrow='<cfoutput>#stokOzellikRenBoy.recordcount#</cfoutput>';
				
			</cfif>
					sumrows=parseFloat(startrow)+parseFloat(amount);
					startrow++;
				
				for(var i=startrow;i<=sumrows;i++)
				{
					
					
					var row="<tr>";
					row+='<td ><select name="color_id'+i+'" required><option value="" >Seçiniz</option><cfoutput query="get_color_property_det"><option value="#PROPERTY_DETAIL_ID#">#PROPERTY_DETAIL#</option></cfoutput></select></td>';
					row+='<td><select  required name="len_id'+i+'"><option value="">Seçiniz</option><cfoutput query="get_len_property_det"><option value="#PROPERTY_DETAIL_ID#">#PROPERTY_DETAIL#</option></cfoutput></select></td>';
					<cfoutput query="get_size_property_det">
					row+='<td><input type="checkbox" style="text-align:right;width:30px;" name="assortment'+i+'_#currentrow#"   value=""></td>';
					row+='<input type="hidden" name="assortment_id'+i+'_#currentrow#" value="#get_size_property_det.property_detail_id#">';
					</cfoutput>
					row+='<td></td></tr>';
					
					$('#table').append(row);
				}
				document.getElementById('recordnum').value=sumrows;
			});
			 /* $("#table").on('click','.remtr',function(){
				  $(this).parent().parent().remove();
			});*/
			
		});
		function add_assortment()
		{
		if(startrow==0)
		{
			if($('#table tr').length>0)
				$('#table tr').remove();
				startrow=0;
		}
			startrow++;
			var i=startrow;
					var row="<tr>";
					row+='<td><select name="color_id'+i+'" required><option value="">Seçiniz</option><cfoutput query="get_color_property_det"><option value="#PROPERTY_DETAIL_ID#">#PROPERTY_DETAIL#</option></cfoutput></select></td>';
					row+='<td><select  required name="len_id'+i+'"><option value="">Seçiniz</option><cfoutput query="get_len_property_det"><option value="#PROPERTY_DETAIL_ID#">#PROPERTY_DETAIL#</option></cfoutput></select></td>';
					<cfoutput query="get_size_property_det">
					row+='<td><input type="checkbox" style="text-align:right;width:30px;" name="assortment'+i+'_#currentrow#"   value=""></td>';
					row+='<input type="hidden" name="assortment_id'+i+'_#currentrow#" value="#get_size_property_det.property_detail_id#">';
					</cfoutput>
					row+='<td></td></tr>';
					
					$('#table').append(row);
			document.getElementById('recordnum').value=startrow;
		}
		
	</script>