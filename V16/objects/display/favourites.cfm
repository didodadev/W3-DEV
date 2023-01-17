<cfstoredproc procedure="FAVOUTIRES" datasource="#dsn#">
	<cfprocparam TYPE="IN" cfsqltype="cf_sql_integer" value="#session.ep.userid#">
	<cfprocresult name="GET_ALL">
</cfstoredproc>
<div style="display:none;">
<form name="fav_form_" action="" method="post"> 
    <cfif GET_ALL.recordcount>
        <div style="display:none;height:100px;" id="fav_form_elements"></div>
        <select name="URL" id="URL" onchange="TusOku(this.value)" class="favorit">
            <option value="-1"><cf_get_lang dictionary_id='57424.Sık Kullanılanlar'></option> 	
            <cfset URLindex=0>
            <cfoutput query="get_all">
                <cfset URLindex=URLindex+1>
                <option value="#favorite[currentrow]#|@|#favorite_shortcut_key#|@|#is_new_page#" id="id_#URLindex#">#favorite_name[currentrow]# <cfif len(favorite_shortcut_key)>(#favorite_shortcut_key#)</cfif></option>
            </cfoutput>
        </select>
    </cfif> 
</form>
</div>
