<cfinclude template="../query/get_money.cfm">
<cfquery name="get_ship_analysis" datasource="#dsn#">
	SELECT
		ASSET_P_SHIP_ANALYSIS.SHIP_ID,
		ASSET_P_SHIP_ANALYSIS.SHIP_DATE,
		ASSET_P_SHIP_ANALYSIS.BRANCH_ID,
		ASSET_P_SHIP_ANALYSIS.SPECIAL_CODE,
		ASSET_P_SHIP_ANALYSIS.DAYS,
		ASSET_P_SHIP_ANALYSIS.SHIP_NUM,
		ASSET_P_SHIP_ANALYSIS.SHIP_AREA,
		ASSET_P_SHIP_ANALYSIS.DISTANCE,
		ASSET_P_SHIP_ANALYSIS.STORE_QUANTITY,
		ASSET_P_SHIP_ANALYSIS.TOUR_NUMBER,
		ASSET_P_SHIP_ANALYSIS.ENDORSEMENT,
		ASSET_P_SHIP_ANALYSIS.CURRENCY,
		ASSET_P_SHIP_ANALYSIS.RECORD_EMP,
		ASSET_P_SHIP_ANALYSIS.RECORD_DATE,
		ASSET_P_SHIP_ANALYSIS.UPDATE_EMP,
		ASSET_P_SHIP_ANALYSIS.UPDATE_DATE,
		BRANCH.BRANCH_NAME
	FROM
		ASSET_P_SHIP_ANALYSIS,
		BRANCH
	WHERE
		ASSET_P_SHIP_ANALYSIS.SHIP_ID = #attributes.ship_id# AND
		BRANCH.BRANCH_ID = ASSET_P_SHIP_ANALYSIS.BRANCH_ID
</cfquery>
<!--- <cfsavecontent variable="right">
	<a href="<cfoutput>#request.self#?fuseaction=assetcare.popup_copy_ship_analysis&ship_id=#attributes.ship_id#</cfoutput>"><img src="/images/plus.gif"  border="0" alt="<cf_get_lang no='70.Analiz Kopyala'>" title="<cf_get_lang no='70.Analiz Kopyala'>"></a>
    <a href="<cfoutput>#request.self#?fuseaction=assetcare.popup_add_ship_analysis</cfoutput>"><img src="/images/plus1.gif"  border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a>
