<cfloop from="1" to="#attributes.RECORD_NUM#" index="row_ind"><!--- Satırları döndürüyoruz! --->
	<cfquery name="del_targets" datasource="#dsn#">
        DELETE FROM TARGET WHERE CAMP_ID IS NOT NULL AND TARGETCAT_ID = #Evaluate("attributes.target_cats#row_ind#")#
    </cfquery>
	<cfif Evaluate("attributes.row_kontrol#row_ind#") eq 1><!--- Satır Silinmemiş ise! --->
		<cfloop list="#attributes.camp_id_list#" index="camp_id">
        	<cfif len(Evaluate("attributes.calculation_type_#camp_id#_#row_ind#")) and len(Evaluate("attributes.target_number_#camp_id#_#row_ind#"))><!--- Kampanyaların altındaki hesaplama tipi ve sayısı  seçilmiş ise --->
                <cfquery name="add_targets" datasource="#dsn#">
                	INSERT INTO TARGET
                    ( 
                        TARGETCAT_ID,
                        STARTDATE,
                        FINISHDATE,
                        TARGET_HEAD,
                        TARGET_NUMBER,
                        CALCULATION_TYPE,
                        CAMP_ID,
                        RECORD_EMP,
					    RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
                        #Evaluate("attributes.target_cats#row_ind#")#,
                        #CreateODBCDate(Evaluate("attributes.camp_startdate#camp_id#"))#,
                        #CreateODBCDate(Evaluate("attributes.camp_finishdate#camp_id#"))#,
                        '#wrk_eval("attributes.detail#row_ind#")#',
                        #Evaluate("attributes.target_number_#camp_id#_#row_ind#")#,
                        #Evaluate("attributes.calculation_type_#camp_id#_#row_ind#")#,
                        #camp_id#,
                        #SESSION.EP.USERID#,
						#NOW()#,
                        '#CGI.REMOTE_ADDR#'
                    )                   
               </cfquery>
               
			</cfif>
        </cfloop>
	</cfif>
</cfloop>
<cfoutput>
<i class="margin-top-10 fa fa-cog fa-6 fa-spin"></i>
<script type="text/javascript">
    window.location.href = '<cfoutput>#request.self#?fuseaction=campaign.targets</cfoutput>';
</script>
</cfoutput>
