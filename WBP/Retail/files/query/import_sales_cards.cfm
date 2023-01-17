<cfsetting showdebugoutput="no">
<cfquery name="CHECK_IMPORTED" datasource="#DSN2#">
    SELECT I_ID FROM FILE_IMPORTS WHERE IMPORTED = 1 AND I_ID = #attributes.i_id#
</cfquery>
<cfif check_imported.recordcount>
    <script type="text/javascript">
        alert('Bu Dosya İmport Edilmiş, Tekrar İmport Edilemez !');
        wrk_opener_reload();
        window.close;
    </script>
    <cfabort>
</cfif>

Aktarım İşlemi Başladı, Lütfen Bekleyiniz...<br/>
<cfinclude template="../../objects/functions/sales_import_functions.cfm">
<cfinclude template="sales_import.cfm">
<script type="text/javascript">
    wrk_opener_reload();
</script>

<cfoutput>
    <hr>
        import satır sayısı : #TOTAL_PRODUCTS#<br/>
        sorunlu satır sayısı : #PROBLEMS_COUNT#<br/>
        Toplam Süre : #timeformat(now()-start_time,'mm:ss')#<br/>
    <hr>
</cfoutput>
