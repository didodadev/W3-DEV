<!---Select İfadeleri Düzenlendi.e.a 24082012--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.camp_id" default="">
<cfparam name="attributes.date1" default="">
<cfparam name="attributes.date2" default="">
<cfquery name="get_sticker" datasource="#dsn#">
	SELECT
    	STICKER_ID,
        STICKER_NAME
       -- ROW_NUMBER
       -- COLUMN_NUMBER
       --HORIZONTAL_GAP
       --VERTICAL_GAP
       --STICKER_WIDTH
       --STICKER_LENGTH
       --RECORD_EMP
       -- RECORD_IP
       -- RECORD_DATE
       -- UPDATE_EMP
       --UPDATE_IP
       --UPDATE_DATE
       --IS_DEFAULT
       --PAGE_WIDTH
       -- PAGE_HEIGHT
       --PAGE_TOP_BLANK
       --PAGE_FOT_BLANK
       --PAGE_RIGHT_BLANK
       --PAGE_LEFT_BLANK
       --PARTNER
     FROM 
     	SETUP_STICKER
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('campaign',111)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="form1" method="post" action="#request.self#?fuseaction=campaign.emptypopup_camp_list_label_info">
			<cf_box_search>
				<input type="hidden" name="submitted" id="submitted" value="">
				<cfoutput>
					<cfif isDefined("attributes.tmarket_id") and Len(attributes.tmarket_id)>
						<input type="hidden" name="tmarket_id" id="tmarket_id" value="#attributes.tmarket_id#">
					</cfif>
					<cfif isDefined("attributes.camp_id") and Len(attributes.camp_id)>
						<input type="hidden" name="camp_id" id="camp_id" value="#attributes.camp_id#">
						<input type="hidden" name="date1" id="date1" value="#dateformat(attributes.date1,dateformat_style)#">
						<input type="hidden" name="date2" id="date2" value="#dateformat(attributes.date2,dateformat_style)#">
					</cfif>
				</cfoutput>
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('','Filtre',57460)#">
				</div>
				<div class="form-group">
					<select name="address_type" id="address_type">
						<option value="2" <cfif isDefined("attributes.address_type") and attributes.address_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='49602.Üye Detay Adresi'></option>
						<option value="1" <cfif isDefined("attributes.address_type") and attributes.address_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='49601.Şirket Adresi'></option>
					</select>
				</div>
				<div class="form-group">
					<select name="sticker" id="sticker">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfoutput query="get_sticker">
							<option value="#sticker_id#" <cfif isDefined("attributes.sticker") and attributes.sticker eq sticker_id>selected</cfif>>#sticker_name#</option>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function='kontrol()'>
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById("sticker").value == '')
		{ 
			alert ("<cf_get_lang dictionary_id='54705.Etiket Seçiniz'>!");
			return false;
		}
		return true;
	}
</script>

