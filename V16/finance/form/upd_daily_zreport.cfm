<cf_get_lang_set module_name="finance">
<cf_xml_page_edit fuseact="finance.add_daily_zreport">
<cfif isnumeric(attributes.iid)>
	<cfinclude template="../query/get_zreport.cfm">
<cfelse>
	<cfset get_sale_det.recordcount = 0>
</cfif>
<cfscript>session_basket_kur_ekle(action_id=attributes.iid,table_type_id:1,process_type:1);</cfscript>
<div id="basket_main_div">
    <cf_catalystHeader>
    <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
        <cf_box>
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_upd_daily_zreport">
                <!---Fatura Bilgileri --->
                <cfinclude template="../form/upd_daily_zreport_1.cfm">
                
                <!--- Basket --->
               
                <cfset attributes.basket_id = 52>
                <cfinclude template="../../objects/display/basket.cfm">
                
                <cf_seperator title="#getLang('','Tahsilat',57845)#" id="tahsilat">
                <!---Nakit ve kredi kartı tahsilatlar --->
                <cfinclude template="../form/upd_daily_zreport_2.cfm">
            
                <!---Toplamlar --->
                <table totalTable cellspacing="1" cellpadding="2" border="0" width="100%" align="center">
                    <tr valign="top" class="color-row">
                        <td height="50" valign="top" id="total">
                            <cfinclude template="../form/add_daily_zreport_3.cfm">
                        </td>
                    </tr>
                </table>
                <!---Istatiksel Bilgiler --->
                <cfif x_show_info eq 1>
                    <table statisticalTable cellspacing="1" cellpadding="2" border="0" width="100%" align="center">
                        <tr>
                            <td id="statistical">
                                <cfinclude template="../form/upd_daily_zreport_4.cfm">
                            </td>
                        </tr>
                    </table>
                </cfif>
            </cfform>
        </cf_box>
    </div>
</div>
<script type="text/javascript">
	toplam_tahsilat();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
