<cfquery name="get_headers" datasource="#dsn_dev#">
	SELECT * FROM SEARCH_TABLES_COLOUMS ORDER BY ROW_ID ASC
</cfquery>

<cfloop  from="1" to="#get_headers.recordcount#" index="ccc">
	<cfif isdefined("attributes.row_id_#ccc#")>
    		<cfset row_id_ = evaluate("attributes.row_id_#ccc#")>
            
            <cfquery name="upd_" datasource="#dsn_Dev#">
            	UPDATE
                	SEARCH_TABLES_COLOUMS
                SET
                	KOLON_OZELAD = '#wrk_eval("attributes.kolon_ozelad_#row_id_#")#',
                    KOLON_FILTRE = <cfif isdefined("attributes.kolon_filtre_#row_id_#")>1<cfelse>0</cfif>,
                    KOLON_FILTRE_TIPI = <cfif len(wrk_eval("attributes.kolon_filtre_tipi_#row_id_#"))>'#wrk_eval("attributes.kolon_filtre_tipi_#row_id_#")#'<cfelse>NULL</cfif>,
                    KOLON_EN = '#wrk_eval("attributes.kolon_en_#row_id_#")#',
                    KOLON_SABIT = <cfif isdefined("attributes.kolon_sabit_#row_id_#")>1<cfelse>0</cfif>,
                    KOLON_ALIGN = '#wrk_eval("attributes.kolon_align_#row_id_#")#',
                    KOLON_ARKA = '#wrk_eval("attributes.kolon_arka_#row_id_#")#',
                    KOLON_YAZI = '#wrk_eval("attributes.kolon_yazi_#row_id_#")#'
                WHERE
                	ROW_ID = #row_id_#
            </cfquery>
    </cfif>
</cfloop>
<script>
    window.location.href="<cfoutput>#request.self#?fuseaction=retail.table_spe</cfoutput>";
</script>