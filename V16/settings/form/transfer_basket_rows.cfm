<cfparam name="attributes.to_company" default="">
<cfparam name="attributes.from_company" default="">
<cfparam name="attributes.mode" default="3">
<cfquery name="get_our_company" datasource="#dsn#">
	SELECT COMP_ID,COMPANY_NAME FROM OUR_COMPANY ORDER BY COMP_ID
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='42210.Basket Şablonları'><cf_get_lang dictionary_id='43531.Aktarım'></cfsavecontent>
    <cf_box title="#title#">
        <cfform name="transfer_basket_rows" method="post" action="">
			<input type="hidden" name="is_submitted" id="is_submitted" value="">
            <cf_box_search>				
                <div class="form-group">
                    <select name="from_company" id="from_company" onChange="javascript:if(document.getElementById('from_company').value==document.getElementById('to_company').value){alert('Kaynak ve Hedef Şirketler Birbirinden Farklı Olmalıdır!');document.getElementById('from_company').value='';return false;};">
                        <option value=""><cf_get_lang dictionary_id='44613.Kaynak'></option>
                        <cfoutput query="get_our_company">
                            <option value="#comp_id#" <cfif attributes.from_company eq comp_id> selected</cfif>>#company_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="to_company" id="to_company" onChange="javascript:if(document.getElementById('from_company').value==document.getElementById('to_company').value){alert('Kaynak ve Hedef Şirketler Birbirinden Farklı Olmalıdır!');document.getElementById('to_company').value='';return false;};">
                        <option value=""><cf_get_lang dictionary_id='57951.Hedef'></option>
                        <cfoutput query="get_our_company">
                            <option value="#comp_id#" <cfif attributes.to_company eq comp_id> selected</cfif>>#company_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <cfif not isdefined("attributes.is_submitted")>
                    <div class="form-group">
                        <cfsavecontent variable="ButtonName"><cf_get_lang dictionary_id='57911.Çalıştır'></cfsavecontent>
                        <cf_workcube_buttons add_function='kontrol()' is_upd='0' is_cancel='0' insert_info='#ButtonName#'>
                    </div>
                </cfif>
                <div class="form-group">
                    <font color="FF0000">
                        <cf_get_lang dictionary_id='44935.Kaynak Kısmında Bilgilerin Nereden Alınacağı Seçilir'>.
                    </font>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfif isdefined("attributes.is_submitted") and len(attributes.from_company) and len(attributes.to_company)>
        <cfquery name="CHK_BASKET_ROW" datasource="#dsn#_#attributes.to_company#">
            SELECT 
                COUNT(*) CNT
            FROM
                SETUP_BASKET_ROWS
        </cfquery>
        <cfif chk_basket_row.cnt eq 0>
            <cflock timeout="100">
                <cftransaction>
                    <cfquery name="TRAN_BASKET" datasource="#dsn#">
                    INSERT INTO 
                        #dsn#_#attributes.to_company#.SETUP_BASKET
                        (
                            BASKET_ID,
                            B_TYPE,
                            PURCHASE_SALES,
                            AMOUNT_ROUND,
                            PRODUCT_SELECT_TYPE,
                            PRICE_ROUND_NUMBER,
                            BASKET_TOTAL_ROUND_NUMBER,
                            BASKET_RATE_ROUND_NUMBER,
                            USE_PROJECT_DISCOUNT,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE
                        )
                    SELECT 
                            BASKET_ID,
                            B_TYPE,
                            PURCHASE_SALES,
                            AMOUNT_ROUND,
                            PRODUCT_SELECT_TYPE,
                            PRICE_ROUND_NUMBER,
                            BASKET_TOTAL_ROUND_NUMBER,
                            BASKET_RATE_ROUND_NUMBER,
                            USE_PROJECT_DISCOUNT,
                            #session.ep.userid#,
                            '#cgi.remote_addr#',
                            #now()#			
                        FROM 
                        #dsn#_#attributes.from_company#.SETUP_BASKET
                        
                    </cfquery>
                    <cfquery name="TRAN_BASKET_ROW" datasource="#DSN#">
                        INSERT INTO 
                            #dsn#_#attributes.to_company#.SETUP_BASKET_ROWS
                            (
                                BASKET_ID,
                                TITLE_NAME,
                                LINE_ORDER_NO,
                                IS_SELECTED,
                                TITLE,
                                B_TYPE,
                                GENISLIK,
                                IS_READONLY
                            )
                        SELECT
                            BASKET_ID,
                            TITLE_NAME,
                            LINE_ORDER_NO,
                            IS_SELECTED,
                            TITLE,
                            B_TYPE,
                            GENISLIK,
                            IS_READONLY
                        FROM
                            #dsn#_#attributes.from_company#.SETUP_BASKET_ROWS
                    </cfquery>
                </cftransaction>
            </cflock>
        <cfelse>
            <script type="text/javascript">	
                alert('<cf_get_lang dictionary_id='63002.Bu Şirket İçin Basket Tanımları Daha Önce Yapılmıştır'> !');
                history.back();
            </script>
            <cfabort>
        </cfif>
        <cfquery name="GET_BASKET_ROWS" datasource="#dsn#_#attributes.to_company#">
            SELECT 
                TITLE_NAME,
                LINE_ORDER_NO,
                IS_SELECTED,
                TITLE,
                B_TYPE,
                GENISLIK,
                IS_READONLY
            FROM
                SETUP_BASKET_ROWS
        </cfquery>
        <cf_box>
            <cf_grid_list>
                <thead>
                    <tr>
                        <th width="75"><cf_get_lang dictionary_id='51766.Seçili Alanlar'></th>
                        <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th width="35"><cf_get_lang dictionary_id='39470.En'></th>
                        <th><cf_get_lang dictionary_id='42801.Basket Adı'></th>
                    </tr>
                    <cfoutput query="GET_BASKET_ROWS">
                        <tr>
                            <td><input type="checkbox" name="is_selected_#currentrow#" id="is_selected_#currentrow#"  disabled <cfif GET_BASKET_ROWS.is_selected eq 1>checked</cfif>></td>
                            <td>#LINE_ORDER_NO#</td>
                            <td>#GENISLIK#</td>
                            <td>#TITLE#</td>
                        </tr>
                    </cfoutput>
            </cf_grid_list>
        </cf_box>
    </cfif>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.getElementById('from_company').value == "" || document.getElementById('to_company').value == "")
	{
		alert("<cf_get_lang dictionary_id='44612.Kaynak ve Hedef Seçeneklerinden Size Uygun Olanları Seçiniz'>!");
		return false;
	}
	return true;
}
</script>
