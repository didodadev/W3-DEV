<cfif isdefined("attributes.active")>
    <cfquery name="CHECK_KONTROL" datasource="#DSN#">
        UPDATE PASSWORD_CONTROL SET PASSWORD_STATUS = 0
    </cfquery>
</cfif>
<cfquery  name="VERI_GUNCELLE" datasource="#dsn#">
    UPDATE 
        PASSWORD_CONTROL
    SET
        PASSWORD_LENGTH = #form.SIFRE_UZUNLUK#,
        PASSWORD_LOWERCASE_LENGTH = #form.KUCUK_HARF_UZUNLUK#,
        PASSWORD_UPPERCASE_LENGTH = #form.BUYUK_HARF_UZUNLUK#,
        PASSWORD_NUMBER_LENGTH = #form.RAKAM_UZUNLUK#,
        PASSWORD_SPECIAL_LENGTH = #form.OZEL_KARAKTER_UZUNLUK#,
        PASSWORD_HISTORY_CONTROL = #form.KONTROL_SAYISI#,
        PASSWORD_CHANGE_INTERVAL = #form.KONTROL_GUN#,
        PASSWORD_NAME = '#form.PASSWORD_NAME#',
        FAILED_LOGIN_COUNT = '#form.LOGIN_COUNT#',
        PASSWORD_STATUS = <cfif isdefined("attributes.active")>1<cfelse>0</cfif>,
        UPDATE_IP = '#cgi.remote_addr#',
        UPDATE_DATE = #now()#,
        UPDATE_EMP = #session.ep.userid#
   WHERE 
        PASSWORD_ID = #form.update#
</cfquery>
<cfobject name="inst_plevne_settings" type="component" component="AddOns.Plevne.models.settings">
<cfif isDefined("form.MFA_ENABLED") and len(form.MFA_ENABLED)> 
    <cfset inst_plevne_settings.save_plevne_setting(SETTING_ID: "-1", SETTING_KEY: "MFA_ENABLED", SETTING_VALUE: #form.MFA_ENABLED#)>
</cfif>
<cfif isDefined("form.MFA_UNTIL") and len(form.MFA_UNTIL)> 
    <cfset inst_plevne_settings.save_plevne_setting(SETTING_ID: "-1", SETTING_KEY: "MFA_UNTIL", SETTING_VALUE: #form.MFA_UNTIL#)>
</cfif>
<cflocation url="#request.self#?fuseaction=settings.form_upd_password_inf&ID=#form.update#" addtoken="no">
