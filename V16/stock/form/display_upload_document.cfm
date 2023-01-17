<cf_get_lang_set module_name="stock">
<cfset upload_folder = "#upload_folder#store#dir_seperator#">
<cfif not directoryexists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
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
			alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
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
			alert("Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfscript>
	CRLF = Chr(13)&Chr(10); // satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
</cfscript>
<cf_big_list_search title="#getLang('stock',240)#">
	<cf_big_list_search_area>
		<!-- sil -->
        <table>
        	<tr>
            	<td>
                    <a href="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.add_ship_from_file&from_where=#attributes.from_where#</cfoutput>"><img src="images/barcode.gif"></a>
                    <cf_workcube_file_action pdf='0' mail='0' doc='1' print='1'>
       			 </td>
            </tr>
        </table>
		<!-- sil -->
    </cf_big_list_search_area>
</cf_big_list_search>
<cf_big_list>
	<thead>
		<tr>
        	<th width="10"><cf_get_lang_main no='1165.Sıra'></th>
			<th width="70"><cf_get_lang_main no='221.Barkod'></th>
			<th><cf_get_lang_main no='106.Stok Kodu'></th>
			<th><cf_get_lang_main no='245.Ürün'></th>
			<th><cf_get_lang_main no='222.Üretici Kodu'></th>			
			<th><cf_get_lang_main no='223.Miktar'></th>						
			<th><cf_get_lang_main no='672.Fiyat'></th>						
		</tr>
    </thead>
    <tbody>
		<cftry>
			<cfquery name="GET_PRODUCT_MAIN_ALL" datasource="#DSN3#">
				SELECT
					<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					GSB.BARCODE,
					<cfelse>
					S.BARCOD BARCODE,
					</cfif>
					S.STOCK_CODE,
					S.PROPERTY,
					S.STOCK_CODE_2,				
					P.PRODUCT_NAME,
					P.MANUFACT_CODE
				FROM
					PRODUCT P,
					STOCKS S
					<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					,GET_STOCK_BARCODES GSB
					</cfif>
				WHERE
					P.PRODUCT_ID = S.PRODUCT_ID 
					<cfif not (isdefined('attributes.stock_identity_type_') and listfind('2,3',attributes.stock_identity_type_))>
					AND S.STOCK_ID = GSB.STOCK_ID 
					</cfif>
			</cfquery>
            <cfset temp_currentrow= 0>
			<cfloop from="1" to="#line_count#" index="k">
				<cfquery name="GET_PRODUCT_MAIN" dbtype="query">
					SELECT
						BARCODE,
						STOCK_CODE,
						PRODUCT_NAME,
						PROPERTY,
						MANUFACT_CODE
					FROM
						GET_PRODUCT_MAIN_ALL
					WHERE
						<cfif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 3><!--- özel kod --->
						STOCK_CODE_2 = '#ListGetAt(dosya[k],1,";")#'
						<cfelseif isdefined("attributes.stock_identity_type_") and attributes.stock_identity_type_ eq 2><!--- stok kodu--->
						STOCK_CODE = '#ListGetAt(dosya[k],1,";")#'
						<cfelse><!--- barkod--->
						BARCODE = '#ListGetAt(dosya[k],1,";")#'
						</cfif>
				</cfquery>                
				<cfif get_product_main.recordcount>
                	<cfset temp_currentrow= temp_currentrow+1>
					<cfoutput query="get_product_main">
						<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
                          <td>#temp_currentrow#</td>
						  <td>#barcode#</td>
						  <td>#stock_code#</td>
						  <td>#product_name# #property#</td>
						  <td>#manufact_code#</td>
						  <td>#ListGetAt(dosya[k],2,";")#</td>
						  <td><cfif len(ListGetAt(dosya[k],3,";"))>#TLFormat(ListGetAt(dosya[k],3,";"))#</cfif></td>
						</tr>
					</cfoutput>
				</cfif>
			</cfloop>
            <cfif temp_currentrow eq 0>
				<tr>
					<td colspan="7"><cf_get_lang_main no='1074.Kayit Bulunamadi'></td>
				</tr>
            </cfif>
		<cfcatch></cfcatch>
		</cftry>
	</tbody>
</cf_big_list>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
