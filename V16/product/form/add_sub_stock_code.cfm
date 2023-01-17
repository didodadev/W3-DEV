<cf_xml_page_edit fuseact="product.form_add_popup_sub_stock_code">
	<cfparam name="attributes.property_color_id" default="">
	<cfparam name="attributes.property_size_id" default="">
	<cfparam name="attributes.property_collar_id" default="">
	<cfparam name="attributes.property_body_size_id" default="">
	<cfparam name="attributes.all_properties" default="">
	<cfparam name="attributes.product_sample_id" default="">
	<style>
	.ui-scroll .ui-table-list > thead > tr > th {
	
		min-width: 50px;
	}
	</style>
	<!--- Urun Ozelliklerini Getirir  --->
	<!--- Guncellemede, kategoriye yeni bir ozellik eklendiginde buraya gelmiyordu, bu sekilde , olmayanlarin gelmesi seklinde unionli bir duzenleme yapilmis--->
	<cfif isDefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
		<cfset comp = createObject("component","Utility.DatabaseInfo") /><cfset Query_result = comp.Query_result(q : 'SELECT SAMPLE_ASORTI_JSON FROM #dsn3#.PRODUCT_SAMPLE where PRODUCT_SAMPLE_ID = #attributes.product_sample_id#')/>

</cfif>
	<cfquery name="get_property" datasource="#dsn1#">
			SELECT 
				PRODUCT_PROPERTY.PROPERTY_ID,
				PRODUCT_PROPERTY.PROPERTY,
				PRODUCT_PROPERTY.PROPERTY_SIZE,
				PRODUCT_PROPERTY.PROPERTY_COLOR,
				PRODUCT_PROPERTY.PROPERTY_COLLAR,
				PRODUCT_PROPERTY.PROPERTY_BODY_SIZE	

			FROM 
				PRODUCT_CAT_PROPERTY,
				PRODUCT_PROPERTY,
				PRODUCT AS PRODUCT
			WHERE 
				PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID AND
				PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID AND
				PRODUCT.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
		<cfif isDefined("attributes.pcatid") and len(attributes.pcatid) >
			UNION
				SELECT 
					PRODUCT_PROPERTY.PROPERTY_ID,
					PRODUCT_PROPERTY.PROPERTY,
					PRODUCT_PROPERTY.PROPERTY_SIZE,
					PRODUCT_PROPERTY.PROPERTY_COLOR,
					PRODUCT_PROPERTY.PROPERTY_COLLAR,
					PRODUCT_PROPERTY.PROPERTY_BODY_SIZE	

				FROM 
					PRODUCT_CAT_PROPERTY 
					LEFT JOIN PRODUCT_PROPERTY ON PRODUCT_PROPERTY.PROPERTY_ID = PRODUCT_CAT_PROPERTY.PROPERTY_ID
					LEFT JOIN PRODUCT AS PRODUCT ON PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = PRODUCT.PRODUCT_CATID
				WHERE 
					PRODUCT_CAT_PROPERTY.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pcatid#">
		</cfif>
		UNION
			SELECT 
				PRODUCT_DT_PROPERTIES.PROPERTY_ID,
				PRODUCT_PROPERTY.PROPERTY,
				PRODUCT_PROPERTY.PROPERTY_SIZE,
				PRODUCT_PROPERTY.PROPERTY_COLOR,
				PRODUCT_PROPERTY.PROPERTY_COLLAR,
				PRODUCT_PROPERTY.PROPERTY_BODY_SIZE	
			FROM 
				PRODUCT_DT_PROPERTIES,
				PRODUCT_PROPERTY
			WHERE
				PRODUCT_DT_PROPERTIES.PROPERTY_ID = PRODUCT_PROPERTY.PROPERTY_ID AND
				PRODUCT_DT_PROPERTIES.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfquery>

	<cfquery dbtype="query" name="get_color_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property <cfif isdefined("xml_size_color")> WHERE PROPERTY_COLOR = 1 </cfif>
	</cfquery>
	<cfquery dbtype="query" name="get_collar_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property <cfif isdefined("xml_size_color")> WHERE PROPERTY_COLLAR = 1 </cfif>
	</cfquery>
	<cfquery dbtype="query" name="get_size_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property <cfif isdefined("xml_size_color")> WHERE PROPERTY_SIZE = 1 </cfif>
	</cfquery>
	<cfquery dbtype="query" name="get_body_size_property">
		SELECT PROPERTY_ID,PROPERTY FROM get_property <cfif isdefined("xml_size_color")> WHERE PROPERTY_BODY_SIZE  = 1 </cfif>
	</cfquery>

<cfif not get_color_property.recordcount or not get_size_property.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='38016.Ürün Renk ve Beden Özelliklerini Giriniz !'> !");
			closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
		</script>
	</cfif>
	<!--- ilgili urunun kayitli tum ozelliklerini getirir, listeler --->
	<cfquery name="get_all_product_propert" datasource="#dsn3#">
		SELECT * FROM STOCKS WHERE PRODUCT_ID = #attributes.pid# ORDER BY RECORD_DATE DESC
	</cfquery>
	<cfset product_property_list = valuelist(get_all_product_propert.property,',')>
	<!--- ilgili urunun kayitli tum ozelliklerini getirir, listeler --->

	<!--- Urun Ozelliklerini Getirir  --->
<!--- 	 --->
	
