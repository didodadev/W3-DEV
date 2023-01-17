<section id="protein_blog_app">
    <div id="list_chapter">  
        <div class="category">
            <ul class="flex-wrap flex-sm-nowrap">
                <cfif isDefined("attributes.tab1_name") and len(attributes.tab1_name)>
                    <li :class="(tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput> && !tab_all)?'active':''" @click="showTab('1')">
                        <a href="javascript://"><cf_get_lang dictionary_id='#attributes.tab1_name#'></a>
                    </li>
                </cfif>
                <cfif isDefined("attributes.tab2_name") and len(attributes.tab2_name)>
                    <li :class="(tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput> && !tab_all)?'active':''" @click="showTab('2')">
                        <a href="javascript://"><cf_get_lang dictionary_id='#attributes.tab2_name#'></a>
                    </li>
                </cfif>
                <cfif isDefined("attributes.tab3_name") and len(attributes.tab3_name)>
                    <li :class="(tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput> && !tab_all)?'active':''" @click="showTab('3')">
                        <a href="javascript://"><cf_get_lang dictionary_id='#attributes.tab3_name#'></a>
                    </li>
                </cfif>
                <cfif isDefined("attributes.tab4_name") and len(attributes.tab4_name)>
                    <li :class="(tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput> && !tab_all)?'active':''" @click="showTab('4')">
                        <a href="javascript://"><cf_get_lang dictionary_id='#attributes.tab4_name#'></a>
                    </li>
                </cfif>
                <cfif isDefined("attributes.tab5_name") and len(attributes.tab5_name)>
                    <li :class="(tab_all)?'active':''" @click="showTab('all')">
                        <a href="javascript://" id="all"><cf_get_lang dictionary_id='#attributes.tab5_name#'></a>
                    </li>
                </cfif>
            </ul>
            <!--- <input type="text" id="quicksearch" placeholder="ARA" />  --->
        </div>
        <div class="list_chapter-type2 row">            
            <div class="list_chapter_item_isotope col-md-6 col-lg-4" v-for="item in blog_data" v-if="eval('tab_'+item.CHAPTER_ID)">
                <div style="background-color:rgba(10,187,135,.1);" class="list_chapter_item-type2">
                    <div class="list_chapter_item-type2_img" :style="'background-image:url(/documents/content/'+item.CONTIMAGE_SMALL+')'"></div>           
                    <div class="list_chapter_item-type2_text">
                        <div class="list_chapter_item-type2_title">
                            {{item.CONT_HEAD}}
                        </div>
                        <p>{{item.CONT_SUMMARY | summary}}...</p>
                        <cfif isDefined("attributes.content_detail_btn") and attributes.content_detail_btn eq 1>
                            <div class="list_chapter_item-type2_btn">
                                <a :href="'<cfoutput>#site_language_path#</cfoutput>/'+item.USER_FRIENDLY_URL"><cf_get_lang dictionary_id='47032.More'></a>
                            </div>
                        </cfif>
                    </div>
                </div>
            </div>                             
        </div>
    </div>
    <div class="d-flex font-weight-bold justify-content-center p-1 table-info" v-if="load_status"><i class="fa-spin fa-spinner fas" style="font-size: 24px;"></i></div>  
    <div class="cursor-pointer d-flex font-weight-bold justify-content-center p-1 table-primary bg-light" @click="loadScroll" v-if="load_more && !load_status"><cf_get_lang dictionary_id='48384.Show more'></div>  
    <div class="d-flex font-weight-bold justify-content-center p-1 bg-light" v-if="!load_more"><cf_get_lang dictionary_id='43288.Page End'></div>    
