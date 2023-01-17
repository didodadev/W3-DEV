<cflock name="#createUUID()#" timeout="60">			
	<cftransaction>
		<cfquery name="GET_ALL_DEKONT" datasource="#dsn2#">
			SELECT DEKONT_ROW_ID FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfscript>
			for (k = 1; k lte get_all_dekont.recordcount;k=k+1)
			{
				cari_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:attributes.process_type);
				butce_sil(action_id:get_all_dekont.DEKONT_ROW_ID[k],process_type:attributes.process_type);
			}
		</cfscript>
		<cfquery name="DEL_DEKONT" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="DEL_DEKONT_ROW" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_ROW WHERE DEKONT_ID = #attributes.dekont_id#
		</cfquery>
		<cfquery name="DEL_MONEY" datasource="#dsn2#">
			DELETE FROM #dsn_alias#.EMPLOYEES_PUANTAJ_CARI_ACTIONS_MONEY WHERE ACTION_ID = #attributes.dekont_id#
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
