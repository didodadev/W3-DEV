<cfquery name="GET_CHAPTER" datasource="#DSN#">
	SELECT 
        CC.CHAPTER_ID,
        CC.CONTENTCAT_ID,
        COALESCE(CSLI.ITEM,CC.CHAPTER) AS CHAPTER,
        HIERARCHY,
        C.CONTENT_ID,
        C.CONT_HEAD
    FROM 
        CONTENT C 
        JOIN CONTENT_CHAPTER AS CC ON C.CHAPTER_ID = CC.CHAPTER_ID
        LEFT JOIN CONTENT_CAT AS CT ON CC.CONTENTCAT_ID = CT.CONTENTCAT_ID
        LEFT JOIN #dsn#.SETUP_LANGUAGE_INFO CSLI 
                ON CSLI.UNIQUE_COLUMN_ID = CC.CHAPTER_ID 
                AND CSLI.COLUMN_NAME ='CHAPTER'
                AND CSLI.TABLE_NAME = 'CONTENT_CHAPTER'
                AND CSLI.LANGUAGE = '#session_base.language#'
    WHERE 
        CC.CONTENTCAT_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.category_id#" list="yes">) AND
        C.LANGUAGE_ID = '#session_base.language#' AND
        C.PROCESS_STAGE = 157 AND
        INTERNET_VIEW = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
    ORDER BY CC.HIERARCHY,C.CONT_HEAD
</cfquery>
<head>
    <link href='https://unpkg.com/boxicons@2.0.7/css/boxicons.min.css' rel='stylesheet'>
</head>
<style>
    .sidebar_menu::-webkit-scrollbar {width: 10px;}
    .sidebar_menu::-webkit-scrollbar-track {background: #f1f1f1;}
    .sidebar_menu::-webkit-scrollbar-thumb {background: #ff980094;}
    .sidebar_menu::-webkit-scrollbar-thumb:hover {background: #FF9800; }
</style>
    <div class="sidebar open">
        <div class="logo-details">
            <div class="logo_name"><cf_get_lang dictionary_id='57697.Kütüphane'></div>
            <i class='bx bx-menu' id="btn"></i>
        </div>
        <ul class="menu sidebar_menu">
            <cfset new_chapter = "">
            <cfoutput query="GET_CHAPTER">
                <cfif new_chapter neq chapter_id>
                    <li class="list">
                        <a href="##" class="links_name">#CHAPTER#</a>
                        <ul class="items">
                            <cfset new_chapter = chapter_id>
                </cfif>
                        <li id="#content_id#">
                            <a href="#site_language_path#/detail/#CONTENT_ID#" class="links_name">#CONT_HEAD#</a>
                            <span class="tooltip">#CONT_HEAD#</span>
                        </li>
                <cfif chapter_id[currentrow+1] neq chapter_id>
                        </ul>
                    </li>
                </cfif>
            </cfoutput>
        </ul>
    </div>

<script>
    const list = document.querySelectorAll('.list');
    function accordion(e){
        e.stopPropagation(); 
        if(this.classList.contains('active')){
            this.classList.remove('active');
        }
        else if(this.parentElement.parentElement.classList.contains('active')){
            this.classList.add('active');
        }
        else{
            for(i=0; i < list.length; i++){
            list[i].classList.remove('active');
            }
                this.classList.add('active');
            }
    }
    for(i = 0; i < list.length; i++ ){
        list[i].addEventListener('click', accordion);
    }


    let sidebar = document.querySelector(".sidebar");
    let closeBtn = document.querySelector("#btn");

    closeBtn.addEventListener("click", ()=>{
        sidebar.classList.toggle("open");
        menuBtnChange();
    });

    function menuBtnChange() {
        if(sidebar.classList.contains("open")){
            closeBtn.classList.replace("bx-menu", "bx-menu");
        }else {
            closeBtn.classList.replace("bx-menu","bx-menu");
        }
    }

    <cfif isDefined("url.param_2") and len(url.param_2)>
        $('.sidebar ul.menu li.list').each(function(){
            var self = $(this);
            self.find('ul.items li').each(function(){
                if ($(this).attr('id') == <cfoutput>#url.param_2#</cfoutput>) {
                    self.addClass('active');
                    $(this).addClass('active');
                }
            });
        });
    </cfif>

    if($(window).width()>992){$(document.querySelectorAll('.sidebar')).addClass("open"); }  else {$(document.querySelectorAll('.sidebar')).removeClass("open"); }
</script>
