<cfquery name="get_price" datasource="#dsn_dev#">
	SELECT * FROM PRICE_TYPES WHERE TYPE_ID = #attributes.type_id#
</cfquery>

<cfquery name="get_label_types" datasource="#dsn_dev#">
	SELECT * FROM LABEL_TYPES
</cfquery>


<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent  variable="head"><cf_get_lang dictionary_id='61480.Fiyat Tipi'> :</cfsavecontent>
	<cf_box title=" #head# #get_price.type_Name#">
		<cfform action="#request.self#?fuseaction=retail.emptypopup_upd_price_type" method="post" name="update_fis_form">
			<cfinput type="hidden" name="type_id" value="#attributes.type_id#">
			<cf_box_elements>
				<div class="col col-6 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-is_standart">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='33137.Standart'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="is_standart" value="1" <cfif get_price.is_standart eq 1>checked="checked"</cfif>/>
						</div>
					</div>
					<div class="form-group" id="item-is_purchase_sale">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32677.Alış Satış'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="IS_PURCHASE_SALE" value="1" <cfif get_price.IS_PURCHASE_SALE eq 1>checked="checked"</cfif>/>
						</div>
					</div>
					<div class="form-group" id="item-is_cash_out">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61502.Kasa Çıkış'></label>
						<div class="col col-8 col-sm-12">
							<input type="checkbox" name="IS_CASH_OUT" value="1" <cfif get_price.IS_CASH_OUT eq 1>checked="checked"</cfif>/>
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-4 col-sm-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-type_name">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61480.Fiyat Tipi'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="type_name" value="#get_price.type_Name#" maxlength="250">
						</div>
					</div>
					<div class="form-group" id="item-type_code">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58585.Kod'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" name="type_code" value="#get_price.type_code#" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="item-label_type_id">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61479.Etiket Tipi'></label>
						<div class="col col-8 col-sm-12">
							<select name="label_type_id">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_label_types">
									<option value="#type_id#" <cfif get_price.label_type_id eq type_id>selected</cfif>>#type_name#</option>	
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_price">
					<cf_workcube_buttons>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
