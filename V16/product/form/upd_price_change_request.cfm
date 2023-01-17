<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_price_change_detail.cfm">
<cfif not GET_PRICE_CHANGE_DET.recordcount>
	<br/><font class="txtbold"><cf_get_lang dictionary_id='58943.Böyle Bir Kayıt Bulunmamaktadır'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="GET_COMPETITIVE_LIST" datasource="#DSN3#">
	SELECT 
		COMPETITIVE_ID
	FROM
		PRODUCT_COMP_PERM 
	WHERE 
		POSITION_CODE = #session.ep.position_code#
</cfquery>
<cfset COMPETITIVE_LIST = ValueList(GET_COMPETITIVE_LIST.COMPETITIVE_ID)>
<cfinclude template="../query/get_price_cat.cfm">
<cfinclude template="../query/get_money.cfm">
<cfinclude template="../query/get_product_unit.cfm">
<cfinclude template="../query/get_product.cfm">
<cfif len(get_product.PROD_COMPETITIVE)>
  <cfset attributes.COMPETITIVE_ID=get_product.PROD_COMPETITIVE>
  <cfinclude template="../query/get_competitive_name.cfm">
  <cfset COMPETITIVE_NAME=GET_COMPETITIVE_NAME.COMPETITIVE>
  <cfelse>
  <cfset COMPETITIVE_NAME="">
</cfif>

<cfif len(GET_PRICE_CHANGE_DET.SAME_CHANGE_ID) >
  <cfquery datasource="#DSN3#" name="GET_SAME_ID">
  	SELECT 
		PRICE_CATID, 
		PRICE_CHANGE_ID, 
		PRICE, 
		PRICE_KDV, 
		MONEY, 
		IS_KDV 
	FROM 
		PRICE_CHANGE 
	WHERE 
		SAME_CHANGE_ID = #GET_PRICE_CHANGE_DET.SAME_CHANGE_ID#
  </cfquery>
  <cfset price_catlist = valuelist(GET_SAME_ID.PRICE_CATID)>
  <cfset price_list = valuelist(GET_SAME_ID.PRICE)>
  <cfset price_kdv_list = valuelist(GET_SAME_ID.PRICE_KDV)>
  <cfset money_list = valuelist(GET_SAME_ID.MONEY)>
  <cfset kdv_list = valuelist(GET_SAME_ID.IS_KDV)>
<cfelse>
  <cfset price_catlist = valuelist(GET_PRICE_CHANGE_DET.PRICE_CATID)>
  <cfset price_list = valuelist(GET_PRICE_CHANGE_DET.PRICE)>
  <cfset price_kdv_list = valuelist(GET_PRICE_CHANGE_DET.PRICE_KDV)>
  <cfset money_list = valuelist(GET_PRICE_CHANGE_DET.MONEY)>
  <cfset kdv_list = valuelist(GET_PRICE_CHANGE_DET.IS_KDV)>
