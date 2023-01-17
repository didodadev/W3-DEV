<cfif not isdefined('attributes.uploaded_file')>
<cfoutput>
	<cf_box title="Dosya Ekle" style="width:280px;" body_style="width:320px;height:150px">
    	<input type="hidden" id="prom_condition_id" name="prom_condition_id" value="#attributes.prom_condition_id#" />
        <table border="0" align="left">
            <tr>
                <td nowrap><cf_get_lang dictionary_id='57468.Belge'> *</td>
                <td>
                    <input type="file" name="uploaded_file" id="uploaded_file" style="width:200px;">
                </td>
            </tr>
            <tr>
                <td><cf_get_lang dictionary_id ='37179.Kayıt Tipi'></td>
                <td>
                    <select name="product_type" id="product_type" style="width:200px">
                        <option value="1"><cf_get_lang dictionary_id='57789.Özel Kod'></option>
                    </select>
                </td>
            </tr>
            <tr>
                <td></td>
                <td style="text-align:right;">
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent>
                    <cf_workcube_buttons insert_info='#message#' add_function='ekle_form_action()' is_cancel='0'>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                	<b><cf_get_lang dictionary_id='58594.Format'></b><br/>
                	<cf_get_lang dictionary_id='44429.Dosya uzantısı csv olmalıdır'>.<br/><cf_get_lang dictionary_id='44487.Aktarım işlemi dosyanın ilk satırından itibaren başlar'>.<br/><cf_get_lang dictionary_id='60450.Belgede tek alan olmalı'>.
                </td>
            </tr>
        </table>
	</cf_box>
</cfoutput>
<script type="text/javascript">
	function ekle_form_action()
	{
		if(document.getElementById('uploaded_file').value == "")
		{
			alert("<cf_get_lang dictionary_id='54246.Belge Seçmelisiniz'> !");
			return false;
		}
		add_prom.action = "<cfoutput>#request.self#?fuseaction=product.popup_add_prom_condition_file</cfoutput>";
	}
</script>
<cfelse>
	<cfset kontrol_file = 0>
    <cfset upload_folder_ = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
    <cftry>
        <cffile action = "upload" 
              fileField = "uploaded_file" 
              destination = "#upload_folder_#"
              nameConflict = "MakeUnique"  
              mode="777">
        <cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
        <cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">	
        <!---Script dosyalarını engelle  02092010 ND --->
        <cfset assetTypeName = listlast(cffile.serverfile,'.')>
        <cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
        <cfif listfind(blackList,assetTypeName,',')>
            <cffile action="delete" file="#upload_folder_##file_name#">
            <script type="text/javascript">
                alert("<cf_get_lang dictionary_id='47804.\php\,\jsp\,\asp\,\cfm\,\cfml\ Formatlarında Dosya Girmeyiniz'>!!");
                history.back();
            </script>
            <cfabort>
        </cfif>	
        <cfset file_size = cffile.filesize>
        <cfset dosya_yolu = "#upload_folder_##file_name#">
        <cffile action="read" file="#dosya_yolu#" variable="dosya">
        <cfcatch type="Any">
            <cfset kontrol_file = 1>
        </cfcatch>
    </cftry>
    
    <cfif kontrol_file eq 0>
    	<cfscript>
			CRLF = Chr(13) & Chr(10);// satır atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
		</cfscript>
        <cfloop from="1" to="#line_count#" index="k">
        	<cfscript>
				ozel_kod = trim(ListGetAt(dosya[k],1,";"));
			</cfscript>
            <cfoutput>
            	<cfif len(ozel_kod)>
                    <cfquery name="get_prom_cont" datasource="#dsn3#">
                        SELECT
                            PRODUCT_ID,
                            STOCK_ID
                        FROM
                            STOCKS
                        WHERE
                            STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ozel_kod#">
                    </cfquery>
                    <cfif get_prom_cont.recordcount lte 0>
                        <script type="text/javascript">
                            alert("#k#. <cf_get_lang dictionary_id='37377.satırda bulunan'> #ozel_kod# <cf_get_lang dictionary_id='60451.özel kodlu kayıt bulunmamaktadır'>. <cf_get_lang dictionary_id='48547.Lütfen kontrol ediniz'>!");
                            history.back();
                        </script>
                        <cfabort>
                   	<cfelseif get_prom_cont.recordcount gt 1>
                    	<script type="text/javascript">
                            alert("#k#. <cf_get_lang dictionary_id='37377.satırda bulunan'> <cf_get_lang dictionary_id='60452.Özel kodlu ürün sayısı'>: #get_prom_cont.recordcount#  <cf_get_lang dictionary_id='48547.Lütfen kontrol ediniz'>!");
                            history.back();
                        </script>
                        <cfabort>
                    </cfif>
               	<cfelse>
                	<script type="text/javascript">
						alert("#k#. <cf_get_lang dictionary_id='60451.özel kodlu kayıt bulunmamaktadır'>. <cf_get_lang dictionary_id='48547.Lütfen kontrol ediniz'>!");
						history.back();
					</script>
					<cfabort>
                </cfif>
            </cfoutput>
      	</cfloop>
        <cfquery name="del_prom_prod" datasource="#dsn3#">
        	DELETE FROM PROMOTION_CONDITIONS_PRODUCTS WHERE PROM_CONDITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_condition_id#">
        </cfquery>
		<cfoutput>
            <cfquery name="add_prom_prod" datasource="#dsn3#">
                <cfloop from="1" to="#line_count#" index="k">
                    INSERT INTO
                        PROMOTION_CONDITIONS_PRODUCTS
                    (
                        PROM_CONDITION_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        PRODUCT_AMOUNT,
                        IS_SALE_WITH_PROM
                    )
                    SELECT
                        #attributes.prom_condition_id# AS PROM_CONDITION_ID,
                        PRODUCT_ID,
                        STOCK_ID,
                        1 AS PRODUCT_AMOUNT,
                        0 AS IS_SALE_WITH_PROM
                    FROM
                        STOCKS
                    WHERE
                        STOCK_CODE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(ListGetAt(dosya[k],1,';'))#">
                </cfloop>
            </cfquery>
        </cfoutput>
        <cfquery name="get_prom" datasource="#dsn3#">
            SELECT COUNT(STOCK_ID),STOCK_ID,PROM_CONDITION_ID FROM PROMOTION_CONDITIONS_PRODUCTS WHERE PROM_CONDITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_condition_id#">
            GROUP BY STOCK_ID,PROM_CONDITION_ID HAVING COUNT(STOCK_ID) > 1
        </cfquery>
        <cfloop query="get_prom">
            <cfquery name="get_prom_products" datasource="#dsn3#">
                SELECT MIN(CONDITION_PRODUCT_ID) CONDITION_PRODUCT_ID from PROMOTION_CONDITIONS_PRODUCTS WHERE PROM_CONDITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_condition_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom.stock_id#">
            </cfquery>
            <cfquery name="del_prom_products" datasource="#dsn3#">
                DELETE FROM PROMOTION_CONDITIONS_PRODUCTS WHERE PROM_CONDITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.prom_condition_id#"> AND STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom.stock_id#"> AND CONDITION_PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#get_prom_products.condition_product_id#">
            </cfquery>
        </cfloop>
        <script type="text/javascript">
			history.back();
		</script>
    </cfif>
</cfif>
