 <cfoutput>
    <div class="pagemenus_container">
        <div style="float:left; width:200px;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang dictionary_id ='55192.Ücret Bilgileri'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_ozel_bordro')><li><a href="#request.self#?fuseaction=ehesap.list_dynamic_bordro"> <cf_get_lang dictionary_id='56300.Dinamik Bordro'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_salary') ><li><a href="#request.self#?fuseaction=hr.list_salary"> <cf_get_lang dictionary_id ='56118.Ücret Ödenek'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_payment_requests')><li><a href="#request.self#?fuseaction=hr.list_payment_requests"><cf_get_lang dictionary_id ='56119.Avans Talepleri'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_payments')><li><a href="#request.self#?fuseaction=hr.list_payments"> <cf_get_lang dictionary_id ='56025.Ödenekler'></a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>
        <div style="float:left; width:200px;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang dictionary_id ='56586.İzin - Mesai'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_offtimes')><li><a href="#request.self#?fuseaction=hr.list_offtimes"><cf_get_lang dictionary_id ='55143.İzinler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_ext_worktimes') ><li><a href="#request.self#?fuseaction=hr.list_ext_worktimes"><cf_get_lang dictionary_id ='56018.Fazla Mesailer'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_interruption')><li><a href="#request.self#?fuseaction=hr.list_interruption"><cf_get_lang dictionary_id ='56023.Kesintiler'></a></li></cfif>
                    </ul>
                </li>     
            </ul>
        </div>  
        <div style="float:left; width:200px;">
            <ul class="pagemenus">
                <li><strong><cf_get_lang dictionary_id ='58576.Vizite'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_visited')><li><a href="#request.self#?fuseaction=hr.list_visited"><cf_get_lang dictionary_id ='56026.Çalışan Viziteler'> </a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_visited_relative') ><li><a href="#request.self#?fuseaction=hr.list_visited_relative"> <cf_get_lang dictionary_id ='56244.Çalışan Yakını Viziteler'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_emp_rel_healty')><li><a href="#request.self#?fuseaction=hr.list_emp_rel_healty"><cf_get_lang dictionary_id ='55151.Saglık Belgesi'> </a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>      
        <div style="float:left; width:200px;">       
            <ul class="pagemenus">      
                <li><strong><cf_get_lang dictionary_id ='58584.İcmal'></strong>
                    <ul>
                        <cfif not listfindnocase(denied_pages,'hr.list_icmal_personal')><li><a href="#request.self#?fuseaction=hr.list_icmal_personal"><cf_get_lang dictionary_id ='56121.Kişi İcmal'></a></li></cfif>
                        <cfif not listfindnocase(denied_pages,'hr.list_icmal') ><li><a href="#request.self#?fuseaction=hr.list_icmal"><cf_get_lang dictionary_id ='58584.İcmal'></a></li></cfif>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</cfoutput>
<script src="../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
