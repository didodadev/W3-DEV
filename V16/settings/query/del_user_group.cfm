<cfif not isdefined("attributes.is_default")> 
	<cfscript>
		get_isDefault = createObject("component","V16.settings.cfc.get_isDefault");
		get_isDefault.dsn = dsn;
		get_isDefaults = get_isDefault.get_isDefault(
			isDefault : 1,
			isNotId :1,
			id :user_group_id
		);
    </cfscript>
    <cfif not get_isDefaults.recordcount>
		<script type="text/javascript">
			alert("Geçerli Kullanıcı Grubu Seçili Olan Yetki Grubunu Siliyorsunuz.");
			history.go(-1); 
        </script>
    	<cfabort>
    </cfif>
</cfif>
<cfquery name="DEL_USER_GROUP" datasource="#DSN#">
	DELETE FROM USER_GROUP WHERE USER_GROUP_ID = #user_group_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_user_group" addtoken="no">
