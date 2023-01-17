<cfquery name="get_imp_products" datasource="#dsn3#">
	SELECT
		QUALITY_CONTROL_ID,
		PRODUCT_ID,
		CREATE_UNIT, 
		IMP_DEFINITION,
		IMP_QUANTITY,
		IMP_DATE,
		IMP_SOURCE_ID,
		PROCESS,
		RECORD_EMP,
		RECORD_DATE,
		RECORD_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		UPDATE_IP
	FROM
		IMPROPER_PRODUCTS				
	WHERE
		QUALITY_CONTROL_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quality_control_id#">
</cfquery>
<cfquery name="get_product_info" datasource="#dsn3#">
	SELECT 
		PRODUCT_ID,
		PRODUCT_NAME,
		STOCK_CODE
	FROM 
		ORDER_RESULT_QUALITY 
		LEFT JOIN STOCKS ON ORDER_RESULT_QUALITY.STOCK_ID = STOCKS.STOCK_ID
	WHERE
		 ORDER_RESULT_QUALITY.OR_Q_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quality_control_id#">
</cfquery>
<cfquery name="get_imp_sources" datasource="#dsn3#">
	SELECT IMP_SOURCE_ID,IMP_SOURCE_NAME FROM SETUP_IMPROPRIETY_SOURCE ORDER BY IMP_SOURCE_NAME
</cfquery>
<cfsavecontent variable="title">
	<cf_get_lang dictionary_id='36484.Uygun Olmayan Ürün Formu'>
</cfsavecontent>
<cf_box title="#title#" popup_box="1"><!--- #lang_array.item[42]# --->
	<cfform name="upd_improper_products" method="post" action="#request.self#?fuseaction=stock.emptypopup_upd_improper_products"  onsubmit="return (UnformatFields());">
		<cfinput type="hidden" name="quality_control_id" value="#attributes.quality_control_id#">
		<cf_box_elements>
			<div class="col col-7 col-md-7 col-sm-7 col-xs-12" type="column" sort="true" index="1">
				<input type="hidden" name="product_id" id="product_id" value="<cfif len(get_product_info.product_id)><cfoutput>#get_product_info.product_id#</cfoutput></cfif>">
				<div class="form-group">
					<label class="col col-4 col-sm-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57518.Stok Kodu'></label>
					<div class="col col-8 col-sm-8 col-md-8 col-xs-12">
						<cfif len(get_product_info.product_id)><cfoutput>#get_product_info.stock_code#</cfoutput></cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='44019.Ürün'>/<cf_get_lang dictionary_id='40582.Malzeme Adı'></label>
					<div class="col col-8 col-sm-8 col-md-8 col-xs-12">
						<cfif len(get_product_info.product_id)><cfoutput>#get_product_info.product_name#</cfoutput></cfif>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-sm-4 col-md-4 col-xs-12"><cf_get_lang no="86.Uygunsuzluk Kaynağı"></label>
					<div class="col col-8 col-sm-8 col-md-8 col-xs-12">
						<select name="imp_source_id" id="imp_source_id">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="get_imp_sources">
								<option value="#imp_source_id#"<cfif imp_source_id eq get_imp_products.imp_source_id>selected</cfif>>#imp_source_name#</option>
							</cfoutput> 
						</select>
					</div>
				</div>
				<cf_duxi type="text" name="imp_definition" id="imp_definition" label="40585" hint="uygunsuzluk Tanımı" style="width:140px;" maxlength="50" value="#get_imp_products.imp_definition#">
				<cf_duxi type="text" name="imp_quantity" id="imp_quantity" label="57685" hint="Miktar" class="moneybox" onkeyup="return(FormatCurrency(this,event));" maxlength="10" value="#TLFormat(get_imp_products.imp_quantity)#">
				<cf_duxi type="text" name="create_unit" id="create_unit" label="40584" hint="oluştuğu Birim" style="width:140px;" maxlength="50" value="#get_imp_products.create_unit#">
				<cfif len(get_imp_products.imp_date)>
					<cf_duxi name="imp_date" type="text" data_control="date"  value="#dateformat(get_imp_products.imp_date,dateformat_style)#"  hint="Tarihi *" label="30631">   
					<cfelse>
						<cf_duxi name="imp_date" type="text" data_control="date"  value="#dateformat(now(),dateformat_style)#"  hint="Tarihi *" label="30631">   
					</cfif>
					<cf_duxi  name="process" type="textarea" id="process"  label="40588" maxlength="100" onkeyup="return ismaxlength(this);" value="#get_imp_products.process#">
				</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="get_imp_products">
			<cfif get_imp_products.recordcount>
				<cf_workcube_buttons is_upd='1' is_delete="0" add_function="UnformatFields()">
			<cfelse>
				<cf_workcube_buttons is_upd='0' add_function="UnformatFields()">
			</cfif>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
function UnformatFields()
{
	document.getElementById('imp_quantity').value = filterNum(document.getElementById('imp_quantity').value);
	if(imp_date.value == '')
        {
            alertObject({message: "Lütfen tarihi doldurunuz!"});
            return false;
        }
        
            return true;
        }
}
</script>
