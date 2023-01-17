<cfparam name="attributes.id" default="table_#round(rand()*10000000)#">
<cfparam name="attributes.style" default="display">
<cfset degerim_ = thisTag.GeneratedContent>
<cfset thisTag.GeneratedContent =''>
<cfset caller.td_id = attributes.id>
<cfif thisTag.executionMode eq "start">
	
	<cfset width_degeri = 0>

		<cfset deger ="STYLE,COLUMN_WIDTH_LIST,ID">
		<cfset count=StructCount(attributes)>
		<cfset list_=''>
		<cfloop from="1" to="#count#" index="cc">
			<cfset caller.att= listgetat("STYLE,COLUMN_WIDTH_LIST,ID",cc)>
			<cfset listem='#caller.att#="#evaluate('attributes.#caller.att#')#" '>
			<cfset listem= ''>
			<cfset list_=listappend(list_,listem)>
        
		<cfif caller.att eq 'column_width_list'>
			<cfset deger =evaluate('attributes.#caller.att#')>
            <cfif deger contains '%'>
				<cfset 'caller.li_width_1' = ListGetAt(deger,1,',')>
                <cfset width_degeri = Evaluate('caller.li_width_1')>
            <cfelse>
                <cfloop index="aa" from="1" to="#ListLen(deger,',')#">
                    <cfset 'caller.li_width_#aa#' = ListGetAt(deger,aa,',')>
                    <cfset width_degeri = width_degeri + Evaluate('caller.li_width_#aa#')>
                </cfloop>
            </cfif>
        </cfif>
        </cfloop>
        
        <cfoutput>
			<td id="#attributes.id#" valign="top" <cfif len(attributes.style)>style="#attributes.style#;"</cfif>>
            	<table cellspacing="0">
        </cfoutput>
<cfelse>
	<cfoutput>#degerim_#</cfoutput>
    </table>
	</td>
    <script type="text/javascript">
    	<cfoutput>
			<cfif width_degeri contains '%'>
				<cfset width_degeri = width_degeri>
			<cfelse>
				<cfset width_degeri = width_degeri&'px'>
			</cfif>
				document.getElementById("#attributes.id#").style.width = '#width_degeri# !important';
		</cfoutput>
    </script>
	<cfif caller.tr_sayac eq caller.hidden_tr_length>
    	<script type="text/javascript">
        	document.getElementById("<cfoutput>#attributes.id#</cfoutput>").style.display = 'none';
        </script>
    </cfif>
	<cfset caller.tr_sayac = 0>
	<cfset caller.hidden_tr_length = 0>
	<cfset caller.li_sayac = 0>
</cfif>
