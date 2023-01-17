<cfquery name="get_money" datasource="#dsn2#">
	SELECT MONEY, RATE1, RATE2 FROM SETUP_MONEY
</cfquery>
<cfloop query="get_money">
	<cfset 't1_fiyat#MONEY#' = 0>
</cfloop>
<cfset toplam = 0>
<cfset toplam_price = 0>
<cfquery name="get_colors" datasource="#dsn3#">
	SELECT * FROM EZGI_COLORS ORDER BY COLOR_NAME
</cfquery>
<cfoutput query="get_colors">
	<cfset 'COLOR_NAME_#COLOR_ID#' = COLOR_NAME>
</cfoutput>
<cfquery name="get_all_stocks" datasource="#dsn3#">
	SELECT        
    	S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        S.STOCK_ID,
        S.PRODUCT_ID, 
        S.PRODUCT_CATID,
        ISNULL((
        		SELECT        
                	PS.PRICE * SM.RATE2 AS PRICE
				FROM            
                	#dsn1_alias#.PRICE_STANDART AS PS INNER JOIN
                    #dsn2_alias#.SETUP_MONEY AS SM ON PS.MONEY = SM.MONEY
				WHERE        
                	PS.PRICESTANDART_STATUS = 1 AND 
                    PS.PURCHASESALES = 0 AND 
                    PS.PRODUCT_ID = S.PRODUCT_ID
        		),0) AS PRICE
  		
	FROM            
    	STOCKS AS S INNER JOIN
    	PRODUCT_CAT ON S.PRODUCT_CATID = PRODUCT_CAT.PRODUCT_CATID
  	WHERE
    	S.PRODUCT_STATUS = 1
</cfquery>
<cfoutput query="get_all_stocks">
	<cfset 'PRICE_#STOCK_ID#' = PRICE>
</cfoutput>
<!---Tasarım Bilgisi Çekme--->
<cfquery name="get_design" datasource="#dsn3#">
	SELECT  * FROM EZGI_DESIGN WHERE DESIGN_ID = #attributes.design_id#
</cfquery>
<!---Tasarım Bilgisi Çekme--->
<!---Renk Bilgisi Çekme--->
<cfquery name="GET_OTHER_COLORS" datasource="#dsn3#">
	SELECT        
    	TBL.COLOR_ID AS PIECE_COLOR_ID, EZGI_COLORS.COLOR_NAME AS PIECE_COLOR_NAME
	FROM            
    	(
        	SELECT        
            	PIECE_COLOR_ID AS COLOR_ID
       		FROM            EZGI_DESIGN_PIECE
            	WHERE        
                	PIECE_COLOR_ID IS NOT NULL AND 
                    DESIGN_ID = #attributes.design_id#
         	UNION ALL
         	SELECT        
            	PACKAGE_COLOR_ID AS COLOR_ID
         	FROM            
            	EZGI_DESIGN_PACKAGE
         	WHERE        
            	DESIGN_ID = #attributes.design_id#
         	UNION ALL
          	SELECT        
            	DESIGN_MAIN_COLOR_ID AS COLOR_ID
         	FROM            
            	EZGI_DESIGN_MAIN_ROW
          	WHERE        
            	DESIGN_ID = #attributes.design_id#
       	) AS TBL INNER JOIN
    	EZGI_COLORS ON TBL.COLOR_ID = EZGI_COLORS.COLOR_ID
	GROUP BY 
    	TBL.COLOR_ID, 
        EZGI_COLORS.COLOR_NAME
</cfquery>
<!---Renk Bilgisi Çekme--->
<!---Hammadde Bilgisi Çekme--->
<cfquery name="get_raw_stock" datasource="#dsn3#">
	SELECT        
    	S.STOCK_ID, 
        S.PRODUCT_ID,
      	S.PRODUCT_NAME, 
      	S.PRODUCT_CODE,
        S.PRODUCT_CATID,
        ISNULL((
        		SELECT     
                	PRICE
               	FROM          
                	#dsn1_alias#.PRICE_STANDART
             	WHERE      
                	PRODUCT_ID = S.PRODUCT_ID AND 
                    PRICESTANDART_STATUS = 1 AND 
                    PURCHASESALES = 0
        		),0) AS STANDART_ALIS,
      	(
        	SELECT     
        		MONEY
      		FROM          
            	#dsn1_alias#.PRICE_STANDART AS PRICE_STANDART_1
        	WHERE      
            	PRODUCT_ID = S.PRODUCT_ID AND 
                PRICESTANDART_STATUS = 1 AND 
                PURCHASESALES = 0
      	) AS STANDART_ALIS_MONEY,
        SUM(PIECE_AMOUNT) AS AMOUNT
	FROM            
    	(
        	SELECT        
            	PIECE_RELATED_ID, 
                PIECE_AMOUNT
         	FROM            
            	EZGI_DESIGN_PIECE
          	WHERE        
            	DESIGN_ID = #attributes.design_id# AND 
                PIECE_TYPE = 4
        	UNION ALL
        	SELECT        
            	EDPR.STOCK_ID, 
                EDP.PIECE_AMOUNT * EDPR.AMOUNT AS AMOUNT
         	FROM            
            	EZGI_DESIGN_PIECE_ROW AS EDPR INNER JOIN
             	EZGI_DESIGN_PIECE AS EDP ON EDPR.PIECE_ROW_ID = EDP.PIECE_ROW_ID
         	WHERE        
            	EDPR.PIECE_ROW_ROW_TYPE IN (2,3) AND 
                EDP.DESIGN_ID = #attributes.design_id#
      	) AS TBL INNER JOIN
 		STOCKS AS S ON TBL.PIECE_RELATED_ID = S.STOCK_ID
	GROUP BY 
    	S.PRODUCT_NAME, 
        S.PRODUCT_CODE, 
        S.STOCK_ID,
        S.PRODUCT_ID,
        S.PRODUCT_CATID
 	ORDER BY
    	S.PRODUCT_CODE
