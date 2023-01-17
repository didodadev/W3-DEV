<cf_xml_page_edit fuseact="quality.control_standarts">
<!--- Güncelleme sayfası için query çekiyor --->
<cfif isdefined("attributes.type_id")>
	<cfquery name="get_control_type" datasource="#dsn3#">
		SELECT 
        	TYPE_ID, 
            IS_ACTIVE, 
			#dsn#.Get_Dynamic_Language(TYPE_ID,'#session.ep.language#','QUALITY_CONTROL_TYPE','QUALITY_CONTROL_TYPE',NULL,NULL,QUALITY_CONTROL_TYPE) AS QUALITY_CONTROL_TYPE,
            TYPE_DESCRIPTION, 
            STANDART_VALUE, 
            TOLERANCE, 
            QUALITY_MEASURE, 
            TOLERANCE_2, 
            PROCESS_CAT_ID, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP ,
			CONTENT_ID,
			STOCK_MATERIAL ,
			PROCESS,
			MACHINE_EQUIPMENT,
			SPECIFIC_WEIGHT,
			CODE
        FROM 
    	    QUALITY_CONTROL_TYPE 
        WHERE 
	        TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
	</cfquery>
	<cfscript>
		type_id = get_control_type.type_id;
		control_type = get_control_type.quality_control_type;
		detail= get_control_type.type_description;
		default_value=get_control_type.standart_value;
		meausure_value=get_control_type.quality_measure;
		tolerans_value=get_control_type.tolerance;	
		status=	get_control_type.is_active;
		process_cat_id = get_control_type.process_cat_id;
		content_id = get_control_type.content_id;
		STOCK_MATERIAL = get_control_type.STOCK_MATERIAL;
		PROCESS = get_control_type.PROCESS;
		MACHINE_EQUIPMENT= get_control_type.MACHINE_EQUIPMENT;
		SPECIFIC_WEIGHT=get_control_type.SPECIFIC_WEIGHT;
		CODE=get_control_type.CODE;
	</cfscript>
<cfelse>
	<cfscript>
		type_id = '';
		control_type = '';
		detail= '';
		default_value='';
		meausure_value='';
		tolerans_value='';
		status=1;
		process_cat_id='';
		content_id='';
		STOCK_MATERIAL ='';
		PROCESS ='';
		MACHINE_EQUIPMENT='';
		SPECIFIC_WEIGHT='';
		CODE='';
	</cfscript>
