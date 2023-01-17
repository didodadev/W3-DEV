<cfsetting showdebugoutput="yes">
<cf_get_lang_set module_name="report">
<cfparam name="attributes.module_id_control" default="13">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.report_type" default="1">
<cfparam name="attributes.process_type_detail" default="">
<cfparam name="attributes.cost_money" default="#session.ep.money#">
<cfparam name="attributes.volume_unit" default="1">
<cfparam name="attributes.date" default="#createodbcdatetime('#session.ep.period_year#-#month(now())#-1')#">
<cfparam name="attributes.date2" default="#now()#">
<cfparam name="attributes.process_type" default="">

<cfif not isdefined ("is_form_submitted")>
	<cfif isdate(attributes.date)>
        <cfset attributes.date = dateformat(attributes.date, dateformat_style)>
    </cfif>
    <cfif isdate(attributes.date2)>
        <cfset attributes.date2 = dateformat(attributes.date2,dateformat_style)>
    </cfif>
</cfif>

<cfset process_cat_list =''>
<cfif attributes.report_type neq 7>
    <cfloop list="#attributes.process_type_detail#" index="ind_process_type">
        <cfset attributes.process_type=listappend(attributes.process_type,listfirst(ind_process_type,'-'))>
        <cfif listlen(ind_process_type,'-') eq 3>
            <cfset process_cat_list = listappend(process_cat_list,listlast(ind_process_type,'-'))>
        </cfif>
    </cfloop>
<cfelse>
	<cfset process_cat_list =''>
</cfif>
<cfquery name="get_cost_type" datasource="#dsn#">
	SELECT INVENTORY_CALC_TYPE FROM SETUP_PERIOD WHERE PERIOD_ID = #session.ep.period_id#
</cfquery>
<cfif attributes.report_type eq 1>
	<cfset ALAN_ADI = 'STOCK_ID'>
<cfelseif listfind('2',attributes.report_type)>
	<cfset ALAN_ADI = 'PRODUCT_ID'>
<cfelseif attributes.report_type eq 8>
	<cfset ALAN_ADI = "STOCK_SPEC_ID">
</cfif>

<table class="dph">
    <!-- sil -->
    <tr>
        <td class="dpht"><a href="javascript:gizle_goster_ikili('stock_analyse','stock_analyse_bask');">&raquo;</a><cf_get_lang_main no='606.Stok Analiz'> Yeni Excel</td>
        <td class="dphb"><cf_workcube_file_action pdf='1' tag_module="stock_analyse_bask" is_ajax="1" mail='1' doc='1' print='1'></td>
    </tr>
    <!-- sil --> 
