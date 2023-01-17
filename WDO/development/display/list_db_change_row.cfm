<cfsetting showdebugoutput="no">
<cfquery name="get_db_row" datasource="#dsn#">
	SELECT
	    COMMANDTEXT,
        OBJECTNAME,
		TIME,
        HOSTNAME,
        case  
        	when COMMANDTEXT LIKE '%ALTER%' AND COMMANDTEXT LIKE '%ADD&%' then 'COLUMN ADD' 
            when COMMANDTEXT LIKE '%ALTER%' AND COMMANDTEXT LIKE '%DROP%' then 'COLUMN DROP'
            when COMMANDTEXT LIKE '%CREATE%' AND COMMANDTEXT LIKE '%TABLE%' then 'TABLE CREATE'
            when COMMANDTEXT LIKE '%ALTER%' AND COMMANDTEXT LIKE '%LOCK_ESCALATION%' then 'COULUMN MODIFY' 
            when COMMANDTEXT LIKE '%DROP%' AND COMMANDTEXT LIKE '%TABLE%' AND COMMANDTEXT NOT LIKE '%x0D%' then 'TABLE DROP'
        end as KOMUT		
	FROM
		WRK_DEVELOPMENT_REPORT
	WHERE
		OBJECTNAME='#attributes.object_name#'
	ORDER BY
		TIME DESC
</cfquery>
<cfset kontrol_sayi = 1>
<cf_grid_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang dictionary_id='57487.No'></th>
			<th width="150"><cf_get_lang dictionary_id='41644.İşlemi Yapan'></th>
            <th><cf_get_lang dictionary_id='64378.Komut'></th>
			<th><cf_get_lang dictionary_id='64377.Etkilenen Alan'></th>
			<th><cf_get_lang dictionary_id='58466.Değiştirme Tarihi'></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_db_row">
			<cfif not KOMUT is 'COULUMN MODIFY'>
                <tr>
                    <td>#kontrol_sayi#</td>
                    <td>#HOSTNAME#</td>
                    <td><cfif len(KOMUT)>#KOMUT#<cfelse>COLUMN MODIFY</cfif></td>
                    <td>
                        <cfif COMMANDTEXT contains 'ALTER' and COMMANDTEXT contains 'ADD' AND NOT COMMANDTEXT contains 'CONSTRAINT'>
                            #replace(listGetAt(COMMANDTEXT,4,' '),'ADD','')#
                        <cfelseif COMMANDTEXT contains 'ALTER' and COMMANDTEXT contains 'DROP'>
                            #replace(listGetAt(COMMANDTEXT,5,' '),'UPDATE','')#
                        <cfelse>
                            #OBJECTNAME#
                        </cfif>
                    </td>
                    <td>#dateformat(dateadd('h',session.ep.time_zone,TIME),'DD/MM/YYYY')# #Timeformat(dateadd('h',session.ep.time_zone,TIME),'HH:MM')#</td>
                </tr>
                <cfset kontrol_sayi = kontrol_sayi+1>
            </cfif>
		</cfoutput>
	</tbody>
</cf_grid_list>

