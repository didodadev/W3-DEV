<cfquery name="GET_ASSET_CARE_CAT" datasource="#DSN#" maxrows="1">
	SELECT
		CARE_STATES.ASSET_ID,
		ASSET_CARE_REPORT.ASSET_ID
	FROM
		CARE_STATES,
		ASSET_CARE_REPORT
	WHERE
		CARE_STATES.CARE_STATE_ID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.asset_care_id#"> AND
		ASSET_CARE_REPORT.CARE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.asset_care_id#">
		
</cfquery>

<cfquery name="GET_ASSET_CARECAT" datasource="#DSN#">
	SELECT ASSETP_CATID, ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>

<cf_box title="#getlang('','Bakım Tipleri','42046')#" add_href="#request.self#?fuseaction=settings.add_asset_care_cat" is_blank="0">
<cfform name="upd_asset_care_cat" method="post" action="">
 <cf_box_elements>
<!--- Bakım Kategorileri --->
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12" index="1" type="column" sort="true">
       		<cfinclude template="../display/list_asset_care_cat.cfm">
        </div>
		<div class="col col-9 col-md-9 col-sm-9 col-xs-12" index="2" type="column" sort="true">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-8">
        		<cfquery name="get_asset_care_cat" datasource="#dsn#">
						SELECT 
							ASSET_CARE_ID, 
							ASSET_CARE, 
							ASSETP_CAT, 
							DETAIL, 
							IS_YASAL, 
							RECORD_DATE, 
							RECORD_EMP, 
							RECORD_IP, 
							UPDATE_DATE, 
							UPDATE_EMP, 
							UPDATE_IP 
						FROM 
							ASSET_CARE_CAT 
						WHERE 
							ASSET_CARE_ID=<cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.asset_care_id#">
				</cfquery>
			

<!---     Kategori Adı          --->
                <div class="form-group" id="item-upd_assetp_cat_name">
                 <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
						<input type="hidden" name="asset_care_id" id="asset_care_id" value="<cfoutput>#attributes.asset_care_id#</cfoutput>">				
						<input type="hidden" name="assetp_cat_" id="assetp_cat_" value="<cfif isdefined("attributes.assetp_cat_") and len(assetp_cat_)><cfoutput>#attributes.assetp_cat_#</cfoutput></cfif>">
						
						<select name="assetp_cat" id="assetp_cat" style="width:150px;">
							<cfoutput query="get_asset_carecat">
								<option value="#assetp_catid#" <cfif len(get_asset_care_cat.assetp_cat) and (get_asset_care_cat.assetp_cat eq assetp_catid)>selected</cfif>>#assetp_cat#</option>
							</cfoutput>
						</select>
							<cfif isdefined("attributes.assetp_cat_") and len(assetp_cat_)>
								<cfquery name="CARE_CATS_" datasource="#dsn#">
									SELECT * FROM ASSET_CARE_CAT WHERE ASSETP_CAT = #attributes.assetp_cat#	
								</cfquery>	
								<cfoutput query="CARE_CATS_">
								<tr>
									<td>#care_cats_.asset_care# </td>
								</tr>
								</cfoutput>					
							</cfif>
                    </div>
                </div>
<!---    Bakım Tipleri        --->
            <div class="form-group" id="item-upd_asset_care">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42046.Kategorinin Bakım Tipleri'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='48429.Bakım Tipi Girmelisiniz'></cfsavecontent>
<!---                         <cfinput type="text" name="asset_care" maxlength="50" required="yes" message="#message#" style="width:150px;"> --->
						<div class="input-group">
                            <cfinput type="text" name="asset_care" style="width:150px; margin-right:5px;" value="#get_asset_care_cat.asset_care#" maxlength="50" required="yes" message="#message#">

                            <span class="input-group-addon">
							<cf_language_info	
									table_name="ASSET_CARE_CAT"
									column_name="ASSET_CARE" 
									column_id_value="#attributes.asset_care_id#" 
									maxlength="500" 
									datasource="#dsn#" 
									column_id="ASSET_CARE_ID" 
									control_type="0">
							</span>
                        </div>
								
						
                </div>
			</div>

<!--- Açıklama --->
			<div class="form-group" id="item-description">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
						<textarea name="detail" id="detail" style="width:150px;height:60px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"><cfoutput>#get_asset_care_cat.detail#</cfoutput></textarea>
					</div>
			</div>
<!---Yasal Bakım Checkbox  --->
            <div class="form-group" id="item-checkbox">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43161.Yasal Bakım'></label>
                 <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                    <input type="checkbox" name="is_yasal" id="is_yasal" value="<cfoutput>#get_asset_care_cat.is_yasal#</cfoutput>" <cfif get_asset_care_cat.is_yasal eq 1>checked</cfif>>
                </div>
            </div>

			</div>
		</div>
 	</cf_box_elements>
 	<cf_box_footer>
	 <!---Kayıt ve Son Güncelleme --->
 	<cf_record_info query_name='get_asset_care_cat'>
			 <!---   Form Button   --->
	<div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
    
    		<cfif get_asset_care_cat.recordcount>
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='submit_et()'>                   
			<cfelse>
				<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_asset_care_cat&asset_care_id=#attributes.asset_care_id#'  add_function='submit_et()'>
			</cfif>
	</div>
    </cf_box_footer>
</cfform>

</cf_box>

<script type="text/javascript">
function submit_et()
{
	upd_asset_care_cat.action = '<cfoutput>#request.self#?fuseaction=settings.emptypopup_upd_asset_care_cat&id=#attributes.asset_care_id#</cfoutput>';
}
</script>
