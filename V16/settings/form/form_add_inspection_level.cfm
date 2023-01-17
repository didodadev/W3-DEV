<cf_box title="#getlang('','Muayene Seviyeleri','61278')#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- #lang_array.item[59]# --->	<!--- #lang_array.item[59]# --->
	<cfform name="add_inspection_level" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_inspection_level">
		<cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group" id="item-active">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
				<div class="col col-8 col-xs-12">
					<input type="checkbox" name="is_active" id="is_active" value="1" checked>
				</div>
			</div>
			<div class="form-group" id="item-level_code">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58585.Kod'>*</label>
				<div class="col col-8 col-xs-12">
					<cfinput type="text" name="inspection_level_code" id="inspection_level_code">
				</div>
			</div>
			<div class="form-group" id="item-level_name">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57631.Ad'>*</label>
				<div class="col col-8 col-xs-12">
					<cfinput type="text" name="inspection_level_name" id="inspection_level_name" value="" style="width:250px;">
				</div>
			</div>
			<div class="form-group" id="item-detail">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-xs-12">
					<textarea name="description" id="description" style="width:250px;height:75px;"></textarea>
				</div>
			</div>
			<div class="form-group" id="item-is_default">
				<label class="col col-4 col-xs-12"></label>
				<div class="col col-8 col-xs-12">
					<input type="checkbox" name="is_default" id="is_default" value="1"><cf_get_lang no='1132.Standart Seçenek Olarak Gelsin'>
				</div>
			</div>
		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_workcube_buttons is_upd='0' type_format="1" add_function='control()'>
	</cf_box_footer>
	</cfform>
</cf_box>
<script language="javascript">
	function control()
	{
		if(document.getElementById("inspection_level_code").value == "")
		{
			alert("Kod alanı boş geçilemez!");
			return false;
		}
		if(document.getElementById("inspection_level_name").value == "")
		{
			alert("Ad alanı boş geçilemez!");
			return false;
		}
		return true;
	}
</script>
