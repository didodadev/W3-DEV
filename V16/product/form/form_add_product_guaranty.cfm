<cfparam name="is_write" default="">
<cfparam name="attributes.process_cat" default="">
<cfquery name="control_product_guaranty" datasource="#DSN3#">
  	SELECT PRODUCT_ID FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
</cfquery>
<cfparam name="attributes.modal_id" default="">

	<cfif control_product_guaranty.recordcount>
		<script type="text/javascript">
			openBoxDraggable('<cfoutput>#request.self#?fuseaction=product.popup_product_guaranty_upd&pid=#url.pid#</cfoutput>','<cfoutput>#attributes.modal_id#</cfoutput>');
		</script>
		<!--- <cflocation url="#request.self#?fuseaction=product.popup_product_guaranty_upd&pid=#url.pid#" addtoken="no"> --->
	<cfelse>
		<cf_box title="#getLang('','Garanti Bilgisi Ekle',37789)# : #get_product_name(product_id:attributes.pid)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
			<cfquery name="get_guaranty_cat" datasource="#dsn#">
				SELECT 
					CURRENCY,
					GUARANTYCAT_TIME,
					MAX_GUARANTYCAT_TIME,
					DETAIL,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP,
					UPDATE_DATE,
					UPDATE_EMP,
					UPDATE_IP,
						CASE
						WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
						ELSE GUARANTYCAT
					END AS GUARANTYCAT,
					GUARANTYCAT_ID
				FROM 
				SETUP_GUARANTY
				LEFT JOIN #DSN#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = SETUP_GUARANTY.GUARANTYCAT_ID
				AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="GUARANTYCAT">
				AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="SETUP_GUARANTY">
				AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
			</cfquery>
			<cfform name="product_guaranty" action="#request.self#?fuseaction=product.emptypopup_product_guaranty_act&PID=#URL.PID#" method="post">
				<input type="hidden" name="record_num" id="record_num" value="0">
				<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.pid#</cfoutput>">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_workcube_process is_upd='0' process_cat_width='170' is_detail='0'>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37052.Satış Garanti Kat'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="sale_guaranty_cat" id="sale_guaranty_cat">
									<cfoutput query="get_guaranty_cat">
										<option value="#GUARANTYCAT_ID#">#GUARANTYCAT#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33895.Satış 2.El Garanti Kategorisi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="sale2_guaranty_cat" id="sale2_guaranty_cat">
									<cfoutput query="get_guaranty_cat">
										<option value="#GUARANTYCAT_ID#">#GUARANTYCAT#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37073.Alış Garanti Kat'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="take_guaranty_cat" id="take_guaranty_cat">
									<cfoutput query="get_guaranty_cat">
										<option value="#GUARANTYCAT_ID#">#GUARANTYCAT#</option>
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
									width="170">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37182.Destek Süre'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="support_duration" id="support_duration">
									<option value="90">3 <cf_get_lang dictionary_id='58724.Ay'></option>
									<option value="180">6 <cf_get_lang dictionary_id='58724.Ay'></option>
									<option value="365">1 <cf_get_lang dictionary_id='58455.yıl'></option>
									<option value="730" selected>2 <cf_get_lang dictionary_id='58455.yıl'></option>
									<option value="1095">3 <cf_get_lang dictionary_id='58455.yıl'></option>
									<option value="1560">4 <cf_get_lang dictionary_id='58455.yıl'></option>
									<option value="1825">5 <cf_get_lang dictionary_id='58455.yıl'></option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37395.Belge Onay Sayısı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="DOCUMENT_APPROVA_NUMBER" value="">
							</div>
						</div>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37394.Belge Onay Tarihi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" maxlength="10" type="text"  name="DOCUMENT_APPROVA_DATE" value="" message="#getLang('','Lutfen Tarih Giriniz',58503)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="DOCUMENT_APPROVA_DATE"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37396.Vize Tarihi'> </label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput validate="#validate_style#" maxlength="10" type="text"  name="VISA_DATE" value="" message="#getLang('','Vize Tarihi Hatalı',37788)#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="VISA_DATE"></span>
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="37128.Red Oranı"> %</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput name="reject_rate" id="reject_rate" type="text" value="" onkeyup="return(FormatCurrency(this,event,8))" validate="float">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37570.Local Seri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_local_serial" id="is_local_serial" value="1">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37387.Tamir Ediliyor'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_repair" id="is_repair" value="1" checked>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='37571.Garanti Belgesi Basılıyor'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="checkbox" name="is_write" id="is_write" value="0">
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons type_format='1' is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("unformat_fields() && loadPopupBox('product_guaranty' , #attributes.modal_id#)"),DE(""))#'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</cfif>

<script type="text/javascript">
	var row_count=0;
	function unformat_fields()
	{
		if(document.product_guaranty.sale_guaranty_cat.value == "" && document.product_guaranty.sale2_guaranty_cat.value == "" && document.product_guaranty.take_guaranty_cat.value == "")
		{
			alert("<cf_get_lang dictionary_id='60491.Satış ve Alış Garanti Kategorilerini Tanımlayınız'>!");
			return false;
		}
		document.getElementById("reject_rate").value=filterNum(document.getElementById("reject_rate").value,8);
		var fld1=document.product_guaranty.DOCUMENT_APPROVA_NUMBER;
		fld1.value=filterNum(fld1.value);		
		return process_cat_control();
		return true;
	}
</script>
