<cfif isDefined('session.ep')>
	<cf_xml_page_edit  default_value="0" fuseact="objects.popup_upd_stock_serialno">
</cfif>
<cfparam name="attributes.product_amount" default=0>
<cfparam name="attributes.product_amount_2" default=0>
<cfparam name="attributes.product_id" default="">
<cfparam name="SALE_PRODUCT " default=0>
<cfparam name="attributes.process_number" default=0>
<cfparam name="attributes.spect_id" default=0>
<cfparam name="attributes.LOCATION_IN" default="">
<cfparam name="attributes.SALE_PRODUCT" default="">
<cfparam name="attributes.department_in" default="">
<cfparam name="attributes.lot_no" default="">
<cf_get_lang_set module_name='objects'>
<script type="text/javascript">
	var ff=null;
	var eee=null;
	var sil=0;
	var tmp1;
	var tmp2;
	function ttt()
	{
		try
		{
			i++;
			bb=tmp1;
			hwpage = i*100;
			bb += "&page=" + hwpage;
			AjaxPageLoad(bb,'PLACE_'+i);
			//ff = setTimeout(ttt,500);
		}
		catch(e) {}
	}
	function kkk()
	{
		try
		{
			i++;
			cc=tmp2;
			hwpage = i*100;
			cc += "&page=" + hwpage;
			AjaxPageLoad(cc,'PLACE_'+i);
			eee = setTimeout(kkk,500);
		}
		catch(e) {}
	}
</script>
<cfset kontrol_seri_no = 1>
<cfinclude template="../query/get_product_name.cfm">
<cfif product_name.recordcount eq 0>
	<script>
		alert("<cf_get_lang dictionary_id='30375.Seçilen Ürün İçin Seri No Takibi Yapılmamaktadır'> !");
		window.close();
	</script>
</cfif>
<cfinclude template="../query/get_serial_info.cfm">
<cfif not isdefined("attributes.recorded_count")><cfset attributes.recorded_count = 0></cfif>
<cfif isdefined("attributes.wrk_row_id") and len(attributes.wrk_row_id) and attributes.wrk_row_id neq 0>
	<cfquery name="get_seri_count" datasource="#dsn3#">
		SELECT 
			SERIAL_NO,
			STOCK_ID,
			PROCESS_ID,
			PERIOD_ID,
			UNIT_TYPE UNIT
		FROM 
			SERVICE_GUARANTY_NEW 
		WHERE 
			STOCK_ID = #attributes.stock_id#
			<cfif isdefined("attributes.process_id") and len(attributes.process_id)>
				AND PROCESS_ID = #attributes.process_id#
			</cfif>
			<cfif isdefined("attributes.process_number") and len(attributes.process_number)>
				AND PROCESS_NO = '#attributes.process_number#'
			</cfif>
			AND PERIOD_ID = #session.ep.period_id#
			AND WRK_ROW_ID = '#attributes.wrk_row_id#'
		GROUP BY 
			SERIAL_NO,
			STOCK_ID,
			PROCESS_ID,
			PERIOD_ID,
			UNIT_TYPE
	</cfquery>
	<cfset attributes.recorded_count = get_seri_count.recordcount>
</cfif>
<cfset attributes.product_amount_2 = ( len(attributes.product_amount_2) ? attributes.product_amount_2 : 0 ) >
<cfif  isdefined("get_seri_count") and get_seri_count.unit eq 1>
	<cfset range_number = attributes.product_amount>
	<cfset range_number_2 = attributes.product_amount_2 - attributes.recorded_count>
<cfelse>
	<cfset range_number = attributes.product_amount - attributes.recorded_count>	
	<cfset range_number_2 = attributes.product_amount_2>
</cfif>
<cfif not isdefined("attributes.amount")><cfset attributes.amount = range_number></cfif>
<cfif not isdefined("attributes.amount_2")><cfset attributes.amount_2 = range_number_2></cfif>
<cfif listfindnocase('171,76,74,73,114,110,1190',attributes.process_cat,',')>
	<cfquery name="get_stock_info" datasource="#dsn3#">
		SELECT S.PRODUCT_ID,S.SERIAL_BARCOD,STOCK_CODE FROM STOCKS S,PRODUCT_GUARANTY PG WHERE S.STOCK_ID = #attributes.STOCK_ID# AND S.PRODUCT_ID = PG.PRODUCT_ID AND PG.IS_LOCAL_SERIAL = 1
	</cfquery>
	<cfset stock_ = "#attributes.STOCK_ID#">
	<cfif get_stock_info.recordcount>
		<cfif x_serial_no_create_type eq 0>
        	<cfif isdefined("x_serial_no_create_type_modify") and  x_serial_no_create_type_modify eq 1>
            	<cfset stock_ = stock_>
            <cfelse>
                <cfloop from="1" to="#6-len(attributes.STOCK_ID)#" index="smk">
                    <cfset stock_ = "0" & stock_>
                </cfloop>
            </cfif>
			<cfif len(get_stock_info.serial_barcod)>
				<cfset seri_ = get_stock_info.serial_barcod + 1>
			<cfelse>
				<cfset seri_ = 1>
			</cfif>
			<cfset my_seri_ = seri_>
			<cfloop from="1" to="#8-len(seri_)#" index="smk">
				<cfset my_seri_ = "0" & my_seri_>
			</cfloop>
		<cfelseif x_serial_no_create_type eq 1>
			<cfset b_1_1 = left(PRODUCT_NAME.PRODUCT_CODE_2,10)>
			<cfloop from="1" to="#10-len(b_1_1)#" index="smk">
				<cfset b_1_1 = "0" & b_1_1>
			</cfloop>
			<cfset b_1_2 = dateformat(now(),'yy')>
			
			<cfset b_2_1 = dateformat(now(),'mm')>
			<cfloop from="1" to="#2-len(b_2_1)#" index="smk">
				#smk#
				<cfset b_2_1 = "0" & b_2_1>
			</cfloop>
			
			<cfset b_2_2 = left(PRODUCT_NAME.SHELF_LIFE,2)>
			<cfloop from="1" to="#2-len(b_2_2)#" index="smk">
				<cfset b_2_2 = "0" & b_2_2>
			</cfloop>
			
			<cfset stock_ = "#b_1_1##b_1_2#">
			<cfset my_seri_ = "#b_2_1##b_2_2#">
			
			<cfquery name="get_olds" datasource="#dsn3#">
				SELECT TOP 1 SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO LIKE '#stock_#%' AND SERIAL_NO LIKE '%#my_seri_#' AND STOCK_ID = #attributes.STOCK_ID# ORDER BY SERIAL_NO DESC
			</cfquery>
			<cfif get_olds.recordcount>
				<cfset serial_no_ = get_olds.serial_no>
				<cfset serial_no_ = replace(serial_no_,'#stock_#','')>
				<cfset serial_no_ = replace(serial_no_,'#my_seri_#','')>
				<cfset serial_no_ = int(serial_no_)>
				<cfset seri_ = serial_no_ + 1>
			<cfelse>
				<cfset seri_ = 1>
			</cfif>
			<cfset seri_baslangic_ = seri_>
			<cfloop from="1" to="#6-len(seri_baslangic_)#" index="smk">
				<cfset seri_baslangic_ = "0" & seri_baslangic_>
			</cfloop>
		<cfelseif x_serial_no_create_type eq 2>
			<cfquery name="get_ek_bilgi" datasource="#dsn3#">
				SELECT TOP 1 PROPERTY19 FROM PRODUCT_INFO_PLUS WHERE PRODUCT_ID = #get_stock_info.PRODUCT_ID#
			</cfquery>
			<cfif get_ek_bilgi.recordcount and len(get_ek_bilgi.PROPERTY19)>
				<cfset ek_bilgi_ = "#get_ek_bilgi.PROPERTY19#">
			<cfelse>
				<cfset ek_bilgi_ = "000">
			</cfif>
			<cfset year_ = dateformat(now(),'yy')>
			<cfset my_seri_ = "#ek_bilgi_##year_#">
			<cfquery name="get_olds" datasource="#dsn3#">
				SELECT TOP 1 SERIAL_NO FROM SERVICE_GUARANTY_NEW WHERE SERIAL_NO LIKE '#my_seri_#%' AND STOCK_ID = #attributes.STOCK_ID# ORDER BY SERIAL_NO DESC
			</cfquery>
			<cfif get_olds.recordcount>
				<cfset serial_no_ = get_olds.serial_no>
				<cfset serial_no_ = replace(serial_no_,'#my_seri_#','')>
				<cfset serial_no_ = int(serial_no_)>
				<cfset seri_ = serial_no_ + 1>
			<cfelse>
				<cfset seri_ = 1>
			</cfif>
			
			<cfset seri_baslangic_ = seri_>
			<cfloop from="1" to="#6-len(seri_baslangic_)#" index="smk">
				<cfset seri_baslangic_ = "0" & seri_baslangic_>
			</cfloop>
		</cfif>
		<cfset local_seri_kontrol = 1>
	<cfelse>
		<cfset stock_ = "">
		<cfset my_seri_ = "">
		<cfset local_seri_kontrol = 0>
		<cfset seri_ = "">
		<cfset seri_baslangic_ = "">
		<cfset b_1_1 = "">
		<cfset b_2_1 = "">
		<cfset b_2_2 = "">
	</cfif>