</div>
<script type="text/javascript">
    
	var protein_blog_app = new Vue({
        el: '#protein_blog_app',
        data: {
			action_url : '/datagate',
            data_packet : {
                action : "",
                cfc : "/V16/objects2/content/cfc/content",
                form_data : {
                    PROTEIN_SITE: "<cfoutput>#GET_PAGE.PROTEIN_SITE#</cfoutput>",
                    list_start_date:"<cfoutput>#attributes.list_start_date#</cfoutput>",
                    list_finish_date:"<cfoutput>#attributes.list_finish_date#</cfoutput>",
                    tab1_name:"<cfoutput>#attributes.tab1_name#</cfoutput>",
                    tab1_chap_id:"<cfoutput>#attributes.tab1_chap_id#</cfoutput>",
                    tab2_name:"<cfoutput>#attributes.tab2_name#</cfoutput>",
                    tab2_chap_id:"<cfoutput>#attributes.tab2_chap_id#</cfoutput>",
                    tab3_name:"<cfoutput>#attributes.tab3_name#</cfoutput>",
                    tab3_chap_id:"<cfoutput>#attributes.tab3_chap_id#</cfoutput>",
                    tab4_name:"<cfoutput>#attributes.tab4_name#</cfoutput>",
                    tab4_chap_id:"<cfoutput>#attributes.tab4_chap_id#</cfoutput>",
                    tab5_name:"<cfoutput>#attributes.tab5_name#</cfoutput>",
                    tab5_chap_id:"<cfoutput>#attributes.tab5_chap_id#</cfoutput>",
                    page:1,
                    is_content_main_sort:"<cfoutput>#attributes.is_content_main_sort#</cfoutput>"
                },
                method : "GET_BLOG_CONTENT"
            },
            blog_data:[],
            load_more:true,
            load_status:true,
            tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput>:true,
            tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput>:true,
            tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput>:true,
            tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput>:true,
            tab_all:true,
			error : []
        },   
        methods: {
            randomNumber : function(){
              return (Math.floor(Math.random() * 10000) + 10000).toString().substring(1);
            },
            getBlogData : function(){
                const _this = this;
                
                if(_this.load_more){
                    _this.load_status = true;
                    axios.post(_this.action_url,_this.data_packet).then(
                        response => {
                            _this.data_packet.form_data.page=response.data.NEXT_PAGE;
                            _this.load_more=(response.data.COUNT != 0)?true:false;

                            const _blog_data = _this.blog_data;

                            const _new_blog_data = _blog_data.concat(response.data.DATA);

                            console.log (_new_blog_data);

                            Vue.set(_this.$data, 'blog_data', _new_blog_data);

                            setTimeout(function(){                                   
                                var myColors = [
                                "#bae9d4", "#e0f2f1", "#ffe899", "#fce4ec","#e8f5e9", "#f3e5f5", "#f1f8e9", "#e8eaf6", "#fff3e0", "#e1f5fe", "#fbe9e7"
                                ];
                                var i = 0;
                                $('.list_chapter_item-type2').each(function() {
                                    $(this).css('background-color', myColors[i]);
                                    i = (i + 1) % myColors.length;
                                });
                                _this.load_status = false; 
                                $grid = $('.list_chapter-type2 ').masonry('reloadItems');  
                                $grid = $('.list_chapter-type2 ').masonry('layout'); 
                            },400)
                            
                        }                
                    )
                    .catch( 
                        e => { _this.error.push({ecode: 801, message:"GET_BLOG_CONTENT"}) 
                    })
                }
            },
            loadScroll : function() {
                const _this = this;
				if(_this.load_more){_this.getBlogData()}
			},
            showTab : function(id) {
                const _this = this;               

                if(id == 'all'){
                    _this.tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput>=true;
                    _this.tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput>=true;
                    _this.tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput>=true;
                    _this.tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput>=true;
                    _this.tab_all=true;
                }

                if(id == '1'){
                    _this.tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput>=true;
                    _this.tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput>=false;
                    _this.tab_all=false;
                }

                if(id == '2'){
                    _this.tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput>=true;
                    _this.tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput>=false;
                    _this.tab_all=false;
                }

                if(id == '3'){
                    _this.tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput>=true;
                    _this.tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput>=false;
                    _this.tab_all=false;
                }

                if(id == '4'){
                    _this.tab_<cfoutput>#attributes.tab1_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab2_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab3_chap_id#</cfoutput>=false;
                    _this.tab_<cfoutput>#attributes.tab4_chap_id#</cfoutput>=true;
                    _this.tab_all=false;
                }
                setTimeout(function(){
                    $grid = $('.list_chapter-type2 ').masonry('reloadItems');  
                    $grid = $('.list_chapter-type2 ').masonry('layout'); 
                    
                },400);
               
			}
        },
        filters: {
            summary: function (value) {              
              return value.substring(0,400);
            }          
        },
        mounted () {
            const _this = this;            
            _this.getBlogData()    
            setTimeout(function(){  
                $grid = $('.list_chapter-type2 ').masonry({itemSelector: '.list_chapter_item_isotope'});         
            },400)  
		}
    });
    
</script>

