<cf_get_lang_set module_name="member">
<cfquery name="GET_COMPANY_SECUREFUND" datasource="#dsn2#">
    SELECT 
    	RETURN_PROCESS_CAT,
    	ACTION_PERIOD_ID,
        ACTION_TYPE_ID,
        SECUREFUND_FILE_SERVER_ID,
        SECUREFUND_FILE
    FROM 
    	#dsn_alias#.COMPANY_SECUREFUND 
    WHERE 
    	SECUREFUND_ID = #attributes.securefund_id#
</cfquery>

<cfif GET_COMPANY_SECUREFUND.ACTION_PERIOD_ID neq session.ep.period_id>
	<script type="text/javascript">
		alert("<cf_get_lang no ='572.İşlem Yapmak İstediğiniz Muhasebe Dönemi ile Aktif Muhasebe Döneminiz Farklı Muhasebe Döneminizi Kontrol Ediniz'>!");
		wrk_opener_reload();
		window.close();
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="60">
	<cftransaction>
		<cfif FileExists("#upload_folder#member#dir_seperator##GET_COMPANY_SECUREFUND.SECUREFUND_FILE#")>
			<cf_del_server_file output_file="member/#GET_COMPANY_SECUREFUND.SECUREFUND_FILE#" output_server="#GET_COMPANY_SECUREFUND.SECUREFUND_FILE_SERVER_ID#"> 
		</cfif>
		<cfif len(get_company_securefund.return_process_cat)><!--- İade edilmişse iadenin de muhasebesi siliniyor --->
			<cfquery name="get_process_type" datasource="#dsn2#">
				SELECT 
					PROCESS_TYPE
				FROM 
					#dsn3_alias#.SETUP_PROCESS_CAT 
				WHERE 
					PROCESS_CAT_ID = #get_company_securefund.return_process_cat#
			</cfquery>
			<cfscript>
				muhasebe_sil (action_id:attributes.securefund_id,process_type:get_process_type.process_type);
				cari_sil (action_id:attributes.securefund_id,process_type:get_process_type.process_type);
			</cfscript>
		</cfif>
		<cfquery name="del_secure" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.COMPANY_SECUREFUND WHERE SECUREFUND_ID = #attributes.securefund_id#
		</cfquery>
		<cfquery name="del_secure_money" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.COMPANY_SECUREFUND_MONEY WHERE ACTION_ID = #attributes.securefund_id#
		</cfquery>
		<cfscript>
			muhasebe_sil (action_id:attributes.securefund_id,process_type:GET_COMPANY_SECUREFUND.ACTION_TYPE_ID);
			cari_sil (action_id:attributes.securefund_id,process_type:GET_COMPANY_SECUREFUND.ACTION_TYPE_ID);
		</cfscript>
	</cftransaction>
</cflock>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#attributes.SECUREFUND_ID#</cfoutput>";
</script>