</cfif>
<!--- <cf_catalystHeader> --->
<cfsavecontent variable="title"><cfif isdefined("attributes.type_id")><cfoutput>#control_type#</cfoutput><cfelse><cf_get_lang dictionary_id='63286.Kalite Kontrol Tanımları'><cf_get_lang dictionary_id='44630.Ekle'></cfif></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box  title="#title#" popup_box="1">
		<div id = "unique_sayfa_1" class = "uniqueBox">
			<cfform name="add_qualty_type" action="#request.self#?fuseaction=settings.emptypopup_add_quality_control_types" method="post">
				<input type="hidden" name="type_id" id="type_id" value="<cfoutput>#type_id#</cfoutput>">
				<cf_box_elements >
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-status">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="status" id="status"  value="1" <cfif len(status) and status gt 0>checked</cfif>></div>
						</div>
						<div class="form-group" id="item-control_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59088.Tip'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfif isdefined("attributes.type_id")><div class="input-group"></cfif>
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'><cf_get_lang dictionary_id='59088.Tip'></cfsavecontent>
									<cfinput type="text" name="control_type" value="#control_type#" style="width:250px;" required="yes" message="#message#" maxlength="50">
									<cfif isdefined("attributes.type_id")>
										<span class="input-group-addon">
											<cf_language_info 
												table_name="QUALITY_CONTROL_TYPE" 
												column_name="QUALITY_CONTROL_TYPE" 
												column_id_value="#attributes.type_id#" 
												maxlength="50" 
												datasource="#dsn3#" 
												column_id="TYPE_ID" 
												control_type="0">
										</span>
								</div></cfif>
							</div>
						</div>
						<cfif not  len(type_id)>
							<div class="form-group" id="content_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63353.Test Metodu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("xml_content_id") and len(xml_content_id)>
											<cfparam  name="attributes.content_id" default="#xml_content_id#">
											<cfinclude template="../../content/query/get_content_name.cfm">
											<cfinput type="hidden" name="content_id" id="content_id" value="#attributes.content_id#" readonly="">
											<input type="text" name="content_name" tabindex="62" id="content_name" value="<cfoutput>#get_content_name.Cont_head#</cfoutput>">
										<cfelse>
											<cfinput type="hidden" name="content_id" id="content_id" value="" readonly="">
											<input type="text" name="content_name" tabindex="62" id="content_name" value="">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_content_relation</cfoutput>&content=add_qualty_type.content_id&content_name=add_qualty_type.content_name');return false"></span>
									</div>
								</div>
							</div> 
						<cfelse>
							<div class="form-group" id="content_id">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63353.Test Metodu'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined("content_id") and len(content_id)>
											<cfparam  name="attributes.content_id" default="#content_id#">
											<cfinclude template="../../content/query/get_content_name.cfm">
											<input type="hidden" name="content_id" id="content_id"  value="<cfoutput>#attributes.content_id#</cfoutput>" >
											<input type="text" name="content_name" tabindex="62" id="content_name" value="<cfoutput>#get_content_name.Cont_head#</cfoutput>" >
										<cfelseif isdefined("xml_content_id") and len(xml_content_id)>
											<cfparam  name="attributes.content_id" default="#xml_content_id#">
											<cfinclude template="../../content/query/get_content_name.cfm">
											<cfinput type="hidden" name="content_id" id="content_id" value="#attributes.content_id#" readonly="">
											<input type="text" name="content_name" tabindex="62" id="content_name" value="<cfoutput>#get_content_name.Cont_head#</cfoutput>">
										<cfelse>
											<cfinput type="hidden" name="content_id" id="content_id" value="" readonly="">
											<input type="text" name="content_name" tabindex="62" id="content_name" value="">
										</cfif>
										<span class="input-group-addon btnPointer icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_content_relation</cfoutput>&content=add_qualty_type.content_id&content_name=add_qualty_type.content_name');return false"></span>
									</div>
								</div>
							</div> 
						</cfif> 
						<div class="form-group" id="item-code">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="code" value="#CODE#">
							</div>
						</div>
						 <cfif xml_show_specific_weight eq 1> 
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='64080.Özgül Ağırlık'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="specific_weight" value="#TLFormat(SPECIFIC_WEIGHT)#">
							</div>
						</div>
						 </cfif> 
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="detail" value="#detail#" style="width:250px;" maxlength="50">
							</div>
						</div>
						<div class="form-group" id="item-control_place">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='63886.Kontrol Yeri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
									<cf_get_lang dictionary_id='57452.Stok'>-<cf_get_lang dictionary_id='444.Malzeme'>  <input type="checkbox" name="STOCK_MATERIAL" id="STOCK_MATERIAL"  value="#STOCK_MATERIAL#" <cfif len(STOCK_MATERIAL) and STOCK_MATERIAL eq 1>checked</cfif>>
								</div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<cf_get_lang dictionary_id='57692.İşlem'> <input type="checkbox" name="PROCESS" id="PROCESS"  value="#PROCESS#" <cfif len(PROCESS) and PROCESS eq 1>checked</cfif>>
								</div>
								<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
									<cf_get_lang dictionary_id='63769.Makine'>-<cf_get_lang dictionary_id='62973.Ekipman'> <input type="checkbox" name="MACHINE_EQUIPMENT" id="MACHINE_EQUIPMENT"  value="#MACHINE_EQUIPMENT#" <cfif len(MACHINE_EQUIPMENT) and MACHINE_EQUIPMENT eq 1>checked</cfif>>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-process_cat_id">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="process_cat_id" id="process_cat_id" multiple>
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<option value="76" <cfif isDefined('process_cat_id') and process_cat_id contains 76>selected</cfif>><cf_get_lang dictionary_id='29581.Mal Alım İrsaliyesi'></option>
									<option value="171" <cfif isDefined('process_cat_id') and process_cat_id contains 171>selected</cfif>><cf_get_lang dictionary_id='29651.Üretim Sonucu'></option>
									<option value="811" <cfif isDefined('process_cat_id') and process_cat_id contains 811>selected</cfif>><cf_get_lang dictionary_id='29588.İthal Mal Girişi'></option>
									<option value="-1" <cfif isDefined('process_cat_id') and process_cat_id contains -1>selected</cfif>><cf_get_lang dictionary_id='36376.Operasyonlar'></option>
									<option value="-2" <cfif isDefined('process_cat_id') and process_cat_id contains -2>selected</cfif>><cf_get_lang dictionary_id='57656.Servis'></option>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<div class="col col-12">
						<cfif isdefined("attributes.type_id")>
							<div class="col col-9"><cf_record_info query_name="get_control_type"></div>
							<cfquery name="get_all_rows" datasource="#dsn3#">
								SELECT 
								QUALITY_CONTROL_ROW_ID, 
								QUALITY_CONTROL_ROW, 
								QUALITY_CONTROL_TYPE_ID, 
								QUALITY_ROW_DESCRIPTION, 
								QUALITY_VALUE, 
								TOLERANCE, 
								TOLERANCE_2, 
								RESULT_TYPE, 
								RECORD_DATE,
								RECORD_IP, 
								RECORD_EMP, 
								UPDATE_DATE, 
								UPDATE_IP, 
								UPDATE_EMP 
								FROM 
								QUALITY_CONTROL_ROW 
								WHERE 
								QUALITY_CONTROL_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.type_id#">
							</cfquery>
							<div class="col col-3">
							<cfif get_all_rows.recordcount eq 0>
								<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_q_control_type&id=#attributes.type_id#'>
							<cfelse>
								<cf_workcube_buttons is_upd='1' is_delete='0'>
							</cfif>
						</div>
							<cfelse>
							<cf_workcube_buttons is_upd='0'>
						</cfif>
					</div>
				</cf_box_footer>
				<cfif len(type_id)>
					<cf_seperator title="#getLang('','',57567)#" id="urunkategori" is_closed="1">
					<div id="urunkategori" style="display:none;">
						<cfinclude  template="/V16/settings/display/list_relation_product_cat.cfm">
					</div>
					<cf_seperator title="#getLang('','Ürünler',57564)#" id="urunler" is_closed="1">
					<div id="urunler" style="display:none;">
						<cfinclude  template="/V16/settings/display/list_relation_product.cfm">
					</div>
				</cfif>
			</cfform>
		</div>
	</cf_box>
</div>