<cf_box title="#getLang('','Ölçü ve Dağılım Tablosu',63452)#" closable="1" popup_box="1">
	<div class="ui-info-bottom">
		<div class="col col-4 col-md-4 col-xs-12">
			<p><b><cf_get_lang dictionary_id='57657.Ürün'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_NAME#</cfoutput></p>
		</div>
		<div class="col col-4 col-md-4 col-xs-12">
			<p><b><cf_get_lang dictionary_id='58800.Ürün Kodu'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_CODE#</cfoutput></p>
		</div>
		<div class="col col-4 col-md-4 col-xs-12">
			<p><b><cf_get_lang dictionary_id='63453.Ana Stok Kodu'> :</b> <cfoutput>#get_all_product_propert.PRODUCT_CODE#</cfoutput></p>
		</div>
	</div>
	<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
		<cfset colspan = 1>
	
		<cfset asorti_json = deserializeJSON(Query_result.SAMPLE_ASORTI_JSON)>
		<cfset asorti_header = asorti_json.headers>
		<cfset asorti_content = asorti_json.content>
		
		<cfloop from="1" to="#arrayLen(asorti_content)#" index="i">
			<cfset counter_ = 1>
			<cfloop from="2" to="#arrayLen(asorti_content[i])#" index="j">
				<cfset property_= asorti_content[i][j]["assortment_hidden"]>
				<cfset color_= ListGetAt(property_,1,'-') >
				<cfif ListLen(property_,'-') eq 4  >
					<cfset collar= ListGetAt(property_,2,'-')>
					<cfset size_= ListGetAt(property_,3,'-')>
					<cfset body_size_= ListGetAt(property_,4,'-')>
				<cfelse>
					<cfset size_= ListGetAt(property_,2,'-')>
					
				</cfif>
				<cfset counter_++>
				<cfquery name="get_color" datasource="#dsn1#"> 
					SELECT PPD.PRPT_ID,
					PPD.PROPERTY_DETAIL_ID,
					PPD.PROPERTY_DETAIL ,
					PP.PROPERTY,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
					LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
					WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#color_#">
				</cfquery> 
			
				
				<cfif ListLen(property_,'-') eq 4 >
					<cfquery name="get_collar" datasource="#dsn1#"> 
						SELECT PPD.PRPT_ID,
						PPD.PROPERTY_DETAIL_ID,
						PPD.PROPERTY_DETAIL ,
						PP.PROPERTY ,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
						LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
						WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#collar#">
					</cfquery> 
					<cfquery name="get_body_size" datasource="#dsn1#"> 
						SELECT PPD.PRPT_ID,
						PPD.PROPERTY_DETAIL_ID,
						PPD.PROPERTY_DETAIL ,
						PP.PROPERTY ,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
						LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
						WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#body_size_#">
					</cfquery> 
				</cfif>
				
				<cfquery name="get_size" datasource="#dsn1#"> 
					SELECT PPD.PRPT_ID,
					PPD.PROPERTY_DETAIL_ID,
					PPD.PROPERTY_DETAIL ,
					PP.PROPERTY ,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
					LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
					WHERE PROPERTY_DETAIL_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#size_#">
				</cfquery> 
					
			</cfloop>
		</cfloop>
	
		  
			
	</cfif>
	
	<cfif not isDefined("attributes.is_submit") and not isDefined("attributes.is_submit_2")>
		<cfform name="search" method="post" action="#request.self#?fuseaction=product.form_add_popup_sub_stock_code">
			
			<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
			<cfif isDefined("attributes.pcatid") and len(attributes.pcatid)>
				<input type="hidden" name="pcatid" id="pcatid" value="<cfoutput>#attributes.pcatid#</cfoutput>">
			</cfif>
			<cfif isDefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
				<input type="hidden" name="product_sample_id" id="product_sample_id" value="<cfoutput>#attributes.product_sample_id#</cfoutput>">
			</cfif>
			<input type="hidden" name="pcode" id="pcode" value="<cfoutput>#attributes.pcode#</cfoutput>"> 
			<input type="hidden" name="is_auto_barcode" id="is_auto_barcode" value="<cfoutput>#attributes.is_auto_barcode#</cfoutput>">
			<input type="hidden" name="is_submit" value="1">
			<div class="ui-form-list flex-list">
				<div class="form-group">
					<span class="input-group-addon no-bg"><b>X</b></span>&nbsp;&nbsp;
					 <cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
						<select name="property_color_id" id="property_color_id" >
							<cfoutput query="get_color_property">	
								<option value="#property_id#" <cfif property_id eq get_color.property_id>selected</cfif>>#property#</option>
							</cfoutput>
						</select>
					<cfelse> 
						<select name="property_color_id" id="property_color_id" >
							<cfoutput query="get_color_property">	
								<option value="#property_id#" <cfif property_id eq attributes.property_color_id>selected</cfif>>#property#</option>
							</cfoutput>
						</select>
					 </cfif> 
				
					<cfif  xml_color eq 1> 
						 <cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON) and  ListLen(property_,'-') eq 4  >
							<span class="input-group-addon no-bg"></span>
							<select name="property_collar_id" id="property_collar_id" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_collar_property">	
									<option value="#property_id#" <cfif property_id eq get_collar.property_id>selected</cfif>>#property#</option>
								</cfoutput>
							</select>
						<cfelse> 
						<span class="input-group-addon no-bg"></span>
							<select name="property_collar_id" id="property_collar_id" >
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_collar_property">	
									<option value="#property_id#" <cfif property_id eq attributes.property_collar_id>selected</cfif>>#property#</option>
								</cfoutput>
							</select>
						 </cfif> 
					</cfif>
				</div>
				<div class="form-group">
					<span class="input-group-addon no-bg"><b>Y</b></span>&nbsp;&nbsp;
				 <cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
						<select name="property_size_id" id="property_size_id" >
							<cfoutput query="get_size_property">	
								<option value="#property_id#"  <cfif property_id eq get_size.property_id>selected</cfif>>#property#</option>
							</cfoutput>
						</select>
					<cfelse> 
						<select name="property_size_id" id="property_size_id">
							<cfoutput query="get_size_property">	
								<option value="#property_id#"  <cfif property_id eq attributes.property_size_id>selected</cfif>>#property#</option>
							</cfoutput>
						</select>
					</cfif> 
					
						<cfif  xml_size eq 1> 
							<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON) and  ListLen(property_,'-') eq 4  >
								<span class="input-group-addon no-bg"></span>
								<select name="property_body_size_id" id="property_body_size_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_body_size_property">	
										<option value="#property_id#"  <cfif property_id eq get_body_size.property_id>selected</cfif>>#property#</option>
									</cfoutput>
								</select>
							<cfelse> 
							<span class="input-group-addon no-bg"></span>
							<select name="property_body_size_id" id="property_body_size_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_body_size_property">	
									<option value="#property_id#"  <cfif property_id eq attributes.property_body_size_id>selected</cfif>>#property#</option>
								</cfoutput>
							</select>
						 </cfif> 
						
						</cfif>
				</div>
				<!--- <div class="form-group">
					<b><cf_get_lang dictionary_id='57998.Veya'></b>&nbsp;&nbsp;
					<input type="file" name="file" class="otherFile">
				</div> --->
				<div class="form-group">
					<cf_wrk_search_button button_type="2" button_name='#getLang('','Tablo Oluştur',59076)#'  search_function="#iif(isdefined("attributes.draggable"),DE("Control_() && loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
					
				
				</div>
			</div>
		</cfform>
	</cfif>
	<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
		<cfquery name="get_color_property_det" datasource="#dsn1#"> 
			SELECT PPD.PRPT_ID,
			PPD.PROPERTY_DETAIL_ID,
			PPD.PROPERTY_DETAIL ,
			PP.PROPERTY,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
			LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
			WHERE PRPT_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#get_color.PRPT_ID#">ORDER BY PROPERTY_DETAIL ASC
		</cfquery> 
	<cfelse>
		<cfquery name="get_color_property_det" datasource="#dsn1#"> 
			SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_color_id') and len(attributes.property_color_id)>#attributes.property_color_id#<cfelse>#get_color_property.property_id#</cfif> ORDER BY PROPERTY_DETAIL ASC
		</cfquery>
	
	</cfif>
	
	
	<cfquery name="get_collar_property_det" datasource="#dsn1#"> 
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_collar_id') and len(attributes.property_collar_id)>#attributes.property_collar_id#<cfelse>#get_collar_property.property_id#</cfif> ORDER BY PROPERTY_DETAIL ASC
	</cfquery> 
	<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
		<cfquery name="get_size_property_det" datasource="#dsn1#">
			SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_size.PRPT_ID#"> ORDER BY PROPERTY_DETAIL ASC 
		</cfquery>
	<cfelse>
		<cfquery name="get_size_property_det" datasource="#dsn1#">
			SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_size_id') and len(attributes.property_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_size_property.property_id#"></cfif> ORDER BY PROPERTY_DETAIL ASC 
		</cfquery>
	</cfif>
	<cfquery name="get_body_size_property_det" datasource="#dsn1#">
		SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PRPT_ID = <cfif isdefined('attributes.property_body_size_id') and len(attributes.property_body_size_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_body_size_id#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_body_size_property.property_id#"></cfif> ORDER BY PROPERTY_DETAIL ASC 
	</cfquery>
		
	<cfform name="search_" method="post">
		<cfif    not isdefined("Query_result.product_sample_id") and  len(attributes.PROPERTY_COLLAR_ID) >
			<cfset color_matris = get_color_property_det.recordCount * get_collar_property_det.recordCount>
			
		<cfelseif  isdefined("Query_result.product_sample_id") and isdefined("collar")  and  len(collar)>
				<cfset color_matris = get_color_property_det.recordCount * get_collar_property_det.recordCount>
		<cfelse>
			<cfset color_matris = get_color_property_det.recordCount * 1>
		</cfif>
		
		<cfif not  isdefined("Query_result.product_sample_id") and  len(attributes.property_body_size_id) >
			<cfset size_matris = get_size_property_det.recordCount * get_body_size_property_det.recordCount>
		<cfelseif isdefined("Query_result.product_sample_id") and isdefined("body_size_")  and len(body_size_) >
			<cfset size_matris = get_size_property_det.recordCount * get_body_size_property_det.recordCount>
		<cfelse>
			<cfset size_matris = get_size_property_det.recordCount * 1>
		</cfif>
		
		<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>">
		<cfif isDefined("attributes.pcatid") and len(attributes.pcatid)>
			<input type="hidden" name="pcatid" id="pcatid" value="<cfoutput>#attributes.pcatid#</cfoutput>">
		</cfif>
		<cfif isDefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
			<input type="hidden" name="product_sample_id" id="product_sample_id" value="<cfoutput>#attributes.product_sample_id#</cfoutput>">
		</cfif>
		<input type="hidden" name="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
		<input type="hidden" name="pcode" id="pcode" value="<cfoutput>#attributes.pcode#</cfoutput>"> 
		<input type="hidden" name="is_auto_barcode" id="is_auto_barcode" value="<cfoutput>#attributes.is_auto_barcode#</cfoutput>">
		<input type="hidden" name="color_detail_id" value="<cfoutput>#get_color_property.property_id#</cfoutput>">
		<input type="hidden" name="size_detail_id" value="<cfoutput>#get_size_property.property_id#</cfoutput>">
		<input type="hidden" name="collar_detail_id" value="<cfoutput>#attributes.property_collar_id#</cfoutput>">
		<input type="hidden" name="body_size_detail_id" value="<cfoutput>#attributes.property_body_size_id#</cfoutput>">
		<cfif not isDefined("attributes.is_submit") and not isDefined("attributes.is_submit_2")>
			<div class="ui-form-list flex-list">
				<div class="form-group padding-left-30">
					<i class="icon-double-right"></i>
				</div>
			</div>
			<div class="ui-form-list flex-list">
				<div class="form-group padding-bottom-30 padding-right-5">
					<i class="icon-double-right" style="transform:rotate(90deg)"></i>
				</div>
				<div>
					<cf_grid_list table_width="200">
						<thead>
							<tr>
								<th style="text-align:center;color:black;font-weight:bold;" width="120"><cf_get_lang dictionary_id='42263.Dağılım'></th>
								<th style="text-align:center;color:black;font-weight:bold;"><cf_get_lang dictionary_id='57492.Toplam'></th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td style="text-align:center;color:black;font-weight:bold;"><cf_get_lang dictionary_id='57492.Toplam'></td>
								<td style="text-align:center;color:red;font-weight:bold;">0</td>
							</tr>
						</tbody>
					</cf_grid_list>
				</div>
			</div>
		<cfelseif not isDefined("attributes.is_submit_2")>
		
			<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
				<cfset colspan = 1>
				<cfset asorti_json = deserializeJSON(Query_result.SAMPLE_ASORTI_JSON)>
				<cfset asorti_header = asorti_json.headers>
				<cfset asorti_content = asorti_json.content>
				<cfif isdefined("asorti_json.is_delete")>
					<cfset asorti_isdel= asorti_json.is_delete>
				</cfif>
				<cfloop from="1" to="#arrayLen(asorti_content)#" index="i">
					<cfset counter_ = 1>
					<cfloop from="2" to="#arrayLen(asorti_content[i])#" index="j">
						<cfset property_= asorti_content[i][j]["assortment_hidden"]>
						<cfset color_= ListGetAt(property_,1,'-') >
						<cfif ListLen(property_,'-') eq 4  >
							<cfset collar= ListGetAt(property_,2,'-')>
							<cfset size_= ListGetAt(property_,3,'-')>
							<cfset body_size_= ListGetAt(property_,4,'-')>
						<cfelse>
							<cfset size_= ListGetAt(property_,2,'-')>
							
						</cfif>
						<cfset counter_++>
						<cfquery name="get_color" datasource="#dsn1#"> 
							SELECT PPD.PRPT_ID,
							PPD.PROPERTY_DETAIL_ID,
							PPD.PROPERTY_DETAIL ,
							PP.PROPERTY,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
							LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
							WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#color_#">
						</cfquery> 
					
						
						<cfif ListLen(property_,'-') eq 4 >
							<cfquery name="get_collar" datasource="#dsn1#"> 
								SELECT PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_ID,
								PPD.PROPERTY_DETAIL ,
								PP.PROPERTY ,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
								LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
								WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#collar#">
							</cfquery> 
							<cfquery name="get_body_size" datasource="#dsn1#"> 
								SELECT PPD.PRPT_ID,
								PPD.PROPERTY_DETAIL_ID,
								PPD.PROPERTY_DETAIL ,
								PP.PROPERTY ,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
								LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
								WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#body_size_#">
							</cfquery> 
						</cfif>
						
						<cfquery name="get_size" datasource="#dsn1#"> 
							SELECT PPD.PRPT_ID,
							PPD.PROPERTY_DETAIL_ID,
							PPD.PROPERTY_DETAIL ,
							PP.PROPERTY ,PP.PROPERTY_ID FROM PRODUCT_PROPERTY_DETAIL AS PPD 
							LEFT JOIN PRODUCT_PROPERTY AS PP ON PP.PROPERTY_ID=PPD.PRPT_ID
							WHERE PROPERTY_DETAIL_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#size_#">
						</cfquery> 
							
					</cfloop>
				</cfloop>
			<cfelse>
				<cfquery dbtype="query" name="get_color">
					SELECT PROPERTY_ID,PROPERTY FROM get_property where PROPERTY_ID = #attributes.property_color_id#
				</cfquery>
				<cfif len(attributes.property_collar_id)>
					<cfquery dbtype="query" name="get_collar">
						SELECT PROPERTY_ID,PROPERTY FROM get_property where PROPERTY_ID = #attributes.property_collar_id#
					</cfquery>
				</cfif>
					<cfquery dbtype="query" name="get_size">
						SELECT PROPERTY_ID,PROPERTY FROM get_property where PROPERTY_ID = #attributes.property_size_id#
				</cfquery>
				<cfif len(attributes.property_body_size_id)>
					<cfquery dbtype="query" name="get_body_size">
						SELECT PROPERTY_ID,PROPERTY FROM get_property where PROPERTY_ID = #attributes.property_body_size_id#
					</cfquery>
				</cfif>
			</cfif>
			<div class="ui-form-list flex-list">
				<div class="form-group padding-left-30">
					<cfoutput><label class="bold" ><i class="icon-double-right"></i>&nbsp;  #get_color.property# <cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON) and ListLen(property_,'-') eq 4  >- #get_collar.property#<cfelseif len(attributes.property_collar_id)>- #get_collar.property#</cfif></label></cfoutput>
				</div>
			</div>
			<div class="ui-form-list flex-list"style="margin:15px 5px 5px 0!important;" >
				<div class="col-1">
					<div class="form-group">
						<cfoutput><label class="bold" style="transform:rotate(90deg)">&emsp;&emsp;<i class="icon-double-right"></i>&nbsp; #get_size.property# <cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON) and ListLen(property_,'-') eq 4  >- #get_body_size.property#<cfelseif len(attributes.property_body_size_id)> - #get_body_size.property#</cfif></label></cfoutput>
					</div>
				</div>
				<div class="col-11">
					<cf_grid_list id="asorti_table">
						<!--- Olusan toplam checkbox sayisi(size*color), hepsini sec icin kullanilir--->
						<cfset cartesian_ = color_matris * size_matris>
						<input type="hidden" name="cartesian" id="cartesian" value="<cfoutput>#cartesian_#</cfoutput>">
						<input type="hidden" name="is_submit_2" value="1">
						<!--- barkod olusturma ean8/ean13 --->
						<input type="hidden" name="is_auto_barcode" id="is_auto_barcode" value="<cfoutput>#attributes.is_auto_barcode#</cfoutput>">
						<input type="hidden" name="assortment_count" value="<cfoutput>#color_matris#</cfoutput>">
						
						
						<!--- sampledan geliyor ve daha önceden asorti json oluşturulmuşsa --->
						<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
							<cfset colspan = 1>
							<cfset asorti_json = deserializeJSON(Query_result.SAMPLE_ASORTI_JSON)>
							<cfset asorti_header = asorti_json.headers>
							<cfset asorti_content = asorti_json.content>
							<cfif isdefined("asorti_json.is_delete")>
								<cfset asorti_isdel= asorti_json.is_delete>
							</cfif>
							<thead>
								<tr>
									
									<th  style="text-align:center;color:black;font-weight:bold;" width="120">
										<div class="form-group formbold">
											<div class="col col-2">
												<a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-eye"></i></a>
											</div>
											<div class="col col-10 formbold">
												<cf_get_lang dictionary_id='42263.Dağılım'></th>
											</div>
										</div>
										<cfloop from="1" to="#arrayLen(asorti_header)#" index="i">
											<th  style="text-align:center;color:black;font-weight:bold;"><cfoutput>#asorti_header[i]#</cfoutput></th>
											<cfset colspan = colspan + 1>
										</cfloop>
									<th style="text-align:center;color:black;font-weight:bold;"><cf_get_lang dictionary_id='57492.Toplam'></th>
								</tr>
							</thead>
				
							<tbody>	
								<cfloop from="1" to="#arrayLen(asorti_content)#" index="i">
									<cfset color_counter = 1>
									
									<tr id="tr_<cfoutput>#i#</cfoutput>" style<cfif isdefined("asorti_isdel") and ArrayIsDefined(asorti_isdel,i) and asorti_isdel[i] eq 1>="display:none;"class="hide"</cfif>>
										<cfinput type="hidden" name="is_del_#i#" id="is_del_#i#" class="delete" value="" >
										<cfloop from="1" to="#arrayLen(asorti_content[i])#" index="j">
											
											<cfif j eq 1>
											
											<td id="dell" style="text-align:center;color:black;font-weight:bold;"><div class="form-group formbold"><div class="col col-2"><input type="hidden" name="row_kontrol<cfoutput>#color_counter#</cfoutput>" id="row_kontrol<cfoutput>#color_counter#</cfoutput>" value="1"><cfoutput><a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(#i#);"><i class="fa fa-eye-slash"></i></a></div><div class="col col-10 formbold"></cfoutput><b><cfoutput>#asorti_content[i][j]["title"]#</cfoutput></b></div></div></td>
												
												
											<cfelse>
											
												<td style="text-align:center;color:black;font-weight:bold;" id="td_<cfoutput>#color_counter#</cfoutput>">
													<div class="form-group">
														<input type="number" class="text-center" name="assortment_<cfoutput>#color_counter#</cfoutput>" id="assortment_<cfoutput>#color_counter#</cfoutput>" value="<cfoutput>#len( asorti_content[i][j]["assortment"]) ? asorti_content[i][j]["assortment"] : 0#</cfoutput>"   onblur="row_sum()" onchange"row_sum()">
														<input type="hidden" name="assortment_hidden_<cfoutput>#color_counter#</cfoutput>" value="<cfoutput>#asorti_content[i][j]["assortment_hidden"]#</cfoutput>">
													</div>
												</td>
												<cfset color_counter++>
											</cfif>
										</cfloop>
										<td id="td_last<cfoutput>#i#</cfoutput>" style="text-align:center;color:red;">0</td>
									</tr>
									<input type="hidden" name="counter" id="counter" value="<cfoutput>#i#</cfoutput>">
									<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#i#</cfoutput>">
								</cfloop>
								<tr>
									
									<td style="text-align:center;color:black;font-weight:bold;"><cf_get_lang dictionary_id='57492.Toplam'></td>
									<cfset i=1>
									<cfloop from="1" to="#arrayLen(asorti_content[1])-1#" index="i">
										<td id="td_net_last<cfoutput>#i#</cfoutput>" style="text-align:center;color:red;">0</td>
										<cfset i++>
									</cfloop>
									<td id="td_sum" style="text-align:center;color:red;">0</td>
								</tr>
							</tbody>
							
						<cfelse>
							<cfset colspan = 1>
							<thead>
								<tr>
									
									<th style="text-align:center;color:black;font-weight:bold;" width="120">
										<div class="form-group formbold">
											<div class="col col-2">
												<a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>"><i class="fa fa-eye"></i></a>
											</div>
											<div class="col col-10 formbold">
												<cf_get_lang dictionary_id='42263.Dağılım'><!--- <cf_get_lang dictionary_id='37324.Beden'>/<cf_get_lang dictionary_id='37325.Renk'> --->
												</div>
											</div>
										</th>
										<cfloop query="get_color_property_det">
											<cfif  len(attributes.property_collar_id)>
												<cfloop  query="get_collar_property_det">
												
													<cfoutput><th id="theader" style="text-align:center;color:black;font-weight:bold">#get_color_property_det.property_detail#<cfif len(attributes.property_collar_id)>-#get_collar_property_det.property_detail#</cfif></th></cfoutput>
													<cfset colspan = colspan + 1>
												</cfloop>
											<cfelse>
													<cfoutput><th id="theader" style="text-align:center;color:black;font-weight:bold">#get_color_property_det.property_detail#<cfif len(attributes.property_collar_id)>-#get_collar_property_det.property_detail#</cfif></th></cfoutput>
												<cfset colspan = colspan + 1>
												</cfif>
										</cfloop>
									<!--- <cfoutput query="get_collar_property_det">
										<th id="theader" style="text-align:center;color:black;font-weight:bold">#get_color_property_det.property_detail#<cfif len(attributes.property_collar_id)>-#get_collar_property_det.property_detail#</cfif></th>
										<cfset colspan = colspan + 1>
									</cfoutput> --->
									<th style="text-align:center;color:black;font-weight:bold;"><cf_get_lang dictionary_id='57492.Toplam'></th>
								</tr>
							</thead>
							<cfset currentrow_ =1>
							<tbody>
								<cfif	len(attributes.property_body_size_id)>
									<cfloop query="get_body_size_property_det">
										<cfloop query="get_size_property_det">
											<cfoutput>

												<cfif	len(attributes.property_body_size_id)>
													<cfset body_=get_body_size_property_det.property_detail_id>
												<cfelse>
													<cfset body_=0>
												</cfif>
												<cfif len(attributes.property_collar_id)>
													<cfset collar=get_collar_property_det.property_detail_id>
												<cfelse>
													<cfset collar=0>
												</cfif>
												<cfset color_counter = 1>
												<tr id="tr_#currentrow_#"  name="tr_#currentrow_#">
													<td id="dell" class="contt" style="text-align:center;color:black;font-weight:bold;" ><input type="hidden" name="row_kontrol#currentrow_#" id="row_kontrol#currentrow_#" class="roww" value="1"><a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(#currentrow_#);"><i class="fa fa-eye-slash"></i></a><b>#get_size_property_det.property_detail#<cfif len(attributes.property_body_size_id)>-#get_body_size_property_det.property_detail#</cfif></b></td>
													<input type="hidden" name="is_del_#currentrow_#" id="is_del_#currentrow_#">
													<cfloop query="get_color_property_det">
														<cfif  len(attributes.property_collar_id)>
															<cfloop  query="get_collar_property_det">
																<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
																<cfset pro = get_color_property_det.PROPERTY_DETAIL>
																<cfset pro = listappend(pro,get_collar_property_det.PROPERTY_DETAIL,'-')>
																<cfset pro = listappend(pro,get_size_property_det.PROPERTY_DETAIL,'-')>
																<cfset pro = listappend(pro,get_body_size_property_det.PROPERTY_DETAIL,',')>
																<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
																
																<td  style="text-align:center;color:black;font-weight:bold;" id="td_#color_counter#">
																	<div class="form-group">
																		<input type="number" class="text-center" name="assortment_#color_counter#" id="assortment_#color_counter#" value="0" onchange="row_sum()" <cfif listfind(product_property_list,pro)>readonly</cfif>>
																		
																		<input type="hidden" name="assortment_hidden_#color_counter#" value="#get_color_property_det.property_detail_id#-#collar#-#get_size_property_det.property_detail_id#-#body_#">
																	</div>
																</td>
																
																<cfset color_counter++>
															</cfloop>
														<cfelse>
															<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
															<cfset pro = get_color_property_det.PROPERTY_DETAIL>
															<cfset pro = listappend(pro,get_collar_property_det.PROPERTY_DETAIL,'-')>
															<cfset pro = listappend(pro,get_size_property_det.PROPERTY_DETAIL,'-')>
															<cfset pro = listappend(pro,get_body_size_property_det.PROPERTY_DETAIL,',')>
															<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
															
															<td  style="text-align:center;color:black;font-weight:bold;" id="td_#color_counter#">
																<div class="form-group">
																	<input type="number" class="text-center" name="assortment_#color_counter#" id="assortment_#color_counter#" value="0" onchange="row_sum()" <cfif listfind(product_property_list,pro)>readonly</cfif>>
																	
																	<input type="hidden" name="assortment_hidden_#color_counter#" value="#get_color_property_det.property_detail_id#-#collar#-#get_size_property_det.property_detail_id#-#body_#">
																</div>
															</td>
															
															<cfset color_counter++>
														</cfif>
													</cfloop>
													<td id="td_last#currentrow_#" style="color:red;text-align:center;">0</td>
												
												</tr>
												
												<input type="hidden" name="counter" id="counter" value="<cfoutput>#currentrow_#</cfoutput>">
												<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#currentrow_#</cfoutput>">
												
											</cfoutput><cfset currentrow_ =currentrow_+1> 
										
										</cfloop> 
									</cfloop>
								<cfelse>
									<cfoutput query="get_size_property_det">
										<cfif len(attributes.property_body_size_id)>
											<cfset body_=get_body_size_property_det.property_detail_id>
										<cfelse>
											<cfset body_=0>
										</cfif>
										<cfif len(attributes.property_collar_id)>
											<cfset collar=get_collar_property_det.property_detail_id>
										<cfelse>
											<cfset collar=0>
										</cfif>
										<cfset color_counter = 1>
										<tr id="tr_#currentrow#"  name="tr_#currentrow#">
											
											<td id="dell" class="contt" style="text-align:center;color:black;font-weight:bold;" ><div class="form-group formbold"><div class="col col-2"><input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" class="roww" value="1"><a style="cursor:pointer" title="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(#currentrow#);"><i class="fa fa-eye-slash"></i></a></div><div class="col col-10 formbold"><b>#get_size_property_det.property_detail#<cfif len(attributes.property_body_size_id)>-#get_body_size_property_det.property_detail#</cfif></b></div></div></td>
											
											<input type="hidden" name="is_del_#currentrow#" id="is_del_#currentrow#">
											<cfloop query="get_color_property_det">
												<cfif  len(attributes.property_collar_id)>
													<cfloop  query="get_collar_property_det">
														<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
														<cfset pro = get_color_property_det.PROPERTY_DETAIL>
														<cfset pro = listappend(pro,get_collar_property_det.PROPERTY_DETAIL,'-')>
														<cfset pro = listappend(pro,get_size_property_det.PROPERTY_DETAIL,'-')>
														<cfset pro = listappend(pro,get_body_size_property_det.PROPERTY_DETAIL,',')>
														<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
														
														<td  style="text-align:center;color:black;font-weight:bold;" id="td_#color_counter#">
															<div class="form-group">
																<input type="number" class="text-center" name="assortment_#color_counter#" id="assortment_#color_counter#" value="0" onchange="row_sum()" <cfif listfind(product_property_list,pro)>readonly</cfif>>
																
																<input type="hidden" name="assortment_hidden_#color_counter#" value="#get_color_property_det.property_detail_id#-#collar#-#get_size_property_det.property_detail_id#-#body_#">
															</div>
														</td>
														
														<cfset color_counter++>
													</cfloop>
												<cfelse>
													<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
													<cfset pro = get_color_property_det.PROPERTY_DETAIL>
													<cfset pro = listappend(pro,get_collar_property_det.PROPERTY_DETAIL,'-')>
													<cfset pro = listappend(pro,get_size_property_det.PROPERTY_DETAIL,'-')>
													<cfset pro = listappend(pro,get_body_size_property_det.PROPERTY_DETAIL,',')>
													<!--- urunun ozelligini size-color olarak birlestirir, cunku value degeri size-color id seklinde atanir --->
													
													<td  style="text-align:center;color:black;font-weight:bold;" id="td_#color_counter#">
														<div class="form-group">
															<input type="number" class="text-center" name="assortment_#color_counter#" id="assortment_#color_counter#" value="0" onchange="row_sum()" <cfif listfind(product_property_list,pro)>readonly</cfif>>
															
															<input type="hidden" name="assortment_hidden_#color_counter#" value="#get_color_property_det.property_detail_id#-#collar#-#get_size_property_det.property_detail_id#-#body_#">
														</div>
													</td>
													
													<cfset color_counter++>
												</cfif>
											</cfloop>
											<td id="td_last#currentrow#" style="color:red;text-align:center;">0</td>
										
										</tr>
										<input type="hidden" name="counter" id="counter" value="<cfoutput>#currentrow#</cfoutput>">
										<input type="hidden" name="record_num" id="record_num" value="<cfoutput>#currentrow#</cfoutput>">
									</cfoutput>
								</cfif>
								<tr>
									<td style="text-align:center;color:black;font-weight:bold;">
										<div class="form-group formbold">
											<div class="col col-2">
												<i class="fa fa-eye-slash"></i>
											</div>
											<div class="col col-10 formbold">
												<cf_get_lang dictionary_id='57492.Toplam'>
											</div>
										</div>
									</td>
									<cfset i=1>
									<cfloop query="get_color_property_det">
										<cfif  len(attributes.property_collar_id)>
											<cfloop  query="get_collar_property_det">
												<td id="td_net_last<cfoutput>#i#</cfoutput>" style="color:red;text-align:center;">0</td>
												<cfset i++>
											</cfloop>
										<cfelse>
											<td id="td_net_last<cfoutput>#i#</cfoutput>" style="color:red;text-align:center;">0</td>
											<cfset i++>
										</cfif>
									</cfloop>
									<td id="td_sum" style="color:red;text-align:center;">0</td>
								</tr>
							</tbody>
						</cfif>
					</cf_grid_list>	
				</div>
			</div>
			<div class="ui-info-bottom ui-form-list flex-list">
				<div class="form-group">
					<select name="is_barkod" id="is_barkod">
						<option value="1"><cf_get_lang dictionary_id='33660.Barkod Oluştur'></option>
					</select>
				</div>
				<div class="form-group small">
					<input type="text" name="stock_count" id="stock_count" readonly placeholder="<cfoutput>#getLang('','Stok Sayısı','44249')#</cfoutput>">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="2" button_name="#getLang('','Ölçü ve Dağılım Tablosuna Göre Stok Yarat',63454)#" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search_' , #attributes.modal_id#)"),DE(""))#">
				</div>
				<cfif isDefined("attributes.product_sample_id") and len(attributes.product_sample_id)>
					<div class="form-group">
						<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left margin-0" onclick="createObj()"><cf_get_lang dictionary_id='64044.Ölçü ve Dağılım Tablosu Oluştur'></a>
					</div>
				</cfif>
			</div>
		<cfelse>
			<input type="hidden" name="is_barkod" value="1">
			<input type="hidden" name="assortment_count" value="<cfoutput>#color_matris#</cfoutput>">
			<cfquery name="stock_count" datasource="#dsn3#">
				SELECT STOCK_ID,STOCK_CODE_2,PRODUCT_UNIT_ID FROM STOCKS WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#pid#">
			</cfquery>
			<cfset stock_count_ = stock_count.recordcount>
			<cfset property_detail_id = attributes.color_detail_id>
			<cfif len(attributes.collar_detail_id)><cfset property_detail_id = listappend(property_detail_id,attributes.collar_detail_id)></cfif>
			<cfset property_detail_id = listappend(property_detail_id,attributes.size_detail_id)>
			<cfif len(attributes.body_size_detail_id)><cfset property_detail_id = listappend(property_detail_id,attributes.body_size_detail_id)></cfif>
			<cf_grid_list>
				<thead>
					<tr>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
						<th><cf_get_lang dictionary_id='57789.Özel Kod'></th>
						<th><cf_get_lang dictionary_id='57633.Barkod'></th>
						<th><cf_get_lang dictionary_id='36199.Açıklana'></th>
						<th><cf_get_lang dictionary_id='29412.Seri'><cf_get_lang dictionary_id='63411.Miktarı'></th>
					</tr>
				</thead>
				<tbody>
					<cfset counter = 1 >
					<cfloop from="1" to="#attributes.assortment_count#" index="item">
						<input type="hidden" name="assortment_<cfoutput>#item#</cfoutput>" value="<cfoutput>#evaluate("attributes.assortment_#item#")#</cfoutput>">
						<input type="hidden" name="assortment_hidden_<cfoutput>#item#</cfoutput>" value="<cfoutput>#evaluate("attributes.assortment_hidden_#item#")#</cfoutput>">
						<cfloop from="1" to="#listlen(evaluate("attributes.assortment_#item#"))#" index="assorti">
						
							<cfif listgetat(evaluate("attributes.assortment_#item#"),assorti,',') gt 0 >
								<cfif isdefined("attributes.is_barkod")>
									<cfif isdefined("attributes.is_auto_barcode") and attributes.is_auto_barcode eq 0>
										<cfset barkod_no = get_barcode_no()>
									<cfelse>
										<cfset barkod_no = get_barcode_no(1)>
									</cfif>
								</cfif>
								<cfset assortment_1 = listgetat(evaluate("attributes.assortment_hidden_#item#"),assorti,',')> 
								<cfset assortment_2 = listgetat(evaluate("attributes.assortment_hidden_#item#"),assorti,',')>
								<cfquery   name="get_color_property_det" datasource="#dsn1#">
									SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL  FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assortment_1,1,'-')#" list="yes">
								</cfquery>
								
								<cfif ListLen(assortment_1,'-') eq 4 >
									<cfquery   name="get_collar_property_det" datasource="#dsn1#">
										SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL  FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assortment_2,2,'-')#" list="yes">
									</cfquery>
									<cfquery  name="get_size_property_det"  datasource="#dsn1#">
										
										SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL  FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assortment_1,3,'-')#" list="yes"> 
									</cfquery>
									<cfquery  name="get_body_size_property_det"  datasource="#dsn1#">
										SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assortment_2,4,'-')#" list="yes">
									</cfquery>
									<cfelse>
										<cfquery  name="get_size_property_det"  datasource="#dsn1#">
											SELECT PROPERTY_DETAIL_ID,PROPERTY_DETAIL  FROM PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(assortment_1,2,'-')#" list="yes"> 
										</cfquery>
								</cfif>
								<cfset stock_count_ = stock_count_ + 1>
								<cfoutput>
									<tr>
										<td>#counter#</td>
										<td>#pcode#.#stock_count_#</td>
										<td>#attributes.pid#.#get_color_property_det.PROPERTY_DETAIL#<cfif ListLen(assortment_1,'-') eq 4  and listgetat(assortment_2,2,'-') neq 0>.#get_collar_property_det.PROPERTY_DETAIL#</cfif>.#get_size_property_det.PROPERTY_DETAIL#<cfif ListLen(assortment_1,'-') eq 4  and listgetat(assortment_2,4,'-') neq 0>.#get_body_size_property_det.PROPERTY_DETAIL#</cfif></td>
										<td>#barkod_no#</td>
										<td>#get_color_property_det.PROPERTY_DETAIL#<cfif ListLen(assortment_1,'-') eq 4  and listgetat(assortment_2,2,'-') neq 0>.#get_collar_property_det.PROPERTY_DETAIL#</cfif>.#get_size_property_det.PROPERTY_DETAIL#<cfif ListLen(assortment_1,'-') eq 4  and listgetat(assortment_2,4,'-') neq 0>.#get_body_size_property_det.PROPERTY_DETAIL#</cfif></td>
										<td>#listgetat(evaluate("attributes.assortment_#item#"),assorti,',')#</td>
									</tr>
								</cfoutput>
								<cfset counter ++>
							</cfif>
						
						</cfloop>
					</cfloop>
				</tbody>
			</cf_grid_list>
		
			<div class="ui-info-bottom ui-form-list flex-list">
				<div class="form-group">
					<label><cfoutput>#getLang('','Stok Sayısı','44249')#</cfoutput></label>
					<input type="text" name="stock_count" id="stock_count_" readonly value="<cfoutput>#attributes.stock_count#</cfoutput>" >
				</div>
				<div class="form-group">
					<cf_workcube_buttons is_upd='0' insert_info="#getLang('','Stokları Oluştur',63459)#" add_function="kontrol()">
				</div>
			</div>
		</cfif>
	</cfform>
