
<cf_box title="#getlang('','Alias Raporu','65490')#">
    <cfform name="einvoice_taxpayer" method="post">
        <input type="hidden" name="is_submitted" id="is_submitted" value="1">
            <div class="form-group">
            <cf_get_lang dictionary_id="65489.Sistemde kayıtlı fatura ve e-arşiv mükelleflerinin aliaslarını çeker. Çoklayan alias varsa bunlarıda temizler.">
        </div>  
                <cf_box_footer>
                <cf_workcube_buttons button_type="1" add_function='kontrol(0)' insert_info="#getlang('','Çalıştır','57911')#">
                </cf_box_footer>
     
    </cfform>
	<cfif isdefined("is_submitted") and len(attributes.is_submitted)>
		<cfquery name="GETRECORD" datasource="#dsn#">
			SELECT 
				COUNT(EINVOICE_COMP_ID) AS TOTAL, 
				TAX_NO, 
				ALIAS 
			FROM 
				EINVOICE_COMPANY_IMPORT
			WHERE
				(EINVOICE_COMPANY_IMPORT.TAX_NO IN (SELECT TAXNO FROM COMPANY WHERE COMPANY_STATUS = 1  AND TAXNO = EINVOICE_COMPANY_IMPORT.TAX_NO))
				OR
				(EINVOICE_COMPANY_IMPORT.TAX_NO IN (SELECT TC_IDENTITY FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_STATUS = 1  AND TC_IDENTITY = EINVOICE_COMPANY_IMPORT.TAX_NO))
			GROUP BY 
				TAX_NO, 
				ALIAS 
			HAVING 
				(COUNT(EINVOICE_COMP_ID) > 1)
		</cfquery> 
		
		<cfoutput query="getrecord">
			<cfquery name="DELOTHER" datasource="#dsn#">
				DELETE TOP(#total#-1) FROM EINVOICE_COMPANY_IMPORT WHERE TAX_NO = '#trim(getrecord.tax_no)#' AND ALIAS = '#trim(alias)#'
			</cfquery>
		</cfoutput>
		<cf_get_lang dictionary_id="44519.İşlem tamamlandı">!
	</cfif>
</cf_box>
