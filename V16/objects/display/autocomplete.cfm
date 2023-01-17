<cfsetting showdebugoutput="no">
<cfparam name="attributes.id" default="a_#round(rand()*10000000)#">
<cfparam name="attributes.isNotDeleting" default="0"> <!--- kelime bulunamadığı zaman inputa yazılan değer silmesin diye eklendi. '1' gönderilirse silinmez. default 0 olarak atandı. BotanKaygan 13.01.2020 --->
<cfparam name="URL.mask" default="">
<cfparam name="URL.query" default="">
<cfparam name="URL.extra_params" default="">
<cfparam name="attributes.oldValue" default="">
<cfset mask1 = URLDecode(URL.mask,"utf-8")>
<cfset mask1 = Replace(mask1,"'","''","all")>
<!---<cfset mask2 = Replace(mask1,"'","\'","all")>--->
<cfset url.extra_params = "#URLDecode(url.extra_params,"windows-1254")#">
<cfset url.extra_params = Replace(url.extra_params, "%u0131", "ı", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u0130", "İ", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u015F", "ş", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u015E", "Ş", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u011F", "ğ", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u011E", "Ğ", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u00F6", "ö", "ALL")>
<cfset url.extra_params = Replace(url.extra_params, "%u00D6", "Ö", "ALL")>
<cfif attributes.projectControl neq 0>
	<script type="text/javascript">
		function controlProject()
		{
			var get_basket_member_info = wrk_safe_query('obj_get_basket_project_info', 'dsn3', 0, '<cfoutput>#attributes.projectControl#</cfoutput>');
			if(get_basket_member_info.recordcount)
			{
				alert("<cf_get_lang dictionary_id='32683.Belgede Satırlar Seçilmiş Proje Değiştiremezsiniz'>");
				gizle(<cfoutput>#URL.divName#</cfoutput>);
				<cfif len(attributes.isNotDeleting) and attributes.isNotDeleting eq "0">reloadOldValue(<cfoutput>'#attributes.AutoCompleteId#','#attributes.oldValue#'</cfoutput>);</cfif>
				return false;
			}
		}
		controlProject();
	</script>
</cfif>
<cfinclude template="/workdata/#URL.query#.cfm">
<cf_box title="#mask1#" closable="1" collapsable="0" draggable="0" resize="0">
	<!--- <span onclick="gizle(<cfoutput>#URL.divName#</cfoutput>); <cfif len(attributes.isNotDeleting) and attributes.isNotDeleting eq "0">reloadOldValue(<cfoutput>'#attributes.AutoCompleteId#','#attributes.oldValue#'</cfoutput>);</cfif>" class="catalystClose2" title="<cf_get_lang dictionary_id='57553.Kapat'>">×</span> --->
<cfset get_js_query = evaluate("#url.query#('#mask1#',#URLdecode(url.extra_params,'windows-1254')#)")>
<cfset i=0>

	<ul class="list">
		<cfoutput query="get_js_query">
			<div class="odd" id="auto_cmp_row">
        	<input type="hidden" id="#attributes.id#_#currentrow#_#currentrow#" value="<cfloop list="#URL.column_visible#" index="txt">#evaluate('get_js_query.#txt#')#<cfbreak></cfloop>" />
        	<cfloop list="#URL.column_value#" index="txt" >
            	<input type="hidden" value="#evaluate('get_js_query.#txt#')#" />
        	</cfloop>
			<li id="#attributes.id#_#currentrow#" onclick="setAtt('#URL.AutocompleteId#',#i#,false)">
        		<cfset str="">
        		<cfloop list="#URL.column_visible#" index="txt">
        			<cfset str = str & "#evaluate('get_js_query.#txt#')# - ">     
        		</cfloop>
        		<cfif url.query is 'get_department_name_autocomplete' and isdefined("department_status")>
            		<cfif (len(get_js_query.location_status) and get_js_query.location_status eq 1) or (not len(get_js_query.location_status) and get_js_query.department_status eq 1)>#left(str,len(str)-3)#<cfelse><span style="color:red;">#left(str,len(str)-3)#</span></cfif>
            		<cfelse>
            		<cftry>
                		#left(str,len(str)-3)#
                	<cfcatch>#left(str,len(str)-2)#</cfcatch>
                	</cftry>
            	</cfif>
			</li>	
			<cfset i = i + 1>    
		</div>      
		</cfoutput>
	</ul>

<cfif i eq 1>
	<div id="auto_cmp_row" style="display:none;"></div>
</cfif>
<cfif i eq 0>	
		<p><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'></p>
</cfif>   
<cfif i neq 0>
	<script type="text/javascript">
		<cfoutput>
			//setAtt('#URL.AutocompleteId#',0,true);
		</cfoutput>
	</script>
</cfif>
</cf_box>