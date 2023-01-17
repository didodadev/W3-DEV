<cfif not isdefined("session.ep") and IsDefined("caller.session.ep")>
    <cfset session.ep = caller.session.ep>
</cfif>
<cfset sira = listFindNoCase(application.langsAllList, IsDefined("session.ep.language") ? session.ep.language : 'tr',',')>
<cftry>
	<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>
        <cfscript>
            l_deger_ = listGetAt(application.langArrayAll['#trim(ListFirst(attributes.dictionary_id,'.'))#'],sira,'█');
             if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1){
                d_id = trim(ListFirst(attributes.dictionary_id,'.'));
                arrayappend(request.pagelangList,{id:d_id,deger:replace(l_deger_,"'","","all"),type:'dictionary',module:''});
              }
            if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1)
                s = chr(124);
            else
                s = '';
            s3= s&l_deger_&s;
            writeoutput(s3);
        </cfscript>
    <cfelse>
        <cfif not isdefined("caller.module_name")>
            <cfset caller = caller.caller>
        </cfif>
        <cfif isdefined("attributes.module_name") and len(attributes.module_name)>
            <cfset caller.module_name = attributes.module_name>
        </cfif>
        <cfscript>
            if(len(listGetAt(application.langArray['#caller.module_name#']['#trim(ListFirst(attributes.no,'.'))#'],sira,'█')))
            {
                l_deger_ = listGetAt(application.langArray['#caller.module_name#']['#trim(ListFirst(attributes.no,'.'))#'],sira,'█');
                 if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1)
                arrayappend(request.pagelangList,{id:listfirst(attributes.no,'.'),deger:replace(l_deger_,"'","","all"),type:'module',module:caller.module_name});
                if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1)
                    s = chr(124);
                else
                    s = '';
                s3= s&l_deger_&s;
                writeoutput(s3);
            }
            else
                writeoutput('??');
        </cfscript>
    </cfif>
<cfcatch>
	<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>
	    <cfoutput>#trim(ListFirst(attributes.dictionary_id,'.'))# Hatası</cfoutput>
    <cfelseif isdefined("attributes.no") and len(attributes.no)>
	    <cfoutput>#trim(ListFirst(attributes.no,'.'))# Hatası</cfoutput>
    <cfelse>
	    <cfoutput>&lt;cf_get_lang&gt; Hatası</cfoutput>
    </cfif>
</cfcatch>
</cftry>