<cfset is_find = 0>
<cfset satirlar = queryNew("id, main_id,package_id, urun_id, type, name","integer, integer, integer, integer, integer, VarChar") />
<cfquery name="get_all_material" datasource="#dsn3#">
	SELECT 
    	DESIGN_PACKAGE_ROW_ID,
        (SELECT PACKAGE_NAME FROM EZGI_DESIGN_PACKAGE_ROW WHERE PACKAGE_ROW_ID = DESIGN_PACKAGE_ROW_ID) as PACKAGE_NAME
   	FROM 
    	EZGI_DESIGN_ALL_MATERIAL 
   	WHERE 
    	DESIGN_ID = #attributes.design_id# AND DESIGN_PACKAGE_ROW_ID IS NOT NULL
</cfquery>
<cfif get_all_material.recordcount> <!---Paket Sepetindeki Ürün Kontrolü--->
	<script type="text/javascript">
		alert("<cfoutput query="get_all_material">#PACKAGE_NAME#,</cfoutput><cf_get_lang_main no='2959.Paket İçindeki Malzeme Sepetinde Malzeme Mevcut Lütfen Düzenleyip Yeniden Deneyin'> !");
		window.close();
	</script>
  	<cfabort>
</cfif>
<cfinclude template="../query/get_ezgi_creative_product_tree_import.cfm">
<!---Parça Kontrolü--->
<cfif get_piece_all.recordcount>
	<cfquery name="get_piece_1_control" dbtype="query"> <!---Paket Tanımlanmamış Parça Kontrolü--->
		SELECT * FROM  get_piece_all WHERE PIECE_TYPE IN (1, 2, 3) AND DESIGN_PACKAGE_ROW_ID IS NULL AND USED_AMOUNT = 0
	</cfquery>
    <!---Pakete Girmemiş Parça Var mı?--->
	<cfif get_piece_1_control.recordcount>
    	<script type="text/javascript">
			alert("<cf_get_lang_main no='2960.Parçalar İçinde Paket Tanımlanmamış Satırlar Mevcut. Önce Düzenleme Yapınız'>!");
			window.close();
		</script>
        <cfabort>
 	</cfif>
    <!---Workcube Ürünleri İçinde Aynı İsimli Parça Var mı?--->
    <cfif get_design_info.PROCESS_ID eq 1> <!---Modül+Paket+Parça ise--->
    	<cfquery name="get_piece_1" dbtype="query"> <!---İmport Edilecek Parçalar Dndürülüyor.--->
          	SELECT * FROM  get_piece_all WHERE PIECE_TYPE IN (1,2,3) AND PIECE_RELATED_ID IS NULL
     	</cfquery>
    	<cfif get_piece_1.recordcount>
        	<cfset found_list = ''>
    		<cfoutput query="get_piece_1">
            	<cfset Temp = QueryAddRow(satirlar)>
             	<cfset attributes.HIERARCHY = get_product_cat_piece.HIERARCHY>
              	<cfset urun_adi = '#get_design_info.DESIGN_NAME# #PIECE_NAME#'> <!---Ürün Adı Tanımı--->
              	<cfif isdefined('COLOR_NAME_#PIECE_COLOR_ID#')>
                 	<cfset urun_adi = "#urun_adi# (#Evaluate('COLOR_NAME_#PIECE_COLOR_ID#')#)">
              	</cfif>
                <cfset Temp = QuerySetCell(satirlar, "id", 1)>
                <cfset Temp = QuerySetCell(satirlar, "main_id", DESIGN_MAIN_ROW_ID)>
                <cfset Temp = QuerySetCell(satirlar, "package_id", DESIGN_PACKAGE_ROW_ID)>
                <cfset Temp = QuerySetCell(satirlar, "urun_id", PIECE_ROW_ID)>
                <cfset Temp = QuerySetCell(satirlar, "type", PIECE_TYPE)> 
                <cfset Temp = QuerySetCell(satirlar, "name", urun_adi)> 
                <cfquery name="get_stock_info" datasource="#dsn3#">
                    SELECT PRODUCT_NAME, PRODUCT_CODE FROM STOCKS WHERE PRODUCT_NAME = '#urun_adi#'
                </cfquery>
                <cfif get_stock_info.recordcount>
                	<cfset 'piece#PIECE_ROW_ID#' = 1>
                	<cfloop query="get_stock_info">
                    	<cfset add_info = '#PRODUCT_CODE# - #PRODUCT_NAME#'>
                		<cfset found_list = ListAppend(found_list,add_info)>
                    </cfloop>
                </cfif>
   			</cfoutput> 
            <cfif len(found_list)>
            	<script type="text/javascript">
					alert("<cfloop list="#found_list#" index="i"><cfoutput>#i# </cfoutput></cfloop> <cf_get_lang_main no='2961.Ürün Adları İle Daha Önce Açılmış Kayıtlar Var'> !");
					window.close();
				</script>
				<cfabort>
            </cfif>
      	</cfif>
   	</cfif> 
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='2962.Aktarım Yapılacak Parça Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<!---Parça Kontrolü--->
<!---Paket Kontrolü--->
<cfif get_package_all.recordcount> 
	<cfif get_design_info.PROCESS_ID eq 1 or get_design_info.PROCESS_ID eq 2> <!---Modül+Paket+Parça ise veya Modül+Paket ise---> 
		<cfquery name="get_package_piece_control" dbtype="query">
			SELECT PACKAGE_ROW_ID, PACKAGE_NUMBER FROM get_package_all WHERE PARCA_SAYISI=0
		</cfquery>
		<cfif get_package_piece_control.recordcount><!---Parça Tanımlanmamış Paket Var mı?--->
			<script type="text/javascript">
				alert("<cf_get_lang_main no='2963.Parça Tanımlanmamış Paketler Mevcut Düzenleme Yapınız'>!");
				window.close();
			</script>
			<cfabort>
		</cfif>
        <cfquery name="get_package_main_control" dbtype="query">
            SELECT PACKAGE_ROW_ID, PACKAGE_NUMBER FROM get_package_all WHERE DESIGN_MAIN_NAME IS NULL
        </cfquery>
        <cfif get_package_main_control.recordcount><!---Modüle Bağlı Olmayan Paket Var mı?--->
            <script type="text/javascript">
                alert("<cf_get_lang_main no='2964.Modüle Bağlı Olmayan Paketler Mevcut Düzenleme Yapınız'>!");
                window.close();
            </script>
            <cfabort>
        </cfif>
        <!---Workcube Ürünleri İçinde Aynı İsimli Paket Var mı?--->
        <cfif get_package_1.recordcount>
        	<cfset found_list = ''>
        	<cfoutput query="get_package_1"><!---İmport Edilecek Paketler Döndürülüyor.--->
            	<cfset Temp = QueryAddRow(satirlar)>
				<cfset urun_adi = get_package_1.PACKAGE_NAME> <!---Ürün Adı Tanımı--->
                <cfset Temp = QuerySetCell(satirlar, "id", 2)>
                <cfset Temp = QuerySetCell(satirlar, "main_id", DESIGN_MAIN_ROW_ID)>
                <cfset Temp = QuerySetCell(satirlar, "package_id", PACKAGE_ROW_ID)>
                <cfset Temp = QuerySetCell(satirlar, "urun_id", PACKAGE_ROW_ID)>
                <cfset Temp = QuerySetCell(satirlar, "type", 0)> 
                <cfset Temp = QuerySetCell(satirlar, "name", urun_adi)> 
                <cfquery name="get_stock_info" datasource="#dsn3#">
                    SELECT PRODUCT_NAME, PRODUCT_CODE FROM STOCKS WHERE PRODUCT_NAME = '#urun_adi#'
                </cfquery>
                <cfif get_stock_info.recordcount>
                	<cfloop query="get_stock_info">
                    	<cfset add_info = '#PRODUCT_CODE# - #PRODUCT_NAME#'>
                		<cfset found_list = ListAppend(found_list,add_info)>
                    </cfloop>
                </cfif> 
      		</cfoutput>
            <cfif len(found_list)>
            	<script type="text/javascript">
					alert("<cfloop list="#found_list#" index="i"><cfoutput>#i# </cfoutput></cfloop> <cf_get_lang_main no='2961.Ürün Adları İle Daha Önce Açılmış Kayıtlar Var'> !");
					window.close();
				</script>
				<cfabort>
            </cfif>
      	</cfif>
   	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='2965.Aktarım Yapılacak Paket Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<!---Paket Kontrolü--->
<!---Modül Kontrolü--->
<cfif get_main_all.recordcount> 
    <cfquery name="get_main_control" dbtype="query">
        SELECT * FROM get_main_all WHERE PACKAGE_ROW_ID IS NULL
    </cfquery>
    <cfif get_main_control.recordcount> <!---Boş Modül Tanımı Var mı?--->
    	<script type="text/javascript">
			alert("<cf_get_lang_main no='2966.Paket Tanımlanmamış Modül Mevcut Düzenleme Yapınız'>!");
			window.close();
		</script>
        <cfabort>
    </cfif>
    <!---Workcube Ürünleri İçinde Aynı İsimli Paket Var mı?--->
    <cfif get_main_1.recordcount>
    	<cfset found_list = ''>
    	<cfoutput query="get_main_1"><!---İmport Edilecek Modüller Döndürülüyor.--->
        	<cfset Temp = QueryAddRow(satirlar)>
	       	<cfset urun_adi = get_main_1.DESIGN_MAIN_NAME> <!---Ürün Adı Tanımı--->
            <cfset Temp = QuerySetCell(satirlar, "id", 3)>
            <cfset Temp = QuerySetCell(satirlar, "main_id", DESIGN_MAIN_ROW_ID)>
           	<cfset Temp = QuerySetCell(satirlar, "package_id", DESIGN_MAIN_ROW_ID)>
         	<cfset Temp = QuerySetCell(satirlar, "urun_id", DESIGN_MAIN_ROW_ID)>
          	<cfset Temp = QuerySetCell(satirlar, "type", 0)> 
        	<cfset Temp = QuerySetCell(satirlar, "name", urun_adi)> 
    		<cfquery name="get_stock_info" datasource="#dsn3#">
                SELECT PRODUCT_NAME, PRODUCT_CODE FROM STOCKS WHERE PRODUCT_NAME = '#urun_adi#'
           	</cfquery>
         	<cfif get_stock_info.recordcount>
             	<cfloop query="get_stock_info">
                 	<cfset add_info = '#PRODUCT_CODE# - #PRODUCT_NAME#'>
                	<cfset found_list = ListAppend(found_list,add_info)>
             	</cfloop>
          	</cfif> 
   		</cfoutput>
        <!---<cfif len(found_list)>
        	<script type="text/javascript">
				alert("<cfloop list="#found_list#" index="i"><cfoutput>#i# </cfoutput></cfloop> Ürün Adları İle Daha Önce Açılmış Kayıtlar Var !");
				window.close();
			</script>
			<cfabort>
     	</cfif>--->
  	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='2967.Aktarım Yapılacak Modül Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<!---Modül Kontrolü--->
<!---Faklı Seviyelerdeki Kayıtlarda Aynı Ürün İsmi Kontrolü (Paketler ve Parçaların farklı Seviyeleri)--->
<cfquery name="get_control_1" dbtype="query">
	SELECT COUNT(*) AS SAYI, NAME FROM satirlar GROUP BY NAME HAVING COUNT(*) > 1
</cfquery>
<cfoutput query="get_control_1">
	<cfquery name="get_control_2" dbtype="query">
        SELECT COUNT(*) AS SAYI, ID, TYPE, NAME FROM satirlar WHERE NAME ='#get_control_1.NAME#' GROUP BY NAME, ID, TYPE
    </cfquery>
    <cfif get_control_1.SAYI neq get_control_2.SAYI>
    	<script type="text/javascript">
			alert("<cfoutput>#get_control_2.NAME# </cfoutput> <cf_get_lang_main no='2968.Ürün Adları İle Bu Tasarımda Farklı Seviyelerde Tanımlanmış Kayıtlar Mevcut Lütfen Düzeltiniz'> !");
			window.close();
		</script>
		<cfabort>
    </cfif>
    <cfquery name="define_same_name_id" dbtype="query">
    	SELECT URUN_ID FROM satirlar WHERE NAME = '#get_control_2.NAME#'
    </cfquery>
    <cfloop query="define_same_name_id">
    	<cfset 'URUN_ID_#URUN_ID#' = URUN_ID>
	</cfloop>
</cfoutput>
<cfquery name="get_satirlar" dbtype="query">
	SELECT * FROM SATIRLAR ORDER BY ID DESC, TYPE DESC, NAME
</cfquery>
<!---Faklı Seviyelerdeki Kayıtlarda Aynı Ürün İsmi Kontrolü (Paketler ve Parçaların farklı Seviyeleri)--->
<!---Tasarımda Aynı İsimde Modül Olma Kontrolü--->
<cfquery name="get_control_same_modul" dbtype="query">
	SELECT COUNT(*) AS SAYI, NAME FROM satirlar WHERE ID = 3 GROUP BY NAME HAVING COUNT(*) > 1
</cfquery>
<cfloop query="get_control_same_modul">
	<cfif get_control_same_modul.recordcount>
    	<script type="text/javascript">
			alert("<cfoutput>#get_control_same_modul.NAME# </cfoutput> <cf_get_lang_main no='2969.Modül Adları İle Bu Tasarımda Aynı İsimle Tanımlanmış Kayıtlar Mevcut Lütfen Düzeltiniz'> !");
			window.close();
		</script>
		<cfabort>
    </cfif>
</cfloop>
<!---Tasarımda Aynı İsimde Modül Olma Kontrolü--->
<cfform name="new_product" id="new_product" method="post" action="">
	<cfinput name="design_id" value="#attributes.design_id#" type="hidden">
    <cf_big_list id="list_product_big_list">
        <thead>
            <tr>
                <th style="text-align:center; width:25px"><cf_get_lang_main no='1165.Sıra'></th>
                <th style="text-align:left; width:60px"><cfoutput>#getLang('main',245)# #getLang('report',216)#</cfoutput></th>
				<th style="text-align:left;"><cfoutput>#getLang('main',245)# #getLang('main',485)#</cfoutput></th>
                <th style="text-align:center; width:25px"><cfoutput>#getLang('main',344)#</cfoutput></th>
            </tr>
        </thead>
        <tbody>
        <cfif get_satirlar.recordcount>
        	<cfset main_row_id_list = Valuelist(get_satirlar.main_id)>
            <cfset main_row_id_list= ListDeleteDuplicates(main_row_id_list,',')>
            <cfinput name="main_row_id_list" value="#main_row_id_list#" type="hidden">
        	<cfquery name="get_related_main_row_id" datasource="#dsn3#"> <!---Daha Önce Transfer Edilmiş Modül Çekiliyor--->
            	SELECT DESIGN_MAIN_ROW_ID FROM EZGI_DESIGN_MAIN_ROW WHERE DESIGN_MAIN_ROW_ID IN (#main_row_id_list#) AND DESIGN_MAIN_RELATED_ID IS NOT NULL
            </cfquery>
            <cfset related_main_row_id_list = Valuelist(get_related_main_row_id.DESIGN_MAIN_ROW_ID)>
			<cfoutput query="get_satirlar">
           		<tr id="row_#id#_#main_id#_#currentrow#">
               		<td style="text-align:right;" nowrap="nowrap">#currentrow#&nbsp;</td>
                  	<td style="text-align:left;" nowrap="nowrap">&nbsp;
                    	<cfif id eq 1>
                        	Parça
                        <cfelseif id eq 2>
                        	Paket
                        <cfelseif id eq 3>
                        	Modül
                        </cfif>
                    </td>
                	<td style="text-align:left;" nowrap="nowrap">&nbsp;#NAME#</td>
                  	<td style="text-align:center;" nowrap="nowrap">
                    	<cfif id eq 3 > <!---Modül İse--->
                        	<cfif ListFind(related_main_row_id_list,main_id)> <!---Bu Modül Daha Önce Transfer Edilmişse--->
                            	<input name="transfer_main_id#main_id#" id="transfer_main_id#main_id#" type="checkbox" disabled="disabled" checked="checked" readonly="readonly" style="text-align:center; vertical-align:middle" />
                            <cfelse>
                            	<input name="transfer_main_id#main_id#" id="transfer_main_id#main_id#" type="checkbox" value="1" style="text-align:center; vertical-align:middle" checked="checked" onchange="select_main(#main_id#);" />
                            </cfif>
                        <cfelse>
							<cfif isdefined('URUN_ID_#URUN_ID#')>
                                <img src="images/d_ok.gif" title="#getLang('main',2970)# #getLang('main',245)#" />
                            <cfelse>
                                <img src="images/c_ok.gif" title="#getLang('main',1262)# #getLang('main',245)#" />
                            </cfif>
                        </cfif>
                    </td>
				</tr>
      		</cfoutput>
        	<tfoot>
            	<tr>
               		<td colspan="4" height="20" style="text-align:right">
                        <cf_workcube_buttons is_upd='1' is_delete='0' add_function='transfer_product_tree()' insert_info='#getLang('main',1371)# #getLang('main',1156)#'>     
                  	</td>
            	</tr>
       		</tfoot>
    	<cfelse>
         	<tr> 
           		<td colspan="4" height="20"><cf_get_lang_main no='72.Kayıt Yok'>!</td>
          	</tr>
     	</cfif>
        </tbody>
    </cf_big_list>
</cfform>

<script language="javascript">
	function transfer_product_tree()
	{
		document.getElementById("new_product").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=prod.emptypopup_add_ezgi_import_creative_workcube";
		document.getElementById("new_product").submit();
		return true;
	}
	function select_main(main_id)
	{
		<cfloop query="get_satirlar">
			<cfif id neq 3>
				<cfoutput>
					id=#get_satirlar.id#; 
					currentrow=#get_satirlar.currentrow#;
					main_id_ = #main_id#
				</cfoutput>
				if(main_id == main_id_)
				{
					if(document.getElementById('transfer_main_id'+main_id).checked == 1)
					{
						document.getElementById('row_'+id+'_'+main_id+'_'+currentrow).style.display='';
					}
					else
					{
						document.getElementById('row_'+id+'_'+main_id+'_'+currentrow).style.display='none';
					}
				}
			</cfif>
		</cfloop>
	}
</script>



