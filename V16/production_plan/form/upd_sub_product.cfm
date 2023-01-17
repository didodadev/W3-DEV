<cfparam name="attributes.is_used_rate" default="0">
<cfquery name="get_protree_detail" datasource="#DSN3#">
	SELECT
		LINE_NUMBER,
		STOCK_ID,
		PRODUCT_ID,
		PROCESS_STAGE,
		RELATED_ID,
		UNIT_ID,
		SPECT_MAIN_ID,
		OPERATION_TYPE_ID,
		AMOUNT,
		FIRE_AMOUNT,
		FIRE_RATE,
		DETAIL,
		QUESTION_ID,
		IS_CONFIGURE,
		IS_FREE_AMOUNT,
		IS_SEVK,
		IS_PHANTOM,
		PRODUCT_WIDTH,
		PRODUCT_LENGTH,
		PRODUCT_HEIGHT,
		TREE_TYPE
	FROM
		PRODUCT_TREE
	WHERE
		PRODUCT_TREE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pro_tree_id#">
</cfquery>
<cfquery name="get_tree_types" datasource="#dsn#">
	SELECT TYPE_ID, #dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','PRODUCT_TREE_TYPE','TYPE',NULL,NULL,TYPE) AS TYPE
	 FROM PRODUCT_TREE_TYPE