<cfelse>
	<cfset stock_ = "">
	<cfset my_seri_ = "">
	<cfset local_seri_kontrol = 0>
	<cfset seri_ = "">
	<cfset seri_baslangic_ = "">
	<cfset b_1_1 = "">
	<cfset b_1_2 = "">
	<cfset b_2_1 = "">
	<cfset b_2_2 = "">
</cfif>
<cfsavecontent variable="head_">
<cf_get_lang dictionary_id='57637.Seri No'><cf_get_lang dictionary_id='32497.Garanti Giriş'> - <cfif sale_product eq 1><cf_get_lang dictionary_id='57448.Satış'><cfelse><cf_get_lang dictionary_id='58176.Alış'></cfif>
</cfsavecontent>
<cfsavecontent variable="right">
<cfoutput>
    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_add_stock_barcode&stock_id=#PRODUCT_NAME.STOCK_ID#&is_terazi=#PRODUCT_NAME.IS_TERAZI#','medium');"><img src="/images/barcode.gif" border="0" title="<cf_get_lang dictionary_id='57633.Barkod'>"></a>
    <a href="#request.self#?fuseaction=objects.emptypopup_add_serial_to_file<cfif isdefined("attributes.wrk_row_id")>&wrk_row_id=#attributes.wrk_row_id#</cfif>&product_amount=#attributes.product_amount#&recorded_count=#attributes.recorded_count#&product_id=#attributes.product_id#&stock_id=#attributes.stock_id#&process_number=#attributes.process_number#&process_cat=#attributes.process_cat#&process_id=#attributes.process_id#&is_serial_no=1&spect_id=<cfif len(attributes.spect_id)>#attributes.spect_id#</cfif>"><img src="/images/file.gif" title="<cf_get_lang dictionary_id ='33858.Dosyaya Aktar'>" border='0'></a>
    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_dsp_product_guaranty&pid=#attributes.product_id#','small');"><img src="/images/help_quaranty.gif" title="<cf_get_lang dictionary_id ='33859.Garanti Bilgisi'>" border='0'></a>
    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_serial_no_search&product_id=#attributes.product_id#&<cfif isdefined("attributes.is_store") and attributes.is_store eq 1>&is_store=1</cfif>','small');"><img src="/images/barcode.gif" border="0" title="<cf_get_lang dictionary_id ='33860.Seri No Ara'>"></a> 
    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#attributes.process_cat#&action_id=#attributes.process_id#&action_row_id=#attributes.STOCK_ID#&print_type=192','page');"><img src="/images/barcode_print.gif" title="<cf_get_lang dictionary_id='57474.Yazdır'>" border="0"></a>
</cfoutput>
</cfsavecontent>

