<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_card" method="post" enctype="multipart/form-data" action="">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-first_card_no">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61701.?'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text" style="width:200px;" name="first_card_no" id="first_card_no" onkeyup="isNumber(this);" maxlength="16">
						</div>
					</div>
					<div class="form-group" id="item-last_card_no">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61702.?'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text"  style="width:200px;" name="last_card_no" id="last_card_no" onkeyup="isNumber(this);" maxlength="16">
						</div>
					</div>
					<div class="form-group" id="item-parameter">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='61703.?'></label>
						<div class="col col-8 col-sm-12">
							<cfinput type="text"  style="width:200px;" name="parameter" required="yes" message="Katsayı Giriniz" id="parameter" onkeyup="isNumber(this);" maxlength="16">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons type_format='1' is_upd='0' add_function="kontrol()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>


	
<script type="text/javascript">
	function kontrol()
	{
		my_first_card_no = document.getElementById('first_card_no').value;
		my_last_card_no = document.getElementById('last_card_no').value;
		if(my_first_card_no.length == 0 && my_last_card_no.length == 0)
		{
			alert('İlk ve Son Kart Numaralarını Giriniz!');
			return false;	
		}
		/*
		if( my_first_card_no == my_last_card_no)
		{
			alert('İlk ve Son Kart Numaraları Eşit Olamaz!');
			return false;	
		}
		*/
		/*if(my_first_card_no.length != my_last_card_no.length)
		{
			alert('İlk ve Son Kart Numaralarının Uzunlukları Eşit Olmalıdır!');
			return false;	
		}*/
		if(my_last_card_no < my_first_card_no)
		{
			alert('Son Kart Numarası İlk Kart Numarasından Büyük Olmalıdır!');
			return false;	
		}
		return true;
	}
</script>