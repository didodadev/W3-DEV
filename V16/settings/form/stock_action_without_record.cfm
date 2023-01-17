<!--- Islemi Olmayan Stok Hareketlerini Goruntuler, Silme Imkani Saglar Hgul 20150113 --->
<cfparam name="attributes.islem_id" default="">
<cfparam name="attributes.process_type" default="">
<cfparam name="attributes.process_cat" default="">

<cfif isdefined("attributes.upd_id") and len(attributes.upd_id) and attributes.kontrol_form eq 1>
	<cfquery name="del_stocks_row" datasource="#dsn2#">
		DELETE FROM STOCKS_ROW WHERE UPD_ID = #attributes.upd_id#
	</cfquery>   
	<cflocation url="#request.self#?fuseaction=settings.stock_action_without_record" addtoken="no">	
</cfif>  
<cfquery name="GET_PROCESS_CAT" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PROCESS_CAT      
</cfquery>      
<cfif isdefined("attributes.form_submitted")>
    <cfquery name="get_all_stocks_row" datasource="#dsn2#">
        <!--- ACTION_TABLE='INVOICE' --->
        SELECT DISTINCT
            'FATURA' AS TYPE,
            UPD_ID,
            PROCESS_TYPE,
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE
        FROM
            STOCKS_ROW WITH (NOLOCK),
            #dsn3_alias#.STOCKS
        WHERE	
            STOCKS_ROW.STOCK_ID = STOCKS.STOCK_ID
            AND PROCESS_TYPE IN (52,53,54,55,59,62,64,65,66,69,690,691,591,592,531,532)
            AND UPD_ID NOT IN(SELECT INVOICE_ID FROM INVOICE WITH (NOLOCK))
            <cfif len(attributes.islem_id)>
                 AND UPD_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.islem_id#">
            </cfif>
            <cfif len(attributes.process_type) and len(process_cat)>
                 AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_type#">
            </cfif>
        UNION ALL
        <!--- SHIP --->
        SELECT DISTINCT
            'IRSALIYE' AS TYPE,
            UPD_ID,
            PROCESS_TYPE,
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE
        FROM
            STOCKS_ROW WITH (NOLOCK),
            #dsn3_alias#.STOCKS
        WHERE	
            STOCKS_ROW.STOCK_ID = STOCKS.STOCK_ID
            AND PROCESS_TYPE IN (70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,88,811,761)
            AND UPD_ID NOT IN(SELECT SHIP_ID FROM SHIP WITH (NOLOCK))
            <cfif len(attributes.islem_id)>
                 AND UPD_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.islem_id#">
            </cfif>
            <cfif len(attributes.process_type) and len(process_cat)>
                 AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_type#">
            </cfif>
        UNION ALL
        <!--- STOCK_FIS --->
        SELECT DISTINCT
            'STOK_FISI' AS TYPE,
            UPD_ID,
            PROCESS_TYPE,
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE
        FROM
            STOCKS_ROW WITH (NOLOCK),
            #dsn3_alias#.STOCKS
        WHERE	
            STOCKS_ROW.STOCK_ID = STOCKS.STOCK_ID
            AND PROCESS_TYPE IN (110,111,112,113,114,115,118,1131,1182)
            AND UPD_ID NOT IN(SELECT FIS_ID FROM STOCK_FIS WITH (NOLOCK))
            <cfif len(attributes.islem_id)>
                 AND UPD_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.islem_id#">
            </cfif>
            <cfif len(attributes.process_type) and len(process_cat)>
                 AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_type#">
            </cfif>
        UNION ALL
        <!--- PRODUCTION_ORDER_RESULTS --->
        SELECT DISTINCT
            'ÜRETİM SONUCU' AS TYPE,
            UPD_ID,
            PROCESS_TYPE,
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE
        FROM
            STOCKS_ROW WITH (NOLOCK),
            #dsn3_alias#.STOCKS
        WHERE	
            STOCKS_ROW.STOCK_ID = STOCKS.STOCK_ID
            AND PROCESS_TYPE IN (171)
            AND UPD_ID NOT IN(SELECT PRODUCTION_ORDER_RESULTS.PR_ORDER_ID FROM #dsn3_alias#.PRODUCTION_ORDER_RESULTS WITH (NOLOCK))
            AND UPD_ID <> 0	
            <cfif len(attributes.islem_id)>
                 AND UPD_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.islem_id#">
            </cfif>
            <cfif len(attributes.process_type) and len(process_cat)>
                 AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_type#">
            </cfif>
        UNION ALL
        <!--- ACTION_TABLE='EXPENSE_ITEM_PLANS' --->
        SELECT DISTINCT
            'MASRAF - GELİR FİŞİ' AS TYPE,
            UPD_ID,
            PROCESS_TYPE,
            STOCKS.STOCK_ID,
            STOCKS.PRODUCT_ID,
            STOCKS.STOCK_CODE
        FROM
            STOCKS_ROW WITH (NOLOCK),
            #dsn3_alias#.STOCKS
        WHERE	
            STOCKS_ROW.STOCK_ID = STOCKS.STOCK_ID
            AND PROCESS_TYPE IN (120,121,122)
            AND UPD_ID NOT IN(SELECT EXPENSE_ITEM_PLANS.EXPENSE_ID FROM EXPENSE_ITEM_PLANS WITH (NOLOCK))
            <cfif len(attributes.islem_id)>
                 AND UPD_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.islem_id#">
            </cfif>
            <cfif len(attributes.process_type) and len(process_cat)>
                 AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.process_type#">
            </cfif>
        ORDER BY
            STOCKS.STOCK_CODE
    </cfquery>
<cfelse>
	<cfset get_all_stocks_row.recordcount = 0>
</cfif>
<cfform name="rapor" action="#request.self#?fuseaction=settings.stock_action_without_record" method="post">
	<cfset irsaliye_tipleri = '70,71,72,73,74,75,76,77,78,79,80,81,87,811,761,84,85,86,88,140,141'>
	<input name="kontrol_form" id="kontrol_form" value="0" type="hidden">
	<input name="upd_id" id="upd_id" value="" type="hidden">
    <input type="hidden" name="form_submitted" value="1" />
    <cf_big_list_search title="Belgesi Olmayan Stok Hareketleri" >
    <cf_big_list_search_area>     
    <table>
        <tr>
            <td width="50px">İşlem Id</td>
            <td> <cfinput type="text" name="islem_id" id="islem_id" value="#attributes.islem_id#" style="width:50px;" /></td>   &nbsp;&nbsp;&nbsp;&nbsp;     
            <td width="50px">İşlem Tipi</td>
            <td colspan="2">
                <cfinput type="hidden" id="process_type" name="process_type" value="#attributes.process_type#"/>
                <cfinput maxlength="100" value="#attributes.process_cat#" type="text" name="process_cat" style="width:160px;">
                <a href="javascript://"	onclick="windowopen('index.cfm?fuseaction=settings.popup_list_process_types&field_id=rapor.process_type&field_name=rapor.process_cat','list');"><img align="absmiddle" alt="İşlem Kategorisi Seçiniz" src="images/plus_thin.gif" border="0"></a>
            </td>      
            <td align="left" width="50px">				
                        &nbsp;&nbsp;<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
                        <cf_workcube_buttons is_upd='0' add_function='control()' is_cancel='0' insert_info='#message#' insert_alert=''>
            </td>  
                      <td>
                     </td>    
        </tr>
    </table>  
     </cf_big_list_search_area>
    </cf_big_list_search> 
    <cf_big_list>         
	<thead>
		<tr> 
			<th style="width:30px;">No</th>
			<th>İşlem</th>
			<th>İşlem Id</th>
			<th>İşlem Tipi</th>
            <th>Stok Kodu</th>
			<th style="width:20px;">&nbsp;</th>
		</tr>
     </thead>
     <tbody>
        <cfset upd_id_list=''>
		<cfif get_all_stocks_row.recordcount>
			<cfoutput query="get_all_stocks_row">
                <cfif listfind(irsaliye_tipleri,get_all_stocks_row.process_type,",")>
					<cfif not listfind(upd_id_list,get_all_stocks_row.upd_id)>
						<cfset upd_id_list = listappend(upd_id_list,get_all_stocks_row.upd_id)>
					</cfif>
                </cfif>
				<tr>
					<td>#currentrow#</td>
					<td>
                    	<!--- <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=account.popup_list_card_rows&upd_id=#upd_id#','page_horizantal');">#upd_id#</a> --->
						<cfif listfind(irsaliye_tipleri,process_type,",") and len(upd_id_list) and not listfind("70,71,72,78,79,85,88,141",process_type,",")>
                            <cfswitch expression="#process_type#">
                                <cfcase value="761">
                                    <cfset url_param="#request.self#?fuseaction=stock.upd_marketplace_ship&ship_id=">
                                </cfcase>
                                <cfcase value="82">
                                    <cfset url_param = "#request.self#?fuseaction=invent.upd_purchase_invent&ship_id=">
                                </cfcase>
                                <cfcase value="81">
                                    <cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset url_param = "#request.self#?fuseaction=stock.form_add_purchase&event=upd&ship_id=">
                                </cfdefaultcase>
                            </cfswitch>
                        <cfelseif not listfind("110,111,112,113,114,115,116,117,118,1182",process_type,",")>
                            <cfswitch expression="#process_type#">
                                <cfcase value="81">
                                    <cfset url_param = "#request.self#?fuseaction=stock.add_ship_dispatch&event=upd&ship_id=">
                                </cfcase>
                                <cfcase value="811">
                                    <cfset url_param="#request.self#?fuseaction=stock.upd_stock_in_from_customs&ship_id=">
                                </cfcase>
                                <cfcase value="83">
                                    <cfset url_param = "#request.self#?fuseaction=invent.upd_invent_sale&ship_id=">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset url_param = "#request.self#?fuseaction=stock.form_add_sale&event=upd&ship_id=">
                                </cfdefaultcase>
                            </cfswitch>				
                        <cfelse>
                            <cfswitch expression="#process_type#">
                                <cfcase value="114">
                                    <cfset url_param="#request.self#?fuseaction=stock.form_add_open_fis&event=upd&upd_id=">
                                </cfcase>
                                <cfcase value="118">
                                    <cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis&fis_id=">
                                </cfcase>
                                <cfcase value="1182">
                                    <cfset url_param="#request.self#?fuseaction=invent.upd_invent_stock_fis_return&fis_id=">
                                </cfcase>
                                <cfcase value="116">
                                    <cfset url_param="#request.self#?fuseaction=stock.form_upd_stock_exchange&exchange_id=">
                                </cfcase>
                                <cfcase value="117">
                                    <cfset url_param="#request.self#?fuseaction=pos.list_fileimports_total_sayim&start_date=#dateformat(process_date,dateformat_style)#">
                                </cfcase>
                                <cfdefaultcase>
                                    <cfset url_param="#request.self#?fuseaction=stock.form_add_fis&event=upd&upd_id=">
                                </cfdefaultcase>
                            </cfswitch>
                        </cfif>
                        <cfif process_type eq 117>
                            <a href="#url_param#" class="tableyazi" target="_blank">#process_type# - #get_process_name(process_type)#</a>
                        <cfelse>
                            <a href="#url_param##get_all_stocks_row.upd_id#" class="tableyazi" target="_blank">#process_type# - #get_process_name(process_type)#</a>
                        </cfif>
                    </td>
                    <td>#UPD_ID#</td>
					<td>#type#</td>
                    <td>#STOCK_CODE#</td>
					<td style="text-align:center;"><a href="javascript://" onClick="sil('#upd_id#');"><img  src="images/delete_list.gif" border="0"></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="7">Kayıt Yok !</td>
			</tr>
		</cfif>
    </tbody>
   </cf_big_list>
</cfform>
<script language="javascript">
	function sil(upd_id)
	{
		if(confirm("İşleme Ait Stok Hareketi Silinecektir. Emin misiniz?"))
		{			
			document.all.kontrol_form.value = 1;
			document.all.upd_id.value = upd_id;
			document.rapor.submit();
			document.all.kontrol_form.value = 0;
			alert('Silme İşlemi Tamamlandı.');
		}
		
	}
</script>
