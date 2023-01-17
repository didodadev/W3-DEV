<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_branches.cfm">
<cf_box title="#getLang('contract',296)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="add_purchase_general_discount" method="post" action="#request.self#?fuseaction=contract.emptypopup_add_purchase_general_discount">
        <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>">
        <cf_box_elements>
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-discount_head">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50930.İskonto Başlığı'> *</label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='50930.İskonto başlığı'></cfsavecontent>
                        <cfinput type="text" name="discount_head" style="width:200" required="Yes" message="#message#" value="" maxlength="100">
                    </div>                
                </div>
                <div class="form-group" id="item-discount">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50934.İskonto Oranı'> *</label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='50935.İskonto oranı girmelisiniz'></cfsavecontent>
                        <cfinput type="text" name="discount" style="width:35" required="Yes" message="#message#" value="" range="0,100" validate="float">
                    </div>                
                </div>
                <div class="form-group" id="item-start_date">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'> *</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfinput value="" validate="#validate_style#" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#" type="text" name="start_date" required="yes" maxlength="10"><!--- #dateformat(start_date,dateformat_style)# --->
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>                
                </div>
                <div class="form-group" id="item-finish_date">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'> *</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfinput value=""type="text" name="finish_date" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#" validate="#validate_style#" required="yes" maxlength="10"><!--- #dateformat(finish_date,dateformat_style)# --->
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>                
                </div>
                <div class="form-group" id="item-type">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57630.Tipi'></label>
                    <div class="col col-4 col-sm-12">
                        <input type="radio" checked="checked" value="1" name="type" id="type"><cf_get_lang dictionary_id='57449.Satın Alma'>
                    </div>           
                    <div class="col col-4 col-sm-12">
                        <input type="radio" value="2" name="type" id="type"><cf_get_lang dictionary_id='57448.Satış'>
                    </div>      
                </div>
            </div>
        </cf_box_elements>
        <cf_seperator title="#getLang('','Geçerli Şubeler',50965)#" id="branches_id">
        <div class="ui-scroll">
            <cf_box_elements id="branches_id">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-branchs">
                        <label class="col col-2 col-sm-12"><input type="checkbox" name="all" id="all" value="1" onclick="hepsi();"></label>
                        <div class="col col-8 col-sm-12">
                            <cf_get_lang dictionary_id='29495.Tüm Şubeler'>
                        </div>                
                    </div> 
                    <cfoutput query="get_branches">
                        <div class="form-group" id="item-branches">
                            <label class="col col-2 col-sm-12"><input type="checkbox" name="branches" id="branches" value="#branch_id#"></label>
                            <div class="col col-8 col-sm-12">
                                #BRANCH_NAME#
                            </div>                
                        </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
        </div>
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('add_purchase_general_discount' , #attributes.modal_id#)"),DE(""))#"> 
        </cf_box_footer>						
    </cfform>
</cf_box>

<script type="text/javascript">
	function hepsi()
	{
		if (add_purchase_general_discount.all.checked)
			{
		<cfif get_branches.recordcount gt 1>	
			for(i=0;i<add_purchase_general_discount.branches.length;i++) add_purchase_general_discount.branches[i].checked = true;
		<cfelseif get_branches.recordcount eq 1>
			add_purchase_general_discount.branches.checked = true;
		</cfif>
			}
		else
			{
		<cfif get_branches.recordcount gt 1>	
			for(i=0;i<add_purchase_general_discount.branches.length;i++) add_purchase_general_discount.branches[i].checked = false;
		<cfelseif get_branches.recordcount eq 1>
			add_purchase_general_discount.branches.checked = false;
		</cfif>
			}
	}
	
	function kontrol()
	{
		flag = false;
		<cfif get_branches.recordcount gt 1>	
		for(i=0;i<add_purchase_general_discount.branches.length;i++)
			if (add_purchase_general_discount.branches[i].checked)
				flag = true;
		<cfelseif get_branches.recordcount eq 1>
			if (add_purchase_general_discount.branches.checked)
				flag = true;
		</cfif>
		if (!flag)
			{
				alert("<cf_get_lang dictionary_id='51006.En az bir şube seçmelisiniz'> !");
				return false;
			}
		else return true;
	}
	
	function reloadOpener()
	{
		wrk_opener_reload();
	}
</script>

