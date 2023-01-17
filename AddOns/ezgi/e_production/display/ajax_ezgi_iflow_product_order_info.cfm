<cfif isdefined('attributes.department_id')>
	<cfquery name="get_op_out" datasource="#dsn3#">
    	SELECT 
        	DEFAULT_PACKAGE_OPERATION_TYPE_ID AS P_ID, 
            DEFAULT_MAIN_OPERATION_TYPE_ID AS M_ID
		FROM            
        	EZGI_DESIGN_DEFAULTS
    </cfquery>
	<cfquery name="get_product" datasource="#dsn3#">
    	SELECT 
            * ,
            (SELECT DESIGN_MAIN_NAME FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID = EZGI_DESIGN_PIECE.DESIGN_MAIN_ROW_ID) as DESIGN_MAIN_NAME,
            (SELECT PACKAGE_NUMBER FROM EZGI_DESIGN_PACKAGE WHERE PACKAGE_ROW_ID = EZGI_DESIGN_PIECE.DESIGN_PACKAGE_ROW_ID) as PACKAGE_NUMBER,
            (SELECT PROPERTY_DETAIL FROM #dsn1_alias#.PRODUCT_PROPERTY_DETAIL WHERE PROPERTY_DETAIL_ID = EZGI_DESIGN_PIECE.KALINLIK) AS KALINLIK_,
            (SELECT COLOR_NAME FROM EZGI_COLORS WHERE COLOR_ID = EZGI_DESIGN_PIECE.PIECE_COLOR_ID) AS RENK
        FROM 
            EZGI_DESIGN_PIECE 
        WHERE
        	PIECE_TYPE <> 4
        	<cfif attributes.product_type eq 2>
       			AND DESIGN_MAIN_ROW_ID = 
                						(
                                        	SELECT TOP (1)       
                                                DESIGN_MAIN_ROW_ID 
                                            FROM            
                                                EZGI_DESIGN_MAIN_ROW
                                            WHERE        
                                                DESIGN_MAIN_RELATED_ID = #attributes.sid#
                                        )	
                
        	<cfelseif attributes.product_type eq 3>
       			AND DESIGN_PACKAGE_ROW_ID = 
                						(
                                        	SELECT  TOP (1)      
                                                PACKAGE_ROW_ID
                                            FROM            
                                                EZGI_DESIGN_PACKAGE
                                            WHERE        
                                                PACKAGE_RELATED_ID = #attributes.sid#
                                        )
        	<cfelseif attributes.product_type eq 4>
       			AND PIECE_ROW_ID = 
                						(
                                        	SELECT TOP (1)       
                                                PIECE_ROW_ID
                                            FROM            
                                                EZGI_DESIGN_PIECE
                                            WHERE        
                                                PIECE_RELATED_ID = #attributes.sid#
                                        )
         	</cfif>	
        ORDER BY
        	PACKAGE_NUMBER,
            PIECE_CODE desc
    </cfquery>
    <cfset piece_id_list = ValueList(get_product.PIECE_ROW_ID)>
    <cfif ListLen(piece_id_list)>
        <cfquery name="get_piece_operations" datasource="#dsn3#">
            SELECT 
            	PIECE_ROW_ID, 
                OPERATION_TYPE_ID, 
                SUM(AMOUNT) AS AMOUNT, 
                COUNT(*) AS SAYI 
           	FROM 
            	EZGI_DESIGN_PIECE_ROTA 
          	WHERE 
            	PIECE_ROW_ID IN (#piece_id_list#) 
          	GROUP BY 
            	PIECE_ROW_ID, 
                OPERATION_TYPE_ID 
        </cfquery>
        <cfoutput query="get_piece_operations">
            <cfset 'AMOUNT_#PIECE_ROW_ID#_#OPERATION_TYPE_ID#' = AMOUNT>
            <cfset 'SAYI_#PIECE_ROW_ID#_#OPERATION_TYPE_ID#' = SAYI>
        </cfoutput>
    </cfif>
    <cfquery name="get_operations" datasource="#dsn3#">
    	SELECT        
        	OPERATION_TYPE_ID, 
            OPERATION_TYPE, 
            OPERATION_CODE
		FROM            
        	OPERATION_TYPES
		WHERE  
        	<cfif len(get_op_out.M_ID)>
        		OPERATION_TYPE_ID <> #get_op_out.M_ID# AND
            </cfif> 
            <cfif len(get_op_out.P_ID)>
        		OPERATION_TYPE_ID <> #get_op_out.P_ID# AND
            </cfif>
        	IS_VIRTUAL = 0 AND 
            OPERATION_STATUS = 1 AND 
            OPERATION_TYPE_ID IN
                             	(
                                	SELECT        
                                    	OPERATION_TYPE_ID
                               		FROM            
                                    	WORKSTATIONS_PRODUCTS
                               		WHERE        
                                    	WS_ID IN
                                            	(
                                                	SELECT        
                                                		STATION_ID
                                                  	FROM            
                                                    	WORKSTATIONS
                                                 	WHERE        
                                                    	DEPARTMENT = #attributes.department_id# AND 
                                                        ACTIVE = 1 AND
                                                 		OPERATION_TYPE_ID IS NOT NULL
                                            	)
       							)
		ORDER BY 
        	OPERATION_CODE
    </cfquery>
<cfelse>
	<cfset get_operations.recordcount = 0>
</cfif>
<table class="detail_basket_list" width="100%">
 	<thead>
    	<tr valign="middle">
        	<th style="vertical-align:middle; text-align:center; width:20px"></th>
          	<th style="height:20px;vertical-align:middle;text-align:center; width:350px"><cf_get_lang_main no='3202.Parça Adı'></th>
            <th style="vertical-align:middle;text-align:center; width:50px"><cf_get_lang_main no='223.Miktar'></th>
            <th style="vertical-align:middle;text-align:center; width:30px"></th>
            <th style="vertical-align:middle;text-align:center; width:60px"><cf_get_lang_main no='2902.Boy'></th>
            <th style="vertical-align:middle;text-align:center; width:60px"><cf_get_lang_main no='2901.En'></th>
            <th style="vertical-align:middle;text-align:center; width:60px"><cf_get_lang_main no='2878.Kalınlık'></th>
            <th style="vertical-align:middle;text-align:center; width:160px"><cf_get_lang_main no='3002.Renk'></th>
            <th style="vertical-align:middle;text-align:center; width:60px"><cf_get_lang_main no='3203.Paket No'></th>
        	<cfoutput query="get_operations">
            	<th style="height:25px;text-align:center;vertical-align:middle;width:35px;" title="#OPERATION_type#">#OPERATION_CODE#</th>
        	</cfoutput>
            <th></th>
     	</tr>           
  	</thead>
    <tbody>
    	<cfif get_product.recordcount>
        	<cfoutput query="get_product">
                <tr>            
                    <td style="text-align:center; height:15px">
                    	<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=prod.popup_upd_ezgi_product_tree_creative_piece_rota&piece_id=#piece_row_id#&master_plan_id=#attributes.master_plan_id#','small');"><img src="/images/action.gif" border="0" title="<cf_get_lang_main no='3204.İlişkili Operasyonlar'>" style="vertical-align:top" ></a>
                    </td>
                    <td style="text-align:left;">&nbsp;#PIECE_NAME#</td>
                    <td style="text-align:center;">&nbsp;#PIECE_AMOUNT#</td>
                    <td style="text-align:center;">
                    	<cfif PIECE_TYPE eq 1>
                            <img src="/images/butcegider.gif" title="<cf_get_lang_main no='2865.Yonga Levha'>">
                        <cfelseif PIECE_TYPE eq 2>
                            <img src="/images/arrow_up.png" title="<cf_get_lang_main no='3205.Genel Reçete'>">
                        <cfelseif PIECE_TYPE eq 3>
                            <img src="/images/elements.gif" title="<cf_get_lang_main no='3206.Montaj Ürünü'>">
                        <cfelseif PIECE_TYPE eq 4>
                            <img src="/images/promo_multi.gif" title="<cf_get_lang_main no='3207.Hammadde'>">
                        </cfif>
                    </td>
                    <td style="text-align:center;">#BOYU#</td>
                    <td style="text-align:center;">#ENI#</td>
                    <td style="text-align:center;">#KALINLIK_#</td>
                    <td style="text-align:left;">&nbsp;#RENK#</td>
                    <td style="text-align:center;">#PACKAGE_NUMBER#</td>
                    <cfloop query="get_operations">
                    	<input type="hidden" id="control_buton_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" value="0" />
                    	<cfif isdefined('AMOUNT_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#')>
                         	<td id="operation_display_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" style="text-align:center;<cfif Evaluate('SAYI_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#') eq 1>background-color:lightGray<cfelse>background-color:Silver</cfif>;color:black" title="#OPERATION_type#">
                            	<cfif Evaluate('SAYI_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#') eq 1>
                           		<a style="cursor:pointer" href="javascript://" onClick="operation_display(#get_product.PIECE_ROW_ID#,#get_operations.OPERATION_TYPE_ID#);">
                            		#Evaluate('AMOUNT_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#')#
                             	</a>
                                <cfelse>
                                	#Evaluate('AMOUNT_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#')#
                                </cfif>
                        	</td>
                         	<td id="operation_input_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" style="text-align:center;background-color:lightGray;color:black;display:none" title="#OPERATION_type#">
                             	<a style="cursor:pointer" href="javascript://" onClick="operation_input(#get_product.PIECE_ROW_ID#,#get_operations.OPERATION_TYPE_ID#);">
                                    <input type="text" name="amount_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" id="amount_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" value="" style="width:30px; text-align:right" />
                             	</a>
                         	</td>
                  		<cfelse>
                        	<td id="operation_display_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" style="text-align:center;" title="#OPERATION_type#">
                           		<a style="cursor:pointer" href="javascript://" onClick="operation_display(#get_product.PIECE_ROW_ID#,#get_operations.OPERATION_TYPE_ID#);">
                            		0
                             	</a>
                        	</td>
                         	<td id="operation_input_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" style="text-align:center;display:none" title="#OPERATION_type#">
                             	<a style="cursor:pointer" href="javascript://" onClick="operation_input(#get_product.PIECE_ROW_ID#,#get_operations.OPERATION_TYPE_ID#);">
                                    <input type="text" name="amount_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" id="amount_#get_product.PIECE_ROW_ID#_#get_operations.OPERATION_TYPE_ID#" value="" style="width:30px; text-align:right" />
                             	</a>
                         	</td>
                        </cfif>
                    </cfloop>
                    <td></td>
                </tr>
        	</cfoutput>
      	</cfif>
   	</tbody>
    <tfoot>
    	<cfset col_span = get_operations.recordcount+10>
    	<tr style="height:25px">
            <td style="text-align:right; vertical-align:middle" colspan="<cfoutput>#col_span#</cfoutput>">
            	<!---<a style="cursor:pointer" onclick="operation_upd_button();">
                  	<button type="button" name="operation_upd_button" style="width:100px; font-size:10px; font-weight:bold;height:25px">
                      	<img src="/images/enabled.gif" alt="Güncelle" border="0"> Güncelle
                  	</button>
            	</a>--->
            </td>
        </tr>
    </tfoot>
</table>
<script language="javascript">
	function operation_display(piece_row_id,operation_type_id)
	{
		document.getElementById('operation_display_'+piece_row_id+'_'+operation_type_id).style.display = 'none';
		document.getElementById('operation_input_'+piece_row_id+'_'+operation_type_id).style.display = '';
		document.getElementById('control_buton_'+piece_row_id+'_'+operation_type_id).value = 1;
		document.getElementById('amount_'+piece_row_id+'_'+operation_type_id).focus();
	}
	function operation_input(piece_row_id,operation_type_id)
	{
		document.getElementById('operation_display_'+piece_row_id+'_'+operation_type_id).style.display = '';
		document.getElementById('operation_input_'+piece_row_id+'_'+operation_type_id).style.display = 'none';
		document.getElementById('control_buton_'+piece_row_id+'_'+operation_type_id).value = 0;
	}
	function operation_upd_button()
	{
		p_operation_id_list = '';
		<cfoutput query="get_product">
			<cfloop query="get_operations">
				piece_row_id = #get_product.piece_row_id#;
				operation_type_id = #get_operations.operation_type_id#;
				operation_code_ = '#get_operations.operation_code#';
				sira = #get_product.currentrow#;
				if(document.getElementById('control_buton_'+piece_row_id+'_'+operation_type_id).value == 1)
				{
					if(document.getElementById('amount_'+piece_row_id+'_'+operation_type_id).value =='')
					{
						alert(sira+'. <cf_get_lang_main no='1096.Satır'> '+operation_code_+'<cf_get_lang_main no='3397.Operasyon Planı Yapılmamış'> <cf_get_lang_main no='3210.Lütfen Düzeltiniz'>!');
						document.getElementById('amount_'+piece_row_id+'_'+operation_type_id).focus();
						return false;
					}
					else
					{
						p_operation_id_list +=piece_row_id+'_'+operation_type_id+'_'+document.getElementById('amount_'+piece_row_id+'_'+operation_type_id).value+',';
					}
				}
			</cfloop>
		</cfoutput>
		if(p_operation_id_list == '')
		{
			alert("<cf_get_lang_main no='3208.Güncellenecek Bilgi Bulunamadı'> !");
			return false;
		}
		else
		{
			sor=confirm("<cf_get_lang_main no='3209.Operasyon Değişiklikleri Güncellenecektir.'> <cf_get_lang_main no='1176.Emin misiniz ?'>");
			if (sor == true)
			{
				window.location ="<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_ezgi_iflow_operation_amount&master_plan_id=#attributes.master_plan_id#</cfoutput>&p_operation_id_list="+p_operation_id_list;
			}
			else
			return false;
		}
	}
</script>