</cfif>

	<cf_box title="#getLang('','settings',37116)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform action="#request.self#?fuseaction=product.emptypopup_upd_price_change" method="post" name="price">
	<cf_box_elements>
	<cfoutput>
		<input type="hidden" name="PRICE_CHANGE_ID" id="PRICE_CHANGE_ID" value="#GET_PRICE_CHANGE_DET.PRICE_CHANGE_ID#">
		<input type="hidden" name="SAME_CHANGE_ID" id="SAME_CHANGE_ID" value="#GET_PRICE_CHANGE_DET.SAME_CHANGE_ID#">
		<input type="hidden" name="pid" id="pid" value="#GET_PRICE_CHANGE_DET.PRODUCT_ID#">
		<input type="hidden" name="product_name" id="product_name" value="#get_product.product_name#">
		<input type="hidden" name="alis_kdv" id="alis_kdv" value="#GET_PRODUCT.TAX_PURCHASE#">
		<input type="hidden" name="satis_kdv" id="satis_kdv" value="#GET_PRODUCT.TAX#">
		<input type="hidden" name="active_company" id="active_company" value="#session.ep.company_id#">
		<input type="hidden" name="active_year" id="active_year" value="#session.ep.period_year#">
		<input type="hidden" name="id" id="id" value="#attributes.id#">  
	</cfoutput>
	<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">  
	<div class="row"> 
		<div class="col col-12 uniqueRow"> 		
			<div class="row formContent">
				<div class="row" type="row">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-product_name">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
							<div class="col col-9 col-xs-12"> 
								<cfoutput>#get_product.product_name# - #COMPETITIVE_NAME#</cfoutput>
							</div>
						</div>
						<div class="form-group" id="item-unit_id">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37307.Ürün Birimi'> *</label>
							<div class="col col-6 col-xs-12">
								<div class="input-group">
									<select name="unit_id" id="unit_id" style="width:211px;">
										<cfoutput query="get_product_unit">
											<option value="#PRODUCT_UNIT_ID#"<cfif GET_PRICE_CHANGE_DET.unit eq PRODUCT_UNIT_ID> selected</cfif>>#add_unit#</option>
										</cfoutput>
									</select>
									<span class="input-group-addon no-bg">
									<cf_get_lang dictionary_id='57710.Yuvarlama'>
									</span>
								</div>
							</div>	
							<div class="col col-3 col-xs-12">
								<select name="ROUNDING" id="ROUNDING" style="width:35px;">
									<option value="0">0
									<option value="1">1
									<option value="2">2
									<option value="3">3
								</select>
							</div>
						</div>
						<div class="form-group" id="item-date">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58053.Baslangic Tarihi'> *</label>
							<div class="col col-5 col-xs-12"> 
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Baslangic Tarihi Girmelisiniz'></cfsavecontent>
									<cfinput required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" style="width:95px;" value="#dateformat(GET_PRICE_CHANGE_DET.STARTDATE,dateformat_style)#" >
									<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
								</div>
							</div>
							<div class="col col-2 col-xs-12">
								<cf_wrkTimeFormat name="start_clock" value="">
									<span class="input-group-addon no-bg"></span>
							</div>
							<div class="col col-2 col-xs-12"> 		
								<select name="start_min" id="start_min" style="width:40px;">
								<cfloop from="0" to="55" index="i" step="5">
								<cfif i lt 10>
									<cfoutput><option value="#i#" <cfif minute(GET_PRICE_CHANGE_DET.startdate) eq i> selected</cfif>>0#i#</option></cfoutput>
								<cfelse>
									<cfoutput><option value="#i#" <cfif minute(GET_PRICE_CHANGE_DET.startdate) eq i> selected</cfif>>#i#</option></cfoutput>
								</cfif>						
								</cfloop>
							</select></div>
						</div>
						<div class="form-group" id="item-reason">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58859.süreç'></label>
							<div class="col col-9 col-xs-12"> 
								<cf_workcube_process 
									is_upd='0' 
									process_cat_width='130' 
									is_detail='0'> 
							</div>
						</div>
						<div class="form-group" id="item-reason">
							<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='37311.Gerekçe'></label>
							<div class="col col-9 col-xs-12"> 
								<textarea name="REASON" id="REASON" style="width:310px;height=70;"></textarea>
							</div>
						</div>
					</div>
				</div>
				<div class="row">
					<div class="col col-12">
						<div class="ListContent">
							<cf_grid_list class="workDevList" id="fiyat_listeleri">
								<thead>
									<tr>
										<th colspan="2"><cf_get_lang dictionary_id='37028.Fiyat Listeleri'></th>
										<th><cf_get_lang dictionary_id='37348.Mevcut Fiyat'></th>
										<th class="txtboldblue" width="35"><cf_get_lang dictionary_id='58716.KDV li'></th>
										<th><cf_get_lang dictionary_id='37306.Yeni Fiyat'></th>
										<th><cf_get_lang dictionary_id='57489.Para Br'></th>				
									</tr>
								</thead>
								<tbody>
								<cfset pricecatid = -2>
								<cfinclude template="../query/get_product_prices.cfm">
									<tr>
										<td><input name="price_cat_list" id="price_cat_list" type="checkbox" value="-2"<cfif ListFind(price_catlist, -2)> checked</cfif>></td>
										<td><cf_get_lang dictionary_id='58721.Standart Satış'></td>
										<td><cfoutput query="get_product_prices">#TLFormat(PRICE)# #MONEY# - (#ADD_UNIT#)<cfif currentrow neq get_product_prices.RecordCount>,</cfif></cfoutput></td>
										<td align="center"><input type="checkbox" name="is_kdv" id="is_kdv" value="-2"<cfif ListFind(price_catlist, -2)><cfif ListGetAt(kdv_list, ListFind(price_catlist, -2))> checked</cfif></cfif>></td>
										<td>
											<cfset yer = ListFind(price_catlist, -2)>
											<cfif yer>
											<cfif ListGetAt(KDV_list, yer) eq 1>
												<cfset price = ListGetAt(price_kdv_list, yer)>
											<cfelse>
												<cfset price = ListGetAt(price_list, yer)>
											</cfif>
											<cfset money_ = ListGetAt(money_list, yer)>
											<cfelse>
												<cfset price = "">
												<cfset money_ = "">
											</cfif>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37416.Yeni Fiyat girmelisiniz'></cfsavecontent>
											<cfinput type="text" name="price_minus_2" value="#TLFormat(price)#" style="width:130px;" message="#message#" validate="float" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
										</td>
										<td>
											<select name="money_minus_2" id="money_minus_2" style="width:70px;">
												<cfoutput query="get_money">
													<option value="#money#"<cfif money_ eq money> selected</cfif>>#money# 
												</cfoutput>
											</select>
										</td>
									</tr>
								<cfset pricecatid = -1>
								<cfinclude template="../query/get_product_prices.cfm">
									<tr>
										<td><input name="price_cat_list" id="price_cat_list" type="checkbox" value="-1"<cfif ListFind(price_catlist, -1)> checked</cfif>></td>
										<td><cf_get_lang dictionary_id='58722.Standart Alış'></td>
										<td><cfoutput query="get_product_prices">#TLFormat(PRICE)# #MONEY# - (#ADD_UNIT#)<cfif currentrow neq get_product_prices.RecordCount>,</cfif></cfoutput></td>
										<td align="center"><input type="checkbox" name="is_kdv" id="is_kdv" value="-1"<cfif ListFind(price_catlist, -1)><cfif ListGetAt(kdv_list, ListFind(price_catlist, -1))> checked</cfif></cfif>></td>
										<td>
											<cfset yer = ListFind(price_catlist, -1)>
											<cfif yer>
												<cfif ListGetAt(KDV_list, yer) eq 1>
													<cfset price = ListGetAt(price_kdv_list, yer)>
												<cfelse>
													<cfset price = ListGetAt(price_list, yer)>
												</cfif>
													<cfset money_ = ListGetAt(money_list, yer)>
												<cfelse>
												<cfset price = "">
												<cfset money_ = "">
											</cfif>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37416.Yeni Fiyat girmelisiniz'></cfsavecontent><!--- required="yes"  --->
											<cfinput type="text" name="price_minus_1" value="#TLFormat(price,4)#" style="width:130px;" message="#message#" validate="float" onkeyup="return(FormatCurrency(this,event,4));" class="moneybox">
										</td>
										<td>
											<select name="money_minus_1" id="money_minus_1" style="width:70px;">
												<cfoutput query="get_money">
													<option value="#money#"<cfif money_ eq money> selected</cfif>>#money#</option>
												</cfoutput>
											</select>
										</td>                  
									</tr>
								<cfoutput query="get_price_cat">
									<cfset pricecatid = price_catid>
									<cfinclude template="../query/get_product_prices.cfm">
									<tr>
										<td><input name="price_cat_list" id="price_cat_list" type="checkbox" value="#price_catid#"<cfif ListFind(price_catlist, price_catid)> checked</cfif>></td>
										<td>#price_cat# </td>
										<td><cfloop query="get_product_prices">#TLFormat(PRICE)# #MONEY# - (#ADD_UNIT#)<cfif currentrow neq get_product_prices.RecordCount>,&nbsp;</cfif></cfloop></td>
										<td align="center"><input type="checkbox" name="is_kdv" id="is_kdv" value="#price_catid#"<cfif ListFind(price_catlist, price_catid)><cfif ListGetAt(kdv_list, ListFind(price_catlist, price_catid))> checked</cfif></cfif>></td>
										<td>
											<cfset yer = ListFind(price_catlist, price_catid)>
											<cfif yer>
												<cfif ListGetAt(KDV_list, yer) eq 1>
													<cfset price = ListGetAt(price_kdv_list, yer)>
												<cfelse>
													<cfset price = ListGetAt(price_list, yer)>
												</cfif>
												<cfset money_ = ListGetAt(money_list, yer)>
											<cfelse>
												<cfset price = "">
												<cfset money_ = "">
											</cfif>
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='37416.Yeni Fiyat girmelisiniz'></cfsavecontent><!--- required="yes"  --->
											<cfinput type="text" name="price_#price_catid#" value="#TLFormat(price,session.ep.our_company_info.purchase_price_round_num)#" style="width:130px;" message="#message#" validate="float" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.purchase_price_round_num#));" class="moneybox">
										</td>
										<td>
											<select name="money_#price_catid#" id="money_#price_catid#" style="width:70px;">
												<cfloop query="get_money">
												<option value="#money#"<cfif money_ eq money> selected</cfif>>#money#</option>
												</cfloop>
											</select>
										</td>                   	
									</tr>				 
								</cfoutput>
							</cf_grid_list>
						</div>
					</div>
				</div>
					<div class="col col-12">
					</div>		<cf_box_footer><cfoutput><cf_record_info query_name="GET_PRICE_CHANGE_DET">
						<cfif not len(GET_PRICE_CHANGE_DET.is_valid) and (GET_PRICE_CHANGE_DET.record_emp eq session.ep.userid)>
							<cf_workcube_buttons is_upd='1' add_function='unformat_fields()' is_delete='0'>
						</cfif>
						<cfif not len(GET_PRICE_CHANGE_DET.is_valid) and len(get_product.PROD_COMPETITIVE) and listfind(COMPETITIVE_LIST,get_product.PROD_COMPETITIVE,",")>
							<input type="hidden" name="valid">
							<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='37869.Fiyat Red Edilecektir Onaylamak istediğinizden emin misiniz'></cfsavecontent>
							<cfsavecontent variable="message2"><cf_get_lang dictionary_id ='37870.Ürün Standart Fiyatı Değişecektir. Onaylamak istediğinizden emin misiniz'></cfsavecontent>
							<input type="button" value="<cf_get_lang dictionary_id='29537.Red'>" onClick="javascript:if (unformat_fields() && confirm('<cfoutput>#message1#</cfoutput>')){price.valid.value = 0; price.submit();}else {return false;}" style="width:65px;">
							<input type="button" value="<cf_get_lang dictionary_id='37039.Kabul'>" onClick="javascript:if (unformat_fields() && confirm('<cfoutput>#message2#</cfoutput>')){price.valid.value = 1; price.submit();} else {return false;}" style="width:65px;">
						</cfif>		
						<input class="ui-wrk-btn ui-wrk-btn-success" type="button" value="<cf_get_lang dictionary_id='57553.Kapat'>" onClick="<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>" name="button">
						</cfoutput>	</cf_box_footer>
					
			</div>
		</div>
	</div>
