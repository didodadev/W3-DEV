<cfif isdefined("attributes.active")>
     <cfquery datasource="#dsn#" name="CHECK_KONTROL">
          UPDATE PASSWORD_CONTROL SET PASSWORD_STATUS = 0
     </cfquery> 
</cfif>

<cfquery datasource="#DSN#" name="add_password_inf" result="MAX_ID">
	INSERT INTO PASSWORD_CONTROL
	(
		PASSWORD_LENGTH,
		PASSWORD_LOWERCASE_LENGTH,
		PASSWORD_UPPERCASE_LENGTH,
		PASSWORD_NUMBER_LENGTH,
		PASSWORD_SPECIAL_LENGTH,
		PASSWORD_HISTORY_CONTROL,
		PASSWORD_CHANGE_INTERVAL,
		PASSWORD_NAME,
		FAILED_LOGIN_COUNT,
		PASSWORD_STATUS,
		RECORD_DATE,
		RECORD_IP,
		RECORD_EMP
	)
	VALUES
	(
		#attributes.SIFRE_UZUNLUK#,
		#attributes.KUCUK_HARF_UZUNLUK#,
		#attributes.BUYUK_HARF_UZUNLUK#,
		#attributes.RAKAM_UZUNLUK#,
		#attributes.OZEL_KARAKTER_UZUNLUK#,
		#attributes.KONTROL_SAYISI#,
		#attributes.KONTROL_GUN#,
		'#attributes.PASSWORD_NAME#',
		#attributes.LOGIN_COUNT#,
		<cfif ISDEFINED("attributes.ACTIVE")>1<cfelse>0</cfif>,
		#NOW()#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#
	)
</cfquery>
<cfobject name="inst_plevne_settings" type="component" component="AddOns.Plevne.models.settings">
<cfif isDefined("form.MFA_ENABLED") and len(form.MFA_ENABLED)> 
    <cfset inst_plevne_settings.save_plevne_setting(SETTING_ID: "-1", SETTING_KEY: "MFA_ENABLED", SETTING_VALUE: #form.MFA_ENABLED#)>
</cfif>
<cfif isDefined("form.MFA_UNTIL") and len(form.MFA_UNTIL)> 
    <cfset inst_plevne_settings.save_plevne_setting(SETTING_ID: "-1", SETTING_KEY: "MFA_UNTIL", SETTING_VALUE: #form.MFA_UNTIL#)>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_upd_password_inf&id=#MAX_ID.IDENTITYCOL#" addtoken="no">
