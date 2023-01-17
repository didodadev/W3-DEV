<cffile action = "upload" 
        fileField = "uploaded_file" 
        destination = "#upload_folder#"
        nameConflict = "MakeUnique"  
        mode="777" charset="utf-8">
<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="utf-8">
<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="utf-8">
<cffile action="delete" file="#upload_folder##file_name#">

<cfscript>
    CRLF = Chr(13) & Chr(10);// satır atlama karakteri
    dosya = Replace(dosya,';;','; ;','all');
    dosya = Replace(dosya,';;','; ;','all');
    dosya = ListToArray(dosya,CRLF);
    line_count = ArrayLen(dosya);
    satir_no =0;
</cfscript>
<cfset columnList = listToArray(replace(dosya[1],chr(34),"","ALL"),";") />
<cftry>
    <cfloop from="2" to="#line_count#" index="i">
        <cfloop from="1" to="#arrayLen(columnList)#" index="j">
            <cfif listFindNoCase(attributes.langs, columnList[j])>
                <cfset values = listToArray(dosya[i],";") />
                <cfif len( values[j] ) gte 3>
                    <cfset langValue = replace(values[j],'"',"'",'ALL') />
                    <cfset dictionary_id = replace(values[1],chr(34),"","ALL") />
                    <cfquery name="set_language" datasource="#dsn#">
                        UPDATE SETUP_LANGUAGE_TR SET ITEM_#UCase(columnList[j])# = <cfqueryparam value="#langValue#" cfsqltype="cf_sql_nvarchar">, UPDATE_DATE = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> WHERE DICTIONARY_ID = #dictionary_id#
                    </cfquery>
                </cfif>
            </cfif>
        </cfloop>
    </cfloop>
    <cfcatch type="any">
        <script type="text/javascript">
            alert("<cf_get_lang dictionary_id='59966.Dosya Yükleme İle İlgili Bir Sorun Oluştu'>! - <cf_get_lang dictionary_id='58508.Satır'>: <cfoutput>#i - 1#</cfoutput>");
        </script>
        <cfdump var = "#cfcatch#" abort>   
    </cfcatch>
</cftry>

<script type="text/javascript">
    alert('<cf_get_lang dictionary_id='44519.İşlem Tamamlandı'>!');
    location.reload();
</script>