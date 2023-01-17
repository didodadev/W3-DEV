<cf_get_lang_set module_name="credit"><!--- sayfanin en altinda kapanisi var --->
<cfparam name="attributes.keyword" default="">
<cfif isdefined('attributes.form_exist')>
    <cfquery name="GET_STOCKBOND" datasource="#dsn3#">
		SELECT 
			*,
			(SELECT SUM(ISNULL(STOCKBOND_IN,0))-SUM(ISNULL(STOCKBOND_OUT,0)) FROM STOCKBONDS_INOUT WHERE STOCKBONDS_INOUT.STOCKBOND_ID = STOCKBONDS.STOCKBOND_ID) AS NET_QUANTITY
		FROM 
			STOCKBONDS
		WHERE 
			STOCKBOND_ID IS NOT NULL 
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
				AND STOCKBOND_CODE LIKE '%#attributes.keyword#%'
			</cfif>
	</cfquery>
<cfelse>
	<cfset GET_STOCKBOND.recordcount = 0>	
</cfif>
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_STOCKBOND.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58240.Menkul Kıymetler'></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1" resize="0" collapsable="0">
            <cfform name="list_stockbonds" method="post" action="#request.self#?fuseaction=objects.popup_list_stockbonds">
                <cf_box_search more="0">
                        <input type="hidden" name="form_exist" id="form_exist" value="1">
                        <div class="form-group">
                            <div class="input-group">
                                <cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                                <cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">        
                            </div>
                        </div>
                        <div class="form-group">
                            <cf_wrk_search_button button_type="4">
                            <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                        </div>
                </cf_box_search>
            </cfform>
            <!-- sil -->
            <cf_grid_list>
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id ='57487.No'></th>
                        <th><cf_get_lang dictionary_id ='57630.Tip'></th>
                        <th><cf_get_lang dictionary_id ='58585.Kod'></th>
                        <th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
                        <th><cf_get_lang dictionary_id ='57635.Miktar'></th>
                        <th><cf_get_lang dictionary_id ='51409.Nominal Değer'></th>	
                        <th><cf_get_lang dictionary_id ='51410.Nominal Değer Döviz'></th>	
                        <th><cf_get_lang dictionary_id ='51411.Alış Değer'></th>	
                        <th><cf_get_lang dictionary_id ='51412.Alış Değer Döviz'></th>	
                        <th><cf_get_lang dictionary_id ='51413.Güncel Değer'></th>	
                        <th><cf_get_lang dictionary_id ='51414.Güncel Değer Döviz'></th>	
                    </tr>
                </thead>
                <tbody>
                    <cfif get_stockbond.recordcount>
                    <cfset stockbond_type_list=''>
                    <cfset expense_id_list=''>
                    <cfset expense_item_list=''>
                    <cfoutput query="get_stockbond" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif len(stockbond_type) and not listfind(stockbond_type_list,stockbond_type)>
                                <cfset stockbond_type_list=listappend(stockbond_type_list,stockbond_type)>
                            </cfif>
                    </cfoutput>
                    <cfoutput query="get_stockbond" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif len(row_exp_center_id) and not listfind(expense_id_list,row_exp_center_id)>
                                <cfset expense_id_list=listappend(expense_id_list,row_exp_center_id)>
                            </cfif>
                    </cfoutput>
                    <cfoutput query="get_stockbond" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfif len(row_exp_item_id) and not listfind(expense_item_list,row_exp_item_id)>
                                <cfset expense_item_list=listappend(expense_item_list,row_exp_item_id)>
                            </cfif>
                    </cfoutput>
                    <cfset stockbond_type_list=listsort(listdeleteduplicates(stockbond_type_list,','),'Numeric','ASC',',')>
                    <cfset expense_id_list=listsort(listdeleteduplicates(expense_id_list,','),'Numeric','ASC',',')>
                    <cfset expense_item_list=listsort(listdeleteduplicates(expense_item_list,','),'Numeric','ASC',',')>
                    <cfif listlen(stockbond_type_list)>
                        <cfquery name="GET_STOCKBOND_TYPES" datasource="#DSN#">
                            SELECT
                                STOCKBOND_TYPE_ID,
                                STOCKBOND_TYPE
                            FROM 
                                SETUP_STOCKBOND_TYPE
                            WHERE
                                STOCKBOND_TYPE_ID IN (#stockbond_type_list#)
                            ORDER BY
                                STOCKBOND_TYPE_ID
                        </cfquery>
                    </cfif>
                    <cfif listlen(expense_id_list)>
                    <cfquery name="GET_EXPENSE_CENTER" datasource="#dsn2#">
                        SELECT 
                            EXPENSE_ID,
                            EXPENSE_CODE, 
                            EXPENSE 
                        FROM 
                            EXPENSE_CENTER 
                        WHERE 
                            EXPENSE_ID IN (#expense_id_list#)
                        ORDER BY
                            EXPENSE_ID
                    </cfquery>
                    </cfif>
                    <cfif listlen(expense_item_list)>
                    <cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
                        SELECT 
                            EXPENSE_ITEM_ID,
                            EXPENSE_ITEM_NAME 
                        FROM 
                            EXPENSE_ITEMS 
                        WHERE
                            IS_EXPENSE = 1 AND EXPENSE_ITEM_ID IN (#expense_item_list#)
                        ORDER BY
                            EXPENSE_ITEM_ID
                    </cfquery>
                    </cfif>
                    </cfif>
                    <cfif isdefined("attributes.form_exist") and GET_STOCKBOND.RECORDCOUNT>
                        <cfoutput query="GET_STOCKBOND" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr>
                                <td>#currentrow#</td>
                                <td><a href="javascript://" class="tableyazi" onclick="gonder('#stockbond_id#','#get_stockbond_types.STOCKBOND_TYPE[listfind(stockbond_type_list,stockbond_type,',')]#','#STOCKBOND_CODE#','#detail#','#NET_QUANTITY#','#TLFormat(NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#dateformat(due_date,dateformat_style)#'<cfif len(expense_id_list)>,'#GET_EXPENSE_CENTER.EXPENSE[listfind(expense_id_list,row_exp_center_id,',')]#'<cfelse>,''</cfif><cfif len(expense_item_list)>,'#GET_EXPENSE_ITEM.EXPENSE_ITEM_NAME[listfind(expense_item_list,row_exp_item_id,',')]#'<cfelse>,''</cfif>);">#get_stockbond_types.STOCKBOND_TYPE[listfind(stockbond_type_list,stockbond_type,',')]#</a></td>
                                <td><a href="javascript://" class="tableyazi" onclick="gonder('#stockbond_id#','#get_stockbond_types.STOCKBOND_TYPE[listfind(stockbond_type_list,stockbond_type,',')]#','#STOCKBOND_CODE#','#detail#','#NET_QUANTITY#','#TLFormat(NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#dateformat(due_date,dateformat_style)#'<cfif len(expense_id_list)>,'#GET_EXPENSE_CENTER.EXPENSE[listfind(expense_id_list,row_exp_center_id,',')]#'<cfelse>,''</cfif><cfif len(expense_item_list)>,'#GET_EXPENSE_ITEM.EXPENSE_ITEM_NAME[listfind(expense_item_list,row_exp_item_id,',')]#'<cfelse>,''</cfif>);">#STOCKBOND_CODE#</a></td>
                                <td><a href="javascript://" class="tableyazi" onclick="gonder('#stockbond_id#','#get_stockbond_types.STOCKBOND_TYPE[listfind(stockbond_type_list,stockbond_type,',')]#','#STOCKBOND_CODE#','#detail#','#NET_QUANTITY#','#TLFormat(NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#','#dateformat(due_date,dateformat_style)#'<cfif len(expense_id_list)>,'#GET_EXPENSE_CENTER.EXPENSE[listfind(expense_id_list,row_exp_center_id,',')]#'<cfelse>,'' </cfif><cfif len(expense_item_list)>,'#GET_EXPENSE_ITEM.EXPENSE_ITEM_NAME[listfind(expense_item_list,row_exp_item_id,',')]#'<cfelse>,''</cfif>);">#detail#</a></td>
                                <td>#NET_QUANTITY#</td>
                                <td style="text-align:right;">#TLFormat(NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#</td>
                                <td style="text-align:right;">#TLFormat(OTHER_NOMINAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#</td>
                                <td style="text-align:right;">#TLFormat(PURCHASE_VALUE,'#session.ep.our_company_info.rate_round_num#')#</td>
                                <td style="text-align:right;">#TLFormat(OTHER_PURCHASE_VALUE,'#session.ep.our_company_info.rate_round_num#')#</td>
                                <td style="text-align:right;">#TLFormat(ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#</td>
                                <td style="text-align:right;">#TLFormat(OTHER_ACTUAL_VALUE,'#session.ep.our_company_info.rate_round_num#')#</td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="11"><cfif isdefined("attributes.form_exist")><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
            <cfif attributes.totalrecords gt attributes.maxrows>
                <cfset adres="form_exist=1">
                <table width="99%" align="center">
                    <tr>
                        <td>
                            <cf_pages 
                            page="#attributes.page#" 
                            maxrows="#attributes.maxrows#" 
                            totalrecords="#attributes.totalrecords#" 
                            startrow="#attributes.startrow#" 
                            adres="objects.popup_list_stockbonds&#adres#">
                        </td>
                        <!-- sil -->
                        <td style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
                        <!-- sil -->
                    </tr>
                </table>
            </cfif>
    </cf_box>
</div>
<script language="javascript">
	function gonder(stockbond_id,bond_type,bond_code,detail,quantity,nominal_value,other_nominal_value,sale_value,other_sale_value,total_sale,other_total_sale,due_date,expense_center_name,expense_item_name){
        var kontrol = false;
        if( typeof( window.opener.document.getElementById("record_num") ) != 'undefined' && parseInt(window.opener.document.getElementById("record_num").value) > 0 ){
            for(tt = 1; tt <= window.opener.document.getElementById("record_num").value; tt++){
                if( typeof( window.opener.document.getElementById('stockbond_id'+tt) ) != 'undefined' && window.opener.document.getElementById('stockbond_id'+tt) != null && stockbond_id == window.opener.document.getElementById('stockbond_id'+tt).value ){
                    kontrol = true;
                    break;
                }
            }
        }
		if (kontrol == true){
			alert("<cf_get_lang dictionary_id='60141.Aynı Menkul Kıymeti Seçmeye Çalışıyorsunuz'>!");
			return false;
		}else opener.gonder(stockbond_id,bond_type,bond_code,detail,quantity,nominal_value,other_nominal_value,sale_value,other_sale_value,total_sale,other_total_sale,due_date,expense_center_name,expense_item_name);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->

