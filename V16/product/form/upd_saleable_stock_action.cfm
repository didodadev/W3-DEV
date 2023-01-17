<cfquery name="GET_SALEABLE_STOCK_ACTION" datasource="#DSN3#">
	SELECT
		#dsn#.Get_Dynamic_Language(STOCK_ACTION_ID,'#session.ep.language#','SETUP_SALEABLE_STOCK_ACTION','STOCK_ACTION_NAME',NULL,NULL,STOCK_ACTION_NAME) AS STOCK_ACTION_NAME,
		*
	FROM
		SETUP_SALEABLE_STOCK_ACTION
	WHERE
		STOCK_ACTION_ID = <cfqueryparam cfsqltype="cf_sql_char" value="#attributes.stock_action_id#">
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box closable="1" title="#getLang('','Satılabilir Stok Prensipleri',58747)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="add_stock_action" action="#request.self#?fuseaction=product.emptypopup_upd_saleable_stock_action" method="post">
			<input type="hidden" name="stock_action_id" id="stock_action_id" value="<cfoutput>#attributes.stock_action_id#</cfoutput>">
			<cf_box_elements vertical="1">
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-stock_action_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37778.Prensip Adı'> *</label>
						<div class="col col-8 col-xs-12"> 
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='37778.Prensip Adı'></cfsavecontent>
								<cfinput type="text" name="stock_action_name" value="#GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_NAME#" maxlength="150" required="yes" message="#message#">
								<span class="input-group-addon">
									<cf_language_info 
									table_name="SETUP_SALEABLE_STOCK_ACTION" 
									column_name="STOCK_ACTION_NAME" 
									column_id_value="#attributes.stock_action_id#" 
									maxlength="255" 
									datasource="#DSN3#" 
									column_id="STOCK_ACTION_ID" 
									control_type="1">
								</span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-stock_action_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37779.Prensip Türü'></label>
						<div class="col col-8 col-xs-12"> 
							<select name="stock_action_type" id="stock_action_type">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'>!</option>
								<option value="1" <cfif GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='37167.Bekleyen Sipariş Alınamaz'></option>
								<option value="2" <cfif GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='37169.Bekleyen Siparişe Alınır. Satırdan Silinemez'></option>
								<option value="3" <cfif GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='37174.Bekleyen Siparişe Alınır. Satırdan Silinebilir'></option>
								<option value="4" <cfif GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='37178.Alternatif Ürün Gönderilebilir'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-stock_action_message">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57543.Mesaj'></label>
						<div class="col col-8 col-xs-12"> 
							<cfinput type="text" name="stock_action_message" value="#GET_SALEABLE_STOCK_ACTION.STOCK_ACTION_MESSAGE#" maxlength="250">
						</div>
					</div>
				</div>
			</cf_box_elements>	
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='1' delete_page_url='#request.self#?fuseaction=product.emptypopup_del_saleable_stock_action&stock_action_id=#attributes.stock_action_id#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
