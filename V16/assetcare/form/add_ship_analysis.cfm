<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.months" default="">
<cfparam name="attributes.years" default="">
<cfinclude template="../query/get_money.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('assetcare',324)#">
		<cfform name="add_ship_analysis" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_add_ship_analysis" onSubmit="return(unformat_fields());">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="months">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58724.Ay'> / <cf_get_lang dictionary_id='58455.Yıl'> *</label>
						<div class="col col-4 col-xs-8">									
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
							<cfset ay_listesi = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">	 
							<select name="months" id="months">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput>
									<cfloop index="i" from="1" to="#ListLen(ay_listesi)#">
										<option value="#i#" <cfif attributes.months eq i>selected</cfif>>#ListGetAt(ay_listesi,i)#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
						<div class="col col-4 col-xs-4">
							<select name="years" id="years">
								<option value=""></option>
								<cfoutput>
									<cfloop index="i" from="#dateFormat(now(),"yyyy")#" to="2000" step="-1">
										<option value="#i#">#i#</option>
									</cfloop>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="branch_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="branch_id" id="branch_id" value="">
								<input type="text" name="branch" id="branch" readonly>
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_id=add_ship_analysis.branch_id&field_branch_name=add_ship_analysis.branch');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="ship_num">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48256.Bölge No'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="ship_num" id="ship_num" onKeyup="return(FormatCurrency(this,event,0));">
						</div>
					</div>
					<div class="form-group" id="ship_area">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48191.Sevk Bölgesi'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="ship_area" id="ship_area" maxlength="50">
						</div>
					</div>
					<div class="form-group" id="special_code">
						<label class=" col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="special_code" id="special_code" maxlength="50">
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="distance">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48211.Rut Uzunluğu'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="distance" id="distance" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="tour_number">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48196.Günlük Sevk Sayısı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="tour_number" id="tour_number" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="store_quantity">
						<label class="col col-4 col-sx-12"><cf_get_lang dictionary_id='37168.Müşteri Sayısı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="store_quantity" id="store_quantity" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="days">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48188.Gün Sayısı'> *</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="days" id="days" onKeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="endorsement">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30010.Ciro'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="endorsement" id="endorsement" onKeyUp="FormatCurrency(this,event);" class="moneybox">
								<span class="input-group-addon width">
									<select name="currency" id="currency">
										<cfoutput query="get_money">
											<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
										</cfoutput>
									</select>
								</span>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer><cf_workcube_buttons type_format='1' is_upd='0' is_cancel='0' is_reset='1' add_function='kontrol()'></cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>

<script type="text/javascript">
function unformat_fields()
{
	add_ship_analysis.ship_num.value = filterNum(add_ship_analysis.ship_num.value);//Bölge No
	add_ship_analysis.distance.value = filterNum(add_ship_analysis.distance.value);//rut uzunluğu
	add_ship_analysis.tour_number.value = filterNum(add_ship_analysis.tour_number.value);//Sevk Sayısı
	add_ship_analysis.store_quantity.value = filterNum(add_ship_analysis.store_quantity.value);//Eczane Sayısı
	add_ship_analysis.days.value = filterNum(add_ship_analysis.days.value);//Gün Sayısı
	add_ship_analysis.endorsement.value = filterNum(add_ship_analysis.endorsement.value);//Ciro
}
function kontrol()
{
	x = document.add_ship_analysis.months.selectedIndex;	
	if(document.add_ship_analysis.months[x].value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58724.Ay'>!");
		return false;
	}
	
	y = document.add_ship_analysis.years.selectedIndex;
	if(document.add_ship_analysis.years[y].value =="")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='58455.Yıl'>!");
		return false;
	}
		
	if(document.add_ship_analysis.branch_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'> !");
		return false;
	}
	
	if(trim(document.add_ship_analysis.ship_num.value) == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48256.Bölge No'>!");
		return false;
	}
	
	if(trim(document.add_ship_analysis.ship_area.value) == "")
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48191.Sevk Bölgesi'>!");
		return false;
	}
	
	temp_distance = filterNum(add_ship_analysis.distance.value);
	if(document.add_ship_analysis.distance.value == "" || temp_distance<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48211.Rut Uzunluğu'>!");
		return false;
	}
	
	temp_tour_number = filterNum(add_ship_analysis.tour_number.value);
	if(document.add_ship_analysis.tour_number.value == "" || temp_tour_number<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='48196.Günlük Sevk Sayısı'>  !");
		return false;
	}	
	
	temp_store_quantity = filterNum(add_ship_analysis.store_quantity.value);
	if(document.add_ship_analysis.store_quantity.value == "" || temp_store_quantity<=0)
	{
		alert("<cf_get_lang dictionary_id='37168.Müşteri Sayısı'><cf_get_lang dictionary_id='57613.Girmelisiniz'>");
		return false;
	}	
	
	temp_days = filterNum(add_ship_analysis.days.value);
	if(document.add_ship_analysis.days.value == "" || temp_days<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang no='317.Gün Sayısı'> !");
		return false;
	}
	
	temp_endorsement = filterNum(add_ship_analysis.endorsement.value);
	if(document.add_ship_analysis.endorsement.value == "" || temp_endorsement<=0)
	{
		alert("<cf_get_lang dictionary_id='58194.zorunlu alan'>:<cf_get_lang dictionary_id='30010.Ciro'>!");
		return false;
	}	
	unformat_fields();
	return true;
}
</script>