<cf_catalystHeader>
<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
	<cf_box title="#head_#" resize="0" collapsable="0">
		<!--- ekleme ekrani --->
		<cfif isdefined("attributes.loc_id")>
			<cfset attributes.loc_id = attributes.loc_id>
			<cfset attributes.dept_id = attributes.dept_id>	
		<cfelseif listfindnocase('76,77,82,84,86,140',attributes.process_cat,',') and not isdefined("attributes.loc_id")>  
			<cfset attributes.loc_id = attributes.location_in>
			<cfset attributes.dept_id = attributes.department_in>
		<cfelseif listfindnocase('70,71,72,83,85,111,141',attributes.process_cat,',')>  
			<cfset attributes.loc_id = attributes.location_out>
			<cfset attributes.dept_id = attributes.department_out>
		<cfelseif listfindnocase('81,811,113',attributes.process_cat,',')>  
			<cfset attributes.loc_id = attributes.location_out>
			<cfset attributes.dept_id = attributes.department_out>
			<cfset attributes.loc_id2 = attributes.location_in>
			<cfset attributes.dept_id2 = attributes.department_in>
		<cfelseif isdefined("attributes.location_in") and len(attributes.location_in)>
			<cfset attributes.loc_id = attributes.location_in>
			<cfset attributes.dept_id = attributes.department_in>
		<cfelseif isdefined("attributes.location_out")>
			<cfset attributes.loc_id = attributes.location_out>
			<cfset attributes.dept_id = attributes.department_out>
		</cfif>
		<cfif isdefined("get_seri_count.unit") and ((range_number gt 0 and get_seri_count.unit neq 1) or (range_number_2 gt 0 and get_seri_count.unit eq 1))>
			<cfinclude template="../query/get_guaranty_cat.cfm">
			<cfform name="add_guaranty_" id="add_guaranty_" action="#request.self#?fuseaction=objects.emptypopup_add_stock_serialno"  method="post" enctype="multipart/form-data">
				<cfoutput>
				<input type="hidden" name="main_stock_id" id="main_stock_id" value="<cfif isdefined("attributes.main_stock_id")>#attributes.main_stock_id#</cfif>">
				<input type="hidden" name="spect_id" id="spect_id" value="<cfif isdefined("attributes.spect_id")>#attributes.spect_id#</cfif>">
				<input type="hidden" name="process_cat" id="process_cat" value="#attributes.process_cat#">
				<input type="hidden" name="x_serial_no_create_type" id="x_serial_no_create_type" value="<cfif isDefined('x_serial_no_create_type')>#x_serial_no_create_type#<cfelse>0</cfif>">
				<input type="hidden" name="xml_control_del_seril_no" id="xml_control_del_seril_no" value="<cfif isDefined('xml_control_del_seril_no')>#xml_control_del_seril_no#<cfelse>0</cfif>">
				<input type="hidden" name="process_id" id="process_id" value="#attributes.process_id#">
				<input type="hidden" name="process_number" id="process_number" value="#attributes.process_number#">
				<input type="hidden" name="product_amount" id="product_amount" value="#attributes.product_amount#">
				<input type="hidden" name="product_amount_2" id="product_amount_2" value="#attributes.product_amount_2#">
				<input type="hidden" name="recorded_count" id="recorded_count" value="#attributes.recorded_count#">
				<input type="hidden" name="guaranty_startdate" id="guaranty_startdate" value="#attributes.guaranty_startdate#">
				<input type="hidden" name="guaranty_cat" id="guaranty_cat" value="#attributes.guaranty_cat#">
				<input type="hidden" name="sale_product" id="sale_product" value="#attributes.sale_product#">
				<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.par_id")>#attributes.par_id#</cfif>">
				<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.con_id#">
				<input type="hidden" name="company_id" id="company_id" value="#attributes.company_id#">
				<input type="hidden" name="location_id" id="location_id" value="#attributes.loc_id#">
				<input type="hidden" name="xml_serial_out_control" id="xml_serial_out_control" value="#xml_serial_out_control#">
				<input type="hidden" name="process_date" id="process_date" value="#attributes.process_date#">
				<cfif isdefined("attributes.dept_id2")>
					<input type="hidden" name="department_id2" id="department_id2" value="#attributes.dept_id2#">
					<input type="hidden" name="location_id2" id="location_id2" value="#attributes.loc_id2#">
				</cfif>
				<input type="hidden" name="department_id" id="department_id" value="#attributes.dept_id#">
				<input type="hidden" name="is_delivered" id="is_delivered" value="<cfif isDefined("attributes.is_delivered")>#attributes.is_delivered#</cfif>">
				<input type="hidden" name="wrk_row_id" id="wrk_row_id" value="<cfif isdefined("attributes.wrk_row_id")>#attributes.wrk_row_id#</cfif>">
				<input type="hidden" name="x_serino_control_out" id="x_serino_control_out" value="<cfif isDefined('x_serino_control_out')>#x_serino_control_out#<cfelse>0</cfif>">
				<input type="hidden" name="x_is_quantity_control" id="x_is_quantity_control" value="<cfif isDefined('x_is_quantity_control')>#x_is_quantity_control#<cfelse>0</cfif>">
				<cfif isdefined("attributes.is_line")>
					<input type="hidden" name="is_line" id="is_line" value="#attributes.is_line#">
				</cfif>
				</cfoutput>
				<cfif isdefined("attributes.stock")><input type="hidden" name="stock" id="stock" value="1"></cfif>
				<cfif isdefined("attributes.is_store") and attributes.is_store eq 1><input type="hidden" name="is_store" id="is_store" value="1"></cfif>
				<cfquery name="get_product_guaranty" datasource="#dsn3#">
					SELECT SALE_GUARANTY_CAT_ID,TAKE_GUARANTY_CAT_ID FROM PRODUCT_GUARANTY WHERE PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
				</cfquery>
				<cfset url_str = "">
				<cfif isdefined("attributes.take")>
					<input type="hidden" name="take" id="take" value="<cfoutput>#attributes.take#</cfoutput>">
					<cfset url_str = "#url_str#&take=#attributes.take#">
				</cfif>
				<cfif isdefined("attributes.sale")>
					<input type="hidden" name="sale" id="sale" value="<cfoutput>#attributes.sale#</cfoutput>">
					<cfset url_str = "#url_str#&sale=#attributes.sale#">
				</cfif>
				<cfif isdefined("attributes.plus")><input type="hidden" name="plus" id="plus" value="1"></cfif>
				<cfif sale_product eq 1>
					<input type="hidden" name="take_get" id="take_get" value="1">
					<cfset guaranty_take_get = get_product_guaranty.SALE_GUARANTY_CAT_ID>
					<cfif not len(guaranty_take_get) and isdefined("get_serial_info.SALE_GUARANTY_CATID")>
						<cfset guaranty_take_get = get_serial_info.SALE_GUARANTY_CATID>
					</cfif>
				<cfelse>
					<input type="hidden" name="take_get" id="take_get" value="0">
					<cfset guaranty_take_get = get_product_guaranty.TAKE_GUARANTY_CAT_ID>
						<cfif not len(guaranty_take_get) and isdefined("get_serial_info.PURCHASE_GUARANTY_CATID")>
						<cfset guaranty_take_get = get_serial_info.PURCHASE_GUARANTY_CATID>
					</cfif>
				</cfif>
				<cf_box_elements>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57880.Belge No'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<label class="txtbold"><cfoutput>#attributes.process_number#</cfoutput></label>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<label class="txtbold"><cfoutput>#get_process_name(attributes.process_cat)#</cfoutput></label>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29472.Yöntem'></label>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="method" id="method" value="0"  onclick="kontrol(this.value)" checked><cf_get_lang dictionary_id='32749.Ardışık'></div>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="method" id="method" value="1"  onclick="kontrol(this.value)"><cf_get_lang dictionary_id='32767.Tek Tek'></div>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="method" id="method" value="2"><cf_get_lang dictionary_id ='57691.Dosya'></div>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="method" id="method" value="3"><cf_get_lang dictionary_id ='32506.Lot'></div>
					</div> 
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="file_information" style="display:none">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12 bold">
							<label><cf_get_lang dictionary_id='58594.Format'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12 bold">
							<p><cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.</p>
							<p><cf_get_lang dictionary_id='35435.Aktarım işlemi dosyanın 1. satırından itibaren başlar, bu yüzden birinci satırda alan isimleri olmalıdır'>.</p>
							<p><cf_get_lang dictionary_id='44683.There will be 3 fields in the document.'>;</p>
							<p>1) <cf_get_lang dictionary_id='57637.Serial No.'></p> 
							<p>2) <cf_get_lang dictionary_id='60368.Unit quantities'></p>
							<p>3) <cf_get_lang dictionary_id='45498.Lot No.'></p>							
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='33861.Artırma Şekli'></label>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="m_type" id="m_type" value="1"><cf_get_lang dictionary_id ='33862.Baştan'></div>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="m_type" id="m_type" value="2" <cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type eq 1>checked</cfif>><cf_get_lang dictionary_id ='33863.Ortadan'></div>
						<div class="col col-2 col-md-2 col-xs-12"><input type="radio" name="m_type" id="m_type" value="3" <cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type neq 1>checked</cfif>><cf_get_lang dictionary_id ='33864.Sondan'></div>	
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label>1. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='32823.Toplam Miktar'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfoutput>
								<input type="hidden" name="range_number" id="range_number" value="#range_number#">
								<label>#range_number#</label>
							</cfoutput>
						</div>
					</div>	
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label>2. <cf_get_lang dictionary_id='57636.Birim'> <cf_get_lang dictionary_id='32823.Toplam Miktar'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<label><cfoutput>#range_number_2#</cfoutput></label>
						</div>
					</div>
					<input type="hidden" name="product_name" id="product_name" value="">
					<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
					<input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
					<script type="text/javascript">
						add_guaranty_.product_name.value = '<cfoutput>#PRODUCT_NAME.PRODUCT_NAME#</cfoutput>';
					</script>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label>1. <cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='32687.Kayıt Miktarı'></label>
						</div>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33959.Ürün miktarı en fazla'></cfsavecontent>
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='33960.olabilir'></cfsavecontent>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="hidden" name="old_amount" value="#attributes.amount#">
							<cfinput type="text" name="amount" id="amount" value="#attributes.amount#" validate="float" range="0.00000001,#range_number#" message="#message# #range_number# #message1#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label>2. <cf_get_lang dictionary_id='57636.Birim'><cf_get_lang dictionary_id='32687.Kayıt Miktarı'></label>
						</div>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='33959.Ürün miktarı en fazla'></cfsavecontent>
						<cfsavecontent variable="message1"><cf_get_lang dictionary_id ='33960.olabilir'></cfsavecontent>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="hidden" name="old_amount_2" value="#attributes.amount_2#">
							<input type="text" name="amount_2" id="amount_2" value="<cfif attributes.amount_2 neq 0><cfoutput>#attributes.amount_2#</cfoutput></cfif>" validate="float" range="0.00000001,#range_number#" message="#message# #range_number# #message1#">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='56236.Kayıt Tipi'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="select_unit" id="select_unit">
								<option value="1" <cfif (isdefined("attributes.select_unit") and attributes.select_unit eq 1) or (isdefined("get_seri_count") and get_seri_count.unit eq 1)>selected</cfif>>1. <cf_get_lang dictionary_id='60324.Birim Kadar'></option>
								<option value="2" <cfif (isdefined("attributes.select_unit") and attributes.select_unit eq 2) or (isdefined("get_seri_count") and get_seri_count.unit eq 1)>selected</cfif>>2. <cf_get_lang dictionary_id='60324.Birim Kadar'></option>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='32624.Garanti Başlama'></label>
						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfif xml_guaranty_date_from_paper>
									<cfinput type="text" name="start_date" id="start_date" value="#attributes.process_date#" readonly="yes">
								<cfelse>
									<cfinput type="text" name="start_date" id="start_date" value="#dateformat(now(),dateformat_style)#" readonly="yes">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><input type="checkbox" name="is_last_guaranty_control" id="is_last_guaranty_control" value="1"><cf_get_lang dictionary_id='60325.Son İşlem Tarihi'></label>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='32653.Garanti Kategorisi'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="guarantycat_id" id="guarantycat_id">
								<cfoutput query="GET_GUARANTY_CAT">
									<option value="#GUARANTYCAT_ID#" <cfif len(guaranty_take_get) and (guaranty_take_get eq GUARANTYCAT_ID)>selected</cfif>>#GUARANTYCAT#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='57468.Belge'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="file" name="uploaded_file" id="uploaded_file">
						</div>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='32506.Lot'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="lot_no" maxlength="100" id="lot_no" value="<cfoutput>#attributes.lot_no#</cfoutput>">
						</div>
					</div>
					<cfif isDefined('x_is_rma') and x_is_rma eq 1>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='34260.RMA No'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="rma_no" id="rma_no" value="">
							</div>
						</div>
					<cfelse>
						<input type="hidden" name="rma_no" id="rma_no" value="">
					</cfif>	
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="ardisik">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='49247.Ürün Seri Baş No'></label>
						</div>
						<cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type eq 2>
							<input type="hidden" name="ship_seri_baslangic" id="ship_seri_baslangic" value="<cfoutput>#seri_#</cfoutput>">
							<div class="col col-3 col-md-2 col-sm-2 col-xs-4">
								<input type="text" name="ship_start_no" id="ship_start_no" <cfif isDefined('x_is_entry_readonly') and x_is_entry_readonly eq 1>readonly="readonly"</cfif> value="<cfoutput>#my_seri_#</cfoutput>" >
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-4">
								<input type="text" name="ship_start_no_orta" id="ship_start_no_orta" <cfif isDefined('x_is_entry_readonly') and x_is_entry_readonly eq 1>readonly="readonly"</cfif> value="" >
							</div>
							<div class="col col-3 col-md-2 col-sm-2 col-xs-4">
								<input type="text" name="ship_start_no_son" id="ship_start_no_son" <cfif isDefined('x_is_entry_readonly') and x_is_entry_readonly eq 1>readonly="readonly"</cfif> value="<cfoutput>#seri_baslangic_#</cfoutput>">
							</div>
						<cfelse>
							<input type="hidden" name="ship_seri_baslangic" id="ship_seri_baslangic" value="<cfoutput>#seri_#</cfoutput>">
							<div class="col col-3 col-md-2 col-sm-2 col-xs-4">
								<input type="text" name="ship_start_no" id="ship_start_no" <cfif isDefined('x_is_entry_readonly') and x_is_entry_readonly eq 1>readonly="readonly"</cfif> value="<cfoutput>#stock_#</cfoutput>" >
							</div>
							<div class="col col-2 col-md-2 col-sm-2 col-xs-4">
								<input type="text" name="ship_start_no_orta" id="ship_start_no_orta" <cfif isDefined('x_is_entry_readonly') and x_is_entry_readonly eq 1>readonly="readonly"</cfif> value="<cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type eq 1><cfoutput>#seri_baslangic_#</cfoutput></cfif>" >
							</div>
							<div class="col col-3 col-md-2 col-sm-2 col-xs-4">
								<input type="text" name="ship_start_no_son" id="ship_start_no_son" <cfif isDefined('x_is_entry_readonly') and x_is_entry_readonly eq 1>readonly="readonly"</cfif> value="<cfoutput>#my_seri_#</cfoutput>">
							</div>
						</cfif>
					</div>
					<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12" id="tek_tek">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<label><cf_get_lang dictionary_id='32726.Ürün Seri Nolar'></label>
						</div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea name="ship_start_nos" id="ship_start_nos" style="width:179px;height:147px;"></textarea>
							<font color="red"><cf_get_lang dictionary_id ='33865.Enter Tuşu İle Ayırınız'>...</font>
						</div>
					</div>
					<cfif isDefined('x_is_reference') and x_is_reference eq 1>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='58794.Referans No'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="reference_nos" id="reference_nos" style="width:179px;height:147px;"></textarea>
								<font color="red"><cf_get_lang dictionary_id ='33865.Enter Tuşu İle Ayırınız'>...</font>
							</div>
							
						</div>
					</cfif>
					<cfif attributes.process_cat eq 86 or attributes.process_cat eq 141>
						<cfif attributes.process_cat eq 86>
							<cfset islem_type = 85> <!--- ureticiden cikis --->
						<cfelseif attributes.process_cat eq 141>
							<cfset islem_type = 140> <!--- servis giris --->
						</cfif>
						<input type="hidden" name="out_stock_id" id="out_stock_id" value="">
						<input type="hidden" name="out_ship_id" id="out_ship_id" value="">
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='57452.Stok'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" value="" name="out_stock_name" id="out_stock_name" readonly> <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_serials_in&out_stock_name=add_guaranty_.out_stock_name&out_belge_no=add_guaranty_.out_belge_no&out_miktar=add_guaranty_.out_miktar&out_stock_id=add_guaranty_.out_stock_id&out_serials=add_guaranty_.out_serials&out_ship_id=add_guaranty_.out_ship_id&islem_type=#islem_type#&in_stock_id=#attributes.stock_id#</cfoutput>','list');"><img src="/images/plus_thin.gif"></a>
							</div>
						</div>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='57468.Belge'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" value="" name="out_belge_no" id="out_belge_no" readonly>
							</div>
						</div>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='57635.Miktar'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" value="" name="out_miktar" id="out_miktar" readonly>
							</div>
						</div>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='57637.Seri'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="out_serials" id="out_serials" style="width:178px;height:50px;" readonly></textarea>
							</div>
						</div>
					</cfif>
					<cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type eq 1>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><cf_get_lang dictionary_id='58876.Dönem Seç'></label>
							</div>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfoutput>
									<select name="serial_year" id="serial_year" onchange="degistir(1);">
										<cfloop from="2008" to="#session.ep.period_year+1#" index="yr">
											<option value="#Right(yr,2)#" <cfif session.ep.period_year eq yr>selected</cfif>>#yr#</option>
										</cfloop>
									</select>
									<cfsavecontent variable="ay1"><cf_get_lang dictionary_id='57592.Ocak'></cfsavecontent>
									<cfsavecontent variable="ay2"><cf_get_lang dictionary_id='57593.Şubat'></cfsavecontent>
									<cfsavecontent variable="ay3"><cf_get_lang dictionary_id='57594.Mart'></cfsavecontent>
									<cfsavecontent variable="ay4"><cf_get_lang dictionary_id='57595.Nisan'></cfsavecontent>
									<cfsavecontent variable="ay5"><cf_get_lang dictionary_id='57596.Mayıs'></cfsavecontent>
									<cfsavecontent variable="ay6"><cf_get_lang dictionary_id='57597.Haziran'></cfsavecontent>
									<cfsavecontent variable="ay7"><cf_get_lang dictionary_id='57598.Temmuz'></cfsavecontent>
									<cfsavecontent variable="ay8"><cf_get_lang dictionary_id='57599.Ağustos'></cfsavecontent>
									<cfsavecontent variable="ay9"><cf_get_lang dictionary_id='57600.Eylül'></cfsavecontent>
									<cfsavecontent variable="ay10"><cf_get_lang dictionary_id='57601.Ekim'></cfsavecontent>
									<cfsavecontent variable="ay11"><cf_get_lang dictionary_id='57602.Kasım'></cfsavecontent>
									<cfsavecontent variable="ay12"><cf_get_lang dictionary_id='57603.Aralık'></cfsavecontent>
									<select name="serial_mon" id="serial_mon" onchange="degistir(2);">
										<cfloop from="1" to="12" index="mn">
											<option value="#mn#" <cfif b_2_1 is NumberFormat(mn,'00')>selected</cfif>>#Evaluate('ay#mn#')#</option>
										</cfloop>
									</select>
								</cfoutput>
							</div>
							<div id="serial_creater"></div>
						</div>
						<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
							<input type="checkbox" name="is_dynamic_lot_no" id="is_dynamic_lot_no" value="1" checked> <cf_get_lang dictionary_id='34261.Otomatik Lot No Ata'>
						</div>
					</cfif>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='chk_form()'>
				</cf_box_footer>
				
			</cfform>
		<cfelseif (range_number eq 0) or (range_number eq 1) or (range_number_2 eq 0) or (range_number_2 eq 1)>
			<p><cf_get_lang dictionary_id='32563.Girilen seri nolar ile miktar eşitlendi'></p>
		<cfelseif range_number lt 0>
			<p><cf_get_lang dictionary_id='32564.Girilen seri nolar miktardan fazla'></p>
		</cfif>
		<cfquery name="get_alt_products" datasource="#dsn3#">
			SELECT PRODUCT_NAME, PROPERTY, STOCK_ID, PRODUCT_ID, IS_PRODUCTION FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND IS_SERIAL_NO = 1
		</cfquery>
		<cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
			<cfquery name="get_product" datasource="#dsn3#">
				SELECT 
					SPECT_ROW_ID,
					SPECT_ID,
					PRODUCT_ID,
					STOCK_ID,
					AMOUNT_VALUE AS AMOUNT,
					IS_SEVK,
					PRODUCT_NAME,
					'' AS PROPERTY
				FROM
					SPECTS_ROW
				WHERE
					SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_id#"> AND
					IS_SEVK = 1
			</cfquery>
			<cfset is_result_ = 1>
		<cfelseif get_alt_products.recordcount and get_alt_products.IS_PRODUCTION>
			<cfquery name="get_product" datasource="#dsn3#">
				SELECT 
					PRODUCT_TREE.PRODUCT_TREE_ID,
					PRODUCT_TREE.RELATED_ID,
					S.PRODUCT_ID,
					S.STOCK_ID,
					PRODUCT_TREE.AMOUNT,
					PRODUCT_TREE.IS_SEVK,
					S.PRODUCT_NAME,
					S.PROPERTY
				FROM
					PRODUCT_TREE,
					STOCKS S
				WHERE
					S.STOCK_ID = PRODUCT_TREE.RELATED_ID AND
					PRODUCT_TREE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#"> AND
					PRODUCT_TREE.IS_SEVK = 1
			</cfquery>
			<cfset is_result_ = 1>
		</cfif>
		<cfif isdefined("is_result_") and get_product.recordcount><!--- get_alt_products.recordcount and (is_yazdir eq 1) --->
			<cf_box_elements>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<label class="formbold"><cf_get_lang dictionary_id ='33866.Üretim Ürünleri'></label>
				</div>
				<div class="form-group col col-12 col-md-12 col-sm-12 col-xs-12">
					<cfoutput query="get_product">	
							<li>
							<cfquery name="GET_SERIAL_INFO_SATIR" datasource="#DSN3#">
								SELECT
									LOT_NO
								FROM
									SERVICE_GUARANTY_NEW
								WHERE
									PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
									PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#"> AND
									<cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
										SPECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spect_id#"> AND
									</cfif>
									STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product.stock_id#"> AND
									<cfif attributes.process_cat neq 171>
										PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#"> AND
									</cfif>
									MAIN_STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
							</cfquery>
							<cfset prod_amount=get_product.amount>
							<cfif len(attributes.product_amount)><cfset prod_amount=attributes.product_amount*get_product.amount></cfif>
							<a class="tableyazi" href="#request.self#?fuseaction=stock.list_serial_operations&event=det&main_stock_id=#attributes.STOCK_ID#&product_amount=#prod_amount#&recorded_count=#GET_SERIAL_INFO_SATIR.RecordCount#&product_id=#get_product.PRODUCT_ID#&stock_id=#get_product.STOCK_ID#&process_number=#attributes.PROCESS_NUMBER#&process_cat=#attributes.process_cat#&process_id=#PROCESS_ID#&sale_product=#attributes.sale_product#&company_id=#attributes.COMPANY_ID#&con_id=&loc_id=#attributes.loc_id#&dept_id=#attributes.dept_id#&is_serial_no=1&guaranty_cat=&guaranty_startdate<cfif isdefined("attributes.spect_id")>&spect_id=#attributes.spect_id#</cfif>">
							#PRODUCT_NAME# #PROPERTY#
							</a>
							</li>
					</cfoutput>
				</div>
			</cf_box_elements>
		</cfif>
		<!--- //ekleme ekrani --->
	</cf_box>
