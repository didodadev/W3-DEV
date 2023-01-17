<cfquery name="get_prize_type" datasource="#dsn#">
    SELECT 
	    PRIZE_TYPE_ID, 
        PRIZE_TYPE,
        DETAIL 
    FROM 
    	SETUP_PRIZE_TYPE
	WHERE
		IS_ACTIVE = 1
	ORDER BY
		PRIZE_TYPE
</cfquery>
<cfif isDefined("attributes.prize_to") and len(attributes.prize_to)>
    <cfset employee = attributes.prize_to>
    <cfset from_fuseaction = #attributes.from_fuseaction#>
<cfelse>
    <cfset from_fuseaction = "">
    <cfset employee = "">
</cfif>
<cf_box title="#getLang('','ödüller','55462')#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform action="#request.self#?fuseaction=ehesap.emptypopup_add_prize" name="add_prize" method="post">
    	<cf_box_elements>
			<div class="col col-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
				<div class="form-group" id="item-prize_head">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Konu'> *</label>
					<div class="col col-9 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="prize_head"  required="yes" message="#message#" maxlength="50">
					</div>
				</div>
				<div class="form-group" id="item-PRIZE_TYPE">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57630.Tip'> *</label>
					<div class="col col-9 col-xs-12">
						<select name="PRIZE_TYPE" id="PRIZE_TYPE" >
							<cfoutput query="get_prize_type">
								<option value="#PRIZE_TYPE_ID#">#PRIZE_TYPE#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-DATE">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53335.Ödül Tarihi'></label>
					<div class="col col-9 col-xs-12">
						<div class="input-group">
							<input validate="#validate_style#" type="text" name="PRIZE_DATE" id="PRIZE_DATE" value="" > 
							<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="PRIZE_DATE"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-prize_give_person_id">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53124.Ödül Veren'> *</label>
					<div class="col col-9 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="prize_give_person_id" id="prize_give_person_id">
							<input type="text" name="prize_give_person" id="prize_give_person" >
							<span class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_prize.prize_give_person_id&field_emp_name=add_prize.prize_give_person');return false"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-6 col-sm-6 col-xs-12" type="column" sort="true" index="2">
				<div class="form-group" id="item-prize_to_id">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='53123.Ödül Alan'> *</label>
					<div class="col col-9 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="prize_to_id" id="prize_to_id" value="<cfif isDefined("attributes.prize_to_id") and len(attributes.prize_to_id)><cfoutput>#attributes.prize_to_id#</cfoutput></cfif>">
							<cfinput type="text" name="prize_to" id="prize_to" value="#employee#">
                            <cfinput type="hidden" name="from_fuseaction" id="from_fuseaction" value="#from_fuseaction#">
							<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_positions&field_emp_id=add_prize.prize_to_id&field_emp_name=add_prize.prize_to');return false"></span>
						</div>
					</div>
				</div>
				<div class="form-group" id="item-PRIZE_DETAIL">
					<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-9 col-xs-12">
						<textarea style="width:190px;height:100px;" name="PRIZE_DETAIL" id="PRIZE_DETAIL"></textarea>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<div class="col col-12">
				<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
			</div>
		</cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
    function kontrol()
    {
        //x = document.add_prize.PRIZE_TYPE.selectedIndex;
        if (document.add_prize.PRIZE_TYPE.value == "")
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