<cfif not isdefined("attributes.kasa_numarasi") or not listlen(attributes.kasa_numarasi)>
	<script>
		alert('Kasa Seçmelisiniz!');
		history.back();
	</script>
    <cfabort>
</cfif>


<cf_date tarih='attributes.startdate'>
<cfset yil_ = year(attributes.startdate)>
<cfset ay_ = month(attributes.startdate)>
<cfset gun_ = day(attributes.startdate)>
<cfquery name="get_rows" datasource="#dsn_dev#">
	SELECT 
    	ACTION_ID
    FROM 
    	GENIUS_ACTIONS 
    WHERE 
    	KASA_NUMARASI IN (#attributes.kasa_numarasi#) AND
        YEAR(FIS_TARIHI) = #yil_# AND
        MONTH(FIS_TARIHI) = #ay_# AND
        DAY(FIS_TARIHI) = #gun_#
</cfquery>
<cfif get_rows.recordcount>
	<cfset action_list = valuelist(get_rows.ACTION_ID)>
    
    <!--- zvarmi --->
    <cfquery name="get_cont" datasource="#dsn_Dev#">
        SELECT 
        	CON_ID 
        FROM 
        	POS_CONS 
        WHERE 
        	YEAR(CON_DATE) = #yil_# AND
            MONTH(CON_DATE) = #ay_# AND
            DAY(CON_DATE) = #gun_# AND
            KASA_NUMARASI IN (#attributes.kasa_numarasi#)
    </cfquery>
    <!--- zvarmi --->
    
    <cfif get_cont.recordcount>
    	Kasaların İlgili Güne Ait Z Raporu Kayıtları Bulunmaktadır! Genius Aktarım Silemezsiniz!
		<script>
            alert('Kasaların İlgili Güne Ait Z Raporu Kayıtları Bulunmaktadır! Genius Aktarım Silemezsiniz!');
            history.back();
        </script>
    	<cfabort>
    </cfif>
    
    <cftransaction>
        <cfquery name="del_actions" datasource="#dsn_dev#">
            DELETE FROM 
                GENIUS_ACTIONS 
            WHERE 
                ACTION_ID IN (#action_list#)
        </cfquery>
        
        <cfquery name="del_action_rows" datasource="#dsn_dev#">
            DELETE FROM 
                GENIUS_ACTIONS_ROWS 
            WHERE 
                ACTION_ID IN (#action_list#)
        </cfquery>
        
        <cfquery name="del_action_payments" datasource="#dsn_dev#">
            DELETE FROM 
                GENIUS_ACTIONS_PAYMENTS
            WHERE 
                ACTION_ID IN (#action_list#)
        </cfquery>
        
        <cfquery name="del_action_stock_rows" datasource="#dsn_dev#">
            DELETE FROM 
                #dsn2_alias#.STOCKS_ROW
            WHERE 
                PROCESS_TYPE = -1003 AND
                UPD_ID IN (#action_list#) AND
                YEAR(PROCESS_DATE) = #year(attributes.startdate)# AND
                MONTH(PROCESS_DATE) = #month(attributes.startdate)# AND
                DAY(PROCESS_DATE) = #day(attributes.startdate)#
        </cfquery>
    </cftransaction>
	İşlemler Tamamlandı!
    <script>
		alert('İşlemler Tamamlandı!');
		window.location.href = 'index.cfm?fuseaction=retail.genius_clear_rows';
	</script>
<cfelse>
	İşlem Yapılacak Satır Bulunamadı!
    <script>
		alert('İşlem Yapılacak Satır Bulunamadı!');
		history.back();
	</script>
</cfif>
<cfabort>