</div>
<div class="col col-6 col-md-6 col-sm-12 col-xs-12">
    <cf_box title="#PRODUCT_NAME.PRODUCT_NAME#">
		<!--- güncelleme ekranı --->
		<div id="info_alani"></div>
		<div id="cont" >
			<cfform name="add_guaranty" id="add_guaranty" method="post" action="#request.self#?fuseaction=objects.upd_stock_serialno">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
						<cfoutput>
						<input type="hidden" name="all_delete" id="all_delete" value="0">
						<cfif isdefined("attributes.is_line")>
							<input type="hidden" name="is_line" id="is_line" value="#attributes.is_line#">
						</cfif>
						<input type="hidden" name="xml_control_del_seril_no" id="xml_control_del_seril_no" value="<cfif isDefined('xml_control_del_seril_no')>#xml_control_del_seril_no#<cfelse>0</cfif>">
						<input type="hidden" name="amount" id="amount" value="#attributes.product_amount#">
						<input type="hidden" name="stock_id" id="stock_id" value="#attributes.stock_id#">
						<input type="hidden" name="sale_product" id="sale_product" value="#attributes.sale_product#">
						<input type="hidden" name="process_cat" id="process_cat" value="#attributes.process_cat#">
						<input type="hidden" name="process_id" id="process_id" value="#attributes.process_id#">
						<input type="hidden" name="process_number" id="process_number" value="#attributes.process_number#">
						</cfoutput>
						<div class="form-group">
							<cfif local_seri_kontrol><font color="red"><cf_get_lang dictionary_id ='33867.Bu Ürün İçin Local Seri Kontrolü Yapılmaktadır'>.</font></cfif>
						</div>
						<cfoutput>
							<div class="form-group">
								<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id ='57518.Stok Kodu'> :</label>
								<div class="col col-4 col-xs-12">
								#PRODUCT_NAME.stock_code#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id ='57633.Barkod'> :</label>
								<div class="col col-4 col-xs-12">
									#PRODUCT_NAME.BARCOD#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> :</label>
								<div class="col col-4 col-xs-12">
									#PRODUCT_NAME.PRODUCT_CODE_2#
								</div>
							</div>
						</cfoutput>
							<cfif GET_SERIAL_INFO.recordcount>
								<div class="col col-4">
									<cfoutput>
										<cfif isdefined("get_seri_count") and len(get_seri_count.unit) and get_seri_count.unit eq 0>
											<cf_get_lang dictionary_id = "60365. 1. Birime göre oluşturuldu."></br>
										<cfelseif isdefined("get_seri_count") and len(get_seri_count.unit) and get_seri_count.unit eq 1>
											<cf_get_lang dictionary_id = "60366. 2. Birime göre oluşturuldu."></br>
										</cfif>
										<input type="hidden" id="range_number_" value="#range_number#">
										1. <cf_get_lang dictionary_id ='57636.Birim'> : #tlFormat(range_number)#</br>
										<cfif isdefined("get_seri_count") and len(get_seri_count.unit) and get_seri_count.unit eq 1>2. <cf_get_lang dictionary_id ='57636.Birim'> : #tlFormat(attributes.product_amount_2)#</br></cfif>
									</cfoutput>
								</div>
								<cfif isdefined("get_seri_count") and len(get_seri_count.unit) and get_seri_count.unit eq 1>
									<div class="col col-4">
										<cfoutput>
											<label><cf_get_lang dictionary_id ='57468.belge'> : </label>
											<input type="hidden" name="paper_amount_input" id="paper_amount_input" value="#range_number#">	
											<input type="hidden" name="diff_amount_input" id="diff_amount_input" value="0">	
											<label id="paper_amount">
												#tlFormat(range_number)#
											</label> </br>
											<label><cf_get_lang dictionary_id ='58583.Fark'> :</label> <label id="diff_amount"> #tlFormat(0)# </label>
										</cfoutput>
									</div>
								</cfif>
							</cfif>
						</div>
						<div class="form-group">
							<div id="EMPTY_PLACE"></div>
						</div>
					<script type="text/javascript">
						<cfif GET_SERIAL_INFO.recordcount>var okk = <cfoutput>#GET_SERIAL_INFO.GUARANTY_ID[1]#</cfoutput>;
							var bb = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_get_serial_info2</cfoutput>";
							bb += "<cfoutput>&process_id=#attributes.process_id#</cfoutput>";
							bb += "<cfoutput>&xml_control_del_seril_no=#xml_control_del_seril_no#</cfoutput>";
							bb += "<cfoutput>&process_cat=#attributes.process_cat#</cfoutput>";
							bb += "<cfoutput>&process_number=#attributes.process_number#</cfoutput>";
							bb += "<cfoutput>&wrk_row_id=#attributes.wrk_row_id#</cfoutput>";
							<cfif isDefined('x_is_reference')>
								bb += "&reference_control=<cfoutput>#x_is_reference#</cfoutput>";
							</cfif>
							<cfif isDefined('amount_invoice') and len(amount_invoice)>
								bb += "&amount_invoice=<cfoutput>#amount_invoice#</cfoutput>";
							</cfif>
							<cfif isDefined('x_is_rma')>
								bb += "&rma_control=<cfoutput>#x_is_rma#</cfoutput>";
							</cfif>
							<cfif isdefined("attributes.main_stock_id")>
								bb += "<cfoutput>&main_stock_id=#attributes.main_stock_id#</cfoutput>";
							</cfif>
							<cfif isdefined("attributes.spect_id")>
								bb += "<cfoutput>&spect_id=#attributes.spect_id#</cfoutput>";
							</cfif>
							bb += "<cfoutput>&STOCK_ID=#attributes.STOCK_ID#</cfoutput>";
							bb += "<cfoutput>&recordcount=#GET_SERIAL_INFO.recordcount#</cfoutput>";
							tmp1=bb;
							<cfif not listfind("81,811,113",attributes.process_cat)>
								for (i=0; i<(<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>/100); ++i)
							<cfelse>
								for (i=0; i<(<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>/500); ++i)
							</cfif>
							{   
								document.write('<tr><td><div id="PLACE_'+i+'"></div></td></tr>');
								//document.getElementById('PLACE_'+i).innerHTML = '..Yükleniyor..';
							}
							i=-1;
							ttt();
						</cfif>
					</script>
					<input type="hidden" name="serial_rows_" id="serial_rows_" value="<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>">
					<cfif GET_SERIAL_INFO.recordcount>
						<cf_box_footer>
							<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-success" onclick="serileri_temizle();"><cf_get_lang dictionary_id ='33961.Tüm Serileri Temizle'></a>
							<cfif len(GET_SERIAL_INFO.unit)>
								<input type="hidden" id="unit_row_quantity" name="unit_row_quantity" value="1">
								<cf_workcube_buttons is_delete = "0" add_function="control_unit()">
							</cfif>
						</cf_box_footer>
						
					</cfif>
				</div>
			</cfform>
		</div>
		<!--- //güncelleme ekranı --->
	</cf_box>
