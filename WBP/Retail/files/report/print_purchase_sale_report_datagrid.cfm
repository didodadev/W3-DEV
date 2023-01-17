<cfset new_basket = DeserializeJSON(attributes.print_note)>

<cfsavecontent variable="print_icerik">  
<style>
	table{font-size:10px;};
	table tr{font-size:10px;};
	table tr td{font-size:10px;};
</style>
<table cellpadding="2" cellspacing="0" border="1" width="99%">
    <tr>
        <cfloop from="1" to="#listlen(name_list)#" index="aa">
        	<cfset tname_ = listgetat(attributes.turkce_name_list,aa)>
            <cfset name_ = listgetat(attributes.name_list,aa)>
            <cfif not listfind(attributes.non_show_list,name_)><td><cfoutput>#tname_#</cfoutput></td></cfif>
        </cfloop>
    </tr>
    <cfloop from="1" to="#arraylen(new_basket)#" index="ccc">
	<cfoutput>
    <tr>
        <cfloop from="1" to="#listlen(name_list)#" index="aa">
        	<cfset tname_ = listgetat(attributes.turkce_name_list,aa)>
            <cfset name_ = listgetat(attributes.name_list,aa)>
            <cfif not listfind(attributes.non_show_list,name_)>
            	<td style='mso-number-format:"\@"'>
                	<cfset deger_ = evaluate("new_basket[#ccc#].#name_#")>
                    #deger_#
               	</td>
            </cfif>
        </cfloop>
    </tr>
    </cfoutput>
    </cfloop>
</table>
</cfsavecontent>

<!--- kirli dosya oluşmasın diye --->
<cfif isdefined("session.ep.userid")>
	<cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')##session.ep.userid#">
<cfelse>
	<cfset filename = "#fusebox.fuseaction#_#dateformat(now(),'ddmmyyyy')##timeformat(now(),'HHMML')#">
</cfif>	
<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfif not directoryexists("#upload_folder#reserve_files#dir_seperator##drc_name_#")>
	<cfdirectory action="create" directory="#upload_folder#reserve_files#dir_seperator##drc_name_#">
</cfif>
<cfdirectory action="list" name="get_ds" directory="#upload_folder#reserve_files">
<cfif get_ds.recordcount>
	<cfoutput query="get_ds">
		<cfif type is 'dir' and name is not drc_name_>
			<cftry>
				<cfset d_name_ = name>
				<cfdirectory action="list" name="get_ds_ic" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
					<cfif get_ds_ic.recordcount>
						<cfloop query="get_ds_ic">
							<cffile action="delete" file="#upload_folder#reserve_files#dir_seperator##d_name_##dir_seperator##get_ds_ic.name#">
						</cfloop>
					</cfif>
				<cfdirectory action="delete" directory="#upload_folder#reserve_files#dir_seperator##d_name_#">
			<cfcatch></cfcatch>
			</cftry>
		</cfif>
	</cfoutput>
</cfif>
<!--- kirli dosya oluşmasın diye --->
<cffile action="write" file="#upload_folder#reserve_files#dir_seperator##drc_name_##dir_seperator##filename#.xls" output="#print_icerik#" charset="utf-16"/>

<script type="text/javascript">
	get_wrk_message_div("<cf_get_lang_main no='1931.Dosya İndir'>","<cf_get_lang_main no='1934.Excel'>","<cfoutput>/documents/reserve_files/#drc_name_#/#filename#.xls</cfoutput>");
</script>