﻿<cftransaction>
	<cfif attributes.is_type eq 1>
        <cfquery name="upd_spect_main" datasource="#dsn3#">
            UPDATE       
                EZGI_SHIP_RESULT
            SET                
                IS_SEVK_EMIR = #attributes.sevk_emir#, 
                SEVK_EMIR_DATE = #now()#
            WHERE        
                SHIP_RESULT_ID = #attributes.upd_id#
        </cfquery>
  	<cfelse>
    	 <cfquery name="upd_spect_main" datasource="#dsn2#">
         	UPDATE       
            	SHIP_INTERNAL
			SET                
            	IS_SEVK_EMIR = #attributes.sevk_emir#, 
                SEVK_EMIR_DATE = #now()#
			WHERE        
            	DISPATCH_SHIP_ID = #attributes.upd_id#
        </cfquery>
    </cfif>
</cftransaction>
<script language="javascript">
   window.close();
   wrk_opener_reload();
</script>