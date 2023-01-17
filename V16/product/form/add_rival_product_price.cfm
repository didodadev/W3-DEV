<cfinclude template="../query/get_rivals.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_unit.cfm">
<cfif not isDefined("dsn_dev")>
	<cfset dsn_dev= dsn & '_retail' >
</cfif>
<cfquery name="GET_PRICE_TYPE" datasource="#dsn_dev#">
	SELECT TYPE_ID, TYPE_NAME FROM RIVAL_PRICE_TYPES WHERE 1=1 ORDER BY TYPE_NAME
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','settings',32089)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- Rakip Fiyatlar --->
		<cfform action="#request.self#?fuseaction=product.emptypopup_add_rival_product_price" method="post" name="price" >
			<cf_box_elements>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-txt_product">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'> *</label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
							<div class="input-group">
								<input type="hidden" name="pid" id="pid" value="<cfif isDefined("pid")>#pid#</cfif>">
								<input type="hidden" name="stock_id" id="stock_id" value="<cfif isDefined("stock_id")>#stock_id#</cfif>">
								<input type="Text"   style="width:200px;" name="txt_product" id="txt_product"  value="" readonly="yes"><!--- onChange="get_prd_unit();"  --->
								<span class="input-group-addon icon-ellipsis btnPointer" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=price.stock_id&product_id=price.pid&field_name=price.txt_product')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-r_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58779.Rakip'> *</label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
							<select name="r_id" id="r_id" style="width:200Px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_rivals">
									<option value="#R_ID#">#rival_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-type_id">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='61480.Fiyat Tipi'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
							<select name="type_id" id="type_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="GET_PRICE_TYPE">
									<option value="#TYPE_ID#">#TYPE_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-price">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58084.Fiyat'> *</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='37416.Fiyat girmelisiniz'></cfsavecontent>
								<cfinput type="text" name="price" class="moneybox" onkeyup="return(FormatCurrency(this,event));">
								<span class="input-group-addon width">
									<select name="money" id="money">
										<cfoutput query="get_money">
											<option value="#money#">#money#</option>
										</cfoutput>
									</select>
								</span>
								</div>									
						</div>
					</div>
					<div class="form-group" id="item-UNIT_ID">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
							<select name="UNIT_ID" id="UNIT_ID" style="width:65px;">
								<cfoutput query="GET_UNIT">
									<option value="#UNIT_ID#">#UNIT#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
								<cfinput required="Yes" validate="#validate_style#" type="text" name="startdate" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-finishdate">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12"> 
							<div class="input-group">
								<cfinput  validate="#validate_style#"  type="text" name="finishdate" style="width:65px;" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-rival_detail">
						<label class="col col-3 col-md-3 col-sm-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12"> 
							<textarea name="rival_detail" id="rival_detail" cols="60" rows="2" style="width:200px;height:60;" ></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-12"><cf_workcube_buttons type_format='1' is_upd='0' add_function='unformat_fields()'></div> 
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		if(document.price.txt_product.value == 0)
		{
			alert("<cf_get_lang dictionary_id='36677.Ürün Seçmelisiniz'> !"); //prod',364
			return false;
		}
		if(document.price.r_id.value == '')
		{
			alert("<cf_get_lang dictionary_id='37544.Rakip Girmelisiniz'> !");
			return false;
		}
		if(document.price.price.value == 0 || document.price.price.value == '')
		{
			alert("<cf_get_lang dictionary_id='37416.Fiyat girmelisiniz'>!");
			return false;
		}
		if(document.price.money.value == 0)
		{
			alert("<cf_get_lang dictionary_id='41991.Para Birimi Girmelisiniz'> !");
			return false;
		}
		if(document.price.money.startdate == '')
		{
			alert("<cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'> !");
			return false;
		}	
		document.price.price.value = filterNum(document.price.price.value);
		return true;
	}
</script>