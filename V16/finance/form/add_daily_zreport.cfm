<!--- Sayfada yer alan hidden alanlar basket çalışmaları kapsamında _1.cfm dosyasına taşınmıştır. EY 20150813 --->
<cf_get_lang_set module_name="finance">
<cf_xml_page_edit fuseact="finance.add_daily_zreport">
<cfscript>session_basket_kur_ekle(process_type:0);</cfscript>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <div id="basket_main_div">
            <cfform name="form_basket" method="post" action="#request.self#?fuseaction=#fusebox.circuit#.emptypopup_add_daily_zreport" >
                <!---Fatura Bilgileri --->
                <cfinclude template="../form/add_daily_zreport_1.cfm">
                <!--- Basket --->
                
                <cfset attributes.basket_id = 52>
                <cfset attributes.form_add = 1>
                <cfinclude template="../../objects/display/basket.cfm">
                <cf_seperator title="#getLang('','Tahsilat',57845)#" id="tahsilat">
                <!---Nakit ve kredi kartı tahsilatlar --->   
                <cfinclude template="../form/add_daily_zreport_2.cfm">    
                <!---Toplamlar --->        
                <table totalTable cellspacing="1" cellpadding="2" border="0" width="100%" align="center">
                    <tr valign="top" class="color-row">
                        <td height="50" valign="top" id="total">
                            <cfinclude template="../form/add_daily_zreport_3.cfm">
                        </td>
                    </tr>
                </table> 
                <cfif x_show_info eq 1>
                <!---Istatiksel Bilgiler --->
                    <table statisticalTable cellspacing="1" cellpadding="2" border="0" width="100%" align="center">
                        <tr valign="top" class="color-row">
                            <td height="50" valign="top" id="statistical">
                                <cfinclude template="../form/add_daily_zreport_4.cfm">		
                            </td>
                        </tr>				
                    </table>		
                </cfif>
            </cfform>
        </div>
    </cf_box>
</div>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
