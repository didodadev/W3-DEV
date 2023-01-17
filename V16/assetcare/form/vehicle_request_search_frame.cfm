<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT WHERE MOTORIZED_VEHICLE = 1 ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="GET_STAGES" datasource="#DSN#">
	SELECT 
		PTR.PROCESS_ROW_ID,
		PTR.STAGE
	FROM
		PROCESS_TYPE PT,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE_ROWS PTR
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.add_vehicle_purchase_request%">
</cfquery>
<cfparam name="attributes.maxrows" default="#session.ep.maxrows#">
<cf_box>
	<cfform name="search_request" method="post">
		<cf_box_search more="0">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='48041.Kullanıcı Şube'></cfsavecontent>
					<input type="hidden" name="branch_id" id="branch_id" value="">
					<cfinput type="Text" name="branch" value="" placeholder="#place#" readonly>
					<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_branches&field_branch_name=search_request.branch&field_branch_id=search_request.branch_id');"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
					<cfinput type="text" name="start_date" maxlength="10" validate="#validate_style#" message="#message#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
				</div>
			</div>
			<div class="form-group">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57742.Tarih'>!</cfsavecontent>
					<cfinput type="text" name="finish_date" maxlength="10" validate="#validate_style#" message="#message#">
					<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
				</div>
			</div>
			<div class="form-group">
				<select name="request_type_id" id="request_type_id">
					<option value=""><cf_get_lang dictionary_id='47972.Talep Tipi'></option>
					<option value="1"><cf_get_lang dictionary_id='58176.Alış Talebi'></option>
					<option value="0"><cf_get_lang dictionary_id='57448.Satış Talebi'></option>
					<option value="2"><cf_get_lang dictionary_id='29418.İade Talebi'></option>
					<option value="3"><cf_get_lang dictionary_id='48011.Değiştirme Talebi'></option>
				</select>
			</div>
			<div class="form-group">
				<select name="status" id="status">
					<option value=""><cf_get_lang dictionary_id='58859.Süreç Aşama'></option>
					<cfoutput query="get_stages">
						<option value="#process_row_id#">#stage#</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group small">
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
			</div>
			<div class="form-group">
				<cf_wrk_search_button search_function='kontrol()' button_type="4">
			</div>
		</cf_box_search>
	</cfform>
</cf_box>
<script type="text/javascript">
function kontrol()
{
	if(document.search_request.maxrows.value>200)
	{
		alert("<cf_get_lang dictionary_id='57537.kayıt sayısı hatalı'>");
		return false;
	}	

	if ((document.search_request.start_date.value.length>0) && (document.search_request.finish_date.value.length>0) && (!date_check(document.search_request.start_date,document.search_request.finish_date,"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!")) )
	{
		return false;
	}
	return true;
}
</script>
