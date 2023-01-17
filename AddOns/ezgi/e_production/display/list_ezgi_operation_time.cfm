<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.report_sort"  default="1">
<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_OPERATION_TIME" datasource="#dsn3#">
    	SELECT     
        	PT.STOCK_ID, 
            PT.OPERATION_TYPE_ID, 
            S.STOCK_CODE, 
            S.PRODUCT_NAME, 
            OT.OPERATION_TYPE, 
            OT.OPERATION_CODE, 
            ISNULL(EOOT.OPTIMUM_TIME,0) AS OPTIMUM_TIME, 
            EOOT.RECORD_EMP, 
            ISNULL(EOOT.STATUS, 1) AS STATUS, 
            ISNULL(EOOT.EZGI_OPERATION_OPTIMUM_TIME_ID,0) AS EZGI_OPERATION_OPTIMUM_TIME_ID
		FROM        
        	PRODUCT_TREE AS PT INNER JOIN
            STOCKS AS S ON PT.STOCK_ID = S.STOCK_ID INNER JOIN
           	OPERATION_TYPES AS OT ON PT.OPERATION_TYPE_ID = OT.OPERATION_TYPE_ID LEFT OUTER JOIN
          	EZGI_OPERATION_OPTIMUM_TIME AS EOOT ON PT.OPERATION_TYPE_ID = EOOT.OPERATION_TYPE_ID AND PT.STOCK_ID = EOOT.STOCK_ID
		WHERE     
        	PT.OPERATION_TYPE_ID IS NOT NULL AND 
            PT.STOCK_ID <> 0 AND 
            S.PRODUCT_STATUS = 1 AND 
            S.IS_PRODUCTION = 1
            <cfif len(attributes.keyword)>
            AND (
                S.STOCK_CODE LIKE '%#attributes.keyword#%' OR 
                S.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
                OT.OPERATION_TYPE LIKE '%#attributes.keyword#%'
            	)
            </cfif>
            <cfif len(attributes.is_active)>
            	AND ISNULL(EOOT.STATUS, 1) = #attributes.is_active#
            </cfif>
		ORDER BY 
        	<cfif attributes.report_sort eq 1>
            	S.PRODUCT_NAME,OT.OPERATION_TYPE
            <cfelse>
            	OT.OPERATION_TYPE,S.PRODUCT_NAME
            </cfif>
    </cfquery>
<cfelse>
	<cfset GET_OPERATION_TIME.recordcount=0>
</cfif>
<cfif not len(attributes.is_active)><cfset attributes.is_active = 1></cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#GET_OPERATION_TIME.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form" action="#request.self#?fuseaction=prod.list_ezgi_operation_time" method="post">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
    <cf_big_list_search title="<cfoutput>#getLang('main',3600)#</cfoutput>"> 
        <cf_big_list_search_area>
            <table>
                <tr>
                    <td><cf_get_lang_main no='48.Filtre'></td>
                    <td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </td>
                    
                    <td><cfoutput>#getLang('main',1512)#</cfoutput></td>
                    <td nowrap>
                        <select name="report_sort" id="report_sort" style="width:150px; height:20px">
                            <option value="1" <cfif attributes.report_sort eq 1>selected</cfif>><cfoutput>#getLang('main',809)#</cfoutput></option>
                            <option value="2" <cfif attributes.report_sort eq 2>selected</cfif>><cfoutput>#getLang('main',1622)#</cfoutput></option>
                        </select>
                    </td>
                    <td nowrap>
                        <select name="is_active" id="is_active" style="width:60px; height:20px">
                            <option value="2"><cf_get_lang_main no='296.Tümü'></option>
                            <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
                            <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
                        </select>
                    </td>
                    <td><cf_wrk_search_button></td>
                </tr>
            </table>
        </cf_big_list_search_area>
    </cf_big_list_search>
