<cfquery name="get_design_info" datasource="#dsn3#">
	SELECT        
    	DESIGN_ID, 
        CONSUMER_ID, 
        COMPANY_ID, 
        MEMBER_TYPE
	FROM        
    	EZGI_DESIGN
	WHERE        
    	DESIGN_ID = #attributes.design_id# AND 
        (COMPANY_ID >0 OR CONSUMER_ID>0)
        
</cfquery>
<cfif not get_design_info.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3050.Müşteri veya Proje Eksik, Lütfen Tamamlayıp Tekrar Deneyin!'>");
		window.close()
	</script>
</cfif>
<cfquery name="get_offer_row" datasource="#dsn3#">
	SELECT        
    	O.OFFER_ID, 
        O.OFFER_NUMBER, 
        O.OFFER_DATE,
        ORR.WRK_ROW_ID,
        ORR.OFFER_ROW_ID,
        ORR.STOCK_ID, 
        ORR.QUANTITY, 
        ORR.UNIT, 
        ORR.UNIT_ID, 
        ORR.PRODUCT_NAME, 
        ORR.SPECT_VAR_ID, 
        ORR.SPECT_VAR_NAME, 
        ORR.PRODUCT_NAME2, 
        O.OFFER_HEAD, 
        O.OFFER_DETAIL, 
      	O.DELIVER_PLACE, 
        O.LOCATION_ID,
        (SELECT PRODUCT_CODE FROM STOCKS WHERE STOCK_ID = ORR.STOCK_ID) AS PRODUCT_CODE
	FROM           
    	OFFER AS O INNER JOIN
     	OFFER_ROW AS ORR ON O.OFFER_ID = ORR.OFFER_ID INNER JOIN
     	EZGI_DESIGN_MAIN_ROW AS E ON ORR.STOCK_ID = E.DESIGN_MAIN_RELATED_ID INNER JOIN
     	EZGI_DESIGN AS ED ON E.DESIGN_ID = ED.DESIGN_ID
	WHERE        
    	O.OFFER_STATUS = 1 AND 
        O.PURCHASE_SALES = 1 AND 
        O.OFFER_ZONE = 0 AND 
        ED.IS_PROTOTIP = 1 AND
        <cfif get_design_info.MEMBER_TYPE eq 'partner' AND LEN(get_design_info.COMPANY_ID)>
    		O.COMPANY_ID = #get_design_info.COMPANY_ID#
    	<cfelseif len(get_design_info.CONSUMER_ID)>
        	O.CONSUMER_ID = #get_design_info.CONSUMER_ID#
        </cfif>
</cfquery>
<cfset offer_id_list = ValueList(get_offer_row.WRK_ROW_ID)>
<cfif listlen(offer_id_list)>
	<cfset related_offer_id_list = ''>
	<cfloop list="#offer_id_list#" index="i">
        <cfquery name="get_related_main_row_id" datasource="#dsn3#"> <!---Daha Önce Transfer Edilmiş Modül Çekiliyor--->
            SELECT WRK_ROW_RELATION_ID FROM EZGI_DESIGN_MAIN_ROW WHERE WRK_ROW_RELATION_ID = '#i#'
        </cfquery>
        <cfif get_related_main_row_id.recordcount>
        	<cfset related_offer_id_list = ListAppend(related_offer_id_list,get_related_main_row_id.WRK_ROW_RELATION_ID)>
        </cfif>
    </cfloop>