</cfquery>
<!---Hammadde Bilgisi Çekme--->
<table class="dph">
    <tr>
        <td class="dpht">&nbsp;<cf_get_lang_main no='1995.Tasarım'> <cf_get_lang_main no='64.Kopyala'></td>
        <td class="dphb">
        	<cfoutput>

            </cfoutput>
            &nbsp;&nbsp;
        </td>
	</tr>
</table>
<table class="dpm" align="center">
    <tr>
    	<td valign="top" class="dpml">
            <cf_form_box>	
            	<cfform name="add_same_design" method="post" action="#request.self#?fuseaction=prod.emptypopup_cpy_ezgi_product_tree_creative">
                    <cfinput type="hidden" name="old_design_id" value="#attributes.design_id#">
                  	<table>
                        <tr height="25px"  id="design_name_">
                            <td width="150px" valign="top" style="font-weight:bold"><cfoutput>#getLang('settings',1457)#</cfoutput>*</td>
                            <td width="200px" valign="top">
                                <cfinput type="text" name="old_design_name" id="old_design_name" value="#get_design.design_name#" maxlength="50" style="width:190px;" >
                            </td>
                            <td width="200px" valign="top">
                                <cfinput type="text" name="new_design_name" id="new_design_name" value="#get_design.design_name#" maxlength="50" style="width:190px;" >
                            </td>
                        </tr>
                        <tr height="25px"  id="design_color_">
                            <td valign="top" style="font-weight:bold"><cfoutput>#getLang('main',2981)#</cfoutput> *</td>
                            <td valign="top">
                                <cfinput type="text" name="old_design_color_name" id="old_design_color_name" value="#Evaluate('COLOR_NAME_#get_design.color_id#')#" maxlength="50" style="width:190px;" >
                                <cfinput type="hidden" name="old_design_color" id="old_design_color" value="#get_design.color_id#">
                            </td>
                            <td valign="top">
                                <select name="new_design_color" id="new_design_color" style="width:190px; height:20px">
                                    <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                    <cfoutput query="get_colors">
                                        <option value="#COLOR_ID#" <cfif get_design.color_id eq COLOR_ID>style="font-weight:bold" selected</cfif>>#COLOR_NAME#</option>
                                    </cfoutput>
                                </select>
                            </td>
                        </tr>
                    </table>
                   		<cf_seperator title="#getLang('main',2982)#" id="_other_colors" is_closed="1">
                        <cf_form_list id="_other_colors">
                             <table>
                                <cfoutput query="GET_OTHER_COLORS">
                                    <tr height="30px"  id="design_color_">
                                        <td width="150px" valign="top" style="font-weight:bold">#getLang('prod',241)# - #currentrow# *</td>
                                        <td width="200px" valign="top">
                                            <cfinput type="text" name="old_design_color_name_#currentrow#" id="old_design_color_name_#currentrow#" value="#PIECE_COLOR_NAME#" maxlength="50" style="width:190px;" >
                                            <cfinput type="hidden" name="old_design_color_#currentrow#" id="old_design_color_#currentrow#" value="#PIECE_COLOR_ID#" maxlength="50" style="width:190px;" >
                                        </td>
                                        <td width="200px" valign="top">
                                            <select name="new_design_color_#PIECE_COLOR_ID#" id="new_design_color_#PIECE_COLOR_ID#" style="width:190px; height:20px">
                                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfloop query="get_colors">
                                                    <option value="#COLOR_ID#" <cfif GET_OTHER_COLORS.PIECE_COLOR_ID eq COLOR_ID>style="font-weight:bold" selected</cfif>>#COLOR_NAME#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                    </tr>
                                </cfoutput>
                            </table>
                        </cf_form_list>
                        <br />
                    	<cf_form_box_footer>
                       	 	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
                  		</cf_form_box_footer> 
                        <br>
                        <div>
                            <cf_seperator title="#getLang('main',2983)#" id="_raw_metals" is_closed="1">
                            <table cellpadding="0" cellspacing="0" border="1" width="98%">
                                <tr height="25px">
                                    <td width="30px" style=" font-weight:bold">&nbsp;<cfoutput>#getLang('main',1165)#</cfoutput></td>
                                    <td width="40px" style=" font-weight:bold">&nbsp;<cfoutput>#getLang('main',223)#</cfoutput></td>
                                    <td style=" font-weight:bold">&nbsp;<cfoutput>#getLang('settings',2630)# #getLang('prod',132)#</cfoutput></td>
                                    <td width="100px" style=" font-weight:bold;">&nbsp;<cfoutput>#getLang('main',1310)#</cfoutput></td>
                                    <td width="50px" style=" font-weight:bold;">&nbsp;<cfoutput>#getLang('main',265)#</cfoutput></td>
                                    <td width="50px" style=" font-weight:bold;">&nbsp;<cfoutput>#getLang('main',261)#</cfoutput></td>
                                    <td width="400px" style=" font-weight:bold">&nbsp;<cfoutput>#getLang('main',539)# #getLang('prod',132)#</cfoutput></td>
                                    <td width="100px" style=" font-weight:bold;">&nbsp;<cfoutput>#getLang('main',1310)#</cfoutput></td>
                                    <td width="50px" style=" font-weight:bold;">&nbsp;<cfoutput>#getLang('main',265)#</cfoutput></td>
                                    <td width="50px" style=" font-weight:bold;">&nbsp;<cfoutput>#getLang('main',261)#</cfoutput></td>
                                </tr>
                                <cfoutput query="get_raw_stock">
                                    <cfquery name="get_these_stocks" dbtype="query">
                                        SELECT        
                                            PRODUCT_NAME, 
                                            PRODUCT_CODE, 
                                            STOCK_ID, 
                                            PRODUCT_CATID
                                        FROM
                                            get_all_stocks
                                        WHERE        
                                            PRODUCT_CATID = #PRODUCT_CATID#
                                    </cfquery>
                                    <tr height="25px"  id="raw_stocks_">
                                        <td valign="middle" style=" text-align:right">#currentrow#&nbsp;</td>
                                        <td valign="middle" style=" text-align:right">#TlFormat(Amount,4)#&nbsp;</td>
                                        <td valign="middle">
                                            <input type="text" name="old_design_product_name_#currentrow#" id="old_design_product_name_#currentrow#" value="#PRODUCT_NAME#" maxlength="50" style="width:100%; height:100%; border:none" >
                                            <cfinput type="hidden" name="old_design_stock_id_#currentrow#" id="old_design_stock_id_#currentrow#" value="#STOCK_ID#">
                                        </td>
                                        <td valign="middle" style=" text-align:right">#TlFormat(STANDART_ALIS,8)#&nbsp;</td>
                                        <td valign="middle" style=" text-align:left">&nbsp;#STANDART_ALIS_MONEY#</td>
                                        <td valign="middle" style=" text-align:right">#TlFormat(STANDART_ALIS*Amount,2)#&nbsp;</td>
										<cfif isdefined('t1_fiyat#STANDART_ALIS_MONEY#') and get_raw_stock.STANDART_ALIS gt 0>
                                      		<cfset 't1_fiyat#STANDART_ALIS_MONEY#' = evaluate('t1_fiyat#STANDART_ALIS_MONEY#') + (get_raw_stock.STANDART_ALIS*get_raw_stock.Amount)>
                                     	</cfif>      	            
                                        <td valign="middle">
                                            <select name="new_design_stock_id_#STOCK_ID#" id="new_design_stock_id_#currentrow#" style="width:100%; height:20px" onchange="change_raw(#currentrow#,#amount#);">
                                                <option value="0"><cf_get_lang_main no='322.Seçiniz'></option>
                                                <cfloop query="get_these_stocks">
                                                    <option value="#STOCK_ID#,#PRODUCT_NAME#" <cfif get_raw_stock.STOCK_ID eq STOCK_ID>style="font-weight:bold" selected</cfif>>#PRODUCT_NAME#</option>
                                                </cfloop>
                                            </select>
                                        </td>
                                        <td valign="middle" style=" text-align:right">
                                        	<cfif isdefined('PRICE_#STOCK_ID#')>
                                        		<input type="text" id="price_#currentrow#" name="price_#currentrow#" class="box" style="width:95px" value="#TlFormat(Evaluate('PRICE_#STOCK_ID#'),8)#" onchange="hesapla_row(#currentrow#,#amount#);" />
                                            <cfelse>
                                            	<input type="text" id="price_#currentrow#" name="price_#currentrow#" class="box" style="width:95px" value="#TlFormat(0,8)#" onchange="hesapla_row(#currentrow#,#amount#);" />
                                            </cfif>
                                            
                                            
                                        
                                        </td>
                                        <td valign="middle" style=" text-align:left">&nbsp;#session.ep.money#</td>
                                        <td valign="middle" style=" text-align:right">
                                        	<cfif isdefined('PRICE_#STOCK_ID#')>
                                        		<input type="text" id="row_price_#currentrow#" name="row_price_#currentrow#" class="box" style="width:45px" value="#TlFormat(Evaluate('PRICE_#STOCK_ID#')*Amount,2)#" readonly="readonly" />
                                        		<cfset toplam_price = toplam_price + (Evaluate('PRICE_#STOCK_ID#')*Amount)>
                                        	<cfelse>
                                        		<input type="text" id="row_price_#currentrow#" name="row_price_#currentrow#" class="box" style="width:45px" value="#TlFormat(0,2)#" readonly="readonly" />
                                        	</cfif>
                                      	</td>
                                    </tr>
                                </cfoutput>
                                <tr>
                                	<td valign="middle" colspan="3" style=" text-align:right; height:20px;font-weight:bold"><cf_get_lang_main no='80.Toplam'>&nbsp;</td>
                                    <td valign="middle" style=" text-align:right;font-weight:bold">
                                    	<cfoutput query="get_money">
											<cfif isdefined('t1_fiyat#MONEY#') and Evaluate('t1_fiyat#MONEY#') gt 0>
                                                #TlFormat(Evaluate('t1_fiyat#MONEY#'),2)#
                                                <cfset toplam = toplam + (Evaluate('t1_fiyat#MONEY#')*RATE2)>
                                            </cfif>      	            
                                        </cfoutput>
                                    </td>
                                    <td valign="middle" style=" text-align:left;font-weight:bold">
                                    	<cfoutput query="get_money">
											<cfif isdefined('t1_fiyat#MONEY#') and Evaluate('t1_fiyat#MONEY#') gt 0>
                                                &nbsp;#MONEY#<br />
                                            </cfif>      	            
                                        </cfoutput>
                                    </td>
                                    <cfoutput>
                                    <td valign="middle" style=" text-align:right; font-weight:bold">#TlFormat(toplam,2)#&nbsp;</td>
                                    <td valign="middle" style=" text-align:left;font-weight:bold" colspan="3">&nbsp;</td>
                                    <td valign="middle" style=" text-align:right;font-weight:bold">
                                    	<input type="text" id="total_price" name="total_price" class="box" style="width:45px; font-weight:bold" value="#TlFormat(toplam_price,2)#" readonly="readonly" />
                                    </td>
                                    </cfoutput>
                                </tr>
                          	</table>
                   		</div>
                </cfform>
            </cf_form_box>
      	</td>
  	</tr>
