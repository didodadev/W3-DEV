<cfinclude template="../query/get_branches.cfm">
<cfif isdefined('attributes.type') and len(attributes.type)>
	<cfif attributes.type eq 1><!--- 1=satınalma --->
		<cfset TABLE_NAME ='CONTRACT_PURCHASE_GENERAL_DISCOUNT'>
		<cfset BRACH_TABLE ='CONTRACT_PURCHASE_GENERAL_DISCOUNT_BRANCHES'>
	<cfelseif attributes.type eq 2><!--- 2=satış --->
		<cfset TABLE_NAME ='CONTRACT_SALES_GENERAL_DISCOUNT'>
		<cfset BRACH_TABLE ='CONTRACT_SALES_GENERAL_DISCOUNT_BRANCHES'>
	</cfif>
</cfif>
<cfinclude template="../query/get_purchase_general_discount.cfm">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('contract',232)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="upd_purchase_general_discount" method="post" action="#request.self#?fuseaction=contract.emptypopup_upd_purchase_general_discount&type=#attributes.type#">
        <cf_box_elements>
            <input type="hidden" name="general_discount_id" id="general_discount_id" value="<cfoutput>#get_purchase_general_discount.general_discount_id#</cfoutput>">
            <div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-discount_head">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50930.İskonto Başlığı'> *</label>
                    <div class="col col-8 col-sm-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='50930.İskonto başlığı'></cfsavecontent>
                        <cfinput type="text" name="discount_head" required="Yes" message="#message#" value="#get_purchase_general_discount.discount_head#" maxlength="100">
                    </div>                
                </div>
                <div class="form-group" id="item-start_date">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57501.Başlangıç'> *</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfinput value="#dateformat(get_purchase_general_discount.start_date,dateformat_style)#" validate="#validate_style#" message="#getLang('','Başlangıç Tarihi Girmelisiniz',57738)#" required="yes" type="text" name="start_date" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                        </div>
                    </div>                
                </div>
                <div class="form-group" id="item-finish_date">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57502.Bitiş'> *</label>
                    <div class="col col-8 col-sm-12">
                        <div class="input-group">
                            <cfinput value="#dateformat(get_purchase_general_discount.finish_date,dateformat_style)#" type="text" name="finish_date" required="yes" message="#getLang('','Bitiş Tarihi Girmelisiniz',57739)#" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                        </div>
                    </div>                
                </div>
                <div class="form-group" id="item-discount">
                    <label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='50934.İskonto Oranı'> *</label>
                    <div class="col col-8 col-sm-12">
                        <cfinput type="text" name="discount" required="Yes" message="#getLang('','İskonto oranı girmelisiniz',50935)#" value="#get_purchase_general_discount.discount#" range="0,100" validate="float">
                    </div>                
                </div>
            </div>
        </cf_box_elements>
        <cf_seperator title="#getLang('','Geçerli Şubeler',50965)#" id="branches_id">
        <div class="ui-scroll">
            <cf_box_elements id="branches_id">
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-branchs">
                        <div class="col col-12 col-sm-12">
                            <cf_get_lang dictionary_id='29495.Tüm Şubeler'>
                            <input type="Checkbox" name="all" id="all" value="1" onclick="hepsi();">
                        </div>                
                    </div> 
                    <cfoutput query="get_branches">
                        <cfset branchid = get_branches.branch_id>
                        <div class="form-group" id="item-branches">
                            <div class="col col-12 col-sm-12">
                                #BRANCH_NAME#
                                <input type="Checkbox" name="branches" id="branches" value="#branch_id#" <cfloop query="GET_PURCHASE_GENERAL_DISCOUNT_BRANCHES"><cfif branchid is branch_id>checked</cfif></cfloop>>
                            </div>                
                        </div>
                    </cfoutput>
                </div>
            </cf_box_elements>
        </div>
        <cf_box_footer>
            <div class="col col-6">
                <cf_record_info query_name="get_purchase_general_discount">
            </div>
            <div class="col col-6">
                <cf_workcube_buttons is_upd='1' add_function="#iif(isdefined("attributes.draggable"),DE("kontrol() && loadPopupBox('upd_purchase_general_discount' , #attributes.modal_id#)"),DE(""))#" delete_page_url='#request.self#?fuseaction=contract.emptypopup_del_purchase_general_discount&general_discount_id=#general_discount_id#&type=#attributes.type#'> 
            </div>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function hepsi()
{
	if (upd_purchase_general_discount.all.checked)
	{
		<cfif get_branches.recordcount gt 1>	
			for(i=0;i<upd_purchase_general_discount.branches.length;i++) upd_purchase_general_discount.branches[i].checked = true;
		<cfelseif get_branches.recordcount eq 1>
			upd_purchase_general_discount.branches.checked = true;
		</cfif>
	}
	else
	{
		<cfif get_branches.recordcount gt 1>	
			for(i=0;i<upd_purchase_general_discount.branches.length;i++) upd_purchase_general_discount.branches[i].checked = false;
		<cfelseif get_branches.recordcount eq 1>
			upd_purchase_general_discount.branches.checked = false;
		</cfif>
	}
}

function kontrol()
{
	flag = false;
	<cfif get_branches.recordcount gt 1>	
		for(i=0;i<upd_purchase_general_discount.branches.length;i++)
			if (upd_purchase_general_discount.branches[i].checked)
			flag = true;
	<cfelseif get_branches.recordcount eq 1>
		if (upd_purchase_general_discount.branches.checked)
		flag = true;
	</cfif>		
	if (!flag)
	{
		alert("<cf_get_lang dictionary_id='51006.En az bir şube seçmelisiniz'>!");
		return false;
	}
	else
		return true;
	}
	function reloadOpener()
	{
		wrk_opener_reload();
	}
</script>
