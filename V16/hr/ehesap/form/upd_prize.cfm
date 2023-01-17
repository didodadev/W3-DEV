<cfinclude template="../query/get_prize.cfm">
<cfquery name="get_prize_type" datasource="#dsn#">
  SELECT PRIZE_TYPE_ID,PRIZE_TYPE FROM SETUP_PRIZE_TYPE WHERE IS_ACTIVE =1 ORDER BY PRIZE_TYPE 
</cfquery>
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_prize"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a></cfsavecontent>
<cf_box title="#getLang('','ödüller','55462')#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_upd_prize" name="add_prize" method="post">
        <input type="hidden" value="<cfoutput>#attributes.prize_id#</cfoutput>" name="prize_id" id="prize_id">
        <cf_box_elements>
            <div class="col col-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-prize_head">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'> *</label>
                    <div class="col col-9 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.başlık girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="prize_head"  required="yes" message="#message#" maxlength="50" value="#get_prize.prize_head#">
                    </div>
                </div>
                <div class="form-group" id="item-PRIZE_TYPE">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'> *</label>
                    <div class="col col-9 col-xs-12">
                        <select name="PRIZE_TYPE" id="PRIZE_TYPE" >
                            <cfoutput query="get_prize_type">
                                <option value="#PRIZE_TYPE_ID#"<cfif PRIZE_TYPE_ID EQ get_prize.PRIZE_TYPE_ID>SELECTED</cfif>>#PRIZE_TYPE#</option>
                            </cfoutput>
                        </select> 
                    </div>
                </div>
                <div class="form-group" id="item-DATE">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53335.Ödül Tarihi'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <input validate="#validate_style#" type="text" name="PRIZE_DATE" id="PRIZE_DATE" value="<cfoutput>#dateformat(get_prize.PRIZE_DATE,dateformat_style)#</cfoutput>" >
                            <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="PRIZE_DATE"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-prize_give_person_id">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53124.Ödül Veren'> *</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="prize_give_person_id" id="prize_give_person_id" value="<cfoutput>#get_prize.prize_give_person#</cfoutput>">
                            <input type="text" name="prize_give_person" id="prize_give_person"  value="<cfoutput>#get_emp_info(get_prize.prize_give_person,0,0)#</cfoutput>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_prize.prize_give_person_id&field_emp_name=add_prize.prize_give_person</cfoutput>');return false"></span>
                        </div>
                    </div>
                </div>
            </div>
			<div class="col col-6 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                <div class="form-group" id="item-prize_to_id">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53123.Ödül Alan'> *</label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <input type="hidden" name="prize_to_id" id="prize_to_id" value="<cfoutput>#get_prize.prize_to#</cfoutput>">
                            <input type="text" name="prize_to" id="prize_to"  value="<cfoutput>#get_emp_info( get_prize.prize_to,0,0)#</cfoutput>">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_list_positions&field_emp_id=add_prize.prize_to_id&field_emp_name=add_prize.prize_to</cfoutput>');return false"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-PRIZE_DETAIL">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-9 col-xs-12">
                        <textarea style="width:190px;height:100px;" name="PRIZE_DETAIL" id="PRIZE_DETAIL"><cfoutput>#get_prize.prize_detail#</cfoutput></textarea>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6 col-xs-12">
                <cf_record_info query_name="get_prize">
            </div>
            <div class="col col-6 col-xs-12">
                <cf_workcube_buttons is_upd='1' add_function='kontrol()'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_prize&prize_id=#get_prize.prize_id#'>
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
			
	x = document.add_prize.PRIZE_TYPE.selectedIndex;
	if (document.add_prize.PRIZE_TYPE[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id ='54009.Ödül Tipi Seçmelisiniz'>!");
		return false;
	}
	
		if (add_prize.prize_give_person.value == "")
			{
			alert("<cf_get_lang dictionary_id ='54010.Ödül Veren Seçmelisiniz'>!");
					return false;
			}
			
		if (add_prize.prize_to.value == "")
			{
			alert("<cf_get_lang dictionary_id ='54011.Ödül Alan Seçmelisiniz'>!");
					return false;
			}
		return true;	
	}
</script>
