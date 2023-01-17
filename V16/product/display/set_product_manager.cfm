<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT 
		PRODUCT_CAT.PRODUCT_CATID, 
		PRODUCT_CAT.HIERARCHY, 
		PRODUCT_CAT.PRODUCT_CAT
	FROM 
		PRODUCT_CAT,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id# 
	ORDER BY 
		HIERARCHY
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	
	<cf_box>
		<cfform name="set_" method="post" action="#request.self#?fuseaction=product.emptypopup_set_product_manager">
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-cat">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29401.Ürün Kategorisi'>*</label>
						<div class="col col-8 col-xs-12">
							<select name="cat" id="cat" multiple="multiple">
								<cfoutput query="get_product_cat">
									<option value="#HIERARCHY#"><cfloop from="1" to="#listlen(HIERARCHY,'.')-1#" index="ccc">&nbsp;&nbsp;</cfloop>#HIERARCHY#-#product_cat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-comp">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="comp" type="text"  id="comp" onFocus="AutoComplete_Create('comp','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','1,1,0','COMPANY_ID','company_id','','3','140');" value="" autocomplete="off">
								<input type="hidden" name="company_id" id="company_id" value="">
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=set_.company_id&field_comp_name=set_.comp&select_list=2&keyword=</cfoutput>'+set_.comp.value,'list','popup_list_pars');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-brand_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="brand_code" id="brand_code" value="">
								<cf_wrkProductBrand
									returnInputValue="brand_id,brand_name,brand_code"
									returnQueryValue="brand_id,brand_name,brand_code"
									width="250"
									compenent_name="getProductBrand"               
									boxwidth="300"
									boxheight="250"
									is_internet="1"
									brand_code="1"
									brand_ID="">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-short_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58225.Model'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cf_wrkProductModel
									returnInputValue="short_code_id,short_code,short_code_name"
									returnQueryValue="MODEL_ID,MODEL_CODE,MODEL_NAME"
									width="250"
									fieldName="short_code_name"
									fieldId="short_code_id"
									fieldcode="short_code"
									compenent_name="getProductModel"            
									boxwidth="250"
									boxheight="150"
									model_ID="">
								<input type="hidden" name="old_short_code" id="old_short_code" value="">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-product_manager_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input name="product_manager_name" type="text"  id="product_manager_name" style="width:250px;" onFocus="AutoComplete_Create('product_manager_name','FULLNAME','FULLNAME','get_emp_pos','','POSITION_CODE','product_manager','','3','130');" value="" autocomplete="off" >
								<span class="input-group-addon  icon-ellipsis" onclick="windowopen('index.cfm?fuseaction=objects.popup_list_positions&amp;field_code=set_.product_manager&amp;field_name=set_.product_manager_name&amp;select_list=1','list');"></span>
								<input type="hidden" name="product_manager" id="product_manager" value="">
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' is_delete='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>


<script type="text/javascript">
	function kontrol()
	{
		
		if(document.set_.product_manager.value == '')
		{
			alert("<cf_get_lang dictionary_id='47936.Sorumlu Seçmelisiniz!'>");
			return false;
		} 
		if($('#comp').val() != '')
		{
			return true;
		}
		else if ($('#brand_name').val() != '')
		{
			return true;
		}
		else if ($('#short_code_name').val() != '')
		{
			return true;
		}
		else if (document.getElementById('cat').selectedIndex > -1)
		{
			return true;
		}
		alert("<cf_get_lang dictionary_id='44561.Lüften filtre giriniz'>!");
			return false;
	}
</script>