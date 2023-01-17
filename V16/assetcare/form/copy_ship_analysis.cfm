<cfinclude template="../query/get_money.cfm">
<cfquery name="GET_SHIP_ANALYSIS" datasource="#DSN#">
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
		BRANCH.BRANCH_NAME
	 FROM
	 	ASSET_P_SHIP_ANALYSIS,
		BRANCH
	WHERE
		ASSET_P_SHIP_ANALYSIS.SHIP_ID = #attributes.ship_id# AND
		BRANCH.BRANCH_ID = ASSET_P_SHIP_ANALYSIS.BRANCH_ID
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Sevkiyat Analizi Kopyala','47941')#">
		<cfform name="copy_ship_analysis" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_ship_analysis" onSubmit="return(unformat_fields());">
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
								<cfinput type="text" name="branch" value="#get_ship_analysis.branch_name#" readonly>
								<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=copy_ship_analysis.branch_id&field_branch_name=copy_ship_analysis.branch','list');"></span>
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
							<input type="text" name="ship_area" id="ship_area" value="<cfoutput>#get_ship_analysis.ship_area#</cfoutput>"  maxlength="50" >
						</div>
					</div>
					<div class="form-group" id="special_code">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="special_code" id="special_code" value="<cfoutput>#get_ship_analysis.special_code#</cfoutput>" maxlength="50">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="distance">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48211.Rut Uzunluğu'>*</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="distance" id="distance" value="<cfoutput>#(get_ship_analysis.distance)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));" >
						</div>
					</div>
					<div class="form-group" id="tour_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48196.Günlük Sevk Sayısı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="tour_number" id="tour_number" value="<cfoutput>#(get_ship_analysis.tour_number)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));">
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
							<input type="text" name="days" id="days" value="<cfoutput>#(get_ship_analysis.days)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="endorsement">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30010.Ciro'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="endorsement" id="endorsement" value="<cfoutput>#(get_ship_analysis.endorsement)#</cfoutput>" onKeyUp="return(FormatCurrency(this,event));" class="moneybox">
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
				<cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' is_reset='0' add_function='kontrol()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function unformat_fields()
{
	copy_ship_analysis.ship_num.value = filterNum(copy_ship_analysis.ship_num.value);/*Bölge No*/
	copy_ship_analysis.distance.value = filterNum(copy_ship_analysis.distance.value);/*//rut uzunluğu*/
	copy_ship_analysis.tour_number.value = filterNum(copy_ship_analysis.tour_number.value);/*Sevk Sayısı*/
	copy_ship_analysis.store_quantity.value = filterNum(copy_ship_analysis.store_quantity.value);/*Eczane Sayısı*/
	copy_ship_analysis.days.value = filterNum(copy_ship_analysis.days.value);/*Gün Sayısı*/	
	copy_ship_analysis.endorsement.value = filterNum(copy_ship_analysis.endorsement.value);/*Ciro*/	
}
function kontrol()
{
	x = document.copy_ship_analysis.months.selectedIndex;	
	if(document.copy_ship_analysis.months[x].value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1312.Ay'>!");
		return false;
	}
	
	y = document.copy_ship_analysis.years.selectedIndex;
	if(document.copy_ship_analysis.years[y].value =="")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1043.Yıl'>!");
		return false;
	}
		
	if(document.copy_ship_analysis.branch_id.value == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1735.Şube Adı'> !");
		return false;
	}
	
	if(trim(document.copy_ship_analysis.ship_num.value) == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='385.Bölge No'>!");
		return false;
	}
	
	if(trim(document.copy_ship_analysis.ship_area.value) == "")
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='320.Sevk Bölgesi'>!");
		return false;
	}
	
	temp_distance = filterNum(copy_ship_analysis.distance.value);
	if(document.copy_ship_analysis.distance.value == "" || temp_distance<=0)
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='340.Rut Uzunluğu'>!");
		return false;
	}
	
	temp_tour_number = filterNum(copy_ship_analysis.tour_number.value);
	if(document.copy_ship_analysis.tour_number.value == "" || temp_tour_number<=0)
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='325.Günlük Sevk Sayısı'> !");
		return false;
	}
	
	temp_store_quantity = filterNum(copy_ship_analysis.store_quantity.value);
	if(document.copy_ship_analysis.store_quantity.value == "" || temp_store_quantity<=0)
	{
		alert("Eczane Sayısı Giriniz !");
		return false;
	}	

	temp_days = filterNum(copy_ship_analysis.days.value);
	if(document.copy_ship_analysis.days.value == "" || temp_days<=0)
	{
		alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no='317.Gün Sayısı'>!");
		return false;
	}

	temp_endorsement = filterNum(copy_ship_analysis.endorsement.value);
	if(document.copy_ship_analysis.endorsement.value == "" || temp_endorsement<=0)
	{
		alert("Ciro Tutarını Giriniz !");
		return false;
	}	

	return true;
}
</script>