</cfquery>
<cfquery name="get_alternative_questions" datasource="#dsn#">
	SELECT QUESTION_ID,QUESTION_NAME FROM SETUP_ALTERNATIVE_QUESTIONS
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform action="#request.self#?fuseaction=prod.emptypopup_upd_sub_product" method="post" name="upd_sub_product">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='63535.Bileşen'></cfsavecontent>
		<cf_box title="#title#" closable="1" popup_box="1">
			<input type="hidden" name="history_stock" id="history_stock" value="<cfif isdefined('attributes.history_stock')><cfoutput>#attributes.history_stock#</cfoutput></cfif>">
			<input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfoutput>#get_protree_detail.stock_id#</cfoutput>">
			<input type="hidden" name="pro_tree_id" id="pro_tree_id" value="<cfoutput>#attributes.pro_tree_id#</cfoutput>">
			<input type="hidden" name="is_draggable" value="<cfif isdefined("attributes.draggable")><cfoutput>#attributes.draggable#</cfoutput><cfelse>0</cfif>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<cfif isdefined('attributes.is_show_line_number') and attributes.is_show_line_number eq 1>
						<div class="form-group">
							<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='58577.Sıra'></label>
							<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
								<input type="text" name="line_number" id="line_number" style="width:40px;text-align:right;" value="<cfoutput>#get_protree_detail.LINE_NUMBER#</cfoutput>">
							</div>
						</div>
					</cfif>
					<div class="form-group" id="form_ul_tree_types">
						<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='63502.Bileşen Tipi'></label>
						<div class="col col-9 col-xs-12">
							<select name="tree_types" id="tree_types">
								<option value=""><cf_get_lang dictionary_id='63502.Bileşen Tipi'></option>
								<cfloop query="get_tree_types">
									<cfoutput><option value="#TYPE_ID#"<cfif TYPE_ID  eq get_protree_detail.TREE_TYPE >selected</cfif>>#TYPE#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cf_workcube_process is_upd='0' process_cat_width='150' is_detail='0' select_value='#get_protree_detail.process_stage#'>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="input-group">
								<cfif get_protree_detail.RELATED_ID GT 0>
									<cfquery name="get_pro_name" datasource="#DSN3#">
										SELECT
											PRODUCT.PRODUCT_NAME,
											PRODUCT.PRODUCT_ID,
											STOCKS.PROPERTY,
											PRODUCT.IS_PROTOTYPE
										FROM
											PRODUCT,
											STOCKS
										WHERE
											PRODUCT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
											STOCKS.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_protree_detail.RELATED_ID#">
									</cfquery>
								<cfelse>
									<cfset get_protree_detail.RELATED_ID =''>
									<cfset get_protree_detail.UNIT_ID =''>
									<cfset get_protree_detail.SPECT_MAIN_ID =''> 
									<cfset get_pro_name.PRODUCT_NAME = ''>
									<cfset get_pro_name.PRODUCT_ID = ''>
									<cfset get_pro_name.PROPERTY = ''>
								</cfif>
								<input type="hidden" name="unit_id" id="unit_id" value="<cfoutput>#get_protree_detail.UNIT_ID#</cfoutput>">
								<input type="hidden" name="related_id" id="related_id" value="<cfoutput>#get_protree_detail.RELATED_ID#</cfoutput>">
								<input type="hidden" id="product_id" name="product_id" value="<cfoutput>#get_pro_name.PRODUCT_ID#</cfoutput>">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
								<cfinput type="text" required="yes" id="product_name" name="product_name" value="#get_pro_name.PRODUCT_NAME# #get_pro_name.PROPERTY#" message="#message#" style="width:150px;"onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product_autocomplete','0','STOCK_ID,PRODUCT_UNIT_ID,PRODUCT_ID','related_id,unit_id,product_id','upd_sub_product','3','225','get_product_main_spec_row()');">
								<span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=upd_sub_product.related_id&field_name=upd_sub_product.product_name&product_id=upd_sub_product.product_id&field_unit=upd_sub_product.unit_id&stock_and_spect=1&field_spect_main_id=upd_sub_product.spect_main_id&field_spect_main_name=upd_sub_product.spect_main_name','page')"></span>
							</div>
						</div>
					</div>	
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='57647.Spec'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<div class="input-group">
								<cfinput type="hidden" name="spect_main_name" value=""  readonly="yes">
								<input type="text" name="spect_main_id" id="spect_main_id" readonly style="width:150px;"  value="<cfoutput>#get_protree_detail.SPECT_MAIN_ID#</cfoutput>">						
								<span class="input-group-addon icon-ellipsis btnPoniter" href="javascript://" onclick="open_spec();"></span>
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='29419.Operasyon'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cf_wrkOperationType width='150' control_status='1' operation_type_id='#get_protree_detail.operation_type_id#'>
						</div>
					</div> 
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cfif attributes.is_used_rate eq 0><cf_get_lang dictionary_id='57635.Miktar'><cfelse>%</cfif></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57635.Miktar'></cfsavecontent>
							<cfset new_amount = wrk_round(get_protree_detail.AMOUNT,8,1)>
							<input name="amount" id="amount" type="text" value="<cfoutput>#Tlformat(new_amount,8,0)#</cfoutput>" style="width:150px;" required="yes" validate="float" message="<cfoutput>#message#</cfoutput>" onClick="this.select();" onkeyup="fire_control();return(FormatCurrency(this,event,8))">
						</div>
					</div>
					<cfif is_used_abh eq 1>
						<cfoutput>
							<div class="form-group" id="form_ul_abh">
								<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='42999.A*b*h'></label>
								<div class="col col-9 col-xs-12">                                        
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="text" class="" value="#get_protree_detail.PRODUCT_WIDTH#" name="product_width">
									</div>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="text" class="" value="#get_protree_detail.PRODUCT_LENGTH#" name="product_length">
									</div>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="text" class="" value="#get_protree_detail.PRODUCT_HEIGHT#" name="product_height">
									</div>                                   					
								</div>
							</div>
						</cfoutput>
					</cfif>
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="37273.Fire Miktar"></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<cfset new_amount = wrk_round(get_protree_detail.FIRE_AMOUNT,8,1)>
							<input name="fire_amount" id="fire_amount" type="text" value="<cfoutput>#Tlformat(new_amount,8,0)#</cfoutput>" style="width:150px;" validate="float" onkeyup="fire_control();return(FormatCurrency(this,event,8));">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="36357.Fire Oran"></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<input name="fire_rate" id="fire_rate" type="text" value="<cfoutput>#wrk_round(get_protree_detail.FIRE_RATE,2)#</cfoutput>" style="width:150px;" validate="float" onkeyup="return(FormatCurrency(this,event,8))" readonly="yes">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<input type="text" name="detail" id="detail" value="<cfoutput>#get_protree_detail.DETAIL#</cfoutput>" style="width:150px;" maxlength="150">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12">
					<div class="form-group">
						<label class="col col-3 col-md-3 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='36625.Alternatif Soru'></label>
						<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
							<select name="alternative_questions" id="alternative_questions" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>
								<cfloop query="get_alternative_questions">
									<cfoutput><option value="#QUESTION_ID#" <cfif get_protree_detail.QUESTION_ID eq QUESTION_ID>selected</cfif>>#QUESTION_NAME#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12 col-md-12 col-xs-12">
							<input type="checkbox" name="is_configure" id="is_configure" value="0" <cfif get_protree_detail.IS_CONFIGURE eq 0>checked</cfif>><cf_get_lang dictionary_id='57236.Standart'>- <cf_get_lang dictionary_id='36799.Konfigure Edilemez'>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12 col-md-12 col-xs-12">
							<input type="checkbox" name="is_free_amount" id="is_free_amount" value="1" <cfif get_protree_detail.IS_FREE_AMOUNT eq 1>checked</cfif>><cf_get_lang dictionary_id='36355.Miktardan Bağımsız'>
						</div>
					</div>
					<div class="form-group">
						<div class="col col-12 col-md-12 col-xs-12">
							<input type="checkbox" name="is_sevk" id="is_sevk" value="1" <cfif get_protree_detail.IS_SEVK eq 1>checked</cfif>><cf_get_lang dictionary_id='36615.Sevkte Birleştir'>
						</div>
					</div>
					<cfif x_is_phantom_tree eq 1>
						<div class="form-group">
							<div class="col col-12 col-md-12 col-xs-12">
								<input type="checkbox" name="is_phantom" id="is_phantom" value="1"<cfif get_protree_detail.IS_PHANTOM eq 1>checked</cfif>><cf_get_lang dictionary_id='44969.Fantom'>- <cf_get_lang dictionary_id='36362.Bu Ürün İçin Üretim Emri Oluşturma'>
							</div>
						</div>
					</cfif>
				</div>
			</cf_box_elements>
			<div class="ui-form-list-btn"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></div>
		</cf_box>
	</cfform>
