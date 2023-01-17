<cf_xml_page_edit fuseact="objects.popup_form_export_stock">
<cfparam name="attributes.modal_id" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
    <cf_box title="#getLang('','Fiyat Değişim Export Belgesi Oluştur',32846)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">  
        <cfform name="formexport" method="post" action="#request.self#?fuseaction=objects.emptypopupflush_export_price_change_genius">
            <input type="hidden" name="x_genius_box_price" id="x_genius_box_price" value="<cfoutput>#x_genius_box_price#</cfoutput>">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-hierarchy">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="hierarchy" id="hierarchy" value="">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='53158.Kategori Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" name="productcat" value="" readonly="yes" message="#message#" style="width:169px;">
                                <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&field_code=formexport.hierarchy&field_name=formexport.productcat</cfoutput>&is_sub_category=1');"><img src="/images/plus_thin.gif" border="0" title="<cf_get_lang dictionary_id='57734.Seçiniz'>" align="absmiddle"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-target_pos">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58594.Format'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="target_pos" id="target_pos" style="width:169px;" onchange="type_change();">
                                <option value="-1"><cf_get_lang dictionary_id='32843.Genius'></option>
                                <option value="-2">Inter</option>
                                <option value="-3">NCR</option>
                                <option value="-4"><cf_get_lang dictionary_id='62481.Workcube Whops'></option>					  
                            </select>
                        </div>
                    </div>
                    <cfif isdefined("attributes.is_branch")>
                        <cfoutput>
                        <input type="hidden" name="branch_id" id="branch_id" value="#listgetat(session.ep.user_location,2,'-')#">
                        <input type="hidden" name="branch" id="branch" value="#listgetat(session.ep.user_location,2,'-')#">
                        </cfoutput>
                    <cfelse>
                        <div class="form-group" id="item-hierarchy">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="hidden" name="branch_id" id="branch_id" value="">
                                    <input type="text" name="branch" id="branch" value="" readonly style="width:169px;">					
                                    <span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=formexport.branch_id&field_branch_name=formexport.branch</cfoutput>');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57738.Başlangıç Tarihi Girmelisiniz'></cfsavecontent>
                                <cfinput type="text" message="#message#" validate="#validate_style#" name="startdate" maxlength="10" style="width:65px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
                            </div>  
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="start_hour" id="start_hour" style="margin-left:3px;">
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
                    <div class="form-group" id="item-finishdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" message="#message#" validate="#validate_style#" name="finishdate" maxlength="10" style="width:65px;"> 
                                <span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>  
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="finish_hour" id="finish_hour" style="margin-left:3px;">
                                <cfloop from="0" to="23" index="i">
                                    <cfif len(i) eq 1><cfset i = "0#i#"></cfif>
                                    <cfoutput><option value="#i#">#i#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="finish_min" id="finish_min">
                                <option value="00">00</option>
                                    <cfloop from="5" to="55" index="i" step="5">
                                        <cfoutput><option value="#i#">#i#</option></cfoutput>
                                    </cfloop>
                            </select> 
                        </div>
                    </div>
                    <div class="form-group" id="item-recorddate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></cfsavecontent>
                                <cfinput type="text" style="width:65px;" message="#alert#" validate="#validate_style#" name="recorddate" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="recorddate"></span>
                            </div>  
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="record_hour" id="record_hour" style="margin-left:3px;">
                                <cfloop from="0" to="23" index="i">
                                    <cfif len(i) eq 1><cfset i = "0#i#"></cfif>
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="record_min" id="record_min">
                                <option value="00">00</option>
                                <cfloop from="5" to="55" index="i" step="5">
                                    <cfoutput>
                                        <option value="#i#">#i#</option>
                                    </cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="3" sort="true" style="display:none">
                    <cfif isdefined("attributes.is_branch")>
                        <cfset attributes.branch_id = listgetat(session.ep.user_location, 2, '-')>
                        <cfquery name="PRICE_CAT" datasource="#DSN3#">
                            SELECT
                                PRICE_CATID,
                                PRICE_CAT
                            FROM
                                PRICE_CAT
                            WHERE
                                PRICE_CAT_STATUS = 1 AND
                                PRICE_CAT.BRANCH LIKE '%,#attributes.branch_id#,%'
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
                                PRICE_CAT_STATUS = 1
                            ORDER BY
                                PRICE_CAT
                        </cfquery>
                        <div class="form-group" id="item-price_catid">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                            <div class="col col-8 col-sm-12">
                                <select name="price_catid" id="price_catid" style="width:169px;">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
                                    <cfoutput query="price_cats">
                                        <option value="#price_catid#">#price_cat#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-price_catid">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57585.Kurumsal Üye'></label>
                        <div class="col col-8 col-sm-12">
                            <div class="input-group">
                                <input type="hidden" name="destination_company_id" id="destination_company_id" value="">
                                <input type="text" name="destination_company_name" id="destination_company_name" value="" readonly style="width:169px;">
                                <span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=formexport.destination_company_id&field_comp_name=formexport.destination_company_name&select_list=2,6')"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0' add_function='form_chk()' >
            </cf_box_footer>
        </cfform>
    </cf_box>
</div> 

<script type="text/javascript">
function type_change()
{
	if(document.formexport.target_pos.value=='-4')
		type_workcube.style.display='';
	else
	{
		type_workcube.style.display='none';
		document.formexport.price_catid.value='';
		document.formexport.destination_company_id.value='';
		document.formexport.destination_company_name.value='';
	}
}
function form_chk()
{
	if(document.formexport.target_pos.value!='-4')
	{
		if (document.formexport.branch_id.value.length == 0)
		{
			alert("<cf_get_lang dictionary_id='30126.Şube Seçiniz'> !");
			return false;
		}
	}
	else
	{
		//workcube belge tipinde fiyat listesi zorunlu
		if (document.formexport.price_catid.value.length == 0)
		{
			alert("<cf_get_lang dictionary_id='33165.Fiyat Listesi Seçiniz'> !");
			return false;
		}		
	}

	if((formexport.startdate.value !="") && (formexport.finishdate.value !="")) 
    {
        if(!date_check(formexport.startdate,formexport.finishdate,"<cf_get_lang dictionary_id ='33707.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'> !"))
		return false;
    }
		
	<cfif isdefined("attributes.draggable")>loadPopupBox('formexport' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>
}
</script>
