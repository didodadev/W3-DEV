<cfoutput>
	<div class="menus2">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr> 
            	<td>
                	<table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                        <cfif not listfindnocase(denied_pages,'dev.list_wbo')>
                            <td><a href="#request.self#?fuseaction=dev.list_wbo" class="menus2_head"><cf_get_lang no='1.workdev'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'dev.list_bugs')>
                            <td><a href="#request.self#?fuseaction=dev.list_wbo" class="menus2_title"><cf_get_lang no="3.WBO"></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'dev.list_table')>
                            <td><a href="#request.self#?fuseaction=dev.list_table" class="menus2_title">Tablolar</a></td>
                        </cfif>
                        <cfif application.host.hostName contains('WRK') or session.ep.admin eq 1>
                            <cfif not listfindnocase(denied_pages,'dev.code_search')>
                               <td><a href="#request.self#?fuseaction=dev.code_search" class="menus2_title">Kod Arama</a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'dev.list_file_change')>
                                <td><a href="#request.self#?fuseaction=dev.list_file_change" class="menus2_title">Dosya Değişimleri</a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'dev.list_db_change')>
                               <td> <a href="#request.self#?fuseaction=dev.list_db_change" class="menus2_title">DB Değişimleri</a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'dev.language_search')>
                                <td><a href="#request.self#?fuseaction=dev.language_search" class="menus2_title">Dil Seti</a></td>
                            </cfif>
							<cfif not listfindnocase(denied_pages,'dev.list_repaet_column')>
                                <td><a href="#request.self#?fuseaction=dev.list_repaet_column" class="menus2_title">Kolon Tekrar</a></td>
                            </cfif>
                        </cfif>
                        </tr>
                    </table>
                 </td>
                <td style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
            </tr>
        </table>
    </div>
</cfoutput>
