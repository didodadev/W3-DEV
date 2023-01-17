<!--- XML AKTARIM SIHIRBAZI --->
<cf_form_box title="#getLang('settings',1422)#">
	<table>
    	<tr>
        	<td><cf_get_lang no='1428.Database seçip gelen ekrandan uygun tablo seçerek bu tabloya uygun'> <cf_get_lang no='1429.XML dosya upload edilip import işlemi yapılır'></td>
        </tr>
    </table> 
    <br />       
	<cfif isdefined("attributes.sub_mitted")>
        <cffile action="read" file="#attributes.file_path#" variable="xmldosyam" charset="UTF-8">
        <cfscript>
            dosyam = XmlParse(xmldosyam);
            str_root = dosyam.XmlRoot.XmlName;
            xml_dizi = Evaluate("dosyam.#str_root#.XmlChildren");
            d_boyut = ArrayLen(xml_dizi);
        </cfscript>
        <cfset str_table_names = "">
        <cfset str_value_names = "">
        :<cfoutput>#attributes.chk_period#</cfoutput><br/>
        :<cfoutput>#str_period_name#</cfoutput><br/>
        :<cfoutput>#attributes.table_selected#</cfoutput><br/>
        <cfoutput>
            <cfloop index="i" from="1" to ="#d_boyut#">
                <cfset str_table_names = "">
                <cfset str_value_names = "">		
                <cfset arr_boyut_2 = ArrayLen(Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren")) >
                <cfloop from="1" to="#arr_boyut_2#" index="j">
                    <cfif isdefined("attributes.is_used#j#") and len(Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren[j].xmlText"))> 
                        <cfset str_table_names=ListAppend(str_table_names,Evaluate("attributes.column_name#j#"),",")>
                        <cfif Evaluate("attributes.data_type#j#") eq 1>
                            <cfset str_value_names = ListAppend(str_value_names,Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren[j].xmlText"),",")>
                        <cfelse>
                            <cfif len(str_value_names)>
                                <cfset str_value_names = "#str_value_names#," & chr(39) & Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren[j].xmlText") & chr(39)>
                            <cfelse>
                                <cfset str_value_names = chr(39) & Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren[j].xmlText") & chr(39)>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
                <cfquery datasource="#attributes.str_period_name#"> 
                    INSERT INTO #table_selected# (#str_table_names#) VALUES (#PreserveSingleQuotes(str_value_names)#)
                </cfquery> 
            </cfloop>
        </cfoutput>	
        <cflocation addtoken="no" url="#request.self#?fuseaction=settings.xml_cycle">
    <cfelse>
        <cfform name="my_form"  action="#request.self#?fuseaction=settings.xml_cycle" enctype="multipart/form-data"  >
            <!--- Veritabani gelicek > TABLO > ALANLAR  --->
            <cfquery name="get_period" datasource="#DSN#">
                SELECT 
                    PERIOD_ID, 
                    PERIOD, 
                    PERIOD_YEAR, 
                    OUR_COMPANY_ID, 
                    RECORD_DATE, 
                    RECORD_IP, 
                    RECORD_EMP, 
                    UPDATE_DATE, 
                    UPDATE_IP, 
                    UPDATE_EMP
                FROM 
                    SETUP_PERIOD <cfif isdefined("attributes.chk_period")> WHERE PERIOD_ID=#attributes.chk_period#</cfif>
            </cfquery>
            <table>
				<cfif not isdefined("attributes.chk_period")>
                    <tr>
                        <td colspan="3">
                            <select name="islem_cesit" id="islem_cesit">
                                <option value="1"><cf_get_lang no='1423.Ana Veritabanı'></option>
                                <option value="3"><cf_get_lang no='1424.Firma Veritabanı'> </option>
                                <option value="2"><cf_get_lang no='1425.Muhasebe Veritabanı'></option>
                                <option value="4"><cf_get_lang dictionary_id='43562.Ürün Veritabanı'></option>
                            </select>
                        </td>
                    </tr>
                    <cfoutput query="get_period">
                        <tr>
                            <td><input type="radio" name="chk_period" id="chk_period" <cfif currentrow eq 1>checked</cfif> value="#PERIOD_ID#"></td>
                            <td colspan="2">#PERIOD#</td>
                        </tr>
                    </cfoutput>
                <cfelseif not isdefined("attributes.table_selected")>
                    <cfif attributes.islem_cesit eq 2>
                        <cfset str_period_name="#DSN#_#get_period.PERIOD_YEAR#_#get_period.OUR_COMPANY_ID#">
                    <cfelseif attributes.islem_cesit eq 3>
                        <cfset str_period_name="#DSN#_#get_period.OUR_COMPANY_ID#">
                    <cfelseif attributes.islem_cesit eq 4>
                        <cfset str_period_name="#DSN#_product">
                    <cfelse>
                        <cfset str_period_name="#DSN#">
                    </cfif>
                    <cfquery name="get_tables" datasource="#str_period_name#">
                        EXEC sp_tables   
                            @table_name = '%',  
                            @table_owner = '#str_period_name#',  
                            @table_qualifier = NULL,
                            @table_type = "'TABLE'";
                    </cfquery>
                    <cfquery name="get_all_table" dbtype="query">
                        SELECT TABLE_NAME FROM get_tables ORDER BY TABLE_NAME
                    </cfquery>
                    <tr>
                        <td colspan="3">
                            <input type="hidden" name="islem_cesit" id="islem_cesit" value="<cfoutput>#attributes.islem_cesit#</cfoutput>">
                            <input type="hidden" name="chk_period" id="chk_period" value="<cfoutput>#attributes.chk_period#</cfoutput>">				
                            <input type="hidden" name="str_period_name" id="str_period_name" value="<cfoutput>#str_period_name#</cfoutput>">
                            <select name="table_selected" id="table_selected">
                                <cfoutput query="get_all_table">
                                    <option value="#TABLE_NAME#">#TABLE_NAME#</option>
                                </cfoutput>
                            </select>
                        </td>
                    </tr>
                    <tr>
                      <td><cf_get_lang_main no='1688.Döküman'>*</td>
                      <td colspan="2">
                        <input type="FILE"  name="asset" id="asset" style="width:250px;">
                      </td>
                    </tr>
                </cfif>	
            </table>		
        <!--- XML Dokumani geliyor. burasi simcilik boyle --->
        <cfif isdefined("attributes.table_selected")>
            <cftry>
                <cffile action="upload" filefield="asset" destination="#upload_folder#" nameconflict="MakeUnique" mode="777">
                <cfcatch type="Any">
                    <script type="text/javascript">
                        alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
                        history.back();
                    </script>
                    <cfabort>
                </cfcatch>  
            </cftry>		
            <cffile action="read" file="#upload_folder##dir_seperator##cffile.serverfile#" variable="xmldosyam" charset="UTF-8">
            
    <!--- 		<cffile action="read" file="#LEFT(PATH_TRANSLATED,evaluate(LEN(PATH_TRANSLATED)-LEN(PATH_INFO)))#\test\arzu\arzu.xml" variable="xmldosyam" charset = "UTF-8"> --->
            <cfscript>
                dosyam = XmlParse(xmldosyam);
                str_root = dosyam.XmlRoot.XmlName;
                xml_dizi = Evaluate("dosyam.#str_root#.XmlChildren");
                d_boyut = ArrayLen(xml_dizi);
            </cfscript>
            <cfquery name="get_column" datasource="#attributes.str_period_name#" maxrows="1">
                SELECT * FROM #attributes.table_selected#
            </cfquery>
            <table>
                <input type="hidden" name="sub_mitted" id="sub_mitted" value="1" >		
                <input type="hidden" name="chk_period" id="chk_period" value="<cfoutput>#attributes.chk_period#</cfoutput>" >
                <input type="hidden" name="str_period_name" id="str_period_name" value="<cfoutput>#str_period_name#</cfoutput>" >
                <input name="table_selected" id="table_selected" type="hidden" value="<cfoutput>#attributes.table_selected#</cfoutput>" >
                <input type="hidden" name="file_path" id="file_path" value="<cfoutput>#upload_folder##dir_seperator##cffile.serverfile#</cfoutput>" >
                <cfloop index="i" from="1" to ="1">
                    <cfoutput>
                        <cfset arr_boyut_2 = ArrayLen(Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren")) >
                        <cfloop from="1" to="#arr_boyut_2#" index="j">
                            <tr>
                                <td><input name="is_used#j#" id="is_used#j#"  value="#j#" type="checkbox"></td>	
                                <td>#Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren[j].xmlName")#</td>
                                <td>
                                    <input name="xml_item#j#" id="xml_item#j#" type="hidden" value="#Evaluate("dosyam.#str_root#.XmlChildren[i].XmlChildren[j].xmlName")#">
                                    <select name="column_name#j#" id="column_name#j#">
                                        <cfoutput>
                                            <cfloop list="#get_column.columnList#" index="k"><option  value="#k#">#k#</option></cfloop>
                                        </cfoutput>
                                    </select>
                                    <select name="data_type#j#" id="data_type#j#">
                                        <option value="1"><cf_get_lang_main no='786.Sayısal'> - <cf_get_lang_main no='330.Tarih'></option>
                                        <option value="2"><cf_get_lang no='1432.Text Yazi'></option>
                                    </select>
                                </td>
                            </tr>
                        </cfloop>
                    </cfoutput>
                </cfloop>
            </table>     	
    </cfif>
    <cf_form_box_footer>
    	<table align="right">
        	<tr>
            	<td style="text-align:right;"><input type="submit" value="<cf_get_lang no='1427.İsleme Basla'>"></td>
            </tr>
        </table>
    </cf_form_box_footer>
</cfform>
</cfif>
</cf_form_box>