</div>
<script type="text/javascript">
	function serileri_temizle()
	{	
		if(confirm("<cf_get_lang dictionary_id ='33962.Belgeye bağlı girilmiş olan tüm seriler silinecek Emin misiniz'>?"))
			<cfif isDefined('session.ep.userid')>
				document.location.href='<cfoutput>#request.self#?fuseaction=objects.upd_stock_serialno&xml_control_del_seril_no=#xml_control_del_seril_no#&all_delete=1&stock_id=#attributes.stock_id#&process_id=#attributes.process_id#&process_cat=#attributes.process_cat#</cfoutput>&process_number=<cfoutput>#attributes.process_number#</cfoutput><cfif isdefined("attributes.wrk_row_id")>&wrk_row_id=<cfoutput>#attributes.wrk_row_id#</cfoutput></cfif>';
			<cfelse>
				document.location.href='<cfoutput>#request.self#?fuseaction=objects2.upd_stock_serialno&all_delete=1&stock_id=#attributes.stock_id#&process_id=#attributes.process_id#&process_cat=#attributes.process_cat#</cfoutput>';
			</cfif>
			
		else
			return false;
	}
	<cfif range_number gt 0>
	function chk_form()
	{
		if(document.add_guaranty_.method[0].checked)
		{
			var serial_no_ = '';
			if(document.add_guaranty_.m_type[0].checked && document.add_guaranty_.ship_start_no.value=="")
			{
				alert("<cf_get_lang dictionary_id ='33855.Seri No Başlangıç Girmelisiniz'>!");
				return false;
			}
			else if(document.add_guaranty_.m_type[1].checked && document.add_guaranty_.ship_start_no_orta.value=="")
			{
				alert("<cf_get_lang dictionary_id ='33855.Seri No Başlangıç Girmelisiniz'>!");
				return false;
			}
			else if(document.add_guaranty_.m_type[2].checked && document.add_guaranty_.ship_start_no_son.value=="")
			{
				alert("<cf_get_lang dictionary_id ='33855.Seri No Başlangıç Girmelisiniz'>!");
				return false;
			}
			if(document.add_guaranty_.ship_start_no.value != "")
			{
				serial_no_ += document.add_guaranty_.ship_start_no.value;
			}
			if(document.add_guaranty_.ship_start_no_orta.value != "")
			{
				serial_no_ += document.add_guaranty_.ship_start_no_orta.value;
			}
			if(document.add_guaranty_.ship_start_no_son.value != "")
			{
				serial_no_ += document.add_guaranty_.ship_start_no_son.value;
			}
			if(serial_no_.length > 50)
			{
				alert('s');
				alert("<cf_get_lang dictionary_id='60326.Seri No Karakter Sayısı Max'>: 50 !");
				return false;
			}
		}
		if(document.add_guaranty_.method[1].checked)
		{
			if(document.add_guaranty_.ship_start_nos.value=="") 
			{
				alert("<cf_get_lang dictionary_id ='33774.Seri No Girmelisiniz'>!");
				return false;
			}
			/*
			if(document.getElementById('ship_start_nos').value!='')
			{
				var inputStr=document.getElementById('ship_start_nos').value;
				alert(inputStr);
				if(inputStr.length>0)
				{
					for(var i=0;i < inputStr.length;i++)
					{
						var oneChar= inputStr.substring(i,i+1).charCodeAt();
						var deger = inputStr.substring(i,i+1);
						if(oneChar==13&&i>50||oneChar!=13&&i>50)
						{
							alert("deger: "+deger+"i: "+i+"oneChar: " +oneChar);
							//alert(i);
							//alert(oneChar);
							alert("Seri No Karakter Sayısı En Fazla 50 Olmalıdır!");
							i=0;
							return false;
						}
					}
				}
			}
			*/
		}
			
		if(document.add_guaranty_.method[2].checked)
		{
			if(document.add_guaranty_.uploaded_file.value=="")
			{
				alert("<cf_get_lang dictionary_id='58682.Çalıştırılmak istenen Dosya Bulunamadı.'>'!");
				return false;
			}
		}
		
		if(document.add_guaranty_.method[3].checked)
		{
			if(document.add_guaranty_.lot_no.value=="")
			{
				alert("<cf_get_lang dictionary_id ='33868.Lot No Girmelisiniz'>!");
				return false;
			}
		}
			
		if(document.add_guaranty_.guarantycat_id.value=="")
		{
			alert("<cf_get_lang dictionary_id ='33869.Garanti Tipi Seçmelisiniz'>!");
			return false;
		}
		
		if(parseInt(document.getElementById('amount').value) > parseInt(document.getElementById('old_amount').value))
		{
			alert("<cf_get_lang dictionary_id ='32862.Girilen miktar, kalan miktardan büyük olamaz!'>");
			return false;
		}
		if(parseInt(document.getElementById('amount_2').value) > parseInt(document.getElementById('old_amount_2').value))
		{
			alert("<cf_get_lang dictionary_id ='32862.Girilen miktar, kalan miktardan büyük olamaz!'>");
			return false;
		}
	
		<cfif attributes.process_cat eq 86> //or attributes.process_cat eq 141
			if(document.add_guaranty_.out_ship_id.value=="")
			{
				alert("<cf_get_lang dictionary_id ='33870.Dönüş İrsaliyesi Seçmelisiniz'>!");
				return false;
			}
		</cfif>
		
		return true;
	}
	</cfif>
	function chk_form2()
	{
		var satir = "<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>";
		if(satir > 1)
		{
			for (i=0; i < satir; i++)			
			{
				try
				{
					if(!document.add_guaranty.start_no[i].value.length)
					{
						alert("<cf_get_lang dictionary_id ='33871.Eksik Seri No Girdiniz'>");
						return false;
					}
				}
				catch(e) {}
			}
		}
		else if(satir == 1)
		{
			if(!document.add_guaranty.start_no.value.length)
			{
				alert("<cf_get_lang dictionary_id ='33871.Eksik Seri No Girdiniz'>!");
				return false;
			}
		}
		return true;
	}
	<cfif range_number gt 0>
		function kontrol(gelen)
		{
			if(gelen == 0)
			{
				$("div#ardisik").show();
				$("div#tek_tek").hide();
			}
			else
			{
				$("div#ardisik").hide();
				$("div#tek_tek").show();
			}
		}
		kontrol(0);
		<cfif isdefined("attributes.guaranty_method") and (attributes.guaranty_method eq 0)>
			kontrol(0);
		<cfelseif isdefined("attributes.guaranty_method") and (attributes.guaranty_method eq 1)>
			kontrol(1);
		</cfif>
	</cfif>
		
	function record_sil(guaranty_id,index,catid,xml_control_del_seril_no)
	{
		var state = confirm("<cf_get_lang dictionary_id ='33872.Seri No silmek İstediğinize Emin misiniz'>?");
		if (state)
		{ 
			siladres = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_del_serial_info</cfoutput>";
			<cfif isdefined("attributes.is_line")>
				siladres +="&is_line=1";
			</cfif>
			siladres +="&catid="+catid;
			siladres +="&guaranty_id="+guaranty_id;
			siladres +="&xml_control_del_seril_no="+xml_control_del_seril_no;
			AjaxPageLoad(siladres,'EMPTY_PLACE');
			gizle(eval("satirim_"+index));

		}
	}
	
	function kayit_duzenle(guaranty_id,index)
	{
		info_alani.innerHTML = '<font color="red">Güncelleniyor!</font>';
		guncelleme_adres = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_upd_stock_serialno</cfoutput>";
		<cfif isdefined("attributes.is_line")>
			guncelleme_adres +="&is_line=1";
		</cfif>
		guncelleme_adres +="&guaranty_id="+guaranty_id;
		guncelleme_adres +="&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>";
		guncelleme_adres +="&satir_="+index;
		guncelleme_adres +="&sale_product=<cfoutput>#attributes.sale_product#</cfoutput>";
		guncelleme_adres +="&is_only_one=1";
		guncelleme_adres +="&seri_no="+eval("document.add_guaranty.start_no_" + index).value;
		guncelleme_adres +="&lot_no="+eval("document.add_guaranty.lot_no_" + index).value;
		<cfif isDefined('x_is_reference') and x_is_reference eq 1>
			guncelleme_adres +="&reference_no="+eval("document.add_guaranty.reference_no_" + index).value;
		</cfif>
		<cfif isDefined('x_is_rma') and x_is_rma eq 1>
			guncelleme_adres +="&rma_no="+eval("document.add_guaranty.rma_no_" + index).value;
		</cfif>
		
		guncelleme_adres +="&old_seri_no="+eval("document.add_guaranty.old_start_no_" + index).value;
		guncelleme_adres +="&old_lot_no="+eval("document.add_guaranty.old_lot_no_" + index).value;
		AjaxPageLoad(guncelleme_adres,'EMPTY_PLACE',1);
	}
	function quantity_calc(id,index)
	{
		var satir = "<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>";
		total = 0;
		for(i = 1;i <= satir;i++)
		{
			if($('#unit_row_quantity_'+i).val())
				total = total + parseFloat(filterNum($('#unit_row_quantity_'+i).val()));
		}
		if(index != undefined)
			$('#unit_row_quantity_'+index).val(commaSplit(parseFloat(filterNum($('#unit_row_quantity_'+index).val()))));
		$('#paper_amount').text(commaSplit(total));
		$('#paper_amount_input').text(total);
		$('#diff_amount').text(commaSplit(Math.abs(parseFloat(total-$('#range_number_').val()))));
		$('#diff_amount_input').val(filterNum(commaSplit(Math.abs(parseFloat(total-$('#range_number_').val())))));
		
	}
	function control_unit()
	{
		if($('#diff_amount_input').val() != 0 ){
			alert("Düzenlenen Belge İle Miktar arasındaki fark 0 olmalı!");
			return false;
		}else
		{
			var satir = "<cfoutput>#GET_SERIAL_INFO.recordcount#</cfoutput>";
			total = 0;
			for(i = 1;i <= satir;i++)
			{
				$('#unit_row_quantity_'+i).val(filterNum($('#unit_row_quantity_'+i).val()));
			}
			return true;
		}
			
	}
	$('input[type=radio][name=method]').change(function() {
		if (this.value == 2) 
			document.getElementById("file_information").style.display = "block";		
		else
			document.getElementById("file_information").style.display = "none";	
	});
</script>

<cfif isDefined('x_serial_no_create_type') and x_serial_no_create_type eq 1>
	<script type="text/javascript">
		function degistir(type)
		{
			if(type==1)
			{
				new_deger_ = document.add_guaranty_.serial_year.value;
				document.add_guaranty_.ship_start_no.value = '<cfoutput>#b_1_1#</cfoutput>' + new_deger_;
			}
			else
			{
				new_deger_ = document.add_guaranty_.serial_mon.value;
				document.add_guaranty_.ship_start_no_son.value = new_deger_ + '<cfoutput>#b_2_2#</cfoutput>';
			}
			guncelleme_adres = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_upd_stock_serialno_creater</cfoutput>";
			guncelleme_adres +="&stock_="+document.add_guaranty_.ship_start_no.value;
			guncelleme_adres +="&my_seri_="+document.add_guaranty_.ship_start_no_son.value;
			guncelleme_adres +="&stock_id=<cfoutput>#attributes.stock_id#</cfoutput>";
			AjaxPageLoad(guncelleme_adres,'serial_creater',1);
		}
	</script>
</cfif>
