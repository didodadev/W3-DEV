<cfsavecontent variable=""><cf_get_lang dictionary_id='37238.Katalog Excel Import'></cfsavecontent>
<cf_form_box title="#message#">
	<cfform name="form_basket" action="" method="post" enctype="multipart/form-data">
		<input type="hidden" name="file_format" id="file_format" value="1">
        <cf_area width="270">
            <table>
                <tr>
                    <td nowrap="nowrap"><cf_get_lang dictionary_id='57468.Belge'> *</td>
                    <td>
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='37926.Belge Seçiniz'>!</cfsavecontent>
                        <cfinput type="file" name="uploaded_file" required="yes" message="#message#" style="width:200px;">
                    </td>
                </tr>
            </table>
        </cf_area>
        <cf_area>
            <cftry>
                <cfinclude template="#file_web_path#templates/import_example/katalog_excel_import_#session.ep.language#.html">
                <cfcatch>
                    <script type="text/javascript">
                        alert("<cf_get_lang dictionary_id='29760.Yardım Dosyası Bulunamadı Lutfen Kontrol Ediniz'>");
                    </script>
                </cfcatch>
            </cftry>
        </cf_area>
        <cf_form_box_footer>
            <cfsavecontent variable="message"><cf_get_lang dictionary_id ='58715.Listele'></cfsavecontent>
            <cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action(1)' is_cancel='0'>
            <cf_workcube_buttons add_function='ekle_form_action(2)' is_cancel='0'>
		</cf_form_box_footer>
	</cfform>
</cf_form_box>
<cfif isdefined("attributes.is_display_info")><br/>
	<cfset upload_folder = "#upload_folder#product#dir_seperator#" >
	<cftry> 
		<cffile action = "upload" 
			  fileField = "uploaded_file" 
			  destination = "#upload_folder#"
			  nameConflict = "MakeUnique"  
			  mode="777">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='47804.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz!'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfset file_size = cffile.filesize>
		<cfset dosya_yolu = "#upload_folder##file_name#">
		<cffile action="read" file="#dosya_yolu#" variable="dosya">
		<cffile action="delete" file="#dosya_yolu#">
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
	</cfscript>
	<cf_big_list>
    	<thead>
            <tr>
                <td><cf_get_lang dictionary_id='57789.Özel Kod'></td>
                <td><cf_get_lang dictionary_id='57657.Ürün'></td>
                <td><cf_get_lang dictionary_id='37936.Sayfa No'></td>						
                <td><cf_get_lang dictionary_id='58069.Sayfa Tipi'></td>	
                <td><cf_get_lang dictionary_id='58067.Döküman Tipi'></td>
                <td><cf_get_lang dictionary_id='37216.Katalog'><cf_get_lang dictionary_id='58084.Fiyat'></td>
                <td><cf_get_lang dictionary_id='57908.Temsilci'><cf_get_lang dictionary_id='58084.Fiyat'></td>
                <td><cf_get_lang dictionary_id='57489.Para Birimi'></td>
                <td><cf_get_lang dictionary_id='57629.Açıklama'>/<cf_get_lang dictionary_id='57467.Not'></td>
                <td><cf_get_lang dictionary_id='37134.Referans Kod'></td>
                <td><cf_get_lang dictionary_id='37168.Müşteri Sayısı'></td>
                <td><cf_get_lang dictionary_id='37150.Birim Satış'></td>
                <td><cf_get_lang dictionary_id='37215.Satış Tipi'></td>	
            </tr>
        </thead>
        <tbody>
            <cfloop from="2" to="#line_count#" index="k">
                <cfquery name="get_product_main" datasource="#DSN3#">
                    SELECT
                        PRODUCT_NAME
                    FROM
                        STOCKS
                    WHERE
                        STOCK_CODE_2 = '#ListGetAt(dosya[k],1,";")#'
                </cfquery>
                <cfif len(trim(ListGetAt(dosya[k],3,";")))>
                    <cfquery name="get_page_type" datasource="#DSN3#">
                        SELECT
                            PAGE_TYPE
                        FROM
                            CATALOG_PAGE_TYPES
                        WHERE
                            PAGE_TYPE_ID = #ListGetAt(dosya[k],3,";")#
                    </cfquery>
                </cfif>
                <cfif get_product_main.recordcount>
                    <cfoutput query="get_product_main">
                        <tr>
                            <td>#ListGetAt(dosya[k],1,";")#</td>
                            <td>#product_name#</td>
                            <td>#ListGetAt(dosya[k],2,";")#</td>
                            <td>
                                <cfif len(trim(ListGetAt(dosya[k],3,";")))>
                                    #get_page_type.page_type#
                                </cfif>
                            </td>
                            <td>
                                <cfif len(trim(ListGetAt(dosya[k],4,";"))) and ListGetAt(dosya[k],4,";") eq 2>Insert<cfelseif len(trim(ListGetAt(dosya[k],4,";"))) and ListGetAt(dosya[k],4,";") eq 1><cf_get_lang dictionary_id='37216.Katalog'></cfif>
                            </td>
                            <td style="text-align:right;">#ListGetAt(dosya[k],5,";")#</td>
                            <td style="text-align:right;">#ListGetAt(dosya[k],6,";")#</td>
                            <td>#ListGetAt(dosya[k],7,";")#</td>
                            <td>#ListGetAt(dosya[k],8,";")#</td>
                            <td>#ListGetAt(dosya[k],9,";")#</td>
                            <td style="text-align:right;">#ListGetAt(dosya[k],10,";")#</td>
                            <td style="text-align:right;">#ListGetAt(dosya[k],11,";")#</td>
                            <td>
                                <cfif listlen(dosya[k],';') gte 12>
                                    <cfif ListGetAt(dosya[k],12,";") eq 1>
                                        <cf_get_lang dictionary_id='37239.Normal Satış'>
                                    <cfelseif ListGetAt(dosya[k],12,";") eq 2>
                                        <cf_get_lang dictionary_id='37241.Set Bileşeni'>
                                    <cfelseif ListGetAt(dosya[k],12,";") eq 3>
                                        <cf_get_lang dictionary_id='37242.Promosyon Faydası'>
                                    <cfelseif ListGetAt(dosya[k],12,";") eq 4>
                                        <cf_get_lang dictionary_id='37265.Promosyon Koşulu'>
                                    <cfelseif ListGetAt(dosya[k],12,";") eq 5>
                                    	<cf_get_lang dictionary_id='37269.Set Ana Ürünü'>
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                    </cfoutput>
                </cfif>
            </cfloop>
        </tbody>
	</cf_big_list>
</cfif>
<script type="text/javascript">
	function ekle_form_action(int_s_flag)
	{
		if(int_s_flag==1)
		{
			form_basket.action = "<cfoutput>#request.self#?fuseaction=product.form_add_catalog_from_file&is_display_info=1</cfoutput>";
			return true;
		}
		else
		{
			form_basket.action = "<cfoutput>#request.self#?fuseaction=product.form_add_catalog_promotion&is_from_file=1</cfoutput>";
			return true;
		}
	}
</script>

