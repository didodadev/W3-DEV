<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='42140.Paket Tipleri'></cfsavecontent>
	<cf_box title="#head#" add_href="#request.self#?fuseaction=settings.add_package_type" is_blank="0">
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
			<cfinclude template="../display/list_package_type.cfm">
    	</div>
    	<div class="col col-9 col-md-9 col-sm-9 col-xs-12">
			<cfform name="add_package_type" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_package_type" onsubmit="return (change_dimension());">
        		<cf_box_elements>
          			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
						<div class="form-group" id="package_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42468.Paket Tipi'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="text" name="package_type" id="package_type" value="" maxlength="20">						
							</div>	
						</div>
						<div class="form-group" id="calculate_type">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43003.Hesaplama Yöntemi'>*</label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<select name="calculate_type" id="calculate_type" style="width:130px;">
										<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<option value="1"><cf_get_lang dictionary_id='43004.Desi'></option>
										<option value="2"><cf_get_lang dictionary_id='43005.Kg'></option>
										<option value="3"><cf_get_lang dictionary_id='42540.Zarf'></option>
									</select>
								</div>
						</div>
						<div class="form-group" id="dimension">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42999.Boyut (a*b*h)'></label>
								<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="hidden" name="dimension" id="dimension">
										<input type="text" name="dimension1" id="dimension1" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">
									</div>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="text" name="dimension2" id="dimension2" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">
									</div>
									<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
										<input type="text" name="dimension3" id="dimension3" onkeyup="return(FormatCurrency(this,event,0));" maxlength="4" class="moneybox">	
									</div>
								</div>
						</div>
						<div class="form-group" id="weight">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='29784.Ağırlık'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="weight" passthrough = "onkeyup='FormatCurrency(this,event,3)'" class="moneybox">
							</div>	
						</div>
						<div class="form-group" id="detail">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<textarea name="detail" id="detail" value="" maxlength="50" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 50"></textarea>
							</div>	
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
				
    	</div>
  	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.add_package_type.package_type.value == "")
		{
			alert("<cf_get_lang dictionary_id='42006.Paket Tipi Girmelisiniz'>!");
			return false;
		}
		
		x = document.add_package_type.calculate_type.selectedIndex;
		if(document.add_package_type.calculate_type[x].value == "")
		{ 
			alert("<cf_get_lang dictionary_id='43357.Hesaplama Yöntemi Seçiniz'>!");
			return false;
		}
		
		if(document.add_package_type.calculate_type[x].value == 1)
		{
			if(document.add_package_type.dimension1.value =="" || document.add_package_type.dimension1.value ==0)
			{
				alert ("<cf_get_lang dictionary_id='43000.Boyut Değerlerinizi Kontrol Ediniz'>!");
				add_package_type.dimension1.focus();
				return false;
			}
			
			if(document.add_package_type.dimension2.value =="" || document.add_package_type.dimension2.value ==0)
			{
				alert ("<cf_get_lang dictionary_id='43000.Boyut Değerlerinizi Kontrol Ediniz'>! ");
				add_package_type.dimension2.focus();
				return false;
			}
			
			if(document.add_package_type.dimension3.value =="" || document.add_package_type.dimension3.value ==0)
			{
				alert ("<cf_get_lang no ='1017.Boyut Değerlerinizi Kontrol Ediniz '> ! ");
				add_package_type.dimension3.focus();
				return false;
			}		
		}
		$('#weight').val(filterNum($('#weight').val()));
		
		return true;
	}
	function change_dimension()
	{
		y = document.add_package_type.calculate_type.selectedIndex;
		if(document.add_package_type.calculate_type[x].value == 1)
			document.add_package_type.dimension.value = filterNum(document.add_package_type.dimension1.value) + '*' + filterNum(document.add_package_type.dimension2.value) + '*' + filterNum(document.add_package_type.dimension3.value);
		else
			document.add_package_type.dimension.value = '';
	}
	</script>
	
