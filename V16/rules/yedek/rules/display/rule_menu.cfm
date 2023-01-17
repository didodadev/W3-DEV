

<div class="w3-menu">
    <div class="col-xl-10 offset-xl-1">
        <ul class="col-12 d-flex justify-content-center">
            <li class="navLite">
                <a class="" href="?fuseaction=rule.welcome">LİTERATÜR</a>   
                <div class="menuDropdown">
                    <div class="container-fluid">
                        <div class="row">
                        <cfinclude template="list_cat_chapter_home.cfm">
                            
                         <cfoutput query="get_lit_names"> 
                            <ul class="col-3">
                                <h4 class="">#contentcat#</h4>
                               
                                   
                                    <cfquery name="get_chapter_" dbtype="query">
                                        SELECT HIERARCHY,CHAPTER,CHAPTER_ID,CONTENTCAT_ID FROM GET_CHAPTER WHERE CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_lit_names.contentcat_id#"> ORDER BY HIERARCHY
					                </cfquery>
                                   
                                    
                                    <cfloop query="get_chapter_">
                                        <li>
                                            <a href="#request.self#?fuseaction=#f_chapter#&chapter_id=#chapter_id#&contentcat_id=#contentcat_id#">
                                            <i class="wrk-keyboard-right-arrow text-intr-orange"></i>
                                            #chapter#</a>
                                        </li>
                                    </cfloop>	
                                    
                               
                             
                            </ul>
                        
                            </cfoutput>
                        </div>
                    </div>
                </div> 
            </li>
            <li class="navFor">
                <a class="" href="?fuseaction=forum.list_forum">FORUM</a>
            </li> 
            <li class="navDij">
                <a class="" href="?fuseaction=asset.list_asset">DİJİTAL ARŞİV</a>
            </li>
            <li class="navEgi">
                <a class="" href="?fuseaction=training.list_class_announce">EĞİTİM</a>
            </li>
            <li class="navKim">
                <a class="" href="?fuseaction=rule.list_hr">KİM KİMDİR?</a>
            </li> 
            <li class="navSos">
                <a class="" href="?fuseaction=worknet.list_social_media">SOSYAL</a>
            </li>
            <li class="navDig">
                <a class="" href="?fuseaction=myhome.other_hr">DİĞER</a>
            </li>
        </ul>		
    </div>
    <hr class="mt-0">
</div>
