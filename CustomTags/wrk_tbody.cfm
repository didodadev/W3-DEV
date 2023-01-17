<cfparam name="attributes.query_name" default="">
<cfparam name="attributes.hidden_input" default="">
<cfparam name="attributes.extra_url_parameter" default="">
<cfparam name="page_" default="1">
<cfparam name="maxrows_" default="#session.ep.maxrows#">
<cfparam name="attributes.big_list_thead_id" default="big_list_id">
<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode neq "start">
	<cfif evaluate('caller.#attributes.query_name#.recordcount')>
		<tbody>
			<cfoutput>#degerim_#</cfoutput>
		</tbody>
		</table>
		<cfif isdefined("caller.form.fieldnames")>
			<cfset inputs = caller.form.fieldnames>
            <cfset input_sayisi = listlen(inputs)>
            <cfset adres_ = caller.url.fuseaction>
            <cfset attributes.fuseaction = caller.url.fuseaction>
            <cfloop index="aaa" from="1" to="#input_sayisi#">
                <cfif len(evaluate('form.#listgetat(inputs,aaa)#'))>
                    <cfset input_value = evaluate('form.#listgetat(inputs,aaa)#')>
                    <cfif listgetat(inputs,aaa) contains 'maxrows'>
                        <cfset maxrows_ = evaluate('form.#listgetat(inputs,aaa)#')>
                    <cfelseif listgetat(inputs,aaa) contains 'page_'>
                        <cfset page_ = evaluate('form.#listgetat(inputs,aaa)#')>
                    <cfelse>
                        <cfset adres_ = adres_ & '&' & listgetat(inputs,aaa,',') & "=" & input_value>
                    </cfif>
                </cfif>
            </cfloop>
            <cfif len(attributes.extra_url_parameter)>
                <cfif not adres_ contains attributes.extra_url_parameter>
                    <cfset adres_ = adres_ & '&' & attributes.extra_url_parameter>
                </cfif>
            </cfif>
            <cfset startrow = ((page_-1)*maxrows_) + 1 >
                       		<cf_paging 
                            page="#page_#" 
                            maxrows="#maxrows_#" 
                            totalrecords="#evaluate('caller.#attributes.query_name#.recordcount')#" 
                            startrow="#startrow#" 
                            adres="#adres_#">
            </cfif>
	<cfelse>
    	<cfoutput>
            <tbody>
                <tr>
                    <td id="last_td"><cfif isdefined("#attributes.hidden_input#")>#caller.getLang('main',72)#!<cfelse>#caller.getLang('main',289)#!</cfif></td><!---Kayıt Yok Filtre Ediniz--->
                </tr>
            </tbody>
			<script type="text/javascript">
                var count = 0;
                metin = document.getElementById('#attributes.big_list_thead_id#').innerHTML;
				if(metin.indexOf('</th>') == -1)
				{
					do
					{
						if(metin.indexOf('</TH>') != -1)
						{
							metin = metin.substr(metin.indexOf('</TH>')+5,metin.length);
							count = count + 1;
						}
					}
	                while(metin.indexOf('</TH>') != -1)
				}
				else
				{
					do
					{
						if(metin.indexOf('</th>') != -1)
						{
							metin = metin.substr(metin.indexOf('</th>')+5,metin.length);
							count = count + 1;
						}
					}
	                while(metin.indexOf('</th>') != -1)
				}
                document.getElementById('last_td').setAttribute('colspan',count);
            </script>
        </cfoutput>
		</table>
	</cfif>
</cfif>

