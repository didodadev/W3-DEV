<cf_xml_page_edit fuseact="invent.popup_add_invent_amortization">
<cfparam name="attributes.last_amortization_year" default="">
<cfparam name="attributes.old_value" default=0>
<cfquery name="GET_DETAIL" datasource="#dsn3#">
	SELECT
		DETAIL,
		PROCESS_TYPE,
		ACTION_DATE,
		PROCESS_CAT,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_EMP,
		UPDATE_DATE,
		ACCOUNTING_TYPE
	FROM
		INVENTORY_AMORTIZATION_MAIN
	WHERE
		INV_AMORT_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_id#">		
</cfquery>
<cfquery name="GET_INVENT" datasource="#dsn3#">
	SELECT
		DISTINCT
		INVENTORY_AMORTIZATON.*,
		<cfif GET_DETAIL.accounting_type eq 0>LAST_INVENTORY_VALUE<cfelse>LAST_INVENTORY_VALUE_IFRS LAST_INVENTORY_VALUE</cfif>,
		INVENTORY.ACCOUNT_ID,
		INVENTORY.INVENTORY_NUMBER,
		INVENTORY.INVENTORY_NAME,
		INVENTORY.PROJECT_ID,
		INVENTORY.EXPENSE_ITEM_ID,
		INVENTORY.EXPENSE_CENTER_ID,
		ISNULL(INVENTORY_AMORTIZATON.INV_QUANTITY,INVENTORY.QUANTITY) QUANTITY,
		INVENTORY.AMOUNT,
		INVENTORY_ROW.STOCK_IN,
        INVENTORY.ACCOUNT_ID,
		INVENTORY_AMORTIZATON.CLAIM_ACCOUNT_ID,
		INVENTORY_AMORTIZATON.DEBT_ACCOUNT_ID
	FROM
		INVENTORY,
		INVENTORY_ROW,
		<cfif GET_DETAIL.accounting_type eq 0>
			INVENTORY_AMORTIZATON
		<cfelse>
			INVENTORY_AMORTIZATON_IFRS INVENTORY_AMORTIZATON
		</cfif>
	WHERE
		INVENTORY.INVENTORY_ID=INVENTORY_ROW.INVENTORY_ID AND 
		INVENTORY_ROW.STOCK_IN > 0 AND 
		INVENTORY.INVENTORY_ID=INVENTORY_AMORTIZATON.INVENTORY_ID AND
		INVENTORY_AMORTIZATON.INV_AMORT_MAIN_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.inv_id#">		
</cfquery>
<cfset inv_list = valuelist(get_invent.inventory_id)>

