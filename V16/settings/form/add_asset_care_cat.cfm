<cfquery name="GET_ASSET_CARECAT" datasource="#DSN#">
	SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>


<cf_box title="#getlang('','Bakım Tipleri','42046')#">
  <cfform name="add_asset_care_cat" method="post" action="">
  <cf_box_elements>
        <div class="col col-3 col-md-3 col-sm-3 col-xs-12" index="1" type="column" sort="true">
       <cfinclude template="../display/list_asset_care_cat.cfm">
        </div>
         <div class="col col-9 col-md-9 col-sm-9 col-xs-12" index="2" type="column" sort="true">
             <div class="col col-6 col-md-6 col-sm-6 col-xs-8">
<!---     Kategori Adı          --->
                <div class="form-group" id="item-assetp_cat_name">
                 <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42003.Kategori Adı'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                         <input type="hidden" name="assetp_cat_" id="assetp_cat_" value="<cfif isdefined("attributes.assetp_cat_") and len(assetp_cat_)><cfoutput>#attributes.assetp_cat_#</cfoutput></cfif>">
                    <select name="assetp_cat" id="assetp_cat" style="width:150px;" onChange="sec();">
						<cfoutput query="get_asset_carecat">
                        <option value="#assetp_catid#" <cfif isdefined("attributes.assetp_cat_") and len(attributes.assetp_cat_) and attributes.assetp_cat_ eq assetp_catid>selected</cfif>>#assetp_cat#</option>
                         </cfoutput>                        
                    </select>
                    </div>
                </div>
<!---    Bakım Tipleri        --->
 <cfif isdefined("attributes.assetp_cat_") and len(attributes.assetp_cat_)>
                                    <cfquery name="CARE_CATS_" datasource="#dsn#">
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
                                        	ASSETP_CAT = <cfqueryparam cfsqltype="cf_sql_integer"  value="#attributes.assetp_cat#">
                                            
                                    </cfquery>	                   
                    </cfif>        

            <div class="form-group" id="item-asset_care">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='42046.Kategorinin Bakım Tipleri'></label>
                 <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='48429.Bakım Tipi Girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="asset_care" maxlength="50" required="yes" message="#message#" style="width:150px;">
                </div>
  
            </div>


<!--- Açıklama --->
    <div class="form-group" id="item-description">
            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='36199.Açıklama'></label>
            <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                        <textarea name="detail" id="detail" style="width:150px;height:60px;" maxlength="100" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : 100"></textarea>
           
            </div>
        </div>
<!---Yasal Bakım Checkbox  --->
            <div class="form-group" id="item-checkbox">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43161.Yasal Bakım'></label>
                 <div class="col col-8 col-md-8 col-sm-8 col-xs-12"> 
                        <cfinput type="checkbox" name="is_yasal" value="">
                </div>
            </div>
 </div>
<!---Kategori adına göre Bakım tipleri    --->
        <div class="col col-6 col-md-6 col-sm-6 col-xs-4">
            <label class="col col-6 col-md-6 col-sm-6 col-xs-12">   
                <cfif isdefined("attributes.assetp_cat_") and len(attributes.assetp_cat_)>
                        <cfoutput query="CARE_CATS_">
                        <div class="container mt-3">
                                        <ul class="list-group list-group-flush " style="list-style-type: none" >
                                             <li class="list-group-item">#asset_care#</li>
                                        </ul>
                                        </div>
                         </cfoutput> 
                </cfif>
            </label>
        </div>

    </div>


    </cf_box_elements>
<!---   Form Button   --->
    <cf_box_footer>
    <cf_workcube_buttons is_upd='0' add_function='submit_et()'>
    </cf_box_footer>
<!--- DB'ye giden parametreler: assetp_cat_, asset_care, detail,is_yasal, --->
     </cfform>
</cf_box>

<!--- Functions  --->
<script type="text/javascript">
function sec()
{
	add_asset_care_cat.assetp_cat_.value = add_asset_care_cat.assetp_cat.options[add_asset_care_cat.assetp_cat.options.selectedIndex].value;
	add_asset_care_cat.action = '<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>';
	add_asset_care_cat.submit();		
}
function submit_et()
{
	add_asset_care_cat.action = '<cfoutput>#request.self#?fuseaction=settings.emptypopup_add_asset_care_cat</cfoutput>';
}
</script>
