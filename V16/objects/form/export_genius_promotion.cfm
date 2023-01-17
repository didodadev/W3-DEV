<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_price_cats.cfm">
<cfif not isDefined("attributes.draggable")><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box id="formexport" title="#iif(isDefined("attributes.draggable"),"getLang('sales','Promosyon Belgesi Ekle',61833)",DE(''))#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),DE(1),DE(0))#">
        <cfform name="formexport" action="#request.self#?fuseaction=objects.emptypopupflush_export_genius_promotion" method="post">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-target_pos">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58594.Format'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="target_pos" id="target_pos" style="width:169px;">
                                <option value="-1"><cf_get_lang dictionary_id='45932.Genius'></option>
                            </select>
                        </div>
                    </div>
                    <cfif isdefined("attributes.is_branch")>
                        <cfoutput>
                            <div class="form-group" id="item-branch_id">
                                <div class="col col-8 col-sm-12">
                                    <input type="hidden" name="branch_id" id="branch_id" value="#listgetat(session.ep.user_location,2,'-')#">
                                    <input type="hidden" name="branch" id="branch" value="#listgetat(session.ep.user_location,2,'-')#">
                                </div>
                            </div>
                        </cfoutput>
                    <cfelse>
                        <div class="form-group" id="item-target_pos">
                            <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57453.Şube'>*</label>
                            <div class="col col-8 col-sm-12">
                                <div class="input-group">
                                    <input type="hidden" name="branch_id" id="branch_id" value="">
                                    <input type="text" name="branch" id="branch" value="" style="width:169px;" readonly>
                                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=formexport.branch_id&field_branch_name=formexport.branch</cfoutput>','list');"><img src="/images/plus_thin.gif"></span>
                                </div>
                            </div>
                        </div>
                    </cfif>
                    <div class="form-group" id="item-price_catid">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58964.Fiyat Listesi'></label>
                        <div class="col col-8 col-sm-12">
                            <select name="price_catid" id="price_catid" style="width:169px;">
                                <option value="-2" selected><cf_get_lang dictionary_id='58721.Standart Satış'>                   
                                <cfoutput query="price_cats">
                                    <option value='#price_catid#'>#price_cat#
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" style="width:65px;" validate="#validate_style#" name="startdate" maxlength="10" required="yes" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#!">
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
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57700.Bitiş Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfinput type="text" style="width:65px;" validate="#validate_style#" name="finishdate" maxlength="10" required="yes" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#!">               
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
                    <div class="form-group" id="item-startdate">
                        <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></label>
                        <div class="col col-4 col-sm-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='57627.Kayıt Tarihi'></cfsavecontent>
                                <cfinput type="text" style="width:65px;" message="#message#" validate="#validate_style#" name="recorddate" maxlength="10">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="recorddate"></span>
                            </div>
                        </div>
                        <div class="col col-2 col-sm-12">
                            <select name="record_hour" id="record_hour" style="margin-left:3px;">
                                <cfloop from="0" to="23" index="i">
                                    <cfif len(i) eq 1>
                                        <cfset i = "0#i#">
                                    </cfif>
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
            </cf_box_elements>
            <cf_box_footer><cf_workcube_buttons type_format="1" is_upd='0' add_function='form_chk()'></cf_box_footer>
        </cfform>
    </cf_box>
</div>   

<script type="text/javascript">
	function form_chk()
	{
		if (formexport.branch_id.value.length == 0)
		{
			alert("<cf_get_lang dictionary_id ='58579.Şube Seçiniz'> !");
			return false;
		}
		
		if ( (formexport.startdate.value !="") && (formexport.finishdate.value !="")) 
		{
			return date_check(formexport.startdate,formexport.finishdate,"<cf_get_lang dictionary_id ='33707.Başlangıç tarihi bitiş tarihinden küçük olmalıdır'> !");
		}
			
		<cfif isdefined("attributes.draggable")>loadPopupBox('formexport' , <cfoutput>#attributes.modal_id#</cfoutput>);<cfelse>return true;</cfif>
	}
</script>