<cf_catalystHeader>
<cfform name="invent_rows" method="post" action="#request.self#?fuseaction=invent.emptypopup_upd_invent_amortization">
<input name="inv_id" id="inv_id" type="hidden" value="<cfoutput>#attributes.inv_id#</cfoutput>">
	<cfif get_invent.recordcount>
	<cf_box>
		<cf_grid_list>
			<thead>	
				<tr>
					<th><input type="checkbox" name="hepsi" id="hepsi" value="1" onClick="check_all(this.checked);" checked></th>
					<th><cf_get_lang dictionary_id='57487.No'></th>
					<th><cf_get_lang dictionary_id='58878.Demirbaş No'></th>
					<th width="75"><cf_get_lang dictionary_id ='57629.Açıklama'></th>
					<th style="width:80px;"><cf_get_lang dictionary_id ='58811.Muhasebe Kodu'></th>
					<th><cf_get_lang dictionary_id ='57635.Mikt'></th>
					<th width="120"><cf_get_lang dictionary_id='56955.Borçlu Hesap'></th>
					<th width="120"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'></th>
					<th width="100"><cf_get_lang dictionary_id='57416.Proje'></th>
					<th width="125"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th>
					<th width="125"><cf_get_lang dictionary_id='58234.Bütçe Kalemi'></th>
					<cfif isDefined("attributes.last_amortization_year") and len(attributes.last_amortization_year)>
						<th><cf_get_lang dictionary_id='56953.Son Değerlendirme Yılı'></th>
					</cfif>
					<th><cf_get_lang dictionary_id ='58606.Amort Yöntemi'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='56908.İlk Değer'></th>
					<th nowrap="nowrap"><cf_get_lang dictionary_id ='56909.Son Değer'></th>
					<th width="75"><cf_get_lang dictionary_id ='56915.Amortisman Oranı'></th>
					<th><cf_get_lang dictionary_id='56946.Amortisman Tutarı'></th>
					<th><cf_get_lang dictionary_id='56967.Hesaplama Dönemi'>(<cf_get_lang dictionary_id ='58605.Periyod/Yıl)'>)<input type="text" name="disc_all" id="disc_all" class="box" style="width:30;"  onblur='all_discount();' onkeyup='return(FormatCurrency(this,event,0));' value=""></th>
					<th><cf_get_lang dictionary_id='56952.Dönemsel Amortisman Tutarı'><br />(<cf_get_lang dictionary_id='57636.Birim'>)</th>
					<th><cf_get_lang dictionary_id='56951.Toplam Ayrılan Amortisman Tutarı'></th>
					<th><cf_get_lang dictionary_id='56950.Yeni Değer'><br />(<cf_get_lang dictionary_id='57636.Birim'>)</th>
					<th><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='56950.Yeni Değer'></th>
				</tr>
			</thead>
			<cfset item_id_list=''>
			<cfset expense_id_list=''>
			<cfoutput query="get_invent">
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
					SELECT EXPENSE_ITEM_NAME,ACCOUNT_CODE FROM EXPENSE_ITEMS WHERE EXPENSE_ITEM_ID IN (#item_id_list#) ORDER BY EXPENSE_ITEM_ID
				</cfquery>
			</cfif>
			<cfif len(expense_id_list)>
				<cfset expense_id_list=listsort(expense_id_list,"numeric","ASC",",")>
				<cfquery name="get_exp_center" datasource="#dsn2#">
					SELECT EXPENSE,EXPENSE_ID FROM EXPENSE_CENTER WHERE EXPENSE_ID IN (#expense_id_list#) ORDER BY EXPENSE_ID
				</cfquery>
			</cfif>
			<input name="all_records" id="all_records" type="hidden" value="<cfoutput>#get_invent.recordcount#</cfoutput>">
			<cfoutput query="get_invent">
			<tbody>
				<tr>
					<td><input type="checkbox" name="invent_row#currentrow#" id="invent_row#currentrow#" value="#INVENTORY_ID#" checked></td>
					<input type="hidden" name="inventory_id#currentrow#" id="inventory_id#currentrow#" value="#INVENTORY_ID#">
					<input type="hidden" name="amortization_method#currentrow#" id="amortization_method#currentrow#" value="#AMORTIZATON_METHOD#">
					<input type="hidden" name="amortization_rate#currentrow#" id="amortization_rate#currentrow#" value="#AMORTIZATON_ESTIMATE#">
					<input type="hidden" name="account_id#currentrow#" id="account_id#currentrow#" value="#ACCOUNT_ID#">
					<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#PROJECT_ID#">
					<td>#currentrow#</td>
					<td>#INVENTORY_NUMBER#</td>
					<td>#INVENTORY_NAME#<input type="hidden" name="invent_name#currentrow#" id="invent_name#currentrow#" value="#INVENTORY_NAME#"></td>
					<td >#ACCOUNT_ID#</td>
					<td>#QUANTITY#</td>
					<input type="hidden" name="quantity#currentrow#" id="quantity#currentrow#" value="#get_invent.QUANTITY#">
					<td nowrap="nowrap"><input type="hidden" name="debt_acc_id#currentrow#" id="debt_acc_id#currentrow#" value="#get_invent.debt_account_id#">
						<input type="text" name="debt_acc#currentrow#" id="debt_acc#currentrow#" value="#get_invent.debt_account_id#" style="width:120px;">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.debt_acc#currentrow#&field_id=invent_rows.debt_acc_id#currentrow#','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td nowrap="nowrap"><input type="hidden" name="claim_acc_id#currentrow#" id="claim_acc_id#currentrow#" value="#get_invent.claim_account_id#">
						<input type="text" name="claim_acc#currentrow#" id="claim_acc#currentrow#" value="#get_invent.claim_account_id#" style="width:120px;">
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.claim_acc#currentrow#&field_id=invent_rows.claim_acc_id#currentrow#','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td><cfif len(PROJECT_ID)>#get_project_name(PROJECT_ID)#</cfif></td>
					<td><cfif len(EXPENSE_CENTER_ID)>#get_exp_center.EXPENSE[listfind(expense_id_list,EXPENSE_CENTER_ID,',')]#</cfif><input type="hidden" name="expense_center_id#currentrow#" id="expense_center_id#currentrow#" value="#EXPENSE_CENTER_ID#"></td>
					<td><cfif len(EXPENSE_ITEM_ID)>#get_exp_detail.EXPENSE_ITEM_NAME[listfind(item_id_list,EXPENSE_ITEM_ID,',')]#</cfif><input type="hidden" name="expense_item_id#currentrow#" id="expense_item_id#currentrow#" value="#EXPENSE_ITEM_ID#"></td>
					<cfif isDefined("attributes.last_amortization_year") and len(attributes.last_amortization_year)>
					<td>#AMORTIZATON_YEAR#</td>
					</cfif>
					<td width="70">
						<cfif AMORTIZATON_METHOD eq 0>
							<cf_get_lang dictionary_id='29421.Azalan Bakiye Üzerinden'>
						<cfelseif AMORTIZATON_METHOD eq 1>
							<cf_get_lang dictionary_id='29422.Sabit Miktar Üzeriden'>
						</cfif>
					</td>
					<td  style="text-align:right;">#TLFormat(AMOUNT)#</td>
					<cfset attributes.old_value=AMORTIZATON_VALUE+PERIODIC_AMORT_VALUE>
					<cfset total_amortization = PERIODIC_AMORT_VALUE*get_invent.quantity>
					<td  style="text-align:right;">#TLFormat(attributes.old_value)#</td>
					<input type="hidden"  name="last_value#currentrow#" id="last_value#currentrow#" value="#TLFormat(attributes.old_value)#" style="width:50px;"  onkeyup="return(FormatCurrency(this,event));">
					<td  style="text-align:right;">#TLFormat(AMORTIZATON_ESTIMATE)#</td>
					<td  style="text-align:right;">#TLFormat(AMORTIZATON_INV_VALUE)#
					<input type="hidden"  name="diff_value#currentrow#" id="diff_value#currentrow#" value="#TLFormat(amortizaton_inv_value)#" style="width:50px;"  onkeyup="return(FormatCurrency(this,event));">
					</td>
					<td  style="text-align:right;">#get_invent.account_period#
					<input type="hidden" name="hd_period#currentrow#" id="hd_period#currentrow#" value="#get_invent.account_period#">
					<input type="hidden" class="moneybox" name="period#currentrow#" id="period#currentrow#" value="#get_invent.account_period#" style="width:70px;"  onkeyup="return(FormatCurrency(this,event,0));" onBlur="period_hesapla(#currentrow#);" >
					</td>
					<input type="hidden" name="new_inventory_value#currentrow#" id="new_inventory_value#currentrow#" value="#TLFormat(periodic_amort_value)#" onkeyup="return(FormatCurrency(this,event));" >
					<td width="60"  style="text-align:right;"><input type="text" name="period_diff_value#currentrow#" id="period_diff_value#currentrow#" value="#TLFormat(periodic_amort_value)#" style="width:70px;" class="moneybox"  onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#currentrow#);"></td>
					<td width="60"  style="text-align:right;"><input type="text" name="total_amortization#currentrow#" id="total_amortization#currentrow#" value="#TLFormat(total_amortization)#" style="width:70px;" class="moneybox"  onkeyup="return(FormatCurrency(this,event));" onBlur="hesapla(#currentrow#);"></td>
					<td width="60"  style="text-align:right;"><input type="text" name="new_value#currentrow#" id="new_value#currentrow#" value="#TLFormat(amortizaton_value)#" style="width:70px;" class="moneybox"  onkeyup="return(FormatCurrency(this,event));"></td>
					<td width="65" style="text-align:right;"><input type="text" name="total_new_value#currentrow#" id="total_new_value#currentrow#" value="#TLFormat(quantity*amortizaton_value)#" style="width:70px;" readonly class="moneybox"  onkeyup="return(FormatCurrency(this,event));"></td>
				</tr>
			</tbody>
			</cfoutput>
		</cf_grid_list>
	</cf_box>
	<cf_box>
        <cf_box_elements>
		    <div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-process_cat_bottom">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57800.İşlem Tipi'> *</label>
                    <div class="col col-8 col-xs-12">
                        <cf_workcube_process_cat process_cat='#get_detail.process_cat#' slct_width="150">
                    </div>
                </div>
                <div class="form-group" id="item-amort_debt_acc_name_bottom">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56955.Borçlu Hesap'> *</label>
                    <div class="col col-8 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="amort_debt_acc_id" id="amort_debt_acc_id" value="<cfoutput>#GET_INVENT.DEBT_ACCOUNT_ID#</cfoutput>">
							<input type="text" name="amort_debt_acc_name" id="amort_debt_acc_name" value="<cfoutput>#GET_INVENT.DEBT_ACCOUNT_ID#</cfoutput>" onFocus="AutoComplete_Create('amort_debt_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','amort_debt_acc_id','invent_rows','3','140');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.amort_debt_acc_name&field_id=invent_rows.amort_debt_acc_id</cfoutput>','list')" title="<cf_get_lang dictionary_id='56955.Borçlu Hesap'>"></span>
                        </div>
                        
                    </div>
                </div>
                <div class="form-group" id="item-amort_claim_acc_name_bottom">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34115.Alacaklı Hesap'> *</label>
                    <div class="col col-8 col-xs-12">	
                        <div class="input-group">
                            <input type="hidden" name="amort_claim_acc_id" id="amort_claim_acc_id" value="<cfoutput>#GET_INVENT.CLAIM_ACCOUNT_ID#</cfoutput>">
							<input type="text" name="amort_claim_acc_name" id="amort_claim_acc_name" value="<cfoutput>#GET_INVENT.CLAIM_ACCOUNT_ID#</cfoutput>" onFocus="AutoComplete_Create('amort_claim_acc_name','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','amort_claim_acc_id','invent_rows','3','140');" autocomplete="off">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=invent_rows.amort_claim_acc_name&field_id=invent_rows.amort_claim_acc_id</cfoutput>','list')" title="<cf_get_lang dictionary_id='34115.Alacaklı Hesap'>"></span>
                        </div>
                    </div>
                </div>
            </div>
			<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-process_date_bottom">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='60776.Muhasebe seçeneği'></label>						
					<div class="col col-8 col-xs-12">
						<select name="accounting_target" id="accounting_target" disabled>
							<option value="0" <cfif GET_DETAIL.accounting_type eq 0>selected</cfif>><cf_get_lang dictionary_id ='58793.tek düzen'></option>
							<option value="1" <cfif GET_DETAIL.accounting_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='58308.IFRS'></option>
							<option value="2" <cfif GET_DETAIL.accounting_type eq 2>selected</cfif>><cf_get_lang dictionary_id="58793.Tek düzen"> + <cf_get_lang dictionary_id="58308.ufrs"></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-process_date_bottom">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'> *</label>
                    <div class="col col-8 col-xs-12">	
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57879.İşlem Tarihi'></cfsavecontent>
							<cfinput type="text" name="process_date" style="width:65px;" required="Yes" message="#message#" value="#dateformat(get_detail.action_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="process_date"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-detail_bottom">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">	
                        <textarea name="detail" id="detail"><cfoutput>#get_detail.detail#</cfoutput></textarea>
                        <cfquery name="get_amortization" datasource="#dsn3#">
                            SELECT 
                                IA.INV_AMORT_MAIN_ID
                            FROM 
								<cfif GET_DETAIL.accounting_type eq 0>
									INVENTORY_AMORTIZATON IA
								<cfelse>
									INVENTORY_AMORTIZATON_IFRS IA
								</cfif>
                               , INVENTORY_AMORTIZATION_MAIN IAM
                            WHERE 
                                IA.INV_AMORT_MAIN_ID = IAM.INV_AMORT_MAIN_ID
                                AND IA.INVENTORY_ID IN(#inv_list#)
                                AND IAM.RECORD_DATE > #createodbcdatetime(get_detail.record_date)#
						</cfquery>
                    </div>
                </div>
            </div>
		</cf_box_elements>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_detail">
            </div>
            <div class="col col-6">
                <!--- Eğer ilgili değerleme işleminden sonra herhangi bir demirbaşa değerleme yapılmadıysa sil butonu gelir. --->
                <cfif get_amortization.recordcount eq 0>
                    <cf_workcube_buttons is_upd='1' is_delete="1" add_function='input_control()' delete_page_url='#request.self#?fuseaction=invent.emptypopup_del_invent_amortization&inv_main_id=#attributes.inv_id#&old_process_type=#get_Detail.process_type#'>
                </cfif>
            </div>
        </cf_box_footer>  
	</cf_box>
	</cfif>	
</cfform>	
<script type="text/javascript">
	function check_all(deger)
	{
		<cfif get_invent.recordcount>
			if(invent_rows.hepsi.checked)
			{
				for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
					var form_field = eval("document.invent_rows.invent_row" + i);
					form_field.checked = true;
					eval('invent_rows.invent_row'+i).focus();
				}
			}
			else
			{
				for (var i=1; i <= <cfoutput>#get_invent.recordcount#</cfoutput>; i++)
				{
					form_field = eval("document.invent_rows.invent_row" + i);
					form_field.checked = false;
					eval('invent_rows.invent_row'+i).focus();
				}				
			}
		</cfif>
	}
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
	function input_control()
	{
		if(!chk_process_cat('invent_rows')) return false;
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
		for(var t=1; t<=toplam; t++)
		{
			if(eval('invent_rows.invent_row'+t).checked)
			{
				if(eval("document.invent_rows.diff_value" + t).value == '')
				{
					alert("<cf_get_lang dictionary_id='56948.Amortisman Tutarı Giriniz'>!");
					return false;
				}
				if((eval("document.invent_rows.debt_acc" + t).value == '') || (eval("document.invent_rows.claim_acc" + t).value == ''))
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
</script>