</cf_box_elements>
</cfform>
</cf_box>
<script type="text/javascript">
	function unformat_fields()
	{
		if
		(
			document.price.price_cat_list[0].checked == false 
			&&
			document.price.price_cat_list[1].checked == false
			<cfoutput query="get_price_cat">
			&&
			document.price.price_cat_list[#currentrow+1#].checked == false
			</cfoutput>
		)
		{
			window.alert("<cf_get_lang dictionary_id ='37346.En az bir liste seçmelisiniz'> !");
			return false;		
		}
		
		if(document.price.price_cat_list[0].checked == true)
		{
			if(document.price.price_minus_2.value == 0 || document.price.price_minus_2.value == '')
			{
				window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
				return false;
			}
		}
		price.price_minus_2.value = filterNum(price.price_minus_2.value);

		if(document.price.price_cat_list[1].checked == true)
		{
			if(document.price.price_minus_1.value == 0 || document.price.price_minus_1.value == '')
			{
				window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
				return false;
			}
		}
		price.price_minus_1.value = filterNum(price.price_minus_1.value,4);

		<cfoutput query="get_price_cat">
		if(document.price.price_cat_list[#currentrow+1#].checked == true)
		{
			if(document.price.price_#price_catid#.value == 0 || document.price.price_#price_catid#.value == '')
			{
				window.alert("<cf_get_lang dictionary_id='37347.Seçili listeler için yeni fiyat girmelisiniz'> !");
				return false;
			}
		}
		price.price_#price_catid#.value = filterNum(price.price_#price_catid#.value,#session.ep.our_company_info.purchase_price_round_num#);
		</cfoutput>
		if (!process_cat_control()) return false;
		return true;
	}	
</script>
