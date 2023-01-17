<cf_xml_page_edit fuseact="invent.popup_add_invent_amortization">
<cfparam name="attributes.start_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.finish_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.asset_type" default="">
<cfparam name="attributes.invent_acc_id" default="">
<cfparam name="attributes.period" default="">
<cfparam name="attributes.invent_acc_name" default="">
<cfparam name="attributes.open_form" default="0">
<cfparam name="attributes.amor_method" default="">
<cfparam name="attributes.last_amortization_year" default="">
<cfparam name="attributes.inventory_type" default="1,2,3">
<cfparam name="attributes.accounting_target" default="0">
<cfparam name="attributes.process_date" default="">
<cfparam name="attributes.account_period_list" default="">
<cfquery name="get_acc_period" datasource="#dsn3#">
	SELECT DISTINCT ACCOUNT_PERIOD FROM INVENTORY ORDER BY ACCOUNT_PERIOD
</cfquery>
<cf_catalystHeader>
<cfif is_list_inventory eq 0>
	<cfset new_action = "#request.self#?fuseaction=invent.emptypopup_add_invent_amortization">
<cfelse>
	<cfset new_action = "">
</cfif>
<cf_box>
	<cfform name="add_amortization" method="post" action="#new_action#">
		<input type="hidden" name="open_form" id="open_form" value="<cfoutput>#attributes.open_form#</cfoutput>">
		<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<cfif is_list_inventory eq 0>
						<div class="form-group" id="item-label">
							<div class="col col-12"><label class="bold"><cf_get_lang dictionary_id='57460.Filtre'></label></div>
						</div>
					</cfif>
					<div class="form-group" id="item-purchase_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56996.Alım Tarihi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'> !</cfsavecontent>
								<cfinput type="text" name="start_date" style="width:65px;" required="Yes" message="#message#" value="#attributes.start_date#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="start_date"></span>
								<span class="input-group-addon no-bg"></span>
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
								<cfinput type="text" name="finish_date" style="width:65px;" required="Yes" message="#message#" value="#attributes.finish_date#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finish_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-purchase_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56997.Demirbaş Hesabı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cf_wrk_account_codes form_name='add_amortization' account_code='invent_acc_id' account_name='invent_acc_name' search_from_name='1'>
								<input type="hidden" name="invent_acc_id" id="invent_acc_id" value="<cfoutput>#attributes.invent_acc_id#</cfoutput>">
								<input type="text" name="invent_acc_name" id="invent_acc_name" value="<cfoutput>#attributes.invent_acc_name#</cfoutput>" onkeyup="get_wrk_acc_code_1();">
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_amortization.invent_acc_name&field_id=add_amortization.invent_acc_id</cfoutput>','list')"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-process_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57879.İşlem Tarihi'></cfsavecontent>
								<cfinput type="text" name="process_date" style="width:65px;" required="Yes" message="#message#" value="#attributes.process_date#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date"></span>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-last_amortization_year">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56999.Son Değerleme Yılı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='56998.Son Değerleme Yılı Girmelisiniz '>!</cfsavecontent>
								<cfinput type="text" name="last_amortization_year" style="width:65px;" message="#message#" value="#attributes.last_amortization_year#" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="last_amortization_year"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-amor_method">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="amor_method" id="amor_method">
								<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
								<option value="0" <cfif attributes.amor_method eq "0">selected</cfif>><cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'></option>
								<option value="1" <cfif attributes.amor_method eq "1">selected</cfif>><cf_get_lang dictionary_id='29422.Normal Amortisman'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-account_period_list">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'></label>
						<div class="col col-8 col-xs-12">
							<select name="account_period_list" id="account_period_list">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_acc_period">
									<option value="#account_period#" <cfif attributes.account_period_list eq account_period>selected</cfif>>#account_period#</option>
								</cfoutput>
							</select>
						</div>
					</div>                            
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-accounting_target">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='60776.Muhasebe seçeneği'></label>
						<div class="col col-8 col-xs-12">
							<select name="accounting_target" id="accounting_target">
								<option value="0" <cfif attributes.accounting_target eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.tek düzen'></option>
								<option value="1" <cfif attributes.accounting_target eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
								<option value="2" <cfif attributes.accounting_target eq 2>selected</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-inventory_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56900.Demirbaş Tipi'></label>
						<div class="col col-8 col-xs-12">
							<select name="inventory_type" id="inventory_type" multiple="multiple">
								<option value="1" <cfif listfind(attributes.inventory_type,1)>selected</cfif>><cf_get_lang dictionary_id='56899.Devirden Gelen'></option>
								<option value="2" <cfif listfind(attributes.inventory_type,2)>selected</cfif>><cf_get_lang dictionary_id='56898.Faturadan Kaydedilen'></option>
								<option value="3" <cfif listfind(attributes.inventory_type,3)>selected</cfif>><cf_get_lang dictionary_id='56897.Stok Fişinden Kaydedilen'></option>
								<option value="4" <cfif listfind(attributes.inventory_type,4)>selected</cfif>><cf_get_lang dictionary_id='56894.İrsaliyeden Kaydedilen'></option>
							</select>
						</div>
					</div>
				</div>  
		</cf_box_elements>
		<cfif is_list_inventory eq 0>
			<cfsavecontent  variable="head"><cf_get_lang dictionary_id="56971.Değerle"></cfsavecontent>
			<cf_seperator title="#head#" id="design">	
			<div id="design">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<input name="is_set_zero_value" id="is_set_zero_value" type="hidden" value="<cfoutput>#is_set_zero_value#</cfoutput>">
						<input name="kist_method" id="kist_method" type="hidden" value="<cfoutput>#kist_method#</cfoutput>">
						<div class="form-group" id="item-amort_debt_acc_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56955.Borçlu Hesap"> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="amort_debt_acc_id" id="amort_debt_acc_id" value="">
									<input type="text" name="amort_debt_acc_name" id="amort_debt_acc_name" value="">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_amortization.amort_debt_acc_name&field_id=add_amortization.amort_debt_acc_id</cfoutput>','list')"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-claim_acc_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="34115.Alacaklı Hesap"> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="amort_claim_acc_id" id="amort_claim_acc_id" value="">
									<input type="text" name="amort_claim_acc_name" id="amort_claim_acc_name" value="">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_amortization.amort_claim_acc_name&field_id=add_amortization.amort_claim_acc_id</cfoutput>','list')"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57800.İşlem Tipi"> *</label>
							<div class="col col-8 col-xs-12"><cf_workcube_process_cat slct_width="120"></div>
						</div>
						<div class="form-group" id="item-detail">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57629.Açıklama"></label>
							<div class="col col-8 col-xs-12"><textarea name="detail" id="detail"></textarea></div>
						</div>
					</div>
				</cf_box_elements>
			</div>
		</cfif>
		<cf_box_footer>
			<cfif is_list_inventory eq 0>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56971.Değerle'></cfsavecontent>
				<cf_wrk_search_button button_type="2" button_name="#message#" search_function='kontrol_all_form()'>
			<cfelse>
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57565.Ara'></cfsavecontent>
				<cf_wrk_search_button button_type="2" button_name="#message#" search_function='kontrol()'>
			</cfif>
		</cf_box_footer>
	</cfform>
