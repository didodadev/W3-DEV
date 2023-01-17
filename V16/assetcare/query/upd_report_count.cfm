<cfif attributes.xml_single_show eq 1>
	<cfif isdefined("attributes.barcode_list") and len(attributes.barcode_list)>
        <cfloop list="#attributes.barcode_list#" index="i">
            <cfif isdefined('attributes.asset_id_#i#') and len(evaluate('attributes.asset_id_#i#'))>
                <cfquery name="upd_asset" datasource="#dsn#">
                    UPDATE
                        ASSET_P
                    SET
                        <cfif isdefined("attributes.process_stage_#i#") and len(evaluate('attributes.process_stage_#i#'))>
                            PROCESS_STAGE = #evaluate('attributes.process_stage_#i#')#,
                        </cfif>
                        <cfif isdefined("attributes.status_#i#") and len(evaluate('attributes.status_#i#'))>
                            ASSETP_STATUS = #evaluate('attributes.status_#i#')#,
                        </cfif>
                        <cfif isdefined("attributes.is_active_#i#") and len(evaluate('attributes.is_active_#i#'))>
                            STATUS = 1,
                        <cfelseif not isdefined("attributes.is_active_#i#")>
                             STATUS = 0,  
                        </cfif>
                        UPDATE_DATE = #NOW()#,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = '#cgi.REMOTE_ADDR#'
                     WHERE
                        ASSETP_ID = #i#	
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>
    <cflocation url="#request.self#?fuseaction=assetcare.asset_counting_report&is_submit=#attributes.is_submit#&page=#attributes.page#" addtoken="no">
<cfelse>
	<!---sistemden Gelenler --->
    <cfif isdefined("attributes.is_counted1")>
       <cfquery name="upd_asset" datasource="#dsn#">
            UPDATE
                ASSET_P
            SET
                <cfif isdefined("attributes.process_stage1") and len(evaluate('attributes.process_stage1'))>
                    PROCESS_STAGE = #evaluate('attributes.process_stage1')#,
                </cfif>
                <cfif isdefined("attributes.status1") and len(evaluate('attributes.status1'))>
                    ASSETP_STATUS = #evaluate('attributes.status1')#,
                </cfif>
                <cfif isdefined("attributes.is_active1") and len(evaluate('attributes.is_active1'))>
                    STATUS = 1,
                <cfelseif not isdefined("attributes.is_active1")>
                     STATUS = 0,  
                </cfif>
                UPDATE_DATE = #NOW()#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            from
                 ASSET_P AS ASSET_P2
            LEFT JOIN
                ####TMP_BARCODE TB
             ON
                 ASSET_P2.BARCODE = TB.BARCODE	 COLLATE TURKISH_CI_AS  
           WHERE 
                TB.BARCODE IS NULL                              
        </cfquery>
    </cfif>
    <!---Dosyadan Gelenler --->
    <cfif isdefined("attributes.is_counted")>
         <cfquery name="upd_asset" datasource="#dsn#">
            UPDATE
                ASSET_P
            SET
                <cfif isdefined("attributes.process_stage") and len(evaluate('attributes.process_stage'))>
                    PROCESS_STAGE = #evaluate('attributes.process_stage')#,
                </cfif>
                <cfif isdefined("attributes.status") and len(evaluate('attributes.status'))>
                    ASSETP_STATUS = #evaluate('attributes.status')#,
                </cfif>
                <cfif isdefined("attributes.is_active") and len(evaluate('attributes.is_active'))>
                    STATUS = 1,
                <cfelseif not isdefined("attributes.is_active")>
                     STATUS = 0,  
                </cfif>
                UPDATE_DATE = #NOW()#,
                UPDATE_EMP = #session.ep.userid#,
                UPDATE_IP = '#cgi.REMOTE_ADDR#'
            from
                 ASSET_P AS ASSET_P2
            LEFT JOIN
                ####TMP_BARCODE TB
             ON
                 ASSET_P2.BARCODE = TB.BARCODE	 COLLATE TURKISH_CI_AS  
           WHERE 
                TB.BARCODE IS NOT  NULL                              
        </cfquery>
    </cfif>
    <cflocation url="#request.self#?fuseaction=assetcare.asset_counting_report&is_submit=#attributes.is_submit#" addtoken="no">
</cfif>