</cfform>
<cf_big_list> 
    <thead>
    	
        <tr>
            <th width="30" rowspan="2" style="text-align:center;"><cf_get_lang_main no='1165.Sıra'></th>
            <th width="100" rowspan="2" style="text-align:center;"><cf_get_lang_main no='106.Stok Kodu'></th>
            <th rowspan="2" style="text-align:center;"><cf_get_lang_main no='809.Ürün Adı' rowspan="2"></th>
            <th width="70" rowspan="2" style="text-align:center;"><cf_get_lang no='64.Operasyon Kodu'></th>
            <th width="90" rowspan="2" style="text-align:center;"><cf_get_lang_main no='388.İşlem Tipi'></th>
            <th width="100" rowspan="2" style="text-align:center;"><cf_get_lang_main no ='487.Kaydeden'></th>
            <th colspan="3" style="text-align:center;"><cfoutput>#getLang('prod',199)#</cfoutput></th>
            <th rowspan="2" style="text-align:center; width:70px"><cf_get_lang_main no ='3600.operasyon süreleri'> <br />(sn.)</th>
            <!-- sil --><th class="header_icn_none" rowspan="2"></th><!-- sil -->
        </tr>
        <tr>
        	<th width="20" style="text-align:center;">1.<cf_get_lang_main no='1622.Operasyon'></th>
            <th width="20" style="text-align:center;">2.<cf_get_lang_main no='1622.Operasyon'></th>
            <th width="20" style="text-align:center;">3.<cf_get_lang_main no='1622.Operasyon'></th>
        </tr>
    </thead>
    <tbody>
        <cfif GET_OPERATION_TIME.recordcount>
        <cfoutput query="GET_OPERATION_TIME" STARTROW="#attributes.startrow#" MAXROWS="#attributes.maxrows#">
        	<cfquery name="GET_LAST_OPTIMUM_TIME" datasource="#DSN3#">
            	SELECT        
                	TOP (3) 
                    CASE
                    	WHEN REAL_TIME >0 AND REAL_AMOUNT > 0
                    	THEN ROUND(REAL_TIME / REAL_AMOUNT, 0) 
                  		ELSE
                        	0
                   	END AS SURE,
                    P_ORDER_ID
				FROM            
                	EZGI_OPERATION_S
				WHERE        
                	REAL_TIME IS NOT NULL AND 
                    STOCK_ID = #STOCK_ID# AND OPERATION_TYPE_ID = #OPERATION_TYPE_ID#
				ORDER BY 
                	ACTION_START_DATE DESC
            </cfquery>
            <tr>
                <td>#CURRENTROW#</td>
                <td>#STOCK_CODE#</td>
                <td><a href="#request.self#?fuseaction=prod.add_product_tree&stock_id=#stock_id#" class="tableyazi">#product_name#</a></td>
                <td>#OPERATION_CODE#</td>
                <td>#OPERATION_TYPE#</td>
                <td>#get_emp_info(RECORD_EMP,0,0)#</td>
                <td style="text-align:center">
                	<cfif GET_LAST_OPTIMUM_TIME.recordcount>
                    	<a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#GET_LAST_OPTIMUM_TIME.P_ORDER_ID[1]#" class="tableyazi" target="_blank">#GET_LAST_OPTIMUM_TIME.SURE[1]#</a>
                    </cfif>
                </td>
                <td style="text-align:center">
                	<cfif GET_LAST_OPTIMUM_TIME.recordcount gt 1>
                    	<a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#GET_LAST_OPTIMUM_TIME.P_ORDER_ID[2]#" class="tableyazi" target="_blank">#GET_LAST_OPTIMUM_TIME.SURE[2]#</a>
                    </cfif>
               	</td>
                <td style="text-align:center">
                	<cfif GET_LAST_OPTIMUM_TIME.recordcount gt 2>
                    	<a href="#request.self#?fuseaction=prod.form_upd_prod_order&upd=#GET_LAST_OPTIMUM_TIME.P_ORDER_ID[3]#" class="tableyazi" target="_blank">#GET_LAST_OPTIMUM_TIME.SURE[3]#</a>
                    </cfif>
                </td>
                <td style="text-align:center">
                	<input name="input_time#CURRENTROW#" id="input_time#CURRENTROW#" value="#OPTIMUM_TIME#" class="box" style="width:30px; text-align:center" onChange="duzenle(#CURRENTROW#,#OPERATION_TYPE_ID#,#STOCK_ID#,#EZGI_OPERATION_OPTIMUM_TIME_ID#);">
                    <input type="hidden" id="operation_optimum_time#currentrow#" name="operation_optimum_time#currentrow#" value="#OPTIMUM_TIME#" /> 
                </td>
                
                <!-- sil -->
                <td align="center" width="15">
                	<span id="red_top#CURRENTROW#" style="display:none"><img src="/images/red_glob.gif" title="<cf_get_lang_main no='52.Düzenle'>" border="0"></span>
                    <span id="yellow_top#CURRENTROW#" style="display:none"><img src="/images/yellow_glob.gif" title="<cf_get_lang_main no='52.Düzenle'>" border="0"></span>
                    <span id="blue_top#CURRENTROW#" style="display:"><img src="/images/blue_glob.gif" title="#getLang('prod',98)#" border="0"></span>
                    <span id="green_top#CURRENTROW#" style="display:none"><img src="/images/green_glob.gif" title="<cf_get_lang_main no='52.Düzenle'>" border="0"></span>
                </td>
                <!-- sil -->
            </tr>
        </cfoutput>
         <tr>
        	<td colspan="11" style="text-align:right">
            	<input type="button" value="<cf_get_lang_main no='52.Güncelle'>" onclick="guncelle();" name="guncelle" id="guncelle">
          	</td>
      	</tr>
        <cfelse>
            <tr>
                <td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
            </tr>
        </cfif>
    </tbody>
