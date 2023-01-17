<cfif not isdefined("caller.lang_array_main")>
	<cfset caller = caller.caller>
</cfif>
<cfset sira = listFindNoCase(application.langsAllList,session.ep.language,',')>
<cftry>
<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>
	<cfscript>
		l_deger_ = listGetAt(caller.lang_array_all.item['#trim(ListFirst(attributes.dictionary_id,'.'))#'],sira,'█');
		 if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1){
			d_id = trim(ListFirst(attributes.dictionary_id,'.'));
			arrayappend(request.pagelangList,{id:d_id,deger:replace(l_deger_,"'","","all"),type:'dictionary',module:''});
		 }
		writeoutput(l_deger_);
	</cfscript>
<cfelse>
	<cfscript>
		if(len(caller.lang_array_main.item[trim(listfirst(attributes.no,'.'))]))
		{
				l_deger_ = listGetAt(caller.lang_array_main.item['#trim(ListFirst(attributes.no,'.'))#'],sira,'█');
				if(isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1)
				arrayappend(request.pagelangList,{id:listfirst(attributes.no,'.'),deger:replace(l_deger_,"'","","all"),type:'module',module:'main'});
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
	<!---<cfif not isdefined("session.ep.lang_change_action") or (isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 0)>
  		<cfoutput>#listGetAt(caller.lang_array_main.item['#trim(ListFirst(attributes.no,'.'))#'],sira,'█')#</cfoutput>
	</cfif>---->
</cfif>
<cfcatch type="any">
	<cfif isdefined("attributes.dictionary_id") and len(attributes.dictionary_id)>
		<cfoutput>#attributes.dictionary_id#</cfoutput> : Tanımsız
	<cfelse>
		<cfif isdefined("attributes.no") and len(attributes.no)>
			<cfoutput>#attributes.no#</cfoutput> : Tanımsız
		<cfelse>
			Tanımsız
		</cfif>
	</cfif>
</cfcatch>
</cftry>
