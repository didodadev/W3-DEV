<footer class="footermenus">
		<script type="text/javascript">
        $( document ).ready(function() { // Sağ panelde açılan XML için xml_page_edit custom tag'inden değer alır.
            <cfif isdefined('xmlPageParams') and len(xmlPageParams)>
                $("li[xmlInfo]").css('display','block');
            <cfelse>
                $("li[xmlInfo]").css('display','none');
            </cfif>
        });
        $(document).keydown(function (e) {
            if (e.keyCode == 8) {
                if ((e.target.nodeName.toLowerCase() == 'input' || e.target.nodeName.toLowerCase() == 'textarea') && $(e.target).attr("readonly")) {
                    e.preventDefault();
                }
            }
        });
        wrk_message_temp_title = document.title;
            function pm_kontrol()
            {
                AjaxPageLoad('index.cfm?fuseaction=objects2.emptypopup_pm_kontrol', 'pm_varmi', 0, '','','',1);
                pmKontrolTetikle = setTimeout("pm_kontrol()", 10000);
            }
        //pm_kontrol();  Websockete geçildiğinden devre sışı bırakıldı Semih Altınışık 04/07/2017
    </script>
	<div id="speed_basket_working" align="center" class="working_div" style="display:none;"></div>
</footer>

<!---

 <cfif not workcube_mode>[<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_session','list','popup_session');return false;">Variables</a>]</cfif>
						<cfif session.ep.admin>
                            <cfset strVersion = SERVER.ColdFusion.ProductVersion />
                            <cfif listfirst(strVersion) gte 10>
                                <cfset servername = createobject("component","CFIDE.adminapi.runtime").getinstancename()>
                            <cfelse>
                                 <cfobject action="create" type="java" class="jrunx.kernel.JRun" name="jr">
                                 <cfset servername = jr.getServerName()>
                            </cfif>
                            <cfoutput>#servername#</cfoutput>
                        </cfif>


--->
