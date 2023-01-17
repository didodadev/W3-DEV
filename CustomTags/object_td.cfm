<cfparam name="attributes.type" default="">
<cfparam name="attributes.td_style" default="">
<cfset degerim_ = thisTag.GeneratedContent>
<cfif degerim_ contains "wrkDepartmentLocationDiv">
	<cfset nowrap_ = 1>
<cfelse>
	<cfset nowrap_ = 0>
</cfif>
<cfset thisTag.GeneratedContent =''>
<cfif thisTag.executionMode eq "start">
	<cfset caller.li_sayac = caller.li_sayac + 1>
    
	<cfset deger=Structkeylist(attributes)>
    <cfset count=StructCount(attributes)>
    
    <cfset list_=''>
    <cfif len(attributes.td_style)>
        <cfloop from="1" to="#count#" index="cc">
            <cfset caller.att= listgetat(deger,cc)>
            <cfset listem='#caller.att#="#evaluate('attributes.#caller.att#')#" '>
            <cfset list_=listappend(list_,listem)>
        </cfloop>
    </cfif>
    
    <cfif evaluate('caller.li_width_1') contains '%'>
	    <cfset li_width_degeri = 'auto'>
    <cfelse>
	    <cfset li_width_degeri = evaluate('caller.li_width_#caller.li_sayac#')&'px'>
    </cfif>
    
    <cfset li_style = "width:#li_width_degeri#; height:20px;">
    
    <cfif attributes.type is 'formbold'>
    	<cfset li_style = li_style & ";font-family:Geneva, Verdana, Arial, sans-serif; font-size : 11px; font-weight: bold;color: ##000000;">
    <cfelseif attributes.type is 'txtbold'>
    	<cfset li_style = li_style & ";font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; color: ##000000;">
    <cfelseif attributes.type is 'txtboldblue'>
    	<cfset li_style = li_style & ";font-weight: bold; font-family:  Geneva, Verdana, Arial, sans-serif; font-size: 10px; padding-right: 1px; padding-left: 1px;">
        <cfswitch expression="#session.ep.DESIGN_COLOR#">
            <cfcase value="1">
            	<cfset li_style = li_style & 'color:##6699CC'>
            </cfcase>
            <cfcase value="2">
            	<cfset li_style = li_style & 'color:##FF6600'>
            </cfcase>
            <cfcase value="3">
            	<cfset li_style = li_style & 'color:##FF6600'>
            </cfcase>
            <cfcase value="4">
            	<cfset li_style = li_style & 'color:##003333'>
            </cfcase>
            <cfcase value="5">
            	<cfset li_style = li_style & 'color:##354860'>
            </cfcase>
            <cfcase value="6">
            	<cfset li_style = li_style & 'color:##008196'>
            </cfcase>
            <cfcase value="7">
            	<cfset li_style = li_style & 'color:##668c40'>
            </cfcase>
        </cfswitch>
    <cfelseif attributes.type is 'text_top'>
    	<cfset li_style = li_style & ";vertical-align:top; padding-top: 5px;">
    </cfif>
    
    <cfif len(attributes.td_style)>
		<cfset li_style = "#li_style##attributes.td_style#">
    </cfif>
    <cfoutput>
        <td <cfif caller.ul_editable eq 0>class="no_image"</cfif> style="#li_style#" <cfif nowrap_ eq 1>nowrap="nowrap"</cfif> <cfloop index="ff" list="#list_#">#ff#</cfloop>>
    </cfoutput>
<cfelse>
	<cfoutput>#degerim_#</cfoutput>
    </td>
</cfif>
