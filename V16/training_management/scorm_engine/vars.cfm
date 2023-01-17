<!--- Global Vars --->
<cfset PARAM_NAME_VERSION = "wrk.sco.version">
<cfset PARAM_NAME_USER_TYPE = "wrk.sco.userType">

<cfset APPLICATION_DB = "#dsn#">
<cfset TABLE_SCO = "TRAINING_CLASS_SCO">
<cfset TABLE_SCO_DATA = "TRAINING_CLASS_SCO_DATA">
<cfset TABLE_SCO_OBJ = "TRAINING_CLASS_SCO_OBJ">

<cfset UPLOAD_DIR_SHORT = "documents\scorm_engine\course\">
<cfset UPLOAD_DIR_LONG = "#expandPath('/')##UPLOAD_DIR_SHORT#">

<cfset PAGE_API = "index.cfm?fuseaction=training.popup_api&">
<cfset PAGE_RTE = "index.cfm?fuseaction=training.popup_rte&">
<cfset PAGE_COMMIT = "index.cfm?fuseaction=training.popup_commit&">
<cfset PAGE_FINISH = "index.cfm?fuseaction=training.popup_finish&">

<cfif isdefined('session.ep')>
	<cfset SESSION_USER_TYPE = 0>
    <cfif not isDefined("session.ep.userid")>
    	<cfset SESSION_USER_ID = 0>
	    <cfset SESSION_USER_NAME = "">
	    <cfset SESSION_USER_SURNAME = "">
        <cfset SESSION_IS_GUEST = true>
    <cfelse>
    	<cfset SESSION_USER_ID = "session.ep.userid">
    	<cfset SESSION_USER_NAME = "session.ep.name">
	    <cfset SESSION_USER_SURNAME = "session.ep.surname">
        <cfset SESSION_IS_GUEST = false>
    </cfif>
<cfelseif isdefined('session.pp')>
	<cfset SESSION_USER_TYPE = 1>
    <cfif not isDefined("session.pp.userid")>
    	<cfset SESSION_USER_ID = 0>
	    <cfset SESSION_USER_NAME = "">
	    <cfset SESSION_USER_SURNAME = "">
        <cfset SESSION_IS_GUEST = true>
    <cfelse>
	    <cfset SESSION_USER_ID = "session.pp.userid">
    	<cfset SESSION_USER_NAME = "session.pp.name">
	    <cfset SESSION_USER_SURNAME = "session.pp.surname">
        <cfset SESSION_IS_GUEST = false>
	</cfif>
<cfelseif isdefined('session.ww')>
	<cfset SESSION_USER_TYPE = 2>
    <cfif not isDefined("session.ww.userid")>
    	<cfset SESSION_USER_ID = 0>
	    <cfset SESSION_USER_NAME = "">
	    <cfset SESSION_USER_SURNAME = "">
        <cfset SESSION_IS_GUEST = true>
    <cfelse>
	    <cfset SESSION_USER_ID = "session.ww.userid">
	    <cfset SESSION_USER_NAME = "session.ww.name">
	    <cfset SESSION_USER_SURNAME = "session.ww.surname">
        <cfset SESSION_IS_GUEST = false>
	</cfif>
<cfelse>
	<cfset SESSION_USER_TYPE = -1>
    <cfset SESSION_USER_ID = 0>
	<cfset SESSION_USER_NAME = "">
    <cfset SESSION_USER_SURNAME = "">
    <cfset SESSION_IS_GUEST = true>
</cfif>