</table>
<cfloop query="get_raw_stock">

</cfloop>
<script type="text/javascript">
	function kontrol()
	{
		if(document.getElementById('old_design_name').value == document.getElementById('new_design_name').value)
		{
			if(document.getElementById('old_design_color').value == document.getElementById('new_design_color').value)	
			{
				alert('<cf_get_lang_main no='2984.Tasarım Kopyalamak İçin Tasarım Adı Veya Tasarım Rengi Farklı Olması Gerekir'> !');	
				return false;
			}
		}
	}
	function change_raw(sira,amount)
	{
		stockid = document.getElementById('new_design_stock_id_'+sira).value;
		price = 0;
		<cfloop query="get_all_stocks">
			<cfoutput>
				stock_id = #stock_id#;
				price = #Evaluate('PRICE_#STOCK_ID#')#;
			</cfoutput>
			if(stock_id == stockid)
			{
				document.getElementById('price_'+sira).value = commaSplit(price,8);
				document.getElementById('row_price_'+sira).value = commaSplit(price*amount,2);
			}
		</cfloop>
		hesapla();
	}
	function hesapla_row(sira,amount)
	{
		document.getElementById('row_price_'+sira).value = commaSplit(filterNum(document.getElementById('price_'+sira).value)*amount,2);	
		hesapla();
	}
	function hesapla()
	{
		toplam = 0;
		<cfloop query="get_raw_stock">
			<cfoutput>
				sira = #currentrow#;
			</cfoutput>
			toplam = toplam + filterNum(document.getElementById('row_price_'+sira).value,2)*1;
		</cfloop>
		document.getElementById('total_price').value = commaSplit(toplam,2);
	}
</script>