</cfsavecontent> --->
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Sevkiyat Analizi Güncelle','48194')#" add_href="#request.self#?fuseaction=assetcare.popup_add_ship_analysis&event=add" copyrow_href="#request.self#?fuseaction=assetcare.popup_copy_ship_analysis&ship_id=#attributes.ship_id#" copyrow_title="#getLang('','Sevkiyat Analizi Kopyala','47941')#" >
		<cfform name="upd_ship_analysis" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_ship_analysis" onSubmit="return(unformat_fields());">
			<input type="hidden" name="ship_id" id="ship_id" value="<cfoutput>#attributes.ship_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="months">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'> / <cf_get_lang dictionary_id='58455.Yıl'> *</label>
						<div class="col col-4 col-xs-8">
							<cfset months = dateFormat(get_ship_analysis.ship_date,'mm')>
							<select name="months" id="months">
								<option value=""></option>
								<cfloop index="i" from="1" to="12">
									<cfoutput><option value="#i#" <cfif i eq months>selected</cfif>>#numberFormat(i,00)#</option></cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-4">
							<cfset years = dateFormat(get_ship_analysis.ship_date,'yyyy')>
							<select name="years" id="years">
								<option value=""></option>
								<cfloop index="i" from="#dateFormat(now(),"yyyy")#" to="2000" step="-1">
									<cfoutput><option value="#i#" <cfif i eq years>selected</cfif>>#i#</option></cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="form-group" id="branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#get_ship_analysis.branch_id#</cfoutput>">
								<input type="text" name="branch" id="branch" value="<cfoutput>#get_ship_analysis.branch_name#</cfoutput>" readonly>
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=upd_ship_analysis.branch_id&field_branch_name=upd_ship_analysis.branch');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="ship_num">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48256.Bölge No'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="ship_num" id="ship_num" value="<cfoutput>#get_ship_analysis.ship_num#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));">
						</div>
					</div>
					<div class="form-group" id="ship_area">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48191.Sevk Bölgesi'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="ship_area" id="ship_area" value="<cfoutput>#get_ship_analysis.ship_area#</cfoutput>"  maxlength="50">
						</div>
					</div>
					<div class="form-group" id="special_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="special_code" id="special_code" value="<cfoutput>#get_ship_analysis.special_code#</cfoutput>" maxlength="50" onKeyUp="return(FormatCurrency(this,event,0));">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="distance">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48211.Rut Uzunluğu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="distance" id="distance" value="<cfoutput>#(get_ship_analysis.distance)#</cfoutput>" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="tour_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48196.Günlük Sevk Sayısı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="tour_number" id="tour_number" value="<cfoutput>#(get_ship_analysis.tour_number)#</cfoutput>"  onKeyUp="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="store_quantity">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='37168.Müşteri Sayısı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="store_quantity" id="store_quantity" value="<cfoutput>#(get_ship_analysis.store_quantity)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="days">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48188.Gün Sayısı'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="days" id="days" value="<cfoutput>#(get_ship_analysis.days)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));" >
						</div>
					</div>
					<div class="form-group" id="endorsement">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30010.Ciro'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="endorsement" id="endorsement" onKeyUp="FormatCurrency(this,event);" value="<cfoutput>#tlFormat(get_ship_analysis.endorsement)#</cfoutput>" class="moneybox">
								<span class="input-group-addon width">
									<select name="currency" id="currency">
										<cfoutput query="get_money">
											<option value="#money#" <cfif money eq get_ship_analysis.currency>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_ship_analysis">
				<cf_workcube_buttons type_format="1" is_upd='1' is_delete='1' is_cancel='0' is_reset='0' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_ship_analysis&ship_id=#attributes.ship_id#&head=#get_ship_analysis.ship_num#' add_function='kontrol()'></td>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function unformat_fields()
{
	upd_ship_analysis.ship_num.value = filterNum(upd_ship_analysis.ship_num.value);//Bölge No
	upd_ship_analysis.distance.value = filterNum(upd_ship_analysis.distance.value);//rut uzunluğu
	upd_ship_analysis.tour_number.value = filterNum(upd_ship_analysis.tour_number.value);//Sevk Sayısı
	upd_ship_analysis.store_quantity.value = filterNum(upd_ship_analysis.store_quantity.value);//Eczane Sayısı
	upd_ship_analysis.days.value = filterNum(upd_ship_analysis.days.value);//Gün Sayısı	
	upd_ship_analysis.endorsement.value = filterNum(upd_ship_analysis.endorsement.value);//Ciro
}
function kontrol()
{
	// x = document.upd_ship_analysis.months.selectedIndex;	
	// if(document.upd_ship_analysis.months[x].value == "")
	// {
	// 	alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58724.Ay'>!");
	// 	return false;
	// }
	
	y = document.upd_ship_analysis.years.selectedIndex;
	if(document.upd_ship_analysis.years[y].value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58455.Yıl'>!");
		return false;
	}
		
	if(document.upd_ship_analysis.branch_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'> !");
		return false;
	}
	
	if(trim(document.upd_ship_analysis.ship_num.value) == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48256.Bölge No'>!");
		return false;
	}
	
	if(trim(document.upd_ship_analysis.ship_area.value) == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48191.Sevk Bölgesi'>!");
		return false;
	}
	
	temp_distance = filterNum(upd_ship_analysis.distance.value);
	if(document.upd_ship_analysis.distance.value == "" || temp_distance<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48211.Rut Uzunluğu'>!");
		return false;
	}
	
	temp_tour_number = filterNum(upd_ship_analysis.tour_number.value);
	if(document.upd_ship_analysis.tour_number.value == "" || temp_tour_number<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48196.Günlük Sevk Sayısı'>  !");
		return false;
	}
	
	temp_store_quantity = filterNum(upd_ship_analysis.store_quantity.value);
	if(document.upd_ship_analysis.store_quantity.value == "" || temp_store_quantity<=0)
	{
		alert("<cf_get_lang dictionary_id='37168.Müşteri Sayısı'><cf_get_lang dictionary_id='57613.Girmelisiniz'> !");
		return false;
	}	
	
	temp_days = filterNum(upd_ship_analysis.days.value);
	if(document.upd_ship_analysis.days.value == "" || temp_days<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48188.Gün Sayısı'> !");
		return false;
	}
	
	temp_endorsement = filterNum(upd_ship_analysis.endorsement.value);
	if(document.upd_ship_analysis.endorsement.value == "" || temp_endorsement<=0)
	{
		alert("<cf_get_lang dictionary_id='48553.Ciro Tutarını Giriniz'> !");
		return false;
	}	
	unformat_fields();
	return true;
}
</script>
