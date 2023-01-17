<cfsavecontent variable="message"><cf_get_lang dictionary_id='32855.Workcube Data Service'></cfsavecontent>
<cf_popup_box title="#message#">
	<cfform name="workcube_data" method="post" action="#request.self#?fuseaction=objects.emptypopup_workxml_data_service">
	<div class="row">
        <div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-wrk_data_service">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='33882.Data Servisi'></label>
            <div class="col col-8 col-xs-12">
				<select name="wrk_data_service" id="wrk_data_service" style="width:150px">
						<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						<cfquery name="GET_WORKXML" datasource="#DSN#">
							SELECT WORKXML_ID,WORKXML_NAME FROM WORKXML_SERVICE ORDER BY WORKXML_NAME
						</cfquery>
						<cfoutput query="GET_WORKXML">
							<option value="#WORKXML_ID#">#WORKXML_NAME#</option>
						</cfoutput>
					</select>
				</div>
			</div>
		<div class="form-group" id="item-wrk_data_type">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='33883.Servis Tipi'></label>
            <div class="col col-8 col-xs-12">
				<select name="wrk_data_type" id="wrk_data_type" style="width:150px">
						<option value="1"><cf_get_lang dictionary_id='57773.İrsaliye'></option>
						<option value="2"><cf_get_lang dictionary_id='57657.Ürün'></option>
					</select>
				</div>
			</div>
		<div class="form-group" id="item-paper_no">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58138.İrsaliye No'></label>
            <div class="col col-8 col-xs-12">
				<input type="text" name="paper_no" id="paper_no" value="" style="width:150px">
			</div>
		</div>	
		<div class="form-group" id="item-startdate">
            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
            <div class="col col-8 col-xs-12">
			<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58503.Tarih Giriniz'> !</cfsavecontent>
					<cfinput validate="#validate_style#" message="#message#" type="text" name="processdate" style="width:70px;" value="#dateformat(now(),dateformat_style)#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
				</div>
			</div>
		</div>
	</div>
</div>		
		<cf_popup_box_footer>
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='form_control()'>
		</cf_popup_box_footer>
	</cfform>
</cf_popup_box>
<script type="text/javascript">
function form_control()
{
	if(document.workcube_data.wrk_data_service.value=='')
	{
		alert("<cf_get_lang dictionary_id ='33884.Lütfen Workcube Data Servislerinden Birini Seçiniz'>!");
		return false
	}
	return true;
}
</script>
