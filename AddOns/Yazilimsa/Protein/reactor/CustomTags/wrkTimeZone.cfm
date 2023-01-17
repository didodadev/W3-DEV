<!--- 16.07.12 Zaman dilimleri select lerini custom tag de toplamak için yapıldı P.Y.  --->
<!--- updDate:16.08.2018 Gönderilen değeri selected hale getirmek amacıyla selected parametresi eklendi. U.H. --->
<cfparam name="attributes.name" default="time_zone">
<cfparam name="attributes.id" default="time_zone">
<cfparam name="attributes.width" default=""> 
<cfparam name="attributes.selected" default="">
<cfif len(attributes.selected) eq 0>
   
    <cfif isdefined("session.ep")>
        <cfset attributes.selected = session.ep.time_zone>
    <cfelseif isdefined("session.pp")>
        <cfset attributes.selected = session.pp.time_zone>
    <cfelseif isdefined("session.pp")>
        <cfset attributes.selected = session.ww.time_zone>
    </cfif>

</cfif>
<!--- tagin içindeki attributeleri alıp yazdırıyor, style in içinden özelliklerde verebiliyoruz böylelikle --->
<cfset deger=Structkeylist(attributes)>
<cfset count=StructCount(attributes)>
<cfset list_=''>
<cfloop from="1" to="#count#" index="cc">
	<cfset att= listgetat(deger,cc)>
	<cfset listem = ''>
    <cfif att is 'width'>
   	<cfelse>
		<cfset listem='#att#="#evaluate('attributes.#att#')#" '>
    </cfif>
	<cfset list_=listappend(list_,listem,' ')>
</cfloop>

<select name="<cfoutput>#attributes.name#</cfoutput>" id="<cfoutput>#attributes.name#</cfoutput>" <cfif isdefined("session.ep")><cfoutput>#list_#</cfoutput></cfif> <cfif len(attributes.width)>style="width:<cfoutput>#attributes.width#</cfoutput>px;"</cfif>>
    <option value="-12" <cfif attributes.selected eq -12>selected</cfif>>(GMT-12:00) International Date Line West</option>
    <option value="-11" <cfif attributes.selected eq -11>selected</cfif>>(GMT-11:00) Midway Island, Samoa</option>
    <option value="-10" <cfif attributes.selected eq -10>selected</cfif>>(GMT-10:00) Hawaii</option>
    <option value="-9"  <cfif attributes.selected eq -9>selected</cfif>>(GMT-09:00) Alaska</option>
    <option value="-8"  <cfif attributes.selected eq -8>selected</cfif>>(GMT-08:00) Pacific Time (US & Canada); Tijuana</option>
    <option value="-7"  <cfif attributes.selected eq -7>selected</cfif>>(GMT-07:00) Mountain Time (US & Canada), Arizona</option>
    <option value="-6"  <cfif attributes.selected eq -6>selected</cfif>>(GMT-06:00) Central Time (US & Canada),Mexico City</option>
    <option value="-5" <cfif attributes.selected eq -5>selected</cfif>>(GMT-05:00) Eastern Time (US & Canada), Indiana(West)</option>
    <option value="-4.5" <cfif attributes.selected eq -4.5>selected</cfif>>(GMT-04:30) Karakas</option>
    <option value="-4" <cfif attributes.selected eq -4>selected</cfif>>(GMT-04:00) Atlantic Time (Canada), Cuiba, Santiago</option>
    <option value="-3.5" <cfif attributes.selected eq -3.5>selected</cfif>>(GMT-03:30) Newfoundland</option>
    <option value="-3" <cfif attributes.selected eq -3>selected</cfif>>(GMT-03:00) Brazil, Buenos Aires, Greenland</option>
    <option value="-2"<cfif attributes.selected eq -2>selected</cfif>>(GMT-02:00) Coordinated Universal Time-02, Mid-Atlantic</option>
    <option value="-1" <cfif attributes.selected eq -1>selected</cfif>>(GMT-01:00) Azores, Cape Verde Is.</option>
    <option value="0" <cfif attributes.selected eq -0>selected</cfif>>(GMT) Greenwich Mean Time : Dublin, Edinburgh, Lisbon, London</option>
    <option value="+1" <cfif attributes.selected eq +1>selected</cfif>>(GMT+01:00) Amsterdam, Berlin, Belgrade, Rome, Paris, Vienna</option>
    <option value="+2" <cfif attributes.selected eq +2>selected</cfif>>(GMT+02:00) Athens, Minsk</option>
    <option value="+3" <cfif attributes.selected eq +3>selected</cfif>>(GMT+03:00) Istanbul, Moscow, St. Petersburg, Kuwait, Baghdad</option>
    <option value="+3.5" <cfif attributes.selected eq +3.5>selected</cfif>>(GMT+03:30) Tehran </option>
    <option value="+4" <cfif attributes.selected eq +4>selected</cfif>>(GMT+04:00) Baku, Tbilisi, Abu Dhabi</option>
    <option value="+4.5" <cfif attributes.selected eq +4.5>selected</cfif>>(GMT+04:30) Kabil</option>
    <option value="+5" <cfif attributes.selected eq +5>selected</cfif>>(GMT+05:00) Islamabad, Tashkent</option>
    <option value="+5.5" <cfif attributes.selected eq +5.5>selected</cfif>>(GMT+05:30) Kalküta, Chennai, Mumbai, New Delhi</option>
    <option value="+5.75" <cfif attributes.selected eq +5.75>selected</cfif>>(GMT+05:45) Kathmandu </option>										
    <option value="+6" <cfif attributes.selected eq +6>selected</cfif>>(GMT+06:00) Novosibirsk, Dakka, Astana</option>
    <option value="+6.5" <cfif attributes.selected eq +6.5>selected</cfif>>(GMT+06:30) Yongan(Rangoon)</option>
    <option value="+7" <cfif attributes.selected eq +7>selected</cfif>>(GMT+07:00) Bangkok, Hanoi, Jakarta, Krasnoyarsk</option>
    <option value="+8" <cfif attributes.selected eq +8>selected</cfif>>(GMT+08:00) Beijing, Chongqing, Hong Kong, Singapore</option>
    <option value="+9" <cfif attributes.selected eq +9>selected</cfif>>(GMT+09:00) Osaka, Seoul, Tokyo</option>
    <option value="+9.5" <cfif attributes.selected eq +9.5>selected</cfif>>(GMT+09:30) Adelaide, Darwin</option>
    <option value="+10" <cfif attributes.selected eq +10>selected</cfif>>(GMT+10:00) Canberra, Melbourne, Sydney</option>
    <option value="+11" <cfif attributes.selected eq +11>selected</cfif>>(GMT+11:00) Magadan, Solomon Is., New Caledonia</option>
    <option value="+12" <cfif attributes.selected eq +12>selected</cfif>>(GMT+12:00) Auckland, Wellington, Fiji</option>
    <option value="+13" <cfif attributes.selected eq +13>selected</cfif>>(GMT+13:00) Nuku'alofa</option>
</select>