</cf_box>
<cf_date tarih='attributes.start_date'>
<cf_date tarih='attributes.process_date'>
<cf_date tarih='attributes.finish_date'>
<cfif attributes.open_form eq 1 and is_list_inventory eq 1>
	<cfscript>
		if(isDefined('attributes.accounting_target') and listfind('1,2',attributes.accounting_target)) {
			go_ifrs = 1;
		} else {
			go_ifrs = 0;
		}
	</cfscript>
	<cfquery name="GET_INVENT" datasource="#dsn3#">
		SELECT DISTINCT
			<cfif len(attributes.last_amortization_year)>
				INVENTORY_AMORTIZATON.AMORTIZATON_YEAR,
			</cfif>
			(SELECT SUM(ISNULL(INVENTORY_ROW3.STOCK_IN,0)-ISNULL(INVENTORY_ROW3.STOCK_OUT,0)) FROM INVENTORY_ROW INVENTORY_ROW3 WHERE INVENTORY_ROW3.INVENTORY_ID = I.INVENTORY_ID AND INVENTORY_ROW3.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#) AS MIKTAR,
			I.INVENTORY_ID,
            I.ACCOUNT_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.PROCESS_CAT,
			I.QUANTITY,
			--ISNULL(INVENTORY_HISTORY.AMORTIZATION_RATE,I.AMORTIZATON_ESTIMATE) AMORTIZATON_ESTIMATE,
			I.AMORTIZATON_ESTIMATE AMORTIZATON_ESTIMATE,
			I.AMORTIZATON_METHOD,
			I.AMOUNT,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.COMP_PARTNER_ID,
			<cfif go_ifrs eq 0>I.LAST_INVENTORY_VALUE<cfelse>I.LAST_INVENTORY_VALUE_IFRS LAST_INVENTORY_VALUE</cfif>,
			ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) ACCOUNT_ID,
			ISNULL(INVENTORY_HISTORY.CLAIM_ACCOUNT_CODE,I.CLAIM_ACCOUNT_ID) CLAIM_ACCOUNT_ID,
			ISNULL(INVENTORY_HISTORY.DEBT_ACCOUNT_CODE,I.DEBT_ACCOUNT_ID) DEBT_ACCOUNT_ID,
			<cfif go_ifrs eq 0>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION,I.INVENTORY_DURATION) INVENTORY_DURATION,
			<cfelse>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION_IFRS,I.INVENTORY_DURATION_IFRS) INVENTORY_DURATION,
			</cfif>
			I.ACCOUNT_PERIOD,
			ISNULL(INVENTORY_HISTORY.EXPENSE_ITEM_ID,I.EXPENSE_ITEM_ID) EXPENSE_ITEM_ID,
			ISNULL(INVENTORY_HISTORY.EXPENSE_CENTER_ID,I.EXPENSE_CENTER_ID) EXPENSE_CENTER_ID,
			ISNULL(INVENTORY_HISTORY.PROJECT_ID,I.PROJECT_ID) PROJECT_ID,
			<cfif go_ifrs eq 0>I.AMORTIZATION_COUNT<cfelse>I.AMORTIZATION_COUNT_IFRS AMORTIZATION_COUNT</cfif>,
			<cfif go_ifrs eq 0>I.AMORT_LAST_VALUE<cfelse>I.AMORT_LAST_VALUE_IFRS AMORT_LAST_VALUE</cfif>,
			I.AMORTIZATION_TYPE,
			(SELECT 
				COUNT(IA.AMORTIZATION_ID) AS AMORTIZATION_COUNT
			FROM
				<cfif go_ifrs eq 0>
					INVENTORY_AMORTIZATON IA,
				<cfelse>
					INVENTORY_AMORTIZATON_IFRS IA,
				</cfif>
				INVENTORY_AMORTIZATION_MAIN IAM
			WHERE 
				I.INVENTORY_ID = IA.INVENTORY_ID
				AND IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID
				AND (YEAR(IAM.ACTION_DATE) = #year(attributes.process_date)#  AND #MONTH(session.ep.PERIOD_START_DATE)# > #MONTH(attributes.process_date)# )) INV_COUNT,
            (SELECT TOP 1
				ISNULL(IA2.PARTIAL_AMORTIZATION_VALUE,0) PARTIAL_AMORTIZATION_VALUE
			FROM 
				<cfif go_ifrs eq 0>
					INVENTORY_AMORTIZATON IA2
				<cfelse>
					INVENTORY_AMORTIZATON_IFRS IA2
				</cfif>
			WHERE 
				I.INVENTORY_ID = IA2.INVENTORY_ID
			ORDER BY 
            	AMORTIZATION_ID DESC) PARTIAL_AMORTIZATION_VALUE,
            ISNULL(I.PARTIAL_AMORTIZATION_VALUE,
            (SELECT TOP 1
                ISNULL(IA2.PARTIAL_AMORTIZATION_VALUE,0) PARTIAL_AMORTIZATION_VALUE
            FROM 
				<cfif go_ifrs eq 0>
					INVENTORY_AMORTIZATON IA2
				<cfelse>
					INVENTORY_AMORTIZATON_IFRS IA2
				</cfif>
            WHERE 
                I.INVENTORY_ID = IA2.INVENTORY_ID AND
                IA2.AMORTIZATON_YEAR = YEAR(I.ENTRY_DATE)
            ORDER BY 
                AMORTIZATION_ID DESC)) FIRST_PARTIAL_AMORTIZATION_VALUE
		FROM
			INVENTORY I 
			LEFT JOIN INVENTORY_HISTORY ON INVENTORY_HISTORY.INVENTORY_ID=I.INVENTORY_ID AND INVENTORY_HISTORY.ACTION_DATE<=#attributes.process_date# AND INVENTORY_HISTORY_ID=(SELECT TOP 1 IH.INVENTORY_HISTORY_ID FROM INVENTORY_HISTORY IH WHERE IH.INVENTORY_ID = I.INVENTORY_ID AND IH.ACTION_DATE<=#attributes.process_date# ORDER BY IH.ACTION_DATE DESC,IH.RECORD_DATE DESC),
			INVENTORY_ROW,
			INVENTORY_ROW INVENTORY_ROW_2
			<cfif len(attributes.last_amortization_year)>
				<cfif go_ifrs eq 0>
					,INVENTORY_AMORTIZATON INVENTORY_AMORTIZATON
				<cfelse>
					,INVENTORY_AMORTIZATON_IFRS INVENTORY_AMORTIZATON
				</cfif>
			</cfif>
		WHERE
			INVENTORY_ROW.INVENTORY_ID = I.INVENTORY_ID AND
			INVENTORY_ROW_2.INVENTORY_ID = I.INVENTORY_ID AND
			INVENTORY_ROW.STOCK_IN >= 0 AND 
			I.ENTRY_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date# AND 
			I.ENTRY_DATE <= #attributes.process_date# AND 
			INVENTORY_ROW_2.ACTION_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
			<cfif isDefined("attributes.invent_acc_id") and len(attributes.invent_acc_id) and len(attributes.invent_acc_name)>
				AND ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) = '#attributes.invent_acc_id#'
			</cfif>
			<cfif len(attributes.last_amortization_year)>
				AND I.INVENTORY_ID = INVENTORY_AMORTIZATON.INVENTORY_ID
				AND INVENTORY_AMORTIZATON.AMORTIZATION_ID = (SELECT TOP 1 INVV.AMORTIZATION_ID FROM INVENTORY_AMORTIZATON INVV,INVENTORY_AMORTIZATION_MAIN INVV_MAIN WHERE INVV.INVENTORY_ID = I.INVENTORY_ID AND INVV.INV_AMORT_MAIN_ID = INVV_MAIN.INV_AMORT_MAIN_ID ORDER BY INVV_MAIN.RECORD_DATE DESC)
				AND INVENTORY_AMORTIZATON.AMORTIZATON_YEAR = #Year(attributes.last_amortization_year)#
			</cfif>
			<cfif isDefined("attributes.amor_method") and len(attributes.amor_method)>
				AND I.AMORTIZATON_METHOD = #attributes.amor_method#
			</cfif>
			<cfif isDefined("attributes.inventory_type") and len(attributes.inventory_type)>
				AND I.INVENTORY_TYPE IN(#attributes.inventory_type#)
			</cfif>
			<cfif isDefined("attributes.account_period_list") and len(attributes.account_period_list)>
				AND I.ACCOUNT_PERIOD = #attributes.account_period_list#
			</cfif>
			AND
			<cfif go_ifrs eq 0>I.LAST_INVENTORY_VALUE  > 0<cfelse>I.LAST_INVENTORY_VALUE_IFRS  > 0</cfif>
			AND I.AMORTIZATON_ESTIMATE > 0
            AND  ISNULL((SELECT SUM(ISNULL(IR.STOCK_IN,0)-ISNULL(IR.STOCK_OUT,0)) FROM INVENTORY_ROW IR WHERE IR.INVENTORY_ID = I.INVENTORY_ID),I.QUANTITY) > 0
		GROUP BY
			<cfif len(attributes.last_amortization_year)>
				INVENTORY_AMORTIZATON.AMORTIZATON_YEAR,
			</cfif>
			I.INVENTORY_ID,
			I.INVENTORY_NAME,
			I.INVENTORY_NUMBER,
			I.PROCESS_CAT,
			I.QUANTITY,
			--ISNULL(INVENTORY_HISTORY.AMORTIZATION_RATE,I.AMORTIZATON_ESTIMATE),
			I.AMORTIZATON_ESTIMATE,
			I.AMORTIZATON_METHOD,
			I.AMOUNT,
			I.ENTRY_DATE,
			I.COMP_ID,
			I.COMP_PARTNER_ID,
			<cfif go_ifrs eq 0>I.LAST_INVENTORY_VALUE<cfelse>I.LAST_INVENTORY_VALUE_IFRS</cfif>,
			ISNULL(INVENTORY_HISTORY.ACCOUNT_CODE,I.ACCOUNT_ID) ,
            ACCOUNT_ID,
			ISNULL(INVENTORY_HISTORY.CLAIM_ACCOUNT_CODE,I.CLAIM_ACCOUNT_ID),
			ISNULL(INVENTORY_HISTORY.DEBT_ACCOUNT_CODE,I.DEBT_ACCOUNT_ID),
			<cfif go_ifrs eq 0>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION,I.INVENTORY_DURATION),
			<cfelse>
				ISNULL(INVENTORY_HISTORY.INVENTORY_DURATION_IFRS,I.INVENTORY_DURATION_IFRS),
			</cfif>
			I.ACCOUNT_PERIOD,
			ISNULL(INVENTORY_HISTORY.EXPENSE_ITEM_ID,I.EXPENSE_ITEM_ID),
			ISNULL(INVENTORY_HISTORY.EXPENSE_CENTER_ID,I.EXPENSE_CENTER_ID),
			ISNULL(INVENTORY_HISTORY.PROJECT_ID,I.PROJECT_ID),
			<cfif go_ifrs eq 0>I.AMORTIZATION_COUNT<cfelse>I.AMORTIZATION_COUNT_IFRS</cfif>,
			<cfif go_ifrs eq 0>I.AMORT_LAST_VALUE<cfelse>I.AMORT_LAST_VALUE_IFRS</cfif>,
			I.AMORTIZATION_TYPE,
            I.PARTIAL_AMORTIZATION_VALUE
	</cfquery>
	
	<cfform name="invent_rows" method="post" action="#request.self#?fuseaction=invent.emptypopup_add_invent_amortization">
		<cf_box>
			<cf_grid_list>			
				<thead>
					<tr>
						<th><input type="checkbox" name="hepsi" id="hepsi" value="1" onClick="check_all(this.checked);" checked></th>
						<th><cf_get_lang dictionary_id='57487.No'></th>
						<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
						<th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
						<th style="width:80px;"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></th>
						<th><cf_get_lang dictionary_id ='57635.Miktar'></th>
						<th width="125"><cf_get_lang dictionary_id='56955.Borçlu Hesap'></th>
						<th width="125"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'></th>
						<cfif is_acc_project eq 1><th width="100"><cf_get_lang dictionary_id='57416.Proje'></th></cfif>
						<th width="125"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
						<th width="125"><cf_get_lang dictionary_id='58551.Gider Kalemi'></th>
						<cfif isDefined("attributes.last_amortization_year") and len(attributes.last_amortization_year)>
							<th><cf_get_lang dictionary_id='56953.Son Değerlendirme Yılı'></th>
						</cfif>
						<th><cf_get_lang dictionary_id='29420.Amortisman Yöntemi'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='56908.İlk Değer'></th>
						<th nowrap="nowrap"><cf_get_lang dictionary_id ='56909.Son Değer'></th>
						<th width="75"><cf_get_lang dictionary_id ='56915.Amortisman Oranı'></th>
						<th><cf_get_lang dictionary_id ='56946.Amortisman Tutarı'></th>
						<th><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'>(<cf_get_lang dictionary_id ='58605.Periyod/Yıl'>)<input type="text" name="disc_all" id="disc_all" class="box" style="width:30;"  onblur='all_discount();' onkeyup='return(FormatCurrency(this,event,0));' value=""></th>
						<th><cf_get_lang dictionary_id='56952.Dönemsel Amortisman Tutarı'> (<cf_get_lang dictionary_id='57636.Birim'>)</th>
						<th><cf_get_lang dictionary_id='56951.Toplam Ayrılan Amortisman Tutarı'></th>
						<th><cf_get_lang dictionary_id='56950.Yeni Değer'> (<cf_get_lang dictionary_id='57636.Birim'>)</th>
						<th><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='56950.Yeni Değer'></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_invent.recordcount>		
						<cfset item_id_list=''>
						<cfset expense_id_list=''>
						<cfoutput query="GET_INVENT" maxrows="8000">
							<cfif len(EXPENSE_ITEM_ID) and not listfind(item_id_list,EXPENSE_ITEM_ID)>
								<cfset item_id_list=listappend(item_id_list,EXPENSE_ITEM_ID)>
							</cfif>
							<cfif len(EXPENSE_CENTER_ID) and not listfind(expense_id_list,EXPENSE_CENTER_ID)>
								<cfset expense_id_list=listappend(expense_id_list,EXPENSE_CENTER_ID)>
							</cfif>
						</cfoutput>
						<cfif len(item_id_list)>
							<cfset item_id_list=listsort(item_id_list,"numeric","ASC",",")>
							<cfquery name="get_exp_detail" datasource="#dsn2#">
								SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE,EXPENSE_ITEM_ID FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
							</cfquery>						
							<cfset item_id_list = listsort(listdeleteduplicates(valuelist(get_exp_detail.EXPENSE_ITEM_ID,',')),'numeric','ASC',',')>
						</cfif>
						<cfif len(expense_id_list)>
							<cfset expense_id_list=listsort(expense_id_list,"numeric","ASC",",")>
							<cfquery name="get_exp_center" datasource="#dsn2#">
								SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_id_list#) ORDER BY EXPENSE_ID
							</cfquery>
							<cfset expense_id_list = listsort(listdeleteduplicates(valuelist(get_exp_center.EXPENSE_ID,',')),'numeric','ASC',',')>
						</cfif>
						<cfset count_new = 0>
						<cfoutput query="GET_INVENT">
							<cfset new_value = 0>	
							<cfset diff_value = 0>	
							<cfif miktar gt 0>
								<cfset count_new = count_new+1>
								<tr>
									<td><input type="checkbox" name="invent_row#count_new#" id="invent_row#count_new#" value="#INVENTORY_ID#" checked></td>
									<input type="hidden" name="inventory_id#count_new#" id="inventory_id#count_new#" value="#INVENTORY_ID#">
									<input type="hidden" name="amortization_method#count_new#" id="amortization_method#count_new#" value="#AMORTIZATON_METHOD#">
									<input type="hidden" name="amortization_rate#count_new#" id="amortization_rate#count_new#" value="#AMORTIZATON_ESTIMATE#">
									<input type="hidden" name="account_id#count_new#" id="account_id#count_new#" value="#ACCOUNT_ID#">
									<input type="hidden" name="project_id#count_new#" id="project_id#count_new#" value="#PROJECT_ID#">
									<cfquery name="get_inv_count" datasource="#dsn3#">
										SELECT INVENTORY_ID FROM 
										<cfif go_ifrs eq 0>
											INVENTORY_AMORTIZATON 
										<cfelse>
											INVENTORY_AMORTIZATON_IFRS 
										</cfif> 
										WHERE INVENTORY_ID = #INVENTORY_ID#
									</cfquery>
									<cfquery name="get_inv_control" datasource="#dsn3#">
										SELECT INVENTORY_ID FROM INVENTORY_ROW WHERE INVENTORY_ID = #INVENTORY_ID# AND PROCESS_TYPE = 1181
									</cfquery>
									<input type="hidden" name="amortization_count#count_new#" id="amortization_count#count_new#" value="<cfif len(amortization_count) and amortization_count gt 0 and amortization_count lt get_invent.account_period>#amortization_count#<cfelse>0</cfif>">
									<td align="center">#count_new#</td>
									<td>#INVENTORY_NUMBER#</td>
									<td>#INVENTORY_NAME#<input type="hidden" name="invent_name#count_new#" id="invent_name#count_new#" value="#INVENTORY_NAME#"></td>
									<td >#ACCOUNT_ID#</td>
									<td>#miktar#<input type="hidden" name="quantity#count_new#" id="quantity#count_new#" value="#miktar#"></td>
									<td nowrap="nowrap"><input type="hidden" name="debt_acc_id#count_new#" id="debt_acc_id#count_new#" value="#get_invent.debt_account_id#">
										<input type="text" name="debt_acc#count_new#" id="debt_acc#count_new#" value="#get_invent.debt_account_id#" >
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.debt_acc#count_new#&field_id=invent_rows.debt_acc_id#count_new#','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
									</td>
									<td nowrap="nowrap"><input type="hidden" name="claim_acc_id#count_new#" id="claim_acc_id#count_new#" value="#get_invent.claim_account_id#">
										<input type="text" name="claim_acc#count_new#" id="claim_acc#count_new#" value="#get_invent.claim_account_id#" >
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.claim_acc#count_new#&field_id=invent_rows.claim_acc_id#count_new#','list')"><img src="/images/plus_thin.gif" border="0"  align="absmiddle"></a>
									</td>
									<cfif is_acc_project eq 1>
										<td><cfif len(PROJECT_ID)>#get_project_name(project_id)#</cfif></td>
									</cfif>
									<td><cfif len(EXPENSE_CENTER_ID)>#get_exp_center.EXPENSE[listfind(expense_id_list,EXPENSE_CENTER_ID,',')]#</cfif><input type="hidden" name="expense_center_id#count_new#" id="expense_center_id#count_new#" value="#EXPENSE_CENTER_ID#"></td>
									<td><cfif len(EXPENSE_ITEM_ID)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,EXPENSE_ITEM_ID,',')]#</cfif><input type="hidden" name="expense_item_id#count_new#" id="expense_item_id#count_new#" value="#EXPENSE_ITEM_ID#"></td>
									<cfif isDefined("attributes.last_amortization_year") and len(attributes.last_amortization_year)>
										<td>#AMORTIZATON_YEAR#</td>
									</cfif>
									<td width="70">
										<cfif AMORTIZATON_METHOD eq 0>
											<cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
										<cfelseif AMORTIZATON_METHOD eq 1>
											<cf_get_lang dictionary_id='29422.Normal Amortisman'>
										</cfif>
									</td>
									<td style="text-align:right;">#TLFormat(AMOUNT)#</td>
									<cfif not len(inventory_duration)>
										<cfset last_inv_year = year(entry_date)-1>
									<cfelse>
										<cfset last_inv_year = year(entry_date)+inventory_duration-1>
									</cfif>
									<cfif kist_method eq 1 and amortization_type eq 1 and len(PARTIAL_AMORTIZATION_VALUE)>
										<cfif year(attributes.process_date)-year(entry_date) eq 1 and inv_count eq 0>
											<cfset GET_INVENT.LAST_INVENTORY_VALUE = LAST_INVENTORY_VALUE - PARTIAL_AMORTIZATION_VALUE>			
										</cfif>
										<cfif last_inv_year eq year(attributes.process_date) and inv_count eq 0>
											<cfset GET_INVENT.LAST_INVENTORY_VALUE = LAST_INVENTORY_VALUE + FIRST_PARTIAL_AMORTIZATION_VALUE>	
										</cfif>
									</cfif>
									<!--- devirden geliyorsa ve bir sonraki yilin ilk degerlemesi ise --->
									<cfif attributes.inventory_type eq 1 and kist_method eq 1 and year(attributes.process_date)-year(entry_date) eq 1 and inv_count eq 0>
										<cfset GET_INVENT.LAST_INVENTORY_VALUE = LAST_INVENTORY_VALUE - FIRST_PARTIAL_AMORTIZATION_VALUE>	
									</cfif>
									<td style="text-align:right;"><cfif not len(LAST_INVENTORY_VALUE)>#TLFormat(AMOUNT)#<cfelse>#TLFormat(LAST_INVENTORY_VALUE)#</cfif></td>
									<input type="hidden"  name="last_value#count_new#" id="last_value#count_new#" value="<cfif not len(LAST_INVENTORY_VALUE)>#TLFormat(AMOUNT)#<cfelse>#TLFormat(LAST_INVENTORY_VALUE)#</cfif>"   onkeyup="return(FormatCurrency(this,event));">
									<cfset amort_last_value_ = ''>
									<cfif inv_count eq 0>
										<input type="hidden"  name="amort_value#count_new#" id="amort_value#count_new#" value="#last_inventory_value#">
										<cfset amort_last_value_ = last_inventory_value>
									</cfif> 
								<cfset month_value = abs(datediff('m',attributes.process_date,session.ep.period_start_date))+1>
									<cfif (listfind("0,2",AMORTIZATON_METHOD) and kist_method eq 1 and attributes.inventory_type eq 1) and year(attributes.process_date) is last_inv_year>
										<cfif len(amort_last_value_)>
											<cfset diff_value = amort_last_value_>
										<cfelse>
											<cfset diff_value = AMORT_LAST_VALUE>
										</cfif>
										<cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
										<cfset period_value=(diff_value/12)*month_value>
									<cfelseif listfind("2",AMORTIZATON_METHOD) and len(amort_last_value_)>									
										<cfset diff_value = (amort_last_value_*AMORTIZATON_ESTIMATE)/100><!--- SENELİK AMORTİASMAN TUTARI--->
										<cfset new_value = LAST_INVENTORY_VALUE -diff_value/account_period>
										<cfset period_value=(diff_value/12)*month_value>										
									<cfelseif listfind("0",AMORTIZATON_METHOD) and len(amort_last_value_) and (account_period eq 12 and month_value gte 12)><!---  azalan bakiye koşulu ayırdık--->	
										<cfset diff_value = (amort_last_value_*AMORTIZATON_ESTIMATE)/100><!--- SENELİK AMORTİASMAN TUTARI--->
										<cfset new_value = LAST_INVENTORY_VALUE -diff_value>
										<cfset period_value=(diff_value/12)>
										<!--- #AMORTIZATON_ESTIMATE#-#amort_last_value_#-senelik amortisman #diff_value#-amort #new_value#-dönem amort #period_value#-ay değeri #month_value#<br> --->
									<cfelseif listfind("0",AMORTIZATON_METHOD) and len(amort_last_value_)><!---  azalan bakiye koşulu ayırdık--->
										<cfset diff_value = (amort_last_value*AMORTIZATON_ESTIMATE)/100><!--- aylık AMORTİASMAN TUTARI--->
										<!--- #amort_last_value#-#LAST_INVENTORY_VALUE# --->
										<cfset new_value = LAST_INVENTORY_VALUE -diff_value/account_period>
										<cfset period_value=(diff_value/account_period)>
									<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMORT_LAST_VALUE)>
										<cfset diff_value = (AMORT_LAST_VALUE*AMORTIZATON_ESTIMATE)/100>
										<cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
										<cfset period_value=(diff_value/12)*month_value>
									<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMOUNT)>
										<cfset diff_value = (AMOUNT*AMORTIZATON_ESTIMATE)/100>
										<cfset new_value = AMOUNT - diff_value/account_period>
										<cfset period_value=(diff_value/12)*month_value>
									<cfelseif listfind("1,3",AMORTIZATON_METHOD) and len(LAST_INVENTORY_VALUE)>
										<cfset diff_value = (AMOUNT*AMORTIZATON_ESTIMATE)/100>
										<cfset new_value = LAST_INVENTORY_VALUE - diff_value/account_period>
										<cfset period_value=diff_value/get_invent.account_period>
									<cfelseif listfind("1,3",AMORTIZATON_METHOD)  and len(AMOUNT)>
										<cfset diff_value = (AMOUNT*AMORTIZATON_ESTIMATE)/100>
										<cfset new_value = AMOUNT - diff_value/account_period>
										<cfset period_value=diff_value/get_invent.account_period>
									</cfif>
									<cfif kist_method eq 1 or (amortization_type eq 1 and get_inv_count.recordcount eq 0 and get_inv_control.recordcount eq 0)>
										<cfset period_value_month = diff_value/12>
									<cfelse>
										<cfset period_value_month = diff_value/get_invent.account_period>     
									</cfif>
									<cfif amortization_type eq 2 and get_inv_count.recordcount eq 0 and  get_inv_control.recordcount eq 0><!--- ilk değerlemeyse ve Kıst amortismana tabi değilse önceki aylarında değerlemesi eklenecek --->
										
										<cfset month_value_ = 12/get_invent.account_period>
										<cfset month_value = (abs(datediff('m',attributes.process_date,session.ep.period_start_date))+1)/month_value_>
										<cfif month_value lt 0><cfset month_value = 0></cfif>
										<cfset old_month_value = period_value_month *  month_value>
										<cfset period_value = 0>
										<cfif listfind("0,2",AMORTIZATON_METHOD)and len(AMORT_LAST_VALUE)>
											<cfset new_value = LAST_INVENTORY_VALUE >
										<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMOUNT)>
											<cfset new_value = AMOUNT >
										<cfelseif listfind("1,3",AMORTIZATON_METHOD) and len(LAST_INVENTORY_VALUE)>
											<cfset new_value = LAST_INVENTORY_VALUE >
										<cfelseif listfind("1,3",AMORTIZATON_METHOD)  and len(AMOUNT)>
											<cfset new_value = AMOUNT>
										</cfif>
									<cfelseif amortization_type eq 1 and get_inv_count.recordcount eq 0 and get_inv_control.recordcount eq 0 ><!--- ilk değerlemeyse ve Kıst amortismana tabi ise alındığı aydan sonraki aylar için de değerleme yapılacak --->
										<cfset month_value = abs(datediff('m',attributes.process_date,entry_date))+1>
										<cfif month_value lt 0><cfset month_value = 0></cfif>
										<cfset period_value = 0>
										<cfset old_month_value = period_value_month *  month_value>
										<cfif listfind("0,2",AMORTIZATON_METHOD)and len(AMORT_LAST_VALUE)>
											<cfset new_value = LAST_INVENTORY_VALUE >
										<cfelseif listfind("0,2",AMORTIZATON_METHOD) and len(AMOUNT)>
											<cfset new_value = AMOUNT >
										<cfelseif listfind("1,3",AMORTIZATON_METHOD) and len(LAST_INVENTORY_VALUE)>
											<cfset new_value = LAST_INVENTORY_VALUE >
										<cfelseif listfind("1,3",AMORTIZATON_METHOD)  and len(AMOUNT)>
											<cfset new_value = AMOUNT>
										</cfif>
									<cfelse>
										<cfset old_month_value = 0>
										<cfset month_value = 0>
									</cfif>
									<cfif amortization_type eq 2>
										<cfif len(inventory_duration)>
											<cfset last_inv_date = '#day(session.ep.period_finish_date)#/#month(session.ep.period_finish_date)#/#year(session.ep.period_finish_date)+inventory_duration-1#'>
										<cfelse>
											<cfset last_inv_date = '#day(session.ep.period_finish_date)#/#month(session.ep.period_finish_date)#/#year(session.ep.period_finish_date)#'>
										</cfif>
									<cfelse>
										<cfset month_value = DaysInMonth(entry_date)>
										<cfset zero = ''>
										<cfloop from="1" to="#2-len(month(entry_date))#" index="kk">
											<cfset zero = '0#zero#'>
										</cfloop>
										<cfif len(inventory_duration)>
											<cfset last_inv_date = '#day(session.ep.period_finish_date)#/#month(session.ep.period_finish_date)#/#year(session.ep.period_finish_date)+inventory_duration-1#'>
										<cfelse>
											<cfset last_inv_date = '#day(session.ep.period_finish_date)#/#month(session.ep.period_finish_date)#/#year(session.ep.period_finish_date)#'>
										</cfif>
									</cfif>
									<cfset period_value = period_value + old_month_value>
									<cfset new_value = new_value - old_month_value>
									<cfif month(entry_date) eq 2>
										<cftry>
											<cfset last_inv_date = createodbcdate(last_inv_date)>
											<cfcatch type="any">
												<cfset month_value= month_value - 1>
												<cfif len(inventory_duration)>
													<cfset last_inv_date = '#month_value#/#zero##month(entry_date)#/#inventory_duration+year(entry_date)#'>
												<cfelse>
													<cfset last_inv_date = '#month_value#/#zero##month(entry_date)#/#year(entry_date)#'>
												</cfif>
												<cfset last_inv_date = createodbcdate(last_inv_date)>
											</cfcatch>
										</cftry>
									<cfelse>
										<cfset last_inv_date = createodbcdate(last_inv_date)>	
									</cfif>
									<cfif amortization_type eq 2 and attributes.process_date gte last_inv_date>
									<!--- Kıst amotrismana tabi değilse Giriş Yılı+ Faydalı Ömür toplamını alacağız. Çıkan sonucun 31.12 tarihi ömrünün bitişi tarihidir. 1 Mayıs 2012 de adıysam ve faydalı ömür 5 yıl ise 31/12/2016 da bitecektir. --->
										<cfset period_value = last_inventory_value>
										<cfset new_value = 0>
									<cfelseif amortization_type eq 1 and attributes.process_date gte last_inv_date>
									<!--- Kıst amortismana tabi isede 1 Mayıs 2012 de aldıysam 31/Mayıs/2017 de ömrü biter --->
										<cfset period_value = last_inventory_value>
										<cfset new_value = 0>
									</cfif>
									<!--- 
									islem yılı: #year(attributes.process_date)# _ son gun: #last_inv_date# _ son yıl:#last_inv_year# <br />
									period_value: #period_value# <br />
									son deger: #LAST_INVENTORY_VALUE# <br />
									new value: #new_value#
									--->
									<cfif listfind("0,2",AMORTIZATON_METHOD) and year(attributes.process_date) is last_inv_year>
							
										<cfset period_value = diff_value/account_period>
									</cfif>
									<cfset total_amortization = wrk_round(period_value)*miktar>
									<td style="text-align:right;">#TLFormat(AMORTIZATON_ESTIMATE)#</td>
									<td width="70" style="text-align:right;">#TLFormat(diff_value)#<input type="hidden"  name="diff_value#count_new#" id="diff_value#count_new#" value="#TLFormat(diff_value)#"   onkeyup="return(FormatCurrency(this,event));"></td>
									<td style="text-align:center;">
										<input type="hidden" name="hd_period#count_new#" id="hd_period#count_new#" value="#get_invent.account_period#" >
										<input type="hidden" class="moneybox" name="period#count_new#" id="period#count_new#" value="#get_invent.account_period#"   onkeyup="return(FormatCurrency(this,event,0));" onBlur="period_hesapla(#count_new#);" >
										#get_invent.account_period#
									</td>
									<input type="hidden" name="new_inventory_value#count_new#" id="new_inventory_value#count_new#" value="#TLFormat(new_value)#" onkeyup="return(FormatCurrency(this,event));">
									<cfif len(partial_amortization_value)>
										<cfset partial_amortization_value_ = partial_amortization_value-period_value>
									<cfelse>
										<cfset partial_amortization_value_ = diff_value-period_value>
									</cfif>
									<input type="hidden" name="partial_amortization_value#count_new#" id="partial_amortization_value#count_new#" value="#TLFormat(partial_amortization_value_)#" onkeyup="return(FormatCurrency(this,event));" >
									<td width="65" style="text-align:right;"><input type="text" name="period_diff_value#count_new#" id="period_diff_value#count_new#" value="#TLFormat(period_value)#"  <cfif amortization_type eq 2>readonly</cfif> class="moneybox"  onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#count_new#);"></td>
									<td width="65" style="text-align:right;"><input type="text" name="total_amortization#count_new#" id="total_amortization#count_new#" value="#TLFormat(total_amortization)#" readonly  class="moneybox"  onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#count_new#);"></td>
									<td width="65" style="text-align:right;"><input type="text" name="new_value#count_new#" id="new_value#count_new#" value="#TLFormat(new_value)#"  readonly class="moneybox"  onkeyup="return(FormatCurrency(this,event));"></td>
									<td width="65" style="text-align:right;"><input type="text" name="total_new_value#count_new#" id="total_new_value#count_new#" value="#TLFormat(wrk_round(new_value)*miktar)#"  readonly class="moneybox"  onkeyup="return(FormatCurrency(this,event));"></td>
								</tr>
							</cfif>
						</cfoutput>								
					<cfelse> 
						<tr>
							<td colspan="11"><cf_get_lang dictionary_id ='58486.Kayıt Bulunamadı'></td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cf_box>
		<cfif get_invent.recordcount>
			<cf_box>
				<input name="all_records" id="all_records" type="hidden" value="<cfoutput>#count_new#</cfoutput>">
				<input name="process_date" id="process_date" type="hidden" value="<cfoutput>#attributes.process_date#</cfoutput>">
				<input name="is_set_zero_value" id="is_set_zero_value" type="hidden" value="<cfoutput>#is_set_zero_value#</cfoutput>">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-process_cat_bottom">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process_cat slct_width="170">
							</div>
						</div>
						<div class="form-group" id="item-amort_debt_acc_name_bottom">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56955.Borçlu Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="amort_debt_acc_id" id="amort_debt_acc_id" value="">
									<input type="text" name="amort_debt_acc_name" id="amort_debt_acc_name" value="" onFocus="AutoComplete_Create('amort_debt_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','amort_debt_acc_id','invent_rows','3','140');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.amort_debt_acc_name&field_id=invent_rows.amort_debt_acc_id</cfoutput>','list')" title="<cfoutput>#getLang('invent',62)#</cfoutput>"></span>
								</div>
								
							</div>
						</div>
						<div class="form-group" id="item-amort_claim_acc_name_bottom">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'> *</label>
							<div class="col col-8 col-xs-12">	
								<div class="input-group">
									<input type="hidden" name="amort_claim_acc_id" id="amort_claim_acc_id" value="">
									<input type="text" name="amort_claim_acc_name" id="amort_claim_acc_name" value="" onFocus="AutoComplete_Create('amort_claim_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','amort_claim_acc_id','invent_rows','3','140');" autocomplete="off">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.amort_claim_acc_name&field_id=invent_rows.amort_claim_acc_id</cfoutput>','list')" title="<cfoutput>#getLang('invent',61)#</cfoutput>"></span>
								</div>
							</div>
						</div>						
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-accounting_target">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='60776.Muhasebe seçeneği'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="accounting_target" value="<cfoutput>#attributes.accounting_target#</cfoutput>">
								<select name="accounting_target" id="accounting_target" disabled>
									<option value="0" <cfif attributes.accounting_target eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.tek düzen'></option>
									<option value="1" <cfif attributes.accounting_target eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
									<option value="2" <cfif attributes.accounting_target eq 2>selected</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-detail_bottom">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
							<div class="col col-8 col-xs-12">	
								<textarea name="detail" id="detail"></textarea>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cfsavecontent variable="message"><cf_get_lang dictionary_id ='56971.Değerle'></cfsavecontent>
					<cf_workcube_buttons is_upd='0' insert_info = '#message#' add_function='input_control()'>
				</cf_box_footer> 
			</cf_box>
		</cfif>
	</cfform>
	
	<script type="text/javascript">
		function check_all(deger)
		{
			<cfif GET_INVENT.recordcount>
				if(invent_rows.hepsi.checked)
				{
					for (var i=1; i <= <cfoutput>#GET_INVENT.recordcount#</cfoutput>; i++)
					{
						if(eval('invent_rows.invent_row'+i) != undefined)
						{
							var form_field = eval("document.invent_rows.invent_row" + i);
							form_field.checked = true;
							eval('invent_rows.invent_row'+i).focus();
						}
					}
				}
				else
				{
					for (var i=1; i <= <cfoutput>#GET_INVENT.recordcount#</cfoutput>; i++)
					{
						if(eval('invent_rows.invent_row'+i) != undefined)
						{						
							form_field = eval("document.invent_rows.invent_row" + i);
							form_field.checked = false;
							eval('invent_rows.invent_row'+i).focus();
						}
					}				
				}
			</cfif>
		}
		function period_hesapla(no)
		{    
			period_kontrol(no);
			deger=eval("document.invent_rows.diff_value" + no).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger1=eval("document.invent_rows.period" + no).value;
			deger1=filterNum(deger1);			
			deger1=parseFloat(deger1);
			deger2=eval("document.invent_rows.last_value" + no).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			quantity = eval("document.invent_rows.quantity" + no).value;
			eval("document.invent_rows.total_amortization" + no).value=commaSplit(deger/deger1*quantity);
			eval("document.invent_rows.period_diff_value" + no).value=commaSplit(deger/deger1);
			eval("document.invent_rows.new_value" + no).value=commaSplit(deger2-deger/deger1);
			eval("document.invent_rows.new_inventory_value" + no).value=commaSplit(deger2-deger/deger1);
			return true;	
		}
		function hesapla(no)
		{    
			deger=eval("document.invent_rows.period_diff_value" + no).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger2=eval("document.invent_rows.last_value" + no).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			quantity = eval("document.invent_rows.quantity" + no).value;
			eval("document.invent_rows.total_amortization" + no).value=commaSplit(deger*quantity);
			eval("document.invent_rows.new_value" + no).value=commaSplit(deger2-deger);
			return true;	
		}
		function  period_kontrol(no)
		{
			deger1= eval("document.invent_rows.hd_period"+no);
			deger = eval("document.invent_rows.period"+no);
			if ((filterNum(deger.value) <1) || (deger.value==""))
			{ 
				alert ("<cf_get_lang dictionary_id='56959.Hesaplama Dönemi 1 den Küçük Olamaz'>!");
				deger.value=deger1.value;
				return false;
			}
		}
	</script>
</cfif>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_amortization.inventory_type.value == '')
		{
			alert("<cf_get_lang dictionary_id='59780.Demirbaş Tipi Seçmelisiniz'> !");
			return false;
		}
		if(document.add_amortization.account_period_list.value == '')
		{
			alert("<cf_get_lang dictionary_id='59781.Hesaplama Dönemi Seçmelisiniz'> !");
			return false;
		}
		var document_id = document.add_amortization.inventory_type.options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
		{
			if(document.add_amortization.inventory_type.options[i].selected && document_name.length==0)
				document_name = document_name + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
			else if(document.add_amortization.inventory_type.options[i].selected && ! list_find(document_name,list_getat(document.add_amortization.inventory_type.options[i].value,1,'-'),','))
				document_name = document_name + ',' + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
		}
		if(list_find(document_name,4) &&  list_len(document_name) != 1)
		{
			alert("<cf_get_lang dictionary_id='59782.İrsaliyeden Kaydedilen Demirbaşları Ayrı Değerlemelisiniz'> !");
			return false;
		}
		document.add_amortization.open_form.value = 1
		return true;
	}
	function input_control()
	{
		if (!chk_process_cat('invent_rows')) return false;
		if(!check_display_files('invent_rows')) return false;
		var checked_info = false;
		var toplam = document.invent_rows.all_records.value;
		for(var i=1; i<=toplam; i++)
		{
			if(eval('invent_rows.invent_row'+i).checked)
			{
				checked_info = true;
				i = toplam+1;
			}
		}
		<cfif isdefined("is_set_zero_value") and is_set_zero_value eq 1>
			if(confirm('<cf_get_lang dictionary_id="59783.Eksiye Düşen Demirbaşların Amortisman Tutarları Yeniden Hesaplanacak! Emin misiniz?">'))
			{
				for(var t=1; t<=toplam; t++)
				{
					if(eval('invent_rows.invent_row'+t).checked)
					{
						if(filterNum(eval("document.invent_rows.new_value" + t).value) < 0)
						{
							deger1=eval("document.invent_rows.period" + t).value;
							deger1=filterNum(deger1);	
							last_value = parseFloat(filterNum(eval("document.invent_rows.period_diff_value" + t).value)) - Math.abs(parseFloat(filterNum(eval("document.invent_rows.new_value" + t).value)));
							eval("document.invent_rows.diff_value" + t).value = commaSplit(parseFloat(last_value)*parseFloat(deger1));
							period_hesapla(t);
						}
					}
				}
			}
		</cfif>
		for(var t=1; t<=toplam; t++)
		{
			if(eval('invent_rows.invent_row'+t).checked)
			{
				if(eval("document.invent_rows.diff_value" + t).value == "")
				{
					alert("<cf_get_lang dictionary_id='56948.Amortisman Tutarı Giriniz'>!");
					return false;
				}
				<cfif isdefined("is_zero_kontrol") and is_zero_kontrol eq 1>
					if(filterNum(eval("document.invent_rows.new_value" + t).value) < 0)
					{
						alert("<cf_get_lang dictionary_id='59785.Amortisman Değeri Sıfırdan Küçük Olamaz'> !");
						return false;
					}
				</cfif>
				if((eval("document.invent_rows.debt_acc" + t).value =="") || (eval("document.invent_rows.claim_acc" + t).value == ""))
				{
					if(invent_rows.amort_debt_acc_id.value=="" || invent_rows.amort_claim_acc_id.value=="")
					{
						alert("<cf_get_lang dictionary_id='56949.Amortisman Hesabı Seçiniz'>!");
						return false;
					}
				}
			}
		}
		if(!checked_info)
		{
			alert("<cf_get_lang dictionary_id='56947.Seçim Yapmadınız'>!");
			return false;
		}
		else
		return true;
	}
	<cfif attributes.open_form eq 1 and is_list_inventory eq 1>
	function all_discount()
	{	
		if (document.invent_rows.disc_all.value == "")
			document.invent_rows.disc_all.value = 0;
			deger = eval("document.invent_rows.disc_all");
			if ((filterNum(deger.value) <1) || (deger.value==""))
			{ 
				alert ("<cf_get_lang dictionary_id='56959.Hesaplama Dönemi 1den Küçük Olamaz'>!");
				deger.value =1;
			}
			else
			{	
			discount_yeni= document.invent_rows.disc_all.value;
			<cfif get_invent.recordcount>
			for(var i=1; i<=<cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
				  eval('invent_rows.period'+i).value=discount_yeni;
				}
			</cfif>
		}
		for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
		{
			deger=eval("document.invent_rows.diff_value" + i).value;
			deger=filterNum(deger);			
			deger=parseFloat(deger);
			deger1=eval("document.invent_rows.period" + i).value;
			deger1=filterNum(deger1);			
			deger1=parseFloat(deger1);
			eval("document.invent_rows.period_diff_value" + i).value=commaSplit(deger/deger1);
			deger2=eval("document.invent_rows.last_value" + i).value;
			deger2=filterNum(deger2);			
			deger2=parseFloat(deger2);
			eval("document.invent_rows.period_diff_value" + i).value=commaSplit(deger/deger1);
			eval("document.invent_rows.new_value" + i).value=commaSplit(deger2-deger/deger1);
			eval("document.invent_rows.new_inventory_value" + i).value=commaSplit(deger2-deger/deger1);
			hesapla(i);
		}
		return true;
	}
	</cfif>
	function kontrol_all_form()
	{
		if(document.add_amortization.inventory_type.value == '')
		{
			alert("<cf_get_lang dictionary_id='59780.Demirbaş Tipi Seçmelisiniz'> !");
			return false;
		}
		if(document.add_amortization.account_period_list.value == '')
		{
			alert("<cf_get_lang dictionary_id='59781.Hesaplama Dönemi Seçmelisiniz'> !");
			return false;
		}
		var document_id = document.add_amortization.inventory_type.options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
		{
			if(document.add_amortization.inventory_type.options[i].selected && document_name.length==0)
				document_name = document_name + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
			else if(document.add_amortization.inventory_type.options[i].selected && ! list_find(document_name,list_getat(document.add_amortization.inventory_type.options[i].value,1,'-'),','))
				document_name = document_name + ',' + list_getat(document.add_amortization.inventory_type.options[i].value,1,'-');
		}
		if(list_find(document_name,4) &&  list_len(document_name) != 1)
		{
			alert("<cf_get_lang dictionary_id='59782.İrsaliyeden Kaydedilen Demirbaşları Ayrı Değerlemelisiniz'> !");
			return false;
		}
		if (!chk_process_cat('add_amortization')) return false;
		if(!check_display_files('add_amortization')) return false;
		if(add_amortization.amort_debt_acc_id.value=="" || add_amortization.amort_claim_acc_id.value=="")
		{
			alert("<cf_get_lang dictionary_id='56949.Amortisman Hesabı Seçiniz'>!");
			return false;
		}
		if(!confirm("<cf_get_lang dictionary_id='59784.Filtrelere Uygun Tüm Demirbaşlar İçin Değerleme İşlemi Yapılacaktır. Emin misiniz?'>"))
			return false;
	}
</script>