</cf_box>


<script type="text/javascript">

function Control_(){
	<cfif  xml_color eq 1> 
		if(	(search.property_color_id.value == search.property_collar_id.value)|| (	search.property_size_id.value == search.property_collar_id.value)){
			alert("<cf_get_lang dictionary_id='49370.Özellikler aynı seçilemez'>!")
			return false;
		}
		
		</cfif>
	<cfif  xml_size eq 1> 
	if(	(search.property_size_id.value == search.property_body_size_id.value) || (search.property_color_id.value == search.property_body_size_id.value)){
		alert("<cf_get_lang dictionary_id='49370.Özellikler aynı seçilemez'>!")
		return false;
	}
	</cfif>
	<cfif  xml_size eq 1 and  xml_color eq 1>
		if(	search.property_collar_id.value == search.property_body_size_id.value){
		alert("<cf_get_lang dictionary_id='49370.Özellikler aynı seçilemez'>!")
		return false;
	}
	
	</cfif>
	if(	search.property_size_id.value == search.property_color_id.value){
		alert("<cf_get_lang dictionary_id='49370.Özellikler aynı seçilemez'>!")
		return false;
	}
	
	return true;

}

function sil(sy){

		for( i=1; i <= <cfoutput>#size_matris#</cfoutput>; i++ ){
			row_total = 0;
			for( j=1; j <= <cfoutput>#color_matris#</cfoutput>; j++ ){
				row_total += parseInt($("tr#tr_"+i+" td#td_"+j+" input:first-child").val());
			}
			$("tr#tr_"+i+" td#td_last"+i).html(row_total);
			
		}
		
		
		for( i=1; i <= <cfoutput>#color_matris#</cfoutput>; i++ ){
			net_total = 0;
		
			for( j=1; j <= <cfoutput>#size_matris#</cfoutput>; j++ ){
			 	 $("tr#tr_"+sy+" td#td_last"+sy).html("0");  
			
					net_total += parseInt($("tr#tr_"+j+" td#td_"+i+" input:first-child").val());
					$("td#td_net_last"+i).html(net_total);
					$("tr#tr_"+sy+" #assortment_"+j).val("0"); 
					var my_element=eval("search_.row_kontrol"+sy);
					if (Boolean(my_element)){
						my_element.value = 0;
						}
				
					document.search_.counter.value=filterNum(document.search_.counter.value)-1;
					var my_element=eval("tr_"+sy);
					my_element.style.display="none";
					$("#is_del_"+sy).val("1");
				
			}
			
		
		}
		total = 0;

		for( i=1; i <= <cfoutput>#size_matris#</cfoutput>; i++ ) {
			total += parseInt($("td#td_last"+i).text());
		
		}
		
		
		$("td#td_sum").html(total);
		$("#stock_count").val(total);
		
	}
	function row_sum(){

		for( i=1; i <= <cfoutput>#size_matris#</cfoutput>; i++ ){
			row_total = 0;
			for( j=1; j <= <cfoutput>#color_matris#</cfoutput>; j++ ){
				row_total += parseInt($("tr#tr_"+i+" td#td_"+j+" input:first-child").val());
			}
		
			$("tr#tr_"+i+" td#td_last"+i).html(row_total);
		}

		for( i=1; i <= <cfoutput>#color_matris#</cfoutput>; i++ ){
			net_total = 0;
			for( j=1; j <= <cfoutput>#size_matris#</cfoutput>; j++ ){
				net_total += parseInt($("tr#tr_"+j+" td#td_"+i+" input:first-child").val());
				
				
			}
			
			$("td#td_net_last"+i).html(net_total);
		}
		total = 0;
	
	

		for( i=1; i <= <cfoutput>#size_matris#</cfoutput>; i++ ) {
			
			total += parseInt($("td#td_last"+i).text());
		
		}
		$("td#td_sum").html(total);
		$("#stock_count").val(total);
	}

	function kontrol() {
		
		document.getElementById("search_").action = "<cfoutput>#request.self#?fuseaction=product.emptypopup_add_sub_stock_code<cfif isdefined("attributes.collar_detail_id") and len(attributes.collar_detail_id)>&collar_detail_id_=#attributes.collar_detail_id#</cfif><cfif isdefined("attributes.body_size_detail_id") and len(attributes.body_size_detail_id)>&body_detail_id=#attributes.body_size_detail_id#</cfif></cfoutput>";
		document.getElementById("search_").submit();
		return true;
	}

	function createObj(){
		
		var headers = [], content = [], is_delete = [], model = {};

		
	
		$("table#asorti_table thead tr th").each(function(index) {
			if( index != 0 && index != ($("table#asorti_table thead tr th").length - 1)  )
				headers.push( $(this).text() );	
			
		});
	
			

		$("table#asorti_table tbody tr ").each(function(index) {
			if( index != 0 ){
				$("tr.hide input.delete").val("1");
			
		
				is_delete.push( $("#is_del_"+index).val() );
			}
				
			
		
	});

		$("table#asorti_table tbody tr").each(function(index) {
			if( index != ($("table#asorti_table tbody tr").length - 1) ){
				
				cells = $(this).find("td");
				contentArr = [];
				cells.each(function (tdIndex) {
					if( tdIndex != 0 && tdIndex != (cells.length - 1) ) contentArr.push( { title: '', assortment: $(this).find('input[type = number]').val(), assortment_hidden: $(this).find('input[type = hidden]').val() } );	
					else if( tdIndex == 0 ) contentArr.push( { title: $(this).text(), assortment: '', assortment_hidden: '' } );
				 
				});
				content.push( contentArr );
			}
		});

		model = {
			headers: headers,
			content: content,
			is_delete :is_delete
		};

		   var data = new FormData();
		data.append("asorti_json", JSON.stringify( model ));
		data.append("product_sample_id", document.getElementById("product_sample_id").value );
		AjaxControlPostDataJson("V16/product/cfc/product_sample.cfc?method=upd_sample_asorti", data, function(response){
                if( response.STATUS ){
                    alert(response.MESSAGE);
                    location.reload();
                }
            });
        return false;        
	}

	<cfif isDefined("Query_result") and len(Query_result.SAMPLE_ASORTI_JSON)>
		row_sum();
		
		$("#dell").click(function(){
			sil(sy);
		});
		
		
	</cfif>

</script>