</cf_big_list> 
<form name="aktar_form" method="post" action="<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_upd_ezgi_operation_optimum_time">
	<input type="hidden" name="keyw" value="<cfoutput>#attributes.keyword#</cfoutput>">
    <input type="hidden" name="active" value="<cfoutput>#attributes.is_active#</cfoutput>">
    <input type="hidden" name="convert_stocks_id" id="convert_stocks_id" value="">
    <input type="hidden" name="convert_operation_type_id" id="convert_operation_type_id" value="">
    <input type="hidden" name="convert_optimum_time" id="convert_optimum_time" value="">
    <input type="hidden" name="convert_operation_optimum_time_id" id="convert_operation_optimum_time_id" value="">
</form>
<cfset url_str = "">
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
    <cfif isdefined("attributes.form_submitted")>
        <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
    </cfif>
    <cfif isdefined ("attributes.is_active") and len(attributes.is_active)>
        <cfset url_str = "#url_str#&is_active=#attributes.is_active#">
    </cfif>
    <cfif isdefined('attributes.report_sort') and len(attributes.report_sort)>
		<cfset url_str = "#url_str#&report_sort=#attributes.report_sort#">
  	</cfif>
    <cf_paging page="#attributes.page#"
        maxrows="#attributes.maxrows#"
        totalrecords="#GET_OPERATION_TIME.recordcount#"
        startrow="#attributes.startrow#"
        adres="prod.list_ezgi_operation_time#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function duzenle(currentrow,operation_type_id,stock_id)
	{
		if(document.getElementById("input_time"+currentrow).value != document.getElementById("operation_optimum_time"+currentrow).value)
		{
			document.getElementById("green_top"+currentrow).style.display = '';	
			document.getElementById("blue_top"+currentrow).style.display = 'none';
		}
		else
		{
			document.getElementById("green_top"+currentrow).style.display = 'none';	
			document.getElementById("blue_top"+currentrow).style.display = '';
		}
	}
	function guncelle()
	{
		document.getElementById('guncelle').disabled=true;
		var convert_list_stock_id ="";
		var convert_list_operation_type_id ="";
		var convert_list_optimum_time ="";
		var convert_list_operation_optimum_time_id ="";
		<cfif isdefined("attributes.form_submitted")>
			<cfoutput query="GET_OPERATION_TIME" STARTROW="#attributes.startrow#" MAXROWS="#attributes.maxrows#">
					var sira = #currentrow#;
					if(document.getElementById("input_time"+sira).value != document.getElementById("operation_optimum_time"+sira).value)
					
					{
						convert_list_stock_id += "#STOCK_ID#,";
						convert_list_operation_type_id += "#OPERATION_TYPE_ID#,";
						convert_list_optimum_time += document.getElementById("input_time"+sira).value+',';
						convert_list_operation_optimum_time_id += "#EZGI_OPERATION_OPTIMUM_TIME_ID#,";
					}
			</cfoutput>
		</cfif>
		document.getElementById('convert_stocks_id').value = convert_list_stock_id.substr(0,convert_list_stock_id.length-1);
		document.getElementById('convert_operation_type_id').value = convert_list_operation_type_id.substr(0,convert_list_operation_type_id.length-1);
		document.getElementById('convert_optimum_time').value = convert_list_optimum_time.substr(0,convert_list_optimum_time.length-1);
		document.getElementById('convert_operation_optimum_time_id').value = convert_list_operation_optimum_time_id.substr(0,convert_list_operation_optimum_time_id.length-1);
		aktar_form.submit();
	}
</script>