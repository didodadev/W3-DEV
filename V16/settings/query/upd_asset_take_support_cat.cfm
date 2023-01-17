<cfquery name="upd_asset_state" datasource="#DSN#">
   UPDATE 
		 ASSET_TAKE_SUPPORT_CAT
   SET
		TAKE_SUP_CAT = '#TAKE_SUP_CAT#',
		DETAIL = '#DETAIL#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#
   WHERE 
		 TAKE_SUP_CATID = #URL.TAKE_SUP_CATID#	 
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.form_add_asset_take_support_cat" addtoken="no">
