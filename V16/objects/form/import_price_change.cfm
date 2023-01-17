
<cfsavecontent variable="title"><cf_get_lang dictionary_id='58725.Fiyat Değişim Import'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#title#">
        <cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.emptypopupflush_import_price_change" enctype="multipart/form-data">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-target_pos">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58594.Format'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="target_pos" id="target_pos" style="width:200px;">
                                <option value="-4"><cf_get_lang dictionary_id='58783.Workcube'></option>					  
                            </select>
                        </div> 
                    </div>
                    <div class="form-group" id="item-file_format">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="file_format" id="file_format" style="width:200px;">
                                <!--- <option value="ISO-8859-9"><cf_get_lang no='589.ISO-8859-9 (Türkçe)'></option> --->
                                <option value="UTF-8">UTF-8</option>
                            </select>
                        </div> 
                    </div>
                    <div class="form-group" id="item-uploaded_file">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57468.Belge'></label>
                        <div class="col col-8 col-sm-12">
                            <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                        </div> 
                    </div>
                    <cfif isdefined("attributes.is_branch")>
                        <cfoutput>
                        <input type="hidden" name="branch_id" id="branch_id" value="#listgetat(session.ep.user_location,2,'-')#">
                        <input type="hidden" name="branch" id="branch" value="#listgetat(session.ep.user_location,2,'-')#">
                        </cfoutput>
                    <cfelse>
                        <div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'> *</label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="hidden" name="branch_id" id="branch_id" value="">
                                    <input type="text" name="branch" id="branch" value="" style="width:200px;" readonly>					
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=formexport.branch_id&field_branch_name=formexport.branch</cfoutput>','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></span>
                                </div>
                            </div> 
                        </div>
                    </cfif>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" style="width:98px;" validate="#validate_style#" name="startdate" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>
                        </div> 
                        <div class="col col-2 col-sm-12">
                            <select name="start_hour" id="start_hour" >
                                <cfloop from="0" to="23" index="i">
                                    <cfif len(i) eq 1><cfset i = "0#i#"></cfif>
                                    <cfoutput><option value="#i#">#i#</option></cfoutput>
                                </cfloop>
                            </select>  
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="start_min" id="start_min">
                                <option value="00">00</option>
                                <cfloop from="5" to="55" index="i" step="5">
                                    <cfoutput><option value="#i#">#i#</option></cfoutput>
                                </cfloop>
                            </select> 
                        </div>
                    </div>
                    <cfif isdefined("attributes.is_branch")>
                        <cfset attributes.branch_id = listgetat(session.ep.user_location, 2, '-')>
                        <cfquery name="PRICE_CAT" datasource="#DSN3#">
                            SELECT
                                PRICE_CATID,
                                PRICE_CAT
                            FROM
                                PRICE_CAT
                            WHERE
                                PRICE_CAT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
                                PRICE_CAT.BRANCH LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#attributes.branch_id#,%">
                            ORDER BY
                                PRICE_CAT
                        </cfquery>
                        <input type="hidden" name="price_catid" id="price_catid" value="<cfoutput>#price_cat.price_catid#</cfoutput>">
                        <div class="form-group" id="item-price_catid">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                            <div class="col col-8 col-sm-12">  
                                <cfoutput>#price_cat.price_cat#</cfoutput>  
                            </div>
                        </div>
                    <cfelse>
                        <cfquery name="PRICE_CATS" datasource="#DSN3#">
                            SELECT
                                PRICE_CATID,
                                PRICE_CAT
                            FROM
                                PRICE_CAT
                            WHERE
                                PRICE_CAT_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="1">
                            ORDER BY
                                PRICE_CAT
                        </cfquery>
                        <div class="form-group" id="item-price_catid">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                            <div class="col col-8 col-sm-12">  
                                <select name="price_catid" id="price_catid" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <option value="-2"><cf_get_lang dictionary_id='58721.Standart Satış'></option>
                                    <cfoutput query="price_cats">
                                    <option value="#price_catid#">#price_cat#</option>
                                    </cfoutput>
                                </select> 
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-price_catid">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57585.Kurumsal Üye'></label>
                        <div class="col col-8 col-sm-12">  
                            <div class="input-group">
                                <input type="hidden" name="destination_company_id" id="destination_company_id" value="">
                                <input type="text" name="destination_company_name" id="destination_company_name" value="" style="width:200px;" readonly>
                                <span class="input-group-addon icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=formexport.destination_company_id&field_comp_name=formexport.destination_company_name&select_list=2,6','list')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='form_chk()'>
            </cf_box_footer>
         </cfform>
    </cf_box>
</div>

<script type="text/javascript">
function form_chk()
{
	if (document.formexport.price_catid.value.length == 0)
	{
		alert("<cf_get_lang dictionary_id ='33165.Fiyat Listesi Seçiniz'> !");
		return false;
	}		
	return true;
}
</script>
