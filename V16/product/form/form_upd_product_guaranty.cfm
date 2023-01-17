<cfquery name="get_guaranty_cat" datasource="#dsn#">
	SELECT * FROM SETUP_GUARANTY
</cfquery>
<cfquery name="get_product_guaranty" datasource="#dsn3#">
	SELECT * FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.PID#">
</cfquery>

<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','Garanti Kategorisi',37176)# : #get_product_name(product_id:attributes.pid)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="product_guaranty" action="#request.self#?fuseaction=product.emptypopup_product_guaranty_upd_act&PID=#URL.PID#" method="post" onsubmit="return process_cat_control();">
		<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cf_workcube_process is_upd='0' select_value='#get_product_guaranty.process_stage#' process_cat_width='170' is_detail='1'>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37052.Satış Garanti Kategorisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="sale_guaranty_cat" id="sale_guaranty_cat">
							<cfoutput query="get_guaranty_cat">
							<option value="#GUARANTYCAT_ID#" <cfif GUARANTYCAT_ID EQ get_product_guaranty.SALE_GUARANTY_CAT_ID>SELECTED</cfif>>#GUARANTYCAT#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37607.Satış 2 el Garanti Kategorisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="sale2_guaranty_cat" id="sale2_guaranty_cat">
							<cfoutput query="get_guaranty_cat">
								<option value="#GUARANTYCAT_ID#" <cfif GUARANTYCAT_ID EQ get_product_guaranty.SALE2_GUARANTY_CAT_ID>SELECTED</cfif>>#GUARANTYCAT#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37073.Alış Garanti Kat'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="take_guaranty_cat" id="take_guaranty_cat">
							<cfoutput query="get_guaranty_cat">
								<option value="#GUARANTYCAT_ID#" <cfif GUARANTYCAT_ID EQ get_product_guaranty.TAKE_GUARANTY_CAT_ID>SELECTED</cfif>>#GUARANTYCAT#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37180.Destek Kategorisi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cf_wrk_combo
							name="support_cat"
							query_name="GET_SUPPORT"
							option_name="SUPPORT_CAT"
							option_value="SUPPORT_CAT_ID"
							value="#get_product_guaranty.SUPPORT_CAT_ID#"
							width="170">
					</div>
				</div>	
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37182.Destek Süre'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<select name="support_duration" id="support_duration">
							<option value="90" <cfif get_product_guaranty.support_duration EQ 90>SELECTED</cfif>>3 <cf_get_lang dictionary_id='58724.Ay'></option>
							<option value="180" <cfif get_product_guaranty.support_duration EQ 180>SELECTED</cfif>>6 <cf_get_lang dictionary_id='58724.Ay'></option>
							<option value="365" <cfif get_product_guaranty.support_duration EQ 365>SELECTED</cfif>>1 <cf_get_lang dictionary_id='58455.yıl'></option>
							<option value="730" <cfif get_product_guaranty.support_duration EQ 730>SELECTED</cfif>>2 <cf_get_lang dictionary_id='58455.yıl'></option>
							<option value="1095" <cfif get_product_guaranty.support_duration EQ 1095>SELECTED</cfif>>3 <cf_get_lang dictionary_id='58455.yıl'></option>
							<option value="1560"  <cfif get_product_guaranty.support_duration EQ 1590>SELECTED</cfif>>4 <cf_get_lang dictionary_id='58455.yıl'></option>
							<option value="1825" <cfif get_product_guaranty.support_duration EQ 1825>SELECTED</cfif>>5 <cf_get_lang dictionary_id='58455.yıl'></option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37395.Belge Onay Sayısı'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput type="text" name="DOCUMENT_APPROVA_NUMBER"  value="#get_product_guaranty.DOCUMENT_APPROVA_NUMBER#" onkeyup="return(FormatCurrency(this,event));">
					</div>
				</div>
			</div>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37394.Belge Onay Tarihi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput validate="#validate_style#" maxlength="10" type="text" name="DOCUMENT_APPROVA_DATE" value="#dateformat(get_product_guaranty.DOCUMENT_APPROVA_DATE,dateformat_style)#" message="#getLang('','Belge Onay Tarihi Hatalı',37796)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="DOCUMENT_APPROVA_DATE"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37396.Vize Tarihi'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<cfinput validate="#validate_style#" maxlength="10" type="text" name="VISA_DATE" value="#dateformat(get_product_guaranty.VISA_DATE,dateformat_style)#" message="#getLang('','Vize Tarihi Hatalı',37797)#">
							<span class="input-group-addon"><cf_wrk_date_image date_field="VISA_DATE"></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="37128.Red Oranı"> %</label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<cfinput name="reject_rate" id="reject_rate" type="text" value="#TLFormat(get_product_guaranty.REJECT_RATE)#" onkeyup="return(FormatCurrency(this,event,8))" validate="float">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37570.Local Seri'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_local_serial" id="is_local_serial" value="1" <cfif get_product_guaranty.is_local_serial eq 1>checked</cfif>>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37387.Tamir Ediliyor'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_repair" id="is_repair" value="1" <cfif get_product_guaranty.IS_REPAIR eq 1>checked</cfif>>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37571.Garanti Belgesi Basılıyor'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
						<input type="checkbox" name="is_write" id="is_write" value="1" <cfif get_product_guaranty.IS_GUARANTY_WRITE eq 1>checked</cfif>>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_product_guaranty">
			<cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' add_function='product_guaranty_control() #iif(isdefined("attributes.draggable"),DE("&& loadPopupBox('product_guaranty' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
    </cfform>
</cf_box>
<script>
	function product_guaranty_control()
	{
		product_guaranty.reject_rate.value =  filterNum(product_guaranty.reject_rate.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		product_guaranty.DOCUMENT_APPROVA_NUMBER.value =  filterNum(product_guaranty.DOCUMENT_APPROVA_NUMBER.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		return true;
	}
</script>