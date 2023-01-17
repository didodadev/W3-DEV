<cf_get_lang_set module_name="product">
<cfquery name="GET_CONS_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY 
</cfquery>
<cfquery name="GET_CONS_CATS" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT WHERE IS_PREMIUM = 0 ORDER BY HIERARCHY
</cfquery>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='37851.Kategori Segmentasyon Tanımları'></cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_segmentation" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_conscat_segmentation">
            <cfif isdefined("attributes.campaign_id")>
                <cfquery name="get_catalog_segment" datasource="#dsn3#">
                    SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #attributes.campaign_id#
                </cfquery>
                <input type="hidden" name="campaign_id" id="campaign_id" value="<cfoutput>#attributes.campaign_id#</cfoutput>">
            <cfelseif isdefined("attributes.catalog_id")>
                <cfquery name="get_catalog_segment" datasource="#dsn3#">
                    SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CATALOG_ID = #attributes.catalog_id#
                </cfquery>
                <input type="hidden" name="catalog_id" id="catalog_id" value="<cfoutput>#attributes.catalog_id#</cfoutput>">
            <cfelseif isdefined("attributes.promotion_id")>	
                <cfquery name="get_catalog_segment" datasource="#dsn3#">
                    SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROMOTION_ID = #attributes.promotion_id#
                </cfquery>
                <input type="hidden" name="promotion_id" id="promotion_id" value="<cfoutput>#attributes.promotion_id#</cfoutput>">
            <cfelseif isdefined("attributes.prom_rel_id")>	
                <cfquery name="get_catalog_segment" datasource="#dsn3#">
                    SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROM_REL_ID = #attributes.prom_rel_id#
                </cfquery>
                <input type="hidden" name="prom_rel_id" id="prom_rel_id" value="<cfoutput>#attributes.prom_rel_id#</cfoutput>">
            </cfif>
            <cfif get_catalog_segment.recordcount gt 0>
                <input type="hidden" name="catalog_segment_id" id="catalog_segment_id" value="1">
            </cfif>

            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="30"><cf_get_lang dictionary_id ='57487.No'></th>
                        <th><cf_get_lang dictionary_id ='58609.Üye Kategorisi'></th>
                        <th><cf_get_lang dictionary_id ='37687.Minimum Kişisel Satış'></th>
                        <th><cf_get_lang dictionary_id ='37688.Sadece Prim Engelle'></th>
                        <th><cf_get_lang dictionary_id ='37689.Bağlı Üye Sayısı'></th>
                        <th><cf_get_lang dictionary_id ='37736.Aktif Olma Kriteri'></th>
                        <th><cf_get_lang dictionary_id ='37912.Bağlı Üye Satış Tutarı'></th>
                        <th><cf_get_lang dictionary_id ='37913.Grup Satış Tutarı'></th>
                        <th><cf_get_lang dictionary_id ='37914.Kampanya Geçerlilik Süresi'></th>
                    </tr>
                </thead>
                <tbody>
                <cfoutput query="get_cons_cat">
                    <cfset conscat_id_ = get_cons_cat.conscat_id>
                    <cfif isdefined("attributes.campaign_id")>
                        <cfquery name="get_segment" datasource="#dsn3#">
                            SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CAMPAIGN_ID = #attributes.campaign_id# AND CONSCAT_ID = #conscat_id_#
                        </cfquery>
                    <cfelseif isdefined("attributes.catalog_id")>
                        <cfquery name="get_segment" datasource="#dsn3#">
                            SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE CATALOG_ID = #attributes.catalog_id# AND CONSCAT_ID = #conscat_id_#
                        </cfquery>
                    <cfelseif isdefined("attributes.promotion_id")>	
                        <cfquery name="get_segment" datasource="#dsn3#">
                            SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROMOTION_ID = #attributes.promotion_id# AND CONSCAT_ID = #conscat_id_#
                        </cfquery>
                    <cfelseif isdefined("attributes.prom_rel_id")>	
                        <cfquery name="get_segment" datasource="#dsn3#">
                            SELECT * FROM SETUP_CONSCAT_SEGMENTATION WHERE PROM_REL_ID = #attributes.prom_rel_id# AND CONSCAT_ID = #conscat_id_#
                        </cfquery>
                    </cfif>
                    <tr>
                        <td>#currentrow#</td>
                        <cfloop query="get_cons_cats">
                            <cfif get_segment.recordcount>
                                <cfquery name="get_segment_rows" datasource="#dsn3#">
                                    SELECT * FROM SETUP_CONSCAT_SEGMENTATION_ROWS WHERE CONSCAT_SEGMENT_ID = #get_segment.conscat_segment_id# AND CONSCAT_ID = #get_cons_cats.conscat_id#
                                </cfquery>
                            <cfelse>
                                <cfset get_segment_rows.recordcount = 0>
                            </cfif>
                            <input type="hidden" name="consumer_cat_row_id#conscat_id_#_#get_cons_cats.currentrow#" id="consumer_cat_row_id#conscat_id_#_#get_cons_cats.currentrow#" value="<cfif get_segment_rows.recordcount>#get_segment_rows.conscat_id#</cfif>">
                            <input type="hidden" name="member_count_row#conscat_id_#_#get_cons_cats.currentrow#" id="member_count_row#conscat_id_#_#get_cons_cats.currentrow#" value="<cfif get_segment_rows.recordcount>#get_segment_rows.row_member_count#<cfelse>0</cfif>">
                        </cfloop>
                        <td width="130">
                            <input type="hidden" name="consumer_catid#currentrow#" id="consumer_catid#currentrow#" value="#conscat_id#">
                            <input type="text" name="consumer_cat#currentrow#" id="consumer_cat#currentrow#" value="#conscat#" class="boxtext">
                        </td>
                        <td>
                            <input type="text" name="min_personal_sale#currentrow#" id="min_personal_sale#currentrow#" value="<cfif get_segment.recordcount>#Tlformat(get_segment.min_personal_sale)#<cfelse>#Tlformat(0)#</cfif>" style="width:90px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                            #session.ep.money#
                        </td>
                        <td class="text-center">
                            <input type="checkbox" name="is_prim_sale#currentrow#" id="is_prim_sale#currentrow#" value="0" <cfif get_segment.recordcount and get_segment.is_personal_prim eq 1>checked</cfif>>
                        </td>
                        <td>
                            <input type="text" name="ref_member_count#currentrow#" id="ref_member_count#currentrow#" value="<cfif get_segment.recordcount>#get_segment.ref_member_count#<cfelse>0</cfif>" style="width:90px;" onkeyup="isNumber(this);" class="moneybox">
                            <div style="position:absolute;" id="open_process_#currentrow#" class="nohover_div"></div>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='37696.Temsilci Dağılımı'></cfsavecontent>
                            <a href="javascript://" onClick="goster(open_process_#currentrow#);open_process(#currentrow#,#conscat_id#);"><img src="/images/plus_thin.gif" border="0" align="absmiddle" title="#message#"></a>
                        </td>
                        <td align="center">
                            <input type="text" name="active_member_condition#currentrow#" id="active_member_condition#currentrow#" value="<cfif get_segment.recordcount and len(get_segment.active_member_condition)>#Tlformat(get_segment.active_member_condition)#<cfelse>#Tlformat(0)#</cfif>" style="width:100px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                        </td>
                        <td>
                            <input type="text" name="min_ref_member_sale#currentrow#" id="min_ref_member_sale#currentrow#" value="<cfif get_segment.recordcount>#Tlformat(get_segment.ref_member_sale)#<cfelse>#Tlformat(0)#</cfif>" style="width:90px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                            #session.ep.money#
                        </td>
                        <td>
                            <input type="text" name="min_group_sale#currentrow#" id="min_group_sale#currentrow#" value="<cfif get_segment.recordcount and len(get_segment.group_sale)>#Tlformat(get_segment.group_sale)#<cfelse>#Tlformat(0)#</cfif>" style="width:90px;" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
                            #session.ep.money#
                        </td>
                        <td width="90">
                            <input type="text" name="campaign_count#currentrow#" id="campaign_count#currentrow#" value="<cfif get_segment.recordcount and len(get_segment.campaign_count)>#get_segment.campaign_count#<cfelse>0</cfif>" style="width:120px;" onkeyup="isNumber(this);" class="moneybox">
                        </td>
                    </tr>
                </cfoutput>
                </tbody>
            </cf_grid_list>
            <cf_box_footer>
                <div class="col col-6">
                    <cfif get_catalog_segment.recordcount gt 0>
                        <cf_record_info query_name="get_catalog_segment">
                    </cfif>
                </div>
                <div class="col col-6">
                    <cfif get_catalog_segment.recordcount gt 0>
                        <cfif isdefined("attributes.campaign_id")>
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_conscat_segmentation&campaign_id=#attributes.campaign_id#'>
                        <cfelseif isdefined("attributes.catalog_id")>
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_conscat_segmentation&catalog_id=#attributes.catalog_id#'>
                        <cfelseif isdefined("attributes.promotion_id")>
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_conscat_segmentation&promotion_id=#attributes.promotion_id#'>
                        <cfelseif isdefined("attributes.prom_rel_id")>
                            <cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=#fusebox.circuit#.emptypopup_del_conscat_segmentation&prom_rel_id=#attributes.prom_rel_id#'>
                        </cfif>
                    <cfelse>
                        <cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                    </cfif>
                </div>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

<script type="text/javascript">
	function open_process(row_count,conscat_id)
	{  
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=product.popup_add_conscat_segmentation_rows&rows='+row_count+'&conscat_id='+conscat_id+'','open_process_'+row_count+'',1);
	}
	function kontrol()
	{
		<cfoutput query="get_cons_cat">
			eval("document.add_segmentation.min_personal_sale"+#currentrow#).value = filterNum(eval("document.add_segmentation.min_personal_sale"+#currentrow#).value);
			eval("document.add_segmentation.min_ref_member_sale"+#currentrow#).value = filterNum(eval("document.add_segmentation.min_ref_member_sale"+#currentrow#).value);
			eval("document.add_segmentation.active_member_condition"+#currentrow#).value = filterNum(eval("document.add_segmentation.active_member_condition"+#currentrow#).value);
			eval("document.add_segmentation.min_group_sale"+#currentrow#).value = filterNum(eval("document.add_segmentation.min_group_sale"+#currentrow#).value);
		</cfoutput>
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