</cfif>
<cfform name="new_product" id="new_product" method="post" action="">
	<cfinput name="design_id" value="#attributes.design_id#" type="hidden">
    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="text-align:center; width:25px"><cfoutput>#getLang('main',1165)#</cfoutput></th>
                <th style="text-align:center; width:150px"><cfoutput>#getLang('main',1408)#</cfoutput></th>
                <th style="text-align:center; width:80px"><cfoutput>#getLang('main',330)#</cfoutput></th>
                <th style="text-align:center; width:80px"><cfoutput>#getLang('main',800)#</cfoutput></th>
                <th style="text-align:center; width:110px"><cfoutput>#getLang('main',1388)#</cfoutput></th>
				<th style="text-align:center;"><cfoutput>#getLang('main',809)#</cfoutput></th>
                <th style="text-align:center;width:75px"><cfoutput>#getLang('main',223)#</cfoutput></th>
                <th style="text-align:center;width:35px"><cfoutput>#getLang('main',224)#</cfoutput></th>
                <th style="text-align:center;width:200px"><cfoutput>#getLang('main',217)#</cfoutput></th>
                <th style="text-align:center; width:25px"><input type="checkbox" alt="#getLang('main',3009)#" onClick="transfer_product_tree(-1);"></th>
            </tr>
        </thead>
        <tbody>
        	<cfif get_offer_row.recordcount>
                <cfoutput query="get_offer_row">
                    <tr id="row_#currentrow#">
                        <td style="text-align:right;" nowrap="nowrap">#currentrow#&nbsp;</td>
                        <td style="text-align:left;" nowrap="nowrap">&nbsp;#OFFER_HEAD#</td>
                        <td style="text-align:center;" nowrap="nowrap">#DateFormat(OFFER_DATE,'DD/MM/YYYY')#</td>
                        <td style="text-align:center;" nowrap="nowrap">#OFFER_NUMBER#</td>
                        <td style="text-align:center;" nowrap="nowrap">#PRODUCT_CODE#</td>
                        <td style="text-align:left;" nowrap="nowrap">&nbsp;#PRODUCT_NAME#</td>
                        <td style="text-align:right;" nowrap="nowrap">#TlFormat(QUANTITY,2)#&nbsp;</td>
                        <td style="text-align:center;" nowrap="nowrap">&nbsp;#UNIT#</td>
                        <td style="text-align:left;" nowrap="nowrap">&nbsp;#PRODUCT_NAME2#</td>
                        <td style="text-align:center;" nowrap="nowrap">
                       		<cfif ListFind(related_offer_id_list,WRK_ROW_ID)> <!---Bu Modül Daha Önce Transfer Edilmişse--->
                                <img src="images/c_ok.gif" title="<cf_get_lang_main no='3051.Transfer Edilmiş Ürün'>" />
                           	<cfelse>
								<input name="select_production" id="select_production" type="checkbox" value="#OFFER_ROW_ID#" style="text-align:center; vertical-align:middle" checked="checked" />
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
                <tfoot>
                    <tr>
                        <td colspan="10" height="20" style="text-align:right">
                            <cfinput type="button" value="  #getLang('main',3049)# #getLang('main',1156)#  " name="buton" onClick="transfer_product_tree(-2)">   
                        </td>
                    </tr>
                </tfoot>
            <cfelse>
                <tr> 
                    <td colspan="10" height="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
                </tr>
            </cfif>
        </tbody>
    </cf_big_list>
</cfform>
<script language="javascript">
	function transfer_product_tree(type)
	{//type sadece -1 olarak gelir,-1 geliyorsa hepsini seç demektir.
		offer_id_list = '';
		chck_leng = document.getElementsByName('select_production').length;
		for(ci=0;ci<chck_leng;ci++)
		{
			var my_objets = document.all.select_production[ci];
			if(chck_leng == 1)
			var my_objets =document.all.select_production;
			if(type == -1)
			{//hepsini seç denilmişse	
				if(my_objets.checked == true)
					my_objets.checked = false;
				else
					my_objets.checked = true;
			}
			else
			{
				if(my_objets.checked == true)
				offer_id_list +=my_objets.value+',';
			}
		}
		offer_id_list = offer_id_list.substr(0,offer_id_list.length-1);//sondaki virgülden kurtarıyoruz.
		if(offer_id_list!='')
		{
			if(type == -2)
			{
				sor=confirm('<cf_get_lang_main no='3052.Seçtiğiniz Kayıtları Özel Tasarıma Transfer Ediyorum!'>');
				if (sor == true)
				{
					document.getElementById("new_product").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_add_ezgi_private_product_tree_creative_main_row";
					document.getElementById("new_product").submit();
				}
				else
					return false;
			}
		}
	}
</script>