</div>
<script type="text/javascript">
	function get_product_main_spec_row()
	{
		if(document.getElementById('related_id').value != "" && document.getElementById('product_name').value != "")
		{
			//spec_main_id de düştüğü için bu bloğa sokmuyoruz sadece istasyonunu seçili getiriyoruz.
			var listParam = document.getElementById('related_id').value;
			QueryTextSpec = 'prdp_get_main_spec_id_3';
			var get_main_spec_id = wrk_safe_query(QueryTextSpec,'dsn3',0,listParam);
			if(get_main_spec_id.recordcount)
			{
				document.getElementById('spect_main_id').value = get_main_spec_id.SPECT_MAIN_ID ;
				document.getElementById('spect_main_name').value = get_main_spec_id.SPECT_MAIN_NAME ;
			}
			else{
				document.getElementById('spect_main_id').value = "";
				document.getElementById('spect_main_name').value = "";
			}
		}	
		else
			alert('<cf_get_lang dictionary_id="36831.Önce Ürün Seçiniz">');
	}
	function open_spec()
	{
		
		if(document.upd_sub_product.related_id.value!='' && document.upd_sub_product.product_name.value!='' ){
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_spect_main&field_name=upd_sub_product.spect_main_name&field_main_id=upd_sub_product.spect_main_id&stock_id='+document.upd_sub_product.related_id.value,'list')
		}
		else
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
	}
	
	function fire_control()
	{
		
        var amount_=parseFloat(filterNum(document.upd_sub_product.amount.value,8));
        var fire_amount_= parseFloat(filterNum(document.upd_sub_product.fire_amount.value,8));
	
       
		if(document.upd_sub_product.amount.value != '' && document.upd_sub_product.fire_amount.value!='')
		{
			var fire_operation=(100* fire_amount_)/amount_;
			fire_operation=fire_operation.toFixed(2);
			document.upd_sub_product.fire_rate.value=fire_operation;
			
		}
		else{
			document.upd_sub_product.fire_rate.value=''
			
		}
	
	}
    
	
	function kontrol()
	{
		
		var amount_=parseFloat(filterNum(document.upd_sub_product.amount.value,8));

	
		 if(document.upd_sub_product.fire_amount.value !=''  && document.upd_sub_product.amount.value != '')
		{
			
        	var fire_amount_=parseFloat(filterNum(document.upd_sub_product.fire_amount.value,8));
			
		
			if(fire_amount_ >= amount_){
                alert("<cf_get_lang dictionary_id='51075.Fire miktarı bileşen miktarından büyük veya eşit olamaz'>");
                    return false;
                } 
		
		} 
		
		if(document.upd_sub_product.related_id.value=='' && (document.getElementById('process') && document.getElementById('process').value ==""))
		{
			alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57657.Ürün'>");
			return false;
		}
		if(amount_ == 0)
		{
			alert("<cf_get_lang dictionary_id='36359.Miktar Sıfırdan Büyük Olmalıdır'> !");
			return false;
		}
		if(	document.upd_sub_product.fire_amount.value == '' )
		{
			document.upd_sub_product.amount.value=parseFloat(filterNum(document.upd_sub_product.amount.value,8));
		}
		else{
			document.upd_sub_product.amount.value=parseFloat(filterNum(document.upd_sub_product.amount.value,8));
		    document.upd_sub_product.fire_amount.value=parseFloat(filterNum(document.upd_sub_product.fire_amount.value,8));
			}

			
		
		
		return process_cat_control();
	}
</script>