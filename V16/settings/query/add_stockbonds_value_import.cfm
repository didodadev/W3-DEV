<cfset upload_folder_ = "#upload_folder#settings#dir_seperator#">
     <!--- <cfdump var="#upload_folder_#" abort> --->
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777" charset="utf-8">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
    </cftry>
    
	<cftry>
		<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
		<cffile action="delete" file="#upload_folder_##file_name#">
        <cfcatch>
            <script type="text/javascript">
                alert("<cf_get_lang_main no='1653.Dosya Okunamadı Karakter Seti Yanlış Seçilmiş Olabilir'>.");
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
        counter = 0;
        liste = "";
    </cfscript>

    <cfloop from="2" to="#line_count#" index="i">
        <cfset kont=1>
        <cftry>
            <cfset mk_stockbond_id = trim(listgetat(dosya[i],1,';'))>
            <cfset mk_guncel_deger = trim(listgetat(dosya[i],2,';'))>
            <cfset mk_guncel_deger_doviz = trim(listgetat(dosya[i],3,';'))>
            <cfset mk_guncel_deger_tarih = trim(listgetat(dosya[i],4,';'))>
            <cfset mk_para_birimi = trim(listgetat(dosya[i],5,';'))>
            <cfset mk_para_birimi_doviz = trim(listgetat(dosya[i],6,';'))>
            <cfcatch type="Any">
                <cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
                <cfset error_flag = 1>
            </cfcatch>  
        </cftry>

        <!--- Menkul Kıymet Kontrol --->
        <cfquery name="CONTROL_STOCKBONDS" datasource=#dsn3#>
            SELECT STOCKBOND_ID FROM STOCKBONDS WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mk_stockbond_id#">
        </cfquery>
        <cfif CONTROL_STOCKBONDS.recordCount lt 1>
            <script type="text/javascript">
                alert("<cfoutput>#i#</cfoutput>. Satırda Menkul Kıymet Bulunamadı, Kontrol Edin!");
                history.back();
            </script>
            <cfabort>
        </cfif>

        <cf_date tarih='mk_guncel_deger_tarih'>

        <cftransaction>
            <cftry>
                <cfquery name="upd_stockbond" datasource="#dsn3#">
                    UPDATE STOCKBONDS SET 
                        ACTUAL_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(mk_guncel_deger)#">, 
                        OTHER_ACTUAL_VALUE = <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(mk_guncel_deger_doviz)#">
                    WHERE STOCKBOND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mk_stockbond_id#"> 
                </cfquery>

                 <!--- güncel değer history --->
                <cfquery name="add_history" datasource="#dsn3#">
                    INSERT INTO STOCKBONDS_VALUE_CHANGES
                        (
                            STOCKBOND_ID,
                            ACTUAL_VALUE,
                            OTHER_ACTUAL_VALUE,
                            DATE,
                            MONEY_TYPE,
                            OTHER_MONEY_TYPE,
                            RECORD_DATE,
                            RECORD_EMP,
                            RECORD_IP
                        )
                        VALUES(
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#mk_stockbond_id#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(mk_guncel_deger)#">, 
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(mk_guncel_deger_doviz)#">,
                            <cfqueryparam cfsqltype="cf_sql_date" value="#mk_guncel_deger_tarih#">,
                            '#mk_para_birimi#',
                            '#mk_para_birimi_doviz#',
                            #now()#,
                            #session.ep.userid#,
                            '#cgi.REMOTE_ADDR#'
                        )
                </cfquery>
                <cfcatch>
                    <cfoutput>
                        #i#. Satırda Sorun Oluştu. 
                    </cfoutput>	
                    <cfset kont=0>
                </cfcatch>
            </cftry> 
            <cfif kont eq 1>
				<cfoutput>İmport Edildi... <br/></cfoutput>
			</cfif>   
        </cftransaction>

    </cfloop>