</table>
<cfform name="rapor" action="#request.self#?fuseaction=report.stock_analyse_new" method="post">
	<cfoutput>
    <input type="hidden" name="is_form_submitted" id="is_form_submitted" value="1">
        <cf_basket_form id="stock_analyse">
            <table border="0">
                <tr>
                    <td><cf_get_lang_main no='1548.Rapor Tipi'></td>
                    <td>
                        <select name="report_type" style="width:175px;"  onchange="control_report_type();">
                            <option value="1" <cfif attributes.report_type eq 1> selected</cfif>><cf_get_lang no ='333.Stok Bazında'></option>
                            <option value="2" <cfif attributes.report_type eq 2> selected</cfif>><cf_get_lang no='332.Ürün Bazında'></option>
                            <!---<option value="8" <cfif attributes.report_type eq 8> selected</cfif>><cf_get_lang no ='1044.Spec Bazında'></option>--->
                        </select>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td width="30"><cf_get_lang_main no='330.Tarih'></td>
                                <td width="180" valign="top" nowrap="nowrap">
                                    <cfoutput>
                                         <cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerini Kontrol Ediniz !'></cfsavecontent>
                                         <cfinput value="#attributes.date#" type="text" name="date" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
                                         <cf_wrk_date_image date_field="date"> /
                                         <cfinput value="#attributes.date2#"  type="text" name="date2" validate="#validate_style#" message="#message#" required="yes" style="width:63px;">
                                         <cf_wrk_date_image date_field="date2">
                                    </cfoutput>
                                </td>
                            </tr>        
                        </table>
                    </td>
                </tr>
                <tr>
                    <td width="71" rowspan="3" valign="top"><cf_get_lang_main no='388.İşlem Tipi'></td>
                    <td width="175" rowspan="3" valign="top" id="member_report_type1" <cfif attributes.report_type eq 7>style="display:none"</cfif>>
                        <cfquery name="GET_ALL_PROCESS_TYPES" datasource="#dsn3#">
                            SELECT PROCESS_TYPE,PROCESS_CAT_ID,PROCESS_CAT FROM SETUP_PROCESS_CAT WHERE PROCESS_TYPE IN (110,111,112,119) ORDER BY PROCESS_TYPE
                        </cfquery>
                        <select name="process_type_detail" style="width:175px; height:75px;" multiple>
                            <option value="2" <cfif listfind(attributes.process_type_detail,2)>selected</cfif>><cf_get_lang no ='1032.Alış ve Alış İadeler'></option>
                            <option value="3" <cfif listfind(attributes.process_type_detail,3)>selected</cfif>><cf_get_lang no='1033.Satış ve Satış İadeler'></option>
                            <option value="4" <cfif listfind(attributes.process_type_detail,4)>selected</cfif>><cf_get_lang no='1034.Üretimden Giriş'></option>
                                <cfquery name="get_process_cat" dbtype="query">
                                    SELECT * FROM GET_ALL_PROCESS_TYPES WHERE PROCESS_TYPE = 110
                                </cfquery>
                                <cfif get_process_cat.recordcount>
                                    <cfloop from="1" to="#get_process_cat.recordcount#" index="s">
                                        <option value="4-#get_process_cat.process_type[s]#-#get_process_cat.process_cat_id[s]#" <cfif listfind(attributes.process_type_detail,'4-#get_process_cat.process_type[s]#-#get_process_cat.process_cat_id[s]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat.process_cat[s]#</option>
                                    </cfloop>
                                </cfif>
                            <option value="5" <cfif listfind(attributes.process_type_detail,5)>selected</cfif>><cf_get_lang no='371.Sarf ve Fireler'></option>
                                <cfquery name="get_process_cat_2" dbtype="query">
                                    SELECT * FROM GET_ALL_PROCESS_TYPES WHERE PROCESS_TYPE  IN (111,112)
                                </cfquery>
                                <cfif get_process_cat_2.recordcount>
                                    <cfloop from="1" to="#get_process_cat_2.recordcount#" index="tt">
                                        <option value="5-#get_process_cat_2.process_type[tt]#-#get_process_cat_2.process_cat_id[tt]#" <cfif listfind(attributes.process_type_detail,'5-#get_process_cat_2.process_type[tt]#-#get_process_cat_2.process_cat_id[tt]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat_2.process_cat[tt]#</option>
                                    </cfloop>
                                </cfif>
                            <option value="6" <cfif listfind(attributes.process_type_detail,6)>selected</cfif>><cf_get_lang no ='1031.Dönem içi Giden Konsinye'></option>
                            <option value="7" <cfif listfind(attributes.process_type_detail,7)>selected</cfif>><cf_get_lang no ='1035.Dönem İçi İade Gelen Konsinye'></option>
                            <option value="19" <cfif listfind(attributes.process_type_detail,19)>selected</cfif>><cf_get_lang no ='1733.Dönem İçi Konsinye Giriş'></option>
                            <option value="20" <cfif listfind(attributes.process_type_detail,20)>selected</cfif>><cf_get_lang no ='1734.Dönem İçi Konsinye Giriş İade'></option>
                            <option value="8" <cfif listfind(attributes.process_type_detail,8)>selected</cfif>><cf_get_lang no ='1036.Teknik Servisten Giren'></option>
                            <option value="9" <cfif listfind(attributes.process_type_detail,9)>selected</cfif>><cf_get_lang no ='1037.Teknik Servisten Çıkan'></option>
                            <option value="10" <cfif listfind(attributes.process_type_detail,10)>selected</cfif>><cf_get_lang no ='1040.RMA Çıkış'></option>
                            <option value="11" <cfif listfind(attributes.process_type_detail,11)>selected</cfif>><cf_get_lang no ='1041.RMA Giriş'> </option>
                            <option value="12" <cfif listfind(attributes.process_type_detail,12)>selected</cfif>><cf_get_lang no ='1038.Sayım Sonuçları'></option>
                            <option value="13" <cfif listfind(attributes.process_type_detail,13)>selected</cfif>><cf_get_lang no ='1039.Dönem İçi Demontaja Giden'></option>
                            <option value="14" <cfif listfind(attributes.process_type_detail,14)>selected</cfif>><cf_get_lang_main  no = '1024.Dönem İçi Demontajdan Giriş'></option>
                                <cfquery name="get_process_cat_3" dbtype="query">
                                    SELECT * FROM GET_ALL_PROCESS_TYPES WHERE PROCESS_TYPE = 119
                                </cfquery>
                                <cfif get_process_cat_3.recordcount>
                                    <cfloop from="1" to="#get_process_cat_3.recordcount#" index="yy">
                                        <option value="14-#get_process_cat_3.process_type[yy]#-#get_process_cat_3.process_cat_id[yy]#" <cfif listfind(attributes.process_type_detail,'14-#get_process_cat_3.process_type[yy]#-#get_process_cat_3.process_cat_id[yy]#')>selected</cfif>>&nbsp;&nbsp;#get_process_cat_3.process_cat[yy]#</option>
                                    </cfloop>
                                </cfif>
                            <option value="15" <cfif listfind(attributes.process_type_detail,15)>selected</cfif>><cf_get_lang no ='1042.Masraf Fişleri'></option>
                            <option value="16" <cfif listfind(attributes.process_type_detail,16)>selected</cfif>><cf_get_lang no ='471.Depolararası Sevk İrsaliyesi'></option>
                            <option value="17" <cfif listfind(attributes.process_type_detail,17)>selected</cfif>><cf_get_lang_main no='1791.İthal Mal Girişi'></option>
                            <option value="18" <cfif listfind(attributes.process_type_detail,18)>selected</cfif>><cf_get_lang_main no='1833.Ambar Fişi'></option>
                            <option value="21" <cfif listfind(attributes.process_type_detail,21)>selected</cfif>><cf_get_lang_main no='1412.Stok Virman'></option>
                            <option value="22" <cfif listfind(attributes.process_type_detail,22)>selected</cfif>><cf_get_lang_main no='1838.Demirbaş Stok Fişi'></option>
                        </select>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td>
                                    <cfoutput>
                                        <cfif not session.ep.cost_display_valid>
                                        <input type="checkbox" name="display_cost" id="display_cost" onclick="control_cost_money()" value="1"<cfif isdefined('attributes.display_cost')>checked</cfif>>
                                        <cf_get_lang no ='365.Maliyet Göster'>
                                        </cfif>
                                        <!---<cfquery name="get_money" datasource="#dsn#">
                                            SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id#
                                        </cfquery>
                                        <cfif get_cost_type.inventory_calc_type eq 3>
                                            <input type="checkbox" name="display_cost_money" id="display_cost_money" value="1"<cfif isdefined('attributes.display_cost_money')>checked</cfif>>
                                            <cf_get_lang_main no ='383.İşlem Dövizli'>
                                            <select name="cost_money" id="cost_money" style="width:100" onclick="control_cost_money(this.value)">
                                                <cfloop query="get_money">
                                                    <option value="#MONEY#" <cfif attributes.cost_money is MONEY>selected</cfif>>#MONEY#</option>
                                                </cfloop>
                                            </select><br />
                                        </cfif>--->
                                        <input type="checkbox" name="from_invoice_actions" id="from_invoice_actions" value="1" <cfif isdefined('attributes.from_invoice_actions')>checked</cfif>><cfif isdefined("x_show_sale_inoice_cost") and x_show_sale_inoice_cost eq 1><cf_get_lang no='1045.Satış Faturası Miktarı-Tutarı'><cf_get_lang_main no='846.Maliyet'><cfelse><cf_get_lang no='1045.Satış Faturası Miktarı-Tutarı'></cfif>&nbsp;&nbsp;<!---secildiginde alış-satıs ve iade faturalarının tutarları gosterilir ---><br />
                                        <input type="checkbox" name="is_envantory" id="is_envantory" value="1" <cfif isdefined('attributes.is_envantory')>checked</cfif>><cf_get_lang no ='720.Envantere Dahil'>&nbsp;
                                        <cfif not session.ep.cost_display_valid><input type="checkbox" name="display_ds_prod_cost" id="display_ds_prod_cost" onclick="control_report_type();" value="1"<cfif isdefined('attributes.display_ds_prod_cost')>checked</cfif>>&nbsp;<cf_get_lang no ='1447.Dönem Sonu Birim Maliyet'>&nbsp;</cfif>
                                        <input type="checkbox" name="stock_age" id="stock_age" value="1" <cfif isdefined('attributes.stock_age')>checked</cfif>><cf_get_lang no ='426.Stok Yaşı'>&nbsp;
										<!---<cfif len(session.ep.money2)><!---sistem 2.para birimi cinsinden maliyetleri getirir --->
                                            <input type="checkbox" name="is_system_money_2" id="is_system_money_2" value="1" onclick="control_cost_money()" <cfif isdefined('attributes.is_system_money_2')>checked</cfif>><cf_get_lang no ='1444.Sistem 2 Para Br'>&nbsp;
                                        </cfif><br />--->
                                    </cfoutput>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <cf_basket_form_button>
                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
                <cf_workcube_buttons add_function='degistir_action()' is_upd='0' is_cancel='0' insert_info='#message#' insert_alert=''>
            </cf_basket_form_button>
        </cf_basket_form>
    </cfoutput>    
</cfform>
<cfif isdefined("attributes.is_form_submitted") and attributes.is_form_submitted eq 1 >
	<cfinclude template="../query/get_stock_analyse_new_excel.cfm">
</